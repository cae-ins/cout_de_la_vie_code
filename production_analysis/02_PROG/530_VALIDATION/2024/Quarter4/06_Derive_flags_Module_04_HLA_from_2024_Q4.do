*******************************************************************************************************************
*
* DERIVE FLAGS TO HIGHLIGH PROBLEMS WITH QUESTIONS AND SECTIONS
* 
*******************************************************************************************************************

/* COdes
1 - out of range
2 - missing: to impute
3 - undue wrong filter: to delete//
9 - undue < 15: to delete
*/


/* SECTION HLL  */
*******************************************************************************************************************
*******************************************************************************************************************
***                                                                                                             ***
***                     CHECK ON THE HLL - HOUSEHOLD LIVELIHOOD, AGRICULTURE AND CHARACTERISTICS                ***
***                                                                                                             *** 
*******************************************************************************************************************
*******************************************************************************************************************



/********************************************************      SRH_START_MODULE    ********************************************/
* drop    	F_HLA_START_MODULE_0
generate  	F_HLA_START_MODULE_0=0
replace  	F_HLA_START_MODULE_0=0
replace   	F_HLA_START_MODULE_0=1
tab      	F_HLA_START_MODULE_0

generate  	F_HLA_START_MODULE_1=0
replace   	F_HLA_START_MODULE_1=1 if F_HLA_START_MODULE_0 != HLA_START_MODULE 
tab      	F_HLA_START_MODULE_1, miss	


/********************************************************      HLL_SRC      ********************************************/
 *created this variable on the 7 Oct 2023 as a place holder for HLL_SRC to run in the 
 
 *drop    HLL_SRC
generate  HLL_SRC_1=0 

replace   HLL_SRC_1=1 if HLL_SRC__1==1 
replace   HLL_SRC_1=2 if HLL_SRC__2==1 
replace   HLL_SRC_1=3 if HLL_SRC__3==1 
replace   HLL_SRC_1=4 if HLL_SRC__4==1 
replace   HLL_SRC_1=5 if HLL_SRC__5==1 
replace   HLL_SRC_1=6 if HLL_SRC__6==1 
replace   HLL_SRC_1=7 if HLL_SRC__7==1 
replace   HLL_SRC_1=8 if HLL_SRC__8==1 
replace   HLL_SRC_1=9 if HLL_SRC__9==1 
replace   HLL_SRC_1=10 if HLL_SRC__10==1 
replace   HLL_SRC_1=11 if HLL_SRC__11==1 
replace   HLL_SRC_1=12 if HLL_SRC__12==1 
replace   HLL_SRC_1=997 if HLL_SRC__997==1
replace   HLL_SRC_1=998 if (HLL_SRC__997==. & HLL_SRC__12==. & HLL_SRC__11==. & HLL_SRC__10==. & HLL_SRC__9==.  ///
                             & HLL_SRC__8==.  & HLL_SRC__7==. &  HLL_SRC__6==. &  HLL_SRC__5==. & HLL_SRC__4==. ///
							 & HLL_SRC__3==. & HLL_SRC__2==. & HLL_SRC__1==.) ///
							 |(HLL_SRC__997==.a & HLL_SRC__12==.a & HLL_SRC__11==.a & HLL_SRC__10==.a & HLL_SRC__9==.a  ///
							 & HLL_SRC__8==.a &  HLL_SRC__7==.a   & HLL_SRC__6==.a &  HLL_SRC__5==.a & HLL_SRC__4==.a ///
							 & HLL_SRC__3==.a & HLL_SRC__2==.a & HLL_SRC__1==.a)
tab       HLL_SRC_1, miss


/********************************************************      HLL_SRC      ********************************************/
 *created this variable on the 7 Oct 2023 as a place holder for HLL_SRC to run in the 
 *and to capture the errors, cab be reviewed as different from other flags
 
*drop    F_HLL_SRC_0
generate  F_HLL_SRC_0=0
replace   F_HLL_SRC_0=1  if PPNO==1 

generate  F_HLL_SRC_1=0
replace   F_HLL_SRC_1=1 if PPNO==1 & (!inrange(HLL_SRC_1,1,12) &  (HLL_SRC__997!=.))
replace   F_HLL_SRC_1=2 if PPNO==1 & (inrange(HLL_SRC_1,1,12)) &  (HLL_SRC__997==.)
replace   F_HLL_SRC_1=3 if PPNO==1 & (!inrange(HLL_SRC_1,1,12))& !(HLL_SRC__997==.)
replace   F_HLL_SRC_1=9 if PPNO==1 & DEM_AGE <15
tab       F_HLL_SRC_1, miss     

/********************************************************      HLL_SRC_OTH        ********************************************/
* drop    F_HLL_SRC_OTH_0
generate  F_HLL_SRC_OTH_0=0
replace   F_HLL_SRC_OTH_0=1 if HLL_SRC==12

* drop    F_HLL_SRC_OTH_1
generate  F_HLL_SRC_OTH_1=0
replace   F_HLL_SRC_OTH_1=1 if F_HLL_SRC_OTH_0==1 & (HLL_SRC_OTH>="0" & HLL_SRC_OTH<="9999999999999999")
replace   F_HLL_SRC_OTH_1=2 if F_HLL_SRC_OTH_0==1 & (HLL_SRC_OTH=="")
replace   F_HLL_SRC_OTH_1=3 if !(F_HLL_SRC_OTH_0==1) & (HLL_SRC_OTH!="")
*replace   F_HLL_SRC_OTH_1=9 if DEM_AGE>= 15 & HLL_SRC_OTH==1 & !inlist(HLL_SRC_OTH,0,.)
tab       F_HLL_SRC_OTH_1 , miss

/********************************************************      HLL_SMN        ********************************************/
* drop    F_HLL_SMN_0=0
generate  F_HLL_SMN_0=0 
replace   F_HLL_SMN_0=1 if  HLA_START_MODULE==1


* drop    F_HLL_SMN_1
generate  F_HLL_SMN_1=0
replace   F_HLL_SMN_1=1 if F_HLL_SMN_0==1  & inrange(HLL_SMN,1,12) | HLL_SMN ==997
replace   F_HLL_SMN_1=2 if F_HLL_SMN_0==1  &   inlist(HLL_SMN,0,.)
replace   F_HLL_SMN_1=3 if !(F_HLL_SMN_0==1) &  !inlist(HLL_SMN,0,.)
*replace   F_HLL_SMN_1=9 if DEM_AGE>= 15 & HLL_SMN ==1 & !inlist(HLL_SMN ,0,.)
tab       F_HLL_SMN_1 , miss

/********************************************************      HLL_SMN_OTH        ********************************************/
* drop    F_HLL_SMN_OTH_0
generate  F_HLL_SMN_OTH_0=0
replace   F_HLL_SMN_OTH_0=1 if HLL_SMN==12

* drop    F_HLL_SMN_OTH_1
generate  F_HLL_SMN_OTH_1=0
replace   F_HLL_SMN_OTH_1=1 if F_HLL_SMN_OTH_0==1 & (HLL_SMN_OTH>="0" & HLL_SMN_OTH<="9999999999999999")
replace   F_HLL_SMN_OTH_1=2 if F_HLL_SMN_OTH_0==1 & (HLL_SMN_OTH=="")
replace   F_HLL_SMN_OTH_1=3 if !(F_HLL_SMN_OTH_0==1) & (HLL_SMN_OTH!="")
*replace   F_HLL_SMN_OTH_1=9 if DEM_AGE>= 15 & HLL_SMN_OTH==1 & !inlist(HLL_SMN_OTH,0,.)
tab       F_HLL_SMN_OTH_1 , miss

/********************************************************      HAL_CRP     ********************************************/

* ¨drop    	F_HAL_CRP_0
generate  	F_HAL_CRP_0=0
replace   	F_HAL_CRP_0=1 if HLA_START_MODULE==1  
   
* ¨drop    	F_HAL_CRP_1
generate  	F_HAL_CRP_1=0
replace   	F_HAL_CRP_1=1 if F_HAL_CRP_0==1    & !inlist(HAL_CRP,1,2) 
replace   	F_HAL_CRP_1=2 if F_HAL_CRP_0==1    &  inlist(HAL_CRP,0,.)
replace   	F_HAL_CRP_1=3 if !(F_HAL_CRP_0==1) & !inlist(HAL_CRP,0,.)
replace  	F_HAL_CRP_1=9 if DEM_AGE<  15      & !inlist(HAL_CRP,0,.)
tab      	HAL_CRP, miss
tab      	F_HAL_CRP_1, miss


/********************************************************      HAL_LIV     ********************************************/

* ¨drop    	F_HAL_LIV_0
generate  	F_HAL_LIV_0=0
replace   	F_HAL_LIV_0=1 if HLA_START_MODULE==1  
   
* ¨drop    	F_HAL_LIV_1
generate  	F_HAL_LIV_1=0
replace   	F_HAL_LIV_1=1 if F_HAL_LIV_0==1    & !inlist(HAL_LIV,1,2) 
replace   	F_HAL_LIV_1=2 if F_HAL_LIV_0==1    &  inlist(HAL_LIV,0,.)
replace   	F_HAL_LIV_1=3 if !(F_HAL_LIV_0==1) & !inlist(HAL_LIV,0,.)
replace  	F_HAL_LIV_1=9 if DEM_AGE<  15      & !inlist(HAL_LIV,0,.)
tab      	HAL_LIV, miss
tab      	F_HAL_LIV_1, miss

/********************************************************      HAL_FSH     ********************************************/

* ¨drop    	F_HAL_FSH_0
generate  	F_HAL_FSH_0=0
replace   	F_HAL_FSH_0=1 if HLA_START_MODULE==1  
   
* ¨drop    	F_HAL_FSH_1
generate  	F_HAL_FSH_1=0
replace   	F_HAL_FSH_1=1 if F_HAL_FSH_0==1    & !inlist(HAL_FSH,1,2) 
replace   	F_HAL_FSH_1=2 if F_HAL_FSH_0==1    &  inlist(HAL_FSH,0,.)
replace   	F_HAL_FSH_1=3 if !(F_HAL_FSH_0==1) & !inlist(HAL_FSH,0,.)
replace  	F_HAL_FSH_1=9 if DEM_AGE<  15      & !inlist(HAL_FSH,0,.)
tab      	HAL_FSH, miss
tab      	F_HAL_FSH_1, miss

/********************************************************      HAL_MKT     ********************************************/

* ¨drop    	F_HAL_MKT_0
generate  	F_HAL_MKT_0=0
replace   	F_HAL_MKT_0=1 if HLA_START_MODULE==1 & (HAL_CRP==1 | HAL_LIV==1 | HAL_MKT==1)
   
* ¨drop    	F_HAL_MKT_1
generate  	F_HAL_MKT_1=0
replace   	F_HAL_MKT_1=1 if F_HAL_MKT_0==1    & !inlist(HAL_MKT,1,2,3,4,5) 
replace   	F_HAL_MKT_1=2 if F_HAL_MKT_0==1    &  inlist(HAL_MKT,0,.)
replace   	F_HAL_MKT_1=3 if !(F_HAL_MKT_0==1) & !inlist(HAL_MKT,0,.)
replace  	F_HAL_MKT_1=9 if DEM_AGE<  15      & !inlist(HAL_MKT,0,.)
tab      	HAL_MKT, miss
tab      	F_HAL_MKT_1, miss

/********************************************************      HAL_HIS     ********************************************/

* ¨drop    	F_HAL_HIS_0
generate  	F_HAL_HIS_0=0
replace   	F_HAL_HIS_0=1 if HLA_START_MODULE==1 & HAL_HIS == 5
   
* ¨drop    	F_HAL_HIS_1
generate  	F_HAL_HIS_1=0
replace   	F_HAL_HIS_1=1 if F_HAL_HIS_0==1    & !inlist(HAL_HIS,1,2,3,4) 
replace   	F_HAL_HIS_1=2 if F_HAL_HIS_0==1    &  inlist(HAL_HIS,0,.)
replace   	F_HAL_HIS_1=3 if !(F_HAL_HIS_0==1) & !inlist(HAL_HIS,0,.)
replace  	F_HAL_HIS_1=9 if DEM_AGE<  15      & !inlist(HAL_HIS,0,.)
tab      	HAL_HIS, miss
tab      	F_HAL_HIS_1, miss


/********************************************************      HAL_PNO     ********************************************/

* ¨drop    	F_HAL_PNO_0
generate  	F_HAL_PNO_0=0
replace   	F_HAL_PNO_0=1 if HLA_START_MODULE==1 & (HAL_CRP == 1 | HAL_LIV == 1 | HAL_FSH == 1)  & DEM_AGE>=15  
   
* ¨drop    	F_HAL_PNO_1
generate  	F_HAL_PNO_1=0
replace   	F_HAL_PNO_1=1 if F_HAL_PNO_0==1    & !inlist(HAL_PNO,1,2) 
replace   	F_HAL_PNO_1=2 if F_HAL_PNO_0==1    &  inlist(HAL_PNO,0,.)
replace   	F_HAL_PNO_1=3 if !(F_HAL_PNO_0==1) & !inlist(HAL_PNO,0,.)
replace  	F_HAL_PNO_1=9 if DEM_AGE<  15      & !inlist(HAL_PNO,0,.)
tab      	HAL_PNO, miss
tab      	F_HAL_PNO_1, miss

/********************************************************     HAL_PNO_DEC     ********************************************/
 
* ¨drop    	F_HAL_PNO_DEC_0
generate  	F_HAL_PNO_DEC_0=0
replace   	F_HAL_PNO_DEC_0=1 if HLA_START_MODULE==1 & (HAL_CRP == 1 | HAL_LIV == 1 | HAL_FSH == 1) & (DEM_REL!=6 & DEM_REL!=7 & DEM_AGE>=15) 
   
* ¨drop    	F_HAL_PNO_DEC_1
generate  	F_HAL_PNO_DEC_1=0
replace   	F_HAL_PNO_DEC_1=1 if F_HAL_PNO_DEC_0==1    & !inlist(HAL_PNO_DEC,1,2) 
replace   	F_HAL_PNO_DEC_1=2 if F_HAL_PNO_DEC_0==1    &  inlist(HAL_PNO_DEC,0,.)
replace   	F_HAL_PNO_DEC_1=3 if !(F_HAL_PNO_DEC_0==1) & !inlist(HAL_PNO_DEC,0,.)
replace  	F_HAL_PNO_DEC_1=9 if DEM_AGE<  15      & !inlist(HAL_PNO_DEC,0,.)
tab      	HAL_PNO_DEC, miss
tab      	F_HAL_PNO_DEC_1, miss


************************************HOUSEHOLD CHARACTERISTICS (HHC)***********************************************


/********************************************************     HHC_WALLS     ********************************************/

* drop    F_HHC_WALLS_0=0
generate  F_HHC_WALLS_0=0 
replace   F_HHC_WALLS_0=1 if HLA_START_MODULE==1


* drop    F_HHC_WALLS_1
generate  F_HHC_WALLS_1=0
replace   F_HHC_WALLS_1=1 if F_HHC_WALLS_0==1  & !inrange(HHC_WALLS,1,12)
replace   F_HHC_WALLS_1=2 if F_HHC_WALLS_0==1  &   inlist(HHC_WALLS,0,.)
replace   F_HHC_WALLS_1=3 if !(F_HHC_WALLS_0==1) &  !inlist(HHC_WALLS,0,.)
*replace   F_HHC_WALLS_1=9 if DEM_AGE>= 15 & HHC_WALLS ==1 & !inlist(HHC_WALLS ,0,.)
tab       F_HHC_WALLS_1 , miss

/********************************************************     HHC_WALLS_Makeshift    ********************************************/

* drop    F_HHC_WALLS_Makeshift_0
generate  F_HHC_WALLS_Makeshift_0=0
replace   F_HHC_WALLS_Makeshift_0=1 if HLA_START_MODULE==1 & HHC_WALLS==9

* drop    F_HHC_WALLS_Makeshift_1
generate  F_HHC_WALLS_Makeshift_1=0
replace   F_HHC_WALLS_Makeshift_1=1 if F_HHC_WALLS_Makeshift_0==1 & (HHC_WALLS_Makeshift>="0" & HHC_WALLS_Makeshift<="9999999999999999")
replace   F_HHC_WALLS_Makeshift_1=2 if F_HHC_WALLS_Makeshift_0==1 & (HHC_WALLS_Makeshift=="")
replace   F_HHC_WALLS_Makeshift_1=3 if !(F_HHC_WALLS_Makeshift_0==1) & (HHC_WALLS_Makeshift!="")
*replace   F_HHC_WALLS_Makeshift_1=9 if DEM_AGE>= 15 & HHC_WALLS_Makeshift==1 & !inlist(HHC_WALLS_Makeshift,0,.)
tab       F_HHC_WALLS_Makeshift_1 , miss

/********************************************************     HHC_WALLS_other     ********************************************/

* drop    F_HHC_WALLS_other_0
generate  F_HHC_WALLS_other_0=0
replace   F_HHC_WALLS_other_0=1 if HLA_START_MODULE==1 & HHC_WALLS==10

* drop    F_HHC_WALLS_other_1
generate  F_HHC_WALLS_other_1=0
replace   F_HHC_WALLS_other_1=1 if F_HHC_WALLS_other_0==1 & ( HHC_WALLS_other>="0" &  HHC_WALLS_other<="9999999999999999")
replace   F_HHC_WALLS_other_1=2 if F_HHC_WALLS_other_0==1 & ( HHC_WALLS_other=="")
replace   F_HHC_WALLS_other_1=3 if !(F_HHC_WALLS_other_0==1) & ( HHC_WALLS_other!="")
*replace   F_HHC_WALLS_other_1=9 if DEM_AGE>= 15 &  HHC_WALLS_other==1 & !inlist( HHC_WALLS_other,0,.)
tab       F_HHC_WALLS_other_1 , miss

/********************************************************    HHC_ROOF     ********************************************/

* drop    F_HHC_ROOF_0=0
generate  F_HHC_ROOF_0=0 
replace   F_HHC_ROOF_0=1 if HLA_START_MODULE==1


* drop    F_HHC_ROOF_1
generate  F_HHC_ROOF_1=0
replace   F_HHC_ROOF_1=1 if F_HHC_ROOF_0==1  & !inrange(HHC_ROOF,1,9)
replace   F_HHC_ROOF_1=2 if F_HHC_ROOF_0==1  &   inlist(HHC_ROOF,0,.)
replace   F_HHC_ROOF_1=3 if !(F_HHC_ROOF_0==1) &  !inlist(HHC_ROOF,0,.)
*replace   F_HHC_ROOF_1=9 if DEM_AGE>= 15 & HHC_ROOF ==1 & !inlist(HHC_ROOF ,0,.)
tab       F_HHC_ROOF_1 , miss

/********************************************************     HHC_ROOF_other     ********************************************/

* drop    F_HHC_ROOF_other_0
generate  F_HHC_ROOF_other_0=0
replace   F_HHC_ROOF_other_0=1 if HLA_START_MODULE==1 & HHC_ROOF==9

* drop    F_HHC_ROOF_other_1
generate  F_HHC_ROOF_other_1=0
replace   F_HHC_ROOF_other_1=1 if F_HHC_ROOF_other_0==1 & ( HHC_ROOF_other>="0" &  HHC_ROOF_other<="9999999999999999")
replace   F_HHC_ROOF_other_1=2 if F_HHC_ROOF_other_0==1 & ( HHC_ROOF_other=="")
replace   F_HHC_ROOF_other_1=3 if !(F_HHC_ROOF_other_0==1) & ( HHC_ROOF_other!="")
*replace   F_HHC_ROOF_other_1=9 if DEM_AGE>= 15 &  HHC_ROOF_other==1 & !inlist( HHC_ROOF_other,0,.)
tab       F_HHC_ROOF_other_1 , miss

/********************************************************    HHC_FLOOR     ********************************************/

* drop    F_HHC_FLOOR_0=0
generate  F_HHC_FLOOR_0=0 
replace   F_HHC_FLOOR_0=1 if HLA_START_MODULE==1


* drop    F_HHC_FLOOR_1
generate  F_HHC_FLOOR_1=0
replace   F_HHC_FLOOR_1=1 if F_HHC_FLOOR_0==1  & !inrange(HHC_FLOOR,1,8)
replace   F_HHC_FLOOR_1=2 if F_HHC_FLOOR_0==1  &   inlist(HHC_FLOOR,0,.)
replace   F_HHC_FLOOR_1=3 if !(F_HHC_FLOOR_0==1) &  !inlist(HHC_FLOOR,0,.)
*replace   F_HHC_FLOOR_1=9 if DEM_AGE>= 15 & HHC_FLOOR ==1 & !inlist(HHC_FLOOR ,0,.)
tab       F_HHC_FLOOR_1 , miss

/********************************************************     HHC_FLOOR_other     ********************************************/

* drop    F_HHC_FLOOR_other_0
generate  F_HHC_FLOOR_other_0=0
replace   F_HHC_FLOOR_other_0=1 if HLA_START_MODULE==1 & HHC_FLOOR==8

* drop    F_HHC_FLOOR_other_1
generate  F_HHC_FLOOR_other_1=0
replace   F_HHC_FLOOR_other_1=1 if F_HHC_FLOOR_other_0==1 & ( HHC_FLOOR_other>="0" &  HHC_FLOOR_other<="9999999999999999")
replace   F_HHC_FLOOR_other_1=2 if F_HHC_FLOOR_other_0==1 & ( HHC_FLOOR_other=="")
replace   F_HHC_FLOOR_other_1=3 if !(F_HHC_FLOOR_other_0==1) & ( HHC_FLOOR_other!="")
*replace   F_HHC_FLOOR_other_1=9 if DEM_AGE>= 15 &  HHC_FLOOR_other==1 & !inlist( HHC_FLOOR_other,0,.)
tab       F_HHC_FLOOR_other_1 , miss

/********************************************************    HHC_TYPE     ********************************************/

* drop    F_HHC_TYPE_0=0
generate  F_HHC_TYPE_0=0 
replace   F_HHC_TYPE_0=1 if HLA_START_MODULE==1


* drop    F_HHC_TYPE_1
generate  F_HHC_TYPE_1=0
replace   F_HHC_TYPE_1=1 if F_HHC_TYPE_0==1  & !inrange(HHC_TYPE,1,11)
replace   F_HHC_TYPE_1=2 if F_HHC_TYPE_0==1  &   inlist(HHC_TYPE,0,.)
replace   F_HHC_TYPE_1=3 if !(F_HHC_TYPE_0==1) &  !inlist(HHC_TYPE,0,.)
*replace   F_HHC_TYPE_1=9 if DEM_AGE>= 15 & HHC_TYPE ==1 & !inlist(HHC_TYPE ,0,.)
tab       F_HHC_TYPE_1 , miss

/********************************************************     HHC_TYPE_other     ********************************************/

* drop    F_HHC_TYPE_other_0
generate  F_HHC_TYPE_other_0=0
replace   F_HHC_TYPE_other_0=1 if HLA_START_MODULE==1 & HHC_TYPE==11

* drop    F_HHC_TYPE_other_1
generate  F_HHC_TYPE_other_1=0
replace   F_HHC_TYPE_other_1=1 if F_HHC_TYPE_other_0==1 & (HHC_TYPE_other>="0" &  HHC_TYPE_other<="9999999999999999")
replace   F_HHC_TYPE_other_1=2 if F_HHC_TYPE_other_0==1 & (HHC_TYPE_other=="")
replace   F_HHC_TYPE_other_1=3 if !(F_HHC_TYPE_other_0==1) & (HHC_TYPE_other!="")
*replace   F_HHC_TYPE_other_1=9 if DEM_AGE>= 15 &  HHC_TYPE_other==1 & !inlist( HHC_TYPE_other,0,.)
tab       F_HHC_TYPE_other_1 , miss

/********************************************************    HHC_OWNSHP     ********************************************/

* drop    F_HHC_OWNSHP_0=0
generate  F_HHC_OWNSHP_0=0 
replace   F_HHC_OWNSHP_0=1 if HLA_START_MODULE==1


* drop    F_HHC_OWNSHP_1
generate  F_HHC_OWNSHP_1=0
replace   F_HHC_OWNSHP_1=1 if F_HHC_OWNSHP_0==1  & !inrange(HHC_OWNSHP,1,9)
replace   F_HHC_OWNSHP_1=2 if F_HHC_OWNSHP_0==1  &   inlist(HHC_OWNSHP,0,.)
replace   F_HHC_OWNSHP_1=3 if !(F_HHC_OWNSHP_0==1) &  !inlist(HHC_OWNSHP,0,.)
*replace   F_HHC_OWNSHP_1=9 if DEM_AGE>= 15 & HHC_OWNSHP ==1 & !inlist(HHC_OWNSHP ,0,.)
tab       F_HHC_OWNSHP_1 , miss

/********************************************************     HHC_OWNSHP_other     ********************************************/

* drop    F_HHC_OWNSHP_other_0
generate  F_HHC_OWNSHP_other_0=0
replace   F_HHC_OWNSHP_other_0=1 if HLA_START_MODULE==1 & HHC_OWNSHP==8

* drop    F_HHC_OWNSHP_other_1
generate  F_HHC_OWNSHP_other_1=0
replace   F_HHC_OWNSHP_other_1=1 if F_HHC_OWNSHP_other_0==1 & (HHC_OWNSHP_other>="0" &  HHC_OWNSHP_other<="9999999999999999")
replace   F_HHC_OWNSHP_other_1=2 if F_HHC_OWNSHP_other_0==1 & (HHC_OWNSHP_other=="")
replace   F_HHC_OWNSHP_other_1=3 if !(F_HHC_OWNSHP_other_0==1) & (HHC_OWNSHP_other!="")
*replace   F_HHC_OWNSHP_other_1=9 if DEM_AGE>= 15 &  HHC_OWNSHP_other==1 & !inlist( HHC_OWNSHP_other,0,.)
tab       F_HHC_OWNSHP_other_1 , miss

/********************************************************     HHC_PAY     ********************************************/

* drop    F_HHC_PAY_0
generate  F_HHC_PAY_0=0
replace   F_HHC_PAY_0=1 if HLA_START_MODULE==1 & !inlist(HHC_OWNSHP,2,4,7)

* drop    F_HHC_PAY_1
generate  F_HHC_PAY_1=0
replace   F_HHC_PAY_1=1 if F_HHC_PAY_0==1 & !(HHC_PAY>=0 &  HHC_PAY<=50000)
replace   F_HHC_PAY_1=2 if F_HHC_PAY_0==1 & (HHC_PAY==0)
replace   F_HHC_PAY_1=3 if !(F_HHC_PAY_0==1) & (HHC_PAY!=0)
*replace   F_HHC_PAY_1=9 if DEM_AGE>= 15 &  HHC_PAY==1 & !inlist( HHC_PAY,0,.)
tab       F_HHC_PAY_1 , miss

/********************************************************     HHC_RENT     ********************************************/

* drop    F_HHC_RENT_0
generate  F_HHC_RENT_0=0
replace   F_HHC_RENT_0=1 if HLA_START_MODULE==1 & !inlist(HHC_OWNSHP,2,4,7)

* drop    F_HHC_RENT_1
generate  F_HHC_RENT_1=0
replace   F_HHC_RENT_1=1 if F_HHC_RENT_0==1 & !(HHC_RENT>=0 &  HHC_RENT<=50000)
replace   F_HHC_RENT_1=2 if F_HHC_RENT_0==1 & (HHC_RENT==0)
replace   F_HHC_RENT_1=3 if !(F_HHC_RENT_0==1) & (HHC_RENT!=0)
*replace   F_HHC_RENT_1=9 if DEM_AGE>= 15 &  HHC_RENT==1 & !inlist( HHC_RENT,0,.)
tab       F_HHC_RENT_1 , miss

/********************************************************    HHC_FUEL     ********************************************/

* drop    F_HHC_FUEL_0=0
generate  F_HHC_FUEL_0=0 
replace   F_HHC_FUEL_0=1 if HLA_START_MODULE==1


* drop    F_HHC_FUEL_1
generate  F_HHC_FUEL_1=0
replace   F_HHC_FUEL_1=1 if F_HHC_FUEL_0==1  & !inrange(HHC_FUEL,1,7)
replace   F_HHC_FUEL_1=2 if F_HHC_FUEL_0==1  &   inlist(HHC_FUEL,0,.)
replace   F_HHC_FUEL_1=3 if !(F_HHC_FUEL_0==1) &  !inlist(HHC_FUEL,0,.)
*replace   F_HHC_FUEL_1=9 if DEM_AGE>= 15 & HHC_FUEL ==1 & !inlist(HHC_FUEL ,0,.)
tab       F_HHC_FUEL_1 , miss

/********************************************************     HHC_FUEL_other     ********************************************/

* drop    F_HHC_FUEL_other_0
generate  F_HHC_FUEL_other_0=0
replace   F_HHC_FUEL_other_0=1 if HLA_START_MODULE==1 & HHC_FUEL==6

* drop    F_HHC_FUEL_other_1
generate  F_HHC_FUEL_other_1=0
replace   F_HHC_FUEL_other_1=1 if F_HHC_FUEL_other_0==1 & (HHC_FUEL_other>="0" &  HHC_FUEL_other<="9999999999999999")
replace   F_HHC_FUEL_other_1=2 if F_HHC_FUEL_other_0==1 & (HHC_FUEL_other=="")
replace   F_HHC_FUEL_other_1=3 if !(F_HHC_FUEL_other_0==1) & (HHC_FUEL_other!="")
*replace   F_HHC_FUEL_other_1=9 if DEM_AGE>= 15 &  HHC_FUEL_other==1 & !inlist( HHC_FUEL_other,0,.)
tab       F_HHC_FUEL_other_1 , miss

/********************************************************    HHC_WTR_SUP     ********************************************/

* drop    F_HHC_WTR_SUP_0=0
generate  F_HHC_WTR_SUP_0=0 
replace   F_HHC_WTR_SUP_0=1 if HLA_START_MODULE==1


* drop    F_HHC_WTR_SUP_1
generate  F_HHC_WTR_SUP_1=0
replace   F_HHC_WTR_SUP_1=1 if F_HHC_WTR_SUP_0==1  & !inrange(HHC_WTR_SUP,1,99)
replace   F_HHC_WTR_SUP_1=2 if F_HHC_WTR_SUP_0==1  &   inlist(HHC_WTR_SUP,0,.)
replace   F_HHC_WTR_SUP_1=3 if !(F_HHC_WTR_SUP_0==1) &  !inlist(HHC_WTR_SUP,0,.)
*replace   F_HHC_WTR_SUP_1=9 if DEM_AGE>= 15 & HHC_WTR_SUP ==1 & !inlist(HHC_WTR_SUP ,0,.)
tab       F_HHC_WTR_SUP_1 , miss

/********************************************************     HHC_WTR_SUP_other     ********************************************/

* drop    F_HHC_WTR_SUP_other_0
generate  F_HHC_WTR_SUP_other_0=0
replace   F_HHC_WTR_SUP_other_0=1 if HLA_START_MODULE==1 & HHC_WTR_SUP==88

* drop    F_HHC_WTR_SUP_other_1
generate  F_HHC_WTR_SUP_other_1=0
replace   F_HHC_WTR_SUP_other_1=1 if F_HHC_WTR_SUP_other_0==1 & (HHC_WTR_SUP_other>="0" &  HHC_WTR_SUP_other<="9999999999999999")
replace   F_HHC_WTR_SUP_other_1=2 if F_HHC_WTR_SUP_other_0==1 & (HHC_WTR_SUP_other=="")
replace   F_HHC_WTR_SUP_other_1=3 if !(F_HHC_WTR_SUP_other_0==1) & (HHC_WTR_SUP_other!="")
*replace   F_HHC_WTR_SUP_other_1=9 if DEM_AGE>= 15 &  HHC_WTR_SUP_other==1 & !inlist( HHC_WTR_SUP_other,0,.)
tab       F_HHC_WTR_SUP_other_1 , miss

/********************************************************    HHC_WTR_DRK     ********************************************/

* drop    F_HHC_WTR_DRK_0=0
generate  F_HHC_WTR_DRK_0=0 
replace   F_HHC_WTR_DRK_0=1 if HLA_START_MODULE==1


* drop    F_HHC_WTR_DRK_1
generate  F_HHC_WTR_DRK_1=0
replace   F_HHC_WTR_DRK_1=1 if F_HHC_WTR_DRK_0==1  & !inrange(HHC_WTR_DRK,1,88)
replace   F_HHC_WTR_DRK_1=2 if F_HHC_WTR_DRK_0==1  &   inlist(HHC_WTR_DRK,0,.)
replace   F_HHC_WTR_DRK_1=3 if !(F_HHC_WTR_DRK_0==1) &  !inlist(HHC_WTR_DRK,0,.)
*replace   F_HHC_WTR_DRK_1=9 if DEM_AGE>= 15 & HHC_WTR_DRK ==1 & !inlist(HHC_WTR_DRK ,0,.)
tab       F_HHC_WTR_DRK_1 , miss

/********************************************************     HHC_WTR_DRK_other     ********************************************/

* drop    F_HHC_WTR_DRK_other_0
generate  F_HHC_WTR_DRK_other_0=0
replace   F_HHC_WTR_DRK_other_0=1 if HLA_START_MODULE==1 & HHC_WTR_DRK==88

* drop    F_HHC_WTR_DRK_other_1
generate  F_HHC_WTR_DRK_other_1=0
replace   F_HHC_WTR_DRK_other_1=1 if F_HHC_WTR_DRK_other_0==1 & (HHC_WTR_DRK_other>="0" &  HHC_WTR_DRK_other<="9999999999999999")
replace   F_HHC_WTR_DRK_other_1=2 if F_HHC_WTR_DRK_other_0==1 & (HHC_WTR_DRK_other=="")
replace   F_HHC_WTR_DRK_other_1=3 if !(F_HHC_WTR_DRK_other_0==1) & (HHC_WTR_DRK_other!="")
*replace   F_HHC_WTR_DRK_other_1=9 if DEM_AGE>= 15 &  HHC_WTR_DRK_other==1 & !inlist( HHC_WTR_DRK_other,0,.)
tab       F_HHC_WTR_DRK_other_1 , miss


/********************************************************    HHC_TOILT_TYP     ********************************************/

* drop    F_HHC_TOILT_TYP_0=0
generate  F_HHC_TOILT_TYP_0=0 
replace   F_HHC_TOILT_TYP_0=1 if HLA_START_MODULE==1


* drop    F_HHC_TOILT_TYP_1
generate  F_HHC_TOILT_TYP_1=0
replace   F_HHC_TOILT_TYP_1=1 if F_HHC_TOILT_TYP_0==1  & !inrange(HHC_TOILT_TYP,1,7)
replace   F_HHC_TOILT_TYP_1=2 if F_HHC_TOILT_TYP_0==1  &   inlist(HHC_TOILT_TYP,0,.)
replace   F_HHC_TOILT_TYP_1=3 if !(F_HHC_TOILT_TYP_0==1) &  !inlist(HHC_TOILT_TYP,0,.)
*replace   F_HHC_TOILT_TYP_1=9 if DEM_AGE>= 15 & HHC_TOILT_TYP ==1 & !inlist(HHC_TOILT_TYP ,0,.)
tab       F_HHC_TOILT_TYP_1 , miss

/********************************************************     HHC_TOILT_TYP_other     ********************************************/

* drop    F_HHC_TOILT_TYP_other_0
generate  F_HHC_TOILT_TYP_other_0=0
replace   F_HHC_TOILT_TYP_other_0=1 if HLA_START_MODULE==1 & HHC_TOILT_TYP==7

* drop    F_HHC_TOILT_TYP_other_1
generate  F_HHC_TOILT_TYP_other_1=0
replace   F_HHC_TOILT_TYP_other_1=1 if F_HHC_TOILT_TYP_other_0==1 & (HHC_TOILT_TYP_other>="0" &  HHC_TOILT_TYP_other<="9999999999999999")
replace   F_HHC_TOILT_TYP_other_1=2 if F_HHC_TOILT_TYP_other_0==1 & (HHC_TOILT_TYP_other=="")
replace   F_HHC_TOILT_TYP_other_1=3 if !(F_HHC_TOILT_TYP_other_0==1) & (HHC_TOILT_TYP_other!="")
*replace   F_HHC_TOILT_TYP_other_1=9 if DEM_AGE>= 15 &  HHC_TOILT_TYP_other==1 & !inlist( HHC_TOILT_TYP_other,0,.)
tab       F_HHC_TOILT_TYP_other_1 , miss


/*/********************************************************      HHC_FACIL_SH     ********************************************/


 *drop    HHC_FACIL_SH
generate  HHC_FACIL_SH_1=0

replace   HHC_FACIL_SH_1=1 if HHC_FACIL_SH__1==1 
replace   HHC_FACIL_SH_1=2 if HHC_FACIL_SH__2==1 
replace   HHC_FACIL_SH_1=3 if HHC_FACIL_SH__3==1 
replace   HHC_FACIL_SH_1=4 if HHC_FACIL_SH__4==1 
replace   HHC_FACIL_SH_1=5 if HHC_FACIL_SH__5==1 
replace   HHC_FACIL_SH_1=6 if HHC_FACIL_SH__6==1 
replace   HHC_FACIL_SH_1=7 if ((HHC_FACIL_SH__6==. & HHC_FACIL_SH__5==. & HHC_FACIL_SH__4==. & HHC_FACIL_SH__3==. & HHC_FACIL_SH__2==. & HHC_FACIL_SH__1==.)|(HHC_FACIL_SH__6==.a & HHC_FACIL_SH__5==.a & HHC_FACIL_SH__4==.a & HHC_FACIL_SH__3==.a & HHC_FACIL_SH__2==.a & HHC_FACIL_SH__1==.a))
tab       HHC_FACIL_SH_1, miss
*br if HHC_FACIL_SH==0 | HHC_FACIL_SH==4 | HHC_FACIL_SH==5      

/********************************************************   HHC_FACIL_SH     ********************************************/

*drop    F_HHC_FACIL_SH_1
generate  F_HHC_FACIL_SH_1=0

replace   F_HHC_FACIL_SH_1=1 if (inrange(HHC_FACIL_SH_1,1,2,3,4,5)|(HHC_FACIL_SH__1==1|HHC_FACIL_SH__2==1|HHC_FACIL_SH__3==1|HHC_FACIL_SH__4==1|HHC_FACIL_SH__5==1)) & HHC_FACIL_SH__6==1 
replace   F_HHC_FACIL_SH_1=2 if (inrange(HHC_FACIL_SH_1,1,2,3,4,5)|(HHC_FACIL_SH__1==1 |HHC_FACIL_SH__2==1)) | HHC_FACIL_SH__3==1 | HHC_FACIL_SH__4==1 | HHC_FACIL_SH__5==1)) & HHC_FACIL_SH__7==1  
replace   F_HHC_FACIL_SH_1=3 if !inrange(HHC_FACIL_SH_1,1,6)
replace   F_HHC_FACIL_SH_1=9 if inlist(HHC_FACIL_SH_1,0,.,.a)
tab       F_HHC_FACIL_SH_1, miss    */

/********************************************************    HHC_ELEC     ********************************************/

* drop    F_HHC_ELEC_0=0
generate  F_HHC_ELEC_0=0 
replace   F_HHC_ELEC_0=1 if HLA_START_MODULE==1


* drop    F_HHC_ELEC_1
generate  F_HHC_ELEC_1=0
replace   F_HHC_ELEC_1=1 if F_HHC_ELEC_0==1  & !inrange(HHC_ELEC,1,9)
replace   F_HHC_ELEC_1=2 if F_HHC_ELEC_0==1  &   inlist(HHC_ELEC,0,.)
replace   F_HHC_ELEC_1=3 if !(F_HHC_ELEC_0==1) &  !inlist(HHC_ELEC,0,.)
*replace   F_HHC_ELEC_1=9 if DEM_AGE>= 15 & HHC_ELEC ==1 & !inlist(HHC_ELEC ,0,.)
tab       F_HHC_ELEC_1 , miss

/********************************************************     HHC_ELEC_other     ********************************************/

* drop    F_HHC_ELEC_other_0
generate  F_HHC_ELEC_other_0=0
replace   F_HHC_ELEC_other_0=1 if HLA_START_MODULE==1 & HHC_ELEC==8

* drop    F_HHC_ELEC_other_1
generate  F_HHC_ELEC_other_1=0
replace   F_HHC_ELEC_other_1=1 if F_HHC_ELEC_other_0==1 & (HHC_ELEC_other>="0" &  HHC_ELEC_other<="9999999999999999")
replace   F_HHC_ELEC_other_1=2 if F_HHC_ELEC_other_0==1 & (HHC_ELEC_other=="")
replace   F_HHC_ELEC_other_1=3 if !(F_HHC_ELEC_other_0==1) & (HHC_ELEC_other!="")
*replace   F_HHC_ELEC_other_1=9 if DEM_AGE>= 15 &  HHC_ELEC_other==1 & !inlist( HHC_ELEC_other,0,.)
tab       F_HHC_ELEC_other_1 , miss

/********************************************************     HHC_ROOMS     ********************************************/

* drop    F_HHC_ROOMS_0
generate  F_HHC_ROOMS_0=0
replace   F_HHC_ROOMS_0=1 if HLA_START_MODULE==1 & inrange(HHC_ROOMS,0,15)

* drop    F_HHC_ROOMS_1
generate  F_HHC_ROOMS_1=0
replace   F_HHC_ROOMS_1=1 if F_HHC_ROOMS_0==1 & !(HHC_ROOMS>=0 &  HHC_ROOMS<=15)
replace   F_HHC_ROOMS_1=2 if F_HHC_ROOMS_0==1 & (HHC_ROOMS==0)
replace   F_HHC_ROOMS_1=3 if !(F_HHC_ROOMS_0==1) & (HHC_ROOMS!=0)
*replace   F_HHC_ROOMS_1=9 if DEM_AGE>= 15 &  HHC_ROOMS==1 & !inlist( HHC_ROOMS,0,.)
tab       F_HHC_ROOMS_1 , miss

/********************************************************     HHC_BEDRM     ********************************************/

* drop    F_HHC_BEDRM_0
generate  F_HHC_BEDRM_0=0
replace   F_HHC_BEDRM_0=1 if HLA_START_MODULE==1 & inrange(HHC_BEDRM,0,15) & HHC_BEDRM<HHC_ROOMS

* drop    F_HHC_BEDRM_1
generate  F_HHC_BEDRM_1=0
replace   F_HHC_BEDRM_1=1 if F_HHC_BEDRM_0==1 & !(HHC_BEDRM>=0 &  HHC_BEDRM<=15)
replace   F_HHC_BEDRM_1=2 if F_HHC_BEDRM_0==1 & (HHC_BEDRM==0)
replace   F_HHC_BEDRM_1=3 if !(F_HHC_BEDRM_0==1) & (HHC_BEDRM!=0)
*replace   F_HHC_BEDRM_1=9 if DEM_AGE>= 15 &  HHC_BEDRM==1 & !inlist( HHC_BEDRM,0,.)
tab       F_HHC_BEDRM_1 , miss

********************************************************   HHC_INTERNT     ********************************************/

* drop    F_HHC_INTERNT_0=0
generate  F_HHC_INTERNT_0=0 
replace   F_HHC_INTERNT_0=1 if HLA_START_MODULE==1


* drop    F_HHC_INTERNT_1
generate  F_HHC_INTERNT_1=0
replace   F_HHC_INTERNT_1=1 if F_HHC_INTERNT_0==1  & !inrange(HHC_INTERNT,1,2)
replace   F_HHC_INTERNT_1=2 if F_HHC_INTERNT_0==1  &   inlist(HHC_INTERNT,0,.)
replace   F_HHC_INTERNT_1=3 if !(F_HHC_INTERNT_0==1) &  !inlist(HHC_INTERNT,0,.)
*replace   F_HHC_INTERNT_1=9 if DEM_AGE>= 15 &HHC_INTERNT ==1 & !inlist(HHC_INTERNT ,0,.)
tab       F_HHC_INTERNT_1 , miss

/*/********************************************************     HHC_OWN_ITEMS     ********************************************/

 *drop    F_HHC_OWN_ITEMS_1
generate  F_HHC_OWN_ITEMS_1=0

replace   F_HHC_OWN_ITEMS_1=1 if (inrange(HHC_OWN_ITEMS_1,1,12)|(HHC_OWN_ITEMS__1==1|HHC_OWN_ITEMS__2==1)) & HHC_OWN_ITEMS__3==1 
replace   F_HHC_OWN_ITEMS_1=2 if (inrange(HHC_OWN_ITEMS_1,1,2)|(HHC_OWN_ITEMS__1==1|HHC_OWN_ITEMS__2==1)) & HHC_OWN_ITEMS__4==1  
replace   F_HHC_OWN_ITEMS_1=3 if !inrange(HHC_OWN_ITEMS_1,1,5)
replace   F_HHC_OWN_ITEMS_1=4 if HHC_OWN_ITEMS__2==0 & HHC_OWN_ITEMS__4==1  
replace   F_HHC_OWN_ITEMS_1=9 if inlist(HHC_OWN_ITEMS_1,0,.,.a)
tab       F_HHC_OWN_ITEMS_1, miss       */

/********************************************************      HLA_END_MODULE    ********************************************/
* drop    	F_HLA_END_MODULE_0
generate  	F_HLA_END_MODULE_0=0
replace   	F_HLA_END_MODULE_0=1 if (DEM_AGE>= 15 & AGF_START_MODULE==1) 
*tab      	F_HLA_END_MODULE_0 

* drop    	F_HLA_END_MODULE_1
generate  	F_HLA_END_MODULE_1=0
replace   	F_HLA_END_MODULE_1=1 if DEM_AGE>= 15 & F_HLA_END_MODULE_0==1    &   !inlist(HLA_END_MODULE,0,1)
replace   	F_HLA_END_MODULE_1=2 if DEM_AGE>= 15 & F_HLA_END_MODULE_0==1    &    inlist(HLA_END_MODULE,0,.)
*replace   	F_HLA_END_MODULE_1=3 if DEM_AGE>= 15 & !(F_HLA_END_MODULE_0==1) &   !inlist(HLA_END_MODULE,0,.)
replace   	F_HLA_END_MODULE_1=9 if DEM_AGE< 15 &                               !inlist(HLA_END_MODULE,0,.)
tab      	F_HLA_END_MODULE_1, miss	


*******************************************************************************************************************
*
*            TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_HLA_0 ///
F_HLA_START_MODULE_0 ///
F_HLL_SRC__0 ///
F_HLL_SRC__1_0 ///
F_HLL_SRC__2_0 ///
F_HLL_SRC__3_0 ///
F_HLL_SRC__4_0 ///
F_HLL_SRC__5_0 ///
F_HLL_SRC__6_0 ///
F_HLL_SRC__7_0 ///
F_HLL_SRC__8_0 ///
F_HLL_SRC__9_0 ///
F_HLL_SRC__10_0 ///
F_HLL_SRC__11_0 ///
F_HLL_SRC__12_0 ///
F_HLL_SRC__997_0 ///
F_HLL_SRC_OTH_0 ///
F_HLL_SMN_0 ///
F_HLL_SMN_OTH_0 ///
F_HAL_CRP_0 ///
F_HAL_LIV_0 ///
F_HAL_FSH_0 ///
F_HAL_MKT_0 ///
F_HAL_HIS_0 ///
F_HAL_PNO_0 ///
F_HAL_PNO_DEC_0 ///
F_HHC_WALLS_0 ///
F_HHC_WALLS_Makeshift_0 ///
F_HHC_WALLS_other_0 ///
F_HHC_ROOF_0 ///
F_HHC_ROOF_other_0 ///
F_HHC_FLOOR_0 ///
F_HHC_FLOOR_other_0 ///
F_HHC_TYPE_0 ///
F_HHC_TYPE_other_0 ///
F_HHC_OWNSHP_0 ///
F_HHC_OWNSHP_other_0 ///
F_HHC_PAY_0 ///
F_HHC_RENT_0 ///
F_HHC_FUEL_0 ///
F_HHC_FUEL_other_0 ///
F_HHC_WTR_SUP_0 ///
F_HHC_WTR_SUP_other_0 ///
F_HHC_WTR_DRK_0 ///
F_HHC_WTR_DRK_other_0 ///
F_HHC_TOILT_TYP_0 ///
F_HHC_TOILT_TYP_other_0 ///
F_HHC_FACIL_SH__1_0 ///
F_HHC_FACIL_SH__2_0 ///
F_HHC_FACIL_SH__3_0 ///
F_HHC_FACIL_SH__4_0 ///
F_HHC_FACIL_SH__5_0 ///
F_HHC_FACIL_SH__6_0 ///
F_HHC_ELEC_0 ///
F_HHC_ELEC_other_0 ///
F_HHC_ROOMS_0 ///
F_HHC_BEDRM_0 ///
F_HHC_INTERNT_0 ///
F_HHC_OWN_ITEMS__1_0 ///
F_HHC_OWN_ITEMS__2_0 ///
F_HHC_OWN_ITEMS__3_0 ///
F_HHC_OWN_ITEMS__4_0 ///
F_HHC_OWN_ITEMS__5_0 ///
F_HHC_OWN_ITEMS__6_0 ///
F_HHC_OWN_ITEMS__7_0 ///
F_HHC_OWN_ITEMS__8_0 ///
F_HHC_OWN_ITEMS__9_0 ///
F_HHC_OWN_ITEMS__10_0 ///
F_HHC_OWN_ITEMS__11_0 ///
F_HHC_OWN_ITEMS__12_0 ///
F_HHC_OWN_ITEMS__13_0 ///
F_HHC_OWN_ITEMS__14_0 ///
F_HLA_END_MODULE_0 ///

foreach var of varlist $List_F_HLA_0 {
    tab `var' if `var'>0 , miss
}

global List_F_HLA_1 ///
F_HLA_START_MODULE_1 ///
F_HLL_SRC_)_1 ///
F_HLL_SRC__1_1 ///
F_HLL_SRC__2_1 ///
F_HLL_SRC__3_1 ///
F_HLL_SRC__4_1 ///
F_HLL_SRC__5_1 ///
F_HLL_SRC__6_1 ///
F_HLL_SRC__7_1 ///
F_HLL_SRC__8_1 ///
F_HLL_SRC__9_1 ///
F_HLL_SRC__11_1 ///
F_HLL_SRC__11_1 ///
F_HLL_SRC__12_1 ///
F_HLL_SRC__997_1 ///
F_HLL_SRC_OTH_1 ///
F_HLL_SMN_1 ///
F_HLL_SMN_OTH_1 ///
F_HAL_CRP_1 ///
F_HAL_LIV_1 ///
F_HAL_FSH_1 ///
F_HAL_MKT_1 ///
F_HAL_HIS_1 ///
F_HAL_PNO_1 ///
F_HAL_PNO_DEC_1 ///
F_HHC_WALLS_1 ///
F_HHC_WALLS_Makeshift_1 ///
F_HHC_WALLS_other_1 ///
F_HHC_ROOF_1 ///
F_HHC_ROOF_other_1 ///
F_HHC_FLOOR_1 ///
F_HHC_FLOOR_other_1 ///
F_HHC_TYPE_1 ///
F_HHC_TYPE_other_1 ///
F_HHC_OWNSHP_1 ///
F_HHC_OWNSHP_other_1 ///
F_HHC_PAY_1 ///
F_HHC_RENT_1 ///
F_HHC_FUEL_1 ///
F_HHC_FUEL_other_1 ///
F_HHC_WTR_SUP_1 ///
F_HHC_WTR_SUP_other_1 ///
F_HHC_WTR_DRK_1 ///
F_HHC_WTR_DRK_other_1 ///
F_HHC_TOILT_TYP_1 ///
F_HHC_TOILT_TYP_other_1 ///
F_HHC_FACIL_SH__1_1 ///
F_HHC_FACIL_SH__2_1 ///
F_HHC_FACIL_SH__3_1 ///
F_HHC_FACIL_SH__4_1 ///
F_HHC_FACIL_SH__5_1 ///
F_HHC_FACIL_SH__6_1 ///
F_HHC_ELEC_1 ///
F_HHC_ELEC_other_1 ///
F_HHC_ROOMS_1 ///
F_HHC_BEDRM_1 ///
F_HHC_INTERNT_1 ///
F_HHC_OWN_ITEMS__1_1 ///
F_HHC_OWN_ITEMS__2_1 ///
F_HHC_OWN_ITEMS__3_1 ///
F_HHC_OWN_ITEMS__4_1 ///
F_HHC_OWN_ITEMS__5_1 ///
F_HHC_OWN_ITEMS__6_1 ///
F_HHC_OWN_ITEMS__7_1 ///
F_HHC_OWN_ITEMS__8_1 ///
F_HHC_OWN_ITEMS__9_1 ///
F_HHC_OWN_ITEMS__11_1 ///
F_HHC_OWN_ITEMS__11_1 ///
F_HHC_OWN_ITEMS__12_1 ///
F_HHC_OWN_ITEMS__13_1 ///
F_HHC_OWN_ITEMS__14_1 ///
F_HLA_END_MODULE_1 ///

foreach var of varlist $List_F_HLA_1 {
    tab `var' if `var'>0 , miss
}
