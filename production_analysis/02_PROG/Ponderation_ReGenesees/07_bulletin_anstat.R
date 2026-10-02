# ==============================================================================
# Bulletin ECV au format ANStat (page de garde, styles et plan du bulletin publié)
#   Rscript 07_bulletin_anstat.R                   # deux derniers mois de config.R
#   Rscript 07_bulletin_anstat.R 2026-06 2026-07   # paire de mois explicite
# Prérequis : run_all.R, 04_variations.R (paire), 06_serie.R (série consolidée).
# Sortie    : production_analysis/Bulletins/Bulletin_ICV<année>_<Mois>.docx
#             (version horodatée si ce fichier est ouvert dans Word)
# ==============================================================================

local({
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  dir <- if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else getwd()
  setwd(dir)
})
source("config.R", encoding = "UTF-8")
suppressPackageStartupMessages({ library(dplyr); library(ggplot2) })
source("R/bulletin.R", encoding = "UTF-8")
suppressPackageStartupMessages(source("R/bulletin_anstat.R", encoding = "UTF-8"))

args <- commandArgs(trailingOnly = TRUE)
ids <- if (length(args) >= 2) args[1:2] else tail(sort(names(MOIS)), 2)
id1 <- ids[1]; id2 <- ids[2]; m1 <- libelle_mois(id1); m2 <- libelle_mois(id2)
methode <- "ce"

# Modèle : bulletin ANStat publié (copié pour ne pas dépendre d'un fichier ouvert)
MODELE <- "C:/Users/f.migone/Desktop/Bulletin_ICV2026_Juillet.docx"
MOIS_MODELE <- "Juillet 2026"
modele_copie <- file.path(tempdir(), "modele_anstat_complet.docx")
invisible(file.copy(MODELE, modele_copie, overwrite = TRUE))

# --- Données ------------------------------------------------------------------
var    <- read.csv(file.path(DIR_VARIATIONS, paste0("variations_", id1, "_", id2, ".csv")), encoding = "UTF-8")
soldes <- read.csv(chemin_mois(id2, paste0("soldes_", id2, ".csv")), encoding = "UTF-8")
poids  <- read.csv(chemin_mois(id2, paste0("poids_", id2, ".csv")), encoding = "UTF-8")
serie  <- read.csv(file.path(DIR_SERIE, "serie_soldes.csv"), encoding = "UTF-8")
tab    <- tableau_national(var, methode) %>%
  mutate(couleur = couleur_lecture(niveau, type, variation),
         lecture = ifelse(niveau == "nc", "non commenté*", paste(fleche_lecture(niveau, variation), qualif)),
         # Évolution non comparable : conservée dans les tableaux, marquée d'un astérisque
         evol_txt = ifelse(niveau == "nc", paste0(pts(variation), "*"), pts(variation)))
nc <- tab %>% filter(niveau == "nc")

# Évolution sur douze mois (même mois de l'année précédente), si les variations ont été calculées
id12 <- sprintf("%d-%s", as.integer(substr(id2, 1, 4)) - 1, substr(id2, 6, 7))
f12 <- file.path(DIR_VARIATIONS, paste0("variations_", id12, "_", id2, ".csv"))
tab12 <- if (file.exists(f12)) {
  tableau_national(read.csv(f12, encoding = "UTF-8"), methode) %>%
    mutate(couleur = couleur_lecture(niveau, type, variation),
           lecture = ifelse(niveau == "nc", "non commenté*", paste(fleche_lecture(niveau, variation), qualif)),
           evol_txt = ifelse(niveau == "nc", paste0(pts(variation), "*"), pts(variation)))
} else NULL
m12 <- libelle_mois(id12)
renvoi_nc <- function(doc) {
  if (nrow(nc) == 0) return(doc)
  body_add_fpar(doc, fpar(ftext(sprintf(paste0("* Évolution non comparable entre %s et %s : à la reprise de la collecte, ",
                                               "la question portait sur quatre mois au lieu de trois (voir l'annexe 5.1)."),
                                        libelle_mois(id1), libelle_mois(id2)), fp(8, color = GRIS_TEXTE))), style = NULL)
}
msg    <- messages_principaux(tab, id1, id2)
cap1   <- function(x) paste0(toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)))
abr    <- c("janv.", "févr.", "mars", "avr.", "mai", "juin", "juil.", "août", "sept.", "oct.", "nov.", "déc.")
court  <- function(id) paste(abr[as.integer(substr(id, 6, 7))], substr(id, 1, 4))

# Seuils des quintiles (dépense par tête, population EHCVM 2021 en personnes), en FCFA par mois
w <- haven::read_dta(FICHIER_WELFARE)
o <- order(w$pcexp); cw <- cumsum((w$hhweight * w$hhsize)[o]) / sum(w$hhweight * w$hhsize)
seuils <- sapply(c(0.2, 0.4, 0.6, 0.8), function(p) w$pcexp[o][which(cw >= p)[1]]) / 12
fcfa <- function(x) paste(format(round(x), big.mark = " "), "FCFA")
pct  <- function(x) formatC(100 * x, format = "f", digits = 1, decimal.mark = ",")

# Effectifs et réponse du mois
n_tir <- nrow(poids); n_rep <- sum(poids$repondant); taux_txt <- pct(n_rep / n_tir)
bilan <- read.csv(file.path(DIR_SERIE, "bilan_mois.csv"), encoding = "UTF-8")
n_communs <- tryCatch({
  r <- readxl::read_excel(file.path(DIR_VARIATIONS, paste0("variations_", id1, "_", id2, ".xlsx")), "recouvrement")
  r$communs[grepl("^Ménages r", r$niveau)]
}, error = function(e) NA)

# --- Document -----------------------------------------------------------------
doc <- preparer_modele(modele_copie, MOIS_MODELE, cap1(m2))
# Direction responsable sur la page de garde : DDI à la place de la CAE
doc <- body_replace_all_text(doc, "Cellule d.Analyses Economiques \\(CAE\\)", DIRECTION, fixed = FALSE)

## I. Résumé exécutif : message principal, chapô, chiffres clés
doc <- ajouter_titre1(doc, "Résumé exécutif")
doc <- ajouter_texte(doc, paste0(msg$titre, "."), bold = TRUE)
for (p in msg$chapo) doc <- ajouter_texte(doc, p)
# Sur un an : seules les évolutions significatives à 95 % sont citées dans le résumé
if (!is.null(tab12)) doc <- ajouter_texte(doc, texte_annuel(tab12, m12, m2, signif_seul = TRUE)[1])
doc <- ajouter_legende(doc, sprintf("Chiffres clés de %s", m2))
cles <- tab %>% transmute(Indicateur = nom_court,
                          !!court(id2) := pts(solde_2),
                          `Sur 1 mois` = evol_txt,
                          `Lecture (1 mois)` = lecture)
couleurs_cles <- list(`Lecture (1 mois)` = tab$couleur)
largeurs_cles <- c(2.6, 1.0, 1.4, 1.6)
if (!is.null(tab12)) {
  t12 <- tab12[match(tab$variable, tab12$variable), ]
  cles <- cles %>% mutate(`Sur 12 mois` = t12$evol_txt, `Lecture (12 mois)` = t12$lecture)
  couleurs_cles$`Lecture (12 mois)` <- t12$couleur
  largeurs_cles <- c(1.9, 0.7, 0.7, 1.35, 0.75, 1.35)
}
doc <- ajouter_tableau(doc, cles, taille = 9, couleurs_lecture = couleurs_cles, largeurs = largeurs_cles)
doc <- renvoi_nc(doc)
doc <- ajouter_source(doc, sprintf("%s ; %s ménages répondants sur %s ménages appelés (taux de réponse : %s %%).",
                                   SOURCE_ANSTAT, format(n_rep, big.mark = " "), format(n_tir, big.mark = " "), taux_txt))
doc <- body_add_break(doc)

## II. Analyse mensuelle
doc <- ajouter_titre1(doc, "Analyse mensuelle des soldes d'opinion économiques")
doc <- ajouter_texte(doc, sprintf(paste0("Cette section présente les soldes d'opinion de %s et leur évolution par rapport à %s. ",
                                         "Seules les évolutions statistiquement significatives sont qualifiées de hausse ou de baisse."), m2, m1))
for (th in unique(THEMES$theme)) {
  # les soldes non comparables ne sont pas commentés ; un thème sans solde commenté est omis
  vars_th <- setdiff(THEMES$variable[THEMES$theme == th], nc$variable)
  if (length(vars_th) == 0) next
  # intertitre réduit aux indicateurs effectivement commentés quand une partie du thème ne l'est pas
  noms_th <- THEMES$nom_court[match(vars_th, THEMES$variable)]
  noms_th[-1] <- tolower(noms_th[-1])
  titre_th <- if (length(vars_th) < sum(THEMES$theme == th)) enumerer(noms_th) else th
  doc <- ajouter_titre2(doc, titre_th)
  for (p in texte_theme(tab[match(vars_th, tab$variable), ], id1, id2)) doc <- ajouter_texte(doc, p)
}
if (!is.null(tab12)) {
  doc <- ajouter_titre2(doc, sprintf("Évolution sur un an (par rapport à %s)", m12))
  for (p in texte_annuel(tab12, m12, m2)) doc <- ajouter_texte(doc, p)
}
doc <- ajouter_titre2(doc, "Écarts entre catégories de ménages")
e <- ecarts_groupes(soldes, methode) %>% filter(significatif) %>%
  left_join(THEMES %>% select(variable, type), by = "variable")
for (p in texte_ecarts(e, m2)) doc <- ajouter_texte(doc, p)
doc <- ajouter_legende(doc, sprintf("Graphique 1 : Cartographie des soldes d'opinion selon les catégories de population - %s", m2))
doc <- ajouter_graphique(doc, graphique_cartographie(soldes, methode), 6.6, 3.5)
doc <- ajouter_note(doc, paste0("plus la couleur est foncée, plus le solde est élevé en valeur absolue : rouge pour les soldes positifs ",
                                "(pression accrue sur les prix, les dépenses, la dette), bleu pour les soldes négatifs (dégradation de la ",
                                "situation financière, du revenu ou du pays). Marges d'erreur par catégorie : tableau A1 en annexe."))
doc <- ajouter_source(doc)

## III. Analyse historique
doc <- ajouter_titre1(doc, "Analyse historique du solde d'opinion sur le coût de la vie")
for (p in texte_historique_cout_vie(serie, id2, methode)) doc <- ajouter_texte(doc, p)
doc <- ajouter_legende(doc, sprintf("Graphique 2 : Évolution du solde d'opinion sur le coût de la vie de février 2025 à %s", m2))
doc <- ajouter_graphique(doc, graphique_cout_vie(serie, methode), 6.6, 3.6)
doc <- ajouter_note(doc, paste0("la bande orange représente l'intervalle de confiance à 95 %. Aucune collecte n'a eu lieu de décembre 2025 ",
                                "à avril 2026 (zone grisée) ; la base de mai 2026 n'est pas disponible."))
doc <- ajouter_source(doc)
doc <- body_add_break(doc)

## IV. Note méthodologique (avant les annexes, comme une publication de référence)
doc <- ajouter_titre1(doc, "Note méthodologique")
doc <- ajouter_titre2(doc, "Échantillon et taux de réponse")
doc <- ajouter_texte(doc, sprintf(paste0(
  "L'enquête interroge chaque mois par téléphone un sous-échantillon des ménages de l'EHCVM 2021, selon un panel rotatif ",
  "(trois mois d'interrogation, neuf mois de repos, puis trois mois). En %s, %s ménages ont été appelés et %s ont répondu, ",
  "soit un taux de réponse de %s %%."),
  m2, format(n_tir, big.mark = " "), format(n_rep, big.mark = " "), taux_txt))
doc <- ajouter_texte(doc, paste0(
  "Aucune collecte n'a eu lieu de décembre 2025 à avril 2026. À la reprise (mai et juin 2026), les questions portant sur ",
  "les trois derniers mois couvraient en réalité quatre mois. Les effectifs et taux de réponse de chaque mois figurent au tableau A5. ",
  "Dates de collecte : [à compléter]."))
doc <- ajouter_titre2(doc, "Pondération")
doc <- ajouter_texte(doc, paste0(
  "Les poids corrigent la non-réponse par un score de propension estimé sur les caractéristiques des ménages connues pour tous ",
  "(niveau de vie, taille, milieu, zone, caractéristiques du chef de ménage), puis sont calés sur la population projetée par région, ",
  "par zone et milieu, et par quintile de niveau de vie."))
doc <- ajouter_titre2(doc, "Lecture des évolutions")
doc <- ajouter_texte(doc, paste0(
  "Chaque solde est estimé sur un échantillon et comporte une marge d'erreur. La variation d'un mois à l'autre est comparée ",
  "à cette marge d'erreur, qui tient compte du fait qu'une partie des ménages est interrogée les deux mois. ",
  "Elle est qualifiée de :"))
for (b in c("stabilité, si elle n'est pas significative au seuil de 90 % ;",
            "légère hausse ou baisse (amélioration ou dégradation), si elle est significative à 90 % mais pas à 95 % ;",
            "hausse ou baisse, si elle est significative à 95 %, et nette hausse ou baisse à 99,9 % ;",
            "lorsque la question ne porte pas sur la même période de référence les deux mois, l'évolution n'est pas commentée (voir l'annexe 5.1)."))
  doc <- ajouter_puce(doc, b)
doc <- body_add_break(doc)

## V. Annexes
doc <- ajouter_titre1(doc, "Annexes")
if (nrow(nc) > 0) {
  doc <- ajouter_titre2(doc, sprintf("Indicateurs non commentés en %s", m2))
  doc <- ajouter_texte(doc, sprintf(paste0(
    "Les évolutions %s ne sont pas commentées dans ce bulletin. Ces questions portent sur les trois derniers mois. ",
    "À la reprise de la collecte, après l'interruption de décembre 2025 à avril 2026, elles ont couvert quatre mois en %s, ",
    "contre trois mois en %s. La différence entre les deux mois mêle donc une évolution de l'opinion et un changement de la ",
    "période de référence, et ne peut pas être interprétée. Les soldes de ces indicateurs restent publiés dans les tableaux, ",
    "où leur évolution est signalée par un astérisque. Ils seront de nouveau commentés lorsque deux mois consécutifs ",
    "porteront sur la même période de référence."),
    enumerer(de_article(nc$sujet)), m1, m2))
}
doc <- ajouter_legende(doc, sprintf("Tableau A1 : Soldes d'opinion de %s selon les catégories de population (points, marge d'erreur à 95 %%)", m2))
t1 <- soldes %>% filter(methode == !!methode) %>%
  inner_join(THEMES %>% select(variable, nom_court), by = "variable") %>%
  mutate(valeur = paste0(pts(solde), "\n(±", pts(1.96 * erreur_type, FALSE), ")"),
         col = ifelse(domaine == "Ensemble", "Ensemble", modalite)) %>%
  select(nom_court, col, valeur) %>%
  tidyr::pivot_wider(names_from = col, values_from = valeur) %>%
  arrange(match(nom_court, THEMES$nom_court)) %>%
  select(Soldes = nom_court, Ensemble, Urbain, Rural, Q1, Q2, Q3, Q4, Q5)
# Ligne d'effectifs : nombre de ménages répondants par catégorie
eff <- serie %>% filter(mois == id2, methode == !!methode, variable == "Cherte_vie") %>%
  mutate(col = ifelse(domaine == "Ensemble", "Ensemble", modalite)) %>%
  select(col, n_repondants)
t1 <- bind_rows(t1, as_tibble(as.list(c(Soldes = "Ménages répondants",
                                        setNames(format(eff$n_repondants, big.mark = " "), eff$col)))))
doc <- ajouter_tableau(doc, t1, taille = 8.5, largeur_col1 = 1.9)
doc <- ajouter_source(doc)

doc <- ajouter_legende(doc, sprintf("Tableau A2 : Soldes d'opinion et évolutions entre %s et %s (points)", m1, m2))
t2 <- tab %>% transmute(Soldes = nom_court, !!court(id1) := pts(solde_1), !!court(id2) := pts(solde_2),
                        `Marge (95 %)` = paste0("±", pts(marge95, FALSE)), `Évolution` = evol_txt,
                        Lecture = lecture)
doc <- ajouter_tableau(doc, t2, taille = 9, couleurs_lecture = tab$couleur,
                       largeurs = c(2.1, 0.7, 0.7, 0.85, 0.85, 1.5))
doc <- renvoi_nc(doc)
doc <- ajouter_source(doc)

if (!is.null(tab12)) {
  doc <- ajouter_legende(doc, sprintf("Tableau A3 : Soldes d'opinion et évolutions sur un an, entre %s et %s (points)", m12, m2))
  t3a <- tab12 %>% transmute(Soldes = nom_court, !!court(id12) := pts(solde_1), !!court(id2) := pts(solde_2),
                             `Marge (95 %)` = paste0("±", pts(marge95, FALSE)), `Évolution` = evol_txt,
                             Lecture = lecture)
  doc <- ajouter_tableau(doc, t3a, taille = 9, couleurs_lecture = tab12$couleur,
                         largeurs = c(2.1, 0.7, 0.7, 0.85, 0.85, 1.5))
  doc <- ajouter_source(doc)
}

doc <- body_add_break(doc)
doc <- ajouter_legende(doc, sprintf("Graphique A1 : Évolution des soldes d'opinion de février 2025 à %s", m2))
doc <- ajouter_graphique(doc, graphique_series_anstat(serie, methode), 6.7, 8.4)
doc <- ajouter_note(doc, paste0("les courbes en rouge représentent les soldes de pression et de charges (coût de la vie, prix, dépenses, dette), ",
                                "pour lesquels une valeur positive traduit une tension accrue ; les courbes en bleu, les soldes de ressources et ",
                                "de conjoncture (situation financière, revenu futur, situation nationale), pour lesquels une valeur négative traduit ",
                                "une dégradation. Barres fines : intervalle de confiance à 95 %. Point creux : question portant sur quatre mois."))
doc <- ajouter_source(doc)

doc <- body_add_break(doc)
doc <- ajouter_legende(doc, "Tableau A4 : Évolution des soldes d'opinion depuis février 2025 (points)")
t3 <- serie %>% filter(methode == !!methode, domaine == "Ensemble") %>%
  inner_join(THEMES %>% select(variable, nom_court), by = "variable") %>%
  mutate(col = paste(abr[as.integer(substr(mois, 6, 7))], substr(mois, 3, 4)),
         val = ifelse(is.na(solde), "nd", paste0(pts(solde), ifelse(!is.na(comparable) & !comparable, "*", "")))) %>%
  arrange(mois) %>% select(nom_court, col, val) %>%
  tidyr::pivot_wider(names_from = col, values_from = val) %>%
  arrange(match(nom_court, THEMES$nom_court)) %>% rename(Soldes = nom_court)
doc <- ajouter_tableau(doc, t3, taille = 7, largeur_col1 = 1.5)
doc <- ajouter_note(doc, "nd : base non disponible. * : question portant sur quatre mois au lieu de trois, non comparable aux autres mois.")
doc <- ajouter_source(doc)

doc <- ajouter_legende(doc, "Tableau A5 : Ménages appelés, ménages répondants et taux de réponse par mois de collecte")
mois_serie <- sort(unique(c(bilan$mois, MOIS_INTROUVABLES)))
t4 <- tibble(mois = mois_serie) %>%
  left_join(bilan %>% select(mois, n_tires, n_repondants), by = "mois") %>%
  transmute(`Mois de collecte` = cap1(sapply(mois, libelle_mois)),
            `Ménages appelés` = ifelse(is.na(n_tires), "nd", format(n_tires, big.mark = " ")),
            `Ménages répondants` = ifelse(is.na(n_repondants), "nd", format(n_repondants, big.mark = " ")),
            `Taux de réponse (%)` = ifelse(is.na(n_tires), "nd", pct(n_repondants / n_tires)))
doc <- ajouter_tableau(doc, t4, taille = 9, largeurs = c(1.8, 1.4, 1.5, 1.4))
doc <- ajouter_note(doc, "nd : base non disponible. Aucune collecte de décembre 2025 à avril 2026.")
doc <- ajouter_source(doc)

## VI. Lexique
doc <- ajouter_titre1(doc, "Lexique")
doc <- ajouter_texte_gras(doc, "Solde d'opinion : ", paste0(
  "écart entre les réponses positives et les réponses négatives, selon la méthode de la Commission européenne : +1 pour une forte ",
  "hausse (ou nette amélioration), +0,5 pour une légère hausse, 0 pour la stabilité, −0,5 et −1 pour les baisses. Les ménages ",
  "sans opinion ne sont pas pris en compte. Le solde est exprimé en points, de −100 à +100."), couleur = MARINE)
doc <- ajouter_texte(doc, "Les soldes ont des périodes de référence différentes :")
for (b in c("le coût de la vie, les prix par rapport au mois précédent, les dépenses et la situation financière se mesurent par rapport au mois précédent ;",
            "le revenu futur mesure une anticipation pour le mois suivant ;",
            "les prix sur les trois derniers mois, la situation économique du pays et la dette se mesurent sur les trois derniers mois."))
  doc <- ajouter_puce(doc, b)
doc <- ajouter_texte_gras(doc, "Marge d'erreur : ", paste0(
  "demi-largeur de l'intervalle de confiance à 95 %. Un solde de +48 avec une marge de ±2 signifie que la valeur vraie se situe ",
  "très probablement entre +46 et +50."), couleur = MARINE)
doc <- ajouter_texte_gras(doc, "Quintile : ", sprintf(paste0(
  "cinq groupes de 20 %% de la population, classés selon la dépense mensuelle par personne mesurée dans l'EHCVM 2021. ",
  "Q1 (les 20 %% les plus modestes) : moins de %s ; Q2 : de %s à %s ; Q3 : de %s à %s ; Q4 : de %s à %s ; ",
  "Q5 (les 20 %% les plus aisés) : plus de %s."),
  fcfa(seuils[1]), fcfa(seuils[1]), fcfa(seuils[2]), fcfa(seuils[2]), fcfa(seuils[3]), fcfa(seuils[3]), fcfa(seuils[4]), fcfa(seuils[4])),
  couleur = MARINE)

# --- Écriture -----------------------------------------------------------------
dir_sortie <- DIR_BULLETINS
dir.create(dir_sortie, showWarnings = FALSE, recursive = TRUE)
# Nom habituel des bulletins : Bulletin_ICV<année>_<Mois>.docx (le suffixe _ok est ajouté à la validation)
sortie <- file.path(dir_sortie, paste0("Bulletin_ICV", substr(id2, 1, 4), "_",
                                       cap1(MOIS_FR[as.integer(substr(id2, 6, 7))]), ".docx"))
doc <- appliquer_numerotation(doc)
doc <- garder_avec_suivant(doc)
doc <- appliquer_police(doc)
# Si le bulletin est ouvert dans Word, on écrit une version horodatée à côté
ecrit <- tryCatch({ print(doc, target = sortie); TRUE }, error = function(e) FALSE)
if (!ecrit) {
  # fichier ouvert dans Word : version horodatée dans Bulletins/Archives
  dir.create(file.path(dir_sortie, "Archives"), showWarnings = FALSE)
  sortie <- file.path(dir_sortie, "Archives",
                      sub("\\.docx$", paste0("_", format(Sys.time(), "%Y%m%d_%H%M"), ".docx"), basename(sortie)))
  print(doc, target = sortie)
}
forcer_police_docx(sortie)
cat("Bulletin ANStat écrit dans", sortie, "\n")
