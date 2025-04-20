

*******************************************************************************************************************
*******************************************************************************************************************                
* 
*            STEP 0 - PREPARE RAW DATA V1
* 
*******************************************************************************************************************
*******************************************************************************************************************


* Assign macro parameters to the standard Datasets from SURVEY SOLUTION 

/* Assign the name of the SURVEY SOLUTION questionnaire */
global name_quest                "LFS_2024"  
display "$name_quest"

global   COVER    		"${DIR_DATA_432RD_YQ}\V1\\${name_quest}.dta"
display "$COVER"

global   R_DEM    		"${DIR_DATA_432RD_YQ}\V1\\UsualMembers.dta"
display "$R_DEM"

global   ALL_VAR   		"${DIR_DATA_441RD_YQ}\LFS_${YYYY_Q}_RAW_V1.dta"
display "$ALL_VAR"


use  "$COVER", clear

merge 1:m interview__key interview__id using "$R_DEM" 

drop _merge

/* Save the single dataset  */ 

generate SUSO_VERSION= "$name_quest"

save       "$ALL_VAR", replace	


use "${DIR_DATA_441RD_YQ}\LFS_${YYYY_Q}_RAW_V1.dta", clear

tab INTERVIEW_RESULT, missing





*******************************************************************************************************************
*******************************************************************************************************************                
* 
*            STEP 0 - PREPARE RAW DATA V2
* 
*******************************************************************************************************************
*******************************************************************************************************************


* Assign macro parameters to the standard Datasets from SURVEY SOLUTION 

/* Assign the name of the SURVEY SOLUTION questionnaire */
global name_quest                "LFS_2024_V2"  
display "$name_quest"

global   COVER    		"${DIR_DATA_432RD_YQ}\V2\\${name_quest}.dta"
display "$COVER"

global   R_DEM    		"${DIR_DATA_432RD_YQ}\V2\\UsualMembers.dta"
display "$R_DEM"

global   ALL_VAR   		"${DIR_DATA_441RD_YQ}\LFS_${YYYY_Q}_RAW_V2.dta"
display "$ALL_VAR"


use  "$COVER", clear

merge 1:m interview__key interview__id using "$R_DEM" 

drop _merge

save       "$ALL_VAR", replace	


use "${DIR_DATA_441RD_YQ}\LFS_${YYYY_Q}_RAW_V2.dta", clear

tab INTERVIEW_RESULT, missing




*******************************************************************************************************************
*******************************************************************************************************************                
* 
*            STEP 1 - APPEND THE 2 DATASETS
* 
*******************************************************************************************************************
*******************************************************************************************************************


* put all together
clear all

use          "${DIR_DATA_441RD_YQ}\LFS_${YYYY_Q}_RAW_V1.dta", clear

append using "${DIR_DATA_441RD_YQ}\LFS_${YYYY_Q}_RAW_V2.dta"

save         "${DIR_DATA_441RD_YQ}\LFS_${YYYY_Q}_RAW.dta", replace

sort id_hh_sas PPNO

tab SUSO_VERSION INTERVIEW_RESULT, missing


tab SUSO_VERSION type_ssu if INTERVIEW_RESULT == 1 ,missing


