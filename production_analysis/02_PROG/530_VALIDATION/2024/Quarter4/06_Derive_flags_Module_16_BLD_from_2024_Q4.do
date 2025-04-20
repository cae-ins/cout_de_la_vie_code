
*******************************************************************************************************************
*
* DERIVE FLAGS TO HIGHLIGH PROBLEMS WITH QUESTIONS AND SECTIONS
* 
*******************************************************************************************************************

/* COdes
1 - out of range
2 - missing: to impute
3 - undue wrong filter: to delete
9 - undue < 15: to delete
*/

*******************************************************************************************************************
*******************************************************************************************************************
***                                                                                                             ***
***                CHECK ON MODULE 14 - BLD  -  OWN USE PRODUCTION OF FOODSTUFF                                 ***
***                                                                                                             *** 
*******************************************************************************************************************
*******************************************************************************************************************


/********************************************************      BLD_START_MODULE    ********************************************/
* drop    	F_BLD_START_MODULE_0
generate  	F_BLD_START_MODULE_0=0
replace   	F_BLD_START_MODULE_0=1 if DEM_AGE>= 15   & GLO_WAP==1
tab      	F_BLD_START_MODULE_0

generate  	F_BLD_START_MODULE_1=0
replace   	F_BLD_START_MODULE_1=0
replace   	F_BLD_START_MODULE_1=1 if  DEM_AGE>= 15 & F_BLD_START_MODULE_0 != BLD_START_MODULE

tab      	F_BLD_START_MODULE_1, miss 		
tab     	BLD_START_MODULE if F_BLD_START_MODULE_1==1
tab     	BLD_START_MODULE, miss


/********************************************************    BLD_OPG        ********************************************/
* drop   F_BLD_OPG_0
generate F_BLD_OPG_0=0
replace  F_BLD_OPG_0=1 if DEM_AGE>= 15 & BLD_START_MODULE==1
tab      F_BLD_OPG_0,  miss 

* drop   F_BLD_OPG_1
generate F_BLD_OPG_1=0
replace  F_BLD_OPG_1=0
replace  F_BLD_OPG_1=1 if DEM_AGE>= 15 &   F_BLD_OPG_0==1   & !inlist(BLD_OPG,1,2)
replace  F_BLD_OPG_1=2 if DEM_AGE>= 15 &   F_BLD_OPG_0==1   &  inlist(BLD_OPG,0,.)
replace  F_BLD_OPG_1=3 if DEM_AGE>= 15 & !(F_BLD_OPG_0==1)  & !inlist(BLD_OPG,.)
replace  F_BLD_OPG_1=9 if DEM_AGE<  15                      & !inlist(BLD_OPG,.)

tab      F_BLD_OPG_1, miss 

tab      BLD_OPG if DEM_AGE>= 15 & BLD_START_MODULE==1, miss 


********************************************************      BLD_OPG_HRS   ********************************************/
* drop   F_BLD_OPG_HRS_0
generate F_BLD_OPG_HRS_0=0
replace  F_BLD_OPG_HRS_0=1 if DEM_AGE>= 15 & BLD_START_MODULE==1 & BLD_OPG==1 
tab      F_BLD_OPG_HRS_0 , miss 

* drop   F_BLD_OPG_HRS_1
generate F_BLD_OPG_HRS_1=0
replace  F_BLD_OPG_HRS_1=0
replace  F_BLD_OPG_HRS_1=1 if DEM_AGE>= 15 &   F_BLD_OPG_HRS_0==1  & !inrange(BLD_OPG_HRS,0.5,168) & BLD_OPG_HRS!=997
replace  F_BLD_OPG_HRS_1=2 if DEM_AGE>= 15 &   F_BLD_OPG_HRS_0==1  &   inlist(BLD_OPG_HRS,0,.)
replace  F_BLD_OPG_HRS_1=3 if DEM_AGE<  15 & !(F_BLD_OPG_HRS_0==1) &  !inlist(BLD_OPG_HRS,.)
replace  F_BLD_OPG_HRS_1=9 if DEM_AGE<  15                         &  !inlist(BLD_OPG_HRS,.)
tab      F_BLD_OPG_HRS_1,  miss 
tab        BLD_OPG_HRS if BLD_OPG==1, miss 
tab        BLD_OPG_HRS if BLD_OPG==1 & BLD_OPG_HRS==0, miss


/********************************************************      BLD_END_MODULE    ********************************************/
* drop    	F_BLD_END_MODULE_0
generate  	F_BLD_END_MODULE_0=0
replace   	F_BLD_END_MODULE_0=1 if DEM_AGE>= 15 & BLD_START_MODULE==1 
tab      	F_BLD_END_MODULE_0 

* drop    	F_BLD_END_MODULE_1
generate  	F_BLD_END_MODULE_1=0
replace   	F_BLD_END_MODULE_1=0
replace   	F_BLD_END_MODULE_1=1 if DEM_AGE>= 15 & F_BLD_END_MODULE_0 != BLD_END_MODULE

tab      	F_BLD_END_MODULE_1, miss

*******************************************************************************************************************
*
*            TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_BLD_0 ///
F_BLD_START_MODULE_0 ///
F_BLD_OPG_0 ///
F_BLD_OPG_HRS_0 ///
F_BLD_END_MODULE_0 ///

foreach var of varlist $List_F_BLD_0 {
    tab `var' if `var'>0 , miss 
}

global List_F_BLD_1 ///
F_BLD_START_MODULE_1 ///
F_BLD_OPG_1 ///
F_BLD_OPG_HRS_1 ///
F_BLD_END_MODULE_1 ///


foreach var of varlist $List_F_BLD_1 {
    tab `var' if `var'>0 , miss 
}
