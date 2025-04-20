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


/*****    1) Identify households that have been already interviewed (exclude those that refused or ineligible)           *****/ 

use "${DIR_DATA_415SS_YQ}\Sample_Theo_${YYYYQ}.dta", clear

/**** add steps to identify households that can be reinterviewed ****/
/**** substitute the command below ****/

keep if quarter !=  $QUARTER

save "${DIR_DATA_422SU_YQ}\Sample_hhlds_to_be_reinterviewed_${YYYYQ}.dta", replace



/*****    3) Identify households that need to have their first interview (from rot_group=1 or from other rot groups)     *****/

use "${DIR_DATA_415SS_YQ}\Sample_Theo_${YYYYQ}.dta", clear

keep if quarter ==  $QUARTER

save "${DIR_DATA_422SU_YQ}\Sample_hhlds_first_interview_${YYYYQ}.dta", replace

