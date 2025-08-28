# ********************** Construction de l'indicateur ******************************

# Approche INSEE et Banque de France pour chaque thème

data <- Enq_Vie_Chere 
# Situation financière
data$score_fin <- dplyr::case_when(
  data$Situation_fin %in% c(1, 2) ~ 1,
  data$Situation_fin %in% c(4, 5) ~ -1,
  data$Situation_fin == 3 ~ 0,
  TRUE ~ NA_real_
)

data$bscore_fin <- dplyr::case_when(
  data$Situation_fin == 1 ~ 1,
  data$Situation_fin == 2 ~ 0.5,
  data$Situation_fin == 3 ~ 0,
  data$Situation_fin == 4 ~ -0.5,
  data$Situation_fin == 5 ~ -1,
  TRUE ~ NA_real_
)

# Économie globale
data$score_eco <- dplyr::case_when(
  data$Situation_eco %in% c(1, 2) ~ 1,
  data$Situation_eco %in% c(4, 5) ~ -1,
  data$Situation_eco == 3 ~ 0,
  TRUE ~ NA_real_
)

data$bscore_eco <- dplyr::case_when(
  data$Situation_eco == 1 ~ 1,
  data$Situation_eco == 2 ~ 0.5,
  data$Situation_eco == 3 ~ 0,
  data$Situation_eco == 4 ~ -0.5,
  data$Situation_eco == 5 ~ -1,
  TRUE ~ NA_real_
)

# Revenu et emploi
data$score_rev <- dplyr::case_when(
  data$RE1_revenu %in% c(1, 2) ~ 1,
  data$RE1_revenu %in% c(4, 5) ~ -1,
  data$RE1_revenu == 3 ~ 0,
  TRUE ~ NA_real_
)

data$bscore_rev <- dplyr::case_when(
  data$RE1_revenu == 1 ~ 1,
  data$RE1_revenu == 2 ~ 0.5,
  data$RE1_revenu == 3 ~ 0,
  data$RE1_revenu == 4 ~ -0.5,
  data$RE1_revenu == 5 ~ -1,
  TRUE ~ NA_real_
)

# Dépenses et budget
data$score_dep <- dplyr::case_when(
  data$variation_depenses %in% c(1, 2) ~ 1,
  data$variation_depenses %in% c(4, 5) ~ -1,
  data$variation_depenses == 3 ~ 0,
  TRUE ~ NA_real_
)

data$bscore_dep <- dplyr::case_when(
  data$variation_depenses == 1 ~ 1,
  data$variation_depenses == 2 ~ 0.5,
  data$variation_depenses == 3 ~ 0,
  data$variation_depenses == 4 ~ -0.5,
  data$variation_depenses == 5 ~ -1,
  TRUE ~ NA_real_
)

# Évolution des prix
data$score_evolution_prix <- dplyr::case_when(
  data$evolution_prix %in% c(1, 2) ~ 1,
  data$evolution_prix %in% c(4, 5) ~ -1,
  data$evolution_prix == 3 ~ 0,
  TRUE ~ NA_real_
)

data$bscore_evolution_prix <- dplyr::case_when(
  data$evolution_prix == 1 ~ 1,
  data$evolution_prix == 2 ~ 0.5,
  data$evolution_prix == 3 ~ 0,
  data$evolution_prix == 4 ~ -0.5,
  data$evolution_prix == 5 ~ -1,
  TRUE ~ NA_real_
)

# Dynamique des prix
data$score_dynamique_prix <- dplyr::case_when(
  data$dynamique_prix %in% c(1, 2) ~ 1,
  data$dynamique_prix %in% c(4, 5) ~ -1,
  data$dynamique_prix == 3 ~ 0,
  TRUE ~ NA_real_
)

data$bscore_dynamique_prix <- dplyr::case_when(
  data$dynamique_prix == 1 ~ 1,
  data$dynamique_prix == 2 ~ 0.5,
  data$dynamique_prix == 3 ~ 0,
  data$dynamique_prix == 4 ~ -0.5,
  data$dynamique_prix == 5 ~ -1,
  TRUE ~ NA_real_
)

# Endettement
data$score_dette <- dplyr::case_when(
  data$endettement %in% c(1, 2) ~ 1,
  data$endettement %in% c(4, 5) ~ -1,
  data$endettement == 3 ~ 0,
  TRUE ~ NA_real_
)

data$bscore_dette <- dplyr::case_when(
  data$endettement == 1 ~ 1,
  data$endettement == 2 ~ 0.5,
  data$endettement == 3 ~ 0,
  data$endettement == 4 ~ -0.5,
  data$endettement == 5 ~ -1,
  TRUE ~ NA_real_
)

# Cherté de la vie
data$score_Cherte_vie <- dplyr::case_when(
  data$Cherte_vie %in% c(1, 2) ~ 1,
  data$Cherte_vie %in% c(4, 5) ~ -1,
  data$Cherte_vie == 3 ~ 0,
  TRUE ~ NA_real_
)

data$bscore_Cherte_vie <- dplyr::case_when(
  data$Cherte_vie == 1 ~ 1,
  data$Cherte_vie == 2 ~ 0.5,
  data$Cherte_vie == 3 ~ 0,
  data$Cherte_vie == 4 ~ -0.5,
  data$Cherte_vie == 5 ~ -1,
  TRUE ~ NA_real_
)

# Optionnel : calculs des soldes par région (moyennes groupées)
# library(dplyr)
# soldes <- data %>%
#   group_by(region_m) %>%
#   summarise(across(starts_with("score_"), ~ mean(.x, na.rm = TRUE), .names = "solde_{.col}"),
#             across(starts_with("bscore_"), ~ mean(.x, na.rm = TRUE), .names = "bsolde_{.col}"))
