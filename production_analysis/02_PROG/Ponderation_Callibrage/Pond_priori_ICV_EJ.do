
use "C:\Users\SADIA\Desktop\Cherte_vie\base_echantillon_cherte_Use.dta" 

*****Calcul des pondérations des ménages à priori***

/*Pondération transversale: Elle est obtenue en faisant le produit de la pondération de l'EHCVM 2021
 
 et le ration l'effectif tiré dans la région par le nombre de ménage en interrogation à cette date*/

*Etape 1: Calculer le total de ménage en interrogation pour chaque mois

 bysort region : gen nb_tire = _N 
 
forvalues i = 1/27 {
    bysort region :gen mois_interro_`i' =0
	 replace mois_interro_`i' =1 if inrange(sous_echantillon,`i'-2,`i')|inrange(sous_echantillon,`i'-14,`i'-12)
	 bysort region:egen nbr_interro_`i'=total(mois_interro_`i'==1) 
	 gen pond_`i'=hhweight*nb_tire/nbr_interro_`i'
	 label var mois_interro_`i' "Echantillon global au mois `i'
	 label var nbr_interro_`i' "Effectif de l'échantillon au mois `i'"
}

bysort region_m:egen total_pond_tirage_m=total(hhweight)

label var total_pond_tirage_m "ponderation totale de l'échantillon initial (10669)"


*******************************Ajustement des pondérations*****************************************
                               
*******************************Ajustement des pondérations (ICV)**************************************

/*Etape 0: Je charge la base de données dans laquelle se trouve l'ancienne région (région_m)

et la nouvelle région après mise à jour de la base (Région_update)*/

use "C:\Users\SADIA\Desktop\Cherte_vie\ponderation_calibrage\changement_T1_ICV.dta" 

/*Etape 1: Calcul préliminaires des pondérations (cumul de poids des entrants et cumul de poids des sortants)*/


*Identification des sortants ou entrants: Lorsqu'un individu a changé de localité, il réprésente pour la région de départ un sortant et pour la nouvelle région un nouvel entrant; Ainsi on a :

bysort Region_update : egen pond_entrant_ = total( hhweight ) if Changement_région == 0

ta pond_entrant

label var pond_entrant "cumul des pondérations des entrants"


bysort region_m_ : egen pond_sortant_ = total(hhweight) if Changement_région == 0

edit region_m_ hhweight pond_entrant_ pond_sortant_

label var pond_entrant "cumul des pondérations des sortants"

codebook consentement



bysort Region_update_ : egen pond_repondant = total(hhweight) if consentement!=1

label var pond_entrant "cumul des pondérations des répondants"



bysort Region_update_ : egen pond_repondant = total(hhweight) if consentement!=1

label var pond_entrant "cumul des pondérations des non répondants"


bysort region_m_  : egen pond_initial = total(hhweight)
label var pond_initial "cumul des pondérations sans attrition ni migration"












*Etape 1: Ajustement par les non-réponses

/*gen intermediate_weight = design_weight * non_response_adj where non_response_adj est l'inverse du taux de réponse*/

****Calcul des variables élémentaires****