/*********************************************************************************************************/
/*********************************************************************************************************/
/*********************************************************************************************************/                
/***                                                                                                   ***/
/***              CREATES TABLE T2 15+ years, and exports it in the Excel template                     ***/
/***                                                                                                   ***/
/***                       LFS questionnaire ANTIGUA AND BARBUDA 2023                                  ***/
/***                                                                                                   ***/
/***              Antonio R. Discenza - ILO Department of STATISTICS - discenza@ilo.org                ***/
/***                                                                                                   ***/
/*********************************************************************************************************/
/*********************************************************************************************************/
/*********************************************************************************************************/


* TO CHANGE: name of the temporary data set that will contain the microdata with the new s variable (it does not overwrite the original dataset)

global data_for_table "tmp_data_t2.dta"

use "$DIR_DATA_580FD_YQ\LFS_ILO_${YYYY_Q}_FINAL.dta", clear

generate WEIGHT_FINAL_000 = WEIGHT_FINAL / 1000

global weight "WEIGHT_FINAL_000"


generate agegroups = "        " 
replace  agegroups = "0.   <14" if DEM_AGE <=14
replace  agegroups = "1. 15-24" if DEM_AGE >=15 & DEM_AGE <=24
replace  agegroups = "2. 25+  " if DEM_AGE >=25		

generate sex = ""  
replace  sex = "1 - Males  "  if DEM_SEX==1
replace  sex = "2 - Females"  if DEM_SEX==2


* TO CHANGE: list of s variables created to fill in the template (rows of the resulting table)
global list_var_s s101-s131


/* EMPLOYERS IN CORPORATIONS OR OWNER-OPERATORS OF COORPORATIONS  ( ICSE-18R=4 )*/
generate s101=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==4

/* EMPLOYERS  AND OWN-ACCOUNT WORKERSIN HOUSEHOLD MARKET ENTERPRISES ( ICSE-18R=1 ) */
generate s102=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==1

/* EMPLOYERS  AND OWN-ACCOUNT WORKERSIN HOUSEHOLD MARKET ENTERPRISES ( ICSE-18R=1 ) in the FORMAL SECTOR */
generate s103=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==1 & ILO_JOB1_IFE_PROD==2

/* EMPLOYERS  AND OWN-ACCOUNT WORKERSIN HOUSEHOLD MARKET ENTERPRISES ( ICSE-18R=1 )  in the INFORMAL SECTOR */
generate s104=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==1 & ILO_JOB1_IFE_PROD==1

/* DEPENDENT CONTRACTORS ( ICSE-18R=2 )  */
generate s105=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==2 

/* DEPENDENT CONTRACTORS ( ICSE-18R=2 )  in the FORMAL SECTOR with FORMAL JOB*/
generate s106=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==2 & ILO_JOB1_IFE_PROD==2 & ILO_JOB1_IFE_NATURE==2

/* DEPENDENT CONTRACTORS ( ICSE-18R=2 )  in the FORMAL SECTOR with INFORMAL JOB */
generate s107=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==2 & ILO_JOB1_IFE_PROD==2 & ILO_JOB1_IFE_NATURE==1

/* DEPENDENT CONTRACTORS ( ICSE-18R=2 )  in the INFORMAL SECTOR  with INFORMAL JOB*/
generate s108=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==2 & ILO_JOB1_IFE_PROD==1 & ILO_JOB1_IFE_NATURE==1

/* DEPENDENT CONTRACTORS ( ICSE-18R=2 )  NOT CLASSIFIABLE in the INFORMAL SECTOR  or  INFORMAL JOB*/
generate s109=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==2 & !inlist(ILO_JOB1_IFE_PROD,1,2)

/* EMPLOYEES ( ICSE-18R=3 )  B*/
generate s110=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==5

/* EMPLOYEES ( ICSE-18R=3 )  in the FORMAL SECTOR with FORMAL JOB*/
generate s111=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==5 & ILO_JOB1_IFE_PROD==2 & ILO_JOB1_IFE_NATURE==2

/* EMPLOYEES ( ICSE-18R=3 )  in the FORMAL SECTOR with INFORMAL JOB*/
generate s112=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==5 & ILO_JOB1_IFE_PROD==2 & ILO_JOB1_IFE_NATURE==1

/* EMPLOYEES ( ICSE-18R=3 )  in the INFORMAL SECTOR with INFORMAL JOB*/
generate s113=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==5 & ILO_JOB1_IFE_PROD==1 & ILO_JOB1_IFE_NATURE==1

/* EMPLOYEES ( ICSE-18R=3 )  in the HOUSEHOLD AND COMMUNITY SECTOR with FORMAL JOB*/
generate s114=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==5 & ILO_JOB1_IFE_PROD==3 & ILO_JOB1_IFE_NATURE==2

/* EMPLOYEES ( ICSE-18R=3 )  in the HOUSEHOLD AND COMMUNITY SECTOR with INFORMAL JOB*/
generate s115=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==5 & ILO_JOB1_IFE_PROD==3 & ILO_JOB1_IFE_NATURE==1

/* CONTRIBUTING FAMILY WORKERS ( ICSE-18R=5 )  */
generate s116=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==3

/* CONTRIBUTING FAMILY WORKERS ( ICSE-18R=5 )  in the FORMAL SECTOR with FORMAL JOB*/
generate s117=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==3 & ILO_JOB1_IFE_PROD==2 & ILO_JOB1_IFE_NATURE==2

/* CONTRIBUTING FAMILY WORKERS ( ICSE-18R=5 )  in the FORMAL SECTOR with INFORMAL JOB*/
generate s118=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==3 & ILO_JOB1_IFE_PROD==2 & ILO_JOB1_IFE_NATURE==1

/* CONTRIBUTING FAMILY WORKERS ( ICSE-18R=5 )  in the INFORMAL SECTOR with INFORMAL JOB*/
generate s119=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_STE_MC_ICSE18R==3 & ILO_JOB1_IFE_PROD==1 & ILO_JOB1_IFE_NATURE==1

/* TOTAL EMPLOYED IN THE FORMAL SECTOR */
generate s120=1             if inlist(ILO_LFS_EMP,1,2)  & ILO_JOB1_IFE_PROD==2

/* TOTAL EMPLOYED IN THE FORMAL SECTOR with FORMAL JOB*/
generate s121=1             if inlist(ILO_LFS_EMP,1,2)  & ILO_JOB1_IFE_PROD==2 & ILO_JOB1_IFE_NATURE==2

/* TOTAL EMPLOYED IN THE FORMAL SECTOR with INFORMAL JOB*/
generate s122=1             if inlist(ILO_LFS_EMP,1,2)  & ILO_JOB1_IFE_PROD==2 & ILO_JOB1_IFE_NATURE==1

/* TOTAL EMPLOYED IN THE INFORMAL SECTOR (hence  with INFORMAL JOB */
generate s123=1             if inlist(ILO_LFS_EMP,1,2)  & ILO_JOB1_IFE_PROD==1

/* TOTAL EMPLOYED IN THE HOUSEHOLD AND COMMUNITY SECTOR */
generate s124=1             if inlist(ILO_LFS_EMP,1,2)  & ILO_JOB1_IFE_PROD==3

/* TOTAL EMPLOYED IN THE HOUSEHOLD AND COMMUNITY SECTOR with FORMAL JOB*/
generate s125=1             if inlist(ILO_LFS_EMP,1,2)  & ILO_JOB1_IFE_PROD==3 & ILO_JOB1_IFE_NATURE==2

/* TOTAL EMPLOYED IN THE HOUSEHOLD AND COMMUNITY SECTOR with INFORMAL JOB*/
generate s126=1             if inlist(ILO_LFS_EMP,1,2)  & ILO_JOB1_IFE_PROD==3 & ILO_JOB1_IFE_NATURE==1

/* TOTAL EMPLOYED IN SECTOR NOT CLASSIFIABLE */
generate s127=1             if inlist(ILO_LFS_EMP,1,2)  & !inlist(ILO_JOB1_IFE_PROD,1,2,3)

/* TOTAL EMPLOYED WITH FORMAL JOBS */
generate s128=1             if inlist(ILO_LFS_EMP,1,2)  & ILO_JOB1_IFE_NATURE==2

/* TOTAL EMPLOYED WITH FORMAL JOBS */
generate s129=1             if inlist(ILO_LFS_EMP,1,2)  & ILO_JOB1_IFE_NATURE==1

/* TOTAL EMPLOYED WITH JOBS NOT CLASSIFIABLE*/
generate s130=1             if inlist(ILO_LFS_EMP,1,2)  & !inlist(ILO_JOB1_IFE_NATURE,1,2)

/* TOTAL EMPLOYED  */
generate s131=1             if inlist(ILO_LFS_EMP,1,2) 

* save these new microdata in a temporary dataset (will be removed after the table has been created)
save "$data_for_table", replace



********************************************************************************************************
********************************************************************************************************
*
*                   DO NOT CHANGE ANYTHING FROM THIS POINT 
*
* creates the different datasets for the different subgroups

* summary total 15+
clear all
use "$data_for_table"
keep if DEM_AGE >=15
collapse (sum)  $list_var_s  [iweight=$weight]
generate sex = "9 - Males and Females"
generate agegroups="0 - 15+ "
save "tmp_table_tot_15+.dta", replace

* summary by sex 15+
clear all
use "$data_for_table"
keep if DEM_AGE >=15
collapse (sum) $list_var_s [iweight=$weight], by (sex) 
gsort -sex
generate agegroups="0 - 15+ "
save "tmp_table_sex_15+.dta", replace


* summary by agegroups and sex
clear all
use "$data_for_table"
keep if DEM_AGE >=15
collapse (sum)  $list_var_s [iweight=$weight], by (agegroups sex) 
save "tmp_table_agesex_15+.dta", replace
collapse (sum)  $list_var_s , by (agegroups) 
generate sex = "9 - Males and Females"
save "tmp_table_agetot_15+.dta", replace

* put all together
clear all
         use "tmp_table_tot_15+.dta"  
append using "tmp_table_sex_15+.dta"
append using "tmp_table_agesex_15+.dta"
append using "tmp_table_agetot_15+.dta"

gsort agegroups -sex

save "$data_for_table", replace


*                   DO NOT CHANGE ANYTHING ABOVE THIS POINT 
*
********************************************************************************************************
********************************************************************************************************




********************************************************************************************************
********************************************************************************************************
*  
*      copy the empty excel template from the directory "template" to the directory "Tables"


*  TO CHANGE: assign the name of the template and of the resulting table (should be in different folders: "$path_in" and "$path_out")

global xlsx_in =  "$DIR_PROG_610DT"  + "Tables_quarterly_press_release\templates\" + "Template_table_T2_ILO.xlsx"

global xlsx_out = "$DIR_DATA_610DT_YQ" + "LFS_ILO_${YYYY_Q}_table_T2_weighted.xlsx"

* delete the existing table and copy the empty template in the new folder
!erase "$xlsx_out"
!copy  "$xlsx_in" "$xlsx_out" /Y	

********************************************************************************************************
********************************************************************************************************
*  
*      copy the block of data from the Stata dataset to the excel template

putexcel clear 

*  TO CHANGE: name of the file containg the excel template (still empty at this point) and of the excel sheet with the template
putexcel set "$xlsx_out", sheet("Data T2") modify
	 
clear all
use "$data_for_table"
set matsize 10000
matrix drop _all 
mkmat $list_var_s , matrix(A)
matrix At=(A') 
*  TO CHANGE: Cell of the excel sheet from which the data start (F5 in this case) 
putexcel F6=matrix(A') 

putexcel A4="ILO - LFS $YYYY_Q" 

* delete all the temporary dataset 

erase "tmp_table_tot_15+.dta"  
erase "tmp_table_sex_15+.dta"
erase "tmp_table_agesex_15+.dta"
erase "tmp_table_agetot_15+.dta"
erase "$data_for_table"
