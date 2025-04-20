
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
***                        CHECK ON THE OPF  -  OWN USE PRODUCTION OF FOODSTUFF                                 ***
***                                                                                                             *** 
*******************************************************************************************************************
*******************************************************************************************************************
 
 
/********************************************************      OPF_HFOOD_a    ********************************************/
* drop   F_OPF_HFOOD_a_0
generate F_OPF_HFOOD_a_0=0
replace  F_OPF_HFOOD_a_0=1 if DEM_AGE>= 15 & AGF_HIR!=2
tab      F_OPF_HFOOD_a_0, missing

* drop   F_OPF_HFOOD_a_1
generate F_OPF_HFOOD_a_1=0
replace  F_OPF_HFOOD_a_1=0 
replace  F_OPF_HFOOD_a_1=1 if DEM_AGE>= 15 &   F_OPF_HFOOD_a_0==1  & !inlist(OPF_HFOOD_a,1,2)
replace  F_OPF_HFOOD_a_1=2 if DEM_AGE>= 15 &   F_OPF_HFOOD_a_0==1  &  inlist(OPF_HFOOD_a,.)
replace  F_OPF_HFOOD_a_1=3 if DEM_AGE>= 15 & !(F_OPF_HFOOD_a_0==1) & !inlist(OPF_HFOOD_a,.)
replace  F_OPF_HFOOD_a_1=9 if DEM_AGE<  15 &                         !inlist(OPF_HFOOD_a,.)

tab      F_OPF_HFOOD_a_0 F_OPF_HFOOD_a_1, miss

/********************************************************      OPF_HFOOD_a_HRS    ********************************************/
* drop   OPF_HFOOD_a_HRS_0
generate F_OPF_HFOOD_a_HRS_0=0
replace  F_OPF_HFOOD_a_HRS_0=1 if DEM_AGE>= 15 & OPF_HFOOD_a==1 
tab      F_OPF_HFOOD_a_HRS_0, missing

* drop   OPF_HFOOD_a_HRS_1
generate F_OPF_HFOOD_a_HRS_1=0
replace  F_OPF_HFOOD_a_HRS_1=0
replace  F_OPF_HFOOD_a_HRS_1=1 if DEM_AGE>= 15 &   F_OPF_HFOOD_a_HRS_0==1  & !inrange(OPF_HFOOD_a_HRS,1,112) & OPF_HFOOD_a_HRS!=997
replace  F_OPF_HFOOD_a_HRS_1=2 if DEM_AGE>= 15 &   F_OPF_HFOOD_a_HRS_0==1  &   inlist(OPF_HFOOD_a_HRS,0,.)
replace  F_OPF_HFOOD_a_HRS_1=3 if DEM_AGE>= 15 & !(F_OPF_HFOOD_a_HRS_0==1) &  !inlist(OPF_HFOOD_a_HRS,.)
replace  F_OPF_HFOOD_a_HRS_1=9 if DEM_AGE<  15 &                              !inlist(OPF_HFOOD_a_HRS,.)

tab      F_OPF_HFOOD_a_HRS_0 F_OPF_HFOOD_a_HRS_1, miss

/********************************************************      OPF_HFOOD_b    ********************************************/
* drop   F_OPF_HFOOD_b_0
generate F_OPF_HFOOD_b_0=0
replace  F_OPF_HFOOD_b_0=1 if DEM_AGE>= 15 & AGF_HIR!=2
tab      F_OPF_HFOOD_b_0, missing

* drop   F_OPF_HFOOD_b_1
generate F_OPF_HFOOD_b_1=0
replace  F_OPF_HFOOD_b_1=0 
replace  F_OPF_HFOOD_b_1=1 if DEM_AGE>= 15 &   F_OPF_HFOOD_b_0==1  & !inlist(OPF_HFOOD_b,1,2)
replace  F_OPF_HFOOD_b_1=2 if DEM_AGE>= 15 &   F_OPF_HFOOD_b_0==1  &  inlist(OPF_HFOOD_b,.)
replace  F_OPF_HFOOD_b_1=3 if DEM_AGE>= 15 & !(F_OPF_HFOOD_b_0==1) & !inlist(OPF_HFOOD_b,.)
replace  F_OPF_HFOOD_b_1=9 if DEM_AGE<  15 &                         !inlist(OPF_HFOOD_b,.)

tab      F_OPF_HFOOD_b_0 F_OPF_HFOOD_b_1, miss


/********************************************************      OPF_HFOOD_b_HRS    ********************************************/
* drop   OPF_HFOOD_b_HRS_0
generate F_OPF_HFOOD_b_HRS_0=0
replace  F_OPF_HFOOD_b_HRS_0=1 if DEM_AGE>= 15 & OPF_HFOOD_b==1 
tab      F_OPF_HFOOD_b_HRS_0, missing

* drop   OPF_HFOOD_b_HRS_1
generate F_OPF_HFOOD_b_HRS_1=0
replace  F_OPF_HFOOD_b_HRS_1=0
replace  F_OPF_HFOOD_b_HRS_1=1 if DEM_AGE>= 15 &   F_OPF_HFOOD_b_HRS_0==1  & !inrange(OPF_HFOOD_b_HRS,1,112) & OPF_HFOOD_b_HRS!=997
replace  F_OPF_HFOOD_b_HRS_1=2 if DEM_AGE>= 15 &   F_OPF_HFOOD_b_HRS_0==1  &   inlist(OPF_HFOOD_b_HRS,0,.)
replace  F_OPF_HFOOD_b_HRS_1=3 if DEM_AGE>= 15 & !(F_OPF_HFOOD_b_HRS_0==1) &  !inlist(OPF_HFOOD_b_HRS,.)
replace  F_OPF_HFOOD_b_HRS_1=9 if DEM_AGE<  15 &                              !inlist(OPF_HFOOD_b_HRS,.)

tab      F_OPF_HFOOD_b_HRS_0 F_OPF_HFOOD_b_HRS_1, miss



/********************************************************      OPF_HFOOD_c    ********************************************/
* drop   F_OPF_HFOOD_c_0
generate F_OPF_HFOOD_c_0=0
replace  F_OPF_HFOOD_c_0=1 if DEM_AGE>= 15 & AGF_HIR!=2
tab      F_OPF_HFOOD_c_0, missing

* drop   F_OPF_HFOOD_c_1
generate F_OPF_HFOOD_c_1=0
replace  F_OPF_HFOOD_c_1=0 
replace  F_OPF_HFOOD_c_1=1 if DEM_AGE>= 15 &   F_OPF_HFOOD_c_0==1  & !inlist(OPF_HFOOD_c,1,2)
replace  F_OPF_HFOOD_c_1=2 if DEM_AGE>= 15 &   F_OPF_HFOOD_c_0==1  &  inlist(OPF_HFOOD_c,.)
replace  F_OPF_HFOOD_c_1=3 if DEM_AGE>= 15 & !(F_OPF_HFOOD_c_0==1) & !inlist(OPF_HFOOD_c,.)
replace  F_OPF_HFOOD_c_1=9 if DEM_AGE<  15 &                         !inlist(OPF_HFOOD_c,.)

tab      F_OPF_HFOOD_c_0 F_OPF_HFOOD_c_1, miss


/********************************************************      OPF_HFOOD_c_HRS    ********************************************/
* drop   OPF_HFOOD_c_HRS_0
generate F_OPF_HFOOD_c_HRS_0=0
replace  F_OPF_HFOOD_c_HRS_0=1 if DEM_AGE>= 15 & OPF_HFOOD_c==1 
tab      F_OPF_HFOOD_c_HRS_0, missing

* drop   OPF_HFOOD_c_HRS_1
generate F_OPF_HFOOD_c_HRS_1=0
replace  F_OPF_HFOOD_c_HRS_1=0
replace  F_OPF_HFOOD_c_HRS_1=1 if DEM_AGE>= 15 &   F_OPF_HFOOD_c_HRS_0==1  & !inrange(OPF_HFOOD_c_HRS,1,112) & OPF_HFOOD_c_HRS!=997
replace  F_OPF_HFOOD_c_HRS_1=2 if DEM_AGE>= 15 &   F_OPF_HFOOD_c_HRS_0==1  &   inlist(OPF_HFOOD_c_HRS,0,.)
replace  F_OPF_HFOOD_c_HRS_1=3 if DEM_AGE>= 15 & !(F_OPF_HFOOD_c_HRS_0==1) &  !inlist(OPF_HFOOD_c_HRS,.)
replace  F_OPF_HFOOD_c_HRS_1=9 if DEM_AGE<  15 &                              !inlist(OPF_HFOOD_c_HRS,.)

tab      F_OPF_HFOOD_c_HRS_0 F_OPF_HFOOD_c_HRS_1, miss


*******************************************************************************************************************
*
*            TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_OPF_0 ///
F_OPF_HFOOD_a_0 /// 
F_OPF_HFOOD_a_HRS_0  ///
F_OPF_HFOOD_b_0  ///
F_OPF_HFOOD_b_HRS_0  ///
F_OPF_HFOOD_c_0 /// 
F_OPF_HFOOD_c_HRS_0 ///


global List_F_OPF_1 ///
F_OPF_HFOOD_a_1 /// 
F_OPF_HFOOD_a_HRS_1  ///
F_OPF_HFOOD_b_1  ///
F_OPF_HFOOD_b_HRS_1  ///
F_OPF_HFOOD_c_1 /// 
F_OPF_HFOOD_c_HRS_1 ///

foreach var of varlist $List_F_OPF_1 {
    tab `var' if `var'>0 , miss
}
