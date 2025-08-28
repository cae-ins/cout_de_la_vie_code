# Packages nécessaires
library(haven)    # lire fichiers .dta
library(dplyr)    # manipulation
library(survey)   # analyse avec pondération
library(writexl)  # export Excel

# 1. Lecture de la base
data <- read_dta("C:/Users/Utilisateur/Downloads/a_transmettre_EJ.dta")

# 2. Encodage de la variable milieu (équivalent encode en Stata)
# En R, on transforme en facteur avec niveaux uniques
data <- data %>%
  mutate(milieu_ = as.integer(factor(milieu)))

# 3. Création des quintiles pondérés (pondération hhweight)
# xtile = découpage en quantiles pondérés
# Pour pondération complexe, on utilise survey package pour calculer quintiles pondérés
# Mais ici on peut approximer avec wtd.quantile du package Hmisc par exemple,
# sinon une fonction personnalisée.
library(Hmisc)

# Fonction pour créer quintiles pondérés
create_quintile <- function(x, w, n = 5) {
  probs <- seq(0, 1, length.out = n + 1)
  cuts <- wtd.quantile(x, weights = w, probs = probs, normwt = TRUE)
  cut(x, breaks = cuts, include.lowest = TRUE, labels = FALSE)
}

data <- data %>%
  mutate(
    quintile = create_quintile(pcexp, hhweight),
    quintile_2 = ifelse(mois_1 == 1, create_quintile(pcexp[mois_1 == 1], hhweight[mois_1 == 1]), NA),
    quintile_3 = create_quintile(pcexp, pondvf)
  )

# 4. Garde uniquement les observations où _merge == 3
data <- filter(data, _merge == 3)

# 5. Définition du design d'enquête avec pondération "pondvf"
des <- svydesign(ids = ~1, data = data, weights = ~pondvf)

# 6. Variables à traiter
vars <- c("score_Cherte_vie", "bscore_Cherte_vie", "score_fin", "bscore_fin",
          "score_eco", "bscore_eco", "score_rev", "bscore_rev", "score_dep", "bscore_dep",
          "score_evolution_prix", "bscore_evolution_prix", "score_dynamique_prix",
          "bscore_dynamique_prix", "score_dette", "bscore_dette")

# 7. Fonction pour calculer moyenne et erreur standard globale et par groupe
calc_stats <- function(design, varname, groupvar = NULL) {
  if (is.null(groupvar)) {
    # Moyenne globale
    svymean(as.formula(paste0("~", varname)), design, na.rm = TRUE)
  } else {
    # Moyenne par groupe
    svyby(as.formula(paste0("~", varname)), as.formula(paste0("~", groupvar)), design, svymean, na.rm = TRUE)
  }
}

# 8. Variables pour les niveaux de regroupement
group_vars <- list(
  milieu_ = "milieu_",
  region = "Region_update",
  quintile = "quintile",
  quintile_2 = "quintile_2",
  quintile_3 = "quintile_3"
)

# 9. Pour chaque variable, calculer les moyennes et erreurs standards globales et par groupe,
# puis assembler un tableau avec les résultats et exporter dans un fichier Excel.

for (var in vars) {
  
  # Résultats globaux
  global_res <- calc_stats(des, var)
  global_df <- data.frame(
    Groupe = "Global",
    Moyenne = coef(global_res),
    StdError = SE(global_res)
  )
  
  # Résultats par groupe
  group_results <- lapply(names(group_vars), function(g) {
    gr_res <- calc_stats(des, var, group_vars[[g]])
    df <- as.data.frame(gr_res)
    # Renommer colonnes pour homogénéité
    colnames(df)[1] <- "Moyenne"
    colnames(df)[2] <- "StdError"
    df$Groupe <- paste0(g, "_", df[[group_vars[[g]]]])
    df[, c("Groupe", "Moyenne", "StdError")]
  })
  
  # Fusionner tous les résultats
  all_res <- bind_rows(global_df, bind_rows(group_results))
  
  # Réorganisation si besoin (optionnel)
  all_res <- all_res %>%
    arrange(Groupe)
  
  # Export dans Excel (une feuille par variable)
  # On crée un fichier unique, on ajoute les feuilles au fur et à mesure
  # Ici on utilise writexl::write_xlsx, qui ne gère pas l'ajout de feuille,
  # donc on sauvegarde une fois à la fin avec toutes les feuilles.
  # Pour cela on peut stocker dans une liste pour écrire à la fin.
  
  if (!exists("excel_list")) {
    excel_list <- list()
  }
  excel_list[[var]] <- all_res
}

# 10. Écriture finale dans un fichier Excel avec plusieurs feuilles
write_xlsx(excel_list, path = "C:/Users/SADIA/Desktop/Cherte_vie/ponderation_calibrage/Final_pond/output_3.xlsx")

