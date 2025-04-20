

*******************************************************************************************************************
*
* DERIVE FLAGS TO HIGHLIGH PROBLEMS WITH QUESTIONS AND SECTIONS
* 
*******************************************************************************************************************
//clear all

/* Codes
0 - No errors
1 - out of range
2 - missing: to impute
3 - undue wrong filter: to delete
9 - undue < 15: to delete
*/




/********************************************************      EDU_MOT        ********************************************/
* drop    F_EDU_MOT_0
generate  F_EDU_MOT_0=0
replace   F_EDU_MOT_0=1 if DEM_AGE>= 10
tab       F_EDU_MOT_0, miss

* drop    F_EDU_MOT_1
generate  F_EDU_MOT_1=0
replace   F_EDU_MOT_1=1 if DEM_AGE>= 5 &   F_EDU_MOT_0==1    & !inlist(EDU_MOT,1,2)
replace   F_EDU_MOT_1=2 if DEM_AGE>= 5 &   F_EDU_MOT_0==1    &  inlist(EDU_MOT,.)
replace   F_EDU_MOT_1=3 if DEM_AGE>= 5 & !(F_EDU_MOT_0==1)   & !inlist(EDU_MOT,.)
replace   F_EDU_MOT_1=9 if DEM_AGE<  5 &                       !inlist(EDU_MOT,.)

tab       F_EDU_MOT_0 F_EDU_MOT_1 , miss



/********************************************************      EDU_ENG        ********************************************/
* drop    F_EDU_ENG_0
generate  F_EDU_ENG_0=0
replace   F_EDU_ENG_0=1 if DEM_AGE>= 10
tab       F_EDU_ENG_0, miss

* drop    F_EDU_ENG_1
generate  F_EDU_ENG_1=0
replace   F_EDU_ENG_1=1 if DEM_AGE>= 5 &   F_EDU_ENG_0==1    & !inlist(EDU_ENG,1,2)
replace   F_EDU_ENG_1=2 if DEM_AGE>= 5 &   F_EDU_ENG_0==1    &  inlist(EDU_ENG,.)
replace   F_EDU_ENG_1=3 if DEM_AGE>= 5 & !(F_EDU_ENG_0==1)   & !inlist(EDU_ENG,.)
replace   F_EDU_ENG_1=9 if DEM_AGE<  5 &                       !inlist(EDU_ENG,.)

tab       F_EDU_ENG_0 F_EDU_ENG_1 , miss


/********************************************************      DEM_EDC        ********************************************/
* drop    F_DEM_EDC_0
generate  F_DEM_EDC_0=0
replace   F_DEM_EDC_0=0
replace   F_DEM_EDC_0=1 if DEM_AGE>= 5
tab       F_DEM_EDC_0, miss



* drop    F_DEM_EDC_1
generate  F_DEM_EDC_1=0
replace   F_DEM_EDC_1=0
replace   F_DEM_EDC_1=1 if DEM_AGE>= 5 &   F_DEM_EDC_0==1    & !inlist(DEM_EDC,1,2)
replace   F_DEM_EDC_1=2 if DEM_AGE>= 5 &   F_DEM_EDC_0==1    &  inlist(DEM_EDC,.)
replace   F_DEM_EDC_1=3 if DEM_AGE>= 5 & !(F_DEM_EDC_0==1)   & !inlist(DEM_EDC,.)
replace   F_DEM_EDC_1=9 if DEM_AGE<  5 &                       !inlist(DEM_EDC,.)

tab       F_DEM_EDC_0 F_DEM_EDC_1 , miss




/********************************************************      EDU_LVL        ********************************************/
* drop    F_EDU_LVL_0
generate  F_EDU_LVL_0=0
replace   F_EDU_LVL_0=1 if DEM_AGE>= 5 & DEM_EDC==1
tab       F_EDU_LVL_0, miss

* drop    F_EDU_LVL_1
generate  F_EDU_LVL_1=0
replace   F_EDU_LVL_1=0
replace   F_EDU_LVL_1=1 if DEM_AGE>= 5 &   F_EDU_LVL_0==1    & !inrange(EDU_LVL,0,20)
replace   F_EDU_LVL_1=2 if DEM_AGE>= 5 &   F_EDU_LVL_0==1    &   inlist(EDU_LVL,.)
replace   F_EDU_LVL_1=3 if DEM_AGE>= 5 & !(F_EDU_LVL_0==1)   &  !inlist(EDU_LVL,.)
replace   F_EDU_LVL_1=9 if DEM_AGE<  5 &                        !inlist(EDU_LVL,.)

tab       F_EDU_LVL_0 F_EDU_LVL_1 , miss

tab       EDU_LVL,miss nol

/********************************************************      EDU_EVR        ********************************************/
* drop    F_EDU_EVR_0
generate  F_EDU_EVR_0=0
replace   F_EDU_EVR_0=1 if DEM_AGE>= 5 & DEM_EDC==2
tab       F_EDU_EVR_0, miss

* drop    F_EDU_EVR_1
generate  F_EDU_EVR_1=0
replace   F_EDU_EVR_1=1 if DEM_AGE>= 5 &   F_EDU_EVR_0==1    & !inlist(EDU_EVR,1,2)
replace   F_EDU_EVR_1=2 if DEM_AGE>= 5 &   F_EDU_EVR_0==1    &  inlist(EDU_EVR,.)
replace   F_EDU_EVR_1=3 if DEM_AGE>= 5 & !(F_EDU_EVR_0==1)   & !inlist(EDU_EVR,.)
replace   F_EDU_EVR_1=9 if DEM_AGE<  5 &                       !inlist(EDU_EVR,.)

tab       F_EDU_EVR_0 F_EDU_EVR_1 , miss




/********************************************************      EDU_HIGH        ********************************************/
* drop    F_EDU_HIGH_0
generate  F_EDU_HIGH_0=0
replace   F_EDU_HIGH_0=1 if DEM_AGE>= 5 & (EDU_EVR==1  | DEM_EDC == 1 ) & !inrange(EDU_LVL,0,12)
tab       F_EDU_HIGH_0, miss

* drop    F_EDU_HIGH_1
generate  F_EDU_HIGH_1=0
replace   F_EDU_HIGH_1=0
replace   F_EDU_HIGH_1=1 if DEM_AGE>= 5 &   F_EDU_HIGH_0==1    & !inrange(EDU_HIGH,0,14)
replace   F_EDU_HIGH_1=2 if DEM_AGE>= 5 &   F_EDU_HIGH_0==1    &   inlist(EDU_HIGH,.)
replace   F_EDU_HIGH_1=3 if DEM_AGE>= 5 & !(F_EDU_HIGH_0==1)   &  !inlist(EDU_HIGH,.)
replace   F_EDU_HIGH_1=9 if DEM_AGE<  5 &                         !inlist(EDU_HIGH,.)

tab       F_EDU_HIGH_0 F_EDU_HIGH_1 , miss




/********************************************************      EDU_YRS        ********************************************/
* drop    F_EDU_YRS_0
generate  F_EDU_YRS_0=0
replace   F_EDU_YRS_0=0 
replace   F_EDU_YRS_0=1 if DEM_AGE>= 5 & EDU_EVR==1 & EDU_HIGH>=13
tab       F_EDU_YRS_0, miss

tab       EDU_YRS, miss nol

* drop    F_EDU_YRS_1
generate  F_EDU_YRS_1=0
replace   F_EDU_YRS_1=0
replace   F_EDU_YRS_1=1 if DEM_AGE>= 5 &   F_EDU_YRS_0==1    &      ! (EDU_YRS>=1 & EDU_YRS<=DEM_AGE) & EDU_YRS!=97
replace   F_EDU_YRS_1=2 if DEM_AGE>= 5 &   F_EDU_YRS_0==1    &  inlist(EDU_YRS,.)
replace   F_EDU_YRS_1=3 if DEM_AGE>= 5 & !(F_EDU_YRS_0==1)   & !inlist(EDU_YRS,.)
replace   F_EDU_YRS_1=9 if DEM_AGE<  5 &                       !inlist(EDU_YRS,.)

tab       F_EDU_YRS_0 F_EDU_YRS_1 , miss


/********************************************************      DEM_EDL        ********************************************/

* drop    F_DEM_EDL_0
generate  F_DEM_EDL_0=0
replace   F_DEM_EDL_0=0
replace   F_DEM_EDL_0=1 if DEM_AGE>= 15
tab       F_DEM_EDL_0 , miss

* drop    F_DEM_EDL_1
generate  F_DEM_EDL_1=0
replace   F_DEM_EDL_1=0 
replace   F_DEM_EDL_1=1 if DEM_AGE>= 15 &   F_DEM_EDL_0==1     & !inlist(DEM_EDL,0,1,2,3,4,5,6,7)
replace   F_DEM_EDL_1=2 if DEM_AGE>= 15 &   F_DEM_EDL_0==1     &  inlist(DEM_EDL,.)
replace   F_DEM_EDL_1=3 if DEM_AGE>= 15 & !(F_DEM_EDL_0==1)    & !inlist(DEM_EDL,.)
replace   F_DEM_EDL_1=9 if DEM_AGE<  15                        & !inlist(DEM_EDL,.)

tab       F_DEM_EDL_0 F_DEM_EDL_1 , miss

// list ENU_1 ENU_2 EDU_EVR EDU_HIGH EDU_MOT DEM_EDL DEM_AGE ind_eligible interview__key if F_DEM_EDL_0==1 & F_DEM_EDL_1==2



/********************************************************      DEM_EDF        ********************************************/
* drop    F_DEM_EDF_0
generate  F_DEM_EDF_0=0
replace   F_DEM_EDF_0=1 if DEM_AGE>= 5 & inrange(DEM_EDL,2,6)
tab       F_DEM_EDF_0 , miss

* drop    F_DEM_EDF_1
generate  F_DEM_EDF_1=0
replace   F_DEM_EDF_1=0
replace   F_DEM_EDF_1=1 if DEM_AGE>= 5 &   F_DEM_EDF_0==1  &   DEM_EDF==""
replace   F_DEM_EDF_1=2 if DEM_AGE>= 5 &   F_DEM_EDF_0==1  &   DEM_EDF==""
replace   F_DEM_EDF_1=3 if DEM_AGE>= 5 & !(F_DEM_EDF_0==1) &   DEM_EDF!=""
replace   F_DEM_EDF_1=9 if DEM_AGE<  5 &                       DEM_EDF!=""

tab       F_DEM_EDF_0 F_DEM_EDF_1 , miss



*******************************************************************************************************************
*
*                                                    TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_EDU_0 ///
F_EDU_MOT_0 ///
F_EDU_ENG_0 ///
F_DEM_EDC_0 ///
F_EDU_LVL_0 ///
F_EDU_EVR_0 ///
F_EDU_HIGH_0 ///
F_EDU_YRS_0 ///
F_DEM_EDL_0 ///
F_DEM_EDF_0 ///


global List_F_EDU_1 ///
F_EDU_MOT_1 ///
F_EDU_ENG_1 ///
F_DEM_EDC_1 ///
F_EDU_LVL_1 ///
F_EDU_EVR_1 ///
F_EDU_HIGH_1 ///
F_EDU_YRS_1 ///
F_DEM_EDL_1 ///
F_DEM_EDF_1 ///

foreach var of varlist $List_F_EDU_1 {
    tab `var' if `var'>0 , miss
}


