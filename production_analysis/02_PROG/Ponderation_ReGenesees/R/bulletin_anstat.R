# ==============================================================================
# Bulletin ECV au format ANStat (officer)
# ==============================================================================
# On part du bulletin ANStat publié : sa page de garde (République, ministère,
# ANStat, logos, encadré titre), ses styles (Montserrat, « heading 1 »,
# « heading 2 », « caption ») et son style de tableau (« Plain Table 2 ») sont
# conservés ; le corps, à partir de « RESUME EXECUTIF », est remplacé.

library(officer, lib.loc = LIB_REGENESEES)
library(flextable, lib.loc = LIB_REGENESEES)

POLICE <- "Aptos Display"
DIRECTION <- "Direction des Données et de l’Innovation (DDI)"
SOURCE_ANSTAT <- "Source : ANStat-DDI, Enquête Cherté de la Vie (ECV) et EHCVM 2021"

# Aptos Display est une police « cloud » de Microsoft 365 : Word l'affiche, mais
# R doit en connaître les fichiers pour les graphiques (moteur ragg).
local({
  dossier <- file.path(Sys.getenv("LOCALAPPDATA"), "Microsoft/FontCache/4/CloudFonts/Aptos Display")
  f <- list.files(dossier, pattern = "\\.ttf$", full.names = TRUE)
  if (length(f) >= 4) {
    info <- systemfonts::font_info(path = f)
    choisir <- function(b, i) f[which(info$bold == b & info$italic == i)[1]]
    systemfonts::register_font(POLICE, plain = choisir(FALSE, FALSE), bold = choisir(TRUE, FALSE),
                               italic = choisir(FALSE, TRUE), bolditalic = choisir(TRUE, TRUE))
  } else {
    warning("Aptos Display introuvable : les graphiques utiliseront la police par défaut.")
  }
})
ggplot2::update_geom_defaults("text", list(family = POLICE))
ggplot2::update_geom_defaults("label", list(family = POLICE))

# Force la police dans les parties du .docx que officer ne touche pas : thème (polices
# par défaut), styles, numérotation des titres, en-têtes et pieds de page.
forcer_police_docx <- function(fichier, police = POLICE) {
  dossier <- file.path(tempdir(), paste0("docx_", as.integer(Sys.time())))
  utils::unzip(fichier, exdir = dossier)
  cibles <- list.files(file.path(dossier, "word"), pattern = "\\.xml$", recursive = TRUE, full.names = TRUE)
  for (f in cibles) {
    x <- readLines(f, encoding = "UTF-8", warn = FALSE)
    # uniquement les balises de police (w:rFonts), pas les autres attributs (w:lang…)
    x <- gsub("<w:rFonts\\b[^>]*/>",
              sprintf('<w:rFonts w:ascii="%1$s" w:hAnsi="%1$s" w:cs="%1$s" w:eastAsia="%1$s"/>', police), x, perl = TRUE)
    x <- gsub('<a:latin typeface="[^"]*"', paste0('<a:latin typeface="', police, '"'), x)   # thème
    writeLines(x, f, useBytes = TRUE)
  }
  fichiers <- list.files(dossier, recursive = TRUE, all.files = TRUE, include.dirs = FALSE)
  unlink(fichier)
  # zip::zip (et non zipr) conserve les chemins relatifs : word/, _rels/, [Content_Types].xml
  zip::zip(fichier, files = fichiers, root = dossier, mode = "mirror", include_directories = FALSE)
  unlink(dossier, recursive = TRUE)
  invisible(fichier)
}

# Applique la police à tout le document, y compris la page de garde issue du modèle
appliquer_police <- function(doc, police = POLICE) {
  for (rf in xml2::xml_find_all(docx_body_xml(doc), "//w:rFonts")) {
    for (a in c("w:ascii", "w:hAnsi", "w:cs", "w:eastAsia")) xml2::xml_set_attr(rf, a, police)
    for (a in c("w:asciiTheme", "w:hAnsiTheme", "w:cstheme", "w:eastAsiaTheme")) xml2::xml_set_attr(rf, a, NULL)
  }
  doc
}

# Palette : bleu marine institutionnel, orange ANStat, couleurs de lecture des évolutions
MARINE <- "#1F3864"; ORANGE_ANSTAT <- "#E8702A"; GRIS_TEXTE <- "#595959"
FOND_ZEBRE <- "#F2F4F8"; FOND_ENCADRE <- "#EEF2F8"; FOND_MESSAGE <- "#FDF1E9"
COUL_DEFAVORABLE <- "#B03A2E"; COUL_FAVORABLE <- "#1E8449"; COUL_NEUTRE <- "#7F8C8D"

TAILLE_TEXTE <- 11
fp <- function(size = TAILLE_TEXTE, bold = FALSE, italic = FALSE, color = "black")
  fp_text(font.family = POLICE, font.size = size, bold = bold, italic = italic, color = color)
par_just <- fp_par(text.align = "justify", padding.bottom = 6, line_spacing = 1.15)
par_titre <- function(avant = 12) fp_par(padding.top = avant, padding.bottom = 6, keep_with_next = TRUE)

# --- Éléments de mise en page -------------------------------------------------

# Titres de niveau 1 numérotés par Word (I., II. ; numérotation du modèle) ;
# titres de niveau 2 numérotés ici (1.1, 1.2…), pour repartir à chaque section.
.compteurs <- new.env(); .compteurs$h1 <- 0; .compteurs$h2 <- 0
ajouter_titre1 <- function(doc, txt) {
  .compteurs$h1 <- .compteurs$h1 + 1; .compteurs$h2 <- 0
  body_add_fpar(doc, fpar(ftext(toupper(txt), fp(12, TRUE, color = MARINE)), fp_p = par_titre(14)), style = "heading 1")
}
ajouter_titre2 <- function(doc, txt) {
  .compteurs$h2 <- .compteurs$h2 + 1
  num <- sprintf("%d.%d.  ", .compteurs$h1, .compteurs$h2)
  body_add_fpar(doc, fpar(ftext(num, fp(11.5, TRUE, color = ORANGE_ANSTAT)), ftext(txt, fp(11.5, TRUE, color = MARINE)),
                          fp_p = par_titre(10)), style = "heading 2")
}
ajouter_texte <- function(doc, txt, size = TAILLE_TEXTE, bold = FALSE)
  body_add_fpar(doc, fpar(ftext(txt, fp(size, bold)), fp_p = par_just), style = NULL)
# Paragraphe « intertitre en gras : texte »
ajouter_texte_gras <- function(doc, gras, txt, couleur = "black")
  body_add_fpar(doc, fpar(ftext(gras, fp(bold = TRUE, color = couleur)), ftext(txt, fp()), fp_p = par_just), style = NULL)
ajouter_puce <- function(doc, txt)
  body_add_fpar(doc, fpar(ftext("•  ", fp(color = ORANGE_ANSTAT, bold = TRUE)), ftext(txt, fp()),
                          fp_p = fp_par(text.align = "justify", padding.left = 16, padding.bottom = 3, line_spacing = 1.15)),
                style = NULL)
ajouter_legende <- function(doc, txt)
  body_add_fpar(doc, fpar(ftext(txt, fp(10.5, TRUE, color = MARINE)), fp_p = par_titre(12)), style = "caption")
ajouter_source <- function(doc, txt = SOURCE_ANSTAT)
  body_add_fpar(doc, fpar(ftext(txt, fp(8, TRUE, color = GRIS_TEXTE)), fp_p = fp_par(padding.bottom = 10)), style = NULL)
ajouter_note <- function(doc, txt)
  body_add_fpar(doc, fpar(ftext("Note de lecture : ", fp(8, TRUE, color = GRIS_TEXTE)), ftext(txt, fp(8, color = GRIS_TEXTE)),
                          fp_p = fp_par(text.align = "justify", padding.top = 2, keep_with_next = TRUE)), style = NULL)

# Graphique centré, inséré à haute résolution
ajouter_graphique <- function(doc, g, largeur, hauteur) {
  f <- tempfile(fileext = ".png")
  ggplot2::ggsave(f, g, width = largeur, height = hauteur, dpi = 300, bg = "white", device = ragg::agg_png)
  body_add_fpar(doc, fpar(external_img(f, width = largeur, height = hauteur),
                          fp_p = fp_par(text.align = "center", keep_with_next = TRUE)), style = NULL)
}

# Lecture d'une évolution : couleur et flèche (défavorable = tension accrue ou dégradation)
couleur_lecture <- function(niveau, type, variation) {
  defav <- (type == "pression" & variation > 0) | (type == "situation" & variation < 0)
  ifelse(niveau %in% c("stable", "nc"), COUL_NEUTRE, ifelse(defav, COUL_DEFAVORABLE, COUL_FAVORABLE))
}
fleche_lecture <- function(niveau, variation)
  ifelse(niveau == "nc", "–", ifelse(niveau == "stable", "►", ifelse(variation > 0, "▲", "▼")))

# Tableau au style de la publication : en-tête marine, lignes alternées, filet de pied
ajouter_tableau <- function(doc, df, taille = 9, couleurs_lecture = NULL, col_lecture = "Lecture", largeur_col1 = NULL,
                            largeurs = NULL) {
  ft <- flextable(df) %>%
    font(fontname = POLICE, part = "all") %>% fontsize(size = taille, part = "all") %>%
    bold(part = "header") %>% color(color = "white", part = "header") %>% bg(bg = MARINE, part = "header") %>%
    align(align = "center", part = "all") %>% align(j = 1, align = "left", part = "all") %>%
    valign(valign = "center", part = "all") %>%
    border_remove() %>%
    hline_bottom(border = fp_border(color = MARINE, width = 1.5), part = "body") %>%
    padding(padding.top = 3, padding.bottom = 3, padding.left = 4, padding.right = 4, part = "all") %>%
    bold(j = 1, part = "body")
  if (nrow(df) > 1) ft <- bg(ft, i = seq(2, nrow(df), 2), bg = FOND_ZEBRE, part = "body")
  # couleurs_lecture : vecteur (colonne col_lecture) ou liste nommée colonne -> couleurs
  if (!is.null(couleurs_lecture) && !is.list(couleurs_lecture)) couleurs_lecture <- setNames(list(couleurs_lecture), col_lecture)
  for (cl in intersect(names(couleurs_lecture), names(df)))
    ft <- ft %>% color(j = cl, color = couleurs_lecture[[cl]], part = "body") %>% bold(j = cl, part = "body")
  if (!is.null(largeurs)) {
    # largeurs fixées (en pouces) : évite les retours à la ligne dans les cellules courtes
    ft <- ft %>% set_table_properties(layout = "fixed") %>% width(width = largeurs)
  } else {
    ft <- set_table_properties(ft, layout = "autofit", width = 1)
    if (!is.null(largeur_col1)) ft <- width(ft, j = 1, width = largeur_col1)
  }
  body_add_flextable(doc, ft, align = "center")
}

# Encadré : titre et paragraphes sur fond bleu clair, filet marine à gauche
ajouter_encadre <- function(doc, titre, lignes, fond = FOND_ENCADRE, filet = MARINE, taille = 9.5) {
  contenu <- do.call(as_paragraph, c(
    list(as_chunk(paste0(titre, "\n"), props = fp(taille + 1, TRUE, color = filet))),
    lapply(seq_along(lignes), function(i) as_chunk(paste0(lignes[i], if (i < length(lignes)) "\n" else ""), props = fp(taille)))))
  ft <- flextable(data.frame(x = "")) %>% delete_part(part = "header") %>%
    compose(j = 1, i = 1, value = contenu) %>%
    bg(bg = fond) %>% border_remove() %>%
    border(border.left = fp_border(color = filet, width = 4)) %>%
    padding(padding = 8) %>% align(align = "left") %>% line_spacing(space = 1.15) %>%
    set_table_properties(layout = "fixed") %>% width(width = 6.6)
  body_add_flextable(doc, ft, align = "center")
}

# Message principal du bulletin, mis en valeur
ajouter_message <- function(doc, txt) {
  ft <- flextable(data.frame(x = txt)) %>% delete_part(part = "header") %>%
    font(fontname = POLICE) %>% fontsize(size = 12.5) %>% bold() %>% color(color = MARINE) %>%
    bg(bg = FOND_MESSAGE) %>% border_remove() %>%
    border(border.left = fp_border(color = ORANGE_ANSTAT, width = 5)) %>%
    padding(padding = 10) %>% align(align = "left") %>%
    set_table_properties(layout = "fixed") %>% width(width = 6.6)
  body_add_flextable(doc, ft, align = "center")
}

# Garde la page de garde du modèle, met le mois à jour, supprime le corps
preparer_modele <- function(fichier_modele, mois_modele, mois_nouveau) {
  doc <- read_docx(fichier_modele)
  doc <- body_replace_all_text(doc, mois_modele, mois_nouveau, fixed = TRUE)
  enfants <- xml2::xml_children(xml2::xml_find_first(docx_body_xml(doc), "w:body"))
  # Numérotation des titres du bulletin publié (I., II. ; 2.1…), portée par les paragraphes
  num <- lapply(c(Titre1 = "Titre1", Titre2 = "Titre2"), function(st) {
    n <- xml2::xml_find_first(docx_body_xml(doc), sprintf("//w:p[w:pPr/w:pStyle[@w:val='%s']]/w:pPr/w:numPr", st))
    if (inherits(n, "xml_missing")) NULL else as.character(n)
  })
  NUMEROTATION_TITRES <<- num
  debut <- which(xml2::xml_text(enfants) == "RESUME EXECUTIF")[1]
  if (is.na(debut)) stop("« RESUME EXECUTIF » introuvable dans le modèle ANStat.")
  n_a_supprimer <- length(enfants) - debut          # le dernier enfant est w:sectPr, conservé
  # body_remove supprime l'élément sous le curseur et garde le curseur synchronisé
  doc <- cursor_reach(doc, "^RESUME EXECUTIF$")
  for (i in seq_len(n_a_supprimer)) doc <- body_remove(doc)
  cursor_end(doc)
}

# Titres et légendes « gardés avec le paragraphe suivant » (keepNext) : avec un style
# imposé, officer n'applique pas fp_par, d'où l'ajout direct dans le XML.
garder_avec_suivant <- function(doc, styles = c("Titre1", "Titre2", "Lgende")) {
  corps <- docx_body_xml(doc)
  cond <- paste(sprintf("@w:val='%s'", styles), collapse = " or ")
  for (ppr in xml2::xml_find_all(corps, sprintf("//w:p/w:pPr[w:pStyle[%s]]", cond))) {
    # juste après w:pStyle (premier enfant) et avant w:numPr, comme l'exige le schéma Word
    if (inherits(xml2::xml_find_first(ppr, "w:keepNext"), "xml_missing"))
      xml2::xml_add_child(ppr, "w:keepNext", .where = 1)
  }
  doc
}

# Applique aux nouveaux titres la numérotation relevée dans le modèle
appliquer_numerotation <- function(doc, num = NUMEROTATION_TITRES) {
  corps <- docx_body_xml(doc)
  # Niveau 2 : numérotation automatique désactivée (numId 0), le numéro est écrit dans le texte
  num$Titre2 <- '<w:numPr><w:ilvl w:val="0"/><w:numId w:val="0"/></w:numPr>'
  for (st in names(num)) {
    if (is.null(num[[st]])) next
    for (p in xml2::xml_find_all(corps, sprintf("//w:p[w:pPr/w:pStyle[@w:val='%s']]", st))) {
      ppr <- xml2::xml_find_first(p, "w:pPr")
      xml2::xml_remove(xml2::xml_find_all(ppr, "w:numPr"))
      noeud <- xml2::read_xml(sub("<w:numPr", "<w:numPr xmlns:w=\"http://schemas.openxmlformats.org/wordprocessingml/2006/main\"",
                                  num[[st]], fixed = TRUE))
      xml2::xml_add_child(ppr, noeud, .where = 1)
    }
  }
  doc
}

# --- Graphiques au style du bulletin publié -----------------------------------
# Repris des graphiques d'origine : courbe principale épaisse et étiquetée, autres
# séries en gris en fond, titres de panneau en majuscules colorés, interruption
# grisée, raccord en pointillé. Ajouts : intervalle de confiance discret et point
# creux pour la période de référence de quatre mois.

ORANGE <- "#e8702a"; ROUGE <- "#d62728"; BLEU <- "#1f6fd1"; GRIS <- "#c8c8c8"
MOIS_COURT <- c("Jan", "Fév", "Mar", "Avr", "Mai", "Juin", "Juil", "Août", "Sep", "Oct", "Nov", "Déc")

# Position d'un mois sur l'axe : 0 = février 2025
idx_mois <- function(m) (as.integer(substr(m, 1, 4)) - 2025) * 12 + as.integer(substr(m, 6, 7)) - 2
axe_mois <- function(dernier) {
  i <- 0:idx_mois(dernier)
  annee <- 2025 + (i + 1) %/% 12; mois <- (i + 1) %% 12 + 1
  lab <- MOIS_COURT[mois]
  lab[i == 0 | mois == 1] <- paste0(lab[i == 0 | mois == 1], "\n", annee[i == 0 | mois == 1])
  list(breaks = i, labels = lab, gris = i >= idx_mois(INTERRUPTION[["debut"]]) & i <= idx_mois(INTERRUPTION[["fin"]]))
}

preparer_serie_graphique <- function(serie, methode = "ce") {
  serie %>%
    dplyr::filter(methode == !!methode, domaine == "Ensemble", !is.na(solde)) %>%
    dplyr::inner_join(THEMES %>% dplyr::select(variable, nom_court, type), by = "variable") %>%
    dplyr::mutate(x = idx_mois(mois), y = 100 * solde,
                  bas = 100 * ic95_bas, haut = 100 * ic95_haut,
                  segment = ifelse(mois < INTERRUPTION[["debut"]], "avant", "apres"),
                  comparable = ifelse(is.na(comparable), TRUE, comparable))
}
# Raccord en pointillé entre le dernier mois avant et le premier mois après l'interruption
raccords <- function(s) s %>% dplyr::group_by(variable) %>%
  dplyr::summarise(x0 = max(x[segment == "avant"]), x1 = min(x[segment == "apres"]),
                   y0 = y[x == x0], y1 = y[x == x1], .groups = "drop") %>%
  dplyr::transmute(variable, x = x0, xend = x1, y = y0, yend = y1)

fond_commun <- function(p, ax, taille = 9) {
  zone <- range(ax$breaks[ax$gris])
  p + ggplot2::annotate("rect", xmin = zone[1] - 0.5, xmax = zone[2] + 0.5, ymin = -Inf, ymax = Inf, fill = "#e6e6e1") +
    ggplot2::geom_hline(yintercept = 0, colour = "black", linewidth = 0.5) +
    ggplot2::scale_x_continuous(breaks = ax$breaks, labels = ax$labels, expand = ggplot2::expansion(add = 0.6)) +
    ggplot2::scale_y_continuous(limits = c(-40, 100), breaks = seq(-40, 100, 20)) +
    ggplot2::labs(x = NULL, y = NULL) +
    ggplot2::theme_classic(base_size = taille, base_family = POLICE) +
    ggplot2::theme(panel.grid.major.y = ggplot2::element_line(colour = "#eeeeee"),
                   axis.text.x = ggplot2::element_text(colour = ifelse(ax$gris, "#aaaaaa", "black")))
}

# Graphique de la série du coût de la vie (graphique 2)
graphique_cout_vie <- function(serie, methode = "ce") {
  s <- preparer_serie_graphique(serie, methode)
  ax <- axe_mois(max(s$mois)); r <- raccords(s)
  m <- s %>% dplyr::filter(variable == "Cherte_vie") %>%
    dplyr::mutate(apres = segment == "apres",
                  lab = ifelse(apres, paste0(pts(solde), "\n", MOIS_COURT[as.integer(substr(mois, 6, 7))], " ", substr(mois, 1, 4)), pts(solde)),
                  # étiquettes sombres des mois récents : avant-dernière à gauche, dernière à droite
                  dy = ifelse(apres, 17, 8),
                  dx = ifelse(apres, ifelse(x == max(x), 0.45, -0.55), 0))
  p <- fond_commun(ggplot2::ggplot(), ax, 11) +
    ggplot2::annotate("text", x = mean(range(ax$breaks[ax$gris])), y = 93, label = "Pas de\ncollecte",
                      colour = "#777777", fontface = "italic", size = 3.6) +
    ggplot2::geom_line(data = s %>% dplyr::filter(variable != "Cherte_vie"),
                       ggplot2::aes(x, y, group = interaction(variable, segment)), colour = GRIS, linewidth = 0.5) +
    ggplot2::geom_segment(data = r %>% dplyr::filter(variable != "Cherte_vie"),
                          ggplot2::aes(x = x, xend = xend, y = y, yend = yend), colour = GRIS, linetype = "dashed", linewidth = 0.5) +
    ggplot2::geom_ribbon(data = m, ggplot2::aes(x, ymin = bas, ymax = haut, group = segment), fill = ORANGE, alpha = 0.12) +
    ggplot2::geom_line(data = m, ggplot2::aes(x, y, group = segment), colour = ORANGE, linewidth = 1.6) +
    ggplot2::geom_segment(data = r %>% dplyr::filter(variable == "Cherte_vie"),
                          ggplot2::aes(x = x, xend = xend, y = y, yend = yend), colour = ORANGE, linetype = "dashed", linewidth = 1.4) +
    ggplot2::geom_point(data = m, ggplot2::aes(x, y), colour = ORANGE, size = 3.4) +
    ggplot2::geom_label(data = m %>% dplyr::filter(!apres), ggplot2::aes(x, y + 8, label = lab),
                        colour = ORANGE, fill = "white", fontface = "bold", size = 3.3, label.r = grid::unit(0.15, "lines")) +
    ggplot2::geom_label(data = m %>% dplyr::filter(apres), ggplot2::aes(x + dx, y + dy, label = lab),
                        colour = "white", fill = "#3a3a3a", fontface = "bold", size = 2.9, label.r = grid::unit(0.15, "lines")) +
    ggplot2::annotate("segment", x = 0, xend = 0.8, y = -34, yend = -34, colour = ORANGE, linewidth = 1.6) +
    ggplot2::annotate("text", x = 1, y = -34, label = "Évolution du coût de la vie", hjust = 0, size = 3.6) +
    ggplot2::scale_x_continuous(breaks = ax$breaks, labels = ax$labels, expand = ggplot2::expansion(add = c(0.6, 1.4))) +
    ggplot2::labs(y = "Solde d'opinion (points)",
                  caption = "* Pas de collecte entre décembre 2025 et avril 2026 (zone grisée / trait pointillé)\nbande orange : intervalle de confiance à 95 %") +
    ggplot2::theme(plot.caption = ggplot2::element_text(hjust = 0.5, face = "italic", colour = "#666666"))
  p
}

# Petits multiples des huit soldes (graphique 3), chacun sur fond des sept autres
graphique_series_anstat <- function(serie, methode = "ce") {
  s <- preparer_serie_graphique(serie, methode)
  ax <- axe_mois(max(s$mois)); r <- raccords(s)
  panneaux <- lapply(THEMES$variable, function(v) {
    th <- THEMES[THEMES$variable == v, ]
    col <- if (th$type == "pression") ROUGE else BLEU
    m <- s %>% dplyr::filter(variable == v)
    dec <- if (th$type == "pression") 7 else -7
    fond_commun(ggplot2::ggplot(), ax, 7) +
      ggplot2::geom_line(data = s %>% dplyr::filter(variable != v),
                         ggplot2::aes(x, y, group = interaction(variable, segment)), colour = GRIS, linewidth = 0.35) +
      ggplot2::geom_segment(data = r %>% dplyr::filter(variable != v),
                            ggplot2::aes(x = x, xend = xend, y = y, yend = yend), colour = GRIS, linetype = "dashed", linewidth = 0.35) +
      ggplot2::geom_errorbar(data = m, ggplot2::aes(x, ymin = bas, ymax = haut), colour = col, alpha = 0.35, width = 0.25) +
      ggplot2::geom_line(data = m, ggplot2::aes(x, y, group = segment), colour = col, linewidth = 0.9) +
      ggplot2::geom_segment(data = r %>% dplyr::filter(variable == v),
                            ggplot2::aes(x = x, xend = xend, y = y, yend = yend), colour = col, linetype = "dashed", linewidth = 0.8) +
      ggplot2::geom_point(data = m, ggplot2::aes(x, y, shape = comparable), colour = col, fill = "white", size = 1.7) +
      ggplot2::scale_shape_manual(values = c(`TRUE` = 16, `FALSE` = 21), guide = "none") +
      ggplot2::geom_text(data = m, ggplot2::aes(x, y + dec, label = pts(solde)), colour = col, fontface = "bold", size = 2.1) +
      ggplot2::ggtitle(toupper(th$nom_court)) +
      ggplot2::theme(plot.title = ggplot2::element_text(colour = col, face = "bold", hjust = 0.5, size = 9),
                     axis.text.x = ggplot2::element_text(size = 5.5, colour = ifelse(ax$gris, "#aaaaaa", "black")))
  })
  grille <- cowplot::plot_grid(plotlist = panneaux, ncol = 2)
  cowplot::plot_grid(grille, cowplot::ggdraw() +
                       cowplot::draw_label("* Pas de collecte entre décembre 2025 et avril 2026 (zone grisée / trait pointillé) ; point creux : question portant sur quatre mois",
                                           fontfamily = POLICE, fontface = "italic", colour = "#666666", size = 7),
                     ncol = 1, rel_heights = c(1, 0.03))
}

# Cartographie des soldes du mois par catégorie (graphique 1), au style du « tableau
# de bord » publié : tuiles franches, bordures blanches, valeurs au centre.
# Rouge : soldes positifs (pression accrue) ; bleu : soldes négatifs (dégradation).
graphique_cartographie <- function(soldes, methode = "ce") {
  s <- soldes %>%
    dplyr::filter(methode == !!methode) %>%
    dplyr::inner_join(THEMES %>% dplyr::select(variable, nom_court, type), by = "variable") %>%
    dplyr::mutate(categorie = factor(ifelse(domaine == "Ensemble", "Ensemble", modalite),
                                     c("Ensemble", "Urbain", "Rural", paste0("Q", 1:5))),
                  nom_court = factor(nom_court, rev(THEMES$nom_court)),
                  v = 100 * solde)
  ggplot2::ggplot(s, ggplot2::aes(categorie, nom_court, fill = v)) +
    ggplot2::geom_tile(colour = "white", linewidth = 1.6) +
    ggplot2::geom_text(ggplot2::aes(label = pts(solde)), size = 3.4,
                       colour = ifelse(abs(s$v) > 25, "white", "black")) +
    ggplot2::scale_fill_distiller(palette = "RdBu", direction = -1, limits = c(-50, 50),
                                  oob = scales::squish, guide = "none") +
    ggplot2::scale_x_discrete(expand = c(0, 0)) + ggplot2::scale_y_discrete(expand = c(0, 0)) +
    ggplot2::labs(x = NULL, y = NULL) +
    ggplot2::theme_minimal(base_size = 10, base_family = POLICE) +
    ggplot2::theme(panel.grid = ggplot2::element_blank(),
                   axis.text = ggplot2::element_text(colour = "black"))
}

# --- Analyse historique du coût de la vie ---------------------------------------

texte_historique_cout_vie <- function(serie, id2, methode = "ce") {
  s <- serie %>% dplyr::filter(methode == !!methode, domaine == "Ensemble", variable == "Cherte_vie", !is.na(solde))
  moy <- mean(s$solde); dern <- s[s$mois == id2, ]
  imax <- which.max(s$solde); imin <- which.min(s$solde)
  tous_positifs <- all(s$ic95_bas > 0)
  ecart <- dern$solde - moy
  position <- if (abs(ecart) < qnorm(0.975) * dern$erreur_type) "proche de cette moyenne" else
    if (ecart > 0) "au-dessus de cette moyenne" else "en dessous de cette moyenne"
  c(sprintf(paste0("Sur les %d mois de collecte disponibles depuis février 2025, le solde relatif au coût de la vie %s. ",
                   "Les ménages perçoivent donc, de manière continue, une hausse du coût de la vie."),
            nrow(s), ifelse(tous_positifs, "est resté positif et significativement différent de zéro chaque mois",
                            "est resté majoritairement positif")),
    sprintf(paste0("Il a varié entre %s points (%s) et %s points (%s), pour une moyenne de %s points sur la période. ",
                   "En %s, il s'établit à %s points, %s."),
            pts(s$solde[imin]), libelle_mois(s$mois[imin]), pts(s$solde[imax]), libelle_mois(s$mois[imax]),
            pts(moy), libelle_mois(id2), pts(dern$solde), position))
}
