*******************************************************************************************************************
*
* DERIVE FLAGS TO HIGHLIGH PROBLEMS WITH QUESTIONS AND SECTIONS
* 
*******************************************************************************************************************

/* Codes
1 - out of range
2 - missing: to impute
3 - undue wrong filter: to delete
9 - undue < 15: to delete
*/
*******************************************************************************************************************
*
* MODULE ABS - TEMPORARY ABSENT FROM EMPLOYMENT
* 
*******************************************************************************************************************

/******************************************************    ABS_JOB    ********************************************/
* drop   	F_ABS_JOB_0
generate 	F_ABS_JOB_0=0
replace  	F_ABS_JOB_0=1 if DEM_AGE>= 15 &   ATW_PAY==2 & ATW_PFT==2 & ATW_FAM==2

* drop   	F_ABS_JOB_1
generate 	F_ABS_JOB_1=0
replace  	F_ABS_JOB_1=1 if DEM_AGE>= 15 &   ATW_PAY==2 & ATW_PFT==2 & ATW_FAM==2  & !inlist(ABS_JOB,1,2)
replace  	F_ABS_JOB_1=2 if DEM_AGE>= 15 &   ATW_PAY==2 & ATW_PFT==2 & ATW_FAM==2  &  inlist(ABS_JOB,0,.)
replace  	F_ABS_JOB_1=3 if DEM_AGE>= 15 & !(ATW_PAY==2 & ATW_PFT==2 & ATW_FAM==2) & !inlist(ABS_JOB,0,.)
replace  	F_ABS_JOB_1=9 if DEM_AGE<  15 &                                           !inlist(ABS_JOB,0,.)
tab      	F_ABS_JOB_1, miss
tab      	ABS_JOB if ATW_PAY==2 & ATW_PFT==2 & ATW_FAM==2, miss

/******************************************************    ABS_WHY    ********************************************/
* drop   	F_ABS_WHY_0
generate 	F_ABS_WHY_0=0
replace  	F_ABS_WHY_0=1 if DEM_AGE>= 15 &  ABS_JOB==1

* drop   	F_ABS_WHY_1
generate 	F_ABS_WHY_1=0
replace  	F_ABS_WHY_1=1 if DEM_AGE>= 15 &  ABS_JOB==1 & !inrange(ABS_WHY,1,13)
replace  	F_ABS_WHY_1=2 if DEM_AGE>= 15 &  ABS_JOB==1 &   inlist(ABS_WHY,0,.)
replace  	F_ABS_WHY_1=3 if DEM_AGE>= 15 &  ABS_JOB!=1 &  !inlist(ABS_WHY,0,.)
replace  	F_ABS_WHY_1=9 if DEM_AGE<  15 &                !inlist(ABS_WHY,0,.)
tab      	F_ABS_WHY_1, miss
tab         ABS_WHY if ABS_JOB==1, miss

/******************************************************    ABS_SEA    ********************************************/
* drop   	F_ABS_SEA_0
generate 	F_ABS_SEA_0=0
replace  	F_ABS_SEA_0=1 if DEM_AGE>= 15 &  ABS_WHY==2

* drop   	F_ABS_SEA_1
generate 	F_ABS_SEA_1=0
replace  	F_ABS_SEA_1=1 if DEM_AGE>= 15 &  ABS_WHY==2 &  !inlist(ABS_SEA,1,2)
replace  	F_ABS_SEA_1=2 if DEM_AGE>= 15 &  ABS_WHY==2 &   inlist(ABS_SEA,0,.)
replace  	F_ABS_SEA_1=3 if DEM_AGE>= 15 &  ABS_WHY!=2 &  !inlist(ABS_SEA,0,.)
replace  	F_ABS_SEA_1=9 if DEM_AGE<  15 &                !inlist(ABS_SEA,0,.)
tab      	F_ABS_SEA_1, miss
tab         ABS_WHY ABS_SEA if ABS_JOB==1, miss


/******************************************************    ABS_DUR    ********************************************/
* drop   	F_ABS_DUR_0
generate 	F_ABS_DUR_0=0
replace  	F_ABS_DUR_0=1 if DEM_AGE>= 15 &  inlist(ABS_WHY,7,8,9,10,11,12,13)

* drop   	F_ABS_DUR_1
generate 	F_ABS_DUR_1=0
replace  	F_ABS_DUR_1=1 if DEM_AGE>= 15 &  inlist(ABS_WHY,7,8,9,10,11,12,13) & !inlist(ABS_DUR,1,2,3)
replace  	F_ABS_DUR_1=2 if DEM_AGE>= 15 &  inlist(ABS_WHY,7,8,9,10,11,12,13) &  inlist(ABS_DUR,0,.)
replace  	F_ABS_DUR_1=3 if DEM_AGE>= 15 & !inlist(ABS_WHY,7,8,9,10,11,12,13) & !inlist(ABS_DUR,0,.)
replace  	F_ABS_DUR_1=9 if DEM_AGE<  15 &                                      !inlist(ABS_DUR,0,.)
tab      	F_ABS_DUR_1, miss
tab         ABS_WHY ABS_DUR if ABS_JOB==1, miss

/******************************************************    ABS_PAY    ********************************************/
* drop   	F_ABS_PAY_0
generate 	F_ABS_PAY_0=0
replace  	F_ABS_PAY_0=1 if DEM_AGE>= 15 &  inlist(ABS_DUR,2,3)

* drop   	F_ABS_PAY_1
generate 	F_ABS_PAY_1=0
replace  	F_ABS_PAY_1=1 if DEM_AGE>= 15 &  inlist(ABS_DUR,2,3) & !inlist(ABS_PAY,1,2)
replace  	F_ABS_PAY_1=2 if DEM_AGE>= 15 &  inlist(ABS_DUR,2,3) &  inlist(ABS_PAY,0,.)
replace  	F_ABS_PAY_1=3 if DEM_AGE>= 15 & !inlist(ABS_DUR,2,3) & !inlist(ABS_PAY,0,.)
replace  	F_ABS_PAY_1=9 if DEM_AGE<  15 &                        !inlist(ABS_PAY,0,.)
tab      	F_ABS_PAY_1, miss
tab         ABS_WHY ABS_PAY if ABS_JOB==1, miss
tab         ABS_DUR ABS_PAY if ABS_JOB==1, miss 







*******************************************************************************************************************
*
*            TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************
global List_F_ABS_0 ///
F_ABS_JOB_0 ///
F_ABS_WHY_0 ///
F_ABS_SEA_0 ///
F_ABS_DUR_0 ///
F_ABS_PAY_0


global List_F_ABS_1 ///
F_ABS_JOB_1 ///
F_ABS_WHY_1 ///
F_ABS_SEA_1 ///
F_ABS_DUR_1 ///
F_ABS_PAY_1 ///


foreach var of varlist $List_F_ABS_1 {
    tab `var' if `var'>0 , miss
}

