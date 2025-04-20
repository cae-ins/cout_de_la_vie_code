
*******************************************************************
*DO FILE DE TRAITEMENT DES BASES DE DONNES ICV

**********************************************************
/*
cd "C:\Users\SADIA\Desktop\Working CAE\Indice de cherté de la vie"

use base_pilote_ICV_EJ,clear

encode region_m,gen(new_region)

drop region_m
rename new_region region_m


***Apurment des bases de données*************

replace Rg_interrogation=1 /*Nous sommes à la première interrogation du ménage*/

ta consentement /*67 ménages ont donné leur consentement*/
edit if consentement==2  /*Vérifier que ceux qui n'ont pas donné leur consentement ne répondent pas aux autres questions*/

keep if consentement==1

*/
****Début des statistiques descriptives****


***Charger la base de donnees


************************

************STATISTIQUES DESCRIPTIVES ET LABELISATION DES VALEURS

*********************************************************************************
*mode administration du questionnaire

****Pour les variabes a choix multiples

*****Préoccupation des menages
preserve
keep Preocup__*
gen id=_n
reshape long Preocup__ , i(id) j(Preocup)
collapse (sum) Preocup__ , by (Preocup)
list 
export excel "Stats_des_ICV.xlsx" , sheet(preoccupation, replace) firstrow(varlabels)
restore

*****

*domain_evolution

preserve
keep domain_evolution__*
gen id=_n
reshape long domain_evolution__ , i(id) j(domain_evolution)
collapse (sum) domain_evolution__ , by (domain_evolution)
list 
export excel "Stats_des_ICV.xlsx" , sheet(domain_evolution, replace) firstrow(varlabels)
restore

*strategie

preserve
keep strategies__*
gen id=_n
reshape long strategies__ , i(id) j(strategies)
collapse (sum) strategies__ , by (strategies)
list 
export excel "Stats_des_ICV.xlsx" , sheet(strategie, replace) firstrow(varlabels)
restore


foreach var of varlist mode migration milieu Situation_fin Situation_eco RE1_revenu variation_depenses endettement evolution_prix dynamique_prix taux_croissance {
    replace `var'=. if `var'==.a
xtable `var', row filename(Stats_des_ICV22.xlsx) sheet(`var')
}

**********************Construction de l'indicateur******************************
                      
				 ***Construction de l'indicateur****

***********************                           ******************************


/*NB: Deux approches ont été considérées dans le calcul des soldes

Approche INSEE: 1 pour positif 0 pour aucun et -1 pour négatif

Approche Banque de France: 1 poistif 0.5 Moyen+ 0 aucun -0.5 moyen negatif -1 Négatif

*/
******Calcul des soldes pour chaque poste identifié

**Situation financière

gen score_fin=1 if inlist(Situation_fin,1,2)
replace score_fin=-1 if inlist(Situation_fin,4,5)
replace score_fin=0 if Situation_fin==3

label var score_fin "INSEE:Solde situation fin"

gen bscore_fin=1 if Situation_fin==1
replace bscore_fin=0.5 if Situation_fin==2
replace bscore_fin=0 if Situation_fin==3
replace bscore_fin=-0.5 if Situation_fin==4
replace bscore_fin=-1 if Situation_fin==5

label var bscore_fin "Bnque:Solde situation fin"
**********************************************************
*Economie globale

gen score_eco=1 if inlist(Situation_eco,1,2)
replace score_eco=-1 if inlist(Situation_eco,4,5)
replace score_eco=0 if Situation_eco==3

label var score_eco "Solde économie globale"

***
gen bscore_eco=1 if Situation_eco==1
replace bscore_eco=0.5 if Situation_eco==2
replace bscore_eco=0 if Situation_eco==3
replace bscore_eco=-0.5 if Situation_eco==4
replace bscore_eco=-1 if Situation_eco==5

label var bscore_eco "Solde situation économique globale _Bque"

********************************
*Revenu et emploi

gen score_rev=1 if inlist(RE1_revenu,1,2)
replace score_rev=-1 if inlist(RE1_revenu,4,5)
replace score_rev=0 if RE1_revenu==3
sum score_rev

label var score_rev "Solde évolution du revenu mois prochain"

gen bscore_rev=1 if RE1_revenu==1
replace bscore_rev=0.5 if RE1_revenu==2
replace bscore_rev=0 if RE1_revenu==3
replace bscore_rev=-0.5 if RE1_revenu==4
replace bscore_rev=-1 if RE1_revenu==5

label var bscore_rev "Solde évolution du revenu: Banque"

**********************************
***Depenses et budget

gen score_dep=1 if inlist(variation_depenses,1,2)
replace score_dep=-1 if inlist(variation_depenses,4,5)
replace score_dep=0 if variation_depenses==3

label var score_dep "Solde évolution des dépenses"

gen bscore_dep=1 if variation_depenses==1
replace bscore_dep=0.5 if variation_depenses==2
replace bscore_dep=0 if variation_depenses==3
replace bscore_dep=-0.5 if variation_depenses==4
replace bscore_dep=-1 if variation_depenses==5

label var bscore_dep "Solde évolution des dépenses:Banque"

**Evolution des prix

gen score_evolution_prix=1 if inlist(evolution_prix,1,2)
replace score_evolution_prix=-1 if inlist(evolution_prix,4,5)
replace score_evolution_prix=0 if evolution_prix==3

label var score_evolution_prix "Solde évolution des prix"

gen bscore_evolution_prix=1 if evolution_prix==1
replace bscore_evolution_prix=0.5 if evolution_prix==2
replace bscore_evolution_prix=0 if evolution_prix==3
replace bscore_evolution_prix=-0.5 if evolution_prix==4
replace bscore_evolution_prix=-1 if evolution_prix==5

label var bscore_evolution_prix "Solde évolution des prix: banque"

*Dynamique des prix

gen score_dynamique_prix=1 if inlist(dynamique_prix,1,2)
replace score_dynamique_prix=-1 if inlist(dynamique_prix,4,5)
replace score_dynamique_prix=0 if dynamique_prix==3
sum score_dynamique_prix

label var score_dynamique_prix "dynamique prix au cours du trimestre passé"

gen bscore_dynamique_prix=1 if dynamique_prix==1
replace bscore_dynamique_prix=0.5 if dynamique_prix==2
replace bscore_dynamique_prix=0 if dynamique_prix==3
replace bscore_dynamique_prix=-0.5 if dynamique_prix==4
replace bscore_dynamique_prix=-1 if dynamique_prix==5

label var bscore_dynamique_prix "Banque:dynamique prix au cours du trimestre passé"

*endettement

gen score_dette=1 if inlist(endettement,1,2)
replace score_dette=-1 if inlist(endettement,4,5)
replace score_dette=0 if endettement==3

gen bscore_dette=1 if endettement==1
replace bscore_dette=0.5 if endettement==2
replace bscore_dette=0 if endettement==3
replace bscore_dette=-0.5 if endettement==4
replace bscore_dette=-1 if endettement==5

***Question  ouverte sur evolution de cherte de la vie

*Variable: Cherte_vie

gen score_Cherte_vie=1 if inlist(Cherte_vie,1,2)
replace score_Cherte_vie=-1 if inlist(Cherte_vie,4,5)
replace score_Cherte_vie=0 if Cherte_vie==3

gen bscore_Cherte_vie=1 if Cherte_vie==1
replace bscore_Cherte_vie=0.5 if Cherte_vie==2
replace bscore_Cherte_vie=0 if Cherte_vie==3
replace bscore_Cherte_vie=-0.5 if Cherte_vie==4
replace bscore_Cherte_vie=-1 if Cherte_vie==5

*Comportement d'épargne du ménage
for each var of varlist 



***************Fin du dofile de création des soldes*******








