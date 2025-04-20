

*******************************************************************************************************************
*
* DERIVE FLAGS TO HIGHLIGHT PROBLEMS WITH QUESTIONS AND SECTIONS
* 
*******************************************************************************************************************


/* Codes
1 - out of range
2 - missing: to impute
3 - undue wrong filter: to delete
9 - undue < 15: to delete
*/

/* SECTION MIG  */


/********************************************************      MIG_LARR_DUR         ********************************************/
* drop    F_MIG_LARR_DUR_0
generate  F_MIG_LARR_DUR_0=0
replace   F_MIG_LARR_DUR_0=0
replace   F_MIG_LARR_DUR_0=1 if ind_eligible==1 & DEM_NAT!=462
tab       F_MIG_LARR_DUR_0 , miss

* drop    F_MIG_LARR_DUR_1
generate  F_MIG_LARR_DUR_1=0
replace   F_MIG_LARR_DUR_1=0
replace   F_MIG_LARR_DUR_1=1 if DEM_AGE>= 15  &    F_MIG_LARR_DUR_0==1  &  !inrange(MIG_LARR_DUR,0,DEM_AGE)
replace   F_MIG_LARR_DUR_1=2 if DEM_AGE>= 15  &    F_MIG_LARR_DUR_0==1  &    inlist(MIG_LARR_DUR,.)
replace   F_MIG_LARR_DUR_1=3 if DEM_AGE>= 15  &  !(F_MIG_LARR_DUR_0==1) &   !inlist(MIG_LARR_DUR,.)

tab       F_MIG_LARR_DUR_0  F_MIG_LARR_DUR_1 , miss
//tab DEM_NAT MIG_LARR_DUR, miss

//list interview__key form_stream DEM_NAT MIG_LARR_DUR ENU_1 ENU_2 GHI_PSU_ID GHI_BLOCK_CODE if F_MIG_LARR_DUR_1 == 2

/********************************************************      MIG_CNTY_MAL         ********************************************/
* drop    F_MIG_CNTY_MAL_0
generate  F_MIG_CNTY_MAL_0=0
replace   F_MIG_CNTY_MAL_0=0
replace   F_MIG_CNTY_MAL_0=1 if DEM_NAT!=462 & MIG_LARR_DUR<DEM_AGE & ind_eligible==1 
tab       F_MIG_CNTY_MAL_0 , miss

* drop    F_MIG_CNTY_MAL_1
generate  F_MIG_CNTY_MAL_1=0
replace   F_MIG_CNTY_MAL_1=0
replace   F_MIG_CNTY_MAL_1=1 if DEM_AGE>= 15  &    F_MIG_CNTY_MAL_0==1  & !inrange(MIG_CNTY_MAL,4,894)
replace   F_MIG_CNTY_MAL_1=2 if DEM_AGE>= 15  &    F_MIG_CNTY_MAL_0==1  &   inlist(MIG_CNTY_MAL,.)
replace   F_MIG_CNTY_MAL_1=3 if DEM_AGE>= 15  &  !(F_MIG_CNTY_MAL_0==1) &  !inlist(MIG_CNTY_MAL,.)

tab       F_MIG_CNTY_MAL_0 F_MIG_CNTY_MAL_1 , miss



/********************************************************      MIG_BTH         ********************************************/
* drop    F_MIG_BTH_0
generate  F_MIG_BTH_0=0
replace   F_MIG_BTH_0=0
replace   F_MIG_BTH_0=1 if ind_eligible==1 
tab       F_MIG_BTH_0 , miss

* drop    F_MIG_BTH_1
generate  F_MIG_BTH_1=0
replace   F_MIG_BTH_1=0
replace   F_MIG_BTH_1=1 if DEM_AGE>= 15  &   F_MIG_BTH_0==1  & !inlist(MIG_BTH,1,2,3)
replace   F_MIG_BTH_1=2 if DEM_AGE>= 15  &   F_MIG_BTH_0==1  &  inlist(MIG_BTH,.)
replace   F_MIG_BTH_1=3 if DEM_AGE>= 15  & !(F_MIG_BTH_0==1) & !inlist(MIG_BTH,.)


tab       F_MIG_BTH_0  F_MIG_BTH_1, miss

tab       MIG_BTH, miss nolabel


/********************************************************      MIG_BTH_ATL         ********************************************/
* drop    F_MIG_BTH_ATL_0
generate  F_MIG_BTH_ATL_0=0
replace   F_MIG_BTH_ATL_0=0
replace   F_MIG_BTH_ATL_0=1 if ind_eligible==1 & MIG_BTH==2
tab       F_MIG_BTH_ATL_0 , miss

* drop    F_MIG_BTH_ATL_1
generate  F_MIG_BTH_ATL_1=0
replace   F_MIG_BTH_ATL_1=0
replace   F_MIG_BTH_ATL_1=1 if DEM_AGE>= 15  &   F_MIG_BTH_ATL_0==1  & !inlist(MIG_BTH_ATL,10,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39)
replace   F_MIG_BTH_ATL_1=2 if DEM_AGE>= 15  &   F_MIG_BTH_ATL_0==1  &  inlist(MIG_BTH_ATL,.)
replace   F_MIG_BTH_ATL_1=3 if DEM_AGE>= 15  & !(F_MIG_BTH_ATL_0==1) & !inlist(MIG_BTH_ATL,.)

tab       F_MIG_BTH_ATL_0  F_MIG_BTH_ATL_1, miss


/********************************************************      MIG_BTH_ISL         ********************************************/
* drop    F_MIG_BTH_ISL_0
generate  F_MIG_BTH_ISL_0=0
replace   F_MIG_BTH_ISL_0=0
replace   F_MIG_BTH_ISL_0=1 if ind_eligible==1 & inlist(MIG_BTH_ATL,10,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39)
tab       F_MIG_BTH_ISL_0 , miss

* drop    F_MIG_BTH_ISL_1
generate  F_MIG_BTH_ISL_1=0
replace   F_MIG_BTH_ISL_1=0
replace   F_MIG_BTH_ISL_1=1 if DEM_AGE>= 15  &   F_MIG_BTH_ISL_0==1  & !inrange(MIG_BTH_ISL,1,10000)
replace   F_MIG_BTH_ISL_1=2 if DEM_AGE>= 15  &   F_MIG_BTH_ISL_0==1  &   inlist(MIG_BTH_ISL,.)
replace   F_MIG_BTH_ISL_1=3 if DEM_AGE>= 15  & !(F_MIG_BTH_ISL_0==1) &  !inlist(MIG_BTH_ISL,.)

tab       F_MIG_BTH_ISL_0  F_MIG_BTH_ISL_1, miss


/********************************************************      MIG_BTH_CNTY         ********************************************/
* drop    F_MIG_BTH_CNTY_0
generate  F_MIG_BTH_CNTY_0=0
replace   F_MIG_BTH_CNTY_0=0
replace   F_MIG_BTH_CNTY_0=1 if ind_eligible==1 & MIG_BTH==3
tab       F_MIG_BTH_CNTY_0 , miss

* drop    F_MIG_BTH_CNTY_1
generate  F_MIG_BTH_CNTY_1=0
replace   F_MIG_BTH_CNTY_1=0
replace   F_MIG_BTH_CNTY_1=1 if DEM_AGE>= 15  &   F_MIG_BTH_CNTY_0==1  & !inrange(MIG_BTH_CNTY,4004,4894)
replace   F_MIG_BTH_CNTY_1=2 if DEM_AGE>= 15  &   F_MIG_BTH_CNTY_0==1  &   inlist(MIG_BTH_CNTY,.)
replace   F_MIG_BTH_CNTY_1=3 if DEM_AGE>= 15  & !(F_MIG_BTH_CNTY_0==1) &  !inlist(MIG_BTH_CNTY,.)

tab       F_MIG_BTH_CNTY_0  F_MIG_BTH_CNTY_1, miss



/********************************************************      MIG_REG         ********************************************/
* drop    F_MIG_REG_0
generate  F_MIG_REG_0=0
replace   F_MIG_REG_0=0
replace   F_MIG_REG_0=1 if ind_eligible==1 & DEM_NAT==462
tab       F_MIG_REG_0 , miss

* drop    F_MIG_REG_1
generate  F_MIG_REG_1=0
replace   F_MIG_REG_1=0
replace   F_MIG_REG_1=1 if DEM_AGE>= 15  &   F_MIG_REG_0==1  &  !inlist(MIG_REG,1,3,4)
replace   F_MIG_REG_1=2 if DEM_AGE>= 15  &   F_MIG_REG_0==1  &   inlist(MIG_REG,.)
replace   F_MIG_REG_1=3 if DEM_AGE>= 15  & !(F_MIG_REG_0==1) &  !inlist(MIG_REG,.)

tab       F_MIG_REG_0  F_MIG_REG_1, miss



/********************************************************      MIG_REG_ATL         ********************************************/
* drop    F_MIG_REG_ATL_0
generate  F_MIG_REG_ATL_0=0
replace   F_MIG_REG_ATL_0=0
replace   F_MIG_REG_ATL_0=1 if ind_eligible==1 & MIG_REG==3
tab       F_MIG_REG_ATL_0 , miss

* drop    F_MIG_REG_ATL_1
generate  F_MIG_REG_ATL_1=0
replace   F_MIG_REG_ATL_1=0
replace   F_MIG_REG_ATL_1=1 if DEM_AGE>= 15  &   F_MIG_REG_ATL_0==1  & !inlist(MIG_REG_ATL,10,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39)
replace   F_MIG_REG_ATL_1=2 if DEM_AGE>= 15  &   F_MIG_REG_ATL_0==1  &  inlist(MIG_REG_ATL,.)
replace   F_MIG_REG_ATL_1=3 if DEM_AGE>= 15  & !(F_MIG_REG_ATL_0==1) & !inlist(MIG_REG_ATL,.)

tab       F_MIG_REG_ATL_0  F_MIG_REG_ATL_1, miss


/********************************************************      MIG_REG_ISL         ********************************************/
* drop    F_MIG_REG_ISL_0
generate  F_MIG_REG_ISL_0=0
replace   F_MIG_REG_ISL_0=0
replace   F_MIG_REG_ISL_0=1 if ind_eligible==1 & inlist(MIG_REG_ATL,10,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39)
tab       F_MIG_REG_ISL_0 , miss

* drop    F_MIG_REG_ISL_1
generate  F_MIG_REG_ISL_1=0
replace   F_MIG_REG_ISL_1=0
replace   F_MIG_REG_ISL_1=1 if DEM_AGE>= 15  &   F_MIG_REG_ISL_0==1  & !inrange(MIG_REG_ISL,1,10000)
replace   F_MIG_REG_ISL_1=2 if DEM_AGE>= 15  &   F_MIG_REG_ISL_0==1  &   inlist(MIG_REG_ISL,.)
replace   F_MIG_REG_ISL_1=3 if DEM_AGE>= 15  & !(F_MIG_REG_ISL_0==1) &  !inlist(MIG_REG_ISL,.)

tab       F_MIG_REG_ISL_0  F_MIG_REG_ISL_1, miss




/********************************************************      MIG_USL         ********************************************/
* drop    F_MIG_USL_0
generate  F_MIG_USL_0=0
replace   F_MIG_USL_0=0
replace   F_MIG_USL_0=1 if ind_eligible==1 
tab       F_MIG_USL_0 , miss

* drop    F_MIG_USL_1
generate  F_MIG_USL_1=0
replace   F_MIG_USL_1=0
replace   F_MIG_USL_1=1 if DEM_AGE>= 15  &   F_MIG_USL_0==1  &  !inlist(MIG_USL,1,2,3)
replace   F_MIG_USL_1=2 if DEM_AGE>= 15  &   F_MIG_USL_0==1  &   inlist(MIG_USL,.)
replace   F_MIG_USL_1=3 if DEM_AGE>= 15  & !(F_MIG_USL_0==1) &  !inlist(MIG_USL,.)

tab       F_MIG_USL_0  F_MIG_USL_1, miss



/********************************************************      MIG_USL_ATL         ********************************************/
* drop    F_MIG_USL_ATL_0
generate  F_MIG_USL_ATL_0=0
replace   F_MIG_USL_ATL_0=0
replace   F_MIG_USL_ATL_0=1 if ind_eligible==1 & MIG_USL==2
tab       F_MIG_USL_ATL_0 , miss

* drop    F_MIG_USL_ATL_1
generate  F_MIG_USL_ATL_1=0
replace   F_MIG_USL_ATL_1=0
replace   F_MIG_USL_ATL_1=1 if DEM_AGE>= 15  &   F_MIG_USL_ATL_0==1  & !inlist(MIG_USL_ATL,10,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39)
replace   F_MIG_USL_ATL_1=2 if DEM_AGE>= 15  &   F_MIG_USL_ATL_0==1  &  inlist(MIG_USL_ATL,.)
replace   F_MIG_USL_ATL_1=3 if DEM_AGE>= 15  & !(F_MIG_USL_ATL_0==1) & !inlist(MIG_USL_ATL,.)

tab       F_MIG_USL_ATL_0  F_MIG_USL_ATL_1, miss


/********************************************************      MIG_USL_ISL         ********************************************/
* drop    F_MIG_USL_ISL_0
generate  F_MIG_USL_ISL_0=0
replace   F_MIG_USL_ISL_0=0
replace   F_MIG_USL_ISL_0=1 if ind_eligible==1 & inlist(MIG_USL_ATL,10,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39)
tab       F_MIG_USL_ISL_0 , miss

* drop    F_MIG_USL_ISL_1
generate  F_MIG_USL_ISL_1=0
replace   F_MIG_USL_ISL_1=0
replace   F_MIG_USL_ISL_1=1 if DEM_AGE>= 15  &   F_MIG_USL_ISL_0==1  & !inrange(MIG_USL_ISL,1,10000)
replace   F_MIG_USL_ISL_1=2 if DEM_AGE>= 15  &   F_MIG_USL_ISL_0==1  &   inlist(MIG_USL_ISL,.)
replace   F_MIG_USL_ISL_1=3 if DEM_AGE>= 15  & !(F_MIG_USL_ISL_0==1) &  !inlist(MIG_USL_ISL,.)

tab       F_MIG_USL_ISL_0  F_MIG_USL_ISL_1, miss



/********************************************************      MIG_USL_CNTY         ********************************************/
* drop    F_MIG_USL_CNTY_0
generate  F_MIG_USL_CNTY_0=0
replace   F_MIG_USL_CNTY_0=0
replace   F_MIG_USL_CNTY_0=1 if ind_eligible==1 & MIG_USL==3
tab       F_MIG_USL_CNTY_0 , miss

* drop    F_MIG_USL_CNTY_1
generate  F_MIG_USL_CNTY_1=0
replace   F_MIG_USL_CNTY_1=0
replace   F_MIG_USL_CNTY_1=1 if DEM_AGE>= 15  &   F_MIG_USL_CNTY_0==1  & !inrange(MIG_USL_CNTY,4004,4894)
replace   F_MIG_USL_CNTY_1=2 if DEM_AGE>= 15  &   F_MIG_USL_CNTY_0==1  &   inlist(MIG_USL_CNTY,.)
replace   F_MIG_USL_CNTY_1=3 if DEM_AGE>= 15  & !(F_MIG_USL_CNTY_0==1) &  !inlist(MIG_USL_CNTY,.)

tab       F_MIG_USL_CNTY_0  F_MIG_USL_CNTY_1, miss





/********************************************************      MIG_ERO         ********************************************/
* drop    F_MIG_ERO_0
generate  F_MIG_ERO_0=0
replace   F_MIG_ERO_0=0
replace   F_MIG_ERO_0=1 if ind_eligible==1 & DEM_AGE>=1  &  inlist(MIG_USL,1,2)
tab       F_MIG_ERO_0 , miss

* drop    F_MIG_ERO_1
generate  F_MIG_ERO_1=0
replace   F_MIG_ERO_1=0
replace   F_MIG_ERO_1=1 if DEM_AGE>= 15  &   F_MIG_ERO_0==1  &  !inlist(MIG_ERO,1,2)
replace   F_MIG_ERO_1=2 if DEM_AGE>= 15  &   F_MIG_ERO_0==1  &   inlist(MIG_ERO,.)
replace   F_MIG_ERO_1=3 if DEM_AGE>= 15  & !(F_MIG_ERO_0==1) &  !inlist(MIG_ERO,.)

tab       F_MIG_ERO_0  F_MIG_ERO_1, miss





/********************************************************      MIG_PREV         ********************************************/
* drop    F_MIG_PREV_0
generate  F_MIG_PREV_0=0
replace   F_MIG_PREV_0=0
replace   F_MIG_PREV_0=1 if ind_eligible==1 & MIG_ERO==1
tab       F_MIG_PREV_0 , miss

* drop    F_MIG_PREV_1
generate  F_MIG_PREV_1=0
replace   F_MIG_PREV_1=0
replace   F_MIG_PREV_1=1 if DEM_AGE>= 15  &   F_MIG_PREV_0==1  &  !inlist(MIG_PREV,1,2,3)
replace   F_MIG_PREV_1=2 if DEM_AGE>= 15  &   F_MIG_PREV_0==1  &   inlist(MIG_PREV,.)
replace   F_MIG_PREV_1=3 if DEM_AGE>= 15  & !(F_MIG_PREV_0==1) &  !inlist(MIG_PREV,.)

tab       F_MIG_PREV_0  F_MIG_PREV_1, miss



/********************************************************      MIG_PREV_ATL         ********************************************/
* drop    F_MIG_PREV_ATL_0
generate  F_MIG_PREV_ATL_0=0
replace   F_MIG_PREV_ATL_0=0
replace   F_MIG_PREV_ATL_0=1 if ind_eligible==1 & MIG_PREV==2
tab       F_MIG_PREV_ATL_0 , miss

* drop    F_MIG_PREV_ATL_1
generate  F_MIG_PREV_ATL_1=0
replace   F_MIG_PREV_ATL_1=0
replace   F_MIG_PREV_ATL_1=1 if DEM_AGE>= 15  &   F_MIG_PREV_ATL_0==1  & !inlist(MIG_PREV_ATL,10,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39)
replace   F_MIG_PREV_ATL_1=2 if DEM_AGE>= 15  &   F_MIG_PREV_ATL_0==1  &  inlist(MIG_PREV_ATL,.)
replace   F_MIG_PREV_ATL_1=3 if DEM_AGE>= 15  & !(F_MIG_PREV_ATL_0==1) & !inlist(MIG_PREV_ATL,.)

tab       F_MIG_PREV_ATL_0  F_MIG_PREV_ATL_1, miss


/********************************************************      MIG_PREV_ISL         ********************************************/
* drop    F_MIG_PREV_ISL_0
generate  F_MIG_PREV_ISL_0=0
replace   F_MIG_PREV_ISL_0=0
replace   F_MIG_PREV_ISL_0=1 if ind_eligible==1 & inlist(MIG_PREV_ATL,10,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39)
tab       F_MIG_PREV_ISL_0 , miss

* drop    F_MIG_PREV_ISL_1
generate  F_MIG_PREV_ISL_1=0
replace   F_MIG_PREV_ISL_1=0
replace   F_MIG_PREV_ISL_1=1 if DEM_AGE>= 15  &   F_MIG_PREV_ISL_0==1  & !inrange(MIG_PREV_ISL,1,10000)
replace   F_MIG_PREV_ISL_1=2 if DEM_AGE>= 15  &   F_MIG_PREV_ISL_0==1  &   inlist(MIG_PREV_ISL,.)
replace   F_MIG_PREV_ISL_1=3 if DEM_AGE>= 15  & !(F_MIG_PREV_ISL_0==1) &  !inlist(MIG_PREV_ISL,.)

tab       F_MIG_PREV_ISL_0  F_MIG_PREV_ISL_1, miss



/********************************************************      MIG_PREV_CNTY         ********************************************/
* drop    F_MIG_PREV_CNTY_0
generate  F_MIG_PREV_CNTY_0=0
replace   F_MIG_PREV_CNTY_0=0
replace   F_MIG_PREV_CNTY_0=1 if ind_eligible==1 & MIG_PREV==3
tab       F_MIG_PREV_CNTY_0 , miss

* drop    F_MIG_PREV_CNTY_1
generate  F_MIG_PREV_CNTY_1=0
replace   F_MIG_PREV_CNTY_1=0
replace   F_MIG_PREV_CNTY_1=1 if DEM_AGE>= 15  &   F_MIG_PREV_CNTY_0==1  & !inrange(MIG_PREV_CNTY,4004,4894)
replace   F_MIG_PREV_CNTY_1=2 if DEM_AGE>= 15  &   F_MIG_PREV_CNTY_0==1  &   inlist(MIG_PREV_CNTY,.)
replace   F_MIG_PREV_CNTY_1=3 if DEM_AGE>= 15  & !(F_MIG_PREV_CNTY_0==1) &  !inlist(MIG_PREV_CNTY,.)

tab       F_MIG_PREV_CNTY_0  F_MIG_PREV_CNTY_1, miss



/********************************************************      MIG_USL_YR         ********************************************/
* drop    F_MIG_USL_YR_0
generate  F_MIG_USL_YR_0=0
replace   F_MIG_USL_YR_0=1 if MIG_ERO==1
tab       F_MIG_USL_YR_0 , miss

* drop    F_MIG_USL_YR_1
generate  F_MIG_USL_YR_1=0
replace   F_MIG_USL_YR_1=0
replace   F_MIG_USL_YR_1=1 if   F_MIG_USL_YR_0==1  &  !inrange(MIG_USL_YR,1903,year) & MIG_USL_YR!=9997
replace   F_MIG_USL_YR_1=2 if   F_MIG_USL_YR_0==1  &    inlist(MIG_USL_YR,.)
replace   F_MIG_USL_YR_1=3 if !(F_MIG_USL_YR_0==1) &   !inlist(MIG_USL_YR,.)

tab       F_MIG_USL_YR_0 F_MIG_USL_YR_1 , miss
tab       MIG_USL_YR , miss

/********************************************************      MIG_USL_DUR        ********************************************/
* drop    F_MIG_USL_DUR_0
generate  F_MIG_USL_DUR_0=0
replace   F_MIG_USL_DUR_0=1 if MIG_USL_YR==9997
tab       F_MIG_USL_DUR_0

* drop    F_MIG_USL_DUR_1
generate  F_MIG_USL_DUR_1=0
replace   F_MIG_USL_DUR_1=1 if   F_MIG_USL_DUR_0==1  &  !inrange(MIG_USL_DUR,0,DEM_AGE)
replace   F_MIG_USL_DUR_1=2 if   F_MIG_USL_DUR_0==1  &    inlist(MIG_USL_DUR,.)
replace   F_MIG_USL_DUR_1=3 if !(F_MIG_USL_DUR_0==1) &   !inlist(MIG_USL_DUR,.)

tab       F_MIG_USL_DUR_0  F_MIG_USL_DUR_1 , miss

tab         MIG_USL_DUR


/********************************************************      MIG_REAS        ********************************************/
* drop    F_MIG_REAS_0
generate  F_MIG_REAS_0=0
replace   F_MIG_REAS_0=1 if MIG_ERO==1
tab       F_MIG_REAS_0

* drop    F_MIG_REAS_1
generate  F_MIG_REAS_1=0
replace   F_MIG_REAS_1=1 if   F_MIG_REAS_0==1  & !inrange(MIG_REAS,1,12) & MIG_REAS!=-96
replace   F_MIG_REAS_1=2 if   F_MIG_REAS_0==1  &   inlist(MIG_REAS,0,.)
replace   F_MIG_REAS_1=3 if !(F_MIG_REAS_0==1) &  !inlist(MIG_REAS,.)

tab       F_MIG_REAS_0  F_MIG_REAS_1 , miss



/********************************************************      MIG_REAS_OTH        ********************************************/
* drop    F_MIG_REAS_OTH_0
generate  F_MIG_REAS_OTH_0=0
replace   F_MIG_REAS_OTH_0=1 if MIG_ERO==1 & MIG_REAS==-96
tab       F_MIG_REAS_OTH_0

* drop    F_MIG_REAS_OTH_1
generate  F_MIG_REAS_OTH_1=0
replace   F_MIG_REAS_OTH_1=0
replace   F_MIG_REAS_OTH_1=2 if   F_MIG_REAS_OTH_0==1  &   MIG_REAS_OTH==""
replace   F_MIG_REAS_OTH_1=3 if !(F_MIG_REAS_OTH_0==1) &   MIG_REAS_OTH!=""

tab       F_MIG_REAS_OTH_0  F_MIG_REAS_OTH_1 , miss


*******************************************************************************************************************
*
*            TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_MIG_0 ///
F_MIG_LARR_DUR_0  ///
F_MIG_CNTY_MAL_0  ///
F_MIG_BTH_0  ///
F_MIG_BTH_ATL_0   ///
F_MIG_BTH_ISL_0  ///
F_MIG_BTH_CNTY_0  ///
F_MIG_REG_0  ///
F_MIG_REG_ATL_0  ///
F_MIG_REG_ISL_0  ///
F_MIG_USL_0  ///
F_MIG_USL_ATL_0  ///
F_MIG_USL_ISL_0  ///
F_MIG_USL_CNTY_0  ///
F_MIG_ERO_0  ///
F_MIG_PREV_0  ///
F_MIG_PREV_ATL_0  ///
F_MIG_PREV_ISL_0  ///
F_MIG_PREV_CNTY_0  ///
F_MIG_USL_YR_0  ///
F_MIG_USL_DUR_0  ///
F_MIG_REAS_0  ///
F_MIG_REAS_OTH_0 ///


global List_F_MIG_1 ///
F_MIG_LARR_DUR_1  ///
F_MIG_CNTY_MAL_1  ///
F_MIG_BTH_1  ///
F_MIG_BTH_ATL_1   ///
F_MIG_BTH_ISL_1  ///
F_MIG_BTH_CNTY_1  ///
F_MIG_REG_1  ///
F_MIG_REG_ATL_1  ///
F_MIG_REG_ISL_1  ///
F_MIG_USL_1  ///
F_MIG_USL_ATL_1  ///
F_MIG_USL_ISL_1  ///
F_MIG_USL_CNTY_1  ///
F_MIG_ERO_1  ///
F_MIG_PREV_1  ///
F_MIG_PREV_ATL_1  ///
F_MIG_PREV_ISL_1  ///
F_MIG_PREV_CNTY_1  ///
F_MIG_USL_YR_1  ///
F_MIG_USL_DUR_1  ///
F_MIG_REAS_1  ///
F_MIG_REAS_OTH_1 ///


foreach var of varlist $List_F_MIG_1 {
    tab `var' if `var'>0 , miss
}

