# ==============================================================================
# Bulletin ECV — règles de commentaire et mise en forme
# ==============================================================================
# Règle de commentaire des évolutions (z = variation / erreur type avec covariance) :
#   |z| < 1,645          -> « stable »            (non significatif à 90 %)
#   1,645 <= |z| < 1,96  -> « légère hausse »      (significatif à 90 %, pas à 95 %)
#   1,96 <= |z| < 3,29   -> « hausse »             (significatif à 95 %)
#   |z| >= 3,29          -> « nette hausse »       (significatif à 99,9 %)
# Les soldes sont présentés en points (solde x 100).

SEUILS_Z <- c(leger = qnorm(0.95), signif = qnorm(0.975), net = qnorm(0.9995))

# type « pression » : un solde en hausse traduit une tension accrue sur les ménages
# type « situation » : un solde en hausse traduit une amélioration
# objet : complément de « le solde d'opinion sur … » ;
# sujet / pluriel : sujet de la phrase de synthèse (« l'endettement augmente »).
THEMES <- tibble::tribble(
  ~variable,            ~nom_court,                           ~type,       ~theme,                          ~objet,                                         ~sujet,                                        ~pluriel,
  "Cherte_vie",         "Coût de la vie",                     "pression",  "Coût de la vie et prix",        "l'évolution du coût de la vie",                "la perception du coût de la vie",             FALSE,
  "evolution_prix",     "Prix par rapport au mois précédent", "pression",  "Coût de la vie et prix",        "l'évolution des prix par rapport au mois précédent", "la perception de hausse des prix",       FALSE,
  "dynamique_prix",     "Prix sur les trois derniers mois",   "pression",  "Coût de la vie et prix",        "l'évolution des prix sur les trois derniers mois", "la perception des prix sur trois mois",   FALSE,
  "variation_depenses", "Dépenses du ménage",                 "pression",  "Dépenses et endettement",       "l'évolution des dépenses du ménage",           "les dépenses perçues",                        TRUE,
  "endettement",        "Endettement",                        "pression",  "Dépenses et endettement",       "la dynamique de la dette",                     "l'endettement",                               FALSE,
  "Situation_fin",      "Situation financière du ménage",     "situation", "Situation des ménages",         "la situation financière du ménage",            "la situation financière des ménages",         FALSE,
  "RE1_revenu",         "Revenu futur",                       "situation", "Situation des ménages",         "l'évolution future du revenu",                 "les anticipations de revenu",                 TRUE,
  "Situation_eco",      "Situation économique nationale",     "situation", "Situation économique du pays",  "la situation économique nationale",            "l'opinion sur la situation du pays",          FALSE
)

# « 1 point », « 0 point », « 5 points »
mot_points <- function(x) ifelse(abs(round(100 * x)) <= 1, "point", "points")

MOIS_FR <- c("janvier", "février", "mars", "avril", "mai", "juin", "juillet",
             "août", "septembre", "octobre", "novembre", "décembre")
libelle_mois <- function(id) {
  m <- as.integer(substr(id, 6, 7)); paste(MOIS_FR[m], substr(id, 1, 4))
}

pts <- function(x, signe = TRUE, dec = 0) {
  r <- round(100 * x, dec)
  r[r == 0] <- 0                                  # évite « -0 »
  v <- formatC(r, format = "f", digits = dec, decimal.mark = ",")
  if (signe) v <- ifelse(r > 0, paste0("+", v), v)
  sub("^-", "−", v)                          # signe moins typographique
}

# Verdict d'une variation : niveau de significativité et mots à employer
verdict <- function(z, type) {
  a <- abs(z)
  niveau <- ifelse(a < SEUILS_Z["leger"], "stable",
            ifelse(a < SEUILS_Z["signif"], "leger",
            ifelse(a < SEUILS_Z["net"], "signif", "net")))
  sens <- ifelse(type == "pression",
                 ifelse(z > 0, "hausse", "baisse"),
                 ifelse(z > 0, "amélioration", "dégradation"))
  qualif <- dplyr::case_when(
    niveau == "stable" ~ "stabilité",
    niveau == "leger"  ~ paste("légère", sens),
    niveau == "signif" ~ sens,
    niveau == "net"    ~ paste("nette", sens)
  )
  phrase_test <- dplyr::case_when(
    niveau == "stable" ~ "n'est pas statistiquement significative",
    niveau == "leger"  ~ "n'est significative qu'au seuil de 90 %",
    TRUE               ~ "est statistiquement significative au seuil de 95 %"
  )
  tibble::tibble(niveau = unname(niveau), qualif = qualif, phrase_test = phrase_test)
}

# Tableau principal : une ligne par solde, national
tableau_national <- function(var, methode = "ce") {
  var %>%
    dplyr::filter(methode == !!methode, domaine == "Ensemble") %>%
    dplyr::inner_join(THEMES, by = "variable") %>%
    dplyr::mutate(verdict(z_covariance, type), marge95 = qnorm(0.975) * se_2) %>%
    # Période de référence différente de 3 mois pour l'un des deux mois : pas de verdict
    dplyr::mutate(
      comparable = !mapply(function(v, a, b) v %in% PERIODE_REFERENCE_NON_STANDARD[[a]] ||
                                             v %in% PERIODE_REFERENCE_NON_STANDARD[[b]],
                           variable, mois_1, mois_2),
      niveau      = ifelse(comparable, niveau, "nc"),
      qualif      = ifelse(comparable, qualif, "non comparable"),
      phrase_test = ifelse(comparable, phrase_test,
                           "n'est pas interprétable : la période de référence ne couvrait pas trois mois pour l'un des deux mois")
    ) %>%
    dplyr::arrange(match(variable, THEMES$variable))
}

# Phrase de commentaire d'un solde
# Les marges d'erreur ne figurent pas dans le texte (elles sont en annexe).
phrase_solde <- function(l, id1, id2) {
  debut <- sprintf("Le solde d'opinion sur %s s'établit à %s points en %s, contre %s en %s",
                   l$objet, pts(l$solde_2), libelle_mois(id2), pts(l$solde_1), libelle_mois(id1))
  sens <- ifelse(l$type == "pression", ifelse(l$variation > 0, "hausse", "baisse"),
                 ifelse(l$variation > 0, "amélioration", "dégradation"))
  fin <- dplyr::case_when(
    l$niveau == "stable" ~ " : l'opinion est restée stable, la variation observée n'étant pas statistiquement significative.",
    l$niveau == "leger"  ~ sprintf(", soit une légère %s de %s %s.",
                                   sens, pts(abs(l$variation), FALSE), mot_points(l$variation)),
    TRUE                 ~ sprintf(", soit une %s%s de %s %s, statistiquement significative.",
                                   ifelse(l$niveau == "net", "nette ", ""), sens,
                                   pts(abs(l$variation), FALSE), mot_points(l$variation))
  )
  paste0(debut, fin)
}

# Paragraphe d'un thème : les soldes stables sont regroupés en une seule phrase,
# chaque évolution significative a sa propre phrase.
texte_theme <- function(lignes, id1, id2) {
  m1 <- libelle_mois(id1); m2 <- libelle_mois(id2)
  st <- lignes[lignes$niveau == "stable", ]
  mv <- lignes[lignes$niveau != "stable", ]
  out <- character(0)
  if (nrow(st) == 1) out <- phrase_solde(st, id1, id2)
  if (nrow(st) > 1) {
    elems <- sprintf("sur %s (%s points en %s, contre %s en %s)", st$objet, pts(st$solde_2), m2, pts(st$solde_1), m1)
    elems[-1] <- sprintf("sur %s (%s points, contre %s)", st$objet[-1], pts(st$solde_2[-1]), pts(st$solde_1[-1]))
    out <- sprintf("Les soldes d'opinion %s sont restés stables, les variations observées n'étant pas statistiquement significatives.",
                   enumerer(elems))
  }
  c(out, vapply(seq_len(nrow(mv)), function(i) phrase_solde(mv[i, ], id1, id2), ""))
}

# ------------------------------------------------------------------------------
# Écarts entre catégories rédigés en prose (seuls les écarts significatifs)
# ------------------------------------------------------------------------------

# Ce que mesure chaque solde, pour la rédaction des écarts entre catégories
RESSENTI <- c(Cherte_vie = "la hausse du coût de la vie", evolution_prix = "la hausse des prix d'un mois sur l'autre",
              dynamique_prix = "la hausse des prix sur les trois derniers mois", variation_depenses = "la hausse de leurs dépenses",
              endettement = "la hausse de leur endettement", Situation_fin = "leur situation financière",
              RE1_revenu = "l'évolution future de leur revenu", Situation_eco = "la situation économique du pays")
GROUPE <- c(Urbain = "ménages urbains", Rural = "ménages ruraux",
            Q1 = "ménages les plus modestes", Q5 = "ménages les plus aisés")

phrase_ecart <- function(variable, type, a, b, sa, sb) {
  # a = groupe le plus touché : solde le plus élevé (pression) ou le plus bas (situation)
  plus_touche_a <- if (type == "pression") sa > sb else sa < sb
  if (!plus_touche_a) { t <- a; a <- b; b <- t; t <- sa; sa <- sb; sb <- t }
  if (type == "pression")
    sprintf("%s est plus fortement ressentie par les %s (%s points) que par les %s (%s points)",
            RESSENTI[[variable]], GROUPE[[a]], pts(sa), GROUPE[[b]], pts(sb))
  else
    sprintf("les %s portent un jugement plus défavorable sur %s que les %s (%s points contre %s)",
            GROUPE[[a]], RESSENTI[[variable]], GROUPE[[b]], pts(sa), pts(sb))
}

texte_ecarts <- function(e, mois_lib) {
  if (nrow(e) == 0)
    return(sprintf("En %s, les opinions ne diffèrent pas de façon statistiquement significative selon le milieu de résidence ni entre les ménages les plus modestes et les plus aisés.", mois_lib))
  cap <- function(x) paste0(toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)))
  paragraphe <- function(sel, intro) {
    if (nrow(sel) == 0) return(NULL)
    ph <- mapply(phrase_ecart, sel$variable, sel$type, sel$groupe_a, sel$groupe_b, sel$solde_a, sel$solde_b)
    # groupe le plus touché de chaque phrase : « De même » s'il est inchangé, « En revanche » sinon
    touche <- ifelse(ifelse(sel$type == "pression", sel$solde_a > sel$solde_b, sel$solde_a < sel$solde_b),
                     sel$groupe_a, sel$groupe_b)
    ph[1] <- paste0(intro, ph[1])
    if (length(ph) > 1) for (k in 2:length(ph))
      ph[k] <- paste0(if (touche[k] == touche[k - 1]) "De même, " else "En revanche, ", ph[k])
    paste0(paste(cap(ph), collapse = ". "), ".")
  }
  c(paragraphe(e[e$groupe_a == "Urbain", ], "selon le milieu de résidence, "),
    paragraphe(e[e$groupe_a == "Q1", ], "selon le niveau de vie, en comparant les 20 % de ménages les plus modestes et les 20 % les plus aisés, "),
    "Les autres écarts entre catégories de ménages ne sont pas statistiquement significatifs.")
}

# ------------------------------------------------------------------------------
# Évolution sur douze mois rédigée en prose
# ------------------------------------------------------------------------------
# tab12 : sortie de tableau_national() pour la paire (même mois de l'année précédente, mois courant).
# La variation est la différence des deux soldes ; seule sa significativité vient de svyDelta.
texte_annuel <- function(tab12, mois12, mois2, signif_seul = FALSE) {
  t <- tab12 %>% dplyr::filter(niveau != "nc")
  verbe <- function(l) {
    v <- if (l$type == "pression") {
      # « la perception de … s'accentue » plutôt que « augmente »
      if (grepl("^la perception", l$sujet)) ifelse(l$variation > 0, "s'accentue", "s'atténue")
      else ifelse(l$variation > 0, "augmente", "diminue")
    } else ifelse(l$variation > 0, "s'améliore", "se dégrade")
    if (l$pluriel) v <- sub("e$", "ent", v)
    adv <- switch(l$niveau, net = " nettement", leger = " légèrement", "")
    paste0(v, adv)
  }
  mouv <- t %>% dplyr::filter(if (signif_seul) niveau %in% c("signif", "net") else niveau != "stable") %>%
    dplyr::arrange(dplyr::desc(abs(z_covariance)))
  phrases <- vapply(seq_len(nrow(mouv)), function(i) {
    l <- mouv[i, ]
    sprintf("%s %s (%s points, contre %s un an plus tôt%s)", l$sujet, verbe(l), pts(l$solde_2), pts(l$solde_1),
            "")
  }, "")
  stables <- t$objet[t$niveau == "stable"]
  p1 <- if (length(phrases)) sprintf("Par rapport à %s, %s.", mois12, enumerer(phrases)) else
    sprintf("Par rapport à %s, aucune opinion n'évolue de façon statistiquement significative.", mois12)
  p2 <- if (!signif_seul && length(stables))
    sprintf("Les opinions sur %s sont restées stables sur un an, les variations observées n'étant pas statistiquement significatives.",
            enumerer(stables)) else NULL
  c(p1, p2)
}

# ------------------------------------------------------------------------------
# Messages principaux : titre-constat et chapô (communs aux deux bulletins)
# ------------------------------------------------------------------------------

enumerer <- function(x) if (length(x) <= 1) x else paste(paste(head(x, -1), collapse = ", "), "et", tail(x, 1))
de_article <- function(x) sub("^de les ", "des ", sub("^de le ", "du ", paste("de", x)))

# Verbe d'un mouvement significatif à 95 %, accordé avec le sujet
verbe_mouvement <- function(niveau, type, variation, pluriel, sujet = "") {
  v <- ifelse(type == "pression",
              ifelse(grepl("^la perception", sujet),
                     ifelse(variation > 0, "s'accentue", "s'atténue"),
                     ifelse(variation > 0, "augmente", "diminue")),
              ifelse(variation > 0, "s'améliore", "se dégrade"))
  v <- ifelse(pluriel, sub("e$", "ent", v), v)
  ifelse(niveau %in% c("signif", "net"), v, NA_character_)
}

messages_principaux <- function(tab, id1, id2) {
  m1 <- libelle_mois(id1); m2 <- libelle_mois(id2)
  cv <- tab[tab$variable == "Cherte_vie", ]
  mouvements <- tab %>%
    dplyr::mutate(verbe = verbe_mouvement(niveau, type, variation, pluriel, sujet)) %>%
    dplyr::filter(!is.na(verbe), variable != "Cherte_vie") %>%
    dplyr::arrange(dplyr::desc(abs(z_covariance)))
  debut <- if (cv$niveau == "stable") {
    sprintf("En %s, la perception de la cherté de la vie reste %s et stable", m2,
            ifelse(cv$solde_2 > 0.3, "élevée", "modérée"))
  } else sprintf("En %s, la perception de la cherté de la vie est en %s", m2, cv$qualif)
  titre <- paste0(debut, if (nrow(mouvements))
    paste0(" ; ", enumerer(paste(mouvements$sujet, mouvements$verbe))) else "")

  stables <- tab$nom_court[tab$niveau == "stable"]
  p1 <- sprintf(paste0("En %s, le solde d'opinion sur l'évolution du coût de la vie s'établit à %s points, contre %s en %s. ",
                       "Sur les %d soldes comparables à %s, %d n'évoluent pas de façon statistiquement significative (%s)."),
                m2, pts(cv$solde_2), pts(cv$solde_1), m1, sum(tab$niveau != "nc"), m1,
                length(stables), tolower(paste(stables, collapse = ", ")))
  p2 <- if (nrow(mouvements)) sprintf("En revanche, %s.", enumerer(paste(mouvements$sujet, mouvements$verbe,
          sprintf("(%s %s)", pts(mouvements$variation), mot_points(mouvements$variation))))) else NULL
  legers <- tab[tab$niveau == "leger", ]
  p3 <- if (nrow(legers)) sprintf("L'évolution %s n'est significative qu'au seuil de 90 %%.",
                                  enumerer(de_article(legers$sujet))) else NULL
  nc <- tab[tab$niveau == "nc", ]
  # Les soldes non comparables ne sont pas commentés (explication en annexe)
  list(titre = titre, chapo = c(p1, paste(c(p2, p3), collapse = " ")))
}

# Graphique de la série nationale : intervalles à 95 %, interruption grisée,
# points non comparables (période de référence de 4 mois) en creux.
graphique_serie <- function(serie, methode = "ce") {
  s <- serie %>%
    dplyr::filter(methode == !!methode, domaine == "Ensemble", !is.na(solde)) %>%
    dplyr::inner_join(THEMES %>% dplyr::select(variable, nom_court, type), by = "variable") %>%
    dplyr::mutate(date = as.Date(paste0(mois, "-15")),
                  nom_court = factor(nom_court, THEMES$nom_court),
                  segment = ifelse(mois < INTERRUPTION[["debut"]], "avant", "apres"),
                  comparable = ifelse(is.na(comparable), TRUE, comparable))
  gris <- as.Date(paste0(INTERRUPTION[c("debut", "fin")], "-01")) + c(0, 30)
  ggplot2::ggplot(s, ggplot2::aes(date, 100 * solde)) +
    ggplot2::annotate("rect", xmin = gris[1], xmax = gris[2], ymin = -Inf, ymax = Inf,
                      fill = "grey90") +
    ggplot2::geom_hline(yintercept = 0, colour = "grey40", linewidth = 0.3) +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = 100 * ic95_bas, ymax = 100 * ic95_haut, colour = type),
                           width = 8, alpha = 0.6) +
    ggplot2::geom_line(ggplot2::aes(group = segment, colour = type), linewidth = 0.6) +
    ggplot2::geom_point(ggplot2::aes(colour = type, shape = comparable), size = 1.8, fill = "white") +
    ggplot2::scale_shape_manual(values = c(`TRUE` = 16, `FALSE` = 21), guide = "none") +
    ggplot2::scale_colour_manual(values = c(pression = "#c0392b", situation = "#1f6fd1"), guide = "none") +
    ggplot2::scale_x_date(date_breaks = "3 months", date_labels = "%m/%y") +
    ggplot2::facet_wrap(~ nom_court, ncol = 2, scales = "free_y") +
    ggplot2::labs(x = NULL, y = "Solde d'opinion (points)") +
    ggplot2::theme_minimal(base_size = 9) +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank(),
                   strip.text = ggplot2::element_text(face = "bold"))
}

# Écarts entre groupes du mois courant (milieu, quintiles extrêmes) : seuls les écarts
# significatifs à 95 % sont commentés. Les groupes sont traités comme indépendants
# (approximation : domaines disjoints, covariance intra-grappe ignorée).
ecarts_groupes <- function(soldes, methode = "ce") {
  s <- soldes %>% dplyr::filter(methode == !!methode)
  paire <- function(dom, a, b) {
    x <- s %>% dplyr::filter(domaine == dom, modalite %in% c(a, b)) %>%
      dplyr::select(variable, modalite, solde, erreur_type) %>%
      tidyr::pivot_wider(names_from = modalite, values_from = c(solde, erreur_type))
    x %>% dplyr::transmute(variable, groupe_a = a, groupe_b = b,
                           solde_a = .data[[paste0("solde_", a)]], solde_b = .data[[paste0("solde_", b)]],
                           ecart = solde_a - solde_b,
                           z = ecart / sqrt(.data[[paste0("erreur_type_", a)]]^2 + .data[[paste0("erreur_type_", b)]]^2))
  }
  dplyr::bind_rows(paire("Milieu", "Urbain", "Rural"), paire("Quintile", "Q1", "Q5")) %>%
    dplyr::inner_join(THEMES %>% dplyr::select(variable, nom_court), by = "variable") %>%
    dplyr::mutate(significatif = abs(z) >= SEUILS_Z["signif"])
}
