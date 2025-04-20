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
***                                            CHECK ON THE SJB - CHARACTERISTICS OF SECOND JOB                 ***
***                                                                                                             *** 
*******************************************************************************************************************
*******************************************************************************************************************


/***************************************************     SJJ_OCC_TLE     *****************************************/
* drop    	F_SJJ_OCC_TLE_0
generate  	F_SJJ_OCC_TLE_0=0
replace   	F_SJJ_OCC_TLE_0=0
replace   	F_SJJ_OCC_TLE_0=1 if DEM_AGE>= 15 &  (MJJ_MULT==2)

* drop    	F_SJJ_OCC_TLE_1
generate  	F_SJJ_OCC_TLE_1=0
replace   	F_SJJ_OCC_TLE_1=0
replace   	F_SJJ_OCC_TLE_1=2 if DEM_AGE>=15 &    F_SJJ_OCC_TLE_0==1  & SJJ_OCC_TLE==""
replace   	F_SJJ_OCC_TLE_1=3 if DEM_AGE>=15 &  !(F_SJJ_OCC_TLE_0==1) & SJJ_OCC_TLE!=""
replace  	F_SJJ_OCC_TLE_1=9 if DEM_AGE< 15                          & SJJ_OCC_TLE!=""

tab      	F_SJJ_OCC_TLE_0 F_SJJ_OCC_TLE_1, miss


/***************************************************     SJJ_OCC_MTD     *****************************************/
* drop    	F_SJJ_OCC_MTD_0
generate  	F_SJJ_OCC_MTD_0=0

replace   	F_SJJ_OCC_MTD_0=1 if DEM_AGE>= 15 &  MJJ_MULT==2
tab      	F_SJJ_OCC_MTD_0

* drop    	F_SJJ_OCC_MTD_1
generate  	F_SJJ_OCC_MTD_1=0
replace   	F_SJJ_OCC_MTD_1=2 if DEM_AGE>= 15 &    F_SJJ_OCC_MTD_0==1  &  SJJ_OCC_MTD==""
replace   	F_SJJ_OCC_MTD_1=3 if DEM_AGE>= 15 &  !(F_SJJ_OCC_MTD_0==1) &  SJJ_OCC_MTD!=""
replace  	F_SJJ_OCC_MTD_1=9 if DEM_AGE<  15 &                           SJJ_OCC_MTD!=""

tab      	F_SJJ_OCC_MTD_0 F_SJJ_OCC_MTD_1 , miss


/***************************************************     SJJ_IND_MAC     *****************************************/
* drop    	F_SJJ_IND_MAC_0
generate  	F_SJJ_IND_MAC_0=0
replace   	F_SJJ_IND_MAC_0=1 if DEM_AGE>= 15 &  ( MJJ_MULT==2)
tab      	F_SJJ_IND_MAC_0

* drop    	F_SJJ_IND_MAC_1
generate  	F_SJJ_IND_MAC_1=0
replace   	F_SJJ_IND_MAC_1=2 if DEM_AGE>= 15 &  ( F_SJJ_IND_MAC_0==1) &  SJJ_IND_MAC==""
replace   	F_SJJ_IND_MAC_1=3 if DEM_AGE>= 15 & !( F_SJJ_IND_MAC_0==1) &  SJJ_IND_MAC!=""
replace  	F_SJJ_IND_MAC_1=9 if DEM_AGE<  15 &                           SJJ_IND_MAC!=""

tab      	F_SJJ_IND_MAC_0 F_SJJ_IND_MAC_1, miss  


/***************************************************     SJJ_EMP_REL     *****************************************/
 *drop    	F_SJJ_EMP_REL_0
generate  	F_SJJ_EMP_REL_0=0
replace   	F_SJJ_EMP_REL_0=1 if DEM_AGE>= 15 &  ( MJJ_MULT==2)
tab      	F_SJJ_EMP_REL_0, miss

* drop    	F_SJJ_EMP_REL_1
generate  	F_SJJ_EMP_REL_1=0
replace   	F_SJJ_EMP_REL_1=1 if DEM_AGE>= 15 &   ( F_SJJ_EMP_REL_0==1) & !inlist(SJJ_EMP_REL,1,2,3,4,5)
replace   	F_SJJ_EMP_REL_1=2 if DEM_AGE>= 15 &   ( F_SJJ_EMP_REL_0==1) &  inlist(SJJ_EMP_REL,0,.)
replace   	F_SJJ_EMP_REL_1=3 if DEM_AGE>= 15 &  !( F_SJJ_EMP_REL_0==1) & !inlist(SJJ_EMP_REL,0,.)
replace  	F_SJJ_EMP_REL_1=9 if DEM_AGE<  15 &                           !inlist(SJJ_EMP_REL,0,.)

tab      	F_SJJ_EMP_REL_0 F_SJJ_EMP_REL_1, miss

/***************************************************     SJJ_HIRES     *****************************************/
* drop    	F_SJJ_HIRES_0
generate  	F_SJJ_HIRES_0=0
replace   	F_SJJ_HIRES_0=1 if DEM_AGE>= 15 &   ( MJJ_MULT==2 &  SJJ_EMP_REL==2) 
tab      	F_SJJ_HIRES_0, miss

* drop    	F_SJJ_HIRES_1
generate  	F_SJJ_HIRES_1=0
replace   	F_SJJ_HIRES_1=1 if DEM_AGE>= 15 &   (F_SJJ_HIRES_0==1)  & !inlist(SJJ_HIRES,1,2)
replace   	F_SJJ_HIRES_1=2 if DEM_AGE>= 15 &   (F_SJJ_HIRES_0==1)  &  inlist(SJJ_HIRES,0,.)
replace   	F_SJJ_HIRES_1=3 if DEM_AGE>= 15 &  !(F_SJJ_HIRES_0==1)  & !inlist(SJJ_HIRES,0,.)
replace  	F_SJJ_HIRES_1=9 if DEM_AGE<  15 &                         !inlist(SJJ_HIRES,0,.)

tab      	F_SJJ_HIRES_0 F_SJJ_HIRES_1, miss


/***************************************************     SIS_REGI     *****************************************/

generate  	F_SJJ_REGI_0=0
replace   	F_SJJ_REGI_0=0
replace   	F_SJJ_REGI_0=1 if DEM_AGE>= 15 &  MJJ_MULT==2 & inlist(SJJ_EMP_REL,2,3)
tab      	F_SJJ_REGI_0, miss

* drop    	F_SJJ_REGI_1
generate  	F_SJJ_REGI_1=0
replace   	F_SJJ_REGI_1=0
replace   	F_SJJ_REGI_1=1 if DEM_AGE>= 15 &   F_SJJ_REGI_0==1  & !inlist(SJJ_REGI,1,2,97)
replace   	F_SJJ_REGI_1=2 if DEM_AGE>= 15 &   F_SJJ_REGI_0==1  &  inlist(SJJ_REGI,0,.)
replace   	F_SJJ_REGI_1=3 if DEM_AGE>= 15 & !(F_SJJ_REGI_0==1) & !inlist(SJJ_REGI,0,.)
replace  	F_SJJ_REGI_1=9 if DEM_AGE<  15 &                      !inlist(SJJ_REGI,0,.)

tab      	F_SJJ_REGI_0  F_SJJ_REGI_1, miss


/***************************************************     SJD_REM_TYP__1     *****************************************/

* drop    	F_SJD_REM_TYP__1_0
generate  	F_SJD_REM_TYP__1_0=0
replace   	F_SJD_REM_TYP__1_0=0
replace   	F_SJD_REM_TYP__1_0=1 if DEM_AGE>= 15 &   (MJJ_MULT==2 & inlist(SJJ_EMP_REL,1,3,4,5 )) 
tab      	F_SJD_REM_TYP__1_0, miss


* drop    	F_SJD_REM_TYP__1_1
generate  	F_SJD_REM_TYP__1_1=0
replace   	F_SJD_REM_TYP__1_1=0
replace   	F_SJD_REM_TYP__1_1=1 if DEM_AGE>= 15 &    F_SJD_REM_TYP__1_0==1  & !inlist(SJD_REM_TYP__1,0,1)
replace   	F_SJD_REM_TYP__1_1=2 if DEM_AGE>= 15 &    F_SJD_REM_TYP__1_0==1  &  inlist(SJD_REM_TYP__1,.)
replace   	F_SJD_REM_TYP__1_1=3 if DEM_AGE>= 15 &    F_SJD_REM_TYP__1_0!=1  & !inlist(SJD_REM_TYP__1,.)
replace  	F_SJD_REM_TYP__1_1=9 if DEM_AGE<  15 &                             !inlist(SJD_REM_TYP__1,.)

tab      	F_SJD_REM_TYP__1_0 F_SJD_REM_TYP__1_1, miss

/***************************************************     SJD_REM_TYP__2     *****************************************/
/***************************************************     SJD_REM_TYP__2     *****************************************/

* drop    	F_SJD_REM_TYP__2_0
generate  	F_SJD_REM_TYP__2_0=0
replace   	F_SJD_REM_TYP__2_0=0
replace   	F_SJD_REM_TYP__2_0=1 if DEM_AGE>= 15 &   (MJJ_MULT==2 & inlist(SJJ_EMP_REL,1,3,4,5 )) 
tab      	F_SJD_REM_TYP__2_0, miss


* drop    	F_SJD_REM_TYP__2_1
generate  	F_SJD_REM_TYP__2_1=0
replace   	F_SJD_REM_TYP__2_1=0
replace   	F_SJD_REM_TYP__2_1=1 if DEM_AGE>= 15 &    F_SJD_REM_TYP__2_0==1  & !inlist(SJD_REM_TYP__2,0,1)
replace   	F_SJD_REM_TYP__2_1=2 if DEM_AGE>= 15 &    F_SJD_REM_TYP__2_0==1  &  inlist(SJD_REM_TYP__2,.)
replace   	F_SJD_REM_TYP__2_1=3 if DEM_AGE>= 15 &    F_SJD_REM_TYP__2_0!=1  & !inlist(SJD_REM_TYP__2,.)
replace  	F_SJD_REM_TYP__2_1=9 if DEM_AGE<  15 &                             !inlist(SJD_REM_TYP__2,.)

tab      	F_SJD_REM_TYP__2_0 F_SJD_REM_TYP__2_1, miss

/***************************************************     SJD_REM_TYP__3     *****************************************/

* drop    	F_SJD_REM_TYP__3_0
generate  	F_SJD_REM_TYP__3_0=0
replace   	F_SJD_REM_TYP__3_0=0
replace   	F_SJD_REM_TYP__3_0=1 if DEM_AGE>= 15 &   (MJJ_MULT==2 & inlist(SJJ_EMP_REL,1,3,4,5 )) 
tab      	F_SJD_REM_TYP__3_0, miss


* drop    	F_SJD_REM_TYP__3_1
generate  	F_SJD_REM_TYP__3_1=0
replace   	F_SJD_REM_TYP__3_1=0
replace   	F_SJD_REM_TYP__3_1=1 if DEM_AGE>= 15 &     F_SJD_REM_TYP__3_0==1  & !inlist(SJD_REM_TYP__3,0,1)
replace   	F_SJD_REM_TYP__3_1=2 if DEM_AGE>= 15 &     F_SJD_REM_TYP__3_0==1  &  inlist(SJD_REM_TYP__3,.)
replace   	F_SJD_REM_TYP__3_1=3 if DEM_AGE>= 15 &     F_SJD_REM_TYP__3_0!=1  & !inlist(SJD_REM_TYP__3,.)
replace  	F_SJD_REM_TYP__3_1=9 if DEM_AGE<  15 &                              !inlist(SJD_REM_TYP__3,.)

tab      	F_SJD_REM_TYP__3_0 F_SJD_REM_TYP__3_1, miss


/***************************************************     SJD_REM_TYP__4     *****************************************/

* drop    	F_SJD_REM_TYP__4_0
generate  	F_SJD_REM_TYP__4_0=0
replace   	F_SJD_REM_TYP__4_0=0
replace   	F_SJD_REM_TYP__4_0=1 if DEM_AGE>= 15 &   (MJJ_MULT==2 & inlist(SJJ_EMP_REL,1,3,4,5 )) 
tab      	F_SJD_REM_TYP__4_0, miss


* drop    	F_SJD_REM_TYP__4_1
generate  	F_SJD_REM_TYP__4_1=0
replace   	F_SJD_REM_TYP__4_1=0
replace   	F_SJD_REM_TYP__4_1=1 if DEM_AGE>= 15 &     F_SJD_REM_TYP__4_0==1  & !inlist(SJD_REM_TYP__4,0,1)
replace   	F_SJD_REM_TYP__4_1=2 if DEM_AGE>= 15 &     F_SJD_REM_TYP__4_0==1  &  inlist(SJD_REM_TYP__4,.)
replace   	F_SJD_REM_TYP__4_1=3 if DEM_AGE>= 15 &     F_SJD_REM_TYP__4_0!=1  & !inlist(SJD_REM_TYP__4,.)
replace  	F_SJD_REM_TYP__4_1=9 if DEM_AGE<  15 &                              !inlist(SJD_REM_TYP__4,.)

tab      	F_SJD_REM_TYP__4_0 F_SJD_REM_TYP__4_1, miss

/***************************************************     SJD_REM_TYP__5     *****************************************/

* drop    	F_SJD_REM_TYP__5_0
generate  	F_SJD_REM_TYP__5_0=0
replace   	F_SJD_REM_TYP__5_0=0
replace   	F_SJD_REM_TYP__5_0=1 if DEM_AGE>= 15 &   (MJJ_MULT==2 & inlist(SJJ_EMP_REL,1,3,4,5 )) 
tab      	F_SJD_REM_TYP__5_0, miss


* drop    	F_SJD_REM_TYP__5_1
generate  	F_SJD_REM_TYP__5_1=0
replace   	F_SJD_REM_TYP__5_1=0
replace   	F_SJD_REM_TYP__5_1=1 if DEM_AGE>= 15 &     F_SJD_REM_TYP__5_0==1  & !inlist(SJD_REM_TYP__5,0,1)
replace   	F_SJD_REM_TYP__5_1=2 if DEM_AGE>= 15 &     F_SJD_REM_TYP__5_0==1  &  inlist(SJD_REM_TYP__5,.)
replace   	F_SJD_REM_TYP__5_1=3 if DEM_AGE>= 15 &     F_SJD_REM_TYP__5_0!=1  & !inlist(SJD_REM_TYP__5,.)
replace  	F_SJD_REM_TYP__5_1=9 if DEM_AGE<  15 &                               !inlist(SJD_REM_TYP__5,.)

tab      	F_SJD_REM_TYP__5_0 F_SJD_REM_TYP__5_1, miss


/***************************************************     SJD_REM_TYP__6     *****************************************/

* drop    	F_SJD_REM_TYP__6_0
generate  	F_SJD_REM_TYP__6_0=0
replace   	F_SJD_REM_TYP__6_0=0
replace   	F_SJD_REM_TYP__6_0=1 if DEM_AGE>= 15 &   (MJJ_MULT==2 &  inlist(SJJ_EMP_REL,1,3,4,5 )) 
tab      	F_SJD_REM_TYP__6_0, miss


* drop    	F_SJD_REM_TYP__6_1
generate  	F_SJD_REM_TYP__6_1=0
replace   	F_SJD_REM_TYP__6_1=0
replace   	F_SJD_REM_TYP__6_1=1 if DEM_AGE>= 15 &     F_SJD_REM_TYP__6_0==1  & !inlist(SJD_REM_TYP__6,0,1)
replace   	F_SJD_REM_TYP__6_1=2 if DEM_AGE>= 15 &     F_SJD_REM_TYP__6_0==1  &  inlist(SJD_REM_TYP__6,.)
replace   	F_SJD_REM_TYP__6_1=3 if DEM_AGE>= 15 &     F_SJD_REM_TYP__6_0!=1  & !inlist(SJD_REM_TYP__6,.)
replace  	F_SJD_REM_TYP__6_1=9 if DEM_AGE<  15 &                               !inlist(SJD_REM_TYP__6,.)

tab      	F_SJD_REM_TYP__6_0 F_SJD_REM_TYP__6_1, miss


/***************************************************     SJD_REM_TYP__7     *****************************************/

* drop    	F_SJD_REM_TYP__7_0
generate  	F_SJD_REM_TYP__7_0=0
replace   	F_SJD_REM_TYP__7_0=0
replace   	F_SJD_REM_TYP__7_0=1 if DEM_AGE>= 15 &   (MJJ_MULT==2 & inlist(SJJ_EMP_REL,1,3,4,5 )) 
tab      	F_SJD_REM_TYP__7_0, miss

* drop    	F_SJD_REM_TYP__7_1
generate  	F_SJD_REM_TYP__7_1=0
replace   	F_SJD_REM_TYP__7_1=0
replace   	F_SJD_REM_TYP__7_1=1 if DEM_AGE>= 15 &     F_SJD_REM_TYP__7_0==1  & !inlist(SJD_REM_TYP__7,0,1)
replace   	F_SJD_REM_TYP__7_1=2 if DEM_AGE>= 15 &     F_SJD_REM_TYP__7_0==1  &  inlist(SJD_REM_TYP__7,.)
replace   	F_SJD_REM_TYP__7_1=3 if DEM_AGE>= 15 &     F_SJD_REM_TYP__7_0!=1  & !inlist(SJD_REM_TYP__7,.)
replace  	F_SJD_REM_TYP__7_1=9 if DEM_AGE<  15 &                              !inlist(SJD_REM_TYP__7,.)

tab      	F_SJD_REM_TYP__7_0 F_SJD_REM_TYP__7_1, miss

/***************************************************     SJD_REM_TYP__8     *****************************************/

* drop    	F_SJD_REM_TYP__8_0
generate  	F_SJD_REM_TYP__8_0=0
replace   	F_SJD_REM_TYP__8_0=0
replace   	F_SJD_REM_TYP__8_0=1 if DEM_AGE>= 15 &   (MJJ_MULT==2 & inlist(SJJ_EMP_REL,1,3,4,5 )) 
tab      	F_SJD_REM_TYP__8_0, miss


* drop    	F_SJD_REM_TYP__8_1
generate  	F_SJD_REM_TYP__8_1=0
replace   	F_SJD_REM_TYP__8_1=0
replace   	F_SJD_REM_TYP__8_1=1 if DEM_AGE>= 15 &     F_SJD_REM_TYP__8_0==1  & !inlist(SJD_REM_TYP__8,0,1)
replace   	F_SJD_REM_TYP__8_1=2 if DEM_AGE>= 15 &     F_SJD_REM_TYP__8_0==1  &  inlist(SJD_REM_TYP__8,.)
replace   	F_SJD_REM_TYP__8_1=3 if DEM_AGE>= 15 &     F_SJD_REM_TYP__8_0!=1  & !inlist(SJD_REM_TYP__8,.)
replace  	F_SJD_REM_TYP__8_1=9 if DEM_AGE<  15 &                               !inlist(SJD_REM_TYP__8,.)

tab      	F_SJD_REM_TYP__8_0 F_SJD_REM_TYP__8_1, miss


/***************************************************     SJD_REM_TYP__9     *****************************************/

* drop    	F_SJD_REM_TYP__9_0
generate  	F_SJD_REM_TYP__9_0=0
replace   	F_SJD_REM_TYP__9_0=0
replace   	F_SJD_REM_TYP__9_0=1 if DEM_AGE>= 15 &   (MJJ_MULT==2 & inlist(SJJ_EMP_REL,1,3,4,5 )) 
tab      	F_SJD_REM_TYP__9_0, miss

* drop    	F_SJD_REM_TYP__9_1
generate  	F_SJD_REM_TYP__9_1=0
replace   	F_SJD_REM_TYP__9_1=0
replace   	F_SJD_REM_TYP__9_1=1 if DEM_AGE>= 15 &     F_SJD_REM_TYP__9_0==1  & !inlist(SJD_REM_TYP__9,0,1)
replace   	F_SJD_REM_TYP__9_1=2 if DEM_AGE>= 15 &     F_SJD_REM_TYP__9_0==1  &  inlist(SJD_REM_TYP__9,.)
replace   	F_SJD_REM_TYP__9_1=3 if DEM_AGE>= 15 &     F_SJD_REM_TYP__9_0!=1  & !inlist(SJD_REM_TYP__9,.)
replace  	F_SJD_REM_TYP__9_1=9 if DEM_AGE<  15 &                               !inlist(SJD_REM_TYP__9,.)

tab      	F_SJD_REM_TYP__9_0 F_SJD_REM_TYP__9_1, miss


/***************************************************     SJD_REM_TYP_OTH     *****************************************/
* drop    	F_SJD_REM_TYP_OTH_0
generate  	F_SJD_REM_TYP_OTH_0=0
replace   	F_SJD_REM_TYP_OTH_0=1 if DEM_AGE>= 15 &   (MJJ_MULT==2 & SJD_REM_TYP__8==1) 
tab      	F_SJD_REM_TYP_OTH_0, miss

* drop    	F_SJD_REM_TYP_OTH_1
generate  	F_SJD_REM_TYP_OTH_1=0
replace   	F_SJD_REM_TYP_OTH_1=2 if DEM_AGE>= 15 &   F_SJD_REM_TYP_OTH_0==1  &  SJD_REM_TYP_OTH==""
replace   	F_SJD_REM_TYP_OTH_1=3 if DEM_AGE>= 15 &   F_SJD_REM_TYP_OTH_0!=1  &  SJD_REM_TYP_OTH!=""
replace  	F_SJD_REM_TYP_OTH_1=9 if DEM_AGE<  15 &                                SJD_REM_TYP_OTH!=""

tab      	F_SJD_REM_TYP_OTH_0 F_SJD_REM_TYP_OTH_1, miss



/***************************************************     SJD_SOCPRO_a     *****************************************/
* drop    	F_SJD_SOCPRO_a_0
generate  	F_SJD_SOCPRO_a_0=0
replace   	F_SJD_SOCPRO_a_0=1 if DEM_AGE>= 15 &    MJJ_MULT==2 & inlist(SJJ_EMP_REL,1,4)
tab      	F_SJD_SOCPRO_a_0, miss

* drop    	F_SJD_SOCPRO_a_1
generate  	F_SJD_SOCPRO_a_1=0
replace   	F_SJD_SOCPRO_a_1=1 if DEM_AGE>= 15 &   (F_SJD_SOCPRO_a_0==1) &  !inlist(SJD_SOCPRO_a,1,2,97)
replace   	F_SJD_SOCPRO_a_1=2 if DEM_AGE>= 15 &   (F_SJD_SOCPRO_a_0==1) &   inlist(SJD_SOCPRO_a,0,.)
replace   	F_SJD_SOCPRO_a_1=3 if DEM_AGE>= 15 &  !(F_SJD_SOCPRO_a_0==1) &  !inlist(SJD_SOCPRO_a,0,.)
replace  	F_SJD_SOCPRO_a_1=9 if DEM_AGE<  15 &                            !inlist(SJD_SOCPRO_a,0,.)

tab      	F_SJD_SOCPRO_a_0 F_SJD_SOCPRO_a_1, miss


/***************************************************     SJD_SOCPRO_b    *****************************************/

* drop    	F_SJD_SOCPRO_b_0
generate  	F_SJD_SOCPRO_b_0=0
replace   	F_SJD_SOCPRO_b_0=0
replace   	F_SJD_SOCPRO_b_0=1 if DEM_AGE>= 15 &   MJJ_MULT==2 & inlist(SJJ_EMP_REL,3,5) & SJD_REM_TYP__1==1 
tab      	F_SJD_SOCPRO_b_0, miss

* drop    	F_SJD_SOCPRO_b_1
generate  	F_SJD_SOCPRO_b_1=0
replace   	F_SJD_SOCPRO_b_1=0
replace   	F_SJD_SOCPRO_b_1=1 if DEM_AGE>= 15 &   (F_SJD_SOCPRO_b_0==1) &  !inlist(SJD_SOCPRO_b,1,2,97)
replace   	F_SJD_SOCPRO_b_1=2 if DEM_AGE>= 15 &   (F_SJD_SOCPRO_b_0==1) &   inlist(SJD_SOCPRO_b,0,.)
replace   	F_SJD_SOCPRO_b_1=3 if DEM_AGE>= 15 &  !(F_SJD_SOCPRO_b_0==1) &  !inlist(SJD_SOCPRO_b,0,.)
replace  	F_SJD_SOCPRO_b_1=9 if DEM_AGE<  15 &                            !inlist(SJD_SOCPRO_b,0,.)

tab      	F_SJD_SOCPRO_b_0 F_SJD_SOCPRO_b_1, miss


/***************************************************     SJD_SOCPRO    *****************************************/
* drop    	F_SJD_SOCPRO_0
generate  	F_SJD_SOCPRO_0=0
replace   	F_SJD_SOCPRO_0=1 if DEM_AGE>= 15 &   MJJ_MULT==2 & inlist(SJJ_EMP_REL,1,4)
replace   	F_SJD_SOCPRO_0=1 if DEM_AGE>= 15 &   MJJ_MULT==2 & inlist(SJJ_EMP_REL,3,5) & SJD_REM_TYP__1==1 
tab      	F_SJD_SOCPRO_0, miss

* drop    	F_SJD_SOCPRO_1
generate  	F_SJD_SOCPRO_1=0
replace   	F_SJD_SOCPRO_1=1 if DEM_AGE>= 15 &   (F_SJD_SOCPRO_0==1) & !inlist(SJD_SOCPRO,1,2,97)
replace   	F_SJD_SOCPRO_1=2 if DEM_AGE>= 15 &   (F_SJD_SOCPRO_0==1) &  inlist(SJD_SOCPRO,0,.)
replace   	F_SJD_SOCPRO_1=3 if DEM_AGE>= 15 &  !(F_SJD_SOCPRO_0==1) & !inlist(SJD_SOCPRO,0,.)
replace  	F_SJD_SOCPRO_1=9 if DEM_AGE<  15 &                         !inlist(SJD_SOCPRO,0,.)  
 
tab      	F_SJD_SOCPRO_0 F_SJD_SOCPRO_1, miss



/***************************************************     SJI_MAINCLIENT     *****************************************/
* drop    	F_SJD_SINGLE_CLIENT_0
generate  	F_SJD_SINGLE_CLIENT_0=0
replace   	F_SJD_SINGLE_CLIENT_0=0
replace   	F_SJD_SINGLE_CLIENT_0=1 if DEM_AGE>= 15  & MJJ_MULT==2 & SJJ_HIRES==2
tab      	F_SJD_SINGLE_CLIENT_0, miss

* drop    	F_SJD_SINGLE_CLIENT_1
generate  	F_SJD_SINGLE_CLIENT_1=0
replace   	F_SJD_SINGLE_CLIENT_1=0 
replace   	F_SJD_SINGLE_CLIENT_1=1 if DEM_AGE>= 15 &   F_SJD_SINGLE_CLIENT_0==1   &  !inlist(SJD_SINGLE_CLIENT,1,2,3)
replace   	F_SJD_SINGLE_CLIENT_1=2 if DEM_AGE>= 15 &   F_SJD_SINGLE_CLIENT_0==1   &   inlist(SJD_SINGLE_CLIENT,0,.)
replace   	F_SJD_SINGLE_CLIENT_1=3 if DEM_AGE>= 15 & !(F_SJD_SINGLE_CLIENT_0==1)  &  !inlist(SJD_SINGLE_CLIENT,0,.)
replace  	F_SJD_SINGLE_CLIENT_1=9 if DEM_AGE<  15 &                                 !inlist(SJD_SINGLE_CLIENT,0,.)

tab      	F_SJD_SINGLE_CLIENT_0  F_SJD_SINGLE_CLIENT_1, miss


/***************************************************     SJD_SOURCE_CLIENT     *****************************************/
* drop    	F_SJD_SOURCE_CLIENT_0
generate  	F_SJD_SOURCE_CLIENT_0=0
replace   	F_SJD_SOURCE_CLIENT_0=0
replace   	F_SJD_SOURCE_CLIENT_0=1 if DEM_AGE>= 15 &   MJJ_MULT==2 & SJD_SINGLE_CLIENT==2
tab      	F_SJD_SOURCE_CLIENT_0, miss

* drop    	F_SJD_SOURCE_CLIENT_1
generate  	F_SJD_SOURCE_CLIENT_1=0
replace   	F_SJD_SOURCE_CLIENT_1=1 if DEM_AGE>= 15 &   (F_SJD_SOURCE_CLIENT_0==1)  & !inlist(SJD_SOURCE_CLIENT,1,2,3,4)
replace   	F_SJD_SOURCE_CLIENT_1=2 if DEM_AGE>= 15 &   (F_SJD_SOURCE_CLIENT_0==1)  &  inlist(SJD_SOURCE_CLIENT,0,.)
replace   	F_SJD_SOURCE_CLIENT_1=3 if DEM_AGE>= 15 &  !(F_SJD_SOURCE_CLIENT_0==1)  & !inlist(SJD_SOURCE_CLIENT,0,.)
replace  	F_SJD_SOURCE_CLIENT_1=9 if DEM_AGE<  15 &                                 !inlist(SJD_SOURCE_CLIENT,0,.)

tab      	F_SJD_SOURCE_CLIENT_0 F_SJD_SOURCE_CLIENT_1, miss

/***************************************************     SJD_CONTROL__1     *****************************************/

generate  	F_SJD_CONTROL__1_0=0
replace   	F_SJD_CONTROL__1_0=1 if DEM_AGE>= 15 &  MJJ_MULT==2 & ( SJD_SINGLE_CLIENT==1 | inlist(SJD_SOURCE_CLIENT,1,2)) 
tab      	F_SJD_CONTROL__1_0, miss

generate  	F_SJD_CONTROL__1_1=0
replace   	F_SJD_CONTROL__1_1=1 if DEM_AGE>= 15 &    F_SJD_CONTROL__1_0==1   & !inlist(SJD_CONTROL__1,1,0)
replace   	F_SJD_CONTROL__1_1=2 if DEM_AGE>= 15 &    F_SJD_CONTROL__1_0==1   &  inlist(SJD_CONTROL__1,.)
replace   	F_SJD_CONTROL__1_1=3 if DEM_AGE>= 15 &  !(F_SJD_CONTROL__1_0==1)  & !inlist(SJD_CONTROL__1,.)
replace  	F_SJD_CONTROL__1_1=9 if DEM_AGE<  15 &                              !inlist(SJD_CONTROL__1,.)

tab      	F_SJD_CONTROL__1_0 F_SJD_CONTROL__1_1, miss


/***************************************************     SJD_CONTROL__2     *****************************************/

generate  	F_SJD_CONTROL__2_0=0
replace   	F_SJD_CONTROL__2_0=1 if DEM_AGE>= 15 &  MJJ_MULT==2 & ( SJD_SINGLE_CLIENT==1 | inlist(SJD_SOURCE_CLIENT,1,2)) 
tab      	F_SJD_CONTROL__2_0, miss

generate  	F_SJD_CONTROL__2_1=0
replace   	F_SJD_CONTROL__2_1=1 if DEM_AGE>= 15 &    F_SJD_CONTROL__2_0==1   & !inlist(SJD_CONTROL__2,1,0)
replace   	F_SJD_CONTROL__2_1=2 if DEM_AGE>= 15 &    F_SJD_CONTROL__2_0==1   &  inlist(SJD_CONTROL__2,.)
replace   	F_SJD_CONTROL__2_1=3 if DEM_AGE>= 15 &  !(F_SJD_CONTROL__2_0==1)  & !inlist(SJD_CONTROL__2,.)
replace  	F_SJD_CONTROL__2_1=9 if DEM_AGE<  15 &                              !inlist(SJD_CONTROL__2,.)

tab      	F_SJD_CONTROL__2_0 F_SJD_CONTROL__2_1, miss



/***************************************************     SJD_CONTROL__7     *****************************************/

generate  	F_SJD_CONTROL__7_0=0
replace  	F_SJD_CONTROL__7_0=0
replace   	F_SJD_CONTROL__7_0=1 if DEM_AGE>= 15 &  MJJ_MULT==2 & ( SJD_SINGLE_CLIENT==1 | inlist(SJD_SOURCE_CLIENT,1,2)) 
tab      	F_SJD_CONTROL__7_0, miss


generate  	F_SJD_CONTROL__7_1=0
replace     F_SJD_CONTROL__7_1=0
replace   	F_SJD_CONTROL__7_1=1 if DEM_AGE>= 15 &    F_SJD_CONTROL__7_0==1   & !inlist(SJD_CONTROL__7,1,0)
replace   	F_SJD_CONTROL__7_1=2 if DEM_AGE>= 15 &    F_SJD_CONTROL__7_0==1   &  inlist(SJD_CONTROL__7,.)
replace   	F_SJD_CONTROL__7_1=3 if DEM_AGE>= 15 &  !(F_SJD_CONTROL__7_0==1)  & !inlist(SJD_CONTROL__7,.)
replace  	F_SJD_CONTROL__7_1=9 if DEM_AGE<  15 &                              !inlist(SJD_CONTROL__7,.)

tab      	F_SJD_CONTROL__7_0 F_SJD_CONTROL__7_1, miss


tab SJD_CONTROL__1 SJD_CONTROL__2 if  ( SJD_SINGLE_CLIENT==1 | inlist(SJD_SOURCE_CLIENT,1,2)) , miss

tab SJD_CONTROL__7 if  ( SJD_SINGLE_CLIENT==1 | inlist(SJD_SOURCE_CLIENT,1,2)) , miss



//list  SJD_CONTROL__1  SJD_CONTROL__2  SJD_CONTROL__7 if MJJ_MULT==2 & ( SJD_SINGLE_CLIENT==1 | inlist(SJD_SOURCE_CLIENT,1,2))


/***************************************************     SJD_SOCPRO_SELF_a     *****************************************/
* drop    	F_SJD_SOCPRO_SELF_a_0
generate  	F_SJD_SOCPRO_SELF_a_0=0
replace   	F_SJD_SOCPRO_SELF_a_0=1 if DEM_AGE>= 15 &    MJJ_MULT==2 & SJJ_REGI==1 & (SJD_CONTROL__1==1 | SJD_CONTROL__2==1 ) 
replace   	F_SJD_SOCPRO_SELF_a_0=1 if DEM_AGE>= 15 &    MJJ_MULT==2 & SJJ_EMP_REL==1 & SJD_REM_TYP__1!=1 & inlist(SJD_SOCPRO,2,97)
tab      	F_SJD_SOCPRO_SELF_a_0, miss

* drop    	F_SJD_SOCPRO_SELF_a_1
generate  	F_SJD_SOCPRO_SELF_a_1=0
replace   	F_SJD_SOCPRO_SELF_a_1=1 if DEM_AGE>= 15 &   (F_SJD_SOCPRO_SELF_a_0==1) &  !inlist(SJD_SOCPRO_SELF_a,1,2,97)
replace   	F_SJD_SOCPRO_SELF_a_1=2 if DEM_AGE>= 15 &   (F_SJD_SOCPRO_SELF_a_0==1) &   inlist(SJD_SOCPRO_SELF_a,0,.)
replace   	F_SJD_SOCPRO_SELF_a_1=3 if DEM_AGE>= 15 &  !(F_SJD_SOCPRO_SELF_a_0==1) &  !inlist(SJD_SOCPRO_SELF_a,0,.)
replace  	F_SJD_SOCPRO_SELF_a_1=9 if DEM_AGE<  15 &                                 !inlist(SJD_SOCPRO_SELF_a,0,.)

tab      	F_SJD_SOCPRO_SELF_a_0 F_SJD_SOCPRO_SELF_a_1, miss


/***************************************************     SJD_SOCPRO_SELF_b    *****************************************/

* drop    	F_SJD_SOCPRO_SELF_b_0
generate  	F_SJD_SOCPRO_SELF_b_0=0
replace   	F_SJD_SOCPRO_SELF_b_0=0
replace   	F_SJD_SOCPRO_SELF_b_0=1 if DEM_AGE>= 15 &   MJJ_MULT==2 & inlist(SJJ_EMP_REL,3,5) & SJD_REM_TYP__1!=1 & SJJ_REGI==1
tab      	F_SJD_SOCPRO_SELF_b_0, miss

* drop    	F_SJD_SOCPRO_SELF_b_1
generate  	F_SJD_SOCPRO_SELF_b_1=0
replace   	F_SJD_SOCPRO_SELF_b_1=0
replace   	F_SJD_SOCPRO_SELF_b_1=1 if DEM_AGE>= 15 &   (F_SJD_SOCPRO_SELF_b_0==1) &  !inlist(SJD_SOCPRO_SELF_b,1,2,97)
replace   	F_SJD_SOCPRO_SELF_b_1=2 if DEM_AGE>= 15 &   (F_SJD_SOCPRO_SELF_b_0==1) &   inlist(SJD_SOCPRO_SELF_b,0,.)
replace   	F_SJD_SOCPRO_SELF_b_1=3 if DEM_AGE>= 15 &  !(F_SJD_SOCPRO_SELF_b_0==1) &  !inlist(SJD_SOCPRO_SELF_b,0,.)
replace  	F_SJD_SOCPRO_SELF_b_1=9 if DEM_AGE<  15 &                                 !inlist(SJD_SOCPRO_SELF_b,0,.)

tab      	F_SJD_SOCPRO_SELF_b_0 F_SJD_SOCPRO_SELF_b_1, miss


/***************************************************     SJD_SOCPRO_SELF    *****************************************/
* drop    	F_SJD_SOCPRO_SELF_0
generate  	F_SJD_SOCPRO_SELF_0=0
replace   	F_SJD_SOCPRO_SELF_0=1 if DEM_AGE>= 15 &    MJJ_MULT==2 &  SJJ_REGI==1 & (SJD_CONTROL__1==1 | SJD_CONTROL__2==1 ) 
replace   	F_SJD_SOCPRO_SELF_0=1 if DEM_AGE>= 15 &    MJJ_MULT==2 &  SJJ_EMP_REL==1 & SJD_REM_TYP__1!=1 & inlist(SJD_SOCPRO,2,97)
replace   	F_SJD_SOCPRO_SELF_0=1 if DEM_AGE>= 15 &    MJJ_MULT==2 & inlist(SJJ_EMP_REL,3,5) & SJD_REM_TYP__1!=1 & SJJ_REGI==1
tab      	F_SJD_SOCPRO_SELF_0, miss

* drop    	F_SJD_SOCPRO_SELF_1
generate  	F_SJD_SOCPRO_SELF_1=0
replace   	F_SJD_SOCPRO_SELF_1=1 if DEM_AGE>= 15 &   (F_SJD_SOCPRO_SELF_0==1) & !inlist(SJD_SOCPRO_SELF,1,2,97)
replace   	F_SJD_SOCPRO_SELF_1=2 if DEM_AGE>= 15 &   (F_SJD_SOCPRO_SELF_0==1) &  inlist(SJD_SOCPRO_SELF,0,.)
replace   	F_SJD_SOCPRO_SELF_1=3 if DEM_AGE>= 15 &  !(F_SJD_SOCPRO_SELF_0==1) & !inlist(SJD_SOCPRO_SELF,0,.)
replace  	F_SJD_SOCPRO_SELF_1=9 if DEM_AGE<  15 &                              !inlist(SJD_SOCPRO_SELF,0,.)  
 
tab      	F_SJD_SOCPRO_SELF_0 F_SJD_SOCPRO_SELF_1, miss



*******************************************************************************************************************
*
*            TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_SJB_0 ///
F_SJJ_OCC_TLE_0 ///
F_SJJ_OCC_MTD_0 ///
F_SJJ_IND_MAC_0 ///
F_SJJ_EMP_REL_0 ///
F_SJJ_HIRES_0 ///
F_SJJ_REGI_0 ///
F_SJD_REM_TYP__1_0 ///
F_SJD_REM_TYP__2_0 ///
F_SJD_REM_TYP__3_0 ///
F_SJD_REM_TYP__4_0 ///
F_SJD_REM_TYP__5_0 ///
F_SJD_REM_TYP__6_0 ///
F_SJD_REM_TYP__7_0 ///
F_SJD_REM_TYP__8_0 ///
F_SJD_REM_TYP__9_0 ///
F_SJD_REM_TYP_OTH_0 ///
F_SJD_SOCPRO_a_0 ///
F_SJD_SOCPRO_b_0 ///
F_SJD_SOCPRO_0 ///
F_SJD_SINGLE_CLIENT_0 ///
F_SJD_SOURCE_CLIENT_0 ///
F_SJD_CONTROL__1_0 ///
F_SJD_CONTROL__2_0 ///
F_SJD_CONTROL__7_0 ///
F_SJD_SOCPRO_SELF_a_0 ///
F_SJD_SOCPRO_SELF_b_0 ///
F_SJD_SOCPRO_SELF_0 

foreach var of varlist $List_F_SJB_0 {
    tab `var' if `var'>0 , miss
}

global List_F_SJB_1 ///
F_SJJ_OCC_TLE_1 ///
F_SJJ_OCC_MTD_1 ///
F_SJJ_IND_MAC_1 ///
F_SJJ_EMP_REL_1 ///
F_SJJ_HIRES_1 ///
F_SJJ_REGI_1 ///
F_SJD_REM_TYP__1_1 ///
F_SJD_REM_TYP__2_1 ///
F_SJD_REM_TYP__3_1 ///
F_SJD_REM_TYP__4_1 ///
F_SJD_REM_TYP__5_1 ///
F_SJD_REM_TYP__6_1 ///
F_SJD_REM_TYP__7_1 ///
F_SJD_REM_TYP__8_1 ///
F_SJD_REM_TYP__9_1 ///
F_SJD_REM_TYP_OTH_1 ///
F_SJD_SOCPRO_a_1 ///
F_SJD_SOCPRO_b_1 ///
F_SJD_SOCPRO_1 ///
F_SJD_SINGLE_CLIENT_1 ///
F_SJD_SOURCE_CLIENT_1 ///
F_SJD_CONTROL__1_1 ///
F_SJD_CONTROL__2_1 ///
F_SJD_CONTROL__7_1 ///
F_SJD_SOCPRO_SELF_a_1 ///
F_SJD_SOCPRO_SELF_b_1 ///
F_SJD_SOCPRO_SELF_1 

foreach var of varlist $List_F_SJB_1 {
    tab `var' if `var'>0 , miss
}
