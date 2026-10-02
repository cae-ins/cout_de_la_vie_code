# ==============================================================================
# Pondération ECV — table de série consolidée (février 2025 à juillet 2026)
#   Rscript 06_serie.R
# Prérequis : run_all.R, puis 04_variations.R pour chaque paire de mois
#             consécutifs de config.R.
# Sorties   : Resultat/Serie/serie_soldes.csv et serie_soldes.xlsx
#
# Une ligne par mois x méthode x solde x domaine x modalité :
#   - solde, erreur type, IC 95 %, nombre de répondants (réponse renseignée) ;
#   - solde publié et solde pondvf recalculé (national, méthode CE) ;
#   - drapeaux comparable, traitement_degrade ;
#   - variation depuis le mois précédent de la série, SE avec covariance
#     (svyDelta), z, verdict, et drapeaux apres_interruption et
#     variation_comparable.
# ==============================================================================

local({
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  dir <- if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else getwd()
  setwd(dir)
})
source("config.R", encoding = "UTF-8")
source("R/fonctions_ponderation.R", encoding = "UTF-8")
source("R/variations.R", encoding = "UTF-8")
source("R/bulletin.R", encoding = "UTF-8")   # verdict() et THEMES (lecture seule)
dir.create(DIR_SERIE, showWarnings = FALSE, recursive = TRUE)
ids <- names(MOIS)

# ------------------------------------------------------------------------------
# Soldes de chaque mois
# ------------------------------------------------------------------------------
bilan <- read.csv(file.path(DIR_SERIE, "bilan_mois.csv"), fileEncoding = "UTF-8")
soldes <- bind_rows(lapply(ids, function(id) {
  s <- read.csv(chemin_mois(id, paste0("soldes_", id, ".csv")), fileEncoding = "UTF-8")
  n <- soldes_mois(ajouter_variables_ratio(charger_plan_cale(id))) %>%
    mutate(domaine = recode(domaine, ensemble = "Ensemble")) %>%
    select(methode, variable, domaine, modalite, n_repondants)
  ctl <- read.csv(chemin_mois(id, paste0("controle_publie_", id, ".csv")), fileEncoding = "UTF-8") %>%
    transmute(variable, methode = "ce", domaine = "Ensemble", modalite = "Ensemble",
              solde_publie = publie, solde_pondvf_fichier = pondvf_recalcule,
              solde_pondvf_replique = pondvf_replique)
  s %>% mutate(mois = id) %>%
    left_join(n, by = c("methode", "variable", "domaine", "modalite")) %>%
    left_join(ctl, by = c("variable", "methode", "domaine", "modalite"))
}))

soldes <- soldes %>%
  left_join(bilan %>% select(mois, calage, traitement_degrade, degradations), by = "mois") %>%
  mutate(libelle = unname(VARIABLES_OPINION[variable]),
         # pondvf recalculé : celui du fichier s'il existe, sinon la réplique de Do_ponderation.do
         solde_pondvf_recalcule = coalesce(solde_pondvf_fichier, solde_pondvf_replique),
         source_pondvf = case_when(!is.na(solde_pondvf_fichier) ~ "pondvf du fichier",
                                   !is.na(solde_pondvf_replique) ~ "pondvf reconstitué (réplique Do_ponderation.do)",
                                   TRUE ~ NA_character_),
         ecart_pondvf_publie = solde_pondvf_recalcule - solde_publie,
         controle_publie_ok = abs(ecart_pondvf_publie) <= 0.005 + 1e-9,
         periode_reference_mois = ifelse(mapply(function(m, v) v %in% PERIODE_REFERENCE_NON_STANDARD[[m]], mois, variable),
                                         "4 mois (non standard)", NA_character_),
         comparable = is.na(periode_reference_mois))

# ------------------------------------------------------------------------------
# Variations entre mois consécutifs de la série
# ------------------------------------------------------------------------------
apres_interruption <- function(id1, id2) id1 < INTERRUPTION[["debut"]] & id2 > INTERRUPTION[["fin"]]
types <- setNames(THEMES$type, THEMES$variable)

variations <- bind_rows(lapply(seq_len(length(ids) - 1), function(k) {
  id1 <- ids[k]; id2 <- ids[k + 1]
  f <- file.path(DIR_VARIATIONS, paste0("variations_", id1, "_", id2, ".csv"))
  if (!file.exists(f)) { warning("Variations absentes : ", f); return(NULL) }
  v <- read.csv(f, fileEncoding = "UTF-8")
  keep <- intersect(c("mois_1", "mois_2", "methode", "variable", "domaine", "modalite", "variation",
                      "se_independance", "se_covariance", "rho", "z_covariance", "p_valeur",
                      "se_covariance_main", "z_covariance_main", "se_delta_boot", "z_bootstrap",
                      "n_psu_communs", "recouvrement_psu"), names(v))
  v[, keep] %>% mutate(mois_1 = as.character(mois_1), mois_2 = as.character(mois_2))
}))
variations <- variations %>%
  mutate(apres_interruption = apres_interruption(mois_1, mois_2),
         non_std_1 = mapply(function(m, x) x %in% PERIODE_REFERENCE_NON_STANDARD[[m]], mois_1, variable),
         non_std_2 = mapply(function(m, x) x %in% PERIODE_REFERENCE_NON_STANDARD[[m]], mois_2, variable),
         variation_comparable = !non_std_1 & !non_std_2,
         ic95_variation_bas = variation - qnorm(0.975) * se_covariance,
         ic95_variation_haut = variation + qnorm(0.975) * se_covariance)
vd <- verdict(variations$z_covariance, types[variations$variable])
variations <- variations %>%
  mutate(verdict_niveau = vd$niveau, verdict = vd$qualif,
         verdict = case_when(!variation_comparable ~ "non comparable (période de référence de 4 mois)",
                             apres_interruption ~ "pas de verdict (paire non consécutive : interruption déc. 2025 - avr. 2026)",
                             TRUE ~ verdict),
         verdict_niveau = ifelse(!variation_comparable | apres_interruption, NA, verdict_niveau),
         significatif_95 = ifelse(!variation_comparable | apres_interruption, NA, abs(z_covariance) >= qnorm(0.975))) %>%
  select(-non_std_1, -non_std_2) %>%
  # Variation impliquant au moins un mois à traitement dégradé
  mutate(variation_traitement_degrade = bilan$traitement_degrade[match(mois_1, bilan$mois)] |
                                        bilan$traitement_degrade[match(mois_2, bilan$mois)])

serie <- soldes %>%
  left_join(variations %>% rename(mois = mois_2, mois_precedent = mois_1),
            by = c("mois", "methode", "variable", "domaine", "modalite")) %>%
  transmute(mois, mois_precedent, methode, variable, libelle, domaine, modalite,
            solde, erreur_type, ic95_bas = ic_bas, ic95_haut = ic_haut, n_repondants,
            solde_publie, solde_pondvf_recalcule, source_pondvf, ecart_pondvf_publie, controle_publie_ok,
            comparable, periode_reference_mois, traitement_degrade, calage, degradations,
            apres_interruption, variation_comparable, variation_traitement_degrade,
            variation, se_variation_covariance = se_covariance,
            se_variation_independance = se_independance, rho, z = z_covariance, p_valeur,
            ic95_variation_bas, ic95_variation_haut, verdict, verdict_niveau, significatif_95,
            se_variation_main = se_covariance_main, z_main = z_covariance_main,
            se_variation_bootstrap = se_delta_boot, z_bootstrap, n_grappes_communes = n_psu_communs) %>%
  arrange(mois, methode, match(variable, names(VARIABLES_OPINION)), domaine, modalite)

# Mois publiés mais introuvables : une ligne par solde, sans estimation
manquants <- expand.grid(mois = MOIS_INTROUVABLES, variable = names(VARIABLES_OPINION), stringsAsFactors = FALSE) %>%
  mutate(methode = "ce", libelle = unname(VARIABLES_OPINION[variable]), domaine = "Ensemble", modalite = "Ensemble",
         solde_publie = mapply(function(m, v) PUBLIE[[m]][[v]], mois, variable),
         comparable = !mapply(function(m, v) v %in% PERIODE_REFERENCE_NON_STANDARD[[m]], mois, variable),
         periode_reference_mois = ifelse(comparable, NA, "4 mois (non standard)"),
         traitement_degrade = NA, degradations = "fichier complet introuvable : mois non recalculé")
serie <- bind_rows(serie, manquants) %>% arrange(mois, methode, match(variable, names(VARIABLES_OPINION)), domaine, modalite)

write.csv(serie, file.path(DIR_SERIE, "serie_soldes.csv"), row.names = FALSE, fileEncoding = "UTF-8", na = "")

# ------------------------------------------------------------------------------
# Vues de synthèse
# ------------------------------------------------------------------------------
nat <- serie %>% filter(methode == "ce", domaine == "Ensemble")
large <- function(col) nat %>% select(variable, libelle, mois, all_of(col)) %>%
  tidyr::pivot_wider(names_from = mois, values_from = all_of(col)) %>%
  arrange(match(variable, names(VARIABLES_OPINION)))
vue_nationale <- bind_rows(
  large("solde") %>% mutate(serie = "nouveau (calage ReGenesees)", .before = 1),
  large("erreur_type") %>% mutate(serie = "erreur type", .before = 1),
  large("solde_publie") %>% mutate(serie = "publié (bulletin juillet 2026)", .before = 1),
  large("solde_pondvf_recalcule") %>% mutate(serie = "pondvf recalculé", .before = 1)
)
variations_nat <- nat %>% filter(!is.na(variation)) %>%
  select(mois_precedent, mois, variable, libelle, solde, variation, se_variation_covariance, z, verdict,
         significatif_95, variation_comparable, apres_interruption, variation_traitement_degrade, z_bootstrap)
controle <- nat %>% filter(!is.na(solde_publie)) %>%
  select(mois, variable, solde_publie, solde_pondvf_recalcule, source_pondvf, ecart_pondvf_publie, controle_publie_ok, solde)

# Effet de la règle de regroupement commune sur juin et juillet 2026
avant_dir <- file.path(DIR_RESULTATS, "Archives", "avant_serie_complete")
effet <- NULL; effet_poids <- NULL; effet_var <- NULL
if (dir.exists(avant_dir)) {
  effet <- bind_rows(lapply(c("2026-06", "2026-07"), function(id) {
    a <- read.csv(file.path(avant_dir, id, paste0("soldes_", id, ".csv")), fileEncoding = "UTF-8")
    b <- read.csv(chemin_mois(id, paste0("soldes_", id, ".csv")), fileEncoding = "UTF-8")
    inner_join(a, b, by = c("mois", "methode", "variable", "domaine", "modalite"), suffix = c("_avant", "_apres")) %>%
      transmute(mois, methode, variable, domaine, modalite, solde_avant, solde_apres,
                ecart_solde = solde_apres - solde_avant, erreur_type_avant, erreur_type_apres,
                ecart_en_erreurs_types = ecart_solde / erreur_type_avant)
  }))
  effet_poids <- bind_rows(lapply(c("2026-06", "2026-07"), function(id) {
    a <- read.csv(file.path(avant_dir, id, paste0("poids_", id, ".csv")), fileEncoding = "UTF-8")
    b <- read.csv(chemin_mois(id, paste0("poids_", id, ".csv")), fileEncoding = "UTF-8")
    m <- inner_join(a %>% filter(repondant) %>% select(hhid, w_avant = w_cal),
                    b %>% filter(repondant) %>% select(hhid, w_apres = w_cal), by = "hhid")
    r <- m$w_apres / m$w_avant
    tibble(mois = id, n = nrow(m), rapport_min = min(r), rapport_q05 = quantile(r, 0.05), rapport_median = median(r),
           rapport_q95 = quantile(r, 0.95), rapport_max = max(r), part_inchanges_1e6 = mean(abs(r - 1) < 1e-6),
           kish_avant = 1 + (sd(m$w_avant) / mean(m$w_avant))^2, kish_apres = 1 + (sd(m$w_apres) / mean(m$w_apres))^2)
  }))
  fa <- file.path(avant_dir, "variations", "variations_2026-06_2026-07.csv")
  fb <- file.path(DIR_VARIATIONS, "variations_2026-06_2026-07.csv")
  if (file.exists(fa) && file.exists(fb)) {
    effet_var <- inner_join(read.csv(fa, fileEncoding = "UTF-8"), read.csv(fb, fileEncoding = "UTF-8"),
                            by = c("methode", "variable", "domaine", "modalite"), suffix = c("_avant", "_apres")) %>%
      filter(domaine == "Ensemble") %>%
      transmute(methode, variable, variation_avant, variation_apres, se_covariance_avant, se_covariance_apres,
                z_avant = z_covariance_avant, z_apres = z_covariance_apres)
  }
}
reg_avant <- tryCatch(read.xlsx(file.path(avant_dir, "2026-07", "diagnostics_2026-07.xlsx"), sheet = "regroupements"), error = function(e) NULL)
reg_apres <- read.csv(file.path(DIR_SERIE, "regroupements.csv"), fileEncoding = "UTF-8")
effet_regroupement <- if (is.null(reg_avant)) NULL else
  full_join(reg_avant %>% select(region_act, milieu_act, cellule_avant = cellule_zone, fragile_avant = region_fragile,
                                 mediane_region_avant = mediane_region),
            reg_apres %>% select(region_act, milieu_act, cellule_apres = cellule_zone, fragile_apres = region_fragile,
                                 mediane_region_apres = mediane_region),
            by = c("region_act", "milieu_act"))

notes <- data.frame(note = c(
  "Une ligne par mois x méthode (ce = +1/+0,5/0/-0,5/-1 ; insee = +1/+1/0/-1/-1) x solde x domaine x modalité. « Ne sait pas » exclu.",
  "solde, erreur_type, ic95 : plan calé ReGenesees (ids = ~grappe, strata = ~strate), svystatTM.",
  "n_repondants : répondants dont la réponse à la question est renseignée.",
  "solde_publie : bulletin de juillet 2026, tableau 2 (national, méthode CE).",
  "solde_pondvf_recalcule : pondvf du fichier s'il existe, sinon pondvf reconstitué par une réplique de Do_ponderation.do (exacte à 1e-7 sur juin et juillet 2026).",
  "comparable = FALSE : période de référence de 4 mois au lieu de 3 (PERIODE_REFERENCE_NON_STANDARD dans config.R).",
  "Variation : mois - mois_precedent (mois précédent disponible de la série), SE avec covariance de rotation (svyDelta, Berger-Priam), z = variation / SE.",
  "verdict : règle du bulletin (|z| < 1,645 stable ; < 1,96 légère ; < 3,29 hausse/baisse ; sinon nette). Pas de verdict si la variation n'est pas comparable ou enjambe l'interruption.",
  "z_main : covariance des résidus calculée à la main sur le plan complet (préférable par domaine) ; z_bootstrap : bootstrap de grappes apparié (B = 200).",
  "Mai 2026 : fichier complet introuvable ; data_mai_2026.dta est le sous-échantillon de rang 3 de juillet 2025.",
  "traitement_degrade : voir la colonne degradations (région ou milieu actuel manquant, calage grossier sans marge régionale)."))

wb <- createWorkbook()
feuilles <- list(serie = serie, nationale_ce = vue_nationale, variations_nationales_ce = variations_nat,
                 controle_publie = controle, bilan_mois = bilan, notes = notes)
if (!is.null(effet)) feuilles$effet_regroupement_soldes <- effet
if (!is.null(effet_poids)) feuilles$effet_regroupement_poids <- effet_poids
if (!is.null(effet_var)) feuilles$effet_regroupement_variation <- effet_var
if (!is.null(effet_regroupement)) feuilles$regroupements_avant_apres <- effet_regroupement
for (f in names(feuilles)) { addWorksheet(wb, f); writeData(wb, f, feuilles[[f]]) }
saveWorkbook(wb, file.path(DIR_SERIE, "serie_soldes.xlsx"), overwrite = TRUE)

cat("Série nationale CE (nouveau / publié)\n")
print(as.data.frame(vue_nationale %>% filter(serie %in% c("nouveau (calage ReGenesees)", "publié (bulletin juillet 2026)")) %>%
                      mutate(across(where(is.numeric), ~ round(.x, 3))) %>% select(-libelle)), row.names = FALSE)
cat("\nVariations nationales CE significatives à 95 % (comparables, consécutives)\n")
print(as.data.frame(variations_nat %>% filter(significatif_95 %in% TRUE) %>%
                      transmute(mois_precedent, mois, variable, variation = round(variation, 3),
                                se = round(se_variation_covariance, 3), z = round(z, 2), verdict, variation_traitement_degrade)), row.names = FALSE)
cat("\nVariations non comparables ou après interruption (national CE)\n")
print(as.data.frame(variations_nat %>% filter(!variation_comparable | apres_interruption) %>%
                      transmute(mois_precedent, mois, variable, variation = round(variation, 3), z = round(z, 2), verdict)), row.names = FALSE)
if (!is.null(effet)) {
  cat("\nEffet de la règle de regroupement commune (national CE)\n")
  print(as.data.frame(effet %>% filter(methode == "ce", domaine == "Ensemble") %>%
                        transmute(mois, variable, avant = round(solde_avant, 4), apres = round(solde_apres, 4),
                                  ecart = round(ecart_solde, 4), se_avant = round(erreur_type_avant, 4),
                                  se_apres = round(erreur_type_apres, 4))), row.names = FALSE)
  print(as.data.frame(effet_poids), row.names = FALSE, digits = 3)
  if (!is.null(effet_var)) print(as.data.frame(effet_var %>% filter(methode == "ce") %>% mutate(across(where(is.numeric), ~ round(.x, 3)))), row.names = FALSE)
}
cat("Terminé :", file.path(DIR_SERIE, "serie_soldes.csv"), "\n")
