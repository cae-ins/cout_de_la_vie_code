# ==============================================================================
# Bulletin ECV — génération du document Word à partir des sorties
#   Rscript 05_bulletin.R                   # deux derniers mois de config.R
#   Rscript 05_bulletin.R 2026-06 2026-07   # paire de mois explicite
# Prérequis : run_all.R puis 04_variations.R pour la même paire de mois.
# Sortie    : Bulletins/Archives/Bulletin_ECV_<id2>.docx (document de travail)
# ==============================================================================

local({
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  dir <- if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else getwd()
  setwd(dir)
})
source("config.R", encoding = "UTF-8")
suppressPackageStartupMessages(library(dplyr))
source("R/bulletin.R", encoding = "UTF-8")

args <- commandArgs(trailingOnly = TRUE)
ids <- if (length(args) >= 2) args[1:2] else tail(sort(names(MOIS)), 2)
dir_sortie <- file.path(DIR_BULLETINS, "Archives")   # document de travail, pas le bulletin diffusé
dir.create(dir_sortie, showWarnings = FALSE, recursive = TRUE)

rmarkdown::render(
  "bulletin/bulletin_ecv.Rmd",
  params = list(id1 = ids[1], id2 = ids[2], methode = "ce"),
  output_file = paste0("Bulletin_ECV_", ids[2], ".docx"),
  output_dir = dir_sortie,
  envir = new.env(parent = globalenv()),
  quiet = TRUE
)
cat("Bulletin écrit dans", file.path(dir_sortie, paste0("Bulletin_ECV_", ids[2], ".docx")), "\n")
