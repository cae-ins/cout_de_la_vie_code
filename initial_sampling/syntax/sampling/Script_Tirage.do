
********Do file de tirage des ménages de l'ICV_Grande phase
clear
cls
global project "C:\Users\fajmi\OneDrive - GOUVCI\CAE_INS - Fichiers de Cellule d'Analyses Economiques ( CAE)\ICV"

global data_input = "${project}\data_input"
global data_out = "${project}\data_out"
global data_temp = "${project}\data_temp"
global program = "${project}\program"


import excel "${data_input}\Tirage.xlsx", firstrow
mkmat CodReg_Id A_Tirer_Final, mat(Ech_Samp)

use "${data_input}\s00_me_CIV2021_withnameshh.dta",clear

count
gen num=0

*edit s00q12a s00q12a1 s00q12b s00q14 

replace num=1 if !inlist(s00q12a,"","88 88 88 88 88")

***744 ménages chefs de ménages n'ont pas donné leurs numéros***

*count if inlist(s00q12b,"","88 88 88 88 88")

replace num=1 if !inlist(s00q12b,"","88 88 88 88 88") & num==0

replace num=1 if num==0 & !inlist(s00q14,"","88 88 88 88 88")

replace num=2 if num==0 & s00q15a==1

label define num 0 "Pas de contact" 1 "Numéro d'un membre du ménage" 2 "Numéro pas fiable_Hors membre"

label values num num

save "${data_temp}\contact_21_ehcvm.dta", replace

*****
merge 1:1 vague grappe menage using "${data_input}\ehcvm_welfare_2b_CIV2021.dta"

save "${data_temp}\base_tirage_global_ICV.dta", replace

****Effectuer le tirage des ménages

use "${data_temp}\base_tirage_global_ICV.dta", clear
keep if num==1

***537 ménages n'ont pas de numéro fiables pour l'opération: On retient que 12428
****

set seed 45006280
*rm folder_final
cap mkdir "${project}\folder_final"
cd "${project}\folder_final"
forvalues i = 1/33 {
    preserve
    keep if region == `i'
    local CodReg = Ech_Samp[`i',1]
    local menage = Ech_Samp[`i',2]
	dis `CodReg'
	dis `menage'
    
    quietly {
        capture do "${program}\Module_Samp_Systematic.do" `menage' `CodReg'
        if _rc != 0 {
            di as error "Erreur dans l'exécution pour region = `i', menage = `menage', CodReg = `CodReg'"
			save "${project}\folder_final\base_group_`CodReg'", replace
			restore
            continue
        }
    }
    
    restore
}


clear
append using `: dir . files "base_group_*.dta"'
save "${data_out}\Echantillon_Global_ICV.dta", replace
