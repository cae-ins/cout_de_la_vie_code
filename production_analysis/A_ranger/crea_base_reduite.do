*******Sélection des ménages du mois Mars (Nouvel entrant

use "C:\Users\SADIA\Desktop\Cherte_vie\Echantillon_Global_ICV_.dta" 
merge 1:1 interview__key using "C:\Users\SADIA\Desktop\Cherte_vie\base_echantillon.dta"

/***
use "C:\Users\SADIA\Desktop\Cherte_vie\Echantillon_Global_ICV_.dta" 
ta interview_cle
compare interview__key interview_cle
compare interview__key interview_key_search
merge 1:1 interview__key using "C:\Users\SADIA\Desktop\Cherte_vie\base_echantillon.dta"
ta nom_prenom_cm
ta region
ta s00q01
compare region s00q01
compare nom_prenom_cm s00q10
gen num1_cm=s00q12a
gen num2_cm= s00q12b
gen num_autre=s00q14
ta s00q04
compare milieu s00q04
ta s00q04 milieu
rename s00q02 departement
rename s00q03 sous_pref
rename s00q05 localite
sort region milieu pcexp
edit
rename departement department_m
rename localite localite_m
rename sous_pref sous_prefecture_m
rename region region_m

**/
