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
***                     CHECK ON THE HFI - HOUSEHOLD: FOOD INSECURITY                      ***
***                                                                                                             *** 
*******************************************************************************************************************
*******************************************************************************************************************

/********************************************************      HFI_CONTINUE    ********************************************/

* drop    F_HFI_CONTINUE_0
generate  F_HFI_CONTINUE_0=0
replace	  F_HFI_CONTINUE_0=1 if HFI_START_MODULE==1
tab       F_HFI_CONTINUE_0

* drop    F_HFI_CONTINUE_1
generate  F_HFI_CONTINUE_1=0
replace   F_HFI_CONTINUE_1=1 if F_HFI_CONTINUE_0==1   & !inlist(HFI_CONTINUE,1,2)
replace   F_HFI_CONTINUE_1=2 if F_HFI_CONTINUE_0==1   &  inlist(HFI_CONTINUE,.,.a)
replace   F_HFI_CONTINUE_1=3 if !(F_HFI_CONTINUE_0==1)& inlist(HFI_CONTINUE,.,.a)
*replace   F_HFI_CONTINUE_1=9 if                     !inlist(HFI_CONTINUE,.,.a)
tab       F_HFI_CONTINUE_1, miss
tab       HFI_CONTINUE, miss

/********************************************************      HFI_START_MODULE    ********************************************/
* drop    	F_HFI_START_MODULE_0
generate  	F_HFI_START_MODULE_0=0
replace   	F_HFI_START_MODULE_0=1 if HFI_CONTINUE==1
tab      	F_HFI_START_MODULE_0 

* drop    	F_HFI_START_MODULE_1
generate  	F_HFI_START_MODULE_1=0
replace   	F_HFI_START_MODULE_1=1 if HFI_CONTINUE==1 & F_HFI_START_MODULE_0 != HFI_START_MODULE
tab      	F_HFI_START_MODULE_1, miss		
tab      	HFI_START_MODULE, miss

/********************************************************     HFI_PPNO      ********************************************/
* drop    F_HFI_PPNO_0
generate  F_HFI_PPNO_0=0
replace   F_HFI_PPNO_0=1 if HFI_START_MODULE==1 
tab       F_HFI_PPNO_0  

* drop    F_HFI_PPNO_1
generate  F_HFI_PPNO_1=0
replace   F_HFI_PPNO_1=1 if F_HFI_PPNO_0==1  &  !inrange(HFI_PPNO,1,25)
replace   F_HFI_PPNO_1=2 if F_HFI_PPNO_0==1  &   inlist(HFI_PPNO,0,.)
replace   F_HFI_PPNO_1=3 if !(F_HFI_PPNO_0==1)& !inlist(HFI_PPNO,0,.)
*replace   F_HFI_PPNO_1=9 if                     !inlist(HFI_PPNO,0,.)
tab       F_HFI_PPNO_1, miss

/********************************************************      HFI_NEF        ********************************************/
* drop    F_HFI_NEF_0
generate  F_HFI_NEF_0=0
replace	  F_HFI_NEF_0=1 if HFI_START_MODULE==1
tab       F_HFI_NEF_0

* drop    F_HFI_NEF_1
generate  F_HFI_NEF_1=0
replace   F_HFI_NEF_1=1 if F_HFI_NEF_0==1   & !inlist(HFI_NEF,0,1,98,99)
replace   F_HFI_NEF_1=2 if F_HFI_NEF_0==1   &  inlist(HFI_NEF,.)
*replace   F_HFI_NEF_1=3 if !(F_HFI_NEF_0==1)& !inlist(HFI_NEF,.)
*replace   F_HFI_NEF_1=9 if                  !inlist(HFI_NEF,.)
tab       F_HFI_NEF_1, miss
tab       HFI_NEF, miss


/********************************************************      HFI_NEF_a        ********************************************/
* drop    F_HFI_NEF_a_0
generate  F_HFI_NEF_a_0=0
replace	  F_HFI_NEF_a_0=1 if HFI_NEF==1
tab       F_HFI_NEF_a_0

* drop    F_HFI_NEF_a_1
generate  F_HFI_NEF_a_1=0
replace   F_HFI_NEF_a_1=1 if F_HFI_NEF_a_0==1   & !inlist(HFI_NEF_a,0,1,98,99)
replace   F_HFI_NEF_a_1=2 if F_HFI_NEF_a_0==1   &  inlist(HFI_NEF_a,.)
replace   F_HFI_NEF_a_1=3 if !(F_HFI_NEF_a_0==1)&  !inlist(HFI_NEF_a,.)
*replace   F_HFI_NEF_a_1=9 if                  !inlist(HFI_NEF_a,.)
tab       F_HFI_NEF_a_1, miss
tab       HFI_NEF_a, miss

/********************************************************      HFI_NEF_b       ********************************************/
* drop    HFI_NEF_b_0
generate  HFI_NEF_b_0=0
replace	  HFI_NEF_b_0=1 if HFI_NEF_a==1
tab       HFI_NEF_b_0

* drop    HFI_NEF_b_1
generate  HFI_NEF_b_1=0
replace   HFI_NEF_b_1=1 if HFI_NEF_b_0==1   & !inlist(HFI_NEF_b,0,1,98,99)
replace   HFI_NEF_b_1=2 if HFI_NEF_b_0==1   &  inlist(HFI_NEF_b,.)
replace   HFI_NEF_b_1=3 if !(HFI_NEF_b_0==1)&  !inlist(HFI_NEF_b,.)
*replace   HFI_NEF_b_1=9 if                  !inlist(HFI_NEF_b,.)
tab       HFI_NEF_b_1, miss
tab       HFI_NEF_b, miss


/********************************************************      HFI_UHN        ********************************************/
* drop    F_HFI_UHN_0
generate  F_HFI_UHN_0=0
replace	  F_HFI_UHN_0=1 if HFI_START_MODULE==1
tab       F_HFI_UHN_0

* drop    F_HFI_UHN_1
generate  F_HFI_UHN_1=0
replace   F_HFI_UHN_1=1 if F_HFI_UHN_0==1   & !inlist(HFI_UHN,0,1,98,99)
replace   F_HFI_UHN_1=2 if F_HFI_UHN_0==1   &  inlist(HFI_UHN,.)
*replace   F_HFI_UHN_1=3 if !(F_HFI_UHN_0==1)& !inlist(HFI_UHN,.)
*replace   F_HFI_UHN_1=9 if                  !inlist(HFI_UHN,.)
tab       F_HFI_UHN_1, miss
tab       HFI_UHN, miss


/********************************************************      HFI_UHN_a        ********************************************/
* drop    F_HFI_UHN_a_0
generate  F_HFI_UHN_a_0=0
replace	  F_HFI_UHN_a_0=1 if HFI_UHN==1
tab       F_HFI_UHN_a_0

* drop    F_HFI_UHN_a_1
generate  F_HFI_UHN_a_1=0
replace   F_HFI_UHN_a_1=1 if F_HFI_UHN_a_0==1   & !inlist(HFI_UHN_a,0,1,98,99)
replace   F_HFI_UHN_a_1=2 if F_HFI_UHN_a_0==1   &  inlist(HFI_UHN_a,.)
replace   F_HFI_UHN_a_1=3 if !(F_HFI_UHN_a_0==1)&  !inlist(HFI_UHN_a,.)
*replace   F_HFI_UHN_a_1=9 if                  !inlist(HFI_UHN_a,.)
tab       F_HFI_UHN_a_1, miss
tab       HFI_UHN_a, miss

/********************************************************      HFI_UHN_b       ********************************************/
* drop    HFI_UHN_b_0
generate  HFI_UHN_b_0=0
replace	  HFI_UHN_b_0=1 if HFI_UHN_a==1
tab       HFI_UHN_b_0

* drop    HFI_UHN_b_1
generate  HFI_UHN_b_1=0
replace   HFI_UHN_b_1=1 if HFI_UHN_b_0==1   & !inlist(HFI_UHN_b,0,1,98,99)
replace   HFI_UHN_b_1=2 if HFI_UHN_b_0==1   &  inlist(HFI_UHN_b,.)
replace   HFI_UHN_b_1=3 if !(HFI_UHN_b_0==1)&  !inlist(HFI_UHN_b,.)
*replace   HFI_UHN_b_1=9 if                  !inlist(HFI_UHN_b,.)
tab       HFI_UHN_b_1, miss
tab       HFI_UHN_b, miss


/********************************************************      HFI_OFK        ********************************************/
* drop    F_HFI_OFK_0
generate  F_HFI_OFK_0=0
replace	  F_HFI_OFK_0=1 if HFI_START_MODULE==1
tab       F_HFI_OFK_0

* drop    F_HFI_OFK_1
generate  F_HFI_OFK_1=0
replace   F_HFI_OFK_1=1 if F_HFI_OFK_0==1   & !inlist(HFI_OFK,0,1,98,99)
replace   F_HFI_OFK_1=2 if F_HFI_OFK_0==1   &  inlist(HFI_OFK,.)
*replace   F_HFI_OFK_1=3 if !(F_HFI_OFK_0==1)& !inlist(HFI_OFK,.)
*replace   F_HFI_OFK_1=9 if                  !inlist(HFI_OFK,.)
tab       F_HFI_OFK_1, miss
tab       HFI_OFK, miss


/********************************************************      HFI_OFK_a        ********************************************/
* drop    F_HFI_OFK_a_0
generate  F_HFI_OFK_a_0=0
replace	  F_HFI_OFK_a_0=1 if HFI_OFK==1
tab       F_HFI_OFK_a_0

* drop    F_HFI_OFK_a_1
generate  F_HFI_OFK_a_1=0
replace   F_HFI_OFK_a_1=1 if F_HFI_OFK_a_0==1   & !inlist(HFI_OFK_a,0,1,98,99)
replace   F_HFI_OFK_a_1=2 if F_HFI_OFK_a_0==1   &  inlist(HFI_OFK_a,.)
replace   F_HFI_OFK_a_1=3 if !(F_HFI_OFK_a_0==1)&  !inlist(HFI_OFK_a,.)
*replace   F_HFI_OFK_a_1=9 if                  !inlist(HFI_OFK_a,.)
tab       F_HFI_OFK_a_1, miss
tab       HFI_OFK_a, miss

/********************************************************      HFI_OFK_b       ********************************************/
* drop    HFI_OFK_b_0
generate  HFI_OFK_b_0=0
replace	  HFI_OFK_b_0=1 if HFI_OFK_a==1
tab       HFI_OFK_b_0

* drop    HFI_OFK_b_1
generate  HFI_OFK_b_1=0
replace   HFI_OFK_b_1=1 if HFI_OFK_b_0==1   & !inlist(HFI_OFK_b,0,1,98,99)
replace   HFI_OFK_b_1=2 if HFI_OFK_b_0==1   &  inlist(HFI_OFK_b,.)
replace   HFI_OFK_b_1=3 if !(HFI_OFK_b_0==1)&  !inlist(HFI_OFK_b,.)
*replace   HFI_OFK_b_1=9 if                  !inlist(HFI_OFK_b,.)
tab       HFI_OFK_b_1, miss
tab       HFI_OFK_b, miss

/********************************************************      HFI_SAM        ********************************************/
* drop    F_HFI_SAM_0
generate  F_HFI_SAM_0=0
replace	  F_HFI_SAM_0=1 if HFI_START_MODULE==1
tab       F_HFI_SAM_0

* drop    F_HFI_SAM_1
generate  F_HFI_SAM_1=0
replace   F_HFI_SAM_1=1 if F_HFI_SAM_0==1   & !inlist(HFI_SAM,0,1,98,99)
replace   F_HFI_SAM_1=2 if F_HFI_SAM_0==1   &  inlist(HFI_SAM,.)
*replace   F_HFI_SAM_1=3 if !(F_HFI_SAM_0==1)& !inlist(HFI_SAM,.)
*replace   F_HFI_SAM_1=9 if                  !inlist(HFI_SAM,.)
tab       F_HFI_SAM_1, miss
tab       HFI_SAM, miss


/********************************************************      HFI_SAM_a        ********************************************/
* drop    F_HFI_SAM_a_0
generate  F_HFI_SAM_a_0=0
replace	  F_HFI_SAM_a_0=1 if HFI_SAM==1
tab       F_HFI_SAM_a_0

* drop    F_HFI_SAM_a_1
generate  F_HFI_SAM_a_1=0
replace   F_HFI_SAM_a_1=1 if F_HFI_SAM_a_0==1   & !inlist(HFI_SAM_a,0,1,98,99)
replace   F_HFI_SAM_a_1=2 if F_HFI_SAM_a_0==1   &  inlist(HFI_SAM_a,.)
replace   F_HFI_SAM_a_1=3 if !(F_HFI_SAM_a_0==1)&  !inlist(HFI_SAM_a,.)
*replace   F_HFI_SAM_a_1=9 if                  !inlist(HFI_SAM_a,.)
tab       F_HFI_SAM_a_1, miss
tab       HFI_SAM_a, miss

/********************************************************      HFI_SAM_b       ********************************************/
* drop    HFI_SAM_b_0
generate  HFI_SAM_b_0=0
replace	  HFI_SAM_b_0=1 if HFI_SAM_a==1
tab       HFI_SAM_b_0

* drop    HFI_SAM_b_1
generate  HFI_SAM_b_1=0
replace   HFI_SAM_b_1=1 if HFI_SAM_b_0==1   & !inlist(HFI_SAM_b,0,1,98,99)
replace   HFI_SAM_b_1=2 if HFI_SAM_b_0==1   &  inlist(HFI_SAM_b,.)
replace   HFI_SAM_b_1=3 if !(HFI_SAM_b_0==1)&  !inlist(HFI_SAM_b,.)
*replace   HFI_SAM_b_1=9 if                  !inlist(HFI_SAM_b,.)
tab       HFI_SAM_b_1, miss
tab       HFI_SAM_b, miss

/********************************************************      HFI_LTS        ********************************************/
* drop    F_HFI_LTS_0
generate  F_HFI_LTS_0=0
replace	  F_HFI_LTS_0=1 if HFI_START_MODULE==1
tab       F_HFI_LTS_0

* drop    F_HFI_LTS_1
generate  F_HFI_LTS_1=0
replace   F_HFI_LTS_1=1 if F_HFI_LTS_0==1   & !inlist(HFI_LTS,0,1,98,99)
replace   F_HFI_LTS_1=2 if F_HFI_LTS_0==1   &  inlist(HFI_LTS,.)
*replace   F_HFI_LTS_1=3 if !(F_HFI_LTS_0==1)& !inlist(HFI_LTS,.)
*replace   F_HFI_LTS_1=9 if                  !inlist(HFI_LTS,.)
tab       F_HFI_LTS_1, miss
tab       HFI_LTS, miss


/********************************************************      HFI_LTS_a        ********************************************/
* drop    F_HFI_LTS_a_0
generate  F_HFI_LTS_a_0=0
replace	  F_HFI_LTS_a_0=1 if HFI_LTS==1
tab       F_HFI_LTS_a_0

* drop    F_HFI_LTS_a_1
generate  F_HFI_LTS_a_1=0
replace   F_HFI_LTS_a_1=1 if F_HFI_LTS_a_0==1   & !inlist(HFI_LTS_a,0,1,98,99)
replace   F_HFI_LTS_a_1=2 if F_HFI_LTS_a_0==1   &  inlist(HFI_LTS_a,.)
replace   F_HFI_LTS_a_1=3 if !(F_HFI_LTS_a_0==1)&  !inlist(HFI_LTS_a,.)
*replace   F_HFI_LTS_a_1=9 if                  !inlist(HFI_LTS_a,.)
tab       F_HFI_LTS_a_1, miss
tab       HFI_LTS_a, miss

/********************************************************      HFI_LTS_b       ********************************************/
* drop    HFI_LTS_b_0
generate  HFI_LTS_b_0=0
replace	  HFI_LTS_b_0=1 if HFI_LTS_a==1
tab       HFI_LTS_b_0

* drop    HFI_LTS_b_1
generate  HFI_LTS_b_1=0
replace   HFI_LTS_b_1=1 if HFI_LTS_b_0==1   & !inlist(HFI_LTS_b,0,1,98,99)
replace   HFI_LTS_b_1=2 if HFI_LTS_b_0==1   &  inlist(HFI_LTS_b,.)
replace   HFI_LTS_b_1=3 if !(HFI_LTS_b_0==1)&  !inlist(HFI_LTS_b,.)
*replace   HFI_LTS_b_1=9 if                  !inlist(HFI_LTS_b,.)
tab       HFI_LTS_b_1, miss
tab       HFI_LTS_b, miss

/********************************************************      HFI_ROF        ********************************************/
* drop    F_HFI_ROF_0
generate  F_HFI_ROF_0=0
replace	  F_HFI_ROF_0=1 if HFI_START_MODULE==1
tab       F_HFI_ROF_0

* drop    F_HFI_ROF_1
generate  F_HFI_ROF_1=0
replace   F_HFI_ROF_1=1 if F_HFI_ROF_0==1   & !inlist(HFI_ROF,0,1,98,99)
replace   F_HFI_ROF_1=2 if F_HFI_ROF_0==1   &  inlist(HFI_ROF,.)
*replace   F_HFI_ROF_1=3 if !(F_HFI_ROF_0==1)& !inlist(HFI_ROF,.)
*replace   F_HFI_ROF_1=9 if                  !inlist(HFI_ROF,.)
tab       F_HFI_ROF_1, miss
tab       HFI_ROF, miss


/********************************************************      HFI_ROF_a        ********************************************/
* drop    F_HFI_ROF_a_0
generate  F_HFI_ROF_a_0=0
replace	  F_HFI_ROF_a_0=1 if HFI_ROF==1
tab       F_HFI_ROF_a_0

* drop    F_HFI_ROF_a_1
generate  F_HFI_ROF_a_1=0
replace   F_HFI_ROF_a_1=1 if F_HFI_ROF_a_0==1   & !inlist(HFI_ROF_a,0,1,98,99)
replace   F_HFI_ROF_a_1=2 if F_HFI_ROF_a_0==1   &  inlist(HFI_ROF_a,.)
replace   F_HFI_ROF_a_1=3 if !(F_HFI_ROF_a_0==1)&  !inlist(HFI_ROF_a,.)
*replace   F_HFI_ROF_a_1=9 if                  !inlist(HFI_ROF_a,.)
tab       F_HFI_ROF_a_1, miss
tab       HFI_ROF_a, miss

/********************************************************      HFI_ROF_b       ********************************************/
* drop    HFI_ROF_b_0
generate  HFI_ROF_b_0=0
replace	  HFI_ROF_b_0=1 if HFI_ROF_a==1
tab       HFI_ROF_b_0

* drop    HFI_ROF_b_1
generate  HFI_ROF_b_1=0
replace   HFI_ROF_b_1=1 if HFI_ROF_b_0==1   & !inlist(HFI_ROF_b,0,1,98,99)
replace   HFI_ROF_b_1=2 if HFI_ROF_b_0==1   &  inlist(HFI_ROF_b,.)
replace   HFI_ROF_b_1=3 if !(HFI_ROF_b_0==1)&  !inlist(HFI_ROF_b,.)
*replace   HFI_ROF_b_1=9 if                  !inlist(HFI_ROF_b,.)
tab       HFI_ROF_b_1, miss
tab       HFI_ROF_b, miss

/********************************************************      HFI_ROF_c        ********************************************/
* drop    F_HFI_ROF_c_0
generate  F_HFI_ROF_c_0=0
replace	  F_HFI_ROF_c_0=1 if HFI_ROF_b==1
tab       F_HFI_ROF_c_0

* drop    F_HFI_ROF_c_1
generate  F_HFI_ROF_c_1=0
replace   F_HFI_ROF_c_1=1 if F_HFI_ROF_c_0==1   & !inlist(HFI_ROF_c,2,3,4,98,99)
replace   F_HFI_ROF_c_1=2 if F_HFI_ROF_c_0==1   &  inlist(HFI_ROF_c,.)
*replace   F_HFI_ROF_c_1=3 if !(F_HFI_ROF_c_0==1)& !inlist(HFI_ROF_c,.)
*replace   F_HFI_ROF_c_1=9 if                  !inlist(HFI_ROF_c,.)
tab       F_HFI_ROF_c_1, miss
tab       HFI_ROF_c, miss

/********************************************************      HFI_DNE        ********************************************/
* drop    F_HFI_DNE_0
generate  F_HFI_DNE_0=0
replace	  F_HFI_DNE_0=1 if HFI_START_MODULE==1
tab       F_HFI_DNE_0

* drop    F_HFI_DNE_1
generate  F_HFI_DNE_1=0
replace   F_HFI_DNE_1=1 if F_HFI_DNE_0==1   & !inlist(HFI_DNE,0,1,98,99)
replace   F_HFI_DNE_1=2 if F_HFI_DNE_0==1   &  inlist(HFI_DNE,.)
*replace   F_HFI_DNE_1=3 if !(F_HFI_DNE_0==1)& !inlist(HFI_DNE,.)
*replace   F_HFI_DNE_1=9 if                  !inlist(HFI_DNE,.)
tab       F_HFI_DNE_1, miss
tab       HFI_DNE, miss


/********************************************************      HFI_DNE_a        ********************************************/
* drop    F_HFI_DNE_a_0
generate  F_HFI_DNE_a_0=0
replace	  F_HFI_DNE_a_0=1 if HFI_DNE==1
tab       F_HFI_DNE_a_0

* drop    F_HFI_DNE_a_1
generate  F_HFI_DNE_a_1=0
replace   F_HFI_DNE_a_1=1 if F_HFI_DNE_a_0==1   & !inlist(HFI_DNE_a,0,1,98,99)
replace   F_HFI_DNE_a_1=2 if F_HFI_DNE_a_0==1   &  inlist(HFI_DNE_a,.)
replace   F_HFI_DNE_a_1=3 if !(F_HFI_DNE_a_0==1)&  !inlist(HFI_DNE_a,.)
*replace   F_HFI_DNE_a_1=9 if                  !inlist(HFI_DNE_a,.)
tab       F_HFI_DNE_a_1, miss
tab       HFI_DNE_a, miss

/********************************************************      HFI_DNE_b       ********************************************/
* drop    HFI_DNE_b_0
generate  HFI_DNE_b_0=0
replace	  HFI_DNE_b_0=1 if HFI_DNE_a==1
tab       HFI_DNE_b_0

* drop    HFI_DNE_b_1
generate  HFI_DNE_b_1=0
replace   HFI_DNE_b_1=1 if HFI_DNE_b_0==1   & !inlist(HFI_DNE_b,0,1,98,99)
replace   HFI_DNE_b_1=2 if HFI_DNE_b_0==1   &  inlist(HFI_DNE_b,.)
replace   HFI_DNE_b_1=3 if !(HFI_DNE_b_0==1)&  !inlist(HFI_DNE_b,.)
*replace   HFI_DNE_b_1=9 if                  !inlist(HFI_DNE_b,.)
tab       HFI_DNE_b_1, miss
tab       HFI_DNE_b, miss

/********************************************************      HFI_DNE_c        ********************************************/
* drop    F_HFI_DNE_c_0
generate  F_HFI_DNE_c_0=0
replace	  F_HFI_DNE_c_0=1 if HFI_DNE_a==1
tab       F_HFI_DNE_c_0

* drop    F_HFI_DNE_c_1
generate  F_HFI_DNE_c_1=0
replace   F_HFI_DNE_c_1=1 if F_HFI_DNE_c_0==1   & !inlist(HFI_DNE_c,2,3,4,98,99)
replace   F_HFI_DNE_c_1=2 if F_HFI_DNE_c_0==1   &  inlist(HFI_DNE_c,.)
*replace   F_HFI_DNE_c_1=3 if !(F_HFI_DNE_c_0==1)& !inlist(HFI_DNE_c,.)
*replace   F_HFI_DNE_c_1=9 if                  !inlist(HFI_DNE_c,.)
tab       F_HFI_DNE_c_1, miss
tab       HFI_DNE_c, miss

/********************************************************      HFI_WEW        ********************************************/
* drop    F_HFI_WEW_0
generate  F_HFI_WEW_0=0
replace	  F_HFI_WEW_0=1 if HFI_START_MODULE==1
tab       F_HFI_WEW_0

* drop    F_HFI_WEW_1
generate  F_HFI_WEW_1=0
replace   F_HFI_WEW_1=1 if F_HFI_WEW_0==1   & !inlist(HFI_WEW,0,1,98,99)
replace   F_HFI_WEW_1=2 if F_HFI_WEW_0==1   &  inlist(HFI_WEW,.)
*replace   F_HFI_WEW_1=3 if !(F_HFI_WEW_0==1)& !inlist(HFI_WEW,.)
*replace   F_HFI_WEW_1=9 if                  !inlist(HFI_WEW,.)
tab       F_HFI_WEW_1, miss
tab       HFI_WEW, miss


/********************************************************      HFI_WEW_a        ********************************************/
* drop    F_HFI_WEW_a_0
generate  F_HFI_WEW_a_0=0
replace	  F_HFI_WEW_a_0=1 if HFI_WEW==1
tab       F_HFI_WEW_a_0

* drop    F_HFI_WEW_a_1
generate  F_HFI_WEW_a_1=0
replace   F_HFI_WEW_a_1=1 if F_HFI_WEW_a_0==1   & !inlist(HFI_WEW_a,0,1,98,99)
replace   F_HFI_WEW_a_1=2 if F_HFI_WEW_a_0==1   &  inlist(HFI_WEW_a,.)
replace   F_HFI_WEW_a_1=3 if !(F_HFI_WEW_a_0==1)&  !inlist(HFI_WEW_a,.)
*replace   F_HFI_WEW_a_1=9 if                  !inlist(HFI_WEW_a,.)
tab       F_HFI_WEW_a_1, miss
tab       HFI_WEW_a, miss

/********************************************************      HFI_WEW_b       ********************************************/
* drop    HFI_WEW_b_0
generate  HFI_WEW_b_0=0
replace	  HFI_WEW_b_0=1 if HFI_WEW_a==1
tab       HFI_WEW_b_0

* drop    HFI_WEW_b_1
generate  HFI_WEW_b_1=0
replace   HFI_WEW_b_1=1 if HFI_WEW_b_0==1   & !inlist(HFI_WEW_b,0,1,98,99)
replace   HFI_WEW_b_1=2 if HFI_WEW_b_0==1   &  inlist(HFI_WEW_b,.)
replace   HFI_WEW_b_1=3 if !(HFI_WEW_b_0==1)&  !inlist(HFI_WEW_b,.)
*replace   HFI_WEW_b_1=9 if                  !inlist(HFI_WEW_b,.)
tab       HFI_WEW_b_1, miss
tab       HFI_WEW_b, miss

/********************************************************      HFI_WEW_c        ********************************************/
* drop    F_HFI_WEW_c_0
generate  F_HFI_WEW_c_0=0
replace	  F_HFI_WEW_c_0=1 if HFI_WEW_b==1
tab       F_HFI_WEW_c_0

* drop    F_HFI_WEW_c_1
generate  F_HFI_WEW_c_1=0
replace   F_HFI_WEW_c_1=1 if F_HFI_WEW_c_0==1   & !inlist(HFI_WEW_c,2,3,4,98,99)
replace   F_HFI_WEW_c_1=2 if F_HFI_WEW_c_0==1   &  inlist(HFI_WEW_c,.)
*replace   F_HFI_WEW_c_1=3 if !(F_HFI_WEW_c_0==1)& !inlist(HFI_WEW_c,.)
*replace   F_HFI_WEW_c_1=9 if                  !inlist(HFI_WEW_c,.)
tab       F_HFI_WEW_c_1, miss
tab       HFI_WEW_c, miss


*******************************************************************************************************************
*
*            TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_HFI_0 ///
F_HFI_CONTINUE_0 ///
F_HFI_START_MODULE_0 ///
F_HFI_PPNO_0 ///
F_HFI_NEF_0 ///   
F_HFI_NEF_a_0 ///   
F_HFI_NEF_b_0 ///
F_HFI_UHN_0 /// 
F_HFI_UHN_a_0 ///
F_HFI_UHN_b_0 ///
F_HFI_OFK_0 ///
F_HFI_OFK_a_0 ///
F_HFI_OFK_b_0 ///   
F_HFI_SAM_0 ///   
F_HFI_SAM_a_0 ///
F_HFI_SAM_b_0 /// 
F_HFI_LTS_0 ///
F_HFI_LTS_a_0 ///
F_HFI_LTS_b_0 ///
F_HFI_ROF_0 ///
F_HFI_ROF_a_0 ///   
F_HFI_ROF_b_0 ///   
F_HFI_ROF_c_0 ///
F_HFI_DNE_0 /// 
F_HFI_DNE_a_0 ///
F_HFI_DNE_b_0 ///
F_HFI_DNE_c_0 ///
F_HFI_WEW_0 ///
F_HFI_WEW_a_0 ///   
F_HFI_WEW_b_0 ///   
F_HFI_WEW_c_0 ///
F_HFI_END_MODULE_0 

global List_F_HFI_1 ///
F_HFI_CONTINUE_1 ///
F_HFI_START_MODULE_1 ///
F_HFI_PPNO_1 ///
F_HFI_NEF_1 ///   
F_HFI_NEF_a_1 ///   
F_HFI_NEF_b_1 ///
F_HFI_UHN_1 /// 
F_HFI_UHN_a_1 ///
F_HFI_UHN_b_1 ///
F_HFI_OFK_1 ///
F_HFI_OFK_a_1 ///
F_HFI_OFK_b_1 ///   
F_HFI_SAM_1 ///   
F_HFI_SAM_a_1 ///
F_HFI_SAM_b_1 /// 
F_HFI_LTS_1 ///
F_HFI_LTS_a_1 ///
F_HFI_LTS_b_1 ///
F_HFI_ROF_1 ///
F_HFI_ROF_a_1 ///   
F_HFI_ROF_b_1 ///   
F_HFI_ROF_c_1 ///
F_HFI_DNE_1 /// 
F_HFI_DNE_a_1 ///
F_HFI_DNE_b_1 ///
F_HFI_DNE_c_1 ///
F_HFI_WEW_1 ///
F_HFI_WEW_a_1 ///   
F_HFI_WEW_b_1 ///   
F_HFI_WEW_c_1 ///
F_HFI_END_MODULE_1 


foreach var of varlist $List_F_HFI_1 {
    tab `var' if `var'>0 , miss
}
