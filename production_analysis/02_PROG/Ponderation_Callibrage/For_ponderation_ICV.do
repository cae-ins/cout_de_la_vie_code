

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

*Variable jugée non nécessaire
*****

****

*Calcul du NR: NR= Effectif interviewé / Tiré

bysort Region_update:egen nb_interview_m=total(consentement==1)
label var nb_interview "nbr interviewé à date"

bysort Region_update:egen na_interview=total(mois_1==1)

label var na_interview "nbr à interviewé à date"


***

gen pond_interviewe= hhweight*(consentement==1)
bysort Region_update:egen sig_inter_niew=total(pond_interviewe)

label var sig_inter "region_update:solde de ponderation des interviewés"

gen pond_a_inter=hhweight*(mois_1==1)
bysort Region_update:egen sig_a_inter=total(pond_a_inter)

label var sig_a_inter "sigma ponderation des menage à interviewer"


***Calcul de PU

gen PU_new=(PdsEch +PdsEntr -PdsSprt)/( total_pond_ehcvm- (nb_menage/ na_interview)*(PdsEntr -PdsSprt))


/*Test effectué par le prof

gen te3 = total_pond_ehcvm / PdsEch
sum te3 if mois_1 ==1
di r(sum)
edit Region_update PdsEch total_pond_ehcvm te3 nb_menage na_interview if first
gen te4 = 1/((na_interview/nb_menage)*(PdsEch/total_pond_ehcvm))
sum te4 if first & Region_update!=.
di r(sum)
sum te4 if Region_update!=.
di r(sum)
drop te1 te2 te3 te4
gen te4 = 1/((na_interview)*(PdsEch/total_pond_ehcvm))
sum te4 if Region_update!=.
drop te4
gen te4 = 1/(na_interview/total_pond_ehcvm)
sum te4 if Region_update!=.
di r(sum)

*/


