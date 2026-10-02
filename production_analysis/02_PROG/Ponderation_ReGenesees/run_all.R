# ==============================================================================
# Pondération ECV — chaîne complète pour les mois déclarés dans config.R
#   Rscript run_all.R
# ==============================================================================

local({
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  dir <- if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else getwd()
  setwd(dir)
})
source("config.R", encoding = "UTF-8")
source("R/fonctions_ponderation.R", encoding = "UTF-8")
source("R/harmonisation.R", encoding = "UTF-8")
for (d in c(DIR_POIDS, DIR_SOLDES, DIR_VARIATIONS, DIR_SERIE)) dir.create(d, showWarnings = FALSE, recursive = TRUE)
dir.create(DIR_SERIE, showWarnings = FALSE, recursive = TRUE)

cat("1. Référentiels (base de sondage, covariables EHCVM, quintiles, projections)\n")
ref <- preparer_referentiels()
cat("   seuils des quintiles de personnes (pcexp) :", round(ref$seuils_quintiles), "\n")
# Total des hhweight EHCVM par région de tirage (réplique de pondvf)
total_pond_ehcvm <- tapply(ref$covariables$hhweight, ref$covariables$region_code, sum)

cat("2. Poids de sondage et non-réponse\n")
mois <- lapply(names(MOIS), function(id) {
  d <- preparer_mois(id, ref)
  nr <- ajuster_non_reponse(d)
  attr(nr$donnees, "harmonisation") <- attr(d, "harmonisation")
  cat(sprintf("   %s : %d tirés, %d répondants (%.1f %%), %d classes de propension\n",
              id, nrow(d), sum(d$repondant), 100 * mean(d$repondant), nrow(nr$classes)))
  nr
})
names(mois) <- names(MOIS)

cat("3. Cellules de calage géographiques (règle commune à tous les mois)\n")
regroupements <- definir_regroupements(lapply(mois, `[[`, "donnees"))
cat(sprintf("   33 régions (médiane mini %.0f répondants), %d cellules zone x milieu (%s), %d régions fragiles\n",
            min(regroupements$mediane_region), n_distinct(regroupements$cellule_zone),
            paste(unique(regroupements$cellule_zone[regroupements$fusion_zone]), collapse = ", "),
            n_distinct(regroupements$region_act[regroupements$region_fragile])))

# Calage standard ; repli « grossier » (sans marge régionale) pour un mois dont le
# calage standard échoue (erreur ou absence de convergence dans les bornes), sauf
# si config.R déclare repli_calage = FALSE pour ce mois. Le repli est consigné
# comme traitement dégradé.
caler_mois <- function(id, d, marges) {
  essai <- function(calage) {
    avert <- character(0)
    res <- withCallingHandlers(
      tryCatch(caler(d, regroupements, marges, calage), error = function(e) e),
      warning = function(w) { avert <<- c(avert, conditionMessage(w)); invokeRestart("muffleWarning") })
    echec <- inherits(res, "error") || any(grepl("converg|not.*reach|fail", avert, ignore.case = TRUE))
    list(res = res, echec = echec, avertissements = avert)
  }
  e <- essai("standard")
  if (e$echec && !identical(MOIS[[id]]$repli_calage, FALSE)) {
    cat(sprintf("   %s : calage standard en échec (%s) -> repli grossier\n", id,
                if (inherits(e$res, "error")) conditionMessage(e$res) else paste(unique(e$avertissements), collapse = " ; ")))
    e2 <- essai("grossier")
    if (inherits(e2$res, "error")) stop(id, " : le calage grossier échoue aussi : ", conditionMessage(e2$res))
    e2$res$repli <- paste("calage standard en échec :", if (inherits(e$res, "error")) conditionMessage(e$res)
                          else paste(unique(e$avertissements), collapse = " ; "))
    e2$res$avertissements <- e2$avertissements
    return(e2$res)
  }
  if (inherits(e$res, "error")) stop(id, " : ", conditionMessage(e$res))
  if (length(e$avertissements)) cat("   avertissements :", paste(unique(e$avertissements), collapse = " ; "), "\n")
  e$res$repli <- NA_character_
  e$res$avertissements <- e$avertissements
  e$res
}

cat("4. Calage et soldes\n")
bilan <- list()
for (id in names(MOIS)) {
  d <- mois[[id]]$donnees
  harmo <- attr(d, "harmonisation")
  marges <- ref$marges %>% filter(trimestre == MOIS[[id]]$trimestre)
  cal <- caler_mois(id, d, marges)
  kish <- 1 + (sd(weights(cal$cal)) / mean(weights(cal$cal)))^2
  cat(sprintf("   %s : calage %s, g dans [%.2f ; %.2f], effet de pondération de Kish %.2f\n",
              id, cal$calage, min(cal$g), max(cal$g), kish))

  soldes <- bind_rows(estimer_soldes(cal$cal, "ce"), estimer_soldes(cal$cal, "insee")) %>%
    mutate(mois = id, .before = 1)

  # Contrôle avec le bulletin : pondvf du fichier s'il existe, sinon pondvf
  # reconstitué par la réplique de Do_ponderation.do (pondvf_replique).
  d$pondvf_replique <- pondvf_replique(d$region_2021, d$region_act, d$hhweight, d$repondant,
                                       unname(total_pond_ehcvm[as.character(d$region_code)]))
  sol_rep <- solde_pondvf(mutate(d, pondvf = pondvf_replique), "ce")
  sol_sto <- if (any(!is.na(d$pondvf[d$repondant]))) solde_pondvf(d, "ce") else setNames(rep(NA_real_, 8), names(VARIABLES_OPINION))
  publie <- if (is.null(PUBLIE[[id]])) setNames(rep(NA_real_, 8), names(VARIABLES_OPINION)) else PUBLIE[[id]]
  comparaison <- tibble(
    variable = names(VARIABLES_OPINION),
    libelle = unname(VARIABLES_OPINION),
    publie = unname(publie[names(VARIABLES_OPINION)]),
    pondvf_recalcule = round(unname(sol_sto), 3),
    pondvf_replique = round(unname(sol_rep), 3)
  ) %>%
    left_join(soldes %>% filter(methode == "ce", domaine == "Ensemble") %>%
                transmute(variable, nouveau = round(solde, 3), erreur_type = round(erreur_type, 3),
                          ic_bas = round(ic_bas, 3), ic_haut = round(ic_haut, 3)),
              by = "variable") %>%
    mutate(ecart_nouveau_publie = round(nouveau - publie, 3),
           ecart_pondvf_publie = round(coalesce(pondvf_recalcule, pondvf_replique) - publie, 3))
  print(as.data.frame(comparaison[, c("libelle", "publie", "pondvf_recalcule", "pondvf_replique", "nouveau", "erreur_type", "ecart_nouveau_publie")]),
        row.names = FALSE)

  # Sorties
  rep <- file.path(DIR_SOLDES, id); dir.create(rep, showWarnings = FALSE, recursive = TRUE)
  poids <- d %>%
    select(hhid, grappe, strate, region_2021, region_act, zone_act, milieu_act, quint, rang, statut,
           repondant, d_base, propension, classe, facteur_nr, w_nr, pondvf) %>%
    left_join(tibble(hhid = cal$cal$variables$hhid, w_cal = weights(cal$cal), g = cal$g), by = "hhid")
  write.csv(poids, chemin_mois(id, paste0("poids_", id, ".csv")), row.names = FALSE, fileEncoding = "UTF-8")
  write.csv(soldes, file.path(rep, paste0("soldes_", id, ".csv")), row.names = FALSE, fileEncoding = "UTF-8")
  saveRDS(cal$cal, chemin_mois(id, paste0("plan_cale_", id, ".rds")))

  degradations <- c(if (!is.null(harmo)) harmo$degradations,
                    if (!is.na(cal$repli)) paste0("calage grossier (sans marge régionale) ; ", cal$repli))
  bilan[[id]] <- tibble(
    mois = id, fichier = MOIS[[id]]$fichier, format = MOIS[[id]]$format %||% "standard",
    n_tires = nrow(d), n_repondants = sum(d$repondant),
    calage = cal$calage, kish = kish, g_min = min(cal$g), g_max = max(cal$g),
    pondvf_dans_fichier = any(!is.na(d$pondvf[d$repondant])),
    ecart_max_pondvf_publie = if (all(is.na(comparaison$publie))) NA_real_ else max(abs(comparaison$ecart_pondvf_publie), na.rm = TRUE),
    controle_publie_0005 = if (all(is.na(comparaison$publie))) NA else all(abs(comparaison$ecart_pondvf_publie) <= 0.005 + 1e-9, na.rm = TRUE),
    traitement_degrade = length(degradations) > 0,
    degradations = paste(degradations, collapse = " ; "),
    hhid_reconstruits = if (is.null(harmo)) 0L else harmo$hhid_par_interview_cle + harmo$hhid_par_cle_men,
    hhid_par_cle_men = if (is.null(harmo)) 0L else harmo$hhid_par_cle_men,
    region_2_systeme = if (is.null(harmo)) "noms (fichier standard)" else harmo$region_2_systeme,
    accord_region_actuelle_tirage = mean((d$region_act == d$region_2021)[d$repondant], na.rm = TRUE),
    accord_milieu_actuel_ehcvm = mean((d$milieu_act == d$milieu_2021)[d$repondant], na.rm = TRUE)
  )

  wb <- createWorkbook()
  feuilles <- list(
    comparaison = comparaison,
    soldes = soldes,
    modele_reponse = data.frame(terme = names(coef(mois[[id]]$modele)),
                                summary(mois[[id]]$modele)$coefficients, row.names = NULL),
    classes_propension = mois[[id]]$classes,
    equilibre = tableau_equilibre(d),
    regroupements = regroupements,
    totaux_calage = data.frame(contrainte = names(cal$totaux), total = unlist(cal$totaux), row.names = NULL),
    facteurs_g = data.frame(t(as.matrix(summary(cal$g)))),
    harmonisation = data.frame(element = c(names(bilan[[id]]), if (!is.null(harmo)) paste0("harmo_", setdiff(names(harmo), "degradations"))),
                               valeur = c(vapply(bilan[[id]], function(x) as.character(x[1]), ""),
                                          if (!is.null(harmo)) vapply(harmo[setdiff(names(harmo), "degradations")], function(x) paste(x, collapse = " "), "")))
  )
  for (f in names(feuilles)) { addWorksheet(wb, f); writeData(wb, f, feuilles[[f]]) }
  saveWorkbook(wb, file.path(rep, paste0("diagnostics_", id, ".xlsx")), overwrite = TRUE)
  write.csv(comparaison, file.path(rep, paste0("controle_publie_", id, ".csv")), row.names = FALSE, fileEncoding = "UTF-8")
}
bilan <- bind_rows(bilan)
write.csv(bilan, file.path(DIR_SERIE, "bilan_mois.csv"), row.names = FALSE, fileEncoding = "UTF-8")
write.csv(regroupements, file.path(DIR_SERIE, "regroupements.csv"), row.names = FALSE, fileEncoding = "UTF-8")
print(as.data.frame(bilan %>% select(mois, n_tires, n_repondants, calage, kish, ecart_max_pondvf_publie, traitement_degrade)), row.names = FALSE, digits = 3)
cat("Terminé. Poids dans", DIR_POIDS, "; résultats dans", DIR_RESULTATS, "\n")
