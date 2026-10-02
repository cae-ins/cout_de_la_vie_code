# ==============================================================================
# Note méthodologique de l'Enquête Cherté de la Vie (ECV), au format ANStat
#   Rscript 08_note_methodologique.R
# Prérequis : run_all.R, 04_variations.R et 06_serie.R déjà exécutés.
# Sortie    : Indice_cout_vie/Méthodologie/Note_Methodologique_ICV_<aaaa_mm_jj>.docx
# Tous les chiffres sont calculés à partir des données et des sorties de la chaîne.
# ==============================================================================

local({
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  dir <- if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else getwd()
  setwd(dir)
})
source("config.R", encoding = "UTF-8")
suppressPackageStartupMessages({ library(dplyr); library(ggplot2) })
source("R/bulletin.R", encoding = "UTF-8")
suppressPackageStartupMessages(source("R/bulletin_anstat.R", encoding = "UTF-8"))
source("R/equations.R", encoding = "UTF-8")

# Ancienne note (août 2025) : page de garde et styles ANStat conservés, corps remplacé
MODELE <- file.path(RACINE, "Méthodologie/Note_Methodologique_ICV_2025_08_06.docx")
modele_copie <- file.path(tempdir(), "modele_anstat_note.docx")
invisible(file.copy(MODELE, modele_copie, overwrite = TRUE))
cap1 <- function(x) paste0(toupper(substr(x, 1, 1)), substr(x, 2, nchar(x)))
pct  <- function(x, d = 1) formatC(100 * x, format = "f", digits = d, decimal.mark = ",")
nb   <- function(x) format(round(x), big.mark = " ")
dec  <- function(x, d = 2) formatC(x, format = "f", digits = d, decimal.mark = ",")
date_note <- Sys.Date()
mois_note <- cap1(paste(MOIS_FR[as.integer(format(date_note, "%m"))], format(date_note, "%Y")))

# --- Chiffres issus des données --------------------------------------------------
base  <- haven::read_dta(FICHIER_BASE_TIRAGE)
ech   <- haven::read_dta(FICHIER_ECHANTILLON)
w     <- haven::read_dta(FICHIER_WELFARE)
N_ehcvm <- nrow(base); N_contact <- sum(base$num == 1); n_tire <- nrow(ech)

# Seuils des quintiles (dépense par tête, population EHCVM en personnes)
o <- order(w$pcexp); cw <- cumsum((w$hhweight * w$hhsize)[o]) / sum(w$hhweight * w$hhsize)
seuils <- sapply(c(0.2, 0.4, 0.6, 0.8), function(p) w$pcexp[o][which(cw >= p)[1]])
base <- base %>% mutate(contact = num == 1, quint = cut(pcexp, c(-Inf, seuils, Inf), labels = paste0("Q", 1:5)))
couv <- function(d) sum(d$hhweight[d$contact]) / sum(d$hhweight)
couv_nat <- couv(base)
couv_milieu <- sapply(split(base, as.integer(base$milieu)), couv)            # 1 urbain, 2 rural
couv_quint  <- sapply(split(base, base$quint), couv)
couv_region <- sapply(split(base, as.integer(base$region)), couv)
lab_region <- read.csv(file.path(DIR_SERIE, "regroupements.csv"), encoding = "UTF-8")
# taux de tirage de la seconde phase par région
tau <- table(as.integer(ech$region)) / table(as.integer(base$region[base$contact]))

bilan <- read.csv(file.path(DIR_SERIE, "bilan_mois.csv"), encoding = "UTF-8")
serie <- read.csv(file.path(DIR_SERIE, "serie_soldes.csv"), encoding = "UTF-8")
regroup <- read.csv(file.path(DIR_SERIE, "regroupements.csv"), encoding = "UTF-8")
dernier <- tail(sort(names(MOIS)), 1); avant_dernier <- tail(sort(names(MOIS)), 2)[1]
poids <- read.csv(chemin_mois(dernier, paste0("poids_", dernier, ".csv")), encoding = "UTF-8") %>%
  mutate(milieu_2021 = sub("^.*_", "", strate))
tr_milieu <- tapply(poids$repondant, poids$milieu_2021, mean)
tr_quint  <- tapply(poids$repondant, poids$quint, mean)
var_m <- read.csv(file.path(DIR_VARIATIONS, paste0("variations_", avant_dernier, "_", dernier, ".csv")), encoding = "UTF-8") %>%
  filter(methode == "ce", domaine == "Ensemble")
se_nat <- serie %>% filter(methode == "ce", domaine == "Ensemble", !is.na(erreur_type), mois != "2025-02")
se_der <- se_nat %>% filter(mois == dernier)
mois_traites <- sort(bilan$mois)
n_zones <- length(unique(regroup$cellule_zone)); fusions <- unique(regroup$cellule_zone[regroup$fusion_zone])

# --- Document -------------------------------------------------------------------------
doc <- suppressWarnings(preparer_modele(modele_copie, "Aout 2025", mois_note, marqueur = "Introduction"))
# Date de la page de garde : « Aout » et « 2025 » sont dans deux segments distincts
local({
  t <- xml2::xml_find_all(docx_body_xml(doc), "//w:t")
  i <- which(trimws(xml2::xml_text(t)) == "Aout")[1]
  if (!is.na(i)) { xml2::xml_text(t[[i]]) <- mois_note; xml2::xml_text(t[[i + 1]]) <- "" }
})
T1 <- function(x) { if (x != "Introduction") x <- paste0(.compteurs$h1 + 1, ". ", x); d <- ajouter_titre1(doc, x); if (grepl("^Introduction", x)) .compteurs$h1 <- 0; d }; T2 <- function(x) ajouter_titre2(doc, x)
P  <- function(...) ajouter_texte(doc, paste0(...))
B  <- function(x) ajouter_puce(doc, x)

doc <- T1("Introduction")
doc <- P("L'Enquête Cherté de la Vie (ECV) mesure chaque mois la perception que les ménages ivoiriens ont de l'évolution du coût de la vie, ",
         "des prix, de leurs dépenses, de leur endettement, de leur situation financière, de leur revenu futur et de la situation économique du pays. ",
         "Ses résultats sont publiés dans le bulletin mensuel « Perception du coût de la vie ».")
doc <- P("Cette note décrit la méthode en vigueur : l'échantillon, la collecte, la pondération, le calcul des soldes d'opinion, ",
         "la mesure de leur précision et les règles de commentaire du bulletin. Elle remplace la note méthodologique d'août 2025. ",
         "La série complète, de février 2025 à ", libelle_mois(dernier), ", a été recalculée selon cette méthode.")

## 1. Échantillon
doc <- T1("Échantillon")
doc <- T2("Base de sondage")
doc <- P("L'échantillon de l'ECV est un sous-échantillon des ménages de l'Enquête Harmonisée sur les Conditions de Vie des Ménages ",
         "(EHCVM 2021), qui compte ", nb(N_ehcvm), " ménages répartis dans les 33 régions. Seuls les ", nb(N_contact),
         " ménages ayant donné le numéro de téléphone d'un de leurs membres peuvent être interrogés : ils constituent la base de sondage.")
doc <- P("Ces ménages représentent ", pct(couv_nat), " % des ménages du pays. Cette couverture est plus faible en milieu rural (",
         pct(couv_milieu[["2"]]), " %) qu'en milieu urbain (", pct(couv_milieu[["1"]]), " %), et chez les ménages les plus modestes (",
         pct(couv_quint[["Q1"]]), " % pour le premier quintile) que chez les plus aisés (", pct(couv_quint[["Q5"]]),
         " % pour le cinquième). L'écart dû aux ménages sans téléphone est corrigé lors du calage (partie 3.3).")
doc <- P("La couverture d'une région r est la part de ses ménages, pondérés par l'EHCVM, qui ont un numéro de téléphone :")
doc <- ajouter_equation(doc, paste0(ind(eq("τ"), eq("r")), eq("="),
                                    frac(somme(paste0(eq("i∈"), ind(eq("C"), eq("r"))), indexp(eq("w"), eq("i"), eqd("EHCVM"))),
                                         somme(paste0(eq("i∈"), ind(eq("U"), eq("r"))), indexp(eq("w"), eq("i"), eqd("EHCVM"))))))
doc <- ajouter_texte_math(doc, list("où ", M(ind(eq("U"), eq("r"))), " est l'ensemble des ménages EHCVM de la région et ",
                                    M(ind(eq("C"), eq("r"))), " ceux qui ont un numéro de téléphone. Elle va de ", pct(min(couv_region)), " % à ",
                                    pct(max(couv_region)), " % selon les régions."))
doc <- T2("Tirage")
doc <- P(nb(n_tire), " ménages ont été tirés dans la base de sondage, par un tirage systématique dans chaque région, après un tri par ",
         "milieu de résidence et par niveau de dépense. Ils ont été répartis au hasard en 24 sous-échantillons d'environ 444 ménages. ",
         "La part des ménages joignables tirés varie selon les régions, de ", pct(min(tau), 0), " % à ", pct(max(tau), 0),
         " %, car les petites régions ont été tirées en totalité pour disposer d'au moins dix ménages par sous-échantillon.")
doc <- T2("Panel rotatif")
doc <- P("Chaque sous-échantillon est interrogé trois mois de suite, laissé au repos neuf mois, puis réinterrogé trois mois. ",
         "Deux mois consécutifs ont donc une grande partie de leurs ménages en commun, ce qui est pris en compte dans le calcul de la ",
         "précision des évolutions (partie 5.2). Aucune collecte n'a eu lieu de décembre 2025 à avril 2026 ; à la reprise, des ménages en ",
         "première interrogation et des ménages en réinterrogation ont été appelés.")

## 2. Collecte
doc <- T1("Collecte et questionnaire")
doc <- P("Les ménages sont interrogés par téléphone. Le questionnaire porte sur huit opinions, chacune à cinq modalités (forte hausse, ",
         "légère hausse, stabilité, légère baisse, forte baisse, ou leurs équivalents en termes d'amélioration et de dégradation), ",
         "auxquelles s'ajoute la possibilité de ne pas se prononcer. Les questions ont des périodes de référence différentes :")
doc <- B("par rapport au mois précédent : coût de la vie, prix, dépenses du ménage et situation financière ;")
doc <- B("pour le mois suivant : revenu futur ;")
doc <- B("sur les trois derniers mois : prix sur trois mois, dette et situation économique du pays.")
doc <- P("À la reprise de la collecte en mai et juin 2026, les questions sur les trois derniers mois ont couvert quatre mois. ",
         "Les évolutions qui font intervenir ces mois ne sont pas comparables et ne sont pas commentées (partie 6).")

## 3. Pondération
doc <- T1("Pondération")
doc <- P("La pondération se fait en trois étapes : poids de sondage, correction de la non-réponse, puis calage sur la population. ",
         "Elle est réalisée chaque mois avec le logiciel ReGenesees (version CAE-INS).")
doc <- T2("Poids de sondage")
doc <- P("Le tirage se fait en deux phases : le ménage a d'abord été tiré dans l'EHCVM, puis dans l'échantillon de l'ECV, et son ",
         "sous-échantillon doit être interrogé le mois considéré. Le poids de sondage du ménage i, de la région de tirage r, au mois t vaut :")
doc <- ajouter_equation(doc, paste0(ind(eq("d"), eq("i,t")), eq("="), indexp(eq("w"), eq("i"), eqd("EHCVM")), eq("×"),
                                    frac(indexp(eq("N"), eq("r"), eq("′")), ind(eq("m"), eq("r,t")))))
doc <- ajouter_texte(doc, "où :")
doc <- ajouter_texte_math(doc, list(M(indexp(eq("w"), eq("i"), eqd("EHCVM"))), " est le poids du ménage dans l'EHCVM 2021 ;"), puce = TRUE)
doc <- ajouter_texte_math(doc, list(M(indexp(eq("N"), eq("r"), eq("′"))), " est le nombre de ménages joignables de la région r dans la base de sondage ;"), puce = TRUE)
doc <- ajouter_texte_math(doc, list(M(ind(eq("m"), eq("r,t"))), " est le nombre de ménages de la région r dont le sous-échantillon est interrogé au mois t."), puce = TRUE)
doc <- P("Ce poids est calculé selon la région de tirage, même si le ménage a déménagé depuis 2021 (partie 3.4).")

doc <- T2("Correction de la non-réponse")
doc <- P("Le taux de réponse varie de ", pct(min(bilan$n_repondants / bilan$n_tires), 0), " à ", pct(max(bilan$n_repondants / bilan$n_tires), 0),
         " % selon les mois et dépend des caractéristiques des ménages. En ", libelle_mois(dernier),
         ", il atteint ", pct(tr_milieu[["Urbain"]], 0), " % en milieu urbain contre ", pct(tr_milieu[["Rural"]], 0),
         " % en milieu rural, et ", pct(tr_quint[["Q1"]], 0), " % chez les ménages du premier quintile contre ",
         pct(tr_quint[["Q5"]], 0), " % chez ceux du cinquième.")
doc <- P("Comme les caractéristiques EHCVM sont connues pour tous les ménages appelés, répondants ou non, la probabilité de répondre ",
         "est estimée par une régression logistique (score de propension) :")
doc <- ajouter_equation(doc, paste0(eqd("ln"), paren(frac(ind(eq("p"), eq("i")), paste0(eq("1−"), ind(eq("p"), eq("i"))))), eq("="),
                                    indexp(eq("x"), eq("i"), eq("′")), eq("β")))
doc <- ajouter_texte_math(doc, list("où ", M(ind(eq("p"), eq("i"))), " est la probabilité que le ménage i réponde et ",
                                    M(ind(eq("x"), eq("i"))), " ses caractéristiques : dépense par tête (en logarithme), taille du ménage, ",
                                    "milieu, zone agroécologique, sexe, âge, instruction et catégorie socioprofessionnelle du chef de ménage, ",
                                    "rang d'interrogation."))
doc <- P("Les ménages appelés sont répartis en ", NB_CLASSES_PROPENSION, " classes selon leur score (au moins ", MIN_REPONDANTS_CLASSE,
         " répondants par classe). Dans chaque classe c, le poids des répondants est divisé par le taux de réponse pondéré de la classe :")
doc <- ajouter_equation(doc, paste0(ind(eq("φ"), eq("c")), eq("="),
                                    frac(somme(paste0(eq("i∈"), ind(eq("A"), eq("c"))), ind(eq("d"), eq("i"))),
                                         somme(paste0(eq("i∈"), ind(eq("R"), eq("c"))), ind(eq("d"), eq("i")))),
                                    eqd(",     "), indexp(eq("w"), eq("i"), eqd("nr")), eq("="), ind(eq("φ"), eq("c")), ind(eq("d"), eq("i"))))
doc <- ajouter_texte_math(doc, list("où ", M(ind(eq("A"), eq("c"))), " est l'ensemble des ménages appelés de la classe c et ",
                                    M(ind(eq("R"), eq("c"))), " celui de ses répondants. Regrouper les ménages en classes, plutôt que ",
                                    "d'utiliser directement le score, évite des poids extrêmes lorsque le score est proche de zéro."))

doc <- T2("Calage sur la population")
doc <- P("Les poids sont ensuite ajustés pour que les ménages répondants reproduisent la population projetée par l'ANStat pour le ",
         "trimestre. Le calage se fait sur le nombre de personnes : chaque ménage compte pour son nombre de membres, ce qui évite ",
         "d'avoir à supposer une taille moyenne des ménages. Les poids calés vérifient :")
doc <- ajouter_equation(doc, paste0(somme(eq("i∈R"), paste0(ind(eq("w"), eq("i")), ind(eq("h"), eq("i")), ind(eq("δ"), eq("i,k")))),
                                    eq("="), ind(eq("P"), eq("k")), eqd(",    pour chaque cellule "), eq("k")))
doc <- ajouter_texte_math(doc, list("où R est l'ensemble des répondants, ", M(ind(eq("h"), eq("i"))), " la taille du ménage i, ",
                                    M(ind(eq("δ"), eq("i,k"))), " vaut 1 si le ménage appartient à la cellule k et 0 sinon, et ",
                                    M(ind(eq("P"), eq("k"))), " est la population projetée de la cellule. Les cellules forment trois marges, respectées simultanément :"))
doc <- B("la région de résidence actuelle (33 régions) ;")
doc <- B(paste0("la zone agroécologique selon le milieu de résidence actuel (", n_zones, " cellules ; ",
                if (length(fusions)) "Abidjan est calé tous milieux confondus, faute d'effectif rural suffisant" else "aucune fusion", ") ;"))
doc <- B("le quintile de niveau de vie, chaque quintile représentant 20 % de la population.")
doc <- P("Parmi tous les poids qui respectent ces totaux, le calage retient les plus proches des poids corrigés de la non-réponse. ",
         "Le poids final s'écrit :")
doc <- ajouter_equation(doc, paste0(ind(eq("w"), eq("i")), eq("="), ind(eq("g"), eq("i")), indexp(eq("w"), eq("i"), eqd("nr")),
                                    eqd(",     avec   "), eqd(dec(BORNES_CALAGE[1])), eq("≤"), ind(eq("g"), eq("i")), eq("≤"),
                                    eqd(dec(BORNES_CALAGE[2], 0))))
doc <- ajouter_texte_math(doc, list("où le coefficient ", M(ind(eq("g"), eq("i"))), " est obtenu par la méthode logit de calage ",
                                    "(Deville et Särndal, 1992), qui maintient chaque coefficient entre ses bornes."))
doc <- P("Les cellules de calage sont fixées une fois pour toute la série : une cellule zone × milieu doit compter au moins ",
         SEUIL_REPONDANTS_CELLULE, " répondants par mois en médiane, sinon elle est fusionnée avec l'autre milieu de la zone. ",
         "Lorsque le calage n'atteint pas ses marges dans les bornes, la marge régionale est retirée pour ce mois.")
doc <- T2("Ménages ayant changé de région")
doc <- P("Un ménage qui a déménagé depuis 2021 garde le poids de sa région de tirage, mais il est classé dans sa région actuelle pour le ",
         "calage et pour les résultats. Il représente ainsi les ménages qui ont fait le même déplacement, et la répartition de la ",
         "population entre régions tient compte des migrations.")
doc <- T2("Quintiles de niveau de vie")
doc <- P("Les quintiles sont définis une fois pour toutes à partir de la dépense annuelle par personne de l'EHCVM 2021, sur l'ensemble ",
         "de la population. Les seuils sont de ", nb(seuils[1] / 12), ", ", nb(seuils[2] / 12), ", ", nb(seuils[3] / 12), " et ",
         nb(seuils[4] / 12), " FCFA par personne et par mois.")

## 4. Indicateurs
doc <- T1("Soldes d'opinion")
doc <- P("Pour chaque question k, le solde d'opinion est calculé selon la méthode de la Commission européenne. Chaque réponse reçoit une note :")
doc <- ajouter_equation(doc, paste0(ind(eq("s"), eq("i,k")), eq("="),
                                    cas(matrice(list(
                                      c(eq("+1"), eqd("forte hausse (nette amélioration)")),
                                      c(eq("+0,5"), eqd("légère hausse (légère amélioration)")),
                                      c(eq("0"), eqd("stabilité")),
                                      c(eq("−0,5"), eqd("légère baisse (légère dégradation)")),
                                      c(eq("−1"), eqd("forte baisse (nette dégradation)")))))))
doc <- P("Le solde est la moyenne pondérée de ces notes, exprimée en points :")
doc <- ajouter_equation(doc, paste0(ind(chapeau(eq("S")), eq("k")), eq("=100×"),
                                    frac(somme(paste0(eq("i∈"), ind(eq("R"), eq("k"))), paste0(ind(eq("w"), eq("i")), ind(eq("s"), eq("i,k")))),
                                         somme(paste0(eq("i∈"), ind(eq("R"), eq("k"))), ind(eq("w"), eq("i"))))))
doc <- ajouter_texte_math(doc, list("où ", M(ind(eq("R"), eq("k"))), " est l'ensemble des répondants qui se prononcent sur la question k : ",
                                    "les « ne sait pas » sont exclus. Le solde va de −100 (tous les ménages déclarent une forte baisse) à +100 ",
                                    "(tous déclarent une forte hausse)."))
doc <- P("Les soldes sont publiés pour l'ensemble des ménages, par milieu de résidence et par quintile de niveau de vie. ",
         "Pour la dette, les prix et le coût de la vie, un solde positif traduit une tension accrue ; pour la situation financière, ",
         "le revenu futur et la situation du pays, un solde négatif traduit une dégradation.")

## 5. Précision
doc <- T1("Précision des résultats")
doc <- T2("Précision d'un solde")
doc <- P("Le solde est le rapport de deux totaux estimés. Sa variance est estimée par linéarisation, en tenant compte du plan de ",
         "sondage de l'EHCVM (grappes j dans les strates h) et du calage :")
doc <- ajouter_equation(doc, paste0(chapeau(eq("V")), paren(ind(chapeau(eq("S")), eq("k"))), eq("="),
                                    somme(eq("h"), paste0(frac(ind(eq("n"), eq("h")), paste0(ind(eq("n"), eq("h")), eq("−1"))),
                                          somme(eq("j"), exp_(paren(paste0(ind(eq("z"), eq("hj")), eq("−"), ind(eq("z̄"), eq("h")))), eq("2")))))))
doc <- ajouter_texte_math(doc, list("où ", M(ind(eq("n"), eq("h"))), " est le nombre de grappes répondantes de la strate h, ",
                                    M(ind(eq("z"), eq("hj"))), " la somme, sur les ménages de la grappe j, des poids multipliés par la variable ",
                                    "linéarisée du solde (calculée sur les résidus du calage) et ", M(ind(eq("z̄"), eq("h"))),
                                    " sa moyenne dans la strate. La marge d'erreur à 95 % vaut :"))
doc <- ajouter_equation(doc, paste0(eqd("ME"), paren(ind(chapeau(eq("S")), eq("k"))), eq("=1,96×"),
                                    racine(paste0(chapeau(eq("V")), paren(ind(chapeau(eq("S")), eq("k")))))))
doc <- P("En ", libelle_mois(dernier), ", la marge d'erreur d'un solde national va de ±", dec(1.96 * 100 * min(se_der$erreur_type), 1),
         " à ±", dec(1.96 * 100 * max(se_der$erreur_type), 1), " points selon l'indicateur. Elle est plus large pour les catégories ",
         "de ménages, en particulier pour les quintiles.")
doc <- T2("Précision d'une évolution")
doc <- P("L'évolution d'un solde entre deux mois est la simple différence des soldes :")
doc <- ajouter_equation(doc, paste0(eq("Δ"), ind(chapeau(eq("S")), eq("k")), eq("="),
                                    indexp(chapeau(eq("S")), eq("k"), eq("t")), eq("−"), indexp(chapeau(eq("S")), eq("k"), eq("t−1"))))
doc <- P("Comme une partie des ménages et des grappes est interrogée les deux mois, les deux soldes ne sont pas indépendants. ",
         "Leur covariance entre dans la variance de l'évolution :")
doc <- ajouter_equation(doc, paste0(chapeau(eq("V")), paren(paste0(eq("Δ"), ind(chapeau(eq("S")), eq("k")))), eq("="),
                                    chapeau(eq("V")), paren(indexp(chapeau(eq("S")), eq("k"), eq("t"))), eq("+"),
                                    chapeau(eq("V")), paren(indexp(chapeau(eq("S")), eq("k"), eq("t−1"))), eq("−2"),
                                    eqd("Cov"), paren(paste0(indexp(chapeau(eq("S")), eq("k"), eq("t")), eq(","), indexp(chapeau(eq("S")), eq("k"), eq("t−1"))))))
doc <- P("La covariance est estimée sur les grappes communes aux deux mois, par la méthode de Berger et Priam (fonction svyDelta ",
         "de ReGenesees). En pratique, les réponses d'un même ménage varient beaucoup d'un mois à l'autre : la corrélation entre deux ",
         "mois reste faible (au plus ", dec(max(var_m$rho, na.rm = TRUE)), " entre ", libelle_mois(avant_dernier), " et ",
         libelle_mois(dernier), ") et ce recouvrement réduit peu la variance des évolutions. Le calcul est contrôlé chaque mois par ",
         "un bootstrap, qui donne des résultats concordants. L'évolution est ensuite rapportée à son écart type :")
doc <- ajouter_equation(doc, paste0(ind(eq("z"), eq("k")), eq("="),
                                    frac(paste0(eq("Δ"), ind(chapeau(eq("S")), eq("k"))),
                                         racine(paste0(chapeau(eq("V")), paren(paste0(eq("Δ"), ind(chapeau(eq("S")), eq("k")))))))))
doc <- P("L'écart entre deux catégories de ménages d'un même mois (urbain et rural, premier et cinquième quintile) est traité de la même ",
         "façon : différence des deux soldes, variance tenant compte de leur covariance dans l'échantillon, puis rapport à l'écart type.")

## 6. Règles de commentaire
doc <- T1("Règles de commentaire")
doc <- P("Une évolution n'est qualifiée de hausse ou de baisse que si elle dépasse sa marge d'erreur. Selon la valeur de z, elle est décrite comme :")
doc <- ajouter_texte_math(doc, list("stable, si ", M(eq("|z|<1,645")), " (non significative au seuil de 90 %) ;"), puce = TRUE)
doc <- ajouter_texte_math(doc, list("une légère hausse ou baisse (amélioration ou dégradation), si ", M(eq("1,645≤|z|<1,96")),
                                    " (significative à 90 % mais pas à 95 %) ;"), puce = TRUE)
doc <- ajouter_texte_math(doc, list("une hausse ou une baisse, si ", M(eq("1,96≤|z|<3,29")), " (significative à 95 %) ;"), puce = TRUE)
doc <- ajouter_texte_math(doc, list("une nette hausse ou baisse, si ", M(eq("|z|≥3,29")), " (significative à 99,9 %)."), puce = TRUE)
doc <- P("Le bulletin compare chaque mois au mois précédent et au même mois de l'année précédente. Une évolution qui fait intervenir ",
         "une période de référence différente (les mois de reprise de 2026) n'est pas commentée : le solde reste publié dans les ",
         "tableaux avec un astérisque et l'annexe du bulletin en donne la raison. Aucune évolution n'est commentée entre deux mois ",
         "séparés par l'interruption de collecte. Les écarts entre milieux de résidence et entre les quintiles extrêmes ne sont ",
         "commentés que lorsqu'ils sont statistiquement significatifs.")

## 7. Série
doc <- T1("Série et contrôles")
doc <- P("La série est disponible pour ", length(mois_traites), " mois, de ", libelle_mois(min(mois_traites)), " à ",
         libelle_mois(max(mois_traites)), ". La base complète de mai 2026 n'a pas été retrouvée : ce mois ne figure pas dans la série. ",
         "Pour quelques mois de 2025, une information manquante a été complétée à partir de l'EHCVM (région ou milieu actuel), ou le ",
         "calage a été fait sans marge régionale ; ces traitements sont signalés dans les fichiers de résultats.")
doc <- ajouter_legende(doc, "Tableau 1 : Ménages appelés, ménages répondants et taux de réponse par mois de collecte")
t1 <- bilan %>% arrange(mois) %>%
  transmute(`Mois de collecte` = cap1(sapply(mois, libelle_mois)), `Ménages appelés` = nb(n_tires),
            `Ménages répondants` = nb(n_repondants), `Taux de réponse (%)` = pct(n_repondants / n_tires),
            `Calage` = ifelse(calage == "standard", "complet", "sans marge régionale"))
doc <- ajouter_tableau(doc, t1, taille = 9, largeurs = c(1.6, 1.2, 1.3, 1.2, 1.4))
doc <- ajouter_source(doc)

## 8. Mise en œuvre
doc <- T1("Mise en œuvre")
doc <- P("Les traitements sont réalisés en R. Les programmes se trouvent dans le dossier 02_PROG/Ponderation_ReGenesees du projet :")
doc <- B("run_all.R : pondération et soldes de tous les mois ;")
doc <- B("04_variations.R : évolutions entre deux mois et leur marge d'erreur ;")
doc <- B("06_serie.R : série consolidée ;")
doc <- B("07_bulletin_anstat.R : bulletin mensuel ;")
doc <- B("08_note_methodologique.R : la présente note.")
doc <- P("Les poids des ménages sont enregistrés dans 01_DATA/Poids, les résultats dans Resultat (Soldes, Variations, Serie) et ",
         "les bulletins dans Bulletins.")

# --- Écriture -------------------------------------------------------------------------
sortie <- file.path(RACINE, "Méthodologie", paste0("Note_Methodologique_ICV_", format(date_note, "%Y_%m_%d"), ".docx"))
doc <- appliquer_numerotation(doc)
doc <- garder_avec_suivant(doc, styles = c("Heading1", "Heading2", "Caption", "Titre1", "Titre2", "Lgende"))
doc <- footers_replace_all_text(doc, "Cellule d.Analyses Economiques", "Direction des Données et de l'Innovation", fixed = FALSE)
doc <- appliquer_police(doc)
ecrit <- tryCatch({ print(doc, target = sortie); TRUE }, error = function(e) FALSE)
if (!ecrit) {
  sortie <- sub("\\.docx$", paste0("_", format(Sys.time(), "%H%M"), ".docx"), sortie)
  print(doc, target = sortie)
}
forcer_police_docx(sortie)
cat("Note méthodologique écrite dans", sortie, "\n")
