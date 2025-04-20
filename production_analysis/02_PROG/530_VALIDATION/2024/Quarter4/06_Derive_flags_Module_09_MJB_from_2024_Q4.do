*******************************************************************************************************************
*
* DERIVE FLAGS TO HIGHLIGH PROBLEMS WITH QUESTIONS AND SECTIONS
* 


/* COdes
1 - out of range
2 - missing: to impute
3 - undue wrong filter: to delete
9 - undue < 15: to delete
*/

	

*******************************************************************************************************************
*******************************************************************************************************************
***                                                                                                             ***
***                                            CHECK ON THE MJB - CHARACTERISTICS OF MAIN JOB                   ***
***                                                                                                             *** 
*******************************************************************************************************************
*******************************************************************************************************************



/********************************************************  MJJ_MULT   ********************************************/
*drop     F_MJJ_MULT_0
generate  F_MJJ_MULT_0=0
replace   F_MJJ_MULT_0=0 
replace   F_MJJ_MULT_0=1 if DEM_AGE>= 15 & GLO_EMP==1 
tab       F_MJJ_MULT_0 , miss

* drop    F_MJJ_MULT_1
generate  F_MJJ_MULT_1=0
replace   F_MJJ_MULT_1=0
replace   F_MJJ_MULT_1=1 if   F_MJJ_MULT_0==1  &  !inlist(MJJ_MULT,1,2)
replace   F_MJJ_MULT_1=2 if   F_MJJ_MULT_0==1  &   inlist(MJJ_MULT,0,.)
replace   F_MJJ_MULT_1=3 if !(F_MJJ_MULT_0==1) &  !inlist(MJJ_MULT,0,.)
replace   F_MJJ_MULT_1=9 if   DEM_AGE<  15     &  !inlist(MJJ_MULT,0,.)

tab        F_MJJ_MULT_0 F_MJJ_MULT_1, miss


/***************************************************     MJJ_OCC_TLE     *****************************************/
* drop    	F_MJJ_OCC_TLE_0
generate  	F_MJJ_OCC_TLE_0=0
replace   	F_MJJ_OCC_TLE_0=0
replace   	F_MJJ_OCC_TLE_0=1 if DEM_AGE>= 15 &  inlist(MJJ_MULT,1,2)
tab      	F_MJJ_OCC_TLE_0 

* drop    	F_MJJ_OCC_TLE_1
generate  	F_MJJ_OCC_TLE_1=0
replace   	F_MJJ_OCC_TLE_1=0
replace   	F_MJJ_OCC_TLE_1=2 if DEM_AGE>=15 &    F_MJJ_OCC_TLE_0==1  & MJJ_OCC_TLE==""
replace   	F_MJJ_OCC_TLE_1=3 if DEM_AGE>=15 &  !(F_MJJ_OCC_TLE_0==1) & MJJ_OCC_TLE!=""
replace  	F_MJJ_OCC_TLE_1=9 if DEM_AGE< 15                          & MJJ_OCC_TLE!=""

tab      	F_MJJ_OCC_TLE_0 F_MJJ_OCC_TLE_1, miss


/***************************************************     MJJ_OCC_MTD     *****************************************/

* drop    	F_MJJ_OCC_MTD_0
generate  	F_MJJ_OCC_MTD_0=0
replace   	F_MJJ_OCC_MTD_0=0
replace   	F_MJJ_OCC_MTD_0=1 if DEM_AGE>= 15 & inlist(MJJ_MULT,1,2)
tab      	F_MJJ_OCC_MTD_0 

* drop    	F_MJJ_OCC_MTD_1
generate  	F_MJJ_OCC_MTD_1=0
replace   	F_MJJ_OCC_MTD_1=0
replace   	F_MJJ_OCC_MTD_1=2 if DEM_AGE>= 15 &    F_MJJ_OCC_TLE_0==1  & MJJ_OCC_MTD==""
replace   	F_MJJ_OCC_MTD_1=3 if DEM_AGE>= 15 &  !(F_MJJ_OCC_TLE_0==1) & MJJ_OCC_MTD!=""
replace  	F_MJJ_OCC_MTD_1=9 if DEM_AGE<  15                          & MJJ_OCC_MTD!=""

tab      	F_MJJ_OCC_MTD_0 F_MJJ_OCC_MTD_1, miss

/***************************************************     MJU_REF     *****************************************/
* drop    	F_MJU_REF_0
generate  	F_MJU_REF_0=0
replace   	F_MJU_REF_0=0
replace   	F_MJU_REF_0=1 if DEM_AGE>= 15 & GLO_EMP==1 
tab      	F_MJU_REF_0, miss

* drop    	F_MJU_REF_1
generate  	F_MJU_REF_1=0
replace   	F_MJU_REF_1=0 
replace   	F_MJU_REF_1=1 if DEM_AGE>= 15 &    F_MJU_REF_0==1  & !inlist(MJU_REF,1,2,3)
replace   	F_MJU_REF_1=2 if DEM_AGE>= 15 &    F_MJU_REF_0==1  &  inlist(MJU_REF,.)
replace   	F_MJU_REF_1=3 if DEM_AGE>= 15 &  !(F_MJU_REF_0==1) & !inlist(MJU_REF,.)
replace  	F_MJU_REF_1=9 if DEM_AGE<  15 &                      !inlist(MJU_REF,.)

tab      	  MJU_REF, miss

tab      	F_MJU_REF_0 F_MJU_REF_1, miss


/***************************************************     MJU_NAM     *****************************************/
* drop    	F_MJU_NAM_0
generate  	F_MJU_NAM_0=0
replace   	F_MJU_NAM_0=1 if DEM_AGE>= 15 & MJU_REF==1 
tab      	F_MJU_NAM_0

* drop    	F_MJU_NAM_1
generate  	F_MJU_NAM_1=0
replace   	F_MJU_NAM_1=2 if DEM_AGE>= 15 &   F_MJU_NAM_0==1  &  MJU_NAM==""
replace   	F_MJU_NAM_1=3 if DEM_AGE>= 15 & !(F_MJU_NAM_0==1) &  MJU_NAM!=""
replace  	F_MJU_NAM_1=9 if DEM_AGE<  15 &                      MJU_NAM!=""

tab      	F_MJU_NAM_0 F_MJU_NAM_1, miss

tab      	  MJU_NAM, miss





/***************************************************     MJU_MAC     *****************************************/
* drop    	F_MJU_MAC_0
generate  	F_MJU_MAC_0=0
replace   	F_MJU_MAC_0=1 if DEM_AGE>= 15 & GLO_EMP==1 & inlist(MJU_REF,1,2)
tab      	F_MJU_MAC_0

* drop    	F_MJU_MAC_1
generate  	F_MJU_MAC_1=0
replace   	F_MJU_MAC_1=2 if DEM_AGE>= 15 &   F_MJU_MAC_0==1  & MJU_MAC==""
replace   	F_MJU_MAC_1=3 if DEM_AGE>= 15 & !(F_MJU_MAC_0==1) & MJU_MAC!=""
replace  	F_MJU_MAC_1=9 if DEM_AGE<  15 &                     MJU_MAC!=""
tab      	F_MJU_MAC_0 F_MJU_MAC_1, miss

tab      	  MJU_MAC, miss


/***************************************************     MJJ_EMP_REL_NAT     *****************************************/
* drop    	F_MJJ_EMP_REL_NAT_0
generate  	F_MJJ_EMP_REL_NAT_0=0
replace   	F_MJJ_EMP_REL_NAT_0=1 if DEM_AGE>= 15 &  GLO_EMP==1
tab      	F_MJJ_EMP_REL_NAT_0 

* drop    	F_MJJ_EMP_REL_NAT_1
generate  	F_MJJ_EMP_REL_NAT_1=0
replace   	F_MJJ_EMP_REL_NAT_1=0
replace   	F_MJJ_EMP_REL_NAT_1=1 if DEM_AGE>= 15 &    F_MJJ_EMP_REL_NAT_0==1  & !inlist(MJJ_EMP_REL_NAT,1,2,3,4,5,6)
replace   	F_MJJ_EMP_REL_NAT_1=2 if DEM_AGE>= 15 &    F_MJJ_EMP_REL_NAT_0==1  &  inlist(MJJ_EMP_REL_NAT,.)
replace   	F_MJJ_EMP_REL_NAT_1=3 if DEM_AGE>= 15 &  !(F_MJJ_EMP_REL_NAT_0==1) & !inlist(MJJ_EMP_REL_NAT,.)
replace  	F_MJJ_EMP_REL_NAT_1=9 if DEM_AGE<  15 &                              !inlist(MJJ_EMP_REL_NAT,.)

tab      	F_MJJ_EMP_REL_NAT_0 F_MJJ_EMP_REL_NAT_1, miss


/***************************************************     MJJ_GRW_CHK     *****************************************/
* drop    	F_MJJ_GRW_CHK_0
generate  	F_MJJ_GRW_CHK_0=0
replace   	F_MJJ_GRW_CHK_0=0 
replace   	F_MJJ_GRW_CHK_0=1 if DEM_AGE>= 15 &   MJJ_EMP_REL_NAT==6
tab      	F_MJJ_GRW_CHK_0, miss

* drop    	F_MJJ_GRW_CHK_1
generate  	F_MJJ_GRW_CHK_1=0
replace   	F_MJJ_GRW_CHK_1=0
replace   	F_MJJ_GRW_CHK_1=1 if DEM_AGE>= 15 &    F_MJJ_GRW_CHK_0==1  & !inlist(MJJ_GRW_CHK,1,2)
replace   	F_MJJ_GRW_CHK_1=2 if DEM_AGE>= 15 &    F_MJJ_GRW_CHK_0==1  &  inlist(MJJ_GRW_CHK,.)
replace   	F_MJJ_GRW_CHK_1=3 if DEM_AGE>= 15 &  !(F_MJJ_GRW_CHK_0==1) & !inlist(MJJ_GRW_CHK,.)
replace  	F_MJJ_GRW_CHK_1=9 if DEM_AGE<  15 &                          !inlist(MJJ_GRW_CHK,.)

tab      	F_MJJ_GRW_CHK_0 F_MJJ_GRW_CHK_1, miss

/***************************************************     MJJ_EMP_REL     *****************************************/
* drop    	F_MJJ_EMP_REL_0
generate  	F_MJJ_EMP_REL_0=0
replace   	F_MJJ_EMP_REL_0=1 if DEM_AGE>= 15 &  GLO_EMP==1
tab      	F_MJJ_EMP_REL_0 

* drop    	F_MJJ_EMP_REL_1
generate  	F_MJJ_EMP_REL_1=0
replace   	F_MJJ_EMP_REL_1=0
replace   	F_MJJ_EMP_REL_1=1 if DEM_AGE>= 15 &    F_MJJ_EMP_REL_0==1  & !inlist(MJJ_EMP_REL,1,2,3,4,5)
replace   	F_MJJ_EMP_REL_1=2 if DEM_AGE>= 15 &    F_MJJ_EMP_REL_0==1  &  inlist(MJJ_EMP_REL,.)
replace   	F_MJJ_EMP_REL_1=3 if DEM_AGE>= 15 &  !(F_MJJ_EMP_REL_0==1) & !inlist(MJJ_EMP_REL,.)
replace  	F_MJJ_EMP_REL_1=9 if DEM_AGE<  15 &                          !inlist(MJJ_EMP_REL,.)

tab      	F_MJJ_EMP_REL_0 F_MJJ_EMP_REL_1, miss

* tab      	  MJJ_EMP_REL    if F_MJJ_EMP_REL_1==3 , miss

/***************************************************     MJJ_CFW_CHK     *****************************************/
* drop    	F_MJJ_CFW_CHK_0
generate  	F_MJJ_CFW_CHK_0=0
replace   	F_MJJ_CFW_CHK_0=0 
replace   	F_MJJ_CFW_CHK_0=1 if DEM_AGE>= 15 &   MJJ_EMP_REL==3
tab      	F_MJJ_CFW_CHK_0, miss

* drop    	F_MJJ_CFW_CHK_1
generate  	F_MJJ_CFW_CHK_1=0
replace   	F_MJJ_CFW_CHK_1=0
replace   	F_MJJ_CFW_CHK_1=1 if DEM_AGE>= 15 &    F_MJJ_CFW_CHK_0==1  & !inlist(MJJ_CFW_CHK,1,2,3,4)
replace   	F_MJJ_CFW_CHK_1=2 if DEM_AGE>= 15 &    F_MJJ_CFW_CHK_0==1  &  inlist(MJJ_CFW_CHK,.)
replace   	F_MJJ_CFW_CHK_1=3 if DEM_AGE>= 15 &  !(F_MJJ_CFW_CHK_0==1) & !inlist(MJJ_CFW_CHK,.)
replace  	F_MJJ_CFW_CHK_1=9 if DEM_AGE<  15 &                          !inlist(MJJ_CFW_CHK,.)

tab      	F_MJJ_CFW_CHK_0 F_MJJ_CFW_CHK_1, miss

/***************************************************     MJJ_HIRES     *****************************************/
* drop    	F_MJJ_HIRES_0
generate  	F_MJJ_HIRES_0=0
replace   	F_MJJ_HIRES_0=0 
replace   	F_MJJ_HIRES_0=1 if DEM_AGE>= 15 &  MJJ_EMP_REL==2
replace   	F_MJJ_HIRES_0=1 if DEM_AGE>= 15 &  MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,1,2)
tab      	F_MJJ_HIRES_0, miss

* drop    	F_MJJ_HIRES_1
generate  	F_MJJ_HIRES_1=0
replace   	F_MJJ_HIRES_1=1 if DEM_AGE>= 15 &    F_MJJ_HIRES_0==1  & !inlist(MJJ_HIRES,1,2)
replace   	F_MJJ_HIRES_1=2 if DEM_AGE>= 15 &    F_MJJ_HIRES_0==1  &  inlist(MJJ_HIRES,.)
replace   	F_MJJ_HIRES_1=3 if DEM_AGE>= 15 &  !(F_MJJ_HIRES_0==1) & !inlist(MJJ_HIRES,.)
replace  	F_MJJ_HIRES_1=9 if DEM_AGE<  15 &                        !inlist(MJJ_HIRES,.)

tab      	F_MJJ_HIRES_0 F_MJJ_HIRES_1, miss

tab      	  MJJ_HIRES, miss


/***************************************************     MJJ_REM_TYP__1     *****************************************/
* drop    	F_MJJ_REM_TYP__1_0
generate  	F_MJJ_REM_TYP__1_0=0
replace   	F_MJJ_REM_TYP__1_0=0
replace   	F_MJJ_REM_TYP__1_0=1 if DEM_AGE>= 15 & ( inlist(MJJ_EMP_REL,1,4,5)  | ( MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,3,4) ) ) 
tab      	F_MJJ_REM_TYP__1_0, miss

* drop    	F_MJJ_REM_TYP__1_1
generate  	F_MJJ_REM_TYP__1_1=0
replace   	F_MJJ_REM_TYP__1_1=0
replace   	F_MJJ_REM_TYP__1_1=1 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__1_0==1  & !inlist(MJJ_REM_TYP__1,0,1) 
replace   	F_MJJ_REM_TYP__1_1=2 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__1_0==1  &  inlist(MJJ_REM_TYP__1,.)
replace   	F_MJJ_REM_TYP__1_1=3 if DEM_AGE>= 15 &  !(F_MJJ_REM_TYP__1_0==1) & !inlist(MJJ_REM_TYP__1,.)
replace  	F_MJJ_REM_TYP__1_1=9 if DEM_AGE<  15 &                             !inlist(MJJ_REM_TYP__1,.)

tab      	F_MJJ_REM_TYP__1_0 F_MJJ_REM_TYP__1_1, miss

* tab           MJJ_REM_TYP__1, miss

/***************************************************     MJJ_REM_TYP__2     *****************************************/

* drop    	F_MJJ_REM_TYP__2_0
generate  	F_MJJ_REM_TYP__2_0=0
replace   	F_MJJ_REM_TYP__2_0=0
replace   	F_MJJ_REM_TYP__2_0=1 if DEM_AGE>= 15 &   ( inlist(MJJ_EMP_REL,1,4,5)  | ( MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,3,4) ) ) 
tab      	F_MJJ_REM_TYP__2_0, miss

* drop    	F_MJJ_REM_TYP__2_1
generate  	F_MJJ_REM_TYP__2_1=0
replace   	F_MJJ_REM_TYP__2_1=0
replace   	F_MJJ_REM_TYP__2_1=1 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__2_0==1  & !inlist(MJJ_REM_TYP__2,0,1) 
replace   	F_MJJ_REM_TYP__2_1=2 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__2_0==1  &  inlist(MJJ_REM_TYP__2,.)
replace   	F_MJJ_REM_TYP__2_1=3 if DEM_AGE>= 15 &  !(F_MJJ_REM_TYP__2_0==1) & !inlist(MJJ_REM_TYP__2,.)
replace  	F_MJJ_REM_TYP__2_1=9 if DEM_AGE<  15 &                             !inlist(MJJ_REM_TYP__2,.)

tab      	F_MJJ_REM_TYP__2_0 F_MJJ_REM_TYP__2_1, miss

* list    MJJ_EMP_REL if  F_MJJ_REM_TYP__2_0==0 & F_MJJ_REM_TYP__2_1==3


/***************************************************     MJJ_REM_TYP__3     *****************************************/

* drop    	F_MJJ_REM_TYP__3_0
generate  	F_MJJ_REM_TYP__3_0=0
replace   	F_MJJ_REM_TYP__3_0=0
replace   	F_MJJ_REM_TYP__3_0=1 if DEM_AGE>= 15 &   ( inlist(MJJ_EMP_REL,1,4,5)  | ( MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,3,4) ) ) 
tab      	F_MJJ_REM_TYP__3_0, miss

* drop    	F_MJJ_REM_TYP__3_1
generate  	F_MJJ_REM_TYP__3_1=0
replace   	F_MJJ_REM_TYP__3_1=0
replace   	F_MJJ_REM_TYP__3_1=1 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__3_0==1  & !inlist(MJJ_REM_TYP__3,0,1) 
replace   	F_MJJ_REM_TYP__3_1=2 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__3_0==1  &  inlist(MJJ_REM_TYP__3,.)
replace   	F_MJJ_REM_TYP__3_1=3 if DEM_AGE>= 15 &  !(F_MJJ_REM_TYP__3_0==1) & !inlist(MJJ_REM_TYP__3,.)
replace  	F_MJJ_REM_TYP__3_1=9 if DEM_AGE<  15 &                             !inlist(MJJ_REM_TYP__3,.)

tab      	F_MJJ_REM_TYP__3_0 F_MJJ_REM_TYP__3_1, miss

* tab           MJJ_REM_TYP__3, miss

/***************************************************     MJJ_REM_TYP__4     *****************************************/

* drop    	F_MJJ_REM_TYP__4_0
generate  	F_MJJ_REM_TYP__4_0=0
replace   	F_MJJ_REM_TYP__4_0=0
replace   	F_MJJ_REM_TYP__4_0=1 if DEM_AGE>= 15 &    ( inlist(MJJ_EMP_REL,1,4,5)  | ( MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,3,4) ) ) 
tab      	F_MJJ_REM_TYP__4_0, miss

* drop    	F_MJJ_REM_TYP__4_1
generate  	F_MJJ_REM_TYP__4_1=0
replace   	F_MJJ_REM_TYP__4_1=0
replace   	F_MJJ_REM_TYP__4_1=1 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__4_0==1  & !inlist(MJJ_REM_TYP__4,0,1) 
replace   	F_MJJ_REM_TYP__4_1=2 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__4_0==1  &  inlist(MJJ_REM_TYP__4,.)
replace   	F_MJJ_REM_TYP__4_1=3 if DEM_AGE>= 15 &  !(F_MJJ_REM_TYP__4_0==1) & !inlist(MJJ_REM_TYP__4,.)
replace  	F_MJJ_REM_TYP__4_1=9 if DEM_AGE<  15 &                             !inlist(MJJ_REM_TYP__4,.)

tab      	F_MJJ_REM_TYP__4_0 F_MJJ_REM_TYP__4_1, miss

* tab           MJJ_REM_TYP__4, miss
/***************************************************     MJJ_REM_TYP__5     *****************************************/

* drop    	F_MJJ_REM_TYP__5_0
generate  	F_MJJ_REM_TYP__5_0=0
replace   	F_MJJ_REM_TYP__5_0=0
replace   	F_MJJ_REM_TYP__5_0=1 if DEM_AGE>= 15 &   ( inlist(MJJ_EMP_REL,1,4,5)  | ( MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,3,4) ) ) 
tab      	F_MJJ_REM_TYP__5_0, miss

* drop    	F_MJJ_REM_TYP__5_1
generate  	F_MJJ_REM_TYP__5_1=0
replace   	F_MJJ_REM_TYP__5_1=0
replace   	F_MJJ_REM_TYP__5_1=1 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__5_0==1  & !inlist(MJJ_REM_TYP__5,0,1) 
replace   	F_MJJ_REM_TYP__5_1=2 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__5_0==1  &  inlist(MJJ_REM_TYP__5,.)
replace   	F_MJJ_REM_TYP__5_1=3 if DEM_AGE>= 15 &  !(F_MJJ_REM_TYP__5_0==1) & !inlist(MJJ_REM_TYP__5,.)
replace  	F_MJJ_REM_TYP__5_1=9 if DEM_AGE<  15 &                             !inlist(MJJ_REM_TYP__5,.)

tab      	F_MJJ_REM_TYP__5_0 F_MJJ_REM_TYP__5_1, miss

*tab           MJJ_REM_TYP__5, miss

/***************************************************     MJJ_REM_TYP__6     *****************************************/

* drop    	F_MJJ_REM_TYP__6_0
generate  	F_MJJ_REM_TYP__6_0=0
replace   	F_MJJ_REM_TYP__6_0=0
replace   	F_MJJ_REM_TYP__6_0=1 if DEM_AGE>= 15 &    ( inlist(MJJ_EMP_REL,1,4,5)  | ( MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,3,4) ) ) 
tab      	F_MJJ_REM_TYP__6_0, miss

* drop    	F_MJJ_REM_TYP__6_1
generate  	F_MJJ_REM_TYP__6_1=0
replace   	F_MJJ_REM_TYP__6_1=0
replace   	F_MJJ_REM_TYP__6_1=1 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__6_0==1  & !inlist(MJJ_REM_TYP__6,0,1) 
replace   	F_MJJ_REM_TYP__6_1=2 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__6_0==1  &  inlist(MJJ_REM_TYP__6,.)
replace   	F_MJJ_REM_TYP__6_1=3 if DEM_AGE>= 15 &  !(F_MJJ_REM_TYP__6_0==1) & !inlist(MJJ_REM_TYP__6,.)
replace  	F_MJJ_REM_TYP__6_1=9 if DEM_AGE<  15 &                             !inlist(MJJ_REM_TYP__6,.)

tab      	F_MJJ_REM_TYP__6_0 F_MJJ_REM_TYP__6_1, miss

*tab           MJJ_REM_TYP__6, miss


/***************************************************     MJJ_REM_TYP__7     *****************************************/

* drop    	F_MJJ_REM_TYP__7_0
generate  	F_MJJ_REM_TYP__7_0=0
replace   	F_MJJ_REM_TYP__7_0=0
replace   	F_MJJ_REM_TYP__7_0=1 if DEM_AGE>= 15 &    ( inlist(MJJ_EMP_REL,1,4,5)  | ( MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,3,4) ) ) 
tab      	F_MJJ_REM_TYP__7_0, miss

* drop    	F_MJJ_REM_TYP__7_1
generate  	F_MJJ_REM_TYP__7_1=0
replace   	F_MJJ_REM_TYP__7_1=0
replace   	F_MJJ_REM_TYP__7_1=1 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__7_0==1  & !inlist(MJJ_REM_TYP__7,0,1) 
replace   	F_MJJ_REM_TYP__7_1=2 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__7_0==1  &  inlist(MJJ_REM_TYP__7,.)
replace   	F_MJJ_REM_TYP__7_1=3 if DEM_AGE>= 15 &  !(F_MJJ_REM_TYP__7_0==1) & !inlist(MJJ_REM_TYP__7,.)
replace  	F_MJJ_REM_TYP__7_1=9 if DEM_AGE<  15 &                             !inlist(MJJ_REM_TYP__7,.)

tab      	F_MJJ_REM_TYP__7_0 F_MJJ_REM_TYP__7_1, miss

* tab           MJJ_REM_TYP__7, miss


/***************************************************     MJJ_REM_TYP__8     *****************************************/

* drop    	F_MJJ_REM_TYP__8_0
generate  	F_MJJ_REM_TYP__8_0=0
replace   	F_MJJ_REM_TYP__8_0=0
replace   	F_MJJ_REM_TYP__8_0=1 if DEM_AGE>= 15 &   ( inlist(MJJ_EMP_REL,1,4,5)  | ( MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,3,4) ) ) 
tab      	F_MJJ_REM_TYP__8_0, miss

* drop    	F_MJJ_REM_TYP__8_1
generate  	F_MJJ_REM_TYP__8_1=0
replace   	F_MJJ_REM_TYP__8_1=0
replace   	F_MJJ_REM_TYP__8_1=1 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__8_0==1  & !inlist(MJJ_REM_TYP__8,0,1) 
replace   	F_MJJ_REM_TYP__8_1=2 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__8_0==1  &  inlist(MJJ_REM_TYP__8,.)
replace   	F_MJJ_REM_TYP__8_1=3 if DEM_AGE>= 15 &  !(F_MJJ_REM_TYP__8_0==1) & !inlist(MJJ_REM_TYP__8,.)
replace  	F_MJJ_REM_TYP__8_1=9 if DEM_AGE<  15 &                             !inlist(MJJ_REM_TYP__8,.)

tab      	F_MJJ_REM_TYP__8_0 F_MJJ_REM_TYP__8_1, miss

*
tab           MJJ_REM_TYP__8, miss


/***************************************************     MJJ_REM_TYP__9     *****************************************/

* drop    	F_MJJ_REM_TYP__9_0
generate  	F_MJJ_REM_TYP__9_0=0
replace   	F_MJJ_REM_TYP__9_0=0
replace   	F_MJJ_REM_TYP__9_0=1 if DEM_AGE>= 15 &    ( inlist(MJJ_EMP_REL,1,4,5)  | ( MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,3,4) ) ) 
tab      	F_MJJ_REM_TYP__9_0, miss

* drop    	F_MJJ_REM_TYP__9_1
generate  	F_MJJ_REM_TYP__9_1=0
replace   	F_MJJ_REM_TYP__9_1=0
replace   	F_MJJ_REM_TYP__9_1=1 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__9_0==1  & !inlist(MJJ_REM_TYP__9,0,1) 
replace   	F_MJJ_REM_TYP__9_1=2 if DEM_AGE>= 15 &    F_MJJ_REM_TYP__9_0==1  &  inlist(MJJ_REM_TYP__9,.)
replace   	F_MJJ_REM_TYP__9_1=3 if DEM_AGE>= 15 &  !(F_MJJ_REM_TYP__9_0==1) & !inlist(MJJ_REM_TYP__9,.)
replace  	F_MJJ_REM_TYP__9_1=9 if DEM_AGE<  15 &                             !inlist(MJJ_REM_TYP__9,.)

tab      	F_MJJ_REM_TYP__9_0 F_MJJ_REM_TYP__9_1, miss

*tab           MJJ_REM_TYP__9, miss







/***************************************************     MJJ_REM_TYP_other     *****************************************/
* drop    	F_MJJ_REM_TYP_OTH_0
generate  	F_MJJ_REM_TYP_OTH_0=0
replace   	F_MJJ_REM_TYP_OTH_0=0 
replace   	F_MJJ_REM_TYP_OTH_0=1 if DEM_AGE>= 15 &   MJJ_REM_TYP__8==1
tab      	F_MJJ_REM_TYP_OTH_0, miss

* drop    	F_MJJ_REM_TYP_other_1
generate  	F_MJJ_REM_TYP_OTH_1=0
replace   	F_MJJ_REM_TYP_OTH_1=0
replace   	F_MJJ_REM_TYP_OTH_1=2 if DEM_AGE>= 15 &    F_MJJ_REM_TYP_OTH_0==1  &  MJJ_REM_TYP_OTH==""
replace   	F_MJJ_REM_TYP_OTH_1=3 if DEM_AGE>= 15 &  !(F_MJJ_REM_TYP_OTH_0==1) &  MJJ_REM_TYP_OTH!=""
replace  	F_MJJ_REM_TYP_OTH_1=9 if DEM_AGE<  15                             &  MJJ_REM_TYP_OTH!=""                     
tab      	F_MJJ_REM_TYP_OTH_0 F_MJJ_REM_TYP_OTH_1, miss



/***************************************************     MJI_MAINCLIENT     *****************************************/
* drop    	F_MJD_SINGLE_CLIENT_0
generate  	F_MJD_SINGLE_CLIENT_0=0
replace   	F_MJD_SINGLE_CLIENT_0=0
replace   	F_MJD_SINGLE_CLIENT_0=1 if DEM_AGE>= 15 & MJJ_EMP_REL==2                           & MJJ_HIRES==2
replace   	F_MJD_SINGLE_CLIENT_0=1 if DEM_AGE>= 15 & MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,1,2) & MJJ_HIRES==2
tab      	F_MJD_SINGLE_CLIENT_0, miss

* drop    	F_MJD_SINGLE_CLIENT_1
generate  	F_MJD_SINGLE_CLIENT_1=0
replace   	F_MJD_SINGLE_CLIENT_1=0 
replace   	F_MJD_SINGLE_CLIENT_1=1 if DEM_AGE>= 15 &   F_MJD_SINGLE_CLIENT_0==1  &  !inlist(MJD_SINGLE_CLIENT,1,2,3)
replace   	F_MJD_SINGLE_CLIENT_1=2 if DEM_AGE>= 15 &   F_MJD_SINGLE_CLIENT_0==1  &   inlist(MJD_SINGLE_CLIENT,.)
replace   	F_MJD_SINGLE_CLIENT_1=3 if DEM_AGE>= 15 & !(F_MJD_SINGLE_CLIENT_0==1) &  !inlist(MJD_SINGLE_CLIENT,.)
replace  	F_MJD_SINGLE_CLIENT_1=9 if DEM_AGE<  15 &                                !inlist(MJD_SINGLE_CLIENT,.)

*tab      	  MJD_SINGLE_CLIENT , miss

tab      	F_MJD_SINGLE_CLIENT_0 F_MJD_SINGLE_CLIENT_1, miss


/***************************************************     MJD_SOURCE_CLIENT     *****************************************/
* drop    	F_MJD_SOURCE_CLIENT_0
generate  	F_MJD_SOURCE_CLIENT_0=0
replace   	F_MJD_SOURCE_CLIENT_0=0 
replace   	F_MJD_SOURCE_CLIENT_0=1 if DEM_AGE>= 15 & MJD_SINGLE_CLIENT==2
tab      	F_MJD_SOURCE_CLIENT_0, miss

* drop    	F_MJD_SOURCE_CLIENT_1
generate  	F_MJD_SOURCE_CLIENT_1=0
replace   	F_MJD_SOURCE_CLIENT_1=0 
replace   	F_MJD_SOURCE_CLIENT_1=1 if DEM_AGE>= 15 &    F_MJD_SOURCE_CLIENT_0==1  & !inlist(MJD_SOURCE_CLIENT,1,2,3,4)
replace   	F_MJD_SOURCE_CLIENT_1=2 if DEM_AGE>= 15 &    F_MJD_SOURCE_CLIENT_0==1  &  inlist(MJD_SOURCE_CLIENT,.)
replace   	F_MJD_SOURCE_CLIENT_1=3 if DEM_AGE>= 15 &  !(F_MJD_SOURCE_CLIENT_0==1) & !inlist(MJD_SOURCE_CLIENT,.)
replace  	F_MJD_SOURCE_CLIENT_1=9 if DEM_AGE<  15 &                                !inlist(MJD_SOURCE_CLIENT,.)

*tab      	  MJD_SOURCE_CLIENT , miss

tab      	F_MJD_SOURCE_CLIENT_0 F_MJD_SOURCE_CLIENT_1, miss




/***************************************************     MJD_SELL_CLIENT__1 *****************************************/
* drop    	F_MJD_SELL_CLIENT__1_0
generate  	F_MJD_SELL_CLIENT__1_0=0
replace   	F_MJD_SELL_CLIENT__1_0=0
replace   	F_MJD_SELL_CLIENT__1_0=1 if DEM_AGE>= 15 & ( inlist(MJD_SOURCE_CLIENT,3,4)  | MJD_SINGLE_CLIENT==3) 
tab      	F_MJD_SELL_CLIENT__1_0, miss

* drop    	F_MJD_SELL_CLIENT__1_1
generate  	F_MJD_SELL_CLIENT__1_1=0
replace   	F_MJD_SELL_CLIENT__1_1=0
replace   	F_MJD_SELL_CLIENT__1_1=1 if DEM_AGE>= 15 &    F_MJD_SELL_CLIENT__1_0==1  & !inlist(MJD_SELL_CLIENT__1,0,1) 
replace   	F_MJD_SELL_CLIENT__1_1=2 if DEM_AGE>= 15 &    F_MJD_SELL_CLIENT__1_0==1  &  inlist(MJD_SELL_CLIENT__1,.)
replace   	F_MJD_SELL_CLIENT__1_1=3 if DEM_AGE>= 15 &  !(F_MJD_SELL_CLIENT__1_0==1) & !inlist(MJD_SELL_CLIENT__1,.)
replace  	F_MJD_SELL_CLIENT__1_1=9 if DEM_AGE<  15 &                                 !inlist(MJD_SELL_CLIENT__1,.)

tab      	F_MJD_SELL_CLIENT__1_0 F_MJD_SELL_CLIENT__1_1, miss

* tab           MJD_SELL_CLIENT__1, miss


/***************************************************     MJD_SELL_CLIENT__2 *****************************************/
* drop    	F_MJD_SELL_CLIENT__2_0
generate  	F_MJD_SELL_CLIENT__2_0=0
replace   	F_MJD_SELL_CLIENT__2_0=0
replace   	F_MJD_SELL_CLIENT__2_0=1 if DEM_AGE>= 15 & ( inlist(MJD_SOURCE_CLIENT,3,4)  | MJD_SINGLE_CLIENT==3) 
tab      	F_MJD_SELL_CLIENT__2_0, miss

* drop    	F_MJD_SELL_CLIENT__2_1
generate  	F_MJD_SELL_CLIENT__2_1=0
replace   	F_MJD_SELL_CLIENT__2_1=0
replace   	F_MJD_SELL_CLIENT__2_1=1 if DEM_AGE>= 15 &    F_MJD_SELL_CLIENT__2_0==1  & !inlist(MJD_SELL_CLIENT__2,0,1) 
replace   	F_MJD_SELL_CLIENT__2_1=2 if DEM_AGE>= 15 &    F_MJD_SELL_CLIENT__2_0==1  &  inlist(MJD_SELL_CLIENT__2,.)
replace   	F_MJD_SELL_CLIENT__2_1=3 if DEM_AGE>= 15 &  !(F_MJD_SELL_CLIENT__2_0==1) & !inlist(MJD_SELL_CLIENT__2,.)
replace  	F_MJD_SELL_CLIENT__2_1=9 if DEM_AGE<  15 &                                 !inlist(MJD_SELL_CLIENT__2,.)

tab      	F_MJD_SELL_CLIENT__2_0 F_MJD_SELL_CLIENT__2_1, miss

* tab           MJD_SELL_CLIENT__2, miss

/***************************************************     MJD_SELL_CLIENT__3 *****************************************/
* drop    	F_MJD_SELL_CLIENT__3_0
generate  	F_MJD_SELL_CLIENT__3_0=0
replace   	F_MJD_SELL_CLIENT__3_0=0
replace   	F_MJD_SELL_CLIENT__3_0=1 if DEM_AGE>= 15 & ( inlist(MJD_SOURCE_CLIENT,3,4)  | MJD_SINGLE_CLIENT==3) 
tab      	F_MJD_SELL_CLIENT__3_0, miss

* drop    	F_MJD_SELL_CLIENT__3_1
generate  	F_MJD_SELL_CLIENT__3_1=0
replace   	F_MJD_SELL_CLIENT__3_1=0
replace   	F_MJD_SELL_CLIENT__3_1=1 if DEM_AGE>= 15 &    F_MJD_SELL_CLIENT__3_0==1  & !inlist(MJD_SELL_CLIENT__3,0,1) 
replace   	F_MJD_SELL_CLIENT__3_1=2 if DEM_AGE>= 15 &    F_MJD_SELL_CLIENT__3_0==1  &  inlist(MJD_SELL_CLIENT__3,.)
replace   	F_MJD_SELL_CLIENT__3_1=3 if DEM_AGE>= 15 &  !(F_MJD_SELL_CLIENT__3_0==1) & !inlist(MJD_SELL_CLIENT__3,.)
replace  	F_MJD_SELL_CLIENT__3_1=9 if DEM_AGE<  15 &                                 !inlist(MJD_SELL_CLIENT__3,.)

tab      	F_MJD_SELL_CLIENT__3_0 F_MJD_SELL_CLIENT__3_1, miss

* tab           MJD_SELL_CLIENT__3, miss

/***************************************************     MJD_SELL_CLIENT__4 *****************************************/
* drop    	F_MJD_SELL_CLIENT__4_0
generate  	F_MJD_SELL_CLIENT__4_0=0
replace   	F_MJD_SELL_CLIENT__4_0=0
replace   	F_MJD_SELL_CLIENT__4_0=1 if DEM_AGE>= 15 & ( inlist(MJD_SOURCE_CLIENT,3,4)  | MJD_SINGLE_CLIENT==3) 
tab      	F_MJD_SELL_CLIENT__4_0, miss

* drop    	F_MJD_SELL_CLIENT__4_1
generate  	F_MJD_SELL_CLIENT__4_1=0
replace   	F_MJD_SELL_CLIENT__4_1=0
replace   	F_MJD_SELL_CLIENT__4_1=1 if DEM_AGE>= 15 &    F_MJD_SELL_CLIENT__4_0==1  & !inlist(MJD_SELL_CLIENT__4,0,1) 
replace   	F_MJD_SELL_CLIENT__4_1=2 if DEM_AGE>= 15 &    F_MJD_SELL_CLIENT__4_0==1  &  inlist(MJD_SELL_CLIENT__4,.)
replace   	F_MJD_SELL_CLIENT__4_1=3 if DEM_AGE>= 15 &  !(F_MJD_SELL_CLIENT__4_0==1) & !inlist(MJD_SELL_CLIENT__4,.)
replace  	F_MJD_SELL_CLIENT__4_1=9 if DEM_AGE<  15 &                                 !inlist(MJD_SELL_CLIENT__4,.)

tab      	F_MJD_SELL_CLIENT__4_0 F_MJD_SELL_CLIENT__4_1, miss

* tab           MJD_SELL_CLIENT__4, miss



/***************************************************     MJD_CONTROL__1  *****************************************/
* drop    	F_MJD_CONTROL_0
generate  	F_MJD_CONTROL__1_0=0
replace   	F_MJD_CONTROL__1_0=0
replace   	F_MJD_CONTROL__1_0=1 if DEM_AGE>= 15 &  (MJD_SINGLE_CLIENT == 1 | inlist(MJD_SOURCE_CLIENT,1,2) | MJD_SELL_CLIENT__1==1 | MJD_SELL_CLIENT__2==1 | MJD_SELL_CLIENT__3==1 )  
tab      	F_MJD_CONTROL__1_0, miss

* drop    	F_MJD_CONTROL__1_1
generate  	F_MJD_CONTROL__1_1=0
replace   	F_MJD_CONTROL__1_1=0
replace   	F_MJD_CONTROL__1_1=1 if DEM_AGE>= 15 &   (F_MJD_CONTROL__1_0==1)  & !inlist(MJD_CONTROL__1,0,1)
replace   	F_MJD_CONTROL__1_1=2 if DEM_AGE>= 15 &   (F_MJD_CONTROL__1_0==1)  &  inlist(MJD_CONTROL__1,.)
replace   	F_MJD_CONTROL__1_1=3 if DEM_AGE>= 15 &  !(F_MJD_CONTROL__1_0==1)  & !inlist(MJD_CONTROL__1,.)
replace  	F_MJD_CONTROL__1_1=9 if DEM_AGE<  15 &                              !inlist(MJD_CONTROL__1,.)

tab      	F_MJD_CONTROL__1_0 F_MJD_CONTROL__1_1, missing

* tab      	MJD_CONTROL__1  , miss

/***************************************************     MJD_CONTROL__2  *****************************************/
* drop    	F_MJD_CONTROL__2_0
generate  	F_MJD_CONTROL__2_0=0
replace   	F_MJD_CONTROL__2_0=0
replace   	F_MJD_CONTROL__2_0=1 if DEM_AGE>= 15 &  (MJD_SINGLE_CLIENT == 1 | inlist(MJD_SOURCE_CLIENT,1,2) | MJD_SELL_CLIENT__1==1 | MJD_SELL_CLIENT__2==1 | MJD_SELL_CLIENT__3==1 )  
tab      	F_MJD_CONTROL__2_0, miss

* drop    	F_MJD_CONTROL__2_1
generate  	F_MJD_CONTROL__2_1=0
replace   	F_MJD_CONTROL__2_1=0
replace   	F_MJD_CONTROL__2_1=1 if DEM_AGE>= 15 &   (F_MJD_CONTROL__2_0==1)  & !inlist(MJD_CONTROL__2,0,1)
replace   	F_MJD_CONTROL__2_1=2 if DEM_AGE>= 15 &   (F_MJD_CONTROL__2_0==1)  &  inlist(MJD_CONTROL__2,.)
replace   	F_MJD_CONTROL__2_1=3 if DEM_AGE>= 15 &  !(F_MJD_CONTROL__2_0==1)  & !inlist(MJD_CONTROL__2,.)
replace  	F_MJD_CONTROL__2_1=9 if DEM_AGE<  15 &                              !inlist(MJD_CONTROL__2,.)

tab      	F_MJD_CONTROL__2_0 F_MJD_CONTROL__2_1, missing

* tab      	MJD_CONTROL__1  , miss

/***************************************************     MJD_CONTROL__7  *****************************************/
* drop    	F_MJD_CONTROL__7_0
generate  	F_MJD_CONTROL__7_0=0
replace   	F_MJD_CONTROL__7_0=0
replace   	F_MJD_CONTROL__7_0=1 if DEM_AGE>= 15 &  (MJD_SINGLE_CLIENT == 1 | inlist(MJD_SOURCE_CLIENT,1,2) | MJD_SELL_CLIENT__1==1 | MJD_SELL_CLIENT__2==1 | MJD_SELL_CLIENT__3==1 )  
tab      	F_MJD_CONTROL__7_0, miss

* drop    	F_MJD_CONTROL__7_1
generate  	F_MJD_CONTROL__7_1=0
replace   	F_MJD_CONTROL__7_1=0
replace   	F_MJD_CONTROL__7_1=1 if DEM_AGE>= 15 &   (F_MJD_CONTROL__7_0==1)  & !inlist(MJD_CONTROL__7,0,1)
replace   	F_MJD_CONTROL__7_1=2 if DEM_AGE>= 15 &   (F_MJD_CONTROL__7_0==1)  &  inlist(MJD_CONTROL__7,.)
replace   	F_MJD_CONTROL__7_1=3 if DEM_AGE>= 15 &  !(F_MJD_CONTROL__7_0==1)  & !inlist(MJD_CONTROL__7,.)
replace  	F_MJD_CONTROL__7_1=9 if DEM_AGE<  15 &                              !inlist(MJD_CONTROL__7,.)

tab      	F_MJD_CONTROL__7_0 F_MJD_CONTROL__7_1, missing

* tab      	MJD_CONTROL__1  , miss


/***************************************************     MJC_CONTRA     *****************************************/

* drop    	F_MJC_CONTRA_0
generate  	F_MJC_CONTRA_0=0
replace   	F_MJC_CONTRA_0=0
replace   	F_MJC_CONTRA_0=1 if DEM_AGE>= 15 &   inlist(MJJ_EMP_REL,1,4) 
replace   	F_MJC_CONTRA_0=1 if DEM_AGE>= 15 &   inlist(MJJ_EMP_REL,3,5) & MJJ_REM_TYP__1==1
tab      	F_MJC_CONTRA_0, miss

* drop    	F_MJC_CONTRA_1
generate  	F_MJC_CONTRA_1=0
replace   	F_MJC_CONTRA_1=0 
replace   	F_MJC_CONTRA_1=1 if DEM_AGE>= 15 &    F_MJC_CONTRA_0==1  & !inlist( MJC_CONTRA,1,2,97)
replace   	F_MJC_CONTRA_1=2 if DEM_AGE>= 15 &    F_MJC_CONTRA_0==1  &  inlist( MJC_CONTRA,0,.)
replace   	F_MJC_CONTRA_1=3 if DEM_AGE>= 15 &  !(F_MJC_CONTRA_0==1) & !inlist( MJC_CONTRA,0,.)
replace  	F_MJC_CONTRA_1=9 if DEM_AGE<  15 &                         !inlist( MJC_CONTRA,0,.)

tab      	F_MJC_CONTRA_0 F_MJC_CONTRA_1, miss


*tab      	   MJC_CONTRA if  MJC_CONTRA!=., miss

/***************************************************     MJC_CONOP     *****************************************/
* drop    	F_MJC_CONOP_0
generate  	F_MJC_CONOP_0=0
replace   	F_MJC_CONOP_0=0
replace   	F_MJC_CONOP_0=1 if DEM_AGE>= 15 &   inlist(MJC_CONTRA,1,2)
tab      	F_MJC_CONOP_0, miss

* drop    	F_MJC_CONOP_1
generate  	F_MJC_CONOP_1=0
replace   	F_MJC_CONOP_1=0
replace   	F_MJC_CONOP_1=1 if DEM_AGE>= 15 &   (F_MJC_CONOP_0==1)  & !inlist(MJC_CONOP,1,2,3,4,97)
replace   	F_MJC_CONOP_1=2 if DEM_AGE>= 15 &   (F_MJC_CONOP_0==1)  &  inlist(MJC_CONOP,0,.)
replace   	F_MJC_CONOP_1=3 if DEM_AGE>= 15 &  !(F_MJC_CONOP_0==1)  & !inlist(MJC_CONOP,0,.)
replace  	F_MJC_CONOP_1=9 if DEM_AGE<  15 &                         !inlist(MJC_CONOP,0,.)

tab      	F_MJC_CONOP_0 F_MJC_CONOP_1, miss


*tab      	  MJC_CONOP if MJC_CONOP!=., miss



/***************************************************     MJC_TEMPTOTAL     *****************************************/
* drop    	F_MJC_TEMPTOTAL_0
generate  	F_MJC_TEMPTOTAL_0=0
replace   	F_MJC_TEMPTOTAL_0=0
replace   	F_MJC_TEMPTOTAL_0=1 if DEM_AGE>= 15 &   MJC_CONTRA == 2  & inlist(MJC_CONOP,4,97)
replace   	F_MJC_TEMPTOTAL_0=1 if DEM_AGE>= 15 &   MJC_CONTRA == 97
tab      	F_MJC_TEMPTOTAL_0, miss

* drop    	F_MJC_TEMPTOTAL_1
generate  	F_MJC_TEMPTOTAL_1=0
replace   	F_MJC_TEMPTOTAL_1=0
replace   	F_MJC_TEMPTOTAL_1=1 if DEM_AGE>= 15 &   (F_MJC_TEMPTOTAL_0==1)  & !inlist(MJC_TEMPTOTAL,1,2,3,4,5,6,97)
replace   	F_MJC_TEMPTOTAL_1=2 if DEM_AGE>= 15 &   (F_MJC_TEMPTOTAL_0==1)  &  inlist(MJC_TEMPTOTAL,.)
replace   	F_MJC_TEMPTOTAL_1=3 if DEM_AGE>= 15 &  !(F_MJC_TEMPTOTAL_0==1)  & !inlist(MJC_TEMPTOTAL,.)
replace  	F_MJC_TEMPTOTAL_1=9 if DEM_AGE<  15 &                             !inlist(MJC_TEMPTOTAL,.)

tab      	F_MJC_TEMPTOTAL_0 F_MJC_TEMPTOTAL_1, miss

*tab      	  MJC_TEMPTOTAL if MJC_TEMPTOTAL!=., missing

/***************************************************     MJC_TEMPDUR     *****************************************/
* drop    	F_MJC_TEMPDUR_0
generate  	F_MJC_TEMPDUR_0=0
replace   	F_MJC_TEMPDUR_0=0
replace   	F_MJC_TEMPDUR_0=1 if DEM_AGE>= 15 &   inlist(MJC_CONTRA,1,2) & inlist(MJC_CONOP,1,2)
tab      	F_MJC_TEMPDUR_0, miss

* drop    	F_MJC_TEMPDUR_1
generate  	F_MJC_TEMPDUR_1=0
replace   	F_MJC_TEMPDUR_1=0
replace   	F_MJC_TEMPDUR_1=1 if DEM_AGE>= 15 &   (F_MJC_TEMPDUR_0==1)  & !inlist(MJC_TEMPDUR,1,2,3,4,5,6,7,8)
replace   	F_MJC_TEMPDUR_1=2 if DEM_AGE>= 15 &   (F_MJC_TEMPDUR_0==1)  &  inlist(MJC_TEMPDUR,0,.)
replace   	F_MJC_TEMPDUR_1=3 if DEM_AGE>= 15 &  !(F_MJC_TEMPDUR_0==1)  & !inlist(MJC_TEMPDUR,0,.)
replace  	F_MJC_TEMPDUR_1=9 if DEM_AGE<  15 &                           !inlist(MJC_TEMPDUR,0,.)

tab      	F_MJC_TEMPDUR_0 F_MJC_TEMPDUR_1, miss

*tab      	  MJC_TEMPDUR if MJC_TEMPDUR!=., miss



***************************************************     MCD_TASKSE     *****************************************/
* drop    	F_MCD_TASKSE_0
generate  	F_MCD_TASKSE_0=0
replace   	F_MCD_TASKSE_0=0 
replace   	F_MCD_TASKSE_0=1 if DEM_AGE>= 15 & inlist(MJC_TEMPDUR,1,2,3,4) 
replace   	F_MCD_TASKSE_0=1 if DEM_AGE>= 15 & inlist(MJC_TEMPTOTAL,1,2,3,4) 
tab      	F_MCD_TASKSE_0, miss


* drop    	F_MCD_TASKSE_1
generate  	F_MCD_TASKSE_1=0
replace   	F_MCD_TASKSE_1=0
replace   	F_MCD_TASKSE_1=1 if DEM_AGE>= 15 &   (F_MCD_TASKSE_0==1) & !inlist(MCD_TASKSE,1,2)
replace   	F_MCD_TASKSE_1=2 if DEM_AGE>= 15 &   (F_MCD_TASKSE_0==1) &  inlist(MCD_TASKSE,.)
replace   	F_MCD_TASKSE_1=3 if DEM_AGE>= 15 &  !(F_MCD_TASKSE_0==1) & !inlist(MCD_TASKSE,.)
replace  	F_MCD_TASKSE_1=9 if DEM_AGE<  15 &                         !inlist(MCD_TASKSE,.)

tab      	F_MCD_TASKSE_0 F_MCD_TASKSE_1, miss

*tab      	  MCD_TASKSE if MCD_TASKSE!=., miss


/***************************************************     MCD_CONTHRS_a     *****************************************/
* drop    	F_MCD_CONTHRS_a_0
generate  	F_MCD_CONTHRS_a_0=0
replace   	F_MCD_CONTHRS_a_0=0
replace   	F_MCD_CONTHRS_a_0=1 if DEM_AGE>= 15 &   inlist(MJC_CONTRA,1)
tab      	F_MCD_CONTHRS_a_0, miss

* drop    	F_MCD_CONTHRS_a_1
generate  	F_MCD_CONTHRS_a_1=0
replace   	F_MCD_CONTHRS_a_1=0
replace   	F_MCD_CONTHRS_a_1=1 if DEM_AGE>= 15 &   (F_MCD_CONTHRS_a_0==1)  & !inlist(MCD_CONTHRS_a,1,2)
replace   	F_MCD_CONTHRS_a_1=2 if DEM_AGE>= 15 &   (F_MCD_CONTHRS_a_0==1)  &  inlist(MCD_CONTHRS_a,.)
replace   	F_MCD_CONTHRS_a_1=3 if DEM_AGE>= 15 &  !(F_MCD_CONTHRS_a_0==1)  & !inlist(MCD_CONTHRS_a,.)
replace  	F_MCD_CONTHRS_a_1=9 if DEM_AGE<  15 &                             !inlist(MCD_CONTHRS_a,.)

tab      	F_MCD_CONTHRS_a_0 F_MCD_CONTHRS_a_1, miss


/***************************************************     MCD_CONTHRS_b     *****************************************/
* drop    	F_MCD_CONTHRS_b_0
generate  	F_MCD_CONTHRS_b_0=0
replace   	F_MCD_CONTHRS_b_0=0 
replace   	F_MCD_CONTHRS_b_0=1 if DEM_AGE>= 15 &   inlist(MJC_CONTRA,2)
tab      	F_MCD_CONTHRS_b_0, miss

* drop    	F_MCD_CONTHRS_b_1
generate  	F_MCD_CONTHRS_b_1=0
replace   	F_MCD_CONTHRS_b_1=1 if DEM_AGE>= 15 &   (F_MCD_CONTHRS_b_0==1)  & !inlist(MCD_CONTHRS_b,1,2)
replace   	F_MCD_CONTHRS_b_1=2 if DEM_AGE>= 15 &   (F_MCD_CONTHRS_b_0==1)  &  inlist(MCD_CONTHRS_b,.)
replace   	F_MCD_CONTHRS_b_1=3 if DEM_AGE>= 15 &  !(F_MCD_CONTHRS_b_0==1)  & !inlist(MCD_CONTHRS_b,.)
replace  	F_MCD_CONTHRS_b_1=9 if DEM_AGE<  15 &                             !inlist(MCD_CONTHRS_b,.)

tab      	F_MCD_CONTHRS_b_0 F_MCD_CONTHRS_b_1, miss



/***************************************************     MCD_CONTHRS     *****************************************/


* drop    	F_MCD_CONTHRS_0
generate  	F_MCD_CONTHRS_0=0
replace   	F_MCD_CONTHRS_0=0 
replace   	F_MCD_CONTHRS_0=1 if DEM_AGE>= 15 &   ( F_MCD_CONTHRS_a_0==1 | F_MCD_CONTHRS_b_0==1)
tab      	F_MCD_CONTHRS_0, miss

* drop    	F_MCD_CONTHRS_1
generate  	F_MCD_CONTHRS_1=0
replace   	F_MCD_CONTHRS_1=0
replace   	F_MCD_CONTHRS_1=1 if DEM_AGE>= 15 &   (F_MCD_CONTHRS_0==1) & !inlist(MCD_CONTHRS,1,2)
replace   	F_MCD_CONTHRS_1=2 if DEM_AGE>= 15 &   (F_MCD_CONTHRS_0==1) &  inlist(MCD_CONTHRS,.)
replace   	F_MCD_CONTHRS_1=3 if DEM_AGE>= 15 &  !(F_MCD_CONTHRS_0==1) & !inlist(MCD_CONTHRS,.)
replace  	F_MCD_CONTHRS_1=9 if DEM_AGE<  15 &                          !inlist(MCD_CONTHRS,.)   

tab      	F_MCD_CONTHRS_0 F_MCD_CONTHRS_1, miss



/***************************************************     MCD_CONTHRS_NUM     *****************************************/
* drop    	F_MCD_CONTHRS_NUM_0
generate  	F_MCD_CONTHRS_NUM_0=0
replace   	F_MCD_CONTHRS_NUM_0=0 
replace   	F_MCD_CONTHRS_NUM_0=1 if DEM_AGE>= 15 &  (MCD_CONTHRS_a == 1 | MCD_CONTHRS_b == 1)
tab      	F_MCD_CONTHRS_NUM_0, miss

* drop    	F_MCD_CONTHRS_NUM_1
generate  	F_MCD_CONTHRS_NUM_1=0
replace   	F_MCD_CONTHRS_NUM_1=0
replace   	F_MCD_CONTHRS_NUM_1=1 if DEM_AGE>= 15 &   (F_MCD_CONTHRS_NUM_0==1) & !(inrange(MCD_CONTHRS_NUM,1,126) | MCD_CONTHRS_NUM==997)  
replace   	F_MCD_CONTHRS_NUM_1=2 if DEM_AGE>= 15 &   (F_MCD_CONTHRS_NUM_0==1) &  inlist(MCD_CONTHRS_NUM,.) 
replace   	F_MCD_CONTHRS_NUM_1=3 if DEM_AGE>= 15 &  !(F_MCD_CONTHRS_NUM_0==1) & !inlist(MCD_CONTHRS_NUM,.) 
replace  	F_MCD_CONTHRS_NUM_1=9 if DEM_AGE<  15 &                              !inlist(MCD_CONTHRS_NUM,.)                                                     
tab      	F_MCD_CONTHRS_NUM_0 F_MCD_CONTHRS_NUM_1, miss

*tab      	  MCD_CONTHRS_NUM if MCD_CONTHRS_NUM!=., miss

/***************************************************     MCD_CONMIN_a     *****************************************/
* drop    	F_MCD_CONMIN_a_0
generate  	F_MCD_CONMIN_a_0=0
replace   	F_MCD_CONMIN_a_0=0 
replace   	F_MCD_CONMIN_a_0=1 if DEM_AGE>= 15 &  MJC_CONTRA==1 & MCD_CONTHRS_a==2
tab      	F_MCD_CONMIN_a_0, miss

* drop    	F_MCD_CONMIN_a_1
generate  	F_MCD_CONMIN_a_1=0
replace   	F_MCD_CONMIN_a_1=0
replace   	F_MCD_CONMIN_a_1=1 if DEM_AGE>= 15 &   (F_MCD_CONMIN_a_0==1) & !inlist(MCD_CONMIN_a,1,2,3)
replace   	F_MCD_CONMIN_a_1=2 if DEM_AGE>= 15 &   (F_MCD_CONMIN_a_0==1) &  inlist(MCD_CONMIN_a,.) 
replace   	F_MCD_CONMIN_a_1=3 if DEM_AGE>= 15 &  !(F_MCD_CONMIN_a_0==1) & !inlist(MCD_CONMIN_a,.)
replace  	F_MCD_CONMIN_a_1=9 if DEM_AGE<  15 &                           !inlist(MCD_CONMIN_a,.)

tab      	F_MCD_CONMIN_a_0 F_MCD_CONMIN_a_1, miss

*tab      	  MCD_CONMIN_a if MCD_CONMIN_a!=., miss


/***************************************************     MCD_CONMIN_b     *****************************************/
* drop    	F_MCD_CONMIN_b_0
generate  	F_MCD_CONMIN_b_0=0
replace   	F_MCD_CONMIN_b_0=0 
replace   	F_MCD_CONMIN_b_0=1 if DEM_AGE>= 15 &   MJC_CONTRA==2 & MCD_CONTHRS_b==2
tab      	F_MCD_CONMIN_b_0, miss

* drop    	F_MCD_CONMIN_b_1
generate  	F_MCD_CONMIN_b_1=0
replace   	F_MCD_CONMIN_b_1=0 
replace   	F_MCD_CONMIN_b_1=1 if DEM_AGE>= 15 &   (F_MCD_CONMIN_b_0==1) & !inlist(MCD_CONMIN_b,1,2,3)
replace   	F_MCD_CONMIN_b_1=2 if DEM_AGE>= 15 &   (F_MCD_CONMIN_b_0==1) &  inlist(MCD_CONMIN_b,.) 
replace   	F_MCD_CONMIN_b_1=3 if DEM_AGE>= 15 &  !(F_MCD_CONMIN_b_0==1) & !inlist(MCD_CONMIN_b,.)
replace  	F_MCD_CONMIN_b_1=9 if DEM_AGE<  15 &                           !inlist(MCD_CONMIN_b,.)

tab      	F_MCD_CONMIN_b_0 F_MCD_CONMIN_b_1, miss

* tab      	  MCD_CONMIN_b if MCD_CONMIN_b!=., miss

/***************************************************     MCD_CONMIN     *****************************************/

* drop    	F_MCD_CONMIN_0
generate  	F_MCD_CONMIN_0=0
replace   	F_MCD_CONMIN_0=0
replace   	F_MCD_CONMIN_0=1 if DEM_AGE>= 15 &  (F_MCD_CONMIN_a_0==1 | F_MCD_CONMIN_b_0==1)
tab      	F_MCD_CONMIN_0, miss

* drop    	F_MCD_CONMIN_1
generate  	F_MCD_CONMIN_1=0
replace   	F_MCD_CONMIN_1=0
replace   	F_MCD_CONMIN_1=1 if DEM_AGE>= 15 &   (F_MCD_CONMIN_0==1) & !inlist(MCD_CONMIN,1,2,3)
replace   	F_MCD_CONMIN_1=2 if DEM_AGE>= 15 &   (F_MCD_CONMIN_0==1) &  inlist(MCD_CONMIN,.)
replace   	F_MCD_CONMIN_1=3 if DEM_AGE>= 15 &  !(F_MCD_CONMIN_0==1) & !inlist(MCD_CONMIN,.)
replace  	F_MCD_CONMIN_1=9 if DEM_AGE<  15 &                         !inlist(MCD_CONMIN,.)   


tab      	F_MCD_CONMIN_0 F_MCD_CONMIN_1, miss


/***************************************************     MIE_SOCPRO_a     *****************************************/
* drop    	F_MIE_SOCPRO_a_0
generate  	F_MIE_SOCPRO_a_0=0
replace   	F_MIE_SOCPRO_a_0=0
replace   	F_MIE_SOCPRO_a_0=1 if DEM_AGE>= 15 &  inlist(MJJ_EMP_REL,1,4)
tab      	F_MIE_SOCPRO_a_0, miss

* drop    	F_MIE_SOCPRO_a_1
generate  	F_MIE_SOCPRO_a_1=0
replace   	F_MIE_SOCPRO_a_1=0
replace   	F_MIE_SOCPRO_a_1=1 if DEM_AGE>= 15 &   (F_MIE_SOCPRO_a_0==1) & !inlist(MIE_SOCPRO_a,1,2,97)
replace   	F_MIE_SOCPRO_a_1=2 if DEM_AGE>= 15 &   (F_MIE_SOCPRO_a_0==1) &  inlist(MIE_SOCPRO_a,.)
replace   	F_MIE_SOCPRO_a_1=3 if DEM_AGE>= 15 &  !(F_MIE_SOCPRO_a_0==1) & !inlist(MIE_SOCPRO_a,.)
replace  	F_MIE_SOCPRO_a_1=9 if DEM_AGE<  15 &                           !inlist(MIE_SOCPRO_a,.)

tab      	F_MIE_SOCPRO_a_0 F_MIE_SOCPRO_a_1, missing

*tab      	  MIE_SOCPRO_a if MIE_SOCPRO_a!=., miss


/***************************************************     MIE_SOCPRO_b    *****************************************/

* drop    	F_MIE_SOCPRO_b_0
generate  	F_MIE_SOCPRO_b_0=0
replace   	F_MIE_SOCPRO_b_0=0 
replace   	F_MIE_SOCPRO_b_0=1 if DEM_AGE>= 15 & inlist(MJJ_EMP_REL,3,5) & MJJ_REM_TYP__1==1 
tab      	F_MIE_SOCPRO_b_0, miss

* drop    	F_MIE_SOCPRO_b_1
generate  	F_MIE_SOCPRO_b_1=0
replace   	F_MIE_SOCPRO_b_1=0 
replace   	F_MIE_SOCPRO_b_1=1 if DEM_AGE>= 15 &   (F_MIE_SOCPRO_b_0==1)  & !inlist( MIE_SOCPRO_b,1,2,97)
replace   	F_MIE_SOCPRO_b_1=2 if DEM_AGE>= 15 &   (F_MIE_SOCPRO_b_0==1)  &  inlist( MIE_SOCPRO_b,.)
replace   	F_MIE_SOCPRO_b_1=3 if DEM_AGE>= 15 &  !(F_MIE_SOCPRO_b_0==1)  & !inlist( MIE_SOCPRO_b,.)
replace  	F_MIE_SOCPRO_b_1=9 if DEM_AGE<  15 &                            !inlist( MIE_SOCPRO_b,.)

tab      	F_MIE_SOCPRO_b_0 F_MIE_SOCPRO_b_1, missing



/***************************************************     MIE_SOCPRO    *****************************************/

* drop    	F_MIE_SOCPRO_0
generate  	F_MIE_SOCPRO_0=0
replace   	F_MIE_SOCPRO_0=0
replace   	F_MIE_SOCPRO_0=1 if DEM_AGE>= 15 &   ( F_MIE_SOCPRO_a_0==1 |  F_MIE_SOCPRO_b_0==1)
tab      	F_MIE_SOCPRO_0, miss

* drop    	F_MIE_SOCPRO_1
generate  	F_MIE_SOCPRO_1=0
replace   	F_MIE_SOCPRO_1=0
replace   	F_MIE_SOCPRO_1=1 if DEM_AGE>= 15 &   (F_MIE_SOCPRO_0==1) & !inlist(MIE_SOCPRO,1,2,97)
replace   	F_MIE_SOCPRO_1=2 if DEM_AGE>= 15 &   (F_MIE_SOCPRO_0==1) &  inlist(MIE_SOCPRO,.)
replace   	F_MIE_SOCPRO_1=3 if DEM_AGE>= 15 &  !(F_MIE_SOCPRO_0==1) & !inlist(MIE_SOCPRO,.)
replace  	F_MIE_SOCPRO_1=9 if DEM_AGE<  15 &                         !inlist(MIE_SOCPRO,.)   

tab      	  MIE_SOCPRO if MIE_SOCPRO!=., miss

tab      	F_MIE_SOCPRO_0 F_MIE_SOCPRO_1, miss




/***************************************************     MIE_SOCPRO_SELF    *****************************************/

* drop    	F_MIE_SOCPRO_SELF_0
generate  	F_MIE_SOCPRO_SELF_0=0
replace   	F_MIE_SOCPRO_SELF_0=0
replace   	F_MIE_SOCPRO_SELF_0=1 if DEM_AGE>= 15 & inlist(MJJ_EMP_REL,1,4) & MJJ_REM_TYP__1!=1 & inlist(MIE_SOCPRO,2,97)
tab      	F_MIE_SOCPRO_SELF_0, miss

* drop    	F_MIE_SOCPRO_SELF_1
generate  	F_MIE_SOCPRO_SELF_1=0
replace   	F_MIE_SOCPRO_SELF_1=0
replace   	F_MIE_SOCPRO_SELF_1=1 if DEM_AGE>= 15 &   (F_MIE_SOCPRO_SELF_0==1) & !inlist(MIE_SOCPRO_SELF,1,2,97)
replace   	F_MIE_SOCPRO_SELF_1=2 if DEM_AGE>= 15 &   (F_MIE_SOCPRO_SELF_0==1) &  inlist(MIE_SOCPRO_SELF,.)
replace   	F_MIE_SOCPRO_SELF_1=3 if DEM_AGE>= 15 &  !(F_MIE_SOCPRO_SELF_0==1) & !inlist(MIE_SOCPRO_SELF,.)
replace  	F_MIE_SOCPRO_SELF_1=9 if DEM_AGE<  15 &                              !inlist(MIE_SOCPRO_SELF,.)   

tab      	F_MIE_SOCPRO_SELF_0 F_MIE_SOCPRO_SELF_1, miss






/***************************************************     MJJ_HINS     ****************************************/

* drop    	F_MJJ_HINS_0
generate  	F_MJJ_HINS_0=0
replace   	F_MJJ_HINS_0=0
replace   	F_MJJ_HINS_0=1 if DEM_AGE>= 15 & inlist(MJJ_EMP_REL,1,4) 
replace   	F_MJJ_HINS_0=1 if DEM_AGE>= 15 & inlist(MJJ_EMP_REL,3,5) & MJJ_REM_TYP__1==1 
tab      	F_MJJ_HINS_0, miss

* drop    	F_MJJ_HINS_1
generate  	F_MJJ_HINS_1=0
replace   	F_MJJ_HINS_1=0
replace   	F_MJJ_HINS_1=1 if DEM_AGE>= 15 &   (F_MJJ_HINS_0==1) & !inlist(MJJ_HINS,1,2,97)
replace   	F_MJJ_HINS_1=2 if DEM_AGE>= 15 &   (F_MJJ_HINS_0==1) &  inlist(MJJ_HINS,.)
replace   	F_MJJ_HINS_1=3 if DEM_AGE>= 15 &  !(F_MJJ_HINS_0==1) & !inlist(MJJ_HINS,.)
replace  	F_MJJ_HINS_1=9 if DEM_AGE<  15 &                       !inlist(MJJ_HINS,.)


tab      	F_MJJ_HINS_0 F_MJJ_HINS_1, miss





/***************************************************     MIE_PVACLV     *****************************************/
* drop    	F_MIE_PVACLV_0
generate  	F_MIE_PVACLV_0=0
replace   	F_MIE_PVACLV_0=0
replace   	F_MIE_PVACLV_0=1 if DEM_AGE>= 15 & inlist(MJJ_EMP_REL,1,4) 
replace   	F_MIE_PVACLV_0=1 if DEM_AGE>= 15 & inlist(MJJ_EMP_REL,3,5) & MJJ_REM_TYP__1==1
tab      	F_MIE_PVACLV_0, miss

* drop    	F_MIE_PVACLV_1
generate  	F_MIE_PVACLV_1=0
replace   	F_MIE_PVACLV_1=0
replace   	F_MIE_PVACLV_1=1 if DEM_AGE>= 15 &   (F_MIE_PVACLV_0==1) & !inlist(MIE_PVACLV,1,2,97)
replace   	F_MIE_PVACLV_1=2 if DEM_AGE>= 15 &   (F_MIE_PVACLV_0==1) &  inlist(MIE_PVACLV,.)
replace   	F_MIE_PVACLV_1=3 if DEM_AGE>= 15 &  !(F_MIE_PVACLV_0==1) & !inlist(MIE_PVACLV,.)
replace  	F_MIE_PVACLV_1=9 if DEM_AGE<  15 &                         !inlist(MIE_PVACLV,.)

tab      	F_MIE_PVACLV_0 F_MIE_PVACLV_1, miss

* tab      	  MIE_PVACLV if MIE_PVACLV!=., miss


/***************************************************     MIE_PSCKLV     *****************************************/
* drop    	F_MIE_PSCKLV_0
generate  	F_MIE_PSCKLV_0=0
replace   	F_MIE_PSCKLV_0=0
replace   	F_MIE_PSCKLV_0=1 if DEM_AGE>= 15 & inlist(MJJ_EMP_REL,1,4) 
replace   	F_MIE_PSCKLV_0=1 if DEM_AGE>= 15 & inlist(MJJ_EMP_REL,3,5) & MJJ_REM_TYP__1==1
tab      	F_MIE_PSCKLV_0, miss

* drop    	F_MIE_PSCKLV_1
generate  	F_MIE_PSCKLV_1=0
replace   	F_MIE_PSCKLV_1=1 if DEM_AGE>= 15 &   (F_MIE_PSCKLV_0==1) & !inlist(MIE_PSCKLV,1,2,97)
replace   	F_MIE_PSCKLV_1=2 if DEM_AGE>= 15 &   (F_MIE_PSCKLV_0==1) &  inlist(MIE_PSCKLV,0,.)
replace   	F_MIE_PSCKLV_1=3 if DEM_AGE>= 15 &  !(F_MIE_PSCKLV_0==1) & !inlist(MIE_PSCKLV,0,.)
replace  	F_MIE_PSCKLV_1=9 if DEM_AGE<  15 &                         !inlist(MIE_PSCKLV,0,.)

tab      	F_MIE_PSCKLV_0 F_MIE_PSCKLV_1, miss

* tab      	  MIE_PSCKLV if MIE_PSCKLV!=., miss


/***************************************************     MJU_INS     *****************************************/
* drop    	F_MJU_INS_0
generate  	F_MJU_INS_0=0
replace   	F_MJU_INS_0=0 
replace   	F_MJU_INS_0=1 if DEM_AGE>= 15 &   inlist(MJJ_EMP_REL,1,2,3,4,5) 
tab      	F_MJU_INS_0, miss

* drop    	F_MJU_INS_1
generate  	F_MJU_INS_1=0
replace   	F_MJU_INS_1=0
replace   	F_MJU_INS_1=1 if DEM_AGE>= 15 &    F_MJU_INS_0==1   & !inlist(MJU_INS,1,2,3,4,5,6)
replace   	F_MJU_INS_1=2 if DEM_AGE>= 15 &    F_MJU_INS_0==1   &  inlist(MJU_INS,.)
replace   	F_MJU_INS_1=3 if DEM_AGE>= 15 &  !(F_MJU_INS_0==1)  & !inlist(MJU_INS,.)
replace  	F_MJU_INS_1=9 if DEM_AGE<  15 &                       !inlist(MJU_INS,.)

tab      	F_MJU_INS_0 F_MJU_INS_1, miss
*tab      	  MJU_INS, miss


/***************************************************     MJU_PLC     *****************************************/
* drop    	F_MJU_PLC_0
generate  	F_MJU_PLC_0=0
replace   	F_MJU_PLC_0=1 if DEM_AGE>= 15 &   GLO_EMP==1
tab      	F_MJU_PLC_0

* drop    	F_MJU_PLC_1
generate  	F_MJU_PLC_1=0
replace   	F_MJU_PLC_1=1 if DEM_AGE>= 15 &   (F_MJU_PLC_0==1)  & !inlist(MJU_PLC,1,2,3,4,5,6,7,8,9,10,11,97)
replace   	F_MJU_PLC_1=2 if DEM_AGE>= 15 &   (F_MJU_PLC_0==1)  &  inlist(MJU_PLC,.)
replace   	F_MJU_PLC_1=3 if DEM_AGE>= 15 &  !(F_MJU_PLC_0==1)  & !inlist(MJU_PLC,.)
replace  	F_MJU_PLC_1=9 if DEM_AGE<  15 &                       !inlist(MJU_PLC,.)

tab      	F_MJU_PLC_0 F_MJU_PLC_1, miss

*tab      	  MJU_PLC, miss


/***************************************************     MJU_SIZ   *****************************************/
* drop    	F_MJU_SIZ_0
generate  	F_MJU_SIZ_0=0
replace   	F_MJU_SIZ_0=0
replace   	F_MJU_SIZ_0=1 if DEM_AGE>= 15 &  GLO_EMP==1 & MJU_INS!=1
tab      	F_MJU_SIZ_0

* drop    	F_MJU_SIZ_1
generate  	F_MJU_SIZ_1=0
replace 	F_MJU_SIZ_1=0
replace   	F_MJU_SIZ_1=1 if DEM_AGE>= 15 &   (F_MJU_SIZ_0==1)  & !inlist(MJU_SIZ,1,2,3,4,5,6,97)
replace   	F_MJU_SIZ_1=2 if DEM_AGE>= 15 &   (F_MJU_SIZ_0==1)  &  inlist(MJU_SIZ,.)
replace   	F_MJU_SIZ_1=3 if DEM_AGE>= 15 &  !(F_MJU_SIZ_0==1)  & !inlist(MJU_SIZ,.)
replace  	F_MJU_SIZ_1=9 if DEM_AGE<  15 &                       !inlist(MJU_SIZ,.)

tab      	F_MJU_SIZ_0 F_MJU_SIZ_1, miss

* tab      	  MJU_SIZ, miss



/***************************************************     MIS_REGI     *****************************************/
* drop    	F_MJL_REGI_0
generate  	F_MJL_REGI_0=0
replace   	F_MJL_REGI_0=0
replace   	F_MJL_REGI_0=1 if DEM_AGE>= 15 &  inlist(MJJ_EMP_REL,2,3)
replace   	F_MJL_REGI_0=1 if DEM_AGE>= 15 &  inlist(MJJ_EMP_REL,1,4,5) & inlist(MJU_INS,2,3) & MIE_SOCPRO==2
replace   	F_MJL_REGI_0=1 if DEM_AGE>= 15 &  inlist(MJJ_EMP_REL,1,4,5) & inlist(MJU_INS,2,3) & MIE_SOCPRO==97 & (inlist(MIE_PVACLV,2,97) | inlist(MIE_PSCKLV,2,97))
tab      	F_MJL_REGI_0, miss

* drop    	F_MIS_REGI_1
generate  	F_MJL_REGI_1=0
replace   	F_MJL_REGI_1=0
replace   	F_MJL_REGI_1=1 if DEM_AGE>= 15 &  (F_MJL_REGI_0==1)  & !inlist(MJL_REGI,1,2,97)
replace   	F_MJL_REGI_1=2 if DEM_AGE>= 15 &  (F_MJL_REGI_0==1)  &  inlist(MJL_REGI,.)
replace   	F_MJL_REGI_1=3 if DEM_AGE>= 15 & !(F_MJL_REGI_0==1)  & !inlist(MJL_REGI,.)
replace  	F_MJL_REGI_1=9 if DEM_AGE<  15 &                       !inlist(MJL_REGI,.)

tab      	F_MJL_REGI_0 F_MJL_REGI_1, miss

* tab      	 MJJ_EMP_REL MJL_REGI if GLO_EMP==1, miss
* tab      	 MJU_INS if F_MJL_REGI_0==0 & F_MJL_REGI_1==3, miss
* tab      	 MJJ_EMP_REL if F_MJL_REGI_0==0 & F_MJL_REGI_1==3, miss
* tab      	 MIE_SOCPRO if F_MJL_REGI_0==0 & F_MJL_REGI_1==3, miss
* tab    	 MIE_PVACLV MIE_PSCKLV if F_MJL_REGI_0==0 & F_MJL_REGI_1==3 & MIE_SOCPRO!=1,  miss
* tab    	 MIE_SOCPRO MJJ_REM_TYP__1 if F_MJL_REGI_0==0 & F_MJL_REGI_1==3 & MIE_SOCPRO!=1,  miss


/***************************************************     MJL_CORP     *****************************************/
* drop    	F_MJL_CORP_0
generate  	F_MJL_CORP_0=0
replace   	F_MJL_CORP_0=0
replace   	F_MJL_CORP_0=1 if DEM_AGE>= 15 &  MJJ_EMP_REL==2 & MJL_REGI==1
replace   	F_MJL_CORP_0=1 if DEM_AGE>= 15 &  MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,1,2) & MJL_REGI==1
tab      	F_MJL_CORP_0, miss

* drop    	F_MJL_CORP_1
generate  	F_MJL_CORP_1=0
replace   	F_MJL_CORP_1=0
replace   	F_MJL_CORP_1=1 if DEM_AGE>= 15 &    F_MJL_CORP_0==1   & !inlist(MJL_CORP,1,2,97)
replace   	F_MJL_CORP_1=2 if DEM_AGE>= 15 &    F_MJL_CORP_0==1   &  inlist(MJL_CORP,.)
replace   	F_MJL_CORP_1=3 if DEM_AGE>= 15 &  !(F_MJL_CORP_0==1)  & !inlist(MJL_CORP,.)
replace  	F_MJL_CORP_1=9 if DEM_AGE<  15                        & !inlist(MJL_CORP,.)

tab      	F_MJL_CORP_0 F_MJL_CORP_1, miss

* tab      	MJL_CORP, miss
* tab      	MJL_REGI MJL_CORP, miss


/***************************************************     MIS_REGP     *****************************************/
* drop    	F_MJL_REGP_0
generate  	F_MJL_REGP_0=0
replace   	F_MJL_REGP_0=0
replace   	F_MJL_REGP_0=1 if DEM_AGE>= 15 &  MJJ_EMP_REL==2 & inlist(MJL_REGI,2,97) & MJD_CONTROL__7!=1 & (MJD_CONTROL__1 ==1 | MJD_CONTROL__2 == 1)
replace   	F_MJL_REGP_0=1 if DEM_AGE>= 15 &  MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,1,2) & inlist(MJL_REGI,2,97) & MJD_CONTROL__7!=1 & (MJD_CONTROL__1 ==1 | MJD_CONTROL__2 == 1)
replace   	F_MJL_REGP_0=1 if DEM_AGE>= 15 &  MJJ_EMP_REL==1 & MJJ_REM_TYP__1!=1 & MIE_SOCPRO==2
replace   	F_MJL_REGP_0=1 if DEM_AGE>= 15 &  MJJ_EMP_REL==1 & MJJ_REM_TYP__1!=1 & MIE_SOCPRO==97 & (inlist(MIE_PVACLV,2,97) | inlist(MIE_PSCKLV,2,97))
 
tab      	F_MJL_REGP_0, miss

 
* drop    	F_MIS_REGP_1
generate  	F_MJL_REGP_1=0
replace   	F_MJL_REGP_1=0
replace   	F_MJL_REGP_1=1 if DEM_AGE>= 15 &  (F_MJL_REGP_0==1)  & !inlist(MJL_REGP,1,2,97)
replace   	F_MJL_REGP_1=2 if DEM_AGE>= 15 &  (F_MJL_REGP_0==1)  &  inlist(MJL_REGP,.)
replace   	F_MJL_REGP_1=3 if DEM_AGE>= 15 & !(F_MJL_REGP_0==1)  & !inlist(MJL_REGP,.)
replace  	F_MJL_REGP_1=9 if DEM_AGE<  15 &                       !inlist(MJL_REGP,.)

tab      	F_MJL_REGP_0 F_MJL_REGP_1, miss

list        MJL_REGP DEM_AGE MJJ_EMP_REL MJL_REGI MJD_CONTROL__7 MJJ_CFW_CHK MJJ_REM_TYP__1 MIE_SOCPRO MIE_PVACLV MIE_PSCKLV if F_MJL_REGP_0==1 & F_MJL_REGP_1==2

* tab      	 MIE_PVACLV MIE_PSCKLV if F_MJL_REGP_0==1 & F_MJL_REGP_1==2, miss
* tab      	 MIE_SOCPRO_a if F_MJL_REGP_0==1 & F_MJL_REGP_1==2, miss


/***************************************************     MIS_BOOK_TYP     *****************************************/
* drop    	F_MIS_BOOK_TYP_0
generate  	F_MIS_BOOK_TYP_0=0
replace   	F_MIS_BOOK_TYP_0=0 
replace   	F_MIS_BOOK_TYP_0=1 if DEM_AGE>= 15 & inlist(MJJ_EMP_REL,2,3)
replace   	F_MIS_BOOK_TYP_0=1 if DEM_AGE>= 15 & inlist(MJJ_EMP_REL,1,4,5) & inlist(MJU_INS,2,3) & MIE_SOCPRO==2
replace   	F_MIS_BOOK_TYP_0=1 if DEM_AGE>= 15 & inlist(MJJ_EMP_REL,1,4,5) & inlist(MJU_INS,2,3) & MIE_SOCPRO==97 & (inlist(MIE_PVACLV,2,97) | inlist(MIE_PSCKLV,2,97))
tab      	F_MIS_BOOK_TYP_0, miss


* drop    	F_MIS_BOOK_TYP_1
generate  	F_MIS_BOOK_TYP_1=0
replace   	F_MIS_BOOK_TYP_1=0
replace   	F_MIS_BOOK_TYP_1=1 if DEM_AGE>= 15 &   (F_MIS_BOOK_TYP_0==1)  & !inlist(MIS_BOOK_TYP,1,2,3,4,5,97)
replace   	F_MIS_BOOK_TYP_1=2 if DEM_AGE>= 15 &   (F_MIS_BOOK_TYP_0==1)  &  inlist(MIS_BOOK_TYP,.)
replace   	F_MIS_BOOK_TYP_1=3 if DEM_AGE>= 15 &  !(F_MIS_BOOK_TYP_0==1)  & !inlist(MIS_BOOK_TYP,.)
replace  	F_MIS_BOOK_TYP_1=9 if DEM_AGE<  15 &                            !inlist(MIS_BOOK_TYP,.)

tab      	F_MIS_BOOK_TYP_0 F_MIS_BOOK_TYP_1, miss

*
tab      	  MIE_SOCPRO if F_MIS_BOOK_TYP_0==0 & F_MIS_BOOK_TYP_1==3 , miss
tab      	  MIE_PVACLV MIE_PSCKLV if F_MIS_BOOK_TYP_0==0 & F_MIS_BOOK_TYP_1==3 , miss

/***************************************************     MIS_BOOK     *****************************************/
* drop    	F_MIS_BOOK_0
generate  	F_MIS_BOOK_0=0
replace   	F_MIS_BOOK_0=0 
replace   	F_MIS_BOOK_0=1 if DEM_AGE>= 15 & inlist(MJJ_EMP_REL,2,3)
replace   	F_MIS_BOOK_0=1 if DEM_AGE>= 15 & inlist(MJJ_EMP_REL,1,4,5) & inlist(MJU_INS,2,3) & MIE_SOCPRO==2
replace   	F_MIS_BOOK_0=1 if DEM_AGE>= 15 & inlist(MJJ_EMP_REL,1,4,5) & inlist(MJU_INS,2,3) & MIE_SOCPRO==97 & (inlist(MIE_PVACLV,2,97) | inlist(MIE_PSCKLV,2,97))
tab      	F_MIS_BOOK_0, miss

* drop    	F_MIS_BOOK_1
generate  	F_MIS_BOOK_1=0
replace   	F_MIS_BOOK_1=0
replace   	F_MIS_BOOK_1=1 if DEM_AGE>= 15 &   (F_MIS_BOOK_0==1)  & !inlist(MIS_BOOK,1,2,97)
replace   	F_MIS_BOOK_1=2 if DEM_AGE>= 15 &   (F_MIS_BOOK_0==1)  &  inlist(MIS_BOOK,.)
replace   	F_MIS_BOOK_1=3 if DEM_AGE>= 15 &  !(F_MIS_BOOK_0==1)  & !inlist(MIS_BOOK,.)
replace  	F_MIS_BOOK_1=9 if DEM_AGE<  15 &                        !inlist(MIS_BOOK,.)

tab      	  MIS_BOOK, mis

tab      	F_MIS_BOOK_0 F_MIS_BOOK_1, miss



/***************************************************     MIS_SOCPRO_DC_a    *****************************************/

* drop    	F_MIS_SOCPRO_DC_a_0
generate  	F_MIS_SOCPRO_DC_a_0=0
replace   	F_MIS_SOCPRO_DC_a_0=0
replace   	F_MIS_SOCPRO_DC_a_0=1 if DEM_AGE>= 15 & MJJ_EMP_REL==2 & (MJD_CONTROL__1==1 | MJD_CONTROL__2==1 )
tab      	F_MIS_SOCPRO_DC_a_0, miss

* drop    	F_MIS_SOCPRO_DC_a_1
generate  	F_MIS_SOCPRO_DC_a_1=0
replace   	F_MIS_SOCPRO_DC_a_1=0
replace   	F_MIS_SOCPRO_DC_a_1=1 if DEM_AGE>= 15 &   (F_MIS_SOCPRO_DC_a_0==1) & !inlist(MIS_SOCPRO_DC_a,1,2,97)
replace   	F_MIS_SOCPRO_DC_a_1=2 if DEM_AGE>= 15 &   (F_MIS_SOCPRO_DC_a_0==1) &  inlist(MIS_SOCPRO_DC_a,.)
replace   	F_MIS_SOCPRO_DC_a_1=3 if DEM_AGE>= 15 &  !(F_MIS_SOCPRO_DC_a_0==1) & !inlist(MIS_SOCPRO_DC_a,.)
replace  	F_MIS_SOCPRO_DC_a_1=9 if DEM_AGE<  15 &                              !inlist(MIS_SOCPRO_DC_a,.)   

tab      	F_MIS_SOCPRO_DC_a_0 F_MIS_SOCPRO_DC_a_1, miss


/***************************************************     MIS_SOCPRO_DC_b    *****************************************/

* drop    	F_MIS_SOCPRO_DC_b_0
generate  	F_MIS_SOCPRO_DC_b_0=0
replace   	F_MIS_SOCPRO_DC_b_0=0
replace   	F_MIS_SOCPRO_DC_b_0=1 if DEM_AGE>= 15 & MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,1,2) & (MJD_CONTROL__1==1 | MJD_CONTROL__2==1 )
tab      	F_MIS_SOCPRO_DC_b_0, miss

* drop    	F_MIS_SOCPRO_DC_b_1
generate  	F_MIS_SOCPRO_DC_b_1=0
replace   	F_MIS_SOCPRO_DC_b_1=0
replace   	F_MIS_SOCPRO_DC_b_1=1 if DEM_AGE>= 15 &   (F_MIS_SOCPRO_DC_b_0==1) & !inlist(MIS_SOCPRO_DC_b,1,2,97)
replace   	F_MIS_SOCPRO_DC_b_1=2 if DEM_AGE>= 15 &   (F_MIS_SOCPRO_DC_b_0==1) &  inlist(MIS_SOCPRO_DC_b,.)
replace   	F_MIS_SOCPRO_DC_b_1=3 if DEM_AGE>= 15 &  !(F_MIS_SOCPRO_DC_b_0==1) & !inlist(MIS_SOCPRO_DC_b,.)
replace  	F_MIS_SOCPRO_DC_b_1=9 if DEM_AGE<  15 &                              !inlist(MIS_SOCPRO_DC_b,.)   

tab      	F_MIS_SOCPRO_DC_b_0 F_MIS_SOCPRO_DC_b_1, miss


/***************************************************     MIS_SOCPRO_DC    *****************************************/

* drop    	F_MIS_SOCPRO_DC_0
generate  	F_MIS_SOCPRO_DC_0=0
replace   	F_MIS_SOCPRO_DC_0=0
replace   	F_MIS_SOCPRO_DC_0=1 if DEM_AGE>= 15 & MJJ_EMP_REL==2 & (MJD_CONTROL__1==1 | MJD_CONTROL__2==1 )
replace   	F_MIS_SOCPRO_DC_0=1 if DEM_AGE>= 15 & MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,1,2) & (MJD_CONTROL__1==1 | MJD_CONTROL__2==1 )

tab      	F_MIS_SOCPRO_DC_0, miss

* drop    	F_MIS_SOCPRO_DC_1
generate  	F_MIS_SOCPRO_DC_1=0
replace   	F_MIS_SOCPRO_DC_1=0
replace   	F_MIS_SOCPRO_DC_1=1 if DEM_AGE>= 15 &   (F_MIS_SOCPRO_DC_0==1) & !inlist(MIS_SOCPRO_DC,1,2,97)
replace   	F_MIS_SOCPRO_DC_1=2 if DEM_AGE>= 15 &   (F_MIS_SOCPRO_DC_0==1) &  inlist(MIS_SOCPRO_DC,.)
replace   	F_MIS_SOCPRO_DC_1=3 if DEM_AGE>= 15 &  !(F_MIS_SOCPRO_DC_0==1) & !inlist(MIS_SOCPRO_DC,.)
replace  	F_MIS_SOCPRO_DC_1=9 if DEM_AGE<  15 &                            !inlist(MIS_SOCPRO_DC,.)   

tab      	F_MIS_SOCPRO_DC_0 F_MIS_SOCPRO_DC_1, miss


/***************************************************     MIS_SOCPRO_CFW    *****************************************/

* drop    	F_MIS_SOCPRO_CFW_0
generate  	F_MIS_SOCPRO_CFW_0=0
replace   	F_MIS_SOCPRO_CFW_0=0
replace   	F_MIS_SOCPRO_CFW_0=1 if DEM_AGE>= 15 & MJJ_EMP_REL==3 & inlist(MJJ_CFW_CHK,3,4) & MJJ_REM_TYP__1!=1 
tab      	F_MIS_SOCPRO_CFW_0, miss

* drop    	F_MIS_SOCPRO_CFW_1
generate  	F_MIS_SOCPRO_CFW_1=0
replace   	F_MIS_SOCPRO_CFW_1=0
replace   	F_MIS_SOCPRO_CFW_1=1 if DEM_AGE>= 15 &   (F_MIS_SOCPRO_CFW_0==1) & !inlist(MIS_SOCPRO_CFW,1,2,97)
replace   	F_MIS_SOCPRO_CFW_1=2 if DEM_AGE>= 15 &   (F_MIS_SOCPRO_CFW_0==1) &  inlist(MIS_SOCPRO_CFW,.)
replace   	F_MIS_SOCPRO_CFW_1=3 if DEM_AGE>= 15 &  !(F_MIS_SOCPRO_CFW_0==1) & !inlist(MIS_SOCPRO_CFW,.)
replace  	F_MIS_SOCPRO_CFW_1=9 if DEM_AGE<  15 &                             !inlist(MIS_SOCPRO_CFW,.)   

tab      	F_MIS_SOCPRO_CFW_0 F_MIS_SOCPRO_CFW_1, miss


/***************************************************     MJT_SYR     *****************************************/


* drop    	F_MJT_SYR_0
generate  	F_MJT_SYR_0=0
replace   	F_MJT_SYR_0=0
replace   	F_MJT_SYR_0=1 if DEM_AGE>= 15 & GLO_EMP==1
tab      	F_MJT_SYR_0, miss

* drop    	F_MJT_SYR_1
generate  	F_MJT_SYR_1=0
replace   	F_MJT_SYR_1=0
replace   	F_MJT_SYR_1=1 if DEM_AGE>= 15 &    F_MJT_SYR_0==1  &  !inrange(MJT_SYR, year - DEM_AGE +10 , year) & MJT_SYR!=9997 
replace   	F_MJT_SYR_1=2 if DEM_AGE>= 15 &    F_MJT_SYR_0==1  &   inlist(MJT_SYR,.)
replace   	F_MJT_SYR_1=3 if DEM_AGE>= 15 &  !(F_MJT_SYR_0==1) &  !inlist(MJT_SYR,.)
replace  	F_MJT_SYR_1=9 if DEM_AGE<  15 &                       !inlist(MJT_SYR,.)

tab      	F_MJT_SYR_0 F_MJT_SYR_1, miss

list      	MJT_SYR DEM_AGE   if F_MJT_SYR_1==1

/***************************************************     MJT_SMO     *****************************************/


* drop    	F_MJT_SMO_0
generate  	F_MJT_SMO_0=0
replace   	F_MJT_SMO_0=1 if DEM_AGE>= 15 &   MJT_SYR !=. & MJT_SYR!=9997
tab      	F_MJT_SMO_0, miss

* drop    	F_MJT_SMO_1
generate  	F_MJT_SMO_1=0
replace   	F_MJT_SMO_1=1 if DEM_AGE>= 15 &   (F_MJT_SMO_0==1)  & !inrange(MJT_SMO,1,12) & MJT_SMO!=97  
replace   	F_MJT_SMO_1=2 if DEM_AGE>= 15 &   (F_MJT_SMO_0==1)  &   inlist(MJT_SMO,.)
replace   	F_MJT_SMO_1=3 if DEM_AGE>= 15 &  !(F_MJT_SMO_0==1)  &  !inlist(MJT_SMO,.)
replace  	F_MJT_SMO_1=9 if DEM_AGE<  15 &                        !inlist(MJT_SMO,.)

tab      	F_MJT_SMO_0 F_MJT_SMO_1, miss



*******************************************************************************************************************/
*
*            TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_MJB_0 ///
F_MJJ_MULT_0 ///
F_MJJ_OCC_TLE_0 ///
F_MJJ_OCC_MTD_0 ///
F_MJU_REF_0 ///
F_MJU_NAM_0 ///
F_MJU_MAC_0 ///
F_MJJ_EMP_REL_NAT_0 ///
F_MJJ_GRW_CHK_0 ///
F_MJJ_EMP_REL_0 ///
F_MJJ_CFW_CHK_0 ///
F_MJJ_HIRES_0 ///
F_MJJ_REM_TYP__1_0 ///
F_MJJ_REM_TYP__2_0 ///
F_MJJ_REM_TYP__3_0 ///
F_MJJ_REM_TYP__4_0 ///
F_MJJ_REM_TYP__5_0 ///
F_MJJ_REM_TYP__6_0 ///
F_MJJ_REM_TYP__7_0 ///
F_MJJ_REM_TYP__8_0 ///
F_MJJ_REM_TYP__9_0 ///
F_MJJ_REM_TYP_OTH_0 ///
F_MJD_SINGLE_CLIENT_0 ///
F_MJD_SOURCE_CLIENT_0 ///
F_MJD_SELL_CLIENT__1_0 ///
F_MJD_SELL_CLIENT__2_0 ///
F_MJD_SELL_CLIENT__3_0 ///
F_MJD_SELL_CLIENT__4_0 ///
F_MJD_CONTROL__1_0 ///
F_MJD_CONTROL__2_0 ///
F_MJD_CONTROL__7_0 ///
F_MJC_CONTRA_0 ///
F_MJC_CONOP_0 ///
F_MJC_TEMPTOTAL_0 ///
F_MJC_TEMPDUR_0 ///
F_MCD_TASKSE_0 ///
F_MCD_CONTHRS_a_0 ///
F_MCD_CONTHRS_b_0 ///
F_MCD_CONTHRS_0 ///
F_MCD_CONTHRS_NUM_0 ///
F_MCD_CONMIN_a_0 ///
F_MCD_CONMIN_b_0 ///
F_MCD_CONMIN_0 ///
F_MIE_SOCPRO_a_0 ///
F_MIE_SOCPRO_b_0 ///
F_MIE_SOCPRO_0 ///
F_MIE_SOCPRO_SELF_0 ///
F_MJJ_HINS_0 ///
F_MIE_PVACLV_0 ///
F_MIE_PSCKLV_0 ///
F_MJU_INS_0 ///
F_MJU_PLC_0 ///
F_MJU_SIZ_0 ///
F_MJL_REGI_0 ///
F_MJL_CORP_0 ///
F_MJL_REGP_0 ///
F_MIS_BOOK_TYP_0 ///
F_MIS_BOOK_0 ///
F_MIS_SOCPRO_DC_a_0 ///
F_MIS_SOCPRO_DC_b_0 ///
F_MIS_SOCPRO_DC_0 ///
F_MIS_SOCPRO_CFW_0 ///
F_MJT_SYR_0 ///
F_MJT_SMO_0


foreach var of varlist $List_F_MJB_0 {
    tab `var' if `var'>0 , miss
}

global List_F_MJB_1 ///
F_MJJ_MULT_1 ///
F_MJJ_OCC_TLE_1 ///
F_MJJ_OCC_MTD_1 ///
F_MJU_REF_1 ///
F_MJU_NAM_1 ///
F_MJU_MAC_1 ///
F_MJJ_EMP_REL_NAT_1 ///
F_MJJ_GRW_CHK_1 ///
F_MJJ_EMP_REL_1 ///
F_MJJ_CFW_CHK_1 ///
F_MJJ_HIRES_1 ///
F_MJJ_REM_TYP__1_1 ///
F_MJJ_REM_TYP__2_1 ///
F_MJJ_REM_TYP__3_1 ///
F_MJJ_REM_TYP__4_1 ///
F_MJJ_REM_TYP__5_1 ///
F_MJJ_REM_TYP__6_1 ///
F_MJJ_REM_TYP__7_1 ///
F_MJJ_REM_TYP__8_1 ///
F_MJJ_REM_TYP__9_1 ///
F_MJJ_REM_TYP_OTH_1 ///
F_MJD_SINGLE_CLIENT_1 ///
F_MJD_SOURCE_CLIENT_1 ///
F_MJD_SELL_CLIENT__1_1 ///
F_MJD_SELL_CLIENT__2_1 ///
F_MJD_SELL_CLIENT__3_1 ///
F_MJD_SELL_CLIENT__4_1 ///
F_MJD_CONTROL__1_1 ///
F_MJD_CONTROL__2_1 ///
F_MJD_CONTROL__7_1 ///
F_MJC_CONTRA_1 ///
F_MJC_CONOP_1 ///
F_MJC_TEMPTOTAL_1 ///
F_MJC_TEMPDUR_1 ///
F_MCD_TASKSE_1 ///
F_MCD_CONTHRS_a_1 ///
F_MCD_CONTHRS_b_1 ///
F_MCD_CONTHRS_1 ///
F_MCD_CONTHRS_NUM_1 ///
F_MCD_CONMIN_a_1 ///
F_MCD_CONMIN_b_1 ///
F_MCD_CONMIN_1 ///
F_MIE_SOCPRO_a_1 ///
F_MIE_SOCPRO_b_1 ///
F_MIE_SOCPRO_1 ///
F_MIE_SOCPRO_SELF_1 ///
F_MJJ_HINS_1 ///
F_MIE_PVACLV_1 ///
F_MIE_PSCKLV_1 ///
F_MJU_INS_1 ///
F_MJU_PLC_1 ///
F_MJU_SIZ_1 ///
F_MJL_REGI_1 ///
F_MJL_CORP_1 ///
F_MJL_REGP_1 ///
F_MIS_BOOK_TYP_1 ///
F_MIS_BOOK_1 ///
F_MIS_SOCPRO_DC_a_1 ///
F_MIS_SOCPRO_DC_b_1 ///
F_MIS_SOCPRO_DC_1 ///
F_MIS_SOCPRO_CFW_1 ///
F_MJT_SYR_1 ///
F_MJT_SMO_1

foreach var of varlist $List_F_MJB_1 {
    tab `var' if `var'!=. , miss
}
