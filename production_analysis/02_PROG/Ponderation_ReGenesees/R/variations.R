# ==============================================================================
# Variations mensuelles des soldes d'opinion et leur précision
# ==============================================================================
# Deux mois consécutifs de l'ECV partagent une grande partie de leurs ménages
# (panel rotatif 3-9-3) et de leurs grappes. Les deux soldes ne sont donc pas
# indépendants : V(S2 - S1) = V1 + V2 - 2 Cov(S1, S2).
#
# Méthode principale : ReGenesees::svyDelta (Berger et Priam), comme dans le
# projet ENE_PRECISION_ESTIMATION. La covariance est estimée à partir des
# totaux par grappe des variables linéarisées et résidualisées par le calage.
# Les grappes sont alignées entre les deux mois par leur identifiant (grappe),
# la strate (région x milieu 2021) ne change pas d'un mois à l'autre
# (rho.STRAT = "noJump").
#
# Contrôles indépendants :
#   - covariance_a_la_main() : même covariance, calculée sans svyDelta, sur
#     l'union des grappes des deux mois (résidus de calage du plan complet) ;
#   - bootstrap_grappes()    : bootstrap de Rao-Wu des grappes, stratifié,
#     commun aux deux mois, qui rejoue le calage de chaque mois.
#
# Ce fichier suppose config.R et R/fonctions_ponderation.R déjà chargés.
# ==============================================================================

# ------------------------------------------------------------------------------
# Préparation des plans
# ------------------------------------------------------------------------------

charger_plan_cale <- function(id) {
  f <- chemin_mois(id, paste0("plan_cale_", id, ".rds"))
  if (!file.exists(f)) stop("Plan calé absent : ", f, " (lancer run_all.R)")
  readRDS(f)
}

# svyDelta refuse les valeurs manquantes (NA.estvars, draconian = TRUE). Le
# solde est donc écrit comme un ratio de deux totaux :
#   solde = sum(w * s) / sum(w * r),  s = score (0 si « ne sait pas »),
#                                     r = 1 si le score est renseigné.
# C'est exactement la moyenne avec « ne sait pas » exclu.
ajouter_variables_ratio <- function(plan, methodes = c("ce", "insee")) {
  for (m in methodes) for (v in names(VARIABLES_OPINION)) {
    s <- plan$variables[[paste0(m, "_", v)]]
    plan$variables[[paste0("sc_", m, "_", v)]] <- ifelse(is.na(s), 0, s)
    plan$variables[[paste0("nn_", m, "_", v)]] <- as.numeric(!is.na(s))
  }
  plan$variables$ensemble <- factor("Ensemble")
  plan$variables$milieu_c <- factor(as.character(plan$variables$milieu_c))
  plan$variables$quint <- factor(as.character(plan$variables$quint), levels = paste0("Q", 1:5))
  plan
}

# ------------------------------------------------------------------------------
# Recouvrement entre deux mois
# ------------------------------------------------------------------------------

lire_poids <- function(id) {
  read.csv(chemin_mois(id, paste0("poids_", id, ".csv")), fileEncoding = "UTF-8")
}

# Recouvrement aux trois niveaux : grappes, ménages tirés, ménages répondants.
mesurer_recouvrement <- function(id1, id2) {
  a <- lire_poids(id1); b <- lire_poids(id2)
  ra <- a[a$repondant, ]; rb <- b[b$repondant, ]
  ligne <- function(niveau, x1, x2) {
    nc <- length(intersect(x1, x2))
    tibble(niveau = niveau, n_mois_1 = length(x1), n_mois_2 = length(x2), communs = nc,
           part_mois_1 = nc / length(x1), part_mois_2 = nc / length(x2),
           taux_recouvrement = nc / mean(c(length(x1), length(x2))))
  }
  # Strates des grappes communes : un saut de strate invaliderait noJump
  sg <- inner_join(distinct(ra, grappe, strate), distinct(rb, grappe, strate), by = "grappe")
  sauts <- sum(sg$strate.x != sg$strate.y)

  resume <- bind_rows(
    ligne("Grappes tirées", unique(a$grappe), unique(b$grappe)),
    ligne("Grappes avec au moins un répondant", unique(ra$grappe), unique(rb$grappe)),
    ligne("Ménages tirés", a$hhid, b$hhid),
    ligne("Ménages répondants", ra$hhid, rb$hhid)
  ) %>% mutate(sauts_de_strate = c(NA, sauts, NA, NA))

  # Répondants communs : dans des grappes communes, part des répondants du mois
  # qui sont aussi répondants de l'autre mois
  rep_communs <- intersect(ra$hhid, rb$hhid)
  g_communes <- intersect(ra$grappe, rb$grappe)
  par_grappe <- tibble(
    mois = c(id1, id2),
    repondants = c(nrow(ra), nrow(rb)),
    repondants_dans_grappes_communes = c(sum(ra$grappe %in% g_communes), sum(rb$grappe %in% g_communes)),
    repondants_communs = length(rep_communs),
    repondants_par_grappe = c(nrow(ra) / n_distinct(ra$grappe), nrow(rb) / n_distinct(rb$grappe))
  )

  # Transitions de rang des ménages tirés les deux mois, et statut de réponse
  m <- inner_join(a, b, by = "hhid", suffix = c("_1", "_2"))
  transitions <- m %>%
    count(rang_1, rang_2, repondant_1, repondant_2, name = "menages") %>%
    arrange(rang_1, rang_2, desc(repondant_1), desc(repondant_2))
  rangs <- full_join(count(a, rang, name = paste0("tires_", id1)),
                     count(b, rang, name = paste0("tires_", id2)), by = "rang") %>% arrange(rang)

  list(resume = resume, par_grappe = par_grappe, transitions = transitions, rangs = rangs)
}

# ------------------------------------------------------------------------------
# Méthode principale : svyDelta
# ------------------------------------------------------------------------------

# Variation S2 - S1 d'un solde, par domaine, avec la covariance Berger-Priam.
# Le domaine est celui du mois considéré (milieu actuel de chaque mois ; le
# quintile est fixe).
variation_svydelta <- function(p1, p2, variable, methode = "ce", domaine = "ensemble",
                               rho_strat = "noJump") {
  s <- paste0("sc_", methode, "_", variable); n <- paste0("nn_", methode, "_", variable)
  expr <- parse(text = sprintf("%s.2 / %s.2 - %s.1 / %s.1", s, n, s, n))
  res <- suppressWarnings(svyDelta(expr, p1, p2, by = as.formula(paste0("~", domaine)),
                                   rho.STRAT = rho_strat, vartype = "se"))
  det <- attr(res, "details")
  tibble(modalite = as.character(det[[domaine]]),
         variation = as.numeric(res[[2]]),
         n_psu_1 = det$n1, n_psu_2 = det$n2, n_psu_communs = det$nc,
         recouvrement_psu = det$overlap,
         v1 = det$V1, v2 = det$V2, rho = det$rho, covariance = det$CoV,
         v_independance = det$Vind, v_delta = det$V)
}

estimer_variations_svydelta <- function(p1, p2, methodes = c("ce", "insee"),
                                        domaines = c(Ensemble = "ensemble", Milieu = "milieu_c",
                                                     Quintile = "quint"),
                                        rho_strat = "noJump") {
  grille <- expand.grid(methode = methodes, variable = names(VARIABLES_OPINION),
                        domaine = names(domaines), stringsAsFactors = FALSE)
  bind_rows(lapply(seq_len(nrow(grille)), function(k) {
    g <- grille[k, ]
    variation_svydelta(p1, p2, g$variable, g$methode, domaines[[g$domaine]], rho_strat) %>%
      mutate(methode = g$methode, variable = g$variable, domaine = g$domaine, .before = 1)
  }))
}

# Soldes de chaque mois (mêmes estimations que soldes_<id>.csv, via le ratio)
soldes_mois <- function(plan, methodes = c("ce", "insee"),
                        domaines = c(Ensemble = "ensemble", Milieu = "milieu_c", Quintile = "quint")) {
  w <- weights(plan); x <- plan$variables
  bind_rows(lapply(methodes, function(m) bind_rows(lapply(names(VARIABLES_OPINION), function(v) {
    bind_rows(lapply(names(domaines), function(d) {
      dom <- as.character(x[[domaines[[d]]]])
      num <- tapply(w * x[[paste0("sc_", m, "_", v)]], dom, sum)
      den <- tapply(w * x[[paste0("nn_", m, "_", v)]], dom, sum)
      tibble(methode = m, variable = v, domaine = d, modalite = names(num),
             solde = as.numeric(num / den), n_repondants = as.numeric(tapply(x[[paste0("nn_", m, "_", v)]], dom, sum)))
    }))
  }))))
}

# ------------------------------------------------------------------------------
# Contrôle 1 : covariance calculée à la main sur les résidus linéarisés
# ------------------------------------------------------------------------------

# Contributions par unité (grappe ou ménage) de la variable linéarisée du solde
# du domaine d, résidualisée par le calage sur le plan COMPLET (et non sur le
# sous-plan du domaine, comme le fait svyDelta) :
#   z_i = I_d(i) (s_i - S_d r_i) / sum_k w_k I_d(k) r_k ;  e_i = résidu de calage ;
#   u_j = sum_{i dans j} w_i e_i.
contributions_linearisees <- function(plan, variable, methode, domaine, modalite) {
  x <- plan$variables; w <- weights(plan)
  ind <- as.numeric(as.character(x[[domaine]]) == modalite)
  s <- x[[paste0("sc_", methode, "_", variable)]]; r <- x[[paste0("nn_", methode, "_", variable)]]
  den <- sum(w * ind * r); S <- sum(w * ind * s) / den
  plan$variables$z_lin <- ind * (s - S * r) / den
  e <- as.numeric(get.residuals(plan, ~z_lin, scale = "no"))
  tibble(hhid = x$hhid, grappe = x$grappe, strate = as.character(x$strate), we = w * e)
}

# Variance et covariance « cluster ultime » sur l'union des unités des deux mois :
# une unité absente d'un mois y a une contribution nulle.
#   C = sum_h n_h / (n_h - 1) sum_j (u1_hj - moy1_h) (u2_hj - moy2_h)
# Strate à une seule unité : centrage sur la moyenne générale (équivalent de
# l'option RG.lonely.psu = "adjust").
covariance_union <- function(c1, c2, unite = "grappe") {
  t1 <- c1 %>% group_by(id = .data[[unite]], strate) %>% summarise(u1 = sum(we), .groups = "drop")
  t2 <- c2 %>% group_by(id = .data[[unite]], strate) %>% summarise(u2 = sum(we), .groups = "drop")
  u <- full_join(t1, t2, by = c("id", "strate")) %>%
    mutate(u1 = coalesce(u1, 0), u2 = coalesce(u2, 0))
  moy1 <- mean(u$u1); moy2 <- mean(u$u2)
  st <- u %>% group_by(strate) %>%
    mutate(nh = n(), c1c = ifelse(nh > 1, u1 - mean(u1), u1 - moy1),
           c2c = ifelse(nh > 1, u2 - mean(u2), u2 - moy2),
           f = ifelse(nh > 1, nh / (nh - 1), 1)) %>% ungroup()
  c(v1 = sum(st$f * st$c1c^2), v2 = sum(st$f * st$c2c^2), cov = sum(st$f * st$c1c * st$c2c),
    n_unites = nrow(u), n_communes = sum(u$id %in% t1$id & u$id %in% t2$id))
}

# Variance cluster ultime d'un seul mois (contrôle de cohérence avec ReGenesees)
variance_mois <- function(c1) {
  t1 <- c1 %>% group_by(grappe, strate) %>% summarise(u = sum(we), .groups = "drop")
  moy <- mean(t1$u)
  t1 %>% group_by(strate) %>%
    mutate(nh = n(), cc = ifelse(nh > 1, u - mean(u), u - moy), f = ifelse(nh > 1, nh / (nh - 1), 1)) %>%
    ungroup() %>% summarise(v = sum(f * cc^2)) %>% pull(v)
}

# Part du produit croisé non centré sum_j u1_j u2_j qui vient des MÊMES ménages
# (sum_i w1_i e1_i w2_i e2_i sur les répondants communs) ; le reste vient de
# ménages différents d'une même grappe.
part_meme_menage <- function(c1, c2) {
  meme <- inner_join(c1, c2, by = "hhid", suffix = c("1", "2"))
  t1 <- c1 %>% group_by(grappe) %>% summarise(u1 = sum(we))
  t2 <- c2 %>% group_by(grappe) %>% summarise(u2 = sum(we))
  total <- inner_join(t1, t2, by = "grappe") %>% summarise(s = sum(u1 * u2)) %>% pull(s)
  sum(meme$we1 * meme$we2) / total
}

covariance_a_la_main <- function(p1, p2, methodes = c("ce", "insee"),
                                 domaines = c(Ensemble = "ensemble", Milieu = "milieu_c",
                                              Quintile = "quint")) {
  grille <- expand.grid(methode = methodes, variable = names(VARIABLES_OPINION),
                        domaine = names(domaines), stringsAsFactors = FALSE)
  bind_rows(lapply(seq_len(nrow(grille)), function(k) {
    g <- grille[k, ]; dv <- domaines[[g$domaine]]
    modalites <- intersect(unique(as.character(p1$variables[[dv]])), unique(as.character(p2$variables[[dv]])))
    bind_rows(lapply(sort(modalites), function(mo) {
      c1 <- contributions_linearisees(p1, g$variable, g$methode, dv, mo)
      c2 <- contributions_linearisees(p2, g$variable, g$methode, dv, mo)
      gr <- covariance_union(c1, c2, "grappe")
      mn <- covariance_union(c1, c2, "hhid")
      # Corrélation individuelle (non pondérée) des scores des répondants communs,
      # présents dans le domaine les deux mois. Ordre de grandeur attendu :
      # rho de l'estimateur ~ (n_communs / sqrt(n1 n2)) x cette corrélation.
      sc <- paste0(g$methode, "_", g$variable)
      cm <- inner_join(p1$variables[as.character(p1$variables[[dv]]) == mo, c("hhid", sc)],
                       p2$variables[as.character(p2$variables[[dv]]) == mo, c("hhid", sc)], by = "hhid")
      ok <- complete.cases(cm)
      tibble(methode = g$methode, variable = g$variable, domaine = g$domaine, modalite = mo,
             v1_main = variance_mois(c1), v2_main = variance_mois(c2),
             rho_main_grappes = gr[["cov"]] / sqrt(gr[["v1"]] * gr[["v2"]]),
             rho_main_menages = mn[["cov"]] / sqrt(mn[["v1"]] * mn[["v2"]]),
             part_meme_menage = part_meme_menage(c1, c2),
             n_repondants_communs = sum(ok),
             cor_scores_communs = if (sum(ok) > 2) cor(cm[[2]][ok], cm[[3]][ok]) else NA_real_)
    }))
  }))
}

# ------------------------------------------------------------------------------
# Contrôle 2 : bootstrap de grappes stratifié, apparié entre les deux mois
# ------------------------------------------------------------------------------

# Totaux de calage d'un mois, relus dans diagnostics_<id>.xlsx (feuille
# totaux_calage) : ce sont les cibles exactes utilisées par caler().
lire_totaux_calage <- function(id) {
  t <- read.xlsx(chemin_mois(id, paste0("diagnostics_", id, ".xlsx")), sheet = "totaux_calage")
  setNames(t$total, t$contrainte)
}

# Recalage d'un mois avec des poids initiaux w_nr * a (a = multiplicateur
# bootstrap de la grappe). Mêmes modèle, fonction et bornes que caler().
recaler <- function(x, a_grappe, totaux) {
  x$w_b <- x$w_nr * a_grappe[as.character(x$grappe)]
  x <- x[x$w_b > 0, , drop = FALSE]
  x$region_c <- droplevels(x$region_c); x$zone_milieu <- droplevels(x$zone_milieu)
  x$quint <- droplevels(x$quint); x$strate <- droplevels(factor(x$strate))
  plan <- e.svydesign(data = x, ids = ~grappe, strata = ~strate, weights = ~w_b,
                      self.rep.str = NULL, check.data = FALSE)
  # Modèle du mois : sans marge régionale si le mois a été calé en repli « grossier »
  modele <- if (any(grepl("^hhsize:region_c", names(totaux)))) MODELES_CALAGE$standard else MODELES_CALAGE$grossier
  pop <- pop.template(data = plan, calmodel = modele)
  manquants <- setdiff(names(pop), names(totaux))
  if (length(manquants)) stop("Contraintes sans total : ", paste(manquants, collapse = ", "))
  for (nm in names(pop)) pop[[nm]] <- totaux[[nm]]
  cal <- suppressWarnings(e.calibrate(design = plan, df.population = pop, calfun = FONCTION_CALAGE,
                                      bounds = BORNES_CALAGE, force = TRUE))
  list(variables = cal$variables, w = weights(cal),
       cellules_perdues = length(totaux) - length(pop))
}

# Soldes (toutes méthodes, variables, domaines) d'un jeu de poids, en vecteur nommé
soldes_vecteur <- function(x, w, methodes, domaines) {
  out <- c()
  for (m in methodes) for (v in names(VARIABLES_OPINION)) for (d in names(domaines)) {
    dom <- as.character(x[[domaines[[d]]]])
    num <- tapply(w * x[[paste0("sc_", m, "_", v)]], dom, sum)
    den <- tapply(w * x[[paste0("nn_", m, "_", v)]], dom, sum)
    out[paste(m, v, d, names(num), sep = "|")] <- num / den
  }
  out
}

# Bootstrap de Rao-Wu (m_h = n_h - 1) sur l'union des grappes répondantes des
# deux mois, strate par strate. Le même tirage de grappes s'applique aux deux
# mois : c'est ce qui reproduit la covariance due aux grappes (et donc aux
# ménages) communes. Le facteur de non-réponse n'est pas rejoué (w_nr fixe,
# comme dans la linéarisation).
bootstrap_grappes <- function(p1, p2, totaux1, totaux2, B = 500, graine = 20260701,
                              methodes = c("ce", "insee"),
                              domaines = c(Ensemble = "ensemble", Milieu = "milieu_c",
                                           Quintile = "quint")) {
  x1 <- p1$variables; x2 <- p2$variables
  union <- bind_rows(distinct(x1, grappe, strate), distinct(x2, grappe, strate)) %>%
    mutate(grappe = as.character(grappe), strate = as.character(strate)) %>% distinct()
  par_strate <- split(union$grappe, union$strate)
  set.seed(graine)
  reps <- vector("list", B); perdues <- 0L; echecs <- 0L
  for (b in seq_len(B)) {
    a <- unlist(lapply(par_strate, function(g) {
      nh <- length(g)
      if (nh == 1) return(setNames(1, g))  # strate à une grappe : pas de variabilité
      tirage <- table(factor(sample(g, nh - 1, replace = TRUE), levels = g))
      setNames(as.numeric(tirage) * nh / (nh - 1), g)
    }), use.names = FALSE)
    names(a) <- unlist(lapply(par_strate, identity), use.names = FALSE)
    r <- tryCatch({
      c1 <- recaler(x1, a, totaux1); c2 <- recaler(x2, a, totaux2)
      perdues <- perdues + c1$cellules_perdues + c2$cellules_perdues
      list(m1 = soldes_vecteur(c1$variables, c1$w, methodes, domaines),
           m2 = soldes_vecteur(c2$variables, c2$w, methodes, domaines))
    }, error = function(e) NULL)
    if (is.null(r)) { echecs <- echecs + 1L; next }
    reps[[b]] <- r
  }
  reps <- Filter(Negate(is.null), reps)
  cles <- Reduce(intersect, lapply(reps, function(r) intersect(names(r$m1), names(r$m2))))
  M1 <- do.call(rbind, lapply(reps, function(r) r$m1[cles]))
  M2 <- do.call(rbind, lapply(reps, function(r) r$m2[cles]))
  D <- M2 - M1
  morceaux <- do.call(rbind, strsplit(cles, "|", fixed = TRUE))
  res <- tibble(methode = morceaux[, 1], variable = morceaux[, 2], domaine = morceaux[, 3],
                modalite = morceaux[, 4],
                se1_boot = apply(M1, 2, sd), se2_boot = apply(M2, 2, sd),
                rho_boot = sapply(seq_along(cles), function(k) cor(M1[, k], M2[, k])),
                se_delta_boot = apply(D, 2, sd))
  attr(res, "replications") <- length(reps)
  attr(res, "echecs") <- echecs
  attr(res, "cellules_perdues") <- perdues
  res
}

# ------------------------------------------------------------------------------
# Tableau final
# ------------------------------------------------------------------------------

assembler_variations <- function(delta, soldes1, soldes2, id1, id2, main = NULL, boot = NULL) {
  q90 <- qnorm(0.95); q95 <- qnorm(0.975)
  t <- delta %>%
    left_join(soldes1 %>% select(methode, variable, domaine, modalite, solde_1 = solde, n_rep_1 = n_repondants),
              by = c("methode", "variable", "domaine", "modalite")) %>%
    left_join(soldes2 %>% select(methode, variable, domaine, modalite, solde_2 = solde, n_rep_2 = n_repondants),
              by = c("methode", "variable", "domaine", "modalite")) %>%
    mutate(mois_1 = id1, mois_2 = id2,
           libelle = unname(VARIABLES_OPINION[variable]),
           se_1 = sqrt(v1), se_2 = sqrt(v2),
           se_independance = sqrt(v_independance), se_covariance = sqrt(pmax(v_delta, 0)),
           gain_variance = 1 - v_delta / v_independance,
           z_independance = variation / se_independance, z_covariance = variation / se_covariance,
           ic95_bas = variation - q95 * se_covariance, ic95_haut = variation + q95 * se_covariance,
           p_valeur = 2 * pnorm(-abs(z_covariance)),
           significatif_90 = abs(z_covariance) > q90, significatif_95 = abs(z_covariance) > q95,
           significatif_90_independance = abs(z_independance) > q90,
           significatif_95_independance = abs(z_independance) > q95)
  # Variantes : même V1 et V2, mais corrélation issue du calcul à la main
  # (résidus du plan complet, plus fidèle pour les domaines non planifiés) ou
  # SE directement issue du bootstrap.
  if (!is.null(main)) {
    t <- left_join(t, main, by = c("methode", "variable", "domaine", "modalite")) %>%
      mutate(se_covariance_main = sqrt(pmax(v1 + v2 - 2 * rho_main_grappes * sqrt(v1 * v2), 0)),
             z_covariance_main = variation / se_covariance_main)
  }
  if (!is.null(boot)) {
    t <- left_join(t, boot, by = c("methode", "variable", "domaine", "modalite")) %>%
      mutate(z_bootstrap = variation / se_delta_boot)
  }
  t %>% select(mois_1, mois_2, methode, variable, libelle, domaine, modalite, n_rep_1, n_rep_2,
               solde_1, solde_2, variation, se_1, se_2, se_independance, se_covariance, rho, covariance,
               gain_variance, z_independance, z_covariance, ic95_bas, ic95_haut, p_valeur,
               significatif_90, significatif_95, significatif_90_independance, significatif_95_independance,
               n_psu_1, n_psu_2, n_psu_communs, recouvrement_psu, everything())
}
