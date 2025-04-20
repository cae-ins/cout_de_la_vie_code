

use "C:\Users\SADIA\Desktop\Cherte_vie\base_for_ponderation_ICV.dta" 


*****************Dofile ponderation***********

gen PdsChang = hhweight*(Changement_region==0)
edit region_m_ Region_update Changement_region hhweight PdsChang
by Region_update , sort : egen PdsEntr = total(PdsChang)
by region_m_ , sort : egen PdsSprt = total(PdsChang)
edit region_m_ Region_update Changement_region hhweight PdsChang PdsEntr PdsSprt
by region_m_ , sort : gen first= _n==1
edit region_m_ Region_update Changement_region hhweight PdsChang PdsEntr PdsSprt 

gen mois_1=1 if statut_reponse!=.

gen poids=hhweight*(mois_1)

by region_m_ , sort : egen PdsEch = total(poids)

edit region_m_ Region_update Changement_region hhweight PdsEch PdsChang PdsEntr PdsSprt 

gen num= (PdsEch- PdsSprt+ PdsEntr)

label var num "Numerateur du calcul de PU"

******Calcul du denominateur****

*calcul du total des ponderation par region

bysort region: egen total_pond_ehcvm=total(hhweight)

label var total_pond_ehcvm "total des pond ehcvm / region"

**nombre de menage pour chaque region dans la base brute de l'ehcvm*

bysort region:egen nb_menage=total(1)

label var nb_menage "nbr menage dans ehcvm pour la region"

***Nombre de ménage sélectionné parmi les 10669 par region

label var nb_tire "nombre de menage sélectionné dans les 10669"


*Calcul du NR: NR= Effectif interviewé / Tiré

bysort Region_update:egen nb_interview_m=total(consentement==1)
label var nb_interview "nbr interviewé à date"

bysort Region_update:egen na_interview=total(mois_1==1)

label var na_interview "nbr à interviewé à date"


***
/*Les éléments ci-contres ne sont pas jugés nécessaires à calculer :

gen pond_interviewe= hhweight*(consentement==1)
bysort Region_update:egen sig_inter_niew=total(pond_interviewe)

label var sig_inter "region_update:solde de ponderation des interviewés"

gen pond_a_inter=hhweight*(mois_1==1)
bysort Region_update:egen sig_a_inter=total(pond_a_inter)

label var sig_a_inter "sigma ponderation des menage à interviewer"


***Calcul de PU: Cette formule n'est pas correcte, car il faut raisonner en termes d'effectifs

*gen PU_new=(PdsEch +PdsEntr -PdsSprt)/( total_pond_ehcvm- (nb_menage/ na_interview)*(PdsEntr -PdsSprt))

*/

*****Vrai travaux effectués le 28 Mars 2025**************

/*gen test5= hhweight*( nb_menage/ na_interview) / Cette formule correspondrait au PU s'il n'y ait pas de migration
sum test5
di r(sum)
*/

*Calculons l'effectif de sortant et de migrant par region_m_

by Region_update , sort : gen firstUp = _n==1

gen chng=Changement_region==0
by Region_update , sort : egen nb_Entr = total(chng)
by region_m_ , sort : egen nb_sort = total(chng)

sum nb_Entr if firstUp==1

**** Calcul du Poids Uniforme et du taux de reponse*****************

***************************************************************************************

gen PUvf = (na_interview - nb_sort + nb_Entr) / (total_pond_ehcvm - PdsSprt + PdsEntr)

***************************************************************************************

*************************************************************************************
gen NRvf = (nb_interview_m - nb_sort + nb_Entr) / (na_interview - nb_sort + nb_Entr)

label var NRvf "Facteur de correction de non reponses"
gen PCvf = PUvf * NRvf
***************************************************************************************

*La variable pondv1 est la ponderation uniforme de chaque region en tenant compte de la migration
gen pondv1 = 1/PCvf
replace pondv1 = . if consentement!=1
sum pondv1
di r(sum)

/*Pour la suite.il s'agit de calculer le poids total et repartir aux différents ménages*/

by Region_update, sort : egen Totpondv1 = total(pondv1)
summ Totpondv1 if firstUp==1

gen hhwrep = hhweight
replace hhwrep = . if consentement!=1
by Region_update, sort : egen Tothhw = total(hhwrep)
drop hhwrep

/*Calcul des ponderations finales*/

gen pondvf = hhweight*Totpondv1/Tothhw
replace pondvf = . if consentement!=1

label var pondvf "ponderation finale du menage "

*Tester la vraissemblance des résultats

summ pondvf if consentement==1

di r(sum)

*******Créer une macro globale pour les valeurs objectifs clés*******

global important_var na_interview nb_sort  nb_Entr total_pond_ehcvm PdsSprt PdsEntr nb_interview_m pondvf pondv1 Totpondv1

***Suppression des variables 

cap drop Tothhw PU_new pond_interviewe sigma sig_inter_niew sig_inter pond_a_inter first firstUp

*******Prochaine Etape*********

merge 1:1 interview_cle using "C:\Users\SADIA\Desktop\Cherte_vie\Enq_Vie_Chere.dta",force

***************************
























