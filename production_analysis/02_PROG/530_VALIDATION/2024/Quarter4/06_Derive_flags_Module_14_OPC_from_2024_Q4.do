
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
***                        CHECK ON THE OPC  -  OWN USE PRODUCTION OF FOODSTUFF                                 ***
***                                                                                                             *** 
*******************************************************************************************************************
*******************************************************************************************************************
 

/********************************************************      OPC_HCROP  ********************************************/
* drop   F_OPC_HCROP_0
generate F_OPC_HCROP_0=0
replace  F_OPC_HCROP_0=1 if DEM_AGE>= 15 & AGF_HIR!=2
tab      F_OPC_HCROP_0, missing

* drop   F_OPC_HCROP_1
generate F_OPC_HCROP_1=0
replace  F_OPC_HCROP_1=1 if DEM_AGE>= 15 &   F_OPC_HCROP_0==1   & !inlist(OPC_HCROP,1,2) 
replace  F_OPC_HCROP_1=2 if DEM_AGE>= 15 &   F_OPC_HCROP_0==1   &  inlist(OPC_HCROP,.)
replace  F_OPC_HCROP_1=3 if DEM_AGE>= 15 & !(F_OPC_HCROP_0==1)  & !inlist(OPC_HCROP,.)
replace  F_OPC_HCROP_1=9 if DEM_AGE< 15                         & !inlist(OPC_HCROP,.)

tab      F_OPC_HCROP_0  F_OPC_HCROP_1 , miss 

tab      OPC_HCROP, miss 

/*
tab      AGF_HIR OPC_HCROP if DEM_AGE>= 15, miss 
*/

/********************************************************      OPC_ACTHRS  ********************************************/
*   drop   OPC_ACTHRS
generate F_OPC_ACTHRS_0=0
replace  F_OPC_ACTHRS_0=0
replace  F_OPC_ACTHRS_0=1 if DEM_AGE>= 15 & OPC_HCROP==1
tab      F_OPC_ACTHRS_0, missing

*   drop   OPC_HHRSW_1
generate F_OPC_ACTHRS_1=0
replace  F_OPC_ACTHRS_1=0
replace  F_OPC_ACTHRS_1=1 if DEM_AGE>= 15 &   F_OPC_ACTHRS_0==1  & !inrange(OPC_ACTHRS,0.5,168)  & OPC_ACTHRS!=997 
replace  F_OPC_ACTHRS_1=2 if DEM_AGE>= 15 &   F_OPC_ACTHRS_0==1  &   inlist(OPC_ACTHRS,0,.)
replace  F_OPC_ACTHRS_1=3 if DEM_AGE>= 15 & !(F_OPC_ACTHRS_0==1) &  !inlist(OPC_ACTHRS,.)
replace  F_OPC_ACTHRS_1=9 if DEM_AGE<  15 &                         !inlist(OPC_ACTHRS,.)

tab      F_OPC_ACTHRS_0 F_OPC_ACTHRS_1, miss

tab      OPC_ACTHRS  if F_OPC_ACTHRS_1==1 , miss
tab       OPC_ACTHRS , miss



*******************************************************************************************************************
*
*            TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_OPC_0 ///
F_OPC_HCROP_0 ///
F_OPC_ACTHRS_0

foreach var of varlist $List_F_OPC_0 {
    tab `var' if `var'>0 , miss
}

global List_F_OPC_1 ///
F_OPC_HCROP_1 ///
F_OPC_ACTHRS_1

foreach var of varlist $List_F_OPC_1 {
    tab `var' if `var'>0 , miss
}
