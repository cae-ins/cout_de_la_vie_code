*******************************************************************************************************************
*******************************************************************************************************************                
* 
*            VALIDATION FOR STEP 1 AND STEP 2
* 
*******************************************************************************************************************
*******************************************************************************************************************
	
*******************************************************************************************************************
*
*          DERIVE FLAGS TO HIGHLIGH PROBLEMS WITH QUESTIONS AND SECTIONS - BEFORE IMPUTATION
* 
*             1 - out of range
*             2 - missing: to impute
*             3 - undue wrong filter: to delete
*             9 - undue < 15: to delete
*
*******************************************************************************************************************


use "$fileout",  clear



********************************************************           Module 01  DEM 
run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_01_DEM_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_DEM_1 {
    tab `var' if `var'>0 , miss
}


********************************************************           Module 01  DEM 
run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_02_EDU_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_EDU_1 {
    tab `var' if `var'>0 , miss
}


********************************************************           Module 02  MIG
run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_02_MIG_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_MIG_1 {
    tab `var'  if `var'>0 , miss
}



********************************************************           Module 14  RSP
/*
run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_04_RSP_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_RSP_1 {
    tab `var'  if `var'>0 , miss	
}	
*/


********************************************************           Module 05  ATW
run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_05_ATW_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_ATW_1 {
    tab `var' if `var'>0 , miss
}

********************************************************           Module 06 ABS
run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_06_ABS_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_ABS_1 {
    tab `var' if `var'>0 , miss
}

*******************************************************            Module 07 AGF
run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_07_AGF_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_AGF_1 {
    tab `var' if `var'>0 , miss
}

*****************************************************              Module 08  HLA
/*
*run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_08_HLA_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_HLA_1 {
    tab `var' if `var'>0 , miss
}
*/

*****************************************************              Module 09 MJB
run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_09_MJB_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_MJB_1 {
    tab `var' if `var'>0 , miss
}

****************************************************               Module 10 SJB

run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_10_SJB_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_SJB_1 {
    tab `var' if `var'>0 , miss
}

********************************************************           Module 11_WKT  

run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_11_WKT_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_WKT_1 {
    tab `var' if `var'>0 , miss
}

******************************************************             Module 12 SRH
run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_12_SRH_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_SRH_1 {
    tab `var' if `var'>0 , miss
}


/*
********************************************************           Module 15_INC
*run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_13_INC_from_2024_Q4.do"
save "$fileout", replace
*foreach var of varlist $List_F_INC_1 {
*    tab `var' if `var'>0 , miss
*}
*/


********************************************************          Module 16_OPC
run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_14_OPC_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_OPC_1 {
    tab `var' if `var'>0 , miss
}



******************************************************             Module 13_OPF
run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_15_OPF_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_OPF_1 {
    tab `var' if `var'>0 , miss
}


******************************************************            Module 18_MNF
run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_17_MNF_from_2024_Q4.do"
save "$fileout", replace
foreach var of varlist $List_F_MNF_1 {
    tab `var' if `var'>0 , miss
}
	
	
******************************************************            Module 20_HFI
*run "$DIR_PROG_530CV\2024\Quarter4\06_Derive_flags_Module_20_HFI_from_2024_Q4.do"
*save "$fileout", replace
*foreach var of varlist $List_F_HFI_1 {
*    tab `var' if `var'>0 , miss
*}	
	
	
		
/*******************************************************************************************************************
*
*            DEFINE THE LIST OF MODULES THAT HAVE BEEN VALIDATED
* 
*******************************************************************************************************************/

global List_ALL_MODULES_0 ///
$List_F_DEM_0 ///
$List_F_MIG_0 ///
$List_F_EDU_0 ///
$List_F_ATW_0 ///
$List_F_ABS_0 ///
$List_F_AGF_0 ///
$List_F_MJB_0 ///
$List_F_SJB_0 ///
$List_F_WKT_0 ///
$List_F_SRH_0 ///
$List_F_OPC_0 ///
$List_F_OPF_0 ///
$List_F_MNF_0    
  

display "$List_ALL_MODULES_0"


global List_ALL_MODULES_1 ///
$List_F_DEM_1 ///
$List_F_MIG_1 ///
$List_F_EDU_1 ///
$List_F_ATW_1 ///
$List_F_ABS_1 ///
$List_F_AGF_1 ///
$List_F_MJB_1 ///
$List_F_SJB_1 ///
$List_F_WKT_1 ///
$List_F_SRH_1 ///
$List_F_OPC_1 ///
$List_F_OPF_1 ///
$List_F_MNF_1    


display "$List_ALL_MODULES_1"
	
	

/*******************************************************************************************************************
*
*            CALCULATES FOR EACH RECORD THE TOTAL NUMBER OF ERRORS IN EACH MODULE AND IN TOTAL
* 
*******************************************************************************************************************/


cd "$DIR_DATA_530CV_YQ"
use "$fileout", clear
save "sum_err_x_rec_step$nstep.dta", replace

* DO NOT use " " for the name of the list when you have the REPLACE command */
foreach var of varlist $List_ALL_MODULES_1 { 	 	
   replace `var'=1 if `var'>1
}

/*

egen Tot_err_x_rec_MIG_step$nstep = rowtotal( $List_F_MIG_1 )
egen Tot_err_x_rec_DIF_step$nstep = rowtotal( $List_F_DIF_1 )
egen Tot_err_x_rec_HLL_step$nstep = rowtotal( $List_F_HLL_1 )
egen Tot_err_x_rec_RSP_step$nstep = rowtotal( $List_F_RSP_1 )
*/

egen Tot_err_x_rec_DEM_step$nstep = rowtotal( $List_F_DEM_1 )
egen Tot_err_x_rec_MIG_step$nstep = rowtotal( $List_F_MIG_1 )
egen Tot_err_x_rec_EDU_step$nstep = rowtotal( $List_F_EDU_1 )
egen Tot_err_x_rec_ATW_step$nstep = rowtotal( $List_F_ATW_1 )
egen Tot_err_x_rec_ABS_step$nstep = rowtotal( $List_F_ABS_1 )
egen Tot_err_x_rec_AGF_step$nstep = rowtotal( $List_F_AGF_1 )
egen Tot_err_x_rec_MJB_step$nstep = rowtotal( $List_F_MJB_1 )
egen Tot_err_x_rec_SJB_step$nstep = rowtotal( $List_F_SJB_1 )
egen Tot_err_x_rec_WKT_step$nstep = rowtotal( $List_F_WKT_1 )
egen Tot_err_x_rec_SRH_step$nstep = rowtotal( $List_F_SRH_1 )
egen Tot_err_x_rec_OPC_step$nstep = rowtotal( $List_F_OPC_1 )
egen Tot_err_x_rec_OPF_step$nstep = rowtotal( $List_F_OPF_1 )
egen Tot_err_x_rec_MNF_step$nstep = rowtotal( $List_F_MNF_1 )
egen Tot_err_x_rec_ALL_step$nstep = rowtotal( $List_ALL_MODULES_1 )

keep interview__key interview__id PPNO ///
Tot_err_x_rec_DEM_step$nstep ///
Tot_err_x_rec_MIG_step$nstep ///
Tot_err_x_rec_EDU_step$nstep ///
Tot_err_x_rec_ATW_step$nstep ///
Tot_err_x_rec_ABS_step$nstep ///
Tot_err_x_rec_AGF_step$nstep ///
Tot_err_x_rec_MJB_step$nstep ///
Tot_err_x_rec_SJB_step$nstep ///
Tot_err_x_rec_WKT_step$nstep ///
Tot_err_x_rec_SRH_step$nstep ///
Tot_err_x_rec_OPC_step$nstep ///
Tot_err_x_rec_OPF_step$nstep ///
Tot_err_x_rec_MNF_step$nstep ///
Tot_err_x_rec_ALL_step$nstep 

/*
Tot_err_x_rec_DEM_step$nstep ///
Tot_err_x_rec_DIF_step$nstep ///
Tot_err_x_rec_HLL_step$nstep ///
Tot_err_x_rec_RSP_step$nstep ///
*/

save "sum_err_x_rec_step$nstep.dta", replace	

/* merge the information back to the file */


use  "$fileout", clear

merge m:1 interview__key interview__id PPNO using "sum_err_x_rec_step$nstep.dta" 

drop _merge

/* Save the single dataset  */ 

save       "$fileout", replace	



/*******************************************************************************************************************
*
*            CALCULATE THE QUALITY INDICATORS ABOUT ELIGIBILITY FOR EACH QUESTION AND ERRORS 
* 
*******************************************************************************************************************/

/*******************************  SUMMARY FLAG 0 ***************************/



cd "$DIR_DATA_530CV_YQ"
clear all
use "$fileout"
generate VER_SUSO_QUESTIONNAIRE="LFS_2024_T1"
save "sum_flag_0_step$nstep.dta", replace

/* DO use " " for the name of the list when you have the COLLAPSE command */
collapse (sum) "$List_ALL_MODULES_0" , by (VER_SUSO_QUESTIONNAIRE) 

rename F_* *
rename *_0 *
generate FLAG_TYPE ="0 - No. record"
save "sum_flag_0_step$nstep.dta", replace




/*******************************  SUMMARY ALL FLAGS (total of 1,2,3,9)  ***************************/

cd "$DIR_DATA_530CV_YQ"
clear all
use "$fileout"
generate VER_SUSO_QUESTIONNAIRE="LFS_2024_T1"
save "sum_flag_err_step$nstep.dta", replace

/* DO NOT use " " for the name of the list when you have the REPLACE command */
foreach var of varlist $List_ALL_MODULES_1 { 	 	
	replace `var'=1 if `var'>1 
	}

save "sum_flag_err_step$nstep.dta", replace

/* DO use " " for the name of the list when you have the COLLAPSE command */
collapse (sum) "$List_ALL_MODULES_1" , by (VER_SUSO_QUESTIONNAIRE) 

rename F_* *
rename *_1 *
generate FLAG_TYPE ="Total errors"
save "sum_flag_err_step$nstep.dta", replace




/*******************************  SUMMARY FLAG 1 ***************************/

cd "$DIR_DATA_530CV_YQ"
clear all
use "$fileout"
generate VER_SUSO_QUESTIONNAIRE="LFS_2024_T1"
save "sum_flag_1_step$nstep.dta", replace

/* DO NOT use " " for the name of the list when you have the REPLACE command */
foreach var of varlist $List_ALL_MODULES_1 { 	 	
    replace `var'=1 if `var'==1
    replace `var'=0 if `var'==3
	replace `var'=0 if `var'==9
    replace `var'=0 if `var'==2
}

save "sum_flag_1_step$nstep.dta", replace

/* DO use " " for the name of the list when you have the COLLAPSE command */
collapse (sum) "$List_ALL_MODULES_1" , by (VER_SUSO_QUESTIONNAIRE) 

rename F_* *
rename *_1 *
generate FLAG_TYPE ="1 - Out of Domain"
save "sum_flag_1_step$nstep.dta", replace



/*******************************  SUMMARY FLAG 2 ***************************/



cd "$DIR_DATA_530CV_YQ"
clear all
use "$fileout"
generate VER_SUSO_QUESTIONNAIRE="LFS_2024_T1"
save "sum_flag_2_step$nstep.dta", replace

/* DO NOT use " " for the name of the list when you have the REPLACE command */
foreach var of varlist $List_ALL_MODULES_1 { 	 	
    replace `var'=0 if `var'==1
    replace `var'=0 if `var'==3
	replace `var'=0 if `var'==9
    replace `var'=1 if `var'==2
}

save "sum_flag_2_step$nstep.dta", replace

/* DO use " " for the name of the list when you have the COLLAPSE command */
collapse (sum) "$List_ALL_MODULES_1" , by (VER_SUSO_QUESTIONNAIRE) 

rename F_* *
rename *_1 *
generate FLAG_TYPE ="2 - Missing"
save "sum_flag_2_step$nstep.dta", replace




/*******************************  SUMMARY FLAG 3 ***************************/



cd "$DIR_DATA_530CV_YQ"
clear all
use "$fileout"
generate VER_SUSO_QUESTIONNAIRE="LFS_2024_T1"
save "sum_flag_3_step$nstep.dta", replace

/* DO NOT use " " for the name of the list when you have the REPLACE command */
foreach var of varlist $List_ALL_MODULES_1 { 	 	
    replace `var'=0 if `var'==1
    replace `var'=0 if `var'==2
	replace `var'=0 if `var'==9
    replace `var'=1 if `var'==3
}

save "sum_flag_3_step$nstep.dta", replace

/* DO use " " for the name of the list when you have the COLLAPSE command */
collapse (sum) "$List_ALL_MODULES_1" , by (VER_SUSO_QUESTIONNAIRE) 

rename *_1 *
rename F_* *
generate FLAG_TYPE ="3 - Undue (to delete)"
save "sum_flag_3_step$nstep.dta", replace




/*******************************  SUMMARY FLAG 9 ***************************/


cd "$DIR_DATA_530CV_YQ"
clear all
use "$fileout"
generate VER_SUSO_QUESTIONNAIRE="LFS_2024_T1"
save "sum_flag_9_step$nstep.dta", replace

/* DO NOT use " " for the name of the list when you have the REPLACE command */
foreach var of varlist $List_ALL_MODULES_1 { 	 	
    replace `var'=0 if `var'==1
    replace `var'=0 if `var'==2
	replace `var'=1 if `var'==9
    replace `var'=0 if `var'==3
}

save "sum_flag_9_step$nstep.dta", replace

/* DO use " " for the name of the list when you have the COLLAPSE command */
collapse (sum) "$List_ALL_MODULES_1" , by (VER_SUSO_QUESTIONNAIRE) 

rename *_1 *
rename F_* *
generate FLAG_TYPE ="9 - Undue <15 (to delete)"
save "sum_flag_9_step$nstep.dta", replace



/*******************************  PUT ALL SUMMARIES TOGETHER ***************************/

cd "$DIR_DATA_530CV_YQ"

clear all
         use "sum_flag_0_step$nstep.dta"  
append using "sum_flag_1_step$nstep.dta"
append using "sum_flag_2_step$nstep.dta"
append using "sum_flag_3_step$nstep.dta"
append using "sum_flag_9_step$nstep.dta"
append using "sum_flag_err_step$nstep.dta"
save "sum_allflags_step$nstep.dta", replace

use "sum_allflags_step$nstep.dta", clear
xpose , clear varname
order _varname
rename _varname Variable_Name 
rename v1 Total_records 
rename v2 Flag_1_out_domain
rename v3 Flag_2_missing_to_impute
rename v4 Flag_3_undue_to_delete
rename v5 Flag_9_undue_0_14_to_delete
rename v6 Total_errors
generate float Percent_Total_errors = round(Total_errors / Total_records * 100,.1)
format %9.1g Percent_Total_errors

save "sum_allflags_step$nstep.dta", replace


* export to excel
use "sum_allflags_step$nstep.dta", clear

export excel using "$fileoutxls", firstrow(variables) replace

/* open the excel file produced */
winexec "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE" "$fileoutxls"
              

use "$fileout"