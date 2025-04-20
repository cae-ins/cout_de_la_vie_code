
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

/********************************************************    MNF_OPG        ********************************************/
* drop   F_MNF_OPG_0
generate F_MNF_OPG_0=0
replace  F_MNF_OPG_0=1 if DEM_AGE>= 15 
tab      F_MNF_OPG_0,  miss 

* drop   F_MNF_OPG_1
generate F_MNF_OPG_1=0
replace  F_MNF_OPG_1=0
replace  F_MNF_OPG_1=1 if DEM_AGE>= 15 &   F_MNF_OPG_0==1   & !inlist(MNF_OPG,1,2)
replace  F_MNF_OPG_1=2 if DEM_AGE>= 15 &   F_MNF_OPG_0==1   &  inlist(MNF_OPG,.)
replace  F_MNF_OPG_1=3 if DEM_AGE>= 15 & !(F_MNF_OPG_0==1)  & !inlist(MNF_OPG,.)
replace  F_MNF_OPG_1=9 if DEM_AGE<  15                      & !inlist(MNF_OPG,.)

tab      F_MNF_OPG_0 F_MNF_OPG_1, miss 

// list MNF_OPG if DEM_AGE>=15


********************************************************      MNF_OPG_HRS   ********************************************/
* drop   F_MNF_OPG_HRS_0
generate F_MNF_OPG_HRS_0=0
replace  F_MNF_OPG_HRS_0=1 if DEM_AGE>= 15 & MNF_OPG==1 
tab      F_MNF_OPG_HRS_0 , miss 

* drop   F_MNF_OPG_HRS_1
generate F_MNF_OPG_HRS_1=0
replace  F_MNF_OPG_HRS_1=0
replace  F_MNF_OPG_HRS_1=1 if DEM_AGE>= 15 &   F_MNF_OPG_HRS_0==1  & !inrange(MNF_OPG_HRS,0.5,168) & MNF_OPG_HRS!=997
replace  F_MNF_OPG_HRS_1=2 if DEM_AGE>= 15 &   F_MNF_OPG_HRS_0==1  &   inlist(MNF_OPG_HRS,0,.)
replace  F_MNF_OPG_HRS_1=3 if DEM_AGE<  15 & !(F_MNF_OPG_HRS_0==1) &  !inlist(MNF_OPG_HRS,0,.)
replace  F_MNF_OPG_HRS_1=9 if DEM_AGE<  15                         &  !inlist(MNF_OPG_HRS,0,.)

tab      F_MNF_OPG_HRS_0 F_MNF_OPG_HRS_1,  miss 


*******************************************************************************************************************
*
*            TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_MNF_0 ///
F_MNF_OPG_0 ///
F_MNF_OPG_HRS_0 ///

foreach var of varlist $List_F_MNF_0 {
    tab `var' if `var'>0 , miss 
}

global List_F_MNF_1 ///
F_MNF_OPG_1 ///
F_MNF_OPG_HRS_1 ///

foreach var of varlist $List_F_MNF_1 {
    tab `var' if `var'>0 , miss 
}
