****Apurement de la base de données du Mois 2*********

use "C:\Users\SADIA\Desktop\Cherte_vie\Enq_Vie_Chere_3_STATA_All_Mars\Enq_Vie_Chere.dta" 

cap gen delete=1  if !regexm( cle_men , "Cherte") /*Nous avions fait une mauvaise affectation de 222 ménages*/

keep if delete!=1

*replace region = substr(region, strpos(region, ". ") + 2, .)

cap gen mois_2=1

ta consentement,m /*sur 886 ménages à enqueter, seulement 546 ont donné leurs consentement, soit un taux de réponse de 61,63% dans l'ensemble*/

replace region_m="ABIDJAN" if region_m=="AUTONOME D'ABIDJAN"
replace region_m="GOH" if region_m=="GÔH"
replace region_m="GBOKLE" if region_m=="GBÔKLE"
replace region_m="LOH-DJIBOUA" if region_m=="LÔH-DJIBOUA"

ta Statut_menage consentement,m

/*Le taux réponse pour les nouveaux entrants est de 62,8% à raison de 280 ménages enquêtés sur 446 prévus*/