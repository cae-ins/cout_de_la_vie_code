# ==============================================================================
# Libraries
# ==============================================================================

library(dplyr)
library(haven)
library(labelled)

# ==============================================================================
# Paths and Parameters
# ==============================================================================
# ------------------------------------------------------------------------------

#source("config/1_config.r")
#DATA_DIR     <- file.path(BASE_DIR, "data")
#PROCESSED_DIR <- file.path(DATA_DIR, "03_Processed")
#WEIGHTS_DIR   <- file.path(DATA_DIR, "04_weights")

data  <-read_dta("C:/Users/er_dibi/OneDrive - GOUVCI/Bureau/RUTH/RUTH/ECV/data_mai.dta") 



MENAGE_COLUMNS_PATH <- df %>% select (interview__key,pondvf,region_2,milieu)

# ==============================================================================
# Load Data
# ==============================================================================
weights_data <- MENAGE_COLUMNS_PATH
# Path to Stata file containing Urban_Pop_menage and Rural_Pop_Menage
# Extraire les 2 derniers chiffres de l'année
#annee_courte <- substr(TARGET_QUARTER, 6, 7)  # "25" de "T1_2025"

POP_MENAGE_PATH <- file.path("C:/Users/er_dibi/OneDrive - GOUVCI/Bureau/RUTH/RUTH/ECV/struct_menage_rp25.xlsx")
# Read the Stata file
pop_menage_data <- read.xlsx(POP_MENAGE_PATH)

# ==============================================================================
# Function: Aggregate Base Weights
# ==============================================================================

aggregate_base_weights <- function(data) {
  # By region
  weights_by_region <- data %>%
    group_by(region_2) %>%
    summarise(
      base_weight_HH_reg    = sum(pondvf, na.rm = TRUE),
      .groups = "drop"
    )
  
  # By region and milieu
  weights_by_milieu <- data %>%
    group_by(region_2, milieu) %>%
    summarise(
      base_weight_HH_milieu    = sum(pondvf , na.rm = TRUE),
      .groups = "drop"
    )
  # Merge aggregates back
  
  
  # Merge with weights_data by region and milieu
  
  
  # Merge aggregates back
  data <- data %>%
    left_join(weights_by_region, by = "region_2") %>%
    left_join(weights_by_milieu, by = c("region_2", "milieu")) 
  
  
  data <- data %>%
    left_join(
      pop_menage_data %>% select(region_2, Urbain_Pop_Menage, Rural_Pop_Menage),
      by = "region_2"
    )
  return(data)
}

# ==============================================================================
# Function: Compute Margin Factors
# ==============================================================================

compute_margin_factors <- function(data) {
  data <- data %>%
    mutate(margin_factor_HH = case_when(
      milieu == 1 ~ Urbain_Pop_Menage * base_weight_HH_reg / base_weight_HH_milieu,
      milieu == 2 ~ Rural_Pop_Menage  * base_weight_HH_reg / base_weight_HH_milieu,
      TRUE ~ NA_real_
    )
    ) 
  return(data)
}

compute_new_pond <- function(data) {
  data <- data %>%
    mutate(new_pond = margin_factor_HH* pondvf
    )  
  return(data)
  
}

Coeff_calage <- read_excel("C:/Users/er_dibi/OneDrive - GOUVCI/Bureau/RUTH/RUTH/ECV/Coeff_calage_Mai.xlsx")

#coef_calage  <- Coeff_calage_Mai

weights_data <- weights_data %>%
  left_join(coef_calage, by = c("region_2", "milieu"))

compute_new_pond2 <- function(data) {
  data <- data %>%
    mutate(new_pond2 = new_pond / data$coeff
    )
  return(data)
}
# ==============================================================================
# Processing
# ==============================================================================
weights_data <- weights_data %>%
  aggregate_base_weights() %>%
  compute_margin_factors()%>%
  compute_new_pond()%>%
  compute_new_pond2



glimpse(weights_data)
# ==============================================================================
# Save Final Dataset
# ==============================================================================
write_dta(weights_data,"C:/Users/er_dibi/OneDrive - GOUVCI/Bureau/RUTH/RUTH/ECV/new_pond.dta")

write.xlsx(weights_data,"C:/Users/er_dibi/OneDrive - GOUVCI/Bureau/RUTH/RUTH/ECV/new_pond_mai.xlsx")


#df_avril <- merge (weights_data, df , by = "interview__key")

df_mai <- weights_data %>%
  # On enlève les colonnes qui existent déjà dans df (sauf la clé)
  select(-any_of(setdiff(names(weights_data), "interview__key"))[names(weights_data) %in% names(df)]) %>%
  left_join(df, by = "interview__key")

library(haven)
library(dplyr)

# Nettoyer les noms de colonnes en supprimant .x, .y, et caractères interdits
names(df_mai) <- gsub("\\.", "_", names(df_mai))         # Remplace les points par des underscores
names(df_mai) <- gsub("__+", "_", names(df_mai))          # Évite les "__"
names(df_mai) <- gsub("_x$|_y$", "", names(df_mai))       # Supprime les suffixes _x et _y

# Réessaye l'exportation
write_dta(df_mai, "C:/Users/er_dibi/OneDrive - GOUVCI/Bureau/RUTH/RUTH/ECV/data_mai_08_08_25.dta")

