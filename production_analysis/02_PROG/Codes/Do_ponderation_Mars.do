
*Importer la base de données principale

use "C:\Users\SADIA\Desktop\Cherte_vie\Cherte_Mars_2025.dta"

*Fusion la base principale avec la base global_ehcvm

merge 1:1 interview_cle using "C:\Users\SADIA\Desktop\Cherte_vie\Indice_cherte_vie\02_PROG\Ponderation_Callibrage\global_base_ehcvm_Use.dta",gen(fusion) force

***Enregistrer une base for ponderation***********

save base_for_ponderation_ICV_Mai.dta, replace


use base_for_ponderation_ICV_Mai.dta,clear

*****************Dofile ponderation***********

gen insample=1 if cle_men!="" /*Insample permet d'identifier ceux qui sont en interrogation pour ce mois_2*/

*******Identification de ceux qui migré entre 2021 et maintenant****

gen chang_region=0 if insample==1 
replace chang_region=1 if region_21!=region_2 & insample==1 /*La variable chang_region permet d'identifier
ceux qui ont changé de région*/
ta chang_region

**********                 *************************

**Calcul du cumul de ponderation des entrants, des sortants et actuels

gen PdsChang = hhweight*(chang_region==1)
*edit region_m_ Region_update chang_region hhweight PdsChang
by region_2 , sort : egen PdsEntr = total(PdsChang) /*cumul de ponderation des entrants*/
label var PdsEntr "Sigma pond entrant"

by region_21 , sort : egen PdsSprt = total(PdsChang) /*cumul de ponderation des sortants*/
edit region_21 region_2 chang_region hhweight PdsChang PdsEntr PdsSprt

drop first
by region_21 , sort :  gen first= _n==1

*edit region_21 region_2 chang_region hhweight PdsChang PdsEntr PdsSprt if first==1

gen mois_2=1 if insample==1

gen poids=hhweight*(mois_2)

by region_21, sort : egen PdsEch = total(poids) /*Poids total echantillon*/

*edit region_m_ Region_update chang_region hhweight PdsEch PdsChang PdsEntr PdsSprt 

gen num= (PdsEch- PdsSprt+ PdsEntr)

label var num "Numerateur du calcul de PU"

******Calcul du denominateur****

*calcul du total des ponderation par region (Variable déjà calculé dans la base /12965)

/*bysort region_2: egen total_pond_ehcvm=total(hhweight)

label var total_pond_ehcvm "total des pond ehcvm / region"*/

**nombre de menage pour chaque region dans la base brute de l'ehcvm*

bysort region_21:egen nb_menage=total(1)

label var nb_menage "nbr menage dans ehcvm pour la region"

***Nombre de ménage sélectionné parmi les 10669 par region

label var nb_tire "nombre de menage sélectionné dans les 10669"


*Calcul du NR: NR= Effectif interviewé / Tiré

bysort region_2:egen nb_interview_m=total(consent==1)
label var nb_interview "nbr interviewé à date"

bysort region_2:egen na_interview=total(mois_2==1)

label var na_interview "nbr à interviewé à date"

*Calculons l'effectif de sortant et de migrant par region_m_

by region_2, sort : gen firstUp = _n==1
by region_2 , sort : egen nb_Entr = total(chang_region)
by region_21, sort : egen nb_sort = total(chang_region)

sum nb_Entr if firstUp==1

************* Calcul du Poids Uniforme et du taux de reponse*****************

*****************************************************************************

gen PUvf = (na_interview - nb_sort + nb_Entr) / (total_pond_ehcvm - PdsSprt + PdsEntr)

************************************************************************************

************************************************************************************
gen NRvf = (nb_interview_m - nb_sort + nb_Entr) / (na_interview - nb_sort + nb_Entr)

label var NRvf "Facteur de correction de non reponses"

gen PCvf = PUvf * NRvf
*************************************************************************************

*La variable pondv1 est la ponderation uniforme de chaque region en tenant compte de la migration

gen pondv1 = 1/PCvf
replace pondv1 = . if consent!=1
sum pondv1
di r(sum)

/*Pour la suite.il s'agit de calculer le poids total et repartir aux différents ménages*/

by region_2, sort : egen Totpondv1 = total(pondv1)
summ Totpondv1 if firstUp==1

gen hhwrep = hhweight
replace hhwrep = . if consent!=1
by region_2, sort : egen Tothhw = total(hhwrep)
drop hhwrep

/*Calcul des ponderations finales*/

gen pondvf = hhweight*Totpondv1/Tothhw
replace pondvf = . if consent!=1

label var pondvf "ponderation finale du menage "

*Tester la vraissemblance des résultats

summ pondvf if consent==1

di r(sum)

*******Créer une macro globale pour les valeurs objectifs clés*******

global important_var na_interview nb_sort  nb_Entr total_pond_ehcvm PdsSprt PdsEntr nb_interview_m pondvf pondv1 Totpondv1

***Suppression des variables 

cap drop Tothhw PU_new pond_interviewe sigma sig_inter_niew sig_inter pond_a_inter first firstUp

*******Prochaine Etape*********

/*Il faut par la suite exétucer le dofile construction_solde et in fine exécuter le dofile

sadia_indicator*/

***************************
























