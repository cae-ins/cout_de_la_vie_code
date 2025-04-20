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
*
* MODULE AGF - AGRICULTURAL WORK
* 
*******************************************************************************************************************


/********************************************************      AGF_ANY__1        ********************************************/
* drop    F_AGF_ANY__1_0
generate  F_AGF_ANY__1_0=0
replace   F_AGF_ANY__1_0=0
replace   F_AGF_ANY__1_0=1 if DEM_AGE>= 15 & (ABS_JOB == 2 | ABS_WHY==1 | ABS_SEA==2 | ABS_PAY == 2)

* drop    F_AGF_ANY__1_1
generate  F_AGF_ANY__1_1=0
replace   F_AGF_ANY__1_1=0
replace   F_AGF_ANY__1_1=1 if DEM_AGE>= 15 &   F_AGF_ANY__1_0 == 1  & !inlist(AGF_ANY__1,0,1)
replace   F_AGF_ANY__1_1=2 if DEM_AGE>= 15 &   F_AGF_ANY__1_0 == 1  &  inlist(AGF_ANY__1,.)
replace   F_AGF_ANY__1_1=3 if DEM_AGE>= 15 & !(F_AGF_ANY__1_0 == 1) & !inlist(AGF_ANY__1,.)
replace   F_AGF_ANY__1_1=9 if DEM_AGE<  15                          & !inlist(AGF_ANY__1,.)

tab       F_AGF_ANY__1_0  F_AGF_ANY__1_1 , miss

/*
tab ABS_JOB if F_AGF_ANY__1_0==1 & F_AGF_ANY__1_1==2
tab ABS_WHY if F_AGF_ANY__1_0==1 & F_AGF_ANY__1_1==2, missing
tab ABS_SEA if F_AGF_ANY__1_0==1 & F_AGF_ANY__1_1==2, missing
tab ABS_PAY if F_AGF_ANY__1_0==1 & F_AGF_ANY__1_1==2, missing
*/

/********************************************************      AGF_ANY__2       ********************************************/
* drop    F_AGF_ANY__2_0
generate  F_AGF_ANY__2_0=0
replace   F_AGF_ANY__2_0=0
replace   F_AGF_ANY__2_0=1 if DEM_AGE>= 15 & (ABS_JOB == 2 | ABS_WHY==1 | ABS_SEA==2 | ABS_PAY == 2)

* drop    F_AGF_ANY__2_1
generate  F_AGF_ANY__2_1=0
replace   F_AGF_ANY__2_1=0
replace   F_AGF_ANY__2_1=1 if DEM_AGE>= 15 &   F_AGF_ANY__2_0 ==1  & !inlist(AGF_ANY__2,0,1)
replace   F_AGF_ANY__2_1=2 if DEM_AGE>= 15 &   F_AGF_ANY__2_0 ==1  &  inlist(AGF_ANY__2,.)
replace   F_AGF_ANY__2_1=3 if DEM_AGE>= 15 & !(F_AGF_ANY__2_0 ==1) & !inlist(AGF_ANY__2,.)
replace   F_AGF_ANY__2_1=9 if DEM_AGE<  15 &                         !inlist(AGF_ANY__2,.)

tab         AGF_ANY__2 , miss

tab       F_AGF_ANY__2_0  F_AGF_ANY__2_1 , miss


/********************************************************      AGF_ANY__3        ********************************************/
* drop    F_AGF_ANY__3_0
generate  F_AGF_ANY__3_0=0
replace   F_AGF_ANY__3_0=0
replace   F_AGF_ANY__3_0=1 if DEM_AGE>= 15 & (ABS_JOB == 2 | ABS_WHY==1 | ABS_SEA==2 | ABS_PAY == 2)

* drop    F_AGF_ANY__3_1
generate  F_AGF_ANY__3_1=0
replace   F_AGF_ANY__3_1=0
replace   F_AGF_ANY__3_1=1 if DEM_AGE>= 15 &   F_AGF_ANY__3_0 ==1  & !inlist(AGF_ANY__3,0,1)
replace   F_AGF_ANY__3_1=2 if DEM_AGE>= 15 &   F_AGF_ANY__3_0 ==1  &  inlist(AGF_ANY__3,.)
replace   F_AGF_ANY__3_1=3 if DEM_AGE>= 15 & !(F_AGF_ANY__3_0 ==1) & !inlist(AGF_ANY__3,.)
replace   F_AGF_ANY__3_1=9 if DEM_AGE<  15 &                         !inlist(AGF_ANY__3,.)

tab         AGF_ANY__3 , miss

tab       F_AGF_ANY__3_0  F_AGF_ANY__3_1 , miss


/********************************************************      AGF_ANY__4        ********************************************/
* drop    F_AGF_ANY__4_0
generate  F_AGF_ANY__4_0=0
replace   F_AGF_ANY__4_0=0
replace   F_AGF_ANY__4_0=1 if DEM_AGE>= 15 & (ABS_JOB == 2 | ABS_WHY==1 | ABS_SEA==2 | ABS_PAY == 2)

* drop    F_AGF_ANY__4_1
generate  F_AGF_ANY__4_1=0
replace   F_AGF_ANY__4_1=0
replace   F_AGF_ANY__4_1=1 if DEM_AGE>= 15 &   F_AGF_ANY__4_0 ==1  & !inlist(AGF_ANY__4,0,1)
replace   F_AGF_ANY__4_1=2 if DEM_AGE>= 15 &   F_AGF_ANY__4_0 ==1  &  inlist(AGF_ANY__4,.)
replace   F_AGF_ANY__4_1=3 if DEM_AGE>= 15 & !(F_AGF_ANY__4_0 ==1) & !inlist(AGF_ANY__4,.)
replace   F_AGF_ANY__4_1=9 if DEM_AGE<  15 &                         !inlist(AGF_ANY__4,.)

tab         AGF_ANY__4 , miss

tab       F_AGF_ANY__4_0  F_AGF_ANY__4_1 , miss




/********************************************************      AGF_ANY__5        ********************************************/
* drop    F_AGF_ANY__5_0
generate  F_AGF_ANY__5_0=0
replace   F_AGF_ANY__5_0=0
replace   F_AGF_ANY__5_0=1 if DEM_AGE>= 15 & (ABS_JOB == 2 | ABS_WHY==1 | ABS_SEA==2 | ABS_PAY == 2)

* drop    F_AGF_ANY__5_1
generate  F_AGF_ANY__5_1=0
replace   F_AGF_ANY__5_1=0
replace   F_AGF_ANY__5_1=1 if DEM_AGE>= 15 &   F_AGF_ANY__5_0 ==1  & !inlist(AGF_ANY__5,0,1)
replace   F_AGF_ANY__5_1=2 if DEM_AGE>= 15 &   F_AGF_ANY__5_0 ==1  &  inlist(AGF_ANY__5,.)
replace   F_AGF_ANY__5_1=3 if DEM_AGE>= 15 & !(F_AGF_ANY__5_0 ==1) & !inlist(AGF_ANY__5,.)
replace   F_AGF_ANY__5_1=9 if DEM_AGE<  15 &                         !inlist(AGF_ANY__5,.)

tab         AGF_ANY__5 , miss

tab       F_AGF_ANY__5_0  F_AGF_ANY__5_1 , miss




/********************************************************      AGF_CHK        ********************************************/


/********************************************************      AGF_CHK__1        ********************************************/
* drop    F_AGF_CHK__1_0
generate  F_AGF_CHK__1_0=0
replace   F_AGF_CHK__1_0=0
replace   F_AGF_CHK__1_0=1 if  DEM_AGE>= 15 & (ATW_PFT == 1 | ATW_FAM == 1 | inlist(ABS_WHY,3,4,5,6) | ABS_DUR == 1 | ABS_PAY == 1 | ABS_SEA == 1)

* drop    F_AGF_CHK__1_1
generate  F_AGF_CHK__1_1=0
replace   F_AGF_CHK__1_1=0
replace   F_AGF_CHK__1_1=1 if DEM_AGE>= 15 &   F_AGF_CHK__1_0 == 1  & !inlist(AGF_CHK__1,0,1)
replace   F_AGF_CHK__1_1=2 if DEM_AGE>= 15 &   F_AGF_CHK__1_0 == 1  &  inlist(AGF_CHK__1,.)
replace   F_AGF_CHK__1_1=3 if DEM_AGE>= 15 & !(F_AGF_CHK__1_0 == 1) & !inlist(AGF_CHK__1,.)
replace   F_AGF_CHK__1_1=9 if DEM_AGE<  15                          & !inlist(AGF_CHK__1,.)

tab         AGF_CHK__1 , miss

tab       F_AGF_CHK__1_0  F_AGF_CHK__1_1 , miss


/********************************************************      AGF_CHK__2       ********************************************/
* drop    F_AGF_CHK__2_0
generate  F_AGF_CHK__2_0=0
replace   F_AGF_CHK__2_0=0
replace   F_AGF_CHK__2_0=1 if  DEM_AGE>= 15 & (ATW_PFT == 1 | ATW_FAM == 1 | inlist(ABS_WHY,3,4,5,6) | ABS_DUR == 1 | ABS_PAY == 1 | ABS_SEA == 1)

* drop    F_AGF_CHK__2_1
generate  F_AGF_CHK__2_1=0
replace   F_AGF_CHK__2_1=0
replace   F_AGF_CHK__2_1=1 if DEM_AGE>= 15 &   F_AGF_CHK__2_0 ==1  & !inlist(AGF_CHK__2,0,1)
replace   F_AGF_CHK__2_1=2 if DEM_AGE>= 15 &   F_AGF_CHK__2_0 ==1  &  inlist(AGF_CHK__2,.)
replace   F_AGF_CHK__2_1=3 if DEM_AGE>= 15 & !(F_AGF_CHK__2_0 ==1) & !inlist(AGF_CHK__2,.)
replace   F_AGF_CHK__2_1=9 if DEM_AGE<  15 &                         !inlist(AGF_CHK__2,.)

tab         AGF_CHK__2 , miss

tab       F_AGF_CHK__2_0  F_AGF_CHK__2_1 , miss


/********************************************************      AGF_CHK__3        ********************************************/
* drop    F_AGF_CHK__3_0
generate  F_AGF_CHK__3_0=0
replace   F_AGF_CHK__3_0=0
replace   F_AGF_CHK__3_0=1 if  DEM_AGE>= 15 & (ATW_PFT == 1 | ATW_FAM == 1 | inlist(ABS_WHY,3,4,5,6) | ABS_DUR == 1 | ABS_PAY == 1 | ABS_SEA == 1)

* drop    F_AGF_CHK__3_1
generate  F_AGF_CHK__3_1=0
replace   F_AGF_CHK__3_1=0
replace   F_AGF_CHK__3_1=1 if DEM_AGE>= 15 &   F_AGF_CHK__3_0 ==1  & !inlist(AGF_CHK__3,0,1)
replace   F_AGF_CHK__3_1=2 if DEM_AGE>= 15 &   F_AGF_CHK__3_0 ==1  &  inlist(AGF_CHK__3,.)
replace   F_AGF_CHK__3_1=3 if DEM_AGE>= 15 & !(F_AGF_CHK__3_0 ==1) & !inlist(AGF_CHK__3,.)
replace   F_AGF_CHK__3_1=9 if DEM_AGE<  15 &                         !inlist(AGF_CHK__3,.)

tab         AGF_CHK__3 , miss

tab       F_AGF_CHK__3_0  F_AGF_CHK__3_1 , miss


/********************************************************      AGF_CHK__4        ********************************************/
* drop    F_AGF_CHK__4_0
generate  F_AGF_CHK__4_0=0
replace   F_AGF_CHK__4_0=0
replace   F_AGF_CHK__4_0=1 if  DEM_AGE>= 15 & (ATW_PFT == 1 | ATW_FAM == 1 | inlist(ABS_WHY,3,4,5,6) | ABS_DUR == 1 | ABS_PAY == 1 | ABS_SEA == 1)

* drop    F_AGF_CHK__4_1
generate  F_AGF_CHK__4_1=0
replace   F_AGF_CHK__4_1=0
replace   F_AGF_CHK__4_1=1 if DEM_AGE>= 15 &   F_AGF_CHK__4_0 ==1  & !inlist(AGF_CHK__4,0,1)
replace   F_AGF_CHK__4_1=2 if DEM_AGE>= 15 &   F_AGF_CHK__4_0 ==1  &  inlist(AGF_CHK__4,.)
replace   F_AGF_CHK__4_1=3 if DEM_AGE>= 15 & !(F_AGF_CHK__4_0 ==1) & !inlist(AGF_CHK__4,.)
replace   F_AGF_CHK__4_1=9 if DEM_AGE<  15 &                         !inlist(AGF_CHK__4,.)

tab         AGF_CHK__4 , miss

tab       F_AGF_CHK__4_0  F_AGF_CHK__4_1 , miss



/********************************************************      AGF_CHK__5        ********************************************/
* drop    F_AGF_CHK__5_0
generate  F_AGF_CHK__5_0=0
replace   F_AGF_CHK__5_0=0
replace   F_AGF_CHK__5_0=1 if  DEM_AGE>= 15 & (ATW_PFT == 1 | ATW_FAM == 1 | inlist(ABS_WHY,3,4,5,6) | ABS_DUR == 1 | ABS_PAY == 1 | ABS_SEA == 1)

* drop    F_AGF_CHK__5_1
generate  F_AGF_CHK__5_1=0
replace   F_AGF_CHK__5_1=0
replace   F_AGF_CHK__5_1=1 if DEM_AGE>= 15 &   F_AGF_CHK__5_0 ==1  & !inlist(AGF_CHK__5,0,1)
replace   F_AGF_CHK__5_1=2 if DEM_AGE>= 15 &   F_AGF_CHK__5_0 ==1  &  inlist(AGF_CHK__5,.)
replace   F_AGF_CHK__5_1=3 if DEM_AGE>= 15 & !(F_AGF_CHK__5_0 ==1) & !inlist(AGF_CHK__5,.)
replace   F_AGF_CHK__5_1=9 if DEM_AGE<  15 &                         !inlist(AGF_CHK__5,.)

tab         AGF_CHK__5 , miss

tab       F_AGF_CHK__5_0  F_AGF_CHK__5_1 , miss




/********************************************************      AGF_MKT    ********************************************/
* drop    	F_AGF_MKT_0
generate  	F_AGF_MKT_0=0
replace   	F_AGF_MKT_0=1 if DEM_AGE>= 15 & (AGF_CHK__1==1 | AGF_CHK__2==1 | AGF_CHK__3==1 | AGF_CHK__4==1 | AGF_ANY__1==1 | AGF_ANY__2==1 | AGF_ANY__3==1 | AGF_ANY__4==1 ) 
    
* drop    	F_AGF_MKT_1
generate  	F_AGF_MKT_1=0
replace   	F_AGF_MKT_1=1 if DEM_AGE>= 15 &   F_AGF_MKT_0==1  & !inlist(AGF_MKT,1,2,3,4,5) 
replace   	F_AGF_MKT_1=2 if DEM_AGE>= 15 &   F_AGF_MKT_0==1  &  inlist(AGF_MKT,0,.)
replace   	F_AGF_MKT_1=3 if DEM_AGE>= 15 & !(F_AGF_MKT_0==1) & !inlist(AGF_MKT,0,.)
replace  	F_AGF_MKT_1=9 if DEM_AGE<  15                     & !inlist(AGF_MKT,0,.)

tab           AGF_MKT, miss nolabel

tab      	F_AGF_MKT_0 F_AGF_MKT_1, miss


/********************************************************      AGF_HIS    ********************************************/
* drop    	F_AGF_HIS_0
generate  	F_AGF_HIS_0=0
replace   	F_AGF_HIS_0=1 if DEM_AGE>= 15 & AGF_MKT==5

* drop    	F_AGF_HIS_1
generate  	F_AGF_HIS_1=0
replace   	F_AGF_HIS_1=1 if DEM_AGE>= 15 &   F_AGF_HIS_0==1  & !inlist(AGF_HIS,1,2,3,4)
replace   	F_AGF_HIS_1=2 if DEM_AGE>= 15 &   F_AGF_HIS_0==1  &  inlist(AGF_HIS,0,.)
replace   	F_AGF_HIS_1=3 if DEM_AGE>= 15 & !(F_AGF_HIS_0==1) & !inlist(AGF_HIS,0,.)
replace  	F_AGF_HIS_1=9 if DEM_AGE<  15                     & !inlist(AGF_HIS,0,.)

tab      	F_AGF_HIS_0 F_AGF_HIS_1, miss

/********************************************************      AGF_HIR    ********************************************/
* drop    	F_AGF_HIR_0
generate  	F_AGF_HIR_0=0
replace   	F_AGF_HIR_0=1 if DEM_AGE>= 15 & ( inlist(AGF_MKT,3,4) | inlist(AGF_HIS,3,4) ) 

* drop    	F_AGF_HIR_1
generate  	F_AGF_HIR_1=0
replace   	F_AGF_HIR_1=1 if DEM_AGE>= 15 &   F_AGF_HIR_0==1  & !inlist(AGF_HIR,1,2)
replace   	F_AGF_HIR_1=2 if DEM_AGE>= 15 &   F_AGF_HIR_0==1  &  inlist(AGF_HIR,.)
replace   	F_AGF_HIR_1=3 if DEM_AGE>= 15 & !(F_AGF_HIR_0==1) & !inlist(AGF_HIR,.)
replace  	F_AGF_HIR_1=9 if DEM_AGE<  15                     & !inlist(AGF_HIR,.)

tab      	  AGF_HIR, miss

tab      	F_AGF_HIR_0 F_AGF_HIR_1, miss

/********************************************************  AGF_GDS   ********************************************/
* drop    	F_AGF_GDS_0
generate  	F_AGF_GDS_0=0
replace   	F_AGF_GDS_0=1 if DEM_AGE>= 15 & AGF_HIR==2

* drop    	F_AGF_GDS_1
generate  	F_AGF_GDS_1=0
replace  	F_AGF_GDS_1=0
replace   	F_AGF_GDS_1=2 if DEM_AGE>= 15 &   F_AGF_GDS_0==1  &  (AGF_GDS=="")
replace   	F_AGF_GDS_1=3 if DEM_AGE>= 15 & !(F_AGF_GDS_0==1) & !(AGF_GDS=="")
replace  	F_AGF_GDS_1=9 if DEM_AGE<  15                     & !(AGF_GDS=="")

tab      	  AGF_GDS  , miss

tab      	F_AGF_GDS_0 F_AGF_GDS_1, miss

/*******************************************************       AGF_DYS    ********************************************/
* drop    	F_AGF_DYS_0
generate  	F_AGF_DYS_0=0
replace   	F_AGF_DYS_0=1 if DEM_AGE>= 15  & AGF_HIR==2

* drop    	F_AGF_DYS_1
generate  	F_AGF_DYS_1=0
replace   	F_AGF_DYS_1=0
replace   	F_AGF_DYS_1=1 if DEM_AGE>= 15 &    F_AGF_DYS_0==1    & !inlist(AGF_DYS,0,1,2,3,4,5,6,7,997)
replace   	F_AGF_DYS_1=2 if DEM_AGE>= 15 &    F_AGF_DYS_0==1    &  inlist(AGF_DYS,.)
replace   	F_AGF_DYS_1=3 if DEM_AGE>= 15 &  !(F_AGF_DYS_0==1)   & !inlist(AGF_DYS,.)
replace  	F_AGF_DYS_1=9 if DEM_AGE<  15                        & !inlist(AGF_DYS,.)

tab      	AGF_DYS AGF_HIR, miss

tab      	F_AGF_DYS_0 F_AGF_DYS_1, miss

/*******************************************************       AGF_HRSD    ********************************************/


* drop    	F_AGF_HRSD_0
generate  	F_AGF_HRSD_0=0
replace   	F_AGF_HRSD_0=0 
replace   	F_AGF_HRSD_0=1 if DEM_AGE>= 15 & AGF_HIR==2 & AGF_DYS != 997

* drop    	F_AGF_HRSD_1
generate  	F_AGF_HRSD_1=0
replace   	F_AGF_HRSD_1=0
replace   	F_AGF_HRSD_1=1 if DEM_AGE>= 15 &    F_AGF_HRSD_0==1  & !(inrange(AGF_HRSD,0,18) | AGF_HRSD == 997 )
replace   	F_AGF_HRSD_1=2 if DEM_AGE>= 15 &    F_AGF_HRSD_0==1  &   inlist(AGF_HRSD,.)
replace   	F_AGF_HRSD_1=3 if DEM_AGE>= 15 &  !(F_AGF_HRSD_0==1) & !inlist(AGF_HRSD,0,.)
replace  	F_AGF_HRSD_1=9 if DEM_AGE<  15                       & !inlist(AGF_HRSD,0,.)

tab      	AGF_HRSD AGF_DYS, miss


tab      	F_AGF_HRSD_0 F_AGF_HRSD_1, miss


/*******************************************************       AGF_HRSW_REP    ********************************************/
* drop    	F_AGF_HRSW_REP_0
generate  	F_AGF_HRSW_REP_0=0
replace   	F_AGF_HRSW_REP_0=1 if DEM_AGE>= 15 & AGF_HIR==2 & ( AGF_DYS==997 |  AGF_HRSD==997) 

* drop    	F_AGF_HRSW_REP_1
generate  	F_AGF_HRSW_REP_1=0
replace   	F_AGF_HRSW_REP_1=0
replace   	F_AGF_HRSW_REP_1=1 if DEM_AGE>= 15 &    F_AGF_HRSW_REP_0==1  & !(inrange(AGF_HRSW_REP,0.5,126) | AGF_HRSW_REP ==997 )
replace   	F_AGF_HRSW_REP_1=2 if DEM_AGE>= 15 &    F_AGF_HRSW_REP_0==1  &  inlist(AGF_HRSW_REP,.)
replace   	F_AGF_HRSW_REP_1=3 if DEM_AGE>= 15 &  !(F_AGF_HRSW_REP_0==1) & !inlist(AGF_HRSW_REP,.)
replace  	F_AGF_HRSW_REP_1=9 if DEM_AGE<  15                           & !inlist(AGF_HRSW_REP,.)

tab      	F_AGF_HRSW_REP_0 F_AGF_HRSW_REP_1, miss


/*******************************************************       GLO_AGF_EMP   ********************************************/

*******************************************************************************************************************
*
*            TABULATION OF EDITING FLAGS   
* 
*******************************************************************************************************************

global List_F_AGF_0 ///
F_AGF_CHK__1_0 ///
F_AGF_CHK__2_0 ///
F_AGF_CHK__3_0 ///
F_AGF_CHK__4_0 ///
F_AGF_CHK__5_0 ///
F_AGF_ANY__1_0 /// 
F_AGF_ANY__2_0 ///
F_AGF_ANY__3_0 ///
F_AGF_ANY__4_0 ///
F_AGF_ANY__5_0 ///
F_AGF_MKT_0 ///
F_AGF_HIS_0 ///
F_AGF_HIR_0 ///
F_AGF_GDS_0 ///
F_AGF_DYS_0 ///
F_AGF_HRSD_0 ///
F_AGF_HRSW_REP_0 ///


foreach var of varlist $List_F_AGF_0 {
    tab `var' if `var'>0 , miss
}

global List_F_AGF_1 ///
F_AGF_CHK__1_1 ///
F_AGF_CHK__2_1 ///
F_AGF_CHK__3_1 ///
F_AGF_CHK__4_1 ///
F_AGF_CHK__5_1 ///
F_AGF_ANY__1_1 /// 
F_AGF_ANY__2_1 ///
F_AGF_ANY__3_1 ///
F_AGF_ANY__4_1 ///
F_AGF_ANY__5_1 ///
F_AGF_MKT_1 ///
F_AGF_HIS_1 ///
F_AGF_HIR_1 ///
F_AGF_GDS_1 ///
F_AGF_DYS_1 ///
F_AGF_HRSD_1 ///
F_AGF_HRSW_REP_1 ///


foreach var of varlist $List_F_AGF_1 {
    tab `var' if `var'>0 , miss
}
