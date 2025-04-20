
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
* MODULE ATW - EMPLOYED AT WORK
* 
*******************************************************************************************************************


/******************************************************    ATW_PAY    ********************************************/
*drop    F_ATW_PAY_0
generate F_ATW_PAY_0=0
replace  F_ATW_PAY_0=1 if DEM_AGE>= 15

*drop    F_ATW_PAY_1
generate F_ATW_PAY_1=0
replace  F_ATW_PAY_1=1 if DEM_AGE>= 15 & !inlist(ATW_PAY,1,2)
replace  F_ATW_PAY_1=2 if DEM_AGE>= 15 &  inlist(ATW_PAY,0,.)
replace  F_ATW_PAY_1=9 if DEM_AGE<  15 & !inlist(ATW_PAY,0,.)
tab      F_ATW_PAY_1, miss




/******************************************************    ATW_PFT    ********************************************/
* drop   F_ATW_PFT_0
generate F_ATW_PFT_0=0
replace  F_ATW_PFT_0=1 if DEM_AGE>= 15 & ATW_PAY==2

* drop   F_ATW_PFT_1
generate F_ATW_PFT_1=0
replace  F_ATW_PFT_1=1 if DEM_AGE>= 15 & ATW_PAY==2 & !inlist(ATW_PFT,1,2)
replace  F_ATW_PFT_1=2 if DEM_AGE>= 15 & ATW_PAY==2 &  inlist(ATW_PFT,0,.)
replace  F_ATW_PFT_1=3 if DEM_AGE>= 15 & ATW_PAY!=2 & !inlist(ATW_PFT,0,.)
replace  F_ATW_PFT_1=9 if DEM_AGE<  15 &              !inlist(ATW_PFT,0,.)
tab      F_ATW_PFT_1, miss

/******************************************************    ATW_FAM    ********************************************/
*drop    F_ATW_FAM_0
generate F_ATW_FAM_0=0
replace  F_ATW_FAM_0=1 if DEM_AGE>= 15 &   ATW_PAY==2 & ATW_PFT==2


* drop    F_ATW_FAM_1
generate F_ATW_FAM_1=0
replace  F_ATW_FAM_1=1 if DEM_AGE>= 15 &   ATW_PAY==2 & ATW_PFT==2  & !inlist(ATW_FAM,1,2)
replace  F_ATW_FAM_1=2 if DEM_AGE>= 15 &   ATW_PAY==2 & ATW_PFT==2  &  inlist(ATW_FAM,0,.)
replace  F_ATW_FAM_1=3 if DEM_AGE>= 15 &                ATW_PFT!=2  & !inlist(ATW_FAM,0,.)
replace  F_ATW_FAM_1=9 if DEM_AGE<  15 &                              !inlist(ATW_FAM,0,.)
tab      F_ATW_FAM_1, miss


*******************************************************************************************************************
*
*                                                    TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_ATW_0 ///
F_ATW_PAY_0 ///
F_ATW_PFT_0 ///
F_ATW_FAM_0 ///


global List_F_ATW_1 ///
F_ATW_PAY_1 ///
F_ATW_PFT_1 ///
F_ATW_FAM_1 ///


foreach var of varlist $List_F_ATW_1 {
    tab `var' if `var'>0 , miss
}
