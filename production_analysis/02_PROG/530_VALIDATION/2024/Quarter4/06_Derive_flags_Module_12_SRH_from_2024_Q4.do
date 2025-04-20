
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
***                                            CHECK ON THE SRH  -  JOB  SEARCH                                 ***
***                                                                                                             *** 
*******************************************************************************************************************
*******************************************************************************************************************

tab  DEM_AGE GLO_EMP if DEM_AGE>=15, miss

/********************************************************      SRH_JOB   ********************************************/
* drop    F_SRH_JOB_0
generate  F_SRH_JOB_0=0
replace   F_SRH_JOB_0=0
replace   F_SRH_JOB_0=1 if DEM_AGE>= 15 & GLO_EMP==0
tab       F_SRH_JOB_0

* drop    F_SRH_JOB_1
generate  F_SRH_JOB_1=0
replace   F_SRH_JOB_1=0
replace   F_SRH_JOB_1=1 if DEM_AGE>= 15 &   F_SRH_JOB_0==1    & !inlist(SRH_JOB,1,2)
replace   F_SRH_JOB_1=2 if DEM_AGE>= 15 &   F_SRH_JOB_0==1    &  inlist(SRH_JOB,.)
replace   F_SRH_JOB_1=3 if DEM_AGE>= 15 & !(F_SRH_JOB_0==1)   & !inlist(SRH_JOB,.)
replace   F_SRH_JOB_1=9 if DEM_AGE<  15                       & !inlist(SRH_JOB,.)

tab       F_SRH_JOB_0 F_SRH_JOB_1, miss

* tab       SRH_JOB, miss

/*
tab         ATW_PAY     if F_SRH_JOB_0==0 & F_SRH_JOB_1==3 , miss
tab         AGF_CHK__6  if F_SRH_JOB_0==0 & F_SRH_JOB_1==3 , miss
tab         AGF_HIR     if F_SRH_JOB_0==0 & F_SRH_JOB_1==3 , miss
tab         AGF_MKT     if F_SRH_JOB_0==0 & F_SRH_JOB_1==3 , miss
tab         AGF_HIS     if F_SRH_JOB_0==0 & F_SRH_JOB_1==3 , miss
tab         ABS_SEA     if F_SRH_JOB_0==0 & F_SRH_JOB_1==3 , miss
*/

/*
tab         ATW_PAY     if F_SRH_JOB_0==1 & F_SRH_JOB_1==2 , miss
tab         AGF_ANY__6  if F_SRH_JOB_0==1 & F_SRH_JOB_1==2 , miss
tab         AGF_CHK__6  if F_SRH_JOB_0==1 & F_SRH_JOB_1==2 , miss
tab         AGF_HIR     if F_SRH_JOB_0==1 & F_SRH_JOB_1==2 , miss
tab         AGF_MKT     if F_SRH_JOB_0==1 & F_SRH_JOB_1==2 , miss
tab         AGF_HIS     if F_SRH_JOB_0==1 & F_SRH_JOB_1==2 , miss
tab         AGF_HIR     if F_SRH_JOB_0==1 & F_SRH_JOB_1==2 , miss
tab         ABS_SEA     if F_SRH_JOB_0==1 & F_SRH_JOB_1==2 , miss
*/

* list DEM_AGE ATW_PAY AGF_CHK__6 if F_SRH_JOB_0==1 & F_SRH_JOB_1==2   ATW_PAY not filled


/********************************************************      SRH_MTD    ********************************************/
* drop    F_SRH_MTD_0
generate  F_SRH_MTD_0=0
replace   F_SRH_MTD_0=0
replace   F_SRH_MTD_0=1 if DEM_AGE>= 15 &  SRH_JOB==1
tab       F_SRH_MTD_0

* drop    F_SRH_MTD_1
generate  F_SRH_MTD_1=0
replace   F_SRH_MTD_1=0
replace   F_SRH_MTD_1=1 if DEM_AGE>= 15 &   F_SRH_MTD_0==1  & !inlist(SRH_MTD,1,2,3,4,5,6,7,-96)
replace   F_SRH_MTD_1=2 if DEM_AGE>= 15 &   F_SRH_MTD_0==1  &  inlist(SRH_MTD,.)
replace   F_SRH_MTD_1=3 if DEM_AGE>= 15 & !(F_SRH_MTD_0==1) & !inlist(SRH_MTD,.)
replace   F_SRH_MTD_1=9 if DEM_AGE<  15 &                     !inlist(SRH_MTD,.)

tab       F_SRH_MTD_0 F_SRH_MTD_1, miss

*tab         SRH_MTD  if SRH_MTD!=. , miss

/********************************************************      SRH_MTD_OTH    ********************************************/
* drop    F_SRH_MTD_OTH_0
generate  F_SRH_MTD_OTH_0=0
replace   F_SRH_MTD_OTH_0=0
replace   F_SRH_MTD_OTH_0=1 if DEM_AGE>= 15 &  SRH_MTD==-96
tab       F_SRH_MTD_OTH_0

* drop    F_SRH_MTD_1
generate  F_SRH_MTD_OTH_1=0
replace   F_SRH_MTD_OTH_1=0
replace   F_SRH_MTD_OTH_1=2 if DEM_AGE>= 15 &   F_SRH_MTD_OTH_0==1  & SRH_MTD_OTH==""
replace   F_SRH_MTD_OTH_1=3 if DEM_AGE>= 15 & !(F_SRH_MTD_OTH_0==1) & SRH_MTD_OTH!=""
replace   F_SRH_MTD_OTH_1=9 if DEM_AGE<  15 &                     SRH_MTD_OTH!=""

tab       F_SRH_MTD_OTH_0 F_SRH_MTD_OTH_1, miss



/********************************************************      SRH_ACT    ********************************************/
* drop    F_SRH_ACT_0
generate  F_SRH_ACT_0=0
replace   F_SRH_ACT_0=0
replace   F_SRH_ACT_0=1 if DEM_AGE>= 15 & SRH_MTD==2 
tab       F_SRH_ACT_0

* drop    F_SRH_ACT_1
generate  F_SRH_ACT_1=0
replace   F_SRH_ACT_1=0
replace   F_SRH_ACT_1=1 if DEM_AGE>= 15 &    F_SRH_ACT_0==1   & !inlist(SRH_ACT,1,2)
replace   F_SRH_ACT_1=2 if DEM_AGE>= 15 &    F_SRH_ACT_0==1   &  inlist(SRH_ACT,0,.)
replace   F_SRH_ACT_1=3 if DEM_AGE>= 15 &  !(F_SRH_ACT_0==1)  & !inlist(SRH_ACT,0,.)
replace   F_SRH_ACT_1=9 if DEM_AGE<  15                       & !inlist(SRH_ACT,0,.)

tab       F_SRH_ACT_0 F_SRH_ACT_1, miss

* tab         SRH_ACT  , miss  



/********************************************************      SRH_OTH    ********************************************/
* drop    F_SRH_OTH_0
generate  F_SRH_OTH_0=0
replace   F_SRH_OTH_0=0 
replace   F_SRH_OTH_0=1 if DEM_AGE>= 15 & SRH_ACT==1
tab       F_SRH_OTH_0

* drop    F_SRH_OTH_1
generate  F_SRH_OTH_1=0
replace   F_SRH_OTH_1=0
replace   F_SRH_OTH_1=2 if DEM_AGE>= 15 &    F_SRH_OTH_0==1   & !inlist(SRH_OTH,1,3,4,5,6,7,8)
replace   F_SRH_OTH_1=2 if DEM_AGE>= 15 &    F_SRH_OTH_0==1   &  inlist(SRH_OTH,.)
replace   F_SRH_OTH_1=3 if DEM_AGE>= 15 &  !(F_SRH_OTH_0==1)  & !inlist(SRH_OTH,.)
replace   F_SRH_OTH_1=9 if DEM_AGE<  15                       & !inlist(SRH_OTH,.)

tab       F_SRH_OTH_0 F_SRH_OTH_1, miss


/********************************************************      SRH_OTH_OTH    ********************************************/
* drop    F_SRH_OTH_OTH_0
generate  F_SRH_OTH_OTH_0=0
replace   F_SRH_OTH_OTH_0=0 
replace   F_SRH_OTH_OTH_0=1 if DEM_AGE>= 15 & SRH_OTH==8
tab       F_SRH_OTH_OTH_0

* drop    F_SRH_OTH_1
generate  F_SRH_OTH_OTH_1=0
replace   F_SRH_OTH_OTH_1=0
replace   F_SRH_OTH_OTH_1=2 if DEM_AGE>= 15 &    F_SRH_OTH_OTH_0==1   & SRH_OTH_OTH==""
replace   F_SRH_OTH_OTH_1=3 if DEM_AGE>= 15 &  !(F_SRH_OTH_OTH_0==1)  & SRH_OTH_OTH!=""
replace   F_SRH_OTH_OTH_1=9 if DEM_AGE<  15                       & SRH_OTH_OTH!=""

tab       F_SRH_OTH_OTH_0 F_SRH_OTH_OTH_1, miss


/********************************************************      SRH_DUR    ********************************************/
* drop    F_SRH_DUR_0
generate  F_SRH_DUR_0=0
replace   F_SRH_DUR_0=0
replace   F_SRH_DUR_0=1 if DEM_AGE>= 15 &  SRH_JOB==1
tab       F_SRH_DUR_0

* drop    F_SRH_DUR_1
generate  F_SRH_DUR_1=0
replace   F_SRH_DUR_1=0
replace   F_SRH_DUR_1=1 if DEM_AGE>= 15 &   F_SRH_DUR_0==1  &  !inrange(SRH_DUR,1,6)
replace   F_SRH_DUR_1=2 if DEM_AGE>= 15 &   F_SRH_DUR_0==1  &   inlist(SRH_DUR,.)
replace   F_SRH_DUR_1=3 if DEM_AGE>= 15 & !(F_SRH_DUR_0==1) &  !inlist(SRH_DUR,.)
replace   F_SRH_DUR_1=9 if DEM_AGE<  15                     &  !inlist(SRH_DUR,.)

tab       F_SRH_DUR_0 F_SRH_DUR_1, miss

*tab         SRH_DUR  if SRH_DUR!=. , miss

/********************************************************      SRH_DES    ********************************************/
* drop    F_SRH_DES_0
generate  F_SRH_DES_0=0
replace   F_SRH_DES_0=0
replace   F_SRH_DES_0=1 if DEM_AGE>= 15 &  SRH_JOB==2
tab       F_SRH_DES_0

* drop    F_SRH_DES_1
generate  F_SRH_DES_1=0
replace   F_SRH_DES_1=0
replace   F_SRH_DES_1=1 if DEM_AGE>= 15 &   F_SRH_DES_0==1  & !inlist(SRH_DES,1,2)
replace   F_SRH_DES_1=2 if DEM_AGE>= 15 &   F_SRH_DES_0==1  &  inlist(SRH_DES,.)
replace   F_SRH_DES_1=3 if DEM_AGE>= 15 & !(F_SRH_DES_0==1) & !inlist(SRH_DES,.)
replace   F_SRH_DES_1=9 if DEM_AGE<  15                     & !inlist(SRH_DES,.)

tab        F_SRH_DES_0 F_SRH_DES_1, miss

* tab         SRH_DES  if SRH_DES!=. , miss


/********************************************************      SRH_DWY    ********************************************/
* drop    F_SRH_DWY_0
generate  F_SRH_DWY_0=0
replace   F_SRH_DWY_0=0
replace   F_SRH_DWY_0=1 if DEM_AGE>= 15 &  SRH_DES==1
tab       F_SRH_DWY_0

* drop    F_SRH_DWY_1
generate  F_SRH_DWY_1=0
replace   F_SRH_DWY_1=0
replace   F_SRH_DWY_1=1 if DEM_AGE>= 15 &   F_SRH_DWY_0==1  & !inrange(SRH_DWY,1,13)
replace   F_SRH_DWY_1=2 if DEM_AGE>= 15 &   F_SRH_DWY_0==1  &  inlist(SRH_DWY,.)
replace   F_SRH_DWY_1=3 if DEM_AGE>= 15 & !(F_SRH_DWY_0==1) & !inlist(SRH_DWY,.)
replace   F_SRH_DWY_1=9 if DEM_AGE<  15                     & !inlist(SRH_DWY,.)

tab       F_SRH_DWY_0 F_SRH_DWY_1, miss


*tab         SRH_DWY  if SRH_DWY!=. , miss


/********************************************************      SRH_DWY_OTH    ********************************************/
* drop    F_SRH_DWY_OTH_0
generate  F_SRH_DWY_OTH_0=0
replace   F_SRH_DWY_OTH_0=0
replace   F_SRH_DWY_OTH_0=1 if DEM_AGE>= 15 &  SRH_DWY==13
tab       F_SRH_DWY_OTH_0

* drop    F_SRH_DWY_1
generate  F_SRH_DWY_OTH_1=0
replace   F_SRH_DWY_OTH_1=0
replace   F_SRH_DWY_OTH_1=2 if DEM_AGE>= 15 &   F_SRH_DWY_OTH_0==1  & SRH_DWY_OTH==""
replace   F_SRH_DWY_OTH_1=3 if DEM_AGE>= 15 & !(F_SRH_DWY_OTH_0==1) & SRH_DWY_OTH!=""
replace   F_SRH_DWY_OTH_1=9 if DEM_AGE<  15                         & SRH_DWY_OTH!=""

tab       F_SRH_DWY_OTH_0 F_SRH_DWY_OTH_1, miss

*tab         SRH_DWY  if SRH_DWY!=. , miss


/********************************************************      SRH_FTR   ********************************************/
* drop    F_SRH_FTR_0
generate  F_SRH_FTR_0=0
replace   F_SRH_FTR_0=0
replace   F_SRH_FTR_0=1 if DEM_AGE>= 15 &  (ABS_WHY==1 | SRH_DWY==4 )
tab       F_SRH_FTR_0

* drop    F_SRH_FTR_1
generate  F_SRH_FTR_1=0
replace   F_SRH_FTR_1=0
replace   F_SRH_FTR_1=1 if DEM_AGE>= 15 &    F_SRH_FTR_0==1   & !inlist(SRH_FTR,1,2,3)
replace   F_SRH_FTR_1=2 if DEM_AGE>= 15 &    F_SRH_FTR_0==1   &  inlist(SRH_FTR,.)
replace   F_SRH_FTR_1=3 if DEM_AGE>= 15 &  !(F_SRH_FTR_0==1)  & !inlist(SRH_FTR,.)
replace   F_SRH_FTR_1=9 if DEM_AGE<  15                       & !inlist(SRH_FTR,.)

tab       F_SRH_FTR_0 F_SRH_FTR_1, missing

* tab         SRH_FTR  if SRH_FTR!=. , miss



/********************************************************      SRH_FAN    ********************************************/
* drop    F_SRH_FAN_0
generate  F_SRH_FAN_0=0
replace   F_SRH_FAN_0=0
replace   F_SRH_FAN_0=1 if DEM_AGE>= 15 &  ( ABS_WHY==1 | SRH_DWY==4 )
tab       F_SRH_FAN_0

* drop    F_SRH_FAN_1
generate  F_SRH_FAN_1=0
replace   F_SRH_FAN_1=0
replace   F_SRH_FAN_1=1 if DEM_AGE>= 15 &   F_SRH_FAN_0==1  & !inlist(SRH_FAN,1,2)
replace   F_SRH_FAN_1=2 if DEM_AGE>= 15 &   F_SRH_FAN_0==1  &  inlist(SRH_FAN,.)
replace   F_SRH_FAN_1=3 if DEM_AGE>= 15 & !(F_SRH_FAN_0==1) & !inlist(SRH_FAN,.)
replace   F_SRH_FAN_1=9 if DEM_AGE<  15                     & !inlist(SRH_FAN,.)

tab       F_SRH_FAN_0 F_SRH_FAN_1, miss

* list      ABS_WHY SRH_DWY SRH_FAN  if F_SRH_FAN_0==0 & F_SRH_FAN_1==3

/********************************************************      SRH_AVN    ********************************************/
* drop    F_SRH_AVN_0
generate  F_SRH_AVN_0=0
replace   F_SRH_AVN_0=0
replace   F_SRH_AVN_0=1 if DEM_AGE>= 15 & (SRH_JOB== 1 | (SRH_DES== 1 & SRH_DWY!=4))
tab       F_SRH_AVN_0

* drop    F_SRH_AVN_1
generate  F_SRH_AVN_1=0
replace   F_SRH_AVN_1=0
replace   F_SRH_AVN_1=1 if DEM_AGE>= 15 &   F_SRH_AVN_0==1  & !inlist(SRH_AVN,1,2)
replace   F_SRH_AVN_1=2 if DEM_AGE>= 15 &   F_SRH_AVN_0==1  &  inlist(SRH_AVN,.)
replace   F_SRH_AVN_1=3 if DEM_AGE>= 15 & !(F_SRH_AVN_0==1) & !inlist(SRH_AVN,.)
replace   F_SRH_AVN_1=9 if DEM_AGE<  15                     & !inlist(SRH_AVN,.)

tab       F_SRH_AVN_0 F_SRH_AVN_1, miss

*tab         SRH_AVN  if SRH_AVN!=. , miss

/********************************************************      SRH_AVL    ********************************************/
* drop    F_SRH_AVL_0
generate  F_SRH_AVL_0=0
replace   F_SRH_AVL_0=0
replace   F_SRH_AVL_0=1 if DEM_AGE>= 15 & (SRH_FAN==2 | SRH_AVN == 2)
tab       F_SRH_AVL_0

* drop    F_SRH_AVL_1
generate  F_SRH_AVL_1=0
replace   F_SRH_AVL_1=0
replace   F_SRH_AVL_1=1 if DEM_AGE>= 15 &   F_SRH_AVL_0==1  & !inlist(SRH_AVL,1,2)
replace   F_SRH_AVL_1=2 if DEM_AGE>= 15 &   F_SRH_AVL_0==1  &  inlist(SRH_AVL,.)
replace   F_SRH_AVL_1=3 if DEM_AGE>= 15 & !(F_SRH_AVL_0==1) & !inlist(SRH_AVL,.)
replace   F_SRH_AVL_1=9 if DEM_AGE<  15                     & !inlist(SRH_AVL,.)

tab       F_SRH_AVL_0 F_SRH_AVL_1, miss

*tab         SRH_AVL  if SRH_AVL!=. , miss



/********************************************************      SRH_NAR    ********************************************/
* drop    F_SRH_NAR_0
generate  F_SRH_NAR_0=0
replace   F_SRH_NAR_0=0
replace   F_SRH_NAR_0=1 if DEM_AGE>= 15 & SRH_AVL==2
tab       F_SRH_NAR_0

* drop    F_SRH_NAR_1
generate  F_SRH_NAR_1=0
replace   F_SRH_NAR_1=0
replace   F_SRH_NAR_1=1 if DEM_AGE>= 15 &    F_SRH_NAR_0==1  &  !inrange(SRH_NAR,1,7)
replace   F_SRH_NAR_1=2 if DEM_AGE>= 15 &    F_SRH_NAR_0==1  &    inlist(SRH_NAR,.)
replace   F_SRH_NAR_1=3 if DEM_AGE>= 15 &  !(F_SRH_NAR_0==1) &   !inlist(SRH_NAR,.)
replace   F_SRH_NAR_1=9 if DEM_AGE<  15 &                        !inlist(SRH_NAR,.)

tab       F_SRH_NAR_0 F_SRH_NAR_1, missing

*tab         SRH_NAR  if SRH_NAR!=. , miss


/********************************************************      SRH_MAC    ********************************************/
* drop    F_SRH_MAC_0
generate  F_SRH_MAC_0=0
replace   F_SRH_MAC_0=0 
replace   F_SRH_MAC_0=1 if DEM_AGE>= 15 & SRH_DES==2   
tab       F_SRH_MAC_0, miss

* drop    F_SRH_MAC_1
generate  F_SRH_MAC_1=0
replace   F_SRH_MAC_1=0
replace   F_SRH_MAC_1=1 if DEM_AGE>= 15 &   F_SRH_MAC_0==1  &  !inrange(SRH_MAC,1,10)
replace   F_SRH_MAC_1=2 if DEM_AGE>= 15 &   F_SRH_MAC_0==1  &   inlist(SRH_MAC,.)
replace   F_SRH_MAC_1=3 if DEM_AGE>= 15 & !(F_SRH_MAC_0==1) &  !inlist(SRH_MAC,.)
replace   F_SRH_MAC_1=9 if DEM_AGE<  15                     &  !inlist(SRH_MAC,.)

tab       F_SRH_MAC_0 F_SRH_MAC_1, miss

*tab         SRH_MAC if SRH_MAC!=., miss



/********************************************************      SRH_MAC_other    ********************************************/
* drop    F_SRH_MAC_OTH_0
generate  F_SRH_MAC_OTH_0=0
replace   F_SRH_MAC_OTH_0=0 
replace   F_SRH_MAC_OTH_0=1 if DEM_AGE>= 15  & SRH_MAC==10  
tab       F_SRH_MAC_OTH_0, miss

* drop    F_SRH_MAC_other_1
generate  F_SRH_MAC_OTH_1=0
replace   F_SRH_MAC_OTH_1=0 
replace   F_SRH_MAC_OTH_1=2 if DEM_AGE>= 15 &   F_SRH_MAC_OTH_0==1  &  SRH_MAC_OTH==""
replace   F_SRH_MAC_OTH_1=3 if DEM_AGE>= 15 & !(F_SRH_MAC_OTH_0==1) &  SRH_MAC_OTH!=""
replace   F_SRH_MAC_OTH_1=9 if DEM_AGE<  15                         &  SRH_MAC_OTH!=""

tab       F_SRH_MAC_OTH_0 F_SRH_MAC_OTH_1, miss

*tab         SRH_MAC_other 


/********************************************************      DWO_3    ********************************************/
* drop    F_DWO_3_0
generate  F_DWO_3_0=0
replace   F_DWO_3_0=0
replace   F_DWO_3_0=1 if DEM_AGE>= 15 &  SRH_DES == 1 & DEM_NAT == 462
tab       F_DWO_3_0

* drop    F_DWO_3_1
generate  F_DWO_3_1=0
replace   F_DWO_3_1=0
replace   F_DWO_3_1=1 if DEM_AGE>= 15 &   F_DWO_3_0==1  & !inlist(DWO_3,1,2,3,4,5,6,7,8,9,10,97)
replace   F_DWO_3_1=2 if DEM_AGE>= 15 &   F_DWO_3_0==1  &  inlist(DWO_3,.)
replace   F_DWO_3_1=3 if DEM_AGE>= 15 & !(F_DWO_3_0==1) & !inlist(DWO_3,.)
replace   F_DWO_3_1=9 if DEM_AGE<  15 &                   !inlist(DWO_3,.)

tab       F_DWO_3_0 F_DWO_3_1, miss


/********************************************************      DWO_4    ********************************************/
* drop    F_DWO_4_0
generate  F_DWO_4_0=0
replace   F_DWO_4_0=0
replace   F_DWO_4_0=1 if DEM_AGE>= 15 &  SRH_DES == 1 & DEM_NAT == 462
tab       F_DWO_4_0

* drop    F_DWO_4_1
generate  F_DWO_4_1=0
replace   F_DWO_4_1=0
replace   F_DWO_4_1=1 if DEM_AGE>= 15 &   F_DWO_4_0==1  & !inlist(DWO_4,1,2,3,4,5)
replace   F_DWO_4_1=2 if DEM_AGE>= 15 &   F_DWO_4_0==1  &  inlist(DWO_4,.)
replace   F_DWO_4_1=3 if DEM_AGE>= 15 & !(F_DWO_4_0==1) & !inlist(DWO_4,.)
replace   F_DWO_4_1=9 if DEM_AGE<  15 &                   !inlist(DWO_4,.)

tab       F_DWO_4_0 F_DWO_4_1, miss

*tab         DWO_4  if DWO_4!=. , miss


/********************************************************      DWO_6    ********************************************/
* drop    F_DWO_6_0
generate  F_DWO_6_0=0
replace   F_DWO_6_0=0
replace   F_DWO_6_0=1 if DEM_AGE>= 15 &  SRH_DES == 1 & DEM_NAT == 462
tab       F_DWO_6_0

* drop    F_DWO_6_1
generate  F_DWO_6_1=0
replace   F_DWO_6_1=0
replace   F_DWO_6_1=1 if DEM_AGE>= 15 &   F_DWO_6_0==1  &       !(DWO_6>0)
replace   F_DWO_6_1=2 if DEM_AGE>= 15 &   F_DWO_6_0==1  &  inlist(DWO_6,.)
replace   F_DWO_6_1=3 if DEM_AGE>= 15 & !(F_DWO_6_0==1) & !inlist(DWO_6,.)
replace   F_DWO_6_1=9 if DEM_AGE<  15 &                   !inlist(DWO_6,.)

tab       F_DWO_6_0 F_DWO_6_1, miss


/********************************************************      DWO_7    ********************************************/
* drop    F_DWO_7_0
generate  F_DWO_7_0=0
replace   F_DWO_7_0=0
replace   F_DWO_7_0=1 if DEM_AGE>= 15 &  GLO_EMP==0
tab       F_DWO_7_0

* drop    F_DWO_7_1
generate  F_DWO_7_1=0
replace   F_DWO_7_1=0
replace   F_DWO_7_1=1 if DEM_AGE>= 15 &   F_DWO_7_0==1  & !inlist(DWO_7,1,2,3,4,5,6,7,8)
replace   F_DWO_7_1=2 if DEM_AGE>= 15 &   F_DWO_7_0==1  &  inlist(DWO_7,.)
replace   F_DWO_7_1=3 if DEM_AGE>= 15 & !(F_DWO_7_0==1) & !inlist(DWO_7,.)
replace   F_DWO_7_1=9 if DEM_AGE<  15 &                   !inlist(DWO_7,.)

tab       F_DWO_7_0 F_DWO_7_1, miss


*******************************************************************************************************************
*
*            TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_SRH_0 ///
F_SRH_JOB_0 ///
F_SRH_MTD_0 ///
F_SRH_MTD_OTH_0 ///
F_SRH_ACT_0 ///
F_SRH_OTH_0 ///
F_SRH_OTH_OTH_0 ///
F_SRH_DUR_0 ///
F_SRH_DES_0 ///
F_SRH_DWY_0 ///
F_SRH_DWY_OTH_0 ///
F_SRH_FTR_0 ///
F_SRH_FAN_0 ///
F_SRH_AVL_0 ///
F_SRH_AVN_0 ///
F_SRH_NAR_0 ///
F_SRH_MAC_0 ///
F_SRH_MAC_OTH_0 ///
F_DWO_3_0 ///
F_DWO_4_0 ///
F_DWO_6_0 ///
F_DWO_7_0 


foreach var of varlist $List_F_SRH_0 {
    tab `var' if `var'>0 , miss
}

global List_F_SRH_1 ///
F_SRH_JOB_1 ///
F_SRH_MTD_1 ///
F_SRH_MTD_OTH_1 ///
F_SRH_ACT_1 ///
F_SRH_OTH_1 ///
F_SRH_OTH_OTH_1 ///
F_SRH_DUR_1 ///
F_SRH_DES_1 ///
F_SRH_DWY_1 ///
F_SRH_DWY_OTH_1 ///
F_SRH_FTR_1 ///
F_SRH_FAN_1 ///
F_SRH_AVL_1 ///
F_SRH_AVN_1 ///
F_SRH_NAR_1 ///
F_SRH_MAC_1 ///
F_SRH_MAC_OTH_1 ///
F_DWO_3_1 ///
F_DWO_4_1 ///
F_DWO_6_1 ///
F_DWO_7_1 

foreach var of varlist $List_F_SRH_1 {
    tab `var' if `var'>0 , miss
}
