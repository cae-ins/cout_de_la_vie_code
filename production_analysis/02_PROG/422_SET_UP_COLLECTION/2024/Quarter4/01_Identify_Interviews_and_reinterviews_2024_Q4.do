/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****                                                                                                                   *****/
/*****                         SUB-PROCESS 4.1.0:    SELECT THEORETHICAL QUARTERLY SAMPLE                                *****/
/*****                                                                                                                   *****/
/*****    1) Identify households that have been already interviewed (exclude those that refused or ineligible)           *****/ 
/*****    2) Retrieve information from the most recent interview (separately for each group of rotation)                 *****/
/*****    3) Identify households that need to have their first interview (from rot_group=1 or from other rot groups)     *****/
/*****                                                                                                                   *****/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/


********************************************************************************
******************************** MONTH 10 - OCTOBER ****************************
********************************************************************************

/*****    3) Identify households that need to have their first interview (from rot_group=1 or from other rot groups)     *****/

use "${DIR_DATA_415SS_YQ}\Sample_Theo_Maale_${YYYYQ}.dta", clear

keep if inlist(rot_group_id,"$YYYYQ","$YYYYQm1","$YYYYQm4","$YYYYQm5") & month==$m1

/* need to identify only the active interviews */

save "${DIR_DATA_422SU_YQ}\Month$m1\Sample_hhlds_first_interview_${YYYYQ}_M$m1.dta", replace


/*****    4) Identify households that can be used as substitutes (from rot_group=1 or from other rot groups)     *****/

use "${DIR_DATA_415SS_YQ}\Sample_Theo_Maale_${YYYYQ}.dta", clear

/* need to identify only the substitute interviews */
keep if inlist(type_ssu,2)
keep if month == 10 //only for this month

save "${DIR_DATA_422SU_YQ}\Month$m1\Substitute_hhlds_first_interview_${YYYYQ}_M$m1.dta", replace



********************************************************************************
******************************** MONTH 11 - NOVEMBER ***************************
********************************************************************************


use "${DIR_DATA_415SS_YQ}\Sample_Theo_Maale_${YYYYQ}.dta", clear

keep if inlist(rot_group_id,"$YYYYQ","$YYYYQm1","$YYYYQm4","$YYYYQm5") & month==$m2

/* need to identify only the active interviews */

save "${DIR_DATA_422SU_YQ}\Month$m2\Sample_hhlds_first_interview_${YYYYQ}_M$m2.dta", replace


/*****    4) Identify households that can be used as substitutes (from rot_group=1 or from other rot groups)     *****/

use "${DIR_DATA_415SS_YQ}\Sample_Theo_Maale_${YYYYQ}.dta", clear

/* need to identify only the substitute interviews */
keep if inlist(type_ssu,2)
keep if month == 11 //only for this month

save "${DIR_DATA_422SU_YQ}\Month$m2\Substitute_hhlds_first_interview_${YYYYQ}_M$m2.dta", replace




********************************************************************************
******************************** MONTH 12 - DECEMBER ***************************
********************************************************************************


use "${DIR_DATA_415SS_YQ}\Sample_Theo_Maale_${YYYYQ}.dta", clear
keep if inlist(rot_group_id,"$YYYYQ","$YYYYQm1","$YYYYQm4","$YYYYQm5") & month==$m3

/* need to identify only the active interviews */

save "${DIR_DATA_422SU_YQ}\Month$m3\Sample_hhlds_first_interview_${YYYYQ}_M$m3.dta", replace



use "${DIR_DATA_415SS_YQ}\Sample_Theo_Maale_${YYYYQ}.dta", clear

/* need to identify only the substitute interviews */
keep if inlist(type_ssu,2)
keep if month == 12 //only for this month

save "${DIR_DATA_422SU_YQ}\Month$m3\Substitute_hhlds_first_interview_${YYYYQ}_M$m3.dta", replace


