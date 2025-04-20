***Do file Rapport Cherté de la vie: Mois de février****

global main C:\Users\SADIA\Desktop\Cherte_vie

global output C:\Users\SADIA\Desktop\Cherte_vie\RESULTAT

******Etape préliminaire********************
/*
use "$main\Echantillon_Global_ICV_",clear
gen interview_cle= interview__key
drop _merge
save "$main\Echantillon_Global_ICV_.dta", replace
base_echantillon_cherte
*/
********************************************

use "$main\Enq_Vie_Chere.dta",clear

merge 1:1 interview_cle using "$main\Echantillon_Global_ICV_.dta"
keep if _merge==3

*use "$main\base_echantillon_cherte.dta",clear

****Stat descriptives des non répondants et personnes ayant migré**

xtile decile = pcexp [aw=hhweight], nq(10)
