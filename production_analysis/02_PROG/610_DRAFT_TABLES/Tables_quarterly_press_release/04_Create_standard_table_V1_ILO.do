/*********************************************************************************************************/
/*********************************************************************************************************/
/*********************************************************************************************************/                
/***                                                                                                   ***/
/***              CREATES TABLE V1 variations 15+ years, and exports it in the Excel template                     ***/
/***                                                                                                   ***/
/***                      ILO LFS Model questionnaire JTS 2024                                   ***/
/***                                                                                                   ***/
/***              Antonio R. Discenza - ILO Department of STATISTICS - discenza@ilo.org                ***/
/***                                                                                                   ***/
/*********************************************************************************************************/
/*********************************************************************************************************/
/*********************************************************************************************************/

use "$DIR_DATA_580FD_YQ\LFS_ILO_${YYYY_Q}_FINAL.dta" , clear

generate WEIGHT_FINAL_000 = WEIGHT_FINAL / 1000

global weight "WEIGHT_FINAL_000"

* TO CHANGE: name of the temporary data set that will contain the microdata with the new s variable (it does not overwrite the original dataset)
global data_for_table "tmp_data_t1.dta"

* TO CHANGE: list of s variables created to fill in the template (rows of the resulting table)
global list_var_s s101num-s138

* the fist part of the table contains ratios and rates, hence we calculate dummy variables for the numerators and denominators.
generate s101num=1             if inlist(ILO_LFS_EMP,1,2) | inlist(ILO_LFS_UNEMP,1,2) 
generate s101den=1             if ILO_WAP==1
generate s101=.   /* this ratio or rate will be calculated later */

generate s102num=1             if inlist(ILO_LFS_EMP,1,2)
generate s102den=1             if ILO_WAP==1
generate s102=.   /* this ratio or rate will be calculated later */

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

generate s107num=1             if inlist(ILO_POTENTIAL_LF,1,2) 
generate s107den=1             if ILO_WAP==1 & !inlist(ILO_LFS_EMP,1,2)  & !inlist(ILO_LFS_UNEMP,1,2)
generate s107=.   /* this ratio or rate will be calculated later */

generate s108num=1             if OWN_USE_PROD_GOODS==1
generate s108den=1             if ILO_WAP==1
generate s108=.   /* this ratio or rate will be calculated later */

generate s109num=1             if OWN_USE_PROD_FOODSTUFF==1
generate s109den=1             if ILO_WAP==1
generate s109=.   /* this ratio or rate will be calculated later */

generate s110num=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_IFE_NATURE==1
generate s110den=1             if inlist(ILO_LFS_EMP,1,2)
generate s110=.   /* this ratio or rate will be calculated later */

generate s111num=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_IFE_PROD==1
generate s111den=1             if inlist(ILO_LFS_EMP,1,2)
generate s111=.   /* this ratio or rate will be calculated later */

generate s112num=1             if inlist(ILO_LFS_EMP,1,2) & MJJ_MULT==2
generate s112den=1             if inlist(ILO_LFS_EMP,1,2)
generate s112=.   /* this ratio or rate will be calculated later */

generate s113num=1             if inlist(ILO_LFS_EMP,1,2) & OWN_USE_PROD_GOODS==1
generate s113den=1             if inlist(ILO_LFS_EMP,1,2)
generate s113=.   /* this ratio or rate will be calculated later */

generate s114num=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOBALL_TRU ==1
generate s114den=1             if inlist(ILO_LFS_EMP,1,2)
generate s114=.   /* this ratio or rate will be calculated later */

generate s115num=1             if OWN_USE_PROD_GOODS==1 & inlist(ILO_LFS_EMP,1,2)
generate s115den=1             if OWN_USE_PROD_GOODS==1
generate s115=.   /* this ratio or rate will be calculated later */

generate s116num=1             if OWN_USE_PROD_GOODS==1 & inlist(ILO_LFS_UNEMP,1,2)
generate s116den=1             if OWN_USE_PROD_GOODS==1
generate s116=.   /* this ratio or rate will be calculated later */

generate s117num=1             if DEM_AGE>=15 & DEM_AGE <= 24 & NEET_1==1
generate s117den=1             if DEM_AGE>=15 & DEM_AGE <= 24
generate s117=.   /* this ratio or rate will be calculated later */

* the second part ot the table contains counts, hence we calculate dummy variables for them 
generate s118=1 if ILO_WAP==1
generate s119=1 if inlist(ILO_LFS_EMP,1,2)
generate s120=1 if inlist(ILO_LFS_EMP,1,2) & MJJ_MULT==2
generate s121=1 if inlist(ILO_LFS_EMP,1,2) & ILO_JOBALL_TRU ==1
generate s122=1 if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_IFE_NATURE==1
generate s123=1 if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_IFE_PROD==1
generate s124=1 if inlist(ILO_LFS_UNEMP,1,2)  
generate s125=1 if ILO_WAP==1 & !inlist(ILO_LFS_EMP,1,2) & !inlist(ILO_LFS_UNEMP,1,2)
generate s126=1 if inlist(ILO_POTENTIAL_LF,1,2)  
generate s127=1 if inlist(ILO_POTENTIAL_LF,1,2) &  ILO_UNAVAIL_JOBSEEK==1	
generate s128=1 if inlist(ILO_POTENTIAL_LF,1,2) &  ILO_AVAIL_POT_JOBSEEK==1
generate s129=1 if inlist(ILO_POTENTIAL_LF,1,2) &  ILO_AVAIL_POT_JOBSEEK==1 & ILO_DISCOURAGED==1
generate s130=1 if OWN_USE_PROD_GOODS==1
generate s131=1 if OWN_USE_PROD_FOODSTUFF==1
generate s132=1 if OWN_USE_PROD_GOODS==1 & inlist(ILO_LFS_EMP,1,2)
generate s133=1 if OWN_USE_PROD_GOODS==1 & inlist(ILO_LFS_UNEMP,1,2)
generate s134=1 if  inlist(ILO_LFS_EMP,1,2) | OWN_USE_PROD_GOODS==1
generate s135=1 if  inlist(ILO_LFS_EMP,1,2) & OWN_USE_PROD_GOODS!=1
generate s136=1 if  inlist(ILO_LFS_EMP,1,2) & OWN_USE_PROD_GOODS==1
generate s137=1 if !inlist(ILO_LFS_EMP,1,2) & OWN_USE_PROD_GOODS==1
generate s138=1 if  NEET_1==1

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
generate grouppop="15+ "
save "tmp_table_tot_15+.dta", replace

* summary by sex 15+
clear all
use "$data_for_table"
keep if DEM_AGE >=15
collapse (sum) $list_var_s [iweight=$weight], by (DEM_SEX) 
generate grouppop="15+ "
save "tmp_table_sex_15+.dta", replace

* put all together
clear all
         use "tmp_table_tot_15+.dta"  
append using "tmp_table_sex_15+.dta"

/* calculates the ratios and rates */
replace   s101=s101num/s101den*100
replace   s102=s102num/s102den*100
replace   s103=s103num/s103den*100
replace   s104=s104num/s104den*100
replace   s105=s105num/s105den*100
replace   s106=s106num/s106den*100
replace   s107=s107num/s107den*100
replace   s108=s108num/s108den*100
replace   s109=s109num/s109den*100
replace   s110=s110num/s110den*100
replace   s111=s111num/s111den*100
replace   s112=s112num/s112den*100
replace   s113=s113num/s113den*100
replace   s114=s114num/s114den*100
replace   s115=s115num/s115den*100
replace   s116=s116num/s116den*100
replace   s117=s117num/s117den*100 

/* removes the dummy variables for numerators and denominators */
drop s101num s101den
drop s102num s102den
drop s103num s103den
drop s104num s104den
drop s105num s105den
drop s106num s106den
drop s107num s107den
drop s108num s108den
drop s109num s109den
drop s110num s110den
drop s111num s111den
drop s112num s112den
drop s113num s113den
drop s114num s114den
drop s115num s115den
drop s116num s116den
drop s117num s117den

save         "ILO_table_T1_var_Qref.dta", replace
erase "$data_for_table"
erase "tmp_table_tot_15+.dta"  
erase "tmp_table_sex_15+.dta" 

/********************************************* Qminus4 *****************************************/

use "$DIR_DATA_580FD\$YEARminus4\quarter${QUARTERminus4}\LFS_ILO_${YYYY_Qm4}_FINAL.dta" , clear

generate WEIGHT_FINAL_000 = WEIGHT_FINAL / 1000

global weight "WEIGHT_FINAL_000"

* TO CHANGE: name of the temporary data set that will contain the microdata with the new s variable (it does not overwrite the original dataset)
global data_for_table "tmp_data_t1.dta"

* TO CHANGE: list of s variables created to fill in the template (rows of the resulting table)
global list_var_s s101num-s138

* the fist part of the table contains ratios and rates, hence we calculate dummy variables for the numerators and denominators.
generate s101num=1             if inlist(ILO_LFS_EMP,1,2) | inlist(ILO_LFS_UNEMP,1,2) 
generate s101den=1             if ILO_WAP==1
generate s101=.   /* this ratio or rate will be calculated later */

generate s102num=1             if inlist(ILO_LFS_EMP,1,2)
generate s102den=1             if ILO_WAP==1
generate s102=.   /* this ratio or rate will be calculated later */

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

generate s107num=1             if inlist(ILO_POTENTIAL_LF,1,2) 
generate s107den=1             if ILO_WAP==1 & !inlist(ILO_LFS_EMP,1,2)  & !inlist(ILO_LFS_UNEMP,1,2)
generate s107=.   /* this ratio or rate will be calculated later */

generate s108num=1             if OWN_USE_PROD_GOODS==1
generate s108den=1             if ILO_WAP==1
generate s108=.   /* this ratio or rate will be calculated later */

generate s109num=1             if OWN_USE_PROD_FOODSTUFF==1
generate s109den=1             if ILO_WAP==1
generate s109=.   /* this ratio or rate will be calculated later */

generate s110num=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_IFE_NATURE==1
generate s110den=1             if inlist(ILO_LFS_EMP,1,2)
generate s110=.   /* this ratio or rate will be calculated later */

generate s111num=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_IFE_PROD==1
generate s111den=1             if inlist(ILO_LFS_EMP,1,2)
generate s111=.   /* this ratio or rate will be calculated later */

generate s112num=1             if inlist(ILO_LFS_EMP,1,2) & MJJ_MULT==2
generate s112den=1             if inlist(ILO_LFS_EMP,1,2)
generate s112=.   /* this ratio or rate will be calculated later */

generate s113num=1             if inlist(ILO_LFS_EMP,1,2) & OWN_USE_PROD_GOODS==1
generate s113den=1             if inlist(ILO_LFS_EMP,1,2)
generate s113=.   /* this ratio or rate will be calculated later */

generate s114num=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOBALL_TRU ==1
generate s114den=1             if inlist(ILO_LFS_EMP,1,2)
generate s114=.   /* this ratio or rate will be calculated later */

generate s115num=1             if OWN_USE_PROD_GOODS==1 & inlist(ILO_LFS_EMP,1,2)
generate s115den=1             if OWN_USE_PROD_GOODS==1
generate s115=.   /* this ratio or rate will be calculated later */

generate s116num=1             if OWN_USE_PROD_GOODS==1 & inlist(ILO_LFS_UNEMP,1,2)
generate s116den=1             if OWN_USE_PROD_GOODS==1
generate s116=.   /* this ratio or rate will be calculated later */

generate s117num=1             if DEM_AGE>=15 & DEM_AGE <= 24 & NEET_1==1
generate s117den=1             if DEM_AGE>=15 & DEM_AGE <= 24
generate s117=.   /* this ratio or rate will be calculated later */

* the second part ot the table contains counts, hence we calculate dummy variables for them 
generate s118=1 if ILO_WAP==1
generate s119=1 if inlist(ILO_LFS_EMP,1,2)
generate s120=1 if inlist(ILO_LFS_EMP,1,2) & MJJ_MULT==2
generate s121=1 if inlist(ILO_LFS_EMP,1,2) & ILO_JOBALL_TRU ==1
generate s122=1 if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_IFE_NATURE==1
generate s123=1 if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_IFE_PROD==1
generate s124=1 if inlist(ILO_LFS_UNEMP,1,2)  
generate s125=1 if ILO_WAP==1 & !inlist(ILO_LFS_EMP,1,2) & !inlist(ILO_LFS_UNEMP,1,2)
generate s126=1 if inlist(ILO_POTENTIAL_LF,1,2)  
generate s127=1 if inlist(ILO_POTENTIAL_LF,1,2) &  ILO_UNAVAIL_JOBSEEK==1	
generate s128=1 if inlist(ILO_POTENTIAL_LF,1,2) &  ILO_AVAIL_POT_JOBSEEK==1
generate s129=1 if inlist(ILO_POTENTIAL_LF,1,2) &  ILO_AVAIL_POT_JOBSEEK==1 & ILO_DISCOURAGED==1
generate s130=1 if OWN_USE_PROD_GOODS==1
generate s131=1 if OWN_USE_PROD_FOODSTUFF==1
generate s132=1 if OWN_USE_PROD_GOODS==1 & inlist(ILO_LFS_EMP,1,2)
generate s133=1 if OWN_USE_PROD_GOODS==1 & inlist(ILO_LFS_UNEMP,1,2)
generate s134=1 if  inlist(ILO_LFS_EMP,1,2) | OWN_USE_PROD_GOODS==1
generate s135=1 if  inlist(ILO_LFS_EMP,1,2) & OWN_USE_PROD_GOODS!=1
generate s136=1 if  inlist(ILO_LFS_EMP,1,2) & OWN_USE_PROD_GOODS==1
generate s137=1 if !inlist(ILO_LFS_EMP,1,2) & OWN_USE_PROD_GOODS==1
generate s138=1 if  NEET_1==1

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
generate grouppop="15+ "
save "tmp_table_tot_15+.dta", replace

* summary by sex 15+
clear all
use "$data_for_table"
keep if DEM_AGE >=15
collapse (sum) $list_var_s [iweight=$weight], by (DEM_SEX) 
generate grouppop="15+ "
save "tmp_table_sex_15+.dta", replace

* put all together
clear all
         use "tmp_table_tot_15+.dta"  
append using "tmp_table_sex_15+.dta"

/* calculates the ratios and rates */
replace   s101=s101num/s101den*100
replace   s102=s102num/s102den*100
replace   s103=s103num/s103den*100
replace   s104=s104num/s104den*100
replace   s105=s105num/s105den*100
replace   s106=s106num/s106den*100
replace   s107=s107num/s107den*100
replace   s108=s108num/s108den*100
replace   s109=s109num/s109den*100
replace   s110=s110num/s110den*100
replace   s111=s111num/s111den*100
replace   s112=s112num/s112den*100
replace   s113=s113num/s113den*100
replace   s114=s114num/s114den*100
replace   s115=s115num/s115den*100
replace   s116=s116num/s116den*100
replace   s117=s117num/s117den*100 



/* removes the dummy variables for numerators and denominators */
drop s101num s101den
drop s102num s102den
drop s103num s103den
drop s104num s104den
drop s105num s105den
drop s106num s106den
drop s107num s107den
drop s108num s108den
drop s109num s109den
drop s110num s110den
drop s111num s111den
drop s112num s112den
drop s113num s113den
drop s114num s114den
drop s115num s115den
drop s116num s116den
drop s117num s117den

save         "ILO_table_T1_var_Qrefminus4.dta", replace
erase "$data_for_table"
erase "tmp_table_tot_15+.dta"  
erase "tmp_table_sex_15+.dta" 

/*************************************** Qminus1 ****************************************/

use "$DIR_DATA_580FD\$YEARminus1\quarter${QUARTERminus1}\LFS_ILO_${YYYY_Qm1}_FINAL.dta" , clear

generate WEIGHT_FINAL_000 = WEIGHT_FINAL / 1000

global weight "WEIGHT_FINAL_000"

* TO CHANGE: name of the temporary data set that will contain the microdata with the new s variable (it does not overwrite the original dataset)
global data_for_table "tmp_data_t1.dta"

* TO CHANGE: list of s variables created to fill in the template (rows of the resulting table)
global list_var_s s101num-s138

* the fist part of the table contains ratios and rates, hence we calculate dummy variables for the numerators and denominators.
generate s101num=1             if inlist(ILO_LFS_EMP,1,2) | inlist(ILO_LFS_UNEMP,1,2) 
generate s101den=1             if ILO_WAP==1
generate s101=.   /* this ratio or rate will be calculated later */

generate s102num=1             if inlist(ILO_LFS_EMP,1,2)
generate s102den=1             if ILO_WAP==1
generate s102=.   /* this ratio or rate will be calculated later */

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

generate s107num=1             if inlist(ILO_POTENTIAL_LF,1,2) 
generate s107den=1             if ILO_WAP==1 & !inlist(ILO_LFS_EMP,1,2)  & !inlist(ILO_LFS_UNEMP,1,2)
generate s107=.   /* this ratio or rate will be calculated later */

generate s108num=1             if OWN_USE_PROD_GOODS==1
generate s108den=1             if ILO_WAP==1
generate s108=.   /* this ratio or rate will be calculated later */

generate s109num=1             if OWN_USE_PROD_FOODSTUFF==1
generate s109den=1             if ILO_WAP==1
generate s109=.   /* this ratio or rate will be calculated later */

generate s110num=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_IFE_NATURE==1
generate s110den=1             if inlist(ILO_LFS_EMP,1,2)
generate s110=.   /* this ratio or rate will be calculated later */

generate s111num=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_IFE_PROD==1
generate s111den=1             if inlist(ILO_LFS_EMP,1,2)
generate s111=.   /* this ratio or rate will be calculated later */

generate s112num=1             if inlist(ILO_LFS_EMP,1,2) & MJJ_MULT==2
generate s112den=1             if inlist(ILO_LFS_EMP,1,2)
generate s112=.   /* this ratio or rate will be calculated later */

generate s113num=1             if inlist(ILO_LFS_EMP,1,2) & OWN_USE_PROD_GOODS==1
generate s113den=1             if inlist(ILO_LFS_EMP,1,2)
generate s113=.   /* this ratio or rate will be calculated later */

generate s114num=1             if inlist(ILO_LFS_EMP,1,2) & ILO_JOBALL_TRU ==1
generate s114den=1             if inlist(ILO_LFS_EMP,1,2)
generate s114=.   /* this ratio or rate will be calculated later */

generate s115num=1             if OWN_USE_PROD_GOODS==1 & inlist(ILO_LFS_EMP,1,2)
generate s115den=1             if OWN_USE_PROD_GOODS==1
generate s115=.   /* this ratio or rate will be calculated later */

generate s116num=1             if OWN_USE_PROD_GOODS==1 & inlist(ILO_LFS_UNEMP,1,2)
generate s116den=1             if OWN_USE_PROD_GOODS==1
generate s116=.   /* this ratio or rate will be calculated later */

generate s117num=1             if DEM_AGE>=15 & DEM_AGE <= 24 & NEET_1==1
generate s117den=1             if DEM_AGE>=15 & DEM_AGE <= 24
generate s117=.   /* this ratio or rate will be calculated later */

* the second part ot the table contains counts, hence we calculate dummy variables for them 
generate s118=1 if ILO_WAP==1
generate s119=1 if inlist(ILO_LFS_EMP,1,2)
generate s120=1 if inlist(ILO_LFS_EMP,1,2) & MJJ_MULT==2
generate s121=1 if inlist(ILO_LFS_EMP,1,2) & ILO_JOBALL_TRU ==1
generate s122=1 if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_IFE_NATURE==1
generate s123=1 if inlist(ILO_LFS_EMP,1,2) & ILO_JOB1_IFE_PROD==1
generate s124=1 if inlist(ILO_LFS_UNEMP,1,2)  
generate s125=1 if ILO_WAP==1 & !inlist(ILO_LFS_EMP,1,2) & !inlist(ILO_LFS_UNEMP,1,2)
generate s126=1 if inlist(ILO_POTENTIAL_LF,1,2)  
generate s127=1 if inlist(ILO_POTENTIAL_LF,1,2) &  ILO_UNAVAIL_JOBSEEK==1	
generate s128=1 if inlist(ILO_POTENTIAL_LF,1,2) &  ILO_AVAIL_POT_JOBSEEK==1
generate s129=1 if inlist(ILO_POTENTIAL_LF,1,2) &  ILO_AVAIL_POT_JOBSEEK==1 & ILO_DISCOURAGED==1
generate s130=1 if OWN_USE_PROD_GOODS==1
generate s131=1 if OWN_USE_PROD_FOODSTUFF==1
generate s132=1 if OWN_USE_PROD_GOODS==1 & inlist(ILO_LFS_EMP,1,2)
generate s133=1 if OWN_USE_PROD_GOODS==1 & inlist(ILO_LFS_UNEMP,1,2)
generate s134=1 if  inlist(ILO_LFS_EMP,1,2) | OWN_USE_PROD_GOODS==1
generate s135=1 if  inlist(ILO_LFS_EMP,1,2) & OWN_USE_PROD_GOODS!=1
generate s136=1 if  inlist(ILO_LFS_EMP,1,2) & OWN_USE_PROD_GOODS==1
generate s137=1 if !inlist(ILO_LFS_EMP,1,2) & OWN_USE_PROD_GOODS==1
generate s138=1 if  NEET_1==1

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
generate grouppop="15+ "
save "tmp_table_tot_15+.dta", replace

* summary by sex 15+
clear all
use "$data_for_table"
keep if DEM_AGE >=15
collapse (sum) $list_var_s [iweight=$weight], by (DEM_SEX) 
generate grouppop="15+ "
save "tmp_table_sex_15+.dta", replace

* put all together
clear all
         use "tmp_table_tot_15+.dta"  
append using "tmp_table_sex_15+.dta"


/* calculates the ratios and rates */
replace   s101=s101num/s101den*100
replace   s102=s102num/s102den*100
replace   s103=s103num/s103den*100
replace   s104=s104num/s104den*100
replace   s105=s105num/s105den*100
replace   s106=s106num/s106den*100
replace   s107=s107num/s107den*100
replace   s108=s108num/s108den*100
replace   s109=s109num/s109den*100
replace   s110=s110num/s110den*100
replace   s111=s111num/s111den*100
replace   s112=s112num/s112den*100
replace   s113=s113num/s113den*100
replace   s114=s114num/s114den*100
replace   s115=s115num/s115den*100
replace   s116=s116num/s116den*100
replace   s117=s117num/s117den*100 



/* removes the dummy variables for numerators and denominators */
drop s101num s101den
drop s102num s102den
drop s103num s103den
drop s104num s104den
drop s105num s105den
drop s106num s106den
drop s107num s107den
drop s108num s108den
drop s109num s109den
drop s110num s110den
drop s111num s111den
drop s112num s112den
drop s113num s113den
drop s114num s114den
drop s115num s115den
drop s116num s116den
drop s117num s117den

save         "ILO_table_T1_var_Qrefminus1.dta", replace
erase "$data_for_table"
erase "tmp_table_tot_15+.dta"  
erase "tmp_table_sex_15+.dta" 

*                   DO NOT CHANGE ANYTHING ABOVE THIS POINT UP TO ROW 87
*
********************************************************************************************************
********************************************************************************************************




********************************************************************************************************
********************************************************************************************************
*  
*      copy the empty excel template from the directory "template" to the directory "Tables"


*  TO CHANGE: assign the name of the template and of the resulting table (should be in different folders: "$path_in" and "$path_out")
global xlsx_in =  "$DIR_PROG_610DT"  + "Tables_quarterly_press_release\templates\" + "Template_table_V1_ILO.xlsx"

global xlsx_out = "$DIR_DATA_610DT_YQ" + "LFS_ILO_${YYYY_Q}_table_V1_var_weighted.xlsx"

* delete the existing table and copy the empty template in the new folder
!erase "$xlsx_out"
!copy  "$xlsx_in" "$xlsx_out" /Y	

********************************************************************************************************
********************************************************************************************************
*  
*      copy the block of data from the Stata dataset to the excel template

putexcel clear 

*  TO CHANGE: name of the file containg the excel template (still empty at this point) and of the excel sheet with the template
putexcel set "$xlsx_out", sheet("S1 var - Headline rates ratios") modify
	
putexcel A4="ILO - LFS $YYYY_Q" 

clear all
use "ILO_table_T1_var_Qrefminus4.dta"
set matsize 10000
matrix drop _all 
mkmat s101-s117 , matrix(A)
matrix At=(A') 
putexcel G6=matrix(At) 
putexcel G2="${YYYY_Qm4}" 
	 
clear all
use "ILO_table_T1_var_Qrefminus1.dta"
set matsize 10000
matrix drop _all 
mkmat s101-s117 , matrix(A)
matrix At=(A') 
putexcel K6=matrix(At) 
putexcel K2="${YYYY_Qm1}" 
	 
clear all
use "ILO_table_T1_var_Qref.dta"
set matsize 10000
matrix drop _all 
mkmat s101-s117 , matrix(A)
matrix At=(A') 
putexcel O6=matrix(At) 
putexcel O2="${YYYY_Q}"

putexcel S2="${YYYY_Q} - ${YYYY_Qm4}"
putexcel W2="${YYYY_Q} - ${YYYY_Qm1}"


putexcel clear 

*  TO CHANGE: name of the file containg the excel template (still empty at this point) and of the excel sheet with the template
putexcel set "$xlsx_out", sheet("S1 var - Headline levels") modif
	
putexcel A4="ILO - LFS $YYYY_Q" 

clear all
use "ILO_table_T1_var_Qrefminus4.dta"
set matsize 10000
matrix drop _all 
mkmat s118-s138 , matrix(A)
matrix At=(A') 
putexcel G6=matrix(At) 
putexcel G2="${YYYY_Qm4}" 


clear all
use "ILO_table_T1_var_Qrefminus1.dta"
set matsize 10000
matrix drop _all 
mkmat s118-s138 , matrix(A)
matrix At=(A') 
putexcel K6=matrix(At) 
putexcel K2="${YYYY_Qm1}"
 
clear all
use "ILO_table_T1_var_Qref.dta"
set matsize 10000
matrix drop _all 
mkmat s118-s138 , matrix(A)
matrix At=(A') 
putexcel O6=matrix(At) 
putexcel O2="${YYYY_Q}" 

putexcel S2="${YYYY_Q} - ${YYYY_Qm4}"
putexcel W2="${YYYY_Q} - ${YYYY_Qm1}"

putexcel AA2="${YYYY_Q} - ${YYYY_Qm4}"
putexcel AE2="${YYYY_Q} - ${YYYY_Qm1}"



* delete all the temporary dataset 
erase "ILO_table_T1_var_Qref.dta" 
erase "ILO_table_T1_var_Qrefminus1.dta" 
erase "ILO_table_T1_var_Qrefminus4.dta" 
