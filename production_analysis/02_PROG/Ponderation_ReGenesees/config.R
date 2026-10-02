# ==============================================================================
# Pondération de l'Enquête Cherté de la Vie (ECV) — paramètres
# ==============================================================================
# Chaîne : poids de sondage (deux phases) -> non-réponse par score de propension
#          -> calage ReGenesees sur la population projetée -> soldes et précision.

# Fork CAE-INS de ReGenesees (2.5.1), installé à part pour ne pas remplacer
# la version 2.4 dont dépend ENE_PRECISION_ESTIMATION.
LIB_REGENESEES <- "C:/Users/f.migone/R/lib_regenesees_cae"

RACINE      <- "C:/Users/f.migone/OneDrive - GOUVCI/CAE_INS - Fichiers de Cellule d'Analyses Economiques ( CAE)/Cherte_vie/Indice_cout_vie"
DIR_PROG    <- file.path(RACINE, "production_analysis/02_PROG/Ponderation_ReGenesees")
DIR_DONNEES <- file.path(RACINE, "production_analysis/01_DATA/Data_cherte_vie")
# Sorties rangées selon l'architecture existante de production_analysis
DIR_PRODUCTION <- file.path(RACINE, "production_analysis")
DIR_POIDS      <- file.path(DIR_PRODUCTION, "01_DATA/Poids")      # poids_<mois>.csv, plan_cale_<mois>.rds
DIR_RESULTATS  <- file.path(DIR_PRODUCTION, "Resultat")
DIR_SOLDES     <- file.path(DIR_RESULTATS, "Soldes")             # Soldes/<mois>/ : soldes, diagnostics, contrôle
DIR_VARIATIONS <- file.path(DIR_RESULTATS, "Variations")         # variations entre deux mois
DIR_SERIE      <- file.path(DIR_RESULTATS, "Serie")              # série consolidée, bilan des mois
DIR_BULLETINS  <- file.path(DIR_PRODUCTION, "Bulletins")         # Bulletin_ICV<année>_<Mois>.docx ; Archives/

# Chemin d'un fichier mensuel : les poids et plans calés vont dans 01_DATA/Poids,
# les autres sorties du mois dans Resultat/Soldes/<mois>
chemin_mois <- function(id, fichier) {
  if (grepl("^(poids|plan_cale)_", fichier)) file.path(DIR_POIDS, fichier) else file.path(DIR_SOLDES, id, fichier)
}

# Base de sondage de l'ECV (12 965 ménages EHCVM, num == 1 : numéro d'un membre)
FICHIER_BASE_TIRAGE <- file.path(RACINE, "initial_sampling/data_temp/base_tirage_global_ICV.dta")
# Covariables EHCVM 2021, connues pour tous les ménages tirés
FICHIER_WELFARE     <- file.path(RACINE, "initial_sampling/data_input/ehcvm_welfare_2b_CIV2021.dta")
# Projections de population 2026 (région x milieu x sexe x âge), reprises de l'ENE
FICHIER_PROJECTIONS <- "C:/Users/f.migone/Desktop/ENE_SURVEY_WEIGHTS/data/06_POPULATION_ESTIMATES/2026/ANStat_Trimestre_2026.xlsx"
# Projections 2025 : population annuelle par région x milieu (feuille data_by_region).
# Les fichiers trimestriels 2025 (T1 à T4) sont identiques entre eux : une seule
# projection annuelle sert donc pour les quatre trimestres de 2025.
FICHIER_PROJECTIONS_2025 <- "C:/Users/f.migone/Desktop/ENE_SURVEY_WEIGHTS/data/06_POPULATION_ESTIMATES/2025/POP_LFS_BY_REGION_URBAIN_RURAL_2025.xlsx"
# Échantillon tiré (clé d'entretien interview__key -> hhid) et base EHCVM de la
# chaîne Stata (interview_cle -> hhid), pour reconstruire hhid quand il manque.
FICHIER_ECHANTILLON   <- file.path(RACINE, "initial_sampling/data_out/Echantillon_Global_ICV.dta")
FICHIER_CORRESP_EHCVM <- file.path(dirname(RACINE), "Indice_Categoriel/Data/global_base_ehcvm_Use.dta")

# Mois de collecte traités. L'identifiant est celui de la colonne du bulletin
# (mois de collecte), qui diffère souvent de mois_ref dans les fichiers.
#   fichier / chemin : fichier mensuel (chemin complet s'il n'est pas dans DIR_DONNEES)
#   format           : « standard » = lu tel quel (juin et juillet 2026) ; sinon
#                      harmonisé par lire_mois_brut() (R/harmonisation.R)
#   trimestre        : trimestre des projections utilisé pour les marges de calage
#   repli_calage     : FALSE pour interdire le repli « grossier » (sans marge
#                      régionale) appliqué par run_all.R quand le calage standard
#                      n'atteint pas ses marges dans les bornes (voir caler())
DIR_BRUT_2025 <- file.path(RACINE, "production_analysis/01_DATA/441_RAW_DATA/2025")
MOIS <- list(
  "2025-02" = list(fichier = "Enq_Vie_Chere_fevrier_2025.dta", format = "fevrier",   trimestre = "T1_2025"),
  "2025-03" = list(fichier = "data_mars_2025.dta",             format = "libelles",  trimestre = "T1_2025"),
  "2025-04" = list(fichier = "data_avril_08_08_25.dta",        format = "chaines",   trimestre = "T2_2025"),
  "2025-05" = list(fichier = "data_mai2025.dta",               format = "chaines",   trimestre = "T2_2025"),
  "2025-06" = list(fichier = "data_juin.dta", chemin = file.path(DIR_BRUT_2025, "Juin/data_juin.dta"),
                   format = "chaines",   trimestre = "T2_2025"),
  "2025-07" = list(fichier = "Cherte_Juillet.dta",             format = "numerique", trimestre = "T3_2025"),
  "2025-08" = list(fichier = "Cherte_Aout.dta",                format = "numerique", trimestre = "T3_2025"),
  "2025-09" = list(fichier = "Cherte_Septembre.dta",           format = "numerique", trimestre = "T3_2025"),
  "2025-10" = list(fichier = "Cherte_Octobre.dta",             format = "numerique", trimestre = "T4_2025"),
  "2025-11" = list(fichier = "Cherte_Novembre.dta",            format = "numerique", trimestre = "T4_2025"),
  # Mai 2026 : aucun fichier complet trouvé (data_mai_2026.dta = sous-fichier de 446
  # ménages de rang 3, qui ne reproduit pas le bulletin). Mois non traité.
  "2026-06" = list(fichier = "data_juin_26_bon.dta", trimestre = "T2_2026"),
  "2026-07" = list(fichier = "data_juillet2026.dta", trimestre = "T3_2026")
)

# Mois manquants de la série publiée (pour la table consolidée)
MOIS_INTROUVABLES <- c("2026-05")

# Interruption de collecte : aucune collecte de décembre 2025 à avril 2026.
# Une paire de mois qui l'enjambe est marquée apres_interruption = TRUE.
INTERRUPTION <- c(debut = "2025-12", fin = "2026-04")

# Période de référence non standard : les questions « sur les 3 derniers mois »
# (dette, situation économique nationale, prix sur 3 mois) ont porté sur 4 mois
# à la reprise après l'interruption (information de la CAE, mai et juin 2026).
# Vérifié dans les données pour 2026-06 : m_date = « Mai 2026 » et third_m_ref
# (début de la fenêtre) = « Février 2026 » pour les 772 répondants, soit février
# à mai = 4 mois ; 2026-07 : avril à juin = 3 mois ; 2025 : 3 mois. 2026-05 :
# non vérifiable (fichier introuvable), hypothèse de la CAE conservée.
# Les soldes de ces cellules sont calculés mais marqués comparable = FALSE, et
# toute variation qui les implique est « non comparable », sans verdict.
PERIODE_REFERENCE_NON_STANDARD <- list(
  "2026-05" = c("endettement", "Situation_eco", "dynamique_prix"),
  "2026-06" = c("endettement", "Situation_eco", "dynamique_prix")
)

# Valeurs publiées (bulletin de juillet 2026, tableau 2 ; méthode CE, poids pondvf,
# « ne sait pas » exclu), pour contrôle.
.pub <- function(eco, dep, fin, rev, dette, prix1, prix3, cout)
  c(Cherte_vie = cout, evolution_prix = prix1, variation_depenses = dep, dynamique_prix = prix3,
    endettement = dette, Situation_eco = eco, Situation_fin = fin, RE1_revenu = rev)
PUBLIE <- list(
  "2025-02" = .pub(-0.03, 0.39, -0.14, -0.04, 0.07, 0.38, 0.45, 0.48),
  "2025-03" = .pub(-0.07, 0.35, -0.16,  0.02, 0.07, 0.49, 0.45, 0.41),
  "2025-04" = .pub(-0.05, 0.28, -0.15, -0.04, 0.11, 0.36, 0.41, 0.47),
  "2025-05" = .pub(-0.07, 0.35, -0.16,  0.02, 0.07, 0.45, 0.49, 0.41),
  "2025-06" = .pub(-0.13, 0.39, -0.29, -0.05, 0.02, 0.44, 0.41, 0.54),
  "2025-07" = .pub(-0.07, 0.39, -0.20, -0.03, 0.06, 0.37, 0.38, 0.47),
  "2025-08" = .pub(-0.06, 0.37, -0.20, -0.07, 0.09, 0.33, 0.34, 0.39),
  "2025-09" = .pub( 0.00, 0.38, -0.13, -0.02, 0.06, 0.33, 0.33, 0.41),
  "2025-10" = .pub(-0.07, 0.34, -0.18, -0.01, 0.06, 0.36, 0.33, 0.42),
  "2025-11" = .pub(-0.03, 0.41, -0.17, -0.06, 0.08, 0.39, 0.35, 0.42),
  "2026-05" = .pub(-0.11, 0.41, -0.21, -0.07, 0.09, 0.44, 0.40, 0.47),
  "2026-06" = .pub(-0.10, 0.43, -0.20, -0.09, 0.06, 0.42, 0.40, 0.46),
  "2026-07" = .pub(-0.13, 0.41, -0.25, -0.14, 0.12, 0.44, 0.40, 0.47)
)
rm(.pub)

VARIABLES_OPINION <- c(
  Cherte_vie         = "Évolution du coût de la vie",
  evolution_prix     = "Évolution des prix (mois précédent)",
  variation_depenses = "Évolution des dépenses",
  dynamique_prix     = "Évolution des prix (3 derniers mois)",
  endettement        = "Dynamique de la dette",
  Situation_eco      = "Situation économique nationale",
  Situation_fin      = "Situation financière",
  RE1_revenu         = "Revenu futur"
)

# --- Cellules de calage géographiques ------------------------------------------
# Marges : région actuelle (33) et zone x milieu actuel (zone = ZAE de la région).
# Une cellule zone x milieu dont la médiane mensuelle de répondants est sous ce seuil
# est fusionnée avec l'autre milieu de la zone (cas d'Abidjan rural).
SEUIL_REPONDANTS_CELLULE <- 20
# Une région dont la médiane mensuelle de répondants est sous ce seuil est signalée.
SEUIL_REPONDANTS_REGION  <- 15

# --- Non-réponse ---------------------------------------------------------------
NB_CLASSES_PROPENSION <- 5
MIN_REPONDANTS_CLASSE <- 30

# --- Calage ----------------------------------------------------------------------
FONCTION_CALAGE <- "logit"
BORNES_CALAGE   <- c(0.25, 4)
