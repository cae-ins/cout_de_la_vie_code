/*********************************************************************************************************/
/*********************************************************************************************************/
/*********************************************************************************************************/                
/***                                                                                                   ***/
/***              CREATES TABLE F1 15+ years, and exports it in the Excel template                     ***/
/***                                                                                                   ***/
/***                               ILO LFS Model questionnaire JTS 2024 2023                                     ***/
/***                                                                                                   ***/
/***              Antonio R. Discenza - ILO Department of STATISTICS - discenza@ilo.org                ***/
/***                                                                                                   ***/
/*********************************************************************************************************/
/*********************************************************************************************************/
/*********************************************************************************************************/


* TO CHANGE: name of the temporary data set that will contain the microdata with the new s variable (it does not overwrite the original dataset)
global data_for_table "tmp_data_f1.dta"

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
global list_var_s s103num-s106

* the fist part of the table contains ratios and rates, hence we calculate dummy variables for the numerators and denominators.

generate s103num=1             if inlist(ILO_LFS_UNEMP,1,2) 
generate s103den=1             if inlist(ILO_LFS_EMP,1,2)   | inlist(ILO_LFS_UNEMP,1,2) 
generate s103=.   /* this ratio or rate will be calculated later */

generate s104num=1             if ILO_JOBALL_TRU ==1 | inlist(ILO_LFS_UNEMP,1,2) 
generate s104den=1             if inlist(ILO_LFS_EMP,1,2) | inlist(ILO_LFS_UNEMP,1,2) 
generate s104=.   /* this ratio or rate will be calculated later */

generate s105num=1             if inlist(ILO_LFS_UNEMP,1,2)  | inlist(ILO_POTENTIAL_LF,1,2) 
generate s105den=1             if inlist(ILO_LFS_EMP,1,2) | inlist(ILO_LFS_UNEMP,1,2)  | inlist(ILO_POTENTIAL_LF,1,2)  
generate s105=.   /* this ratio or rate will be calculated later */

generate s106num=1             if ILO_JOBALL_TRU ==1 | inlist(ILO_LFS_UNEMP,1,2)  | inlist(ILO_POTENTIAL_LF,1,2)  
generate s106den=1             if inlist(ILO_LFS_EMP,1,2) | inlist(ILO_LFS_UNEMP,1,2)  | inlist(ILO_POTENTIAL_LF,1,2)  
generate s106=.   /* this ratio or rate will be calculated later */

* save these new microdata in a temporary dataset (will be removed after the table has been created)
save "$data_for_table", replace

********************************************************************************************************
********************************************************************************************************
*
*                   DO NOT CHANGE ANYTHING FROM THIS POINT UP TO ROW 201
*
* creates the different datasets for the different subgroups

* summary total 15+
clear all
use "$data_for_table"
keep if DEM_AGE >=15
collapse (sum)  $list_var_s [iweight=$weight]
generate sex = "9 - Males and Females"
generate grouppop="15+ "
save "tmp_table_tot_15+.dta", replace

* summary by sex 15+
clear all
use "$data_for_table"
keep if DEM_AGE >=15
collapse (sum) $list_var_s [iweight=$weight], by (sex) 
gsort -sex
generate grouppop="15+ "
save "tmp_table_sex_15+.dta", replace


* summary by DEM_AGE groups
clear all
use "$data_for_table"
keep if DEM_AGE >=15
collapse (sum)  $list_var_s [iweight=$weight], by (agegroups) 
generate sex = "9 - Males and Females"
generate grouppop="15+ "
save "tmp_table_agegroups_15+.dta", replace


* summary by sex 15-24
clear all
use "$data_for_table"
keep if DEM_AGE >=15 & DEM_AGE<=24
collapse (sum) $list_var_s [iweight=$weight], by (sex) 
gsort -sex
generate grouppop="1524"
save "tmp_table_sex_1524.dta", replace

* put all together
clear all
         use "tmp_table_tot_15+.dta"  
append using "tmp_table_sex_15+.dta"
append using "tmp_table_agegroups_15+.dta"
append using "tmp_table_sex_1524.dta"



/* calculates the ratios and rates */
replace   s103=s103num/s103den
replace   s104=s104num/s104den
replace   s105=s105num/s105den
replace   s106=s106num/s106den



/* removes the dummy variables for numerators and denominators */
drop s103num s103den
drop s104num s104den
drop s105num s105den
drop s106num s106den

save "$data_for_table", replace


*                   DO NOT CHANGE ANYTHING ABOVE THIS POINT UP TO ROW 87
*
********************************************************************************************************
********************************************************************************************************




********************************************************************************************************
********************************************************************************************************
*  
*      copy the empty excel template from the directory "template" to the directory "Tables"


*  TO CHANGE: assign the name of the template and of the resulting table (should be in different folders: "$path_in" and "$path_out")

global xlsx_in =  "$DIR_PROG_610DT"  + "Tables_quarterly_press_release\templates\" + "Template_figure_F1_ILO.xlsx"

global xlsx_out = "$DIR_DATA_610DT_YQ" + "LFS_ILO_${YYYY_Q}_Figure_F1_weighted.xlsx"

* delete 

* delete the existing table and copy the empty template in the new folder
!erase "$xlsx_out"
!copy  "$xlsx_in" "$xlsx_out" /Y	

********************************************************************************************************
********************************************************************************************************
*  
*      copy the block of data from the Stata dataset to the excel template

putexcel clear 

*  TO CHANGE: name of the file containg the excel template (still empty at this point) and of the excel sheet with the template
putexcel set "$xlsx_out", sheet("Data F1") modify
	 
clear all
use "$data_for_table"
set matsize 10000
matrix drop _all 
mkmat s103-s106 , matrix(A)
*matrix At=(A') 
*  TO CHANGE: Cell of the excel sheet from which the data start (F5 in this case) 
putexcel C4=matrix(A) 

putexcel A1="ILO - LFS $YYYY_Q" 

* delete all the temporary dataset 

erase "tmp_table_tot_15+.dta"  
erase "tmp_table_sex_15+.dta"
erase "tmp_table_agegroups_15+.dta"
erase "tmp_table_sex_1524.dta"
erase "$data_for_table"
