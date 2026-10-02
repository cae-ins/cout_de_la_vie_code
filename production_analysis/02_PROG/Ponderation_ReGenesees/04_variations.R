# ==============================================================================
# Pondération ECV — variations d'un mois à l'autre des soldes d'opinion
#   Rscript 04_variations.R                      # deux derniers mois de config.R
#   Rscript 04_variations.R 2026-06 2026-07      # paire de mois explicite
#   Rscript 04_variations.R 2026-06 2026-07 1000 # nombre de réplications bootstrap
#                                                # (0 = pas de bootstrap)
# Prérequis : run_all.R a produit, pour les deux mois, 01_DATA/Poids/plan_cale_<id>.rds
#             et poids_<id>.csv, et Resultat/Soldes/<id>/diagnostics_<id>.xlsx.
# Sorties   : Resultat/Variations/variations_<id1>_<id2>.csv et .xlsx
# ==============================================================================

local({
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  dir <- if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else getwd()
  setwd(dir)
})
source("config.R", encoding = "UTF-8")
source("R/fonctions_ponderation.R", encoding = "UTF-8")
source("R/variations.R", encoding = "UTF-8")

args <- commandArgs(trailingOnly = TRUE)
ids <- if (length(args) >= 2) args[1:2] else tail(sort(names(MOIS)), 2)
B   <- if (length(args) >= 3) as.integer(args[3]) else 1000L
id1 <- ids[1]; id2 <- ids[2]
dir.create(DIR_VARIATIONS, showWarnings = FALSE, recursive = TRUE)

cat(sprintf("Variations %s -> %s\n", id1, id2))
p1 <- ajouter_variables_ratio(charger_plan_cale(id1))
p2 <- ajouter_variables_ratio(charger_plan_cale(id2))

cat("1. Recouvrement entre les deux mois\n")
rec <- mesurer_recouvrement(id1, id2)
print(as.data.frame(rec$resume), row.names = FALSE, digits = 3)
if (any(rec$resume$sauts_de_strate > 0, na.rm = TRUE))
  warning("Des grappes communes changent de strate : rho.STRAT = 'noJump' n'est plus exact.")

cat("2. svyDelta (Berger-Priam, rho.STRAT = 'noJump')\n")
delta <- estimer_variations_svydelta(p1, p2)
# Sensibilité : covariance sans la stratification (national seulement)
sans_strate <- estimer_variations_svydelta(p1, p2, domaines = c(Ensemble = "ensemble"),
                                           rho_strat = "noStrat") %>%
  select(methode, variable, domaine, modalite, rho_sans_strate = rho)

cat("3. Contrôle : covariance des résidus linéarisés calculée à la main\n")
main <- covariance_a_la_main(p1, p2)

boot <- NULL
if (B > 0) {
  cat(sprintf("4. Contrôle : bootstrap de grappes apparié (%d réplications, recalage rejoué)\n", B))
  t0 <- Sys.time()
  boot <- bootstrap_grappes(p1, p2, lire_totaux_calage(id1), lire_totaux_calage(id2), B = B)
  cat(sprintf("   %d réplications utiles, %d échecs, %d cellules de calage perdues, %.0f s\n",
              attr(boot, "replications"), attr(boot, "echecs"), attr(boot, "cellules_perdues"),
              as.numeric(difftime(Sys.time(), t0, units = "secs"))))
}

variations <- assembler_variations(delta, soldes_mois(p1), soldes_mois(p2), id1, id2, main, boot) %>%
  left_join(sans_strate, by = c("methode", "variable", "domaine", "modalite"))

# Cohérence : les SE de chaque mois doivent reproduire soldes_<id>.csv
s_pub <- bind_rows(lapply(ids, function(id)
  read.csv(chemin_mois(id, paste0("soldes_", id, ".csv")), fileEncoding = "UTF-8") %>%
    mutate(mois = id)))
verif <- variations %>%
  select(methode, variable, domaine, modalite, solde_1, solde_2, se_1, se_2) %>%
  left_join(s_pub %>% filter(mois == id1) %>% select(methode, variable, domaine, modalite,
                                                     solde_csv_1 = solde, se_csv_1 = erreur_type),
            by = c("methode", "variable", "domaine", "modalite")) %>%
  left_join(s_pub %>% filter(mois == id2) %>% select(methode, variable, domaine, modalite,
                                                     solde_csv_2 = solde, se_csv_2 = erreur_type),
            by = c("methode", "variable", "domaine", "modalite"))
ecart_max <- with(verif, max(abs(c(solde_1 - solde_csv_1, solde_2 - solde_csv_2, se_1 - se_csv_1,
                                   se_2 - se_csv_2)), na.rm = TRUE))
cat(sprintf("   écart maximal avec soldes_<id>.csv (soldes et SE) : %.2e\n", ecart_max))

cat("Variations nationales (méthode CE)\n")
print(as.data.frame(variations %>% filter(methode == "ce", domaine == "Ensemble") %>%
  transmute(libelle, solde_1 = round(solde_1, 3), solde_2 = round(solde_2, 3),
            variation = round(variation, 3), se_indep = round(se_independance, 4),
            se_cov = round(se_covariance, 4), rho = round(rho, 2),
            rho_main = round(rho_main_grappes, 2),
            rho_boot = if (B > 0) round(rho_boot, 2) else NA,
            z_indep = round(z_independance, 2), z_cov = round(z_covariance, 2),
            z_boot = if (B > 0) round(z_bootstrap, 2) else NA,
            sig90 = significatif_90, sig95 = significatif_95)), row.names = FALSE)

# Sorties
base <- file.path(DIR_VARIATIONS, paste0("variations_", id1, "_", id2))
write.csv(variations, paste0(base, ".csv"), row.names = FALSE, fileEncoding = "UTF-8")
wb <- createWorkbook()
feuilles <- list(
  variations = variations,
  recouvrement = rec$resume,
  repondants_grappes = rec$par_grappe,
  rangs = rec$rangs,
  transitions = rec$transitions,
  controle_soldes = verif,
  parametres = data.frame(
    parametre = c("mois_1", "mois_2", "methode", "rho.STRAT", "unite_de_recouvrement",
                  "replications_bootstrap", "bootstrap", "quantile_IC"),
    valeur = c(id1, id2, "ReGenesees::svyDelta (Berger-Priam), ratio sum(w s)/sum(w r)",
               "noJump", "grappe (ZD EHCVM), strate = région x milieu 2021",
               if (B > 0) attr(boot, "replications") else 0,
               "Rao-Wu m_h = n_h - 1, union des grappes, même tirage pour les deux mois, calage rejoué, w_nr fixe",
               "loi normale"))
)
for (f in names(feuilles)) { addWorksheet(wb, f); writeData(wb, f, feuilles[[f]]) }
saveWorkbook(wb, paste0(base, ".xlsx"), overwrite = TRUE)
cat("Terminé. Sorties dans", DIR_VARIATIONS, "\n")
