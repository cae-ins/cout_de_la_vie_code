# ==============================================================================
# Harmonisation des fichiers mensuels de l'ECV (février 2025 à juillet 2026)
# ==============================================================================
# Les fichiers mensuels n'ont pas tous le même format :
#   - février 2025      : export Survey Solutions brut (codes 1-5 étiquetés), sans
#                         hhid, sans region_2 ni milieu actuel ;
#   - mars 2025         : réponses en libellés (« Très chère », « Légère hausse »…) ;
#   - avril à juin 2025 : réponses en chaînes « 1 » à « 5 », noms de variables
#                         parfois en minuscules ou dédoublés, region_2 codée ;
#   - juillet à nov. 2025 : codes numériques 1-5 (0 = manquant), consentement
#                         1 / 2 / 0, sans hhid ni pondvf (sauf novembre) ;
#   - juin et juillet 2026 : format « standard », lu tel quel.
#
# lire_mois_brut(id) renvoie, pour chaque mois, un tableau au format attendu par
# preparer_mois() : hhid, grappe, consentement (« Oui » / autre), Rg_interrogation,
# region_2 (nom), milieu (1 urbain / 2 rural), region_21 (nom), les 8 variables
# d'opinion (codes 1-5, NA sinon), pondvf (si présent) et mois_ref.
# Les mois de format « standard » sont lus par read_dta() sans aucune
# transformation : leur traitement reste strictement celui de la chaîne initiale.
#
# Le diagnostic de chaque mois (clés reconstruites, système de codes de
# region_2, accord avec la région et le milieu EHCVM, traitements dégradés) est
# attaché en attribut « harmonisation » du tableau renvoyé.
#
# Ce fichier suppose config.R et R/fonctions_ponderation.R déjà chargés.
# ==============================================================================

# ------------------------------------------------------------------------------
# Noms de région
# ------------------------------------------------------------------------------

sans_accents_maj <- function(x) {
  x <- toupper(trimws(as.character(x)))
  chartr("ÉÈÊËÀÂÄÎÏÔÖÛÜÇéèêëàâäîïôöûüç", "EEEEAAAIIOOUUCEEEEAAAIIOOUUC", x)
}

# Localités ou sous-préfectures saisies à la place d'une région -> région
CORRECTIONS_REGION <- c("KAMASSELA(TOUBA)" = "BAFING", "TOUBA(TOUBA)" = "BAFING",
                        "KOUEDOUO(BOUNA)" = "BOUNKANI", "TIMBEGUELE(DABAKALA)" = "HAMBOL",
                        "BADIKAHA(BADIKAHA)" = "HAMBOL", "GRAND-PONTS" = "GRANDS-PONTS")

# Nom canonique d'une région (celui des fichiers 2026 et des projections)
canon_region <- function(x) {
  x <- sans_accents_maj(x)
  x <- sub("^[0-9]+\\.\\s*", "", x)                 # « 1. AUTONOME D'ABIDJAN »
  x <- sub("^DISTRICT\\s+", "", x)
  x <- sub("^AUTONOME D'\\s*", "", x)
  x <- sub("^AUTONOME DE\\s+", "", x)
  x <- gsub("\\s+", " ", x)
  x <- ifelse(x %in% names(CORRECTIONS_REGION), CORRECTIONS_REGION[x], x)
  x[x %in% c("", ".A", "NA")] <- NA
  unname(x)
}

# ------------------------------------------------------------------------------
# Projections de population 2025
# ------------------------------------------------------------------------------
# Les fichiers trimestriels 2025 de l'ENE (T1 à T4/POP_LFS_..._2025_Tq.xlsx) sont
# identiques entre eux et contiennent une ligne NATIONAL qui double le total.
# On retient donc la projection annuelle 2025 par région x milieu
# (POP_LFS_BY_REGION_URBAIN_RURAL_2025.xlsx, feuille data_by_region), la même
# pour tous les trimestres de 2025.
lire_projections_2025 <- function(fichier, trimestre) {
  x <- read_excel(fichier, sheet = "data_by_region")
  x <- x[!is.na(x$region) & canon_region(x$region) != "NATIONAL", ]
  bind_rows(
    tibble(region = canon_region(x$region), milieu = "Urbain", population = as.numeric(x$urban)),
    tibble(region = canon_region(x$region), milieu = "Rural",  population = as.numeric(x$rural))
  ) %>% mutate(trimestre = trimestre)
}

# Marges d'un trimestre : projections 2026 de l'ANStat, ou projection annuelle 2025
lire_marges_trimestre <- function(trimestre) {
  if (grepl("_2025$", trimestre)) lire_projections_2025(FICHIER_PROJECTIONS_2025, trimestre)
  else lire_projections(FICHIER_PROJECTIONS, trimestre)
}

# ------------------------------------------------------------------------------
# Codage des réponses
# ------------------------------------------------------------------------------

# Libellés -> codes 1 à 5 (1 = hausse forte / nette amélioration, 5 = baisse forte /
# nette dégradation), d'après les étiquettes Stata de février 2025.
DICTIONNAIRE_REPONSES <- c(
  "tres chere" = 1, "forte hausse" = 1, "forte hause" = 1, "forte augmentation" = 1,
  "nette amelioration" = 1, "tres eleve" = 1,
  "chere" = 2, "legere hausse" = 2, "legere augmentation" = 2, "legere amelioration" = 2,
  "eleve" = 2,
  "stable" = 3, "reste echange" = 3, "reste inchange" = 3, "reste inchangee" = 3,
  "quelques-peu chere" = 4, "legere baisse" = 4, "legere diminution" = 4,
  "legere degradation" = 4, "moins eleve" = 4,
  "pas du tout chere" = 5, "forte baisse" = 5, "forte diminution" = 5,
  "nette degradation" = 5, "beaucoup moins eleve" = 5
)

# Une variable d'opinion, quel que soit son format, en codes 1-5 (NA sinon)
coder_reponse <- function(x, nom = "") {
  lab <- attr(x, "labels")
  if (!is.null(lab)) {
    # Variable étiquetée : on vérifie que l'étiquette du code 1 et du code 5
    # correspond bien au dictionnaire, puis on garde les codes.
    cles <- sans_accents(names(lab))
    attendu <- DICTIONNAIRE_REPONSES[cles]
    if (any(!is.na(attendu) & attendu != unname(lab)))
      stop("Étiquettes inattendues pour ", nom, " : ", paste(names(lab), lab, collapse = ", "))
    x <- as.numeric(zap_labels(x))
  }
  if (is.character(x)) {
    t <- sans_accents(x)
    num <- suppressWarnings(as.numeric(t))
    if (all(is.na(t) | t %in% c("", ".a") | !is.na(num))) {
      x <- num
    } else {
      code <- unname(DICTIONNAIRE_REPONSES[t])
      inconnus <- setdiff(unique(t[is.na(code)]), c("", ".a", NA))
      if (length(inconnus)) warning("Libellés non codés pour ", nom, " : ", paste(inconnus, collapse = " | "))
      x <- code
    }
  }
  x <- as.numeric(x)
  x[!(x %in% 1:5)] <- NA
  x
}

coder_consentement <- function(x) {
  if (!is.null(attr(x, "labels"))) x <- as.character(as_factor(x))
  x <- trimws(as.character(x))
  case_when(x %in% c("Oui", "1") ~ "Oui",
            x %in% c("Non", "2") ~ "Non",
            TRUE ~ "Injoignable ou manquant")
}

coder_milieu <- function(x) {
  if (!is.null(attr(x, "labels"))) x <- as.character(as_factor(x))
  t <- sans_accents(x)
  case_when(t %in% c("1", "urbain") ~ 1L, t %in% c("2", "rural") ~ 2L, TRUE ~ NA_integer_)
}

# ------------------------------------------------------------------------------
# Référentiels de l'harmonisation (chargés une fois)
# ------------------------------------------------------------------------------

referentiels_harmonisation <- local({
  cache <- NULL
  function() {
    if (!is.null(cache)) return(cache)
    welfare <- read_dta(FICHIER_WELFARE)
    # Nom canonique de chaque code de région EHCVM (welfare$region)
    noms <- attr(welfare$region, "labels")
    code_nom <- tibble(region_code = as.integer(noms), region_21 = canon_region(names(noms)))
    reg <- welfare %>% transmute(hhid = as.numeric(hhid), region_code = as.integer(region),
                                 milieu_ehcvm = as.integer(milieu)) %>%
      left_join(code_nom, by = "region_code")
    # Clé d'entretien Survey Solutions -> hhid : échantillon tiré, puis base EHCVM
    ech <- read_dta(FICHIER_ECHANTILLON) %>%
      transmute(interview_cle = as.character(interview__key), hhid = as.numeric(hhid))
    glob <- read_dta(FICHIER_CORRESP_EHCVM) %>%
      transmute(interview_cle = as.character(interview_cle), hhid = as.numeric(hhid))
    cles <- bind_rows(ech, glob) %>% filter(!is.na(interview_cle), interview_cle != "") %>%
      distinct(interview_cle, hhid)
    dup <- cles$interview_cle[duplicated(cles$interview_cle)]
    cles <- cles %>% filter(!interview_cle %in% dup)
    # Identifiant ECV du ménage (cle_men) -> hhid, appris sur tous les fichiers
    # mensuels où hhid est connu (directement ou par interview_cle). Sert pour les
    # ménages dont interview_cle ne figure pas dans les bases EHCVM (juin et
    # juillet 2025). Les cle_men associées à plusieurs hhid sont écartées.
    cle_men <- bind_rows(lapply(names(MOIS), function(id) {
      b <- read_dta(chemin_mois(id), .name_repair = "minimal")
      names(b) <- make.unique(names(b), sep = "...")
      h <- colonne(b, "hhid"); h <- if (is.null(h)) rep(NA_real_, nrow(b)) else as.numeric(h)
      k <- as.character(colonne(b, c("interview_cle", "interview__key")))
      h <- ifelse(is.na(h), cles$hhid[match(k, cles$interview_cle)], h)
      cm <- colonne(b, "cle_men")
      if (is.null(cm)) return(NULL)
      tibble(cle_men = as.character(cm), hhid = h)
    })) %>% filter(!is.na(hhid), !is.na(cle_men), cle_men != "") %>% distinct()
    conflits <- unique(c(cle_men$cle_men[duplicated(cle_men$cle_men)]))
    cle_men <- cle_men %>% filter(!cle_men %in% conflits)
    canon <- sort(unique(code_nom$region_21))
    cache <<- list(region = reg, cles = cles, cle_men = cle_men, cle_men_conflits = length(conflits),
                   code_nom = code_nom,
                   # Systèmes de codes possibles pour une region_2 numérique sans étiquette
                   systemes = list(
                     alphabetique_nzi_nawa = setNames(canon, seq_along(canon)),
                     alphabetique_nawa_nzi = { a <- canon; i <- match(c("N'ZI", "NAWA"), a); a[i] <- a[rev(i)]; setNames(a, seq_along(a)) },
                     ehcvm = setNames(code_nom$region_21, code_nom$region_code)))
    cache
  }
})

# ------------------------------------------------------------------------------
# Lecture d'un mois
# ------------------------------------------------------------------------------

chemin_mois <- function(id) {
  m <- MOIS[[id]]
  if (!is.null(m$chemin)) m$chemin else file.path(DIR_DONNEES, m$fichier)
}

# Première colonne dont le nom (sans tenir compte de la casse) figure dans `noms`
colonne <- function(d, noms) {
  low <- tolower(names(d))
  for (n in tolower(noms)) { i <- which(low == n); if (length(i)) return(d[[i[1]]]) }
  NULL
}

lire_mois_brut <- function(id) {
  m <- MOIS[[id]]
  format <- if (is.null(m$format)) "standard" else m$format
  if (format == "standard") return(read_dta(chemin_mois(id)))

  ref <- referentiels_harmonisation()
  brut <- read_dta(chemin_mois(id), .name_repair = "minimal")
  names(brut) <- make.unique(names(brut), sep = "...")
  diag <- list(mois = id, fichier = basename(chemin_mois(id)), format = format,
               n_lignes = nrow(brut), degradations = character(0))

  # --- Clé ménage ---------------------------------------------------------------
  hhid <- colonne(brut, "hhid"); hhid <- if (is.null(hhid)) rep(NA_real_, nrow(brut)) else as.numeric(hhid)
  cle <- as.character(colonne(brut, c("interview_cle", "interview__key")))
  via_cle <- ref$cles$hhid[match(cle, ref$cles$interview_cle)]
  cm <- as.character(colonne(brut, "cle_men") %||% rep(NA, nrow(brut)))
  via_men <- ref$cle_men$hhid[match(cm, ref$cle_men$cle_men)]
  diag$hhid_present <- sum(!is.na(hhid))
  diag$hhid_par_interview_cle <- sum(is.na(hhid) & !is.na(via_cle))
  diag$hhid_par_cle_men <- sum(is.na(hhid) & is.na(via_cle) & !is.na(via_men))
  diag$hhid_discordants <- sum(!is.na(hhid) & !is.na(via_cle) & hhid != via_cle) +
    sum(!is.na(hhid) & !is.na(via_men) & hhid != via_men)
  diag$hhid_discordants_cle_men_interview_cle <- sum(!is.na(via_cle) & !is.na(via_men) & via_cle != via_men)
  hhid <- ifelse(is.na(hhid), via_cle, hhid)
  hhid <- ifelse(is.na(hhid), via_men, hhid)

  d <- tibble(
    hhid = hhid,
    interview_cle = cle,
    consentement = coder_consentement(colonne(brut, "consentement")),
    Rg_interrogation = as.integer(zap_labels(colonne(brut, c("Rg_interrogation", "rg_interrogation")) %||% NA)),
    mois_ref = as.character(colonne(brut, "mois_ref") %||% NA)
  )
  for (v in names(VARIABLES_OPINION)) d[[v]] <- coder_reponse(colonne(brut, v) %||% rep(NA, nrow(brut)), v)
  pv <- colonne(brut, "pondvf")
  d$pondvf <- if (is.null(pv)) NA_real_ else as.numeric(pv)
  diag$pondvf_present <- !is.null(pv)

  # Ménages sans clé EHCVM, ou en double : retirés (comptés dans le diagnostic)
  diag$sans_hhid <- sum(is.na(d$hhid))
  diag$hhid_inconnus_ehcvm <- sum(!is.na(d$hhid) & !d$hhid %in% ref$region$hhid)
  garder <- !is.na(d$hhid) & d$hhid %in% ref$region$hhid
  # Doublons : on garde la ligne répondante si elle existe
  ordre <- order(d$hhid, d$consentement != "Oui")
  dup <- duplicated(d$hhid[ordre]); dup <- dup[order(ordre)]
  diag$doublons_hhid <- sum(dup & garder)
  garder <- garder & !dup

  # --- Région de tirage (EHCVM 2021) --------------------------------------------
  e <- ref$region[match(d$hhid, ref$region$hhid), ]
  d$region_21 <- e$region_21
  d$grappe <- d$hhid %/% 100
  d$menage <- d$hhid %% 100

  # --- Région actuelle ------------------------------------------------------------
  r2 <- colonne(brut, if (format == "fevrier") "region" else c("region_2", "region_2_3", "region_2_153"))
  rep <- d$consentement == "Oui"
  if (is.null(r2)) {
    d$region_2 <- NA_character_
    diag$region_2_systeme <- "absente"
  } else if (!is.null(attr(r2, "labels")) || is.character(r2)) {
    d$region_2 <- canon_region(if (!is.null(attr(r2, "labels"))) as_factor(r2) else r2)
    diag$region_2_systeme <- if (is.character(r2)) "noms" else "étiquettes"
  } else {
    # Codes sans étiquette : on retient le système qui concorde le mieux avec la
    # région de tirage chez les répondants (la plupart n'ont pas déménagé).
    code <- as.character(as.integer(r2))
    accord <- sapply(ref$systemes, function(s) mean(unname(s[code])[rep] == d$region_21[rep], na.rm = TRUE))
    d$region_2 <- unname(ref$systemes[[which.max(accord)]][code])
    diag$region_2_systeme <- paste0("codes ", names(which.max(accord)))
  }
  inconnus <- !is.na(d$region_2) & !d$region_2 %in% ref$code_nom$region_21
  diag$region_2_inconnues <- paste(unique(d$region_2[inconnus]), collapse = " | ")
  d$region_2[inconnus] <- NA
  diag$region_2_manquante_repondants <- sum(rep & garder & is.na(d$region_2))
  diag$accord_region_2_region_21 <- mean((d$region_2 == d$region_21)[rep & garder], na.rm = TRUE)
  if (is.null(r2)) diag$degradations <- c(diag$degradations,
    "région actuelle absente : région de tirage EHCVM utilisée pour tous les répondants")
  if (diag$region_2_manquante_repondants > 0) diag$degradations <- c(diag$degradations,
    sprintf("région actuelle manquante pour %d répondants : région de tirage utilisée", diag$region_2_manquante_repondants))

  # --- Milieu actuel ----------------------------------------------------------------
  mi <- if (format == "fevrier") NULL else colonne(brut, "milieu")
  d$milieu <- if (is.null(mi)) NA_integer_ else coder_milieu(mi)
  diag$accord_milieu_ehcvm <- mean((d$milieu == e$milieu_ehcvm)[rep & garder], na.rm = TRUE)
  if (is.null(mi)) {
    diag$degradations <- c(diag$degradations, "milieu actuel absent : milieu EHCVM 2021 utilisé")
  } else if (isTRUE(diag$accord_milieu_ehcvm == 1)) {
    # La variable « milieu » n'est qu'une copie du milieu EHCVM : pas de milieu actuel
    d$milieu <- NA_integer_
    diag$degradations <- c(diag$degradations,
      "milieu actuel absent (la variable milieu recopie le milieu EHCVM 2021) : milieu EHCVM utilisé")
  }

  # --- Rang -------------------------------------------------------------------------
  if (all(is.na(d$Rg_interrogation)))
    diag$degradations <- c(diag$degradations, "rang d'interrogation absent")

  d <- d[garder, ]
  diag$n_tires <- nrow(d)
  diag$n_repondants <- sum(d$consentement == "Oui")
  attr(d, "harmonisation") <- diag
  d
}

`%||%` <- function(a, b) if (is.null(a)) b else a

# ------------------------------------------------------------------------------
# Réplique de Do_ponderation.do (poids « pondvf » de la chaîne Stata)
# ------------------------------------------------------------------------------
# Sert uniquement au contrôle avec les chiffres publiés, pour les mois dont le
# fichier ne contient pas pondvf. Après simplification (na_interview s'annule) :
#   pondv1_i = (T_r21 - S_r21 + E_r2) / (n_r2 - ns_r21 + ne_r2)
#   T  : total des hhweight EHCVM de la région de tirage ;
#   S  : hhweight des répondants sortis de la région de tirage, E : entrés dans r2 ;
#   n  : répondants de la région actuelle ; ns, ne : nombres de sortants, d'entrants.
#   pondvf_i = hhweight_i x sum_r2(pondv1) / sum_r2(hhweight)  (répondants).
pondvf_replique <- function(region_21, region_2, hhweight, repondant, total_pond_ehcvm) {
  x <- tibble(r21 = region_21, r2 = ifelse(is.na(region_2), region_21, region_2),
              w = hhweight, rep = repondant, T = total_pond_ehcvm) %>%
    mutate(chg = rep & r21 != r2, pchg = w * chg)
  s21 <- x %>% group_by(r21) %>% summarise(S = sum(pchg), ns = sum(chg), .groups = "drop")
  s2  <- x %>% group_by(r2) %>% summarise(E = sum(pchg), ne = sum(chg), n = sum(rep),
                                          tot_w = sum(w[rep]), .groups = "drop")
  x <- x %>% left_join(s21, by = "r21") %>% left_join(s2, by = "r2") %>%
    mutate(pondv1 = ifelse(rep, (T - S + E) / (n - ns + ne), NA_real_))
  x <- x %>% group_by(r2) %>% mutate(tot_v1 = sum(pondv1, na.rm = TRUE)) %>% ungroup()
  ifelse(x$rep, x$w * x$tot_v1 / x$tot_w, NA_real_)
}
