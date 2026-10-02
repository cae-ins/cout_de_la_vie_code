# ==============================================================================
# Fonctions de la pondération ECV
# ==============================================================================

suppressPackageStartupMessages({
  library(haven)
  library(dplyr)
  library(readxl)
  library(openxlsx)
  library(ReGenesees, lib.loc = LIB_REGENESEES)
})
stopifnot(as.character(packageVersion("ReGenesees", lib.loc = LIB_REGENESEES)) >= "2.5.1")
options(RG.lonely.psu = "adjust")

# ------------------------------------------------------------------------------
# Utilitaires
# ------------------------------------------------------------------------------

sans_accents <- function(x) {
  x <- tolower(trimws(as.character(x)))
  chartr("éèêëàâäîïôöûüçœ", "eeeeaaaiioouucœ", x)
}

# Noms de région des projections -> noms courts utilisés dans l'ECV
normaliser_region <- function(x) {
  x <- toupper(trimws(as.character(x)))
  x <- sub("^DISTRICT AUTONOME D'", "", x)
  x <- sub("^DISTRICT AUTONOME DE ", "", x)
  x
}

quantile_pondere <- function(x, w, probs) {
  o <- order(x); x <- x[o]; w <- w[o]
  cw <- cumsum(w) / sum(w)
  sapply(probs, function(p) x[which(cw >= p)[1]])
}

# Score d'une réponse qualitative à 5 modalités.
#   methode "ce"    : +1 / +0,5 / 0 / -0,5 / -1 (formule de la Commission européenne)
#   methode "insee" : +1 / +1 / 0 / -1 / -1
# « Ne sait pas » et non-réponse -> NA (exclus du dénominateur, comme à l'Insee).
# Codes numériques : 1 et 2 hausse/amélioration, 3 stable, 4 et 5 baisse/dégradation
# (codage de construction_solde.do).
score_reponse <- function(x, methode = c("ce", "insee")) {
  methode <- match.arg(methode)
  leger <- if (methode == "ce") 0.5 else 1
  if (is.numeric(x)) {
    s <- rep(NA_real_, length(x))
    ok <- !is.na(x) & x %in% 1:5
    s[ok] <- c(1, leger, 0, -leger, -1)[x[ok]]
    return(s)
  }
  t <- sans_accents(x)
  s <- rep(NA_real_, length(t))
  neutre <- grepl("inchang|stable|echang", t)
  baisse <- grepl("baisse|diminu|degrad|moins", t) & !neutre
  hausse <- grepl("hausse|hause|augment|amelior|eleve", t) & !baisse & !neutre
  fort   <- grepl("forte|nette|beaucoup|tres", t)
  s[neutre] <- 0
  s[hausse] <- ifelse(fort[hausse], 1, leger)
  s[baisse] <- -ifelse(fort[baisse], 1, leger)
  s
}

# ------------------------------------------------------------------------------
# Référentiels : base de sondage, covariables EHCVM, seuils de quintiles, marges
# ------------------------------------------------------------------------------

lire_projections <- function(fichier, trimestre) {
  feuille <- paste0("TAB1_", trimestre)
  x <- suppressMessages(read_excel(fichier, sheet = feuille, col_names = FALSE))
  region <- x[[2]]
  for (i in seq_along(region)) if (is.na(region[i]) && i > 1) region[i] <- region[i - 1]
  lignes <- which(x[[4]] == "Total" & !is.na(region) & region != "Ensemble")
  num <- function(cols) rowSums(sapply(x[lignes, cols], as.numeric))
  bind_rows(
    tibble(region = normaliser_region(region[lignes]), milieu = "Urbain", population = num(5:8)),
    tibble(region = normaliser_region(region[lignes]), milieu = "Rural",  population = num(9:12))
  ) %>% mutate(trimestre = trimestre)
}

preparer_referentiels <- function() {
  base <- read_dta(FICHIER_BASE_TIRAGE)
  welfare <- read_dta(FICHIER_WELFARE)

  # N'_r : ménages de la région EHCVM disposant du numéro d'un membre (num == 1)
  n_prime <- base %>%
    filter(num == 1) %>%
    count(region_code = as.integer(region), name = "N_prime")

  regroupe_educ <- function(e) {
    e <- sans_accents(as_factor(e))
    case_when(e %in% c("aucun", "maternelle") ~ "Aucun",
              e == "primaire" ~ "Primaire",
              grepl("^second", e) ~ "Secondaire",
              e %in% c("postsecondaire", "superieur") ~ "Superieur",
              TRUE ~ "Inconnu")
  }
  regroupe_csp <- function(c) {
    c <- sans_accents(as_factor(c))
    case_when(grepl("compte propre", c) ~ "Compte propre",
              grepl("cadre|qualifie", c) & !grepl("non qualifie", c) ~ "Salarie qualifie",
              grepl("non qualifie|manoeuvre|manœuvre", c) ~ "Salarie non qualifie",
              grepl("patron", c) ~ "Employeur",
              is.na(c) | c == "" ~ "Sans emploi declare",
              TRUE ~ "Autre")
  }

  covariables <- welfare %>%
    transmute(
      hhid,
      region_code   = as.integer(region),
      milieu_2021   = ifelse(as.integer(milieu) == 1, "Urbain", "Rural"),
      strate        = paste(region_code, milieu_2021, sep = "_"),
      zae           = as.character(as_factor(zae)),
      cm_sexe       = as.character(as_factor(hgender)),
      cm_age        = cut(as.numeric(hage), c(0, 30, 45, 60, Inf), right = FALSE,
                          labels = c("<30", "30-44", "45-59", "60+")),
      cm_educ       = regroupe_educ(heduc),
      cm_csp        = regroupe_csp(hcsp),
      hhsize        = as.numeric(hhsize),
      pcexp         = as.numeric(pcexp),
      hhweight      = as.numeric(hhweight)
    )

  # Zone de chaque région : ZAE majoritaire de ses ménages EHCVM
  zone_region <- covariables %>%
    count(region_code, zae) %>%
    group_by(region_code) %>% slice_max(n, n = 1, with_ties = FALSE) %>% ungroup() %>%
    select(region_code, zone = zae)

  # Seuils de quintiles fixes : pcexp, population EHCVM 2021 pondérée en personnes
  seuils <- quantile_pondere(covariables$pcexp, covariables$hhweight * covariables$hhsize,
                             c(0.2, 0.4, 0.6, 0.8))

  trimestres <- unique(vapply(MOIS, `[[`, "", "trimestre"))
  # Projections ANStat 2026 par trimestre ; projection annuelle 2025 pour les
  # trimestres de 2025 (lire_marges_trimestre, R/harmonisation.R)
  marges <- bind_rows(lapply(trimestres, lire_marges_trimestre))

  list(n_prime = n_prime, covariables = covariables, zone_region = zone_region,
       seuils_quintiles = seuils, marges = marges)
}

# ------------------------------------------------------------------------------
# Données d'un mois et poids de sondage
# ------------------------------------------------------------------------------

# Poids de sondage : d_it = hhweight_i * N'_r / m_rt
#   r    : région EHCVM de tirage
#   m_rt : ménages tirés de la région dont le sous-échantillon est lancé au mois t
preparer_mois <- function(id, ref) {
  # Fichiers « standard » (2026) : read_dta() tel quel ; autres mois : format
  # harmonisé par lire_mois_brut() (R/harmonisation.R)
  brut <- lire_mois_brut(id)
  d <- brut %>%
    transmute(
      hhid, grappe = as.integer(grappe),
      repondant   = as.character(consentement) == "Oui",
      statut      = as.character(consentement),
      rang        = as.integer(Rg_interrogation),
      region_act  = na_if(na_if(as.character(as_factor(region_2)), ".A"), ""),
      milieu_act  = case_when(as.integer(milieu) == 1 ~ "Urbain",
                              as.integer(milieu) == 2 ~ "Rural"),
      pondvf      = as.numeric(pondvf),
      across(all_of(names(VARIABLES_OPINION)), ~ .x)
    ) %>%
    left_join(ref$covariables, by = "hhid")

  if (anyNA(d$region_code)) stop("Ménages sans correspondance dans la base EHCVM : ", sum(is.na(d$region_code)))

  d <- d %>%
    add_count(region_code, name = "m_rt") %>%
    left_join(ref$n_prime, by = "region_code") %>%
    mutate(
      d_base  = hhweight * N_prime / m_rt,
      quint   = cut(pcexp, c(-Inf, ref$seuils_quintiles, Inf), labels = paste0("Q", 1:5)),
      rang    = ifelse(is.na(rang), as.integer(names(which.max(table(rang)))), rang),
      # Milieu actuel manquant chez un répondant resté dans sa région : milieu EHCVM
      milieu_act = ifelse(repondant & is.na(milieu_act), milieu_2021, milieu_act)
    )

  # Région actuelle manquante chez un répondant : région de tirage
  d$region_2021 <- as.character(as_factor(brut$region_21))[match(d$hhid, brut$hhid)]
  d$region_act <- ifelse(d$repondant & is.na(d$region_act), d$region_2021, d$region_act)

  # Zone de la région actuelle (via le code de la région du même nom)
  code_nom <- distinct(d, region_2021, region_code)
  d$zone_act <- ref$zone_region$zone[match(code_nom$region_code[match(d$region_act, code_nom$region_2021)],
                                           ref$zone_region$region_code)]

  # Scores des réponses, selon les deux méthodes
  for (v in names(VARIABLES_OPINION)) {
    d[[paste0("ce_", v)]]    <- score_reponse(d[[v]], "ce")
    d[[paste0("insee_", v)]] <- score_reponse(d[[v]], "insee")
  }
  attr(d, "harmonisation") <- attr(brut, "harmonisation")
  d
}

# ------------------------------------------------------------------------------
# Non-réponse : score de propension et classes homogènes de réponse
# ------------------------------------------------------------------------------

ajuster_non_reponse <- function(d) {
  formule <- repondant ~ log(pcexp) + log(hhsize) + milieu_2021 + zae +
    cm_sexe + cm_age + cm_educ + cm_csp + factor(rang)
  # Un seul rang ce mois-là (février 2025, premier sous-échantillon) : terme retiré
  if (n_distinct(d$rang) == 1) formule <- update(formule, . ~ . - factor(rang))
  modele <- glm(formule, data = d, family = binomial())
  d$propension <- predict(modele, type = "response")

  # Classes par quantiles du score ; fusion des classes trop petites avec la voisine
  bornes <- unique(quantile(d$propension, seq(0, 1, length.out = NB_CLASSES_PROPENSION + 1)))
  d$classe <- cut(d$propension, bornes, include.lowest = TRUE, labels = FALSE)
  repeat {
    n_rep <- tapply(d$repondant, d$classe, sum)
    petite <- which(n_rep < MIN_REPONDANTS_CLASSE)
    if (length(petite) == 0 || length(n_rep) == 1) break
    k <- as.integer(names(n_rep)[petite[1]])
    voisine <- if (k == min(d$classe)) k + 1 else k - 1
    d$classe[d$classe == k] <- voisine
    d$classe <- as.integer(factor(d$classe))
  }

  # Facteur = inverse du taux de réponse pondéré par d_base dans la classe
  classes <- d %>%
    group_by(classe) %>%
    summarise(n = n(), n_repondants = sum(repondant),
              propension_moyenne = mean(propension),
              taux_reponse_pondere = sum(d_base[repondant]) / sum(d_base),
              .groups = "drop") %>%
    mutate(facteur_nr = 1 / taux_reponse_pondere)

  d <- d %>%
    left_join(classes %>% select(classe, facteur_nr), by = "classe") %>%
    mutate(w_nr = ifelse(repondant, d_base * facteur_nr, NA_real_))

  list(donnees = d, modele = modele, classes = classes)
}

# Équilibre : structure de l'échantillon tiré (d_base) comparée à celle des
# répondants avant (d_base) et après (w_nr) correction de non-réponse.
tableau_equilibre <- function(d, variables = c("quint", "milieu_2021", "zae", "cm_educ", "cm_age")) {
  bind_rows(lapply(variables, function(v) {
    d %>%
      group_by(modalite = as.character(.data[[v]])) %>%
      summarise(echantillon = sum(d_base),
                repondants_brut = sum(d_base[repondant]),
                repondants_corriges = sum(w_nr[repondant]), .groups = "drop") %>%
      mutate(across(c(echantillon, repondants_brut, repondants_corriges), ~ 100 * .x / sum(.x)),
             variable = v, .before = 1)
  }))
}

# ------------------------------------------------------------------------------
# Regroupement des cellules région x milieu (règle fixe, sur plusieurs mois)
# ------------------------------------------------------------------------------

# Deux marges géographiques emboîtées :
#   - la région actuelle seule (33 cellules) ;
#   - la zone (ZAE majoritaire de la région) x milieu actuel.
# Une cellule zone x milieu dont la médiane mensuelle de répondants est sous
# SEUIL_REPONDANTS_CELLULE est fusionnée avec l'autre milieu de la zone.
# Une région sous SEUIL_REPONDANTS_REGION est signalée (fusion à décider à la main).
definir_regroupements <- function(liste_mois) {
  rep <- bind_rows(lapply(names(liste_mois), function(id) {
    liste_mois[[id]] %>% filter(repondant) %>% select(region_act, zone_act, milieu_act) %>% mutate(mois = id)
  }))
  zones <- rep %>% distinct(region_act, zone_act)
  grille <- expand.grid(region_act = zones$region_act, milieu_act = c("Urbain", "Rural"),
                        mois = names(liste_mois), stringsAsFactors = FALSE) %>%
    left_join(zones, by = "region_act")
  n_cellules <- grille %>%
    left_join(rep %>% count(region_act, milieu_act, mois), by = c("region_act", "milieu_act", "mois")) %>%
    mutate(n = coalesce(n, 0L))

  med_region <- n_cellules %>% group_by(region_act, mois) %>% summarise(n = sum(n), .groups = "drop") %>%
    group_by(region_act) %>% summarise(mediane_region = median(n), min_region = min(n), .groups = "drop")
  med_zone <- n_cellules %>% group_by(zone_act, milieu_act, mois) %>% summarise(n = sum(n), .groups = "drop") %>%
    group_by(zone_act, milieu_act) %>% summarise(mediane_zone_milieu = median(n), .groups = "drop") %>%
    group_by(zone_act) %>% mutate(fusion_zone = any(mediane_zone_milieu < SEUIL_REPONDANTS_CELLULE)) %>% ungroup()

  grille %>% distinct(region_act, zone_act, milieu_act) %>%
    left_join(med_region, by = "region_act") %>%
    left_join(med_zone, by = c("zone_act", "milieu_act")) %>%
    mutate(cellule_zone = ifelse(fusion_zone, paste0(zone_act, "_Ensemble"), paste0(zone_act, "_", milieu_act)),
           region_fragile = mediane_region < SEUIL_REPONDANTS_REGION)
}

# ------------------------------------------------------------------------------
# Calage ReGenesees : poids de ménages calés sur des totaux de personnes
#   sum_i w_i * hhsize_i = P   par cellule (région actuelle x milieu, regroupée),
#                              par milieu actuel (national) et par quintile (national)
# ------------------------------------------------------------------------------

# calage = "standard" : région + zone x milieu + quintile (modèle de référence).
# calage = "grossier" : zone x milieu + quintile, sans la marge régionale. Repli
#   déclenché par run_all.R pour un mois dont le calage standard n'atteint pas
#   ses marges dans les bornes (trop peu de répondants dans une région).
MODELES_CALAGE <- list(
  standard = ~ hhsize:region_c + hhsize:zone_milieu + hhsize:quint - 1,
  grossier = ~ hhsize:zone_milieu + hhsize:quint - 1
)

caler <- function(d, regroupements, marges_trimestre, calage = "standard") {
  r <- d %>%
    filter(repondant) %>%
    left_join(regroupements %>% select(region_act, milieu_act, cellule_zone),
              by = c("region_act", "milieu_act")) %>%
    mutate(region_c = factor(region_act), zone_milieu = factor(cellule_zone),
           milieu_c = factor(milieu_act), quint = factor(quint), strate = factor(strate))
  if (anyNA(r$zone_milieu)) stop("Répondants sans cellule de calage : ", sum(is.na(r$zone_milieu)))

  # Totaux de population (projections du trimestre)
  m <- marges_trimestre %>%
    left_join(regroupements %>% distinct(region_act, milieu_act, cellule_zone),
              by = c("region" = "region_act", "milieu" = "milieu_act"))
  if (anyNA(m$cellule_zone)) stop("Régions des projections absentes de l'échantillon : ",
                                   paste(unique(m$region[is.na(m$cellule_zone)]), collapse = ", "))
  tot_region <- tapply(m$population, m$region, sum)
  tot_zone   <- tapply(m$population, m$cellule_zone, sum)
  tot_quint  <- setNames(rep(sum(m$population) / 5, 5), paste0("Q", 1:5))

  plan <- e.svydesign(data = as.data.frame(r), ids = ~grappe, strata = ~strate,
                      weights = ~w_nr, self.rep.str = NULL, check.data = TRUE)

  modele <- MODELES_CALAGE[[calage]]
  pop <- pop.template(data = plan, calmodel = modele)
  # Noms des colonnes du gabarit : « hhsize:region_cX », « hhsize:zone_milieuX », « hhsize:quintX »
  sources <- list(region_c = tot_region, zone_milieu = tot_zone, quint = tot_quint)
  for (nm in names(pop)) {
    for (f in names(sources)) {
      motif <- paste0("^hhsize:", f)
      if (grepl(motif, nm)) pop[[nm]] <- sources[[f]][[sub(motif, "", nm)]]
    }
  }
  if (anyNA(unlist(pop))) stop("Totaux de calage non renseignés : ", paste(names(pop)[is.na(unlist(pop))], collapse = ", "))

  cal <- e.calibrate(design = plan, df.population = pop, calfun = FONCTION_CALAGE,
                     bounds = BORNES_CALAGE, force = TRUE)
  g <- weights(cal) / weights(plan)
  list(plan = plan, cal = cal, totaux = pop, g = g, calage = calage,
       controle = check.cal(cal))
}

# ------------------------------------------------------------------------------
# Soldes et précision
# ------------------------------------------------------------------------------

estimer_soldes <- function(cal, methode = "ce") {
  extraire <- function(est, variable, domaine) {
    # Par domaine, SE() renvoie un data.frame et les noms sont « modalité:variable »
    co <- coef(est); se <- unlist(SE(est), use.names = FALSE); ic <- confint(est)
    tibble(variable = variable, domaine = domaine,
           modalite = if (domaine == "Ensemble") "Ensemble" else sub(":.*$", "", names(co)),
           solde = as.numeric(co), erreur_type = as.numeric(se),
           ic_bas = ic[, 1], ic_haut = ic[, 2])
  }

  bind_rows(lapply(names(VARIABLES_OPINION), function(v) {
    y <- as.formula(paste0("~", methode, "_", v))
    bind_rows(
      extraire(svystatTM(cal, y, estimator = "Mean", conf.int = TRUE, na.rm = TRUE), v, "Ensemble"),
      extraire(svystatTM(cal, y, by = ~milieu_c, estimator = "Mean", conf.int = TRUE, na.rm = TRUE), v, "Milieu"),
      extraire(svystatTM(cal, y, by = ~quint, estimator = "Mean", conf.int = TRUE, na.rm = TRUE), v, "Quintile")
    )
  })) %>% mutate(methode = methode, .before = 1)
}

solde_pondvf <- function(d, methode = "ce") {
  r <- d %>% filter(repondant, !is.na(pondvf))
  sapply(names(VARIABLES_OPINION), function(v) {
    s <- r[[paste0(methode, "_", v)]]; ok <- !is.na(s)
    sum(s[ok] * r$pondvf[ok]) / sum(r$pondvf[ok])
  })
}
