

*******************************************************************************************************************
*******************************************************************************************************************                
* 
*            STEP 0 - PREPARE RAW DATA V1
* 
*******************************************************************************************************************
*******************************************************************************************************************


* Assign macro parameters to the standard Datasets from SURVEY SOLUTION 

/* Assign the name of the SURVEY SOLUTION questionnaire */
global name_quest                "LFS_2024_V5"  
display "$name_quest"

global   COVER    		"${DIR_DATA_432RD_YQ}\V5\\${name_quest}.dta"
display "$COVER"

global   R_DEM    		"${DIR_DATA_432RD_YQ}\V5\\UsualMembers.dta"
display "$R_DEM"

global   ALL_VAR   		"${DIR_DATA_441RD_YQ}\LFS_Maale_${YYYY_Q}_RAW_V5.dta"
display "$ALL_VAR"


use  "$COVER", clear

merge 1:m interview__key interview__id using "$R_DEM" 


/*
replace MIG_USL_YR=9997 if MIG_USL_YR == -99

replace EDU_YRS=97 if EDU_YRS == -99

replace WKT_ACHRSTOT = WKT_ACHRSTOT_CALC if GLO_EMP==1 & MJJ_MULT==1
replace WKT_ACHRSTOT = WKT_ACHRSTOT_CALC if GLO_EMP==1 & MJJ_MULT==2 & WKT_ACHRSTOT_CHK==1
replace WKT_ACHRSTOT = WKT_ACHRSTOT_REP  if GLO_EMP==1 & MJJ_MULT==2 & (WKT_ACHRSTOT_CHK==2 | WKT_ACHRSTOT_CALC==997)

generate SRH_AVN = .
*/

drop _merge

/* Save the single dataset  */ 

//generate SUSO_VERSION= "$name_quest"

save       "$ALL_VAR", replace	

use "${DIR_DATA_441RD_YQ}\LFS_Maale_${YYYY_Q}_RAW_V5.dta", clear

tab INTERVIEW_RESULT, missing


tab SUSO_VERSION, missing


*******************************************************************************************************************
*******************************************************************************************************************                
* 
*            STEP 1 - APPEND ALL THE DATASETS
* 
*******************************************************************************************************************
*******************************************************************************************************************


* put all together
clear all

use          "${DIR_DATA_441RD_YQ}\LFS_Maale_${YYYY_Q}_RAW_V5.dta", clear

* append using "${DIR_DATA_441RD_YQ}\LFS_Maale_${YYYY_Q}_RAW_V6.dta"


save         "${DIR_DATA_441RD_YQ}\LFS_Maale_${YYYY_Q}_RAW.dta", replace

sort id_hh_sas PPNO

tab SUSO_VERSION INTERVIEW_RESULT, missing


tab SUSO_VERSION type_ssu if INTERVIEW_RESULT == 1 ,missing

collapse (count) id_psu_n (mean) total_members  if INTERVIEW_RESULT ==1 , by(GHI_HOUSEHOLD_ID)

tab total_members , missing
