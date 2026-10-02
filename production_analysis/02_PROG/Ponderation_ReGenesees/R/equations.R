# ==============================================================================
# Équations Word natives (OMML) pour les documents officer
# ==============================================================================
# Chaque fonction renvoie un fragment OMML (chaîne). ajouter_equation() insère une
# équation centrée, numérotée à droite « (n) », comme dans un document Word saisi
# avec l'éditeur d'équations. Police des formules : Cambria Math (défaut de Word).

NS_W <- "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
NS_M <- "http://schemas.openxmlformats.org/officeDocument/2006/math"

.xml_echap <- function(x) { x <- gsub("&", "&amp;", x, fixed = TRUE); x <- gsub("<", "&lt;", x, fixed = TRUE); gsub(">", "&gt;", x, fixed = TRUE) }

# Texte : italique mathématique par défaut ; droit = TRUE pour les mots et fonctions
eq   <- function(..., droit = FALSE)
  paste0("<m:r>", if (droit) '<m:rPr><m:sty m:val="p"/></m:rPr>', '<m:t xml:space="preserve">',
         .xml_echap(paste0(...)), "</m:t></m:r>")
eqd  <- function(...) eq(..., droit = TRUE)
ind  <- function(base, bas) paste0("<m:sSub><m:e>", base, "</m:e><m:sub>", bas, "</m:sub></m:sSub>")
exp_ <- function(base, haut) paste0("<m:sSup><m:e>", base, "</m:e><m:sup>", haut, "</m:sup></m:sSup>")
indexp <- function(base, bas, haut)
  paste0("<m:sSubSup><m:e>", base, "</m:e><m:sub>", bas, "</m:sub><m:sup>", haut, "</m:sup></m:sSubSup>")
frac <- function(num, den) paste0("<m:f><m:num>", num, "</m:num><m:den>", den, "</m:den></m:f>")
somme <- function(sous, corps)
  paste0('<m:nary><m:naryPr><m:chr m:val="∑"/><m:limLoc m:val="undOvr"/><m:supHide m:val="1"/></m:naryPr>',
         "<m:sub>", sous, "</m:sub><m:sup/><m:e>", corps, "</m:e></m:nary>")
racine <- function(x) paste0('<m:rad><m:radPr><m:degHide m:val="1"/></m:radPr><m:deg/><m:e>', x, "</m:e></m:rad>")
paren  <- function(x, g = "(", d = ")")
  paste0('<m:d><m:dPr><m:begChr m:val="', g, '"/><m:endChr m:val="', d, '"/></m:dPr><m:e>', x, "</m:e></m:d>")
chapeau <- function(x) paste0('<m:acc><m:accPr><m:chr m:val="̂"/></m:accPr><m:e>', x, "</m:e></m:acc>")
# Accolade de cas : liste de lignes « valeur, condition »
cas <- function(lignes)
  paren(paste0("<m:eqArr>", paste0("<m:e>", lignes, "</m:e>", collapse = ""), "</m:eqArr>"), g = "{", d = "")

# Largeur utile de la page (twips), lue dans la dernière section du document
.largeur_texte <- function(doc) {
  s <- xml2::xml_find_first(docx_body_xml(doc), "//w:body/w:sectPr")
  w <- as.numeric(xml2::xml_attr(xml2::xml_find_first(s, "w:pgSz"), "w"))
  m <- xml2::xml_find_first(s, "w:pgMar")
  w - as.numeric(xml2::xml_attr(m, "left")) - as.numeric(xml2::xml_attr(m, "right"))
}

# Matrice sans délimiteurs, colonnes alignées à gauche (barèmes, cas)
matrice <- function(lignes, jc = "left") {
  nc <- length(lignes[[1]])
  paste0('<m:m><m:mPr><m:mcs><m:mc><m:mcPr><m:count m:val="', nc, '"/><m:mcJc m:val="', jc, '"/></m:mcPr></m:mc></m:mcs>',
         '<m:cGp m:val="400"/></m:mPr>',
         paste0(vapply(lignes, function(l) paste0("<m:mr>", paste0("<m:e>", l, "</m:e>", collapse = ""), "</m:mr>"), ""), collapse = ""),
         "</m:m>")
}

.compteur_eq <- new.env(); .compteur_eq$n <- 0
# Équation en mode « affichage » (seule dans son paragraphe, d'où des fractions et
# des sommes de pleine taille), centrée, numéro « (n) » à droite : tableau sans
# bordure de trois colonnes, disposition classique des documents Word.
ajouter_equation <- function(doc, omml, numero = TRUE, taille = 11) {
  l <- round(.largeur_texte(doc)); marge <- round(0.1 * l)
  if (numero) .compteur_eq$n <- .compteur_eq$n + 1
  rpr <- sprintf('<w:rPr><w:rFonts w:ascii="%s" w:hAnsi="%s"/><w:sz w:val="%d"/></w:rPr>', POLICE, POLICE, 2 * taille)
  cell <- function(w, contenu, jc = "center")
    paste0('<w:tc><w:tcPr><w:tcW w:w="', w, '" w:type="dxa"/><w:vAlign w:val="center"/></w:tcPr>',
           '<w:p><w:pPr><w:spacing w:before="80" w:after="80"/><w:jc w:val="', jc, '"/></w:pPr>', contenu, "</w:p></w:tc>")
  xml <- paste0(
    '<w:tbl xmlns:w="', NS_W, '" xmlns:m="', NS_M, '"><w:tblPr><w:tblW w:w="', l, '" w:type="dxa"/><w:jc w:val="center"/>',
    '<w:tblBorders><w:top w:val="nil"/><w:left w:val="nil"/><w:bottom w:val="nil"/><w:right w:val="nil"/>',
    '<w:insideH w:val="nil"/><w:insideV w:val="nil"/></w:tblBorders><w:tblLayout w:type="fixed"/>',
    '<w:tblCellMar><w:left w:w="0" w:type="dxa"/><w:right w:w="0" w:type="dxa"/></w:tblCellMar></w:tblPr>',
    '<w:tblGrid><w:gridCol w:w="', marge, '"/><w:gridCol w:w="', l - 2 * marge, '"/><w:gridCol w:w="', marge, '"/></w:tblGrid>',
    '<w:tr><w:trPr><w:cantSplit/></w:trPr>',
    cell(marge, ""),
    cell(l - 2 * marge, paste0('<m:oMathPara><m:oMathParaPr><m:jc m:val="center"/></m:oMathParaPr><m:oMath>', omml, "</m:oMath></m:oMathPara>")),
    cell(marge, if (numero) sprintf("<w:r>%s<w:t>(%d)</w:t></w:r>", rpr, .compteur_eq$n) else "", jc = "right"),
    "</w:tr></w:tbl>")
  body_add_xml(doc, str = xml)
}

# Paragraphe de texte contenant des symboles mathématiques en ligne :
# morceaux = liste alternant chaînes (texte) et list(m = omml) (formule)
ajouter_texte_math <- function(doc, morceaux, taille = TAILLE_TEXTE, puce = FALSE) {
  rpr <- sprintf('<w:rPr><w:rFonts w:ascii="%s" w:hAnsi="%s"/><w:sz w:val="%d"/></w:rPr>', POLICE, POLICE, round(2 * taille))
  run <- function(t) sprintf('<w:r>%s<w:t xml:space="preserve">%s</w:t></w:r>', rpr, .xml_echap(t))
  corps <- paste0(vapply(morceaux, function(x) if (is.list(x)) paste0("<m:oMath>", x$m, "</m:oMath>") else run(x), ""), collapse = "")
  if (puce) corps <- paste0(sprintf('<w:r><w:rPr><w:rFonts w:ascii="%s" w:hAnsi="%s"/><w:b/><w:color w:val="%s"/><w:sz w:val="%d"/></w:rPr><w:t xml:space="preserve">•  </w:t></w:r>',
                                    POLICE, POLICE, sub("#", "", ORANGE_ANSTAT), round(2 * taille)), corps)
  ppr <- paste0('<w:pPr><w:spacing w:after="', if (puce) 60 else 120, '" w:line="276" w:lineRule="auto"/>',
                if (puce) '<w:ind w:left="320"/>', '<w:jc w:val="both"/></w:pPr>')
  body_add_xml(doc, str = paste0('<w:p xmlns:w="', NS_W, '" xmlns:m="', NS_M, '">', ppr, corps, "</w:p>"))
}
# Raccourci pour un symbole en ligne
M <- function(...) list(m = paste0(...))
