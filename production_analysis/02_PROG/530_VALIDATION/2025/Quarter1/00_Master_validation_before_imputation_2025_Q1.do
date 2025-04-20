*******************************************************************************************************************
*******************************************************************************************************************                
* 
*            EDITING RULES LFS ILO model 2024 - Antonio Discenza
* 
*            PROCEDURE WITH TWO STEPS
*              - STEP 1  - VALIDATION BEFORE IMPUTATION (PRODUCE A SUMMARY OF THE ERRORS BEFORE IMPUTATION)
* 
* 
*******************************************************************************************************************
*******************************************************************************************************************

clear all 
log close _all

* Name of the dataset containing raw data  
global    fileinp       "${DIR_DATA_441RD_YQ}\LFS_${YYYY_Q}_RAW.dta"
display "$fileinp"

* Name of the intermediate dataset containing raw data before validation
global    fileinterm    "$DIR_DATA_530CV_YQ\LFS_${YYYY_Q}_CHK_step_0.dta"
display "$fileinterm"

* Name of the output dataset containing results of validation on raw data  
global    fileout       "$DIR_DATA_530CV_YQ\LFS_${YYYY_Q}_CHK_step_1.dta"
display "$fileout"

* Name of the excel file containing results of validation on raw data  
global    fileoutxls    "$DIR_DATA_530CV_YQ\LFS_${YYYY_Q}_CHK_step_1_Summary.xls"
display "$fileoutxls"

* Name of the txt file containing log of the process  
global    fileoutlog    "$DIR_DATA_530CV_YQ\LFS_${YYYY_Q}_CHK_step_1_Log.txt"
display "$fileoutlog"

* Assgn nstep = 1 (first step, before imputation)  
global    nstep  1
display "$nstep"


*******************************************************************************************************************
*******************************************************************************************************************                
* 
*            STEP 1 - EDITING BEFORE CORRECTION
* 
*******************************************************************************************************************
*******************************************************************************************************************

use "$fileinp", clear

tab INTERVIEW_RESULT interview__status, m

keep if inlist(INTERVIEW_RESULT,1,2,3) & inlist(interview__status,100,120)


/* prepare the list to keep only the variables that needs to be on the final data (to be checked or not) */

run "$DIR_PROG_530CV\2024\Quarter4\03_Lists_of_all_variables_by_section_from_2024_Q4.do"


/* initial recoding of raw data and selection of the variables to be validated */

run "$DIR_PROG_530CV\2024\Quarter4\04_Prepare_raw_data_for_validation_from_2024_Q4.do"


/* SUBSTITUTE THE 0 and .a WITH . FROM THE DIFFERENT SECTIONS (IN CASE IT IS NEEDED) */

run "$DIR_PROG_530CV\2024\Quarter4\05_Substitute_missings_by_section_from_2024_Q4.do"


save "$fileinterm", replace


*******************************************************************************************************************
*******************************************************************************************************************                
* 
*            STEP 1 - VALIDATION BEFORE IMPUTATION
* 
*******************************************************************************************************************
*******************************************************************************************************************



use "$fileinterm", clear

drop if DEM_AGE == . //14 obs

save "$fileout", replace


use  "$fileout", clear

display  "$DIR_PROG_530CV_YQ\01_Validation_All_Variables_${YYYY_Q}.do"

run      "$DIR_PROG_530CV_YQ\01_Validation_All_Variables_${YYYY_Q}.do"



/* Distribution of errors per record before imputation */


tab Tot_err_x_rec_ALL_step1, missing 
tab Tot_err_x_rec_DEM_step1, missing 
tab Tot_err_x_rec_MIG_step1, missing 
tab Tot_err_x_rec_EDU_step1, missing 
tab Tot_err_x_rec_ATW_step1, missing 
tab Tot_err_x_rec_ABS_step1, missing 
tab Tot_err_x_rec_AGF_step1, missing 
tab Tot_err_x_rec_MJB_step1, missing
tab Tot_err_x_rec_SJB_step1, missing 
tab Tot_err_x_rec_WKT_step1, missing  
tab Tot_err_x_rec_SRH_step1, missing 
tab Tot_err_x_rec_OPC_step1, missing 
tab Tot_err_x_rec_OPF_step1, missing 
tab Tot_err_x_rec_MNF_step1, missing 

/*
tab Tot_err_x_rec_DEM_step1, missing 
tab Tot_err_x_rec_MIG_step1, missing 
tab Tot_err_x_rec_DIF_step1, missing 
tab Tot_err_x_rec_HLL_step1, missing 
tab Tot_err_x_rec_RSP_step1, missing 
*/



/* Copy everything from the Stata Result Window into a txt file and open it */

translate @Results "$fileoutlog", replace

winexec   notepad  "$fileoutlog"



