*******************************************************************************************************************
*******************************************************************************************************************                
* 
*            EDITING RULES LFS ILO model 2024 - Antonio Discenza
* 
*            PROCEDURE WITH TWO STEPS
*              - STEP 2  - VALIDATION AFTER IMPUTATION   (PRODUCE A SUMMARY OF THE ERRORS THAT REMAINS AFTER IMPUTATION)
* 
* 
*******************************************************************************************************************
*******************************************************************************************************************


clear all 
log close _all

* Name of the dataset containing imputed data 
 
global    fileinp       "${DIR_DATA_540IM_YQ}\LFS_Maale_${YYYY_Q}_IMP.dta"
display "$fileinp"


* Name of the output dataset containing results of validation on imputed data  

global    fileout       "$DIR_DATA_530CV_YQ\LFS_Maale_${YYYY_Q}_CHK_step_2.dta"
display "$fileout"

* Name of the excel file containing results of validation on raw data  
global    fileoutxls    "$DIR_DATA_530CV_YQ\LFS_Maale_${YYYY_Q}_CHK_step_2_Summary.xls"
display "$fileoutxls"

* Name of the txt file containing log of the process  
global    fileoutlog    "$DIR_DATA_530CV_YQ\LFS_Maale_${YYYY_Q}_CHK_step_2_Log.txt"
display "$fileoutlog"

* Assgn nstep = 2 (second step, after imputation)  
global    nstep  2
display "$nstep"


*******************************************************************************************************************
*******************************************************************************************************************                
* 
*           STEP 2 - VALIDATION AFTER IMPUTATION
* 
*******************************************************************************************************************
*******************************************************************************************************************

use  "$fileinp", clear

save "$fileout", replace

use  "$fileout", replace

//display  "$DIR_PROG_530CV_YQ\01_Validation_All_Variables_${YYYY_Q}.do"


run      "$DIR_PROG_530CV_YQ\01_Validation_All_Variables_${YYYY_Q}.do"

//"W:\LFS_GSBPM\PROG\530_VALIDATION\2024\Quarter4\01_Validation_All_Variables_2024_Q4.do"

/* Distribution of errors per record before imputation */


use "$fileout", replace

tab Tot_err_x_rec_ALL_step2, missing 


tab Tot_err_x_rec_ATW_step2, missing 
tab Tot_err_x_rec_ABS_step2, missing 
tab Tot_err_x_rec_AGF_step2, missing 
tab Tot_err_x_rec_MJB_step2, missing 
tab Tot_err_x_rec_SRH_step2, missing 


/*
tab Tot_err_x_rec_DEM_step2, missing 
tab Tot_err_x_rec_MIG_step2, missing 
tab Tot_err_x_rec_DIF_step2, missing 
tab Tot_err_x_rec_HLL_step2, missing 
tab Tot_err_x_rec_RSP_step2, missing 
*/

/* Copy everything from the Stata Result Window into a txt file and open it */

translate @Results "$fileoutlog", replace

winexec   notepad  "$fileoutlog"



