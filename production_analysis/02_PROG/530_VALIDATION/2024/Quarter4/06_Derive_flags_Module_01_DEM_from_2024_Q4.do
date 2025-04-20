

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



/********************************************************      DEM_STR        ********************************************/
*drop    F_DEM_STR_0
generate  F_DEM_STR_0=1

* drop    F_DEM_STR_1
generate  F_DEM_STR_1=0
replace   F_DEM_STR_1=0
replace   F_DEM_STR_1=1 if F_DEM_STR_0==1 & !inlist(DEM_STR,1,2)
replace   F_DEM_STR_1=2 if F_DEM_STR_0==1 &  inlist(DEM_STR,.)

tab       F_DEM_STR_0 F_DEM_STR_1 , miss


/********************************************************      HHR_MIS        ********************************************/
*drop     F_HHR_MIS_0
generate  F_HHR_MIS_0=1

* drop    F_HHR_MIS_1
generate  F_HHR_MIS_1=0
replace   F_HHR_MIS_1=0
replace   F_HHR_MIS_1=1 if F_HHR_MIS_0==1 & !inlist(HHR_MIS,2)
replace   F_HHR_MIS_1=2 if F_HHR_MIS_0==1 &  inlist(HHR_MIS,.)

tab       F_HHR_MIS_0 F_HHR_MIS_1 , miss

/********************************************************      HHR_INELI        ********************************************/
*drop     F_HHR_INELI_0
generate  F_HHR_INELI_0=1

* drop    F_HHR_INELI_1
generate  F_HHR_INELI_1=0
replace   F_HHR_INELI_1=0
replace   F_HHR_INELI_1=1 if F_HHR_INELI_0==1 & !inlist(HHR_INELI,2)
replace   F_HHR_INELI_1=2 if F_HHR_INELI_0==1 &  inlist(HHR_INELI,.)

tab       F_HHR_INELI_0 F_HHR_INELI_1 , miss

/********************************************************      DEM_HEAD_PPNO       ********************************************/
*drop     F_DEM_HEAD_PPNO_0
generate  F_DEM_HEAD_PPNO_0=1

* drop    F_DEM_HEAD_PPNO_1
generate  F_DEM_HEAD_PPNO_1=0
replace   F_DEM_HEAD_PPNO_1=0
replace   F_DEM_HEAD_PPNO_1=1 if F_DEM_HEAD_PPNO_0==1 & !inrange(DEM_HEAD_PPNO,1,40)
replace   F_DEM_HEAD_PPNO_1=2 if F_DEM_HEAD_PPNO_0==1 &   inlist(DEM_HEAD_PPNO,.)

tab       F_DEM_HEAD_PPNO_0 F_DEM_HEAD_PPNO_1 , miss


/********************************************************      DEM_HEAD_NAME    ********************************************/
*drop     F_DEM_HEAD_NAME_0
generate  F_DEM_HEAD_NAME_0=1

* drop    F_DEM_HEAD_NAME_1
generate  F_DEM_HEAD_NAME_1=0
replace   F_DEM_HEAD_NAME_1=2 if F_DEM_HEAD_NAME_0==1 & DEM_HEAD_NAME==""

tab       F_DEM_HEAD_NAME_0 F_DEM_HEAD_NAME_1 , miss


/********************************************************      HHR_HEAD_CONT    ********************************************/
*drop     F_HHR_HEAD_CONT_0
generate  F_HHR_HEAD_CONT_0=1

* drop    F_HHR_HEAD_CONT_1
generate  F_HHR_HEAD_CONT_1=0
replace   F_HHR_HEAD_CONT_1=0
replace   F_HHR_HEAD_CONT_1=2 if F_HHR_HEAD_CONT_0==1 & HHR_HEAD_CONT==.

tab       F_HHR_HEAD_CONT_0 F_HHR_HEAD_CONT_1 , miss



/********************************************************      PPNO         ********************************************/
*drop    F_PPNO_0
generate  F_PPNO_0=1

* drop    F_PPNO_1
generate  F_PPNO_1=0
replace   F_PPNO_1=1 if F_PPNO_0==1 & !inrange(PPNO,1,40)
replace   F_PPNO_1=2 if F_PPNO_0==1 &   inlist(PPNO,.)

tab       F_PPNO_0 F_PPNO_1 , miss


/********************************************************      DEM_NAME    ********************************************/
*drop    F_DEM_NAME_0
generate  F_DEM_NAME_0=1

* drop    F_DEM_NAME_1
generate  F_DEM_NAME_1=0
replace   F_DEM_NAME_1=2 if F_DEM_NAME_0==1 & DEM_NAME==""

tab       F_DEM_NAME_0 F_DEM_NAME_1 , miss



/******************************************************    RSP_AVAIL    ********************************************/
*drop    F_RSP_AVAIL_0
generate F_RSP_AVAIL_0=0
replace  F_RSP_AVAIL_0=1 
tab      F_RSP_AVAIL_0

* drop    F_RSP_AVAIL_1
generate F_RSP_AVAIL_1=0
replace  F_RSP_AVAIL_1=0
replace  F_RSP_AVAIL_1=1 if   F_RSP_AVAIL_0==1  & !inlist(RSP_AVAIL,1,2,3,4,5,6,7,8,9,10) & RSP_AVAIL!=-96
replace  F_RSP_AVAIL_1=2 if   F_RSP_AVAIL_0==1  &  inlist(RSP_AVAIL,.)
replace  F_RSP_AVAIL_1=3 if !(F_RSP_AVAIL_0==1) & !inlist(RSP_AVAIL,.)

tab      F_RSP_AVAIL_0 F_RSP_AVAIL_1, miss

tab      RSP_AVAIL, miss


/******************************************************    RSP_PPNO    ********************************************/
* drop    F_RSP_PPNO_0
generate F_RSP_PPNO_0=0
replace  F_RSP_PPNO_0=1 if RSP_AVAIL==2    
tab      F_RSP_PPNO_0

* drop    F_RSP_PPNO_1
generate F_RSP_PPNO_1=0
replace  F_RSP_PPNO_1=1 if   F_RSP_PPNO_0==1  & !inrange(RSP_PPNO,1,40) & !inlist(RSP_PPNO,97)
replace  F_RSP_PPNO_1=2 if   F_RSP_PPNO_0==1  &   inlist(RSP_PPNO,.)
replace  F_RSP_PPNO_1=3 if !(F_RSP_PPNO_0==1) &  !inlist(RSP_PPNO,.)

tab      F_RSP_PPNO_0 F_RSP_PPNO_1, miss



/******************************************************    RSP_CONT   ********************************************/
* drop    F_RSP_CONT_0
generate F_RSP_CONT_0=0
replace  F_RSP_CONT_0=1 if RSP_AVAIL==3 
tab      F_RSP_CONT_0

* drop    F_RSP_CONT_1
generate F_RSP_CONT_1=0
replace  F_RSP_CONT_1=1 if   F_RSP_CONT_0==1  & !inlist(RSP_CONT,-99,-98,-97)
replace  F_RSP_CONT_1=2 if   F_RSP_CONT_0==1  &  inlist(RSP_CONT,.)
replace  F_RSP_CONT_1=3 if !(F_RSP_CONT_0==1) & !inlist(RSP_CONT,.)
tab      F_RSP_CONT_1, miss



/******************************************************    IND_DESC    ********************************************/
* drop    F_IND_DESC_0
generate F_IND_DESC_0=0
replace  F_IND_DESC_0=1 if DEM_AGE>= 15 & inlist(RSP_AVAIL,4,5,6,-96)    
tab      F_IND_DESC_0

* drop    F_IND_DESC_1
generate F_IND_DESC_1=0
replace  F_IND_DESC_1=2 if DEM_AGE>= 15 &   F_IND_DESC_0==1  &  IND_DESC==""
replace  F_IND_DESC_1=3 if DEM_AGE>= 15 & !(F_IND_DESC_0==1) &  IND_DESC!=""

tab      F_IND_DESC_0 F_IND_DESC_1, miss

/********************************************************      DEM_SEX         ********************************************/
*drop    F_DEM_SEX_0
generate  F_DEM_SEX_0=1

* drop    F_DEM_SEX_1
generate  F_DEM_SEX_1=0
replace   F_DEM_SEX_1=1 if !inlist(DEM_SEX,1,2)
replace   F_DEM_SEX_1=2 if  inlist(DEM_SEX,.)

tab       F_DEM_SEX_0 F_DEM_SEX_1 , miss




/******************************************************** DEM_BTH_YEAR ***************************************/

* drop    F_DEM_BTH_YEAR_0
generate  F_DEM_BTH_YEAR_0=1
tab       F_DEM_BTH_YEAR_0

* drop    F_DEM_BTH_YEAR_1
generate  F_DEM_BTH_YEAR_1=0
replace   F_DEM_BTH_YEAR_1=1 if F_DEM_BTH_YEAR_0==1  & !inrange(DEM_BTH_YEAR,1902,year) & DEM_BTH_YEAR!=9997
replace   F_DEM_BTH_YEAR_1=2 if F_DEM_BTH_YEAR_0==1  &   inlist(DEM_BTH_YEAR,.)

tab       F_DEM_BTH_YEAR_0 F_DEM_BTH_YEAR_1, miss    

 
/******************************************************** DEM_BTH_MONTH ***************************************/

* drop    F_DEM_BTH_MONTH_0
generate  F_DEM_BTH_MONTH_0=0 
replace   F_DEM_BTH_MONTH_0=0 
replace   F_DEM_BTH_MONTH_0=1 if DEM_BTH_YEAR!=9997 
tab       F_DEM_BTH_MONTH_0

* drop    F_DEM_BTH_MONTH_1
generate  F_DEM_BTH_MONTH_1=0
replace   F_DEM_BTH_MONTH_1=0
replace   F_DEM_BTH_MONTH_1=1 if F_DEM_BTH_MONTH_0==1  & !inrange(DEM_BTH_MONTH,1,12) & !inlist(DEM_BTH_MONTH,97)
replace   F_DEM_BTH_MONTH_1=2 if F_DEM_BTH_MONTH_0==1  &   inlist(DEM_BTH_MONTH,.)

tab       F_DEM_BTH_MONTH_0 F_DEM_BTH_MONTH_1, miss    



/********************************************************      AgeCurrent      ********************************************/
* drop    F_AgeCurrent_0
generate  F_AgeCurrent_0=0
replace   F_AgeCurrent_0=0
replace   F_AgeCurrent_0=1 if inrange(DEM_BTH_YEAR,1902,year)

* drop    F_AgeCurrent_1
generate  F_AgeCurrent_1=0
replace   F_AgeCurrent_1=0
replace   F_AgeCurrent_1=2 if F_AgeCurrent_0==1 &  !inrange(AgeCurrent,0,120)
replace   F_AgeCurrent_1=2 if F_AgeCurrent_0==1 &   inlist(AgeCurrent,.)

tab       F_AgeCurrent_0 F_AgeCurrent_1, miss

/******************************************************** DEM_AGE_CONF ***************************************/

* drop    F_DEM_AGE_CONF_0
generate  F_DEM_AGE_CONF_0=0
replace   F_DEM_AGE_CONF_0=0
replace   F_DEM_AGE_CONF_0=1 if DEM_BTH_YEAR>=0 & DEM_BTH_YEAR!=9997  
tab       F_DEM_AGE_CONF_0

* drop    F_DEM_AGE_CONF_1
generate  F_DEM_AGE_CONF_1=0
replace   F_DEM_AGE_CONF_1=0
replace   F_DEM_AGE_CONF_1=1 if   F_DEM_AGE_CONF_0==1   &  !inlist(DEM_AGE_CONF,1,2)
replace   F_DEM_AGE_CONF_1=2 if   F_DEM_AGE_CONF_0==1   &   inlist(DEM_AGE_CONF,.)
replace   F_DEM_AGE_CONF_1=3 if   F_DEM_AGE_CONF_0!=1   &  !inlist(DEM_AGE_CONF,.)

tab       F_DEM_AGE_CONF_0 F_DEM_AGE_CONF_1, miss    


/******************************************************** DEM_AGE_ENT ***************************************/

* drop    F_DEM_AGE_ENT_0
generate  F_DEM_AGE_ENT_0=0
replace   F_DEM_AGE_ENT_0=0
replace   F_DEM_AGE_ENT_0=1 if DEM_BTH_YEAR==9997 | DEM_AGE_CONF==2
tab       F_DEM_AGE_ENT_0

* drop    F_DEM_AGE_ENT_1
generate  F_DEM_AGE_ENT_1=0
replace   F_DEM_AGE_ENT_1=0
replace   F_DEM_AGE_ENT_1=1 if   F_DEM_AGE_ENT_0==1   & !inrange(DEM_AGE_ENT,0,120) & !inlist(DEM_AGE_ENT,997)
replace   F_DEM_AGE_ENT_1=2 if   F_DEM_AGE_ENT_0==1   &   inlist(DEM_AGE_ENT,.)
replace   F_DEM_AGE_ENT_1=3 if   F_DEM_AGE_ENT_0!=1   &  !inlist(DEM_AGE_ENT,.)

tab       F_DEM_AGE_ENT_0 F_DEM_AGE_ENT_1, miss    


/********************************************************      DEM_AGE_EST        ********************************************/
* drop    F_DEM_AGE_EST_0
generate  F_DEM_AGE_EST_0=0 
replace   F_DEM_AGE_EST_0=0 
replace   F_DEM_AGE_EST_0=1 if DEM_AGE_ENT==997


* drop    F_DEM_AGE_EST_1
generate  F_DEM_AGE_EST_1=0
replace   F_DEM_AGE_EST_1=0
replace   F_DEM_AGE_EST_1=1 if    F_DEM_AGE_EST_0==1 &   !inrange(DEM_AGE_EST,0,120) 
replace   F_DEM_AGE_EST_1=2 if    F_DEM_AGE_EST_0==1 &     inlist(DEM_AGE_EST,.)
replace   F_DEM_AGE_EST_1=3 if    F_DEM_AGE_EST_0!=1 &    !inlist(DEM_AGE_EST,.)

tab       F_DEM_AGE_EST_0 F_DEM_AGE_EST_1 , miss

/*
tab         DEM_AGE, miss   
*/


/********************************************************      DEM_AGE         ********************************************/
* drop    F_DEM_AGE_0
generate  F_DEM_AGE_0=1 

* drop    F_DEM_AGE_1
generate  F_DEM_AGE_1=0
replace   F_DEM_AGE_1=1 if  !inrange(DEM_AGE,0,120) 
replace   F_DEM_AGE_1=2 if    inlist(DEM_AGE,.)

tab       F_DEM_AGE_0 F_DEM_AGE_1 , miss

/*
tab         DEM_AGE, miss   
*/



/********************************************************      GLO_WAP         ********************************************/
*drop     F_GLO_WAP_0
generate  F_GLO_WAP_0=1

* drop    F_GLO_WAP_1
generate  F_GLO_WAP_1=0
replace   F_GLO_WAP_1=0 
replace   F_GLO_WAP_1=1 if !inrange(GLO_WAP,1,2)
replace   F_GLO_WAP_1=2 if   inlist(GLO_WAP,.)

tab       F_GLO_WAP_0 F_GLO_WAP_1 , miss

/********************************************************      DEM_REL_a         ********************************************/
* drop    F_DEM_REL_a_0
generate  F_DEM_REL_a_0=0
replace   F_DEM_REL_a_0=0
replace   F_DEM_REL_a_0=1 if ind_eligible == 1 & DEM_HEAD_PPNO != PPNO & form_stream != "LABOUR_QUARTER"
 
* drop    F_DEM_REL_a_1
generate  F_DEM_REL_a_1=0
replace   F_DEM_REL_a_1=0
replace   F_DEM_REL_a_1=1 if  F_DEM_REL_a_0 == 1 & !inlist(DEM_REL_a,2,3,4,5,6,7,8,9,10,11,12,13,14)
replace   F_DEM_REL_a_1=2 if  F_DEM_REL_a_0 == 1 & inlist(DEM_REL_a,.)

tab       F_DEM_REL_a_0 F_DEM_REL_a_1 , miss



/********************************************************      DEM_REL         ********************************************/
* drop    F_DEM_REL_0
generate  F_DEM_REL_0=0
replace   F_DEM_REL_0=0
replace   F_DEM_REL_0=1 if ind_eligible == 1 & DEM_HEAD_PPNO == PPNO
replace   F_DEM_REL_0=1 if ind_eligible == 1 & DEM_HEAD_PPNO != PPNO & form_stream != "LABOUR_QUARTER"

* drop    F_DEM_REL_1
generate  F_DEM_REL_1=0
replace   F_DEM_REL_1=0
replace   F_DEM_REL_1=1 if F_DEM_REL_0==1 & !inlist(DEM_REL,1,2,3,4,5,6,7,8,9,10,11,12,13,14)
replace   F_DEM_REL_1=2 if F_DEM_REL_0==1 & inlist(DEM_REL,.)

tab       F_DEM_REL_0 F_DEM_REL_1 , miss

/*
tab DEM_REL_a DEM_REL , miss
list DEM_REL form_stream PPNO DEM_HEAD_PPNO ind_eligible if F_DEM_REL_0==0 & F_DEM_REL_1==2
*/

/********************************************************      DEM_NAT         ********************************************/
* drop    F_DEM_NAT_0
generate  F_DEM_NAT_0=0
replace   F_DEM_NAT_0=1 if ind_eligible==1

* drop    F_DEM_NAT_1
generate  F_DEM_NAT_1=0
replace   F_DEM_NAT_1=0
replace   F_DEM_NAT_1=1 if F_DEM_NAT_0==1 & !inlist(DEM_NAT,462,50,356,144,524,608,360,156,996)
replace   F_DEM_NAT_1=2 if F_DEM_NAT_0==1 &  inlist(DEM_NAT,.)

tab       F_DEM_NAT_0 F_DEM_NAT_1 , miss




/********************************************************      DEM_CNTY         ********************************************/
* drop    F_DEM_CNTY_0
generate  F_DEM_CNTY_0=0
replace   F_DEM_CNTY_0=0
replace   F_DEM_CNTY_0=1 if DEM_NAT==996

* drop    F_DEM_CNTY_1
generate  F_DEM_CNTY_1=0
replace   F_DEM_CNTY_1=0
replace   F_DEM_CNTY_1=2 if F_DEM_CNTY_0==1 &  DEM_CNTY==.

tab       F_DEM_CNTY_0 F_DEM_CNTY_1 , miss





/********************************************************      DEM_MRT        ********************************************/
* drop    F_DEM_MRT_0
generate  F_DEM_MRT_0=0
replace   F_DEM_MRT_0=1 if DEM_AGE >= 15

* drop    F_DEM_MRT_1
generate  F_DEM_MRT_1=0
replace   F_DEM_MRT_1=1 if DEM_AGE> 15 & F_DEM_MRT_0==1 & !inlist(DEM_MRT,1,2,3,4)
replace   F_DEM_MRT_1=2 if DEM_AGE> 15 & F_DEM_MRT_0==1 &  inlist(DEM_MRT,.)
replace   F_DEM_MRT_1=3 if DEM_AGE> 15 & F_DEM_MRT_0!=1 & !inlist(DEM_MRT,.)
replace   F_DEM_MRT_1=9 if DEM_AGE< 15 &                  !inlist(DEM_MRT,.)

tab       F_DEM_MRT_0 F_DEM_MRT_1 , miss

/*
tab        DEM_AGE DEM_MRT , miss
*/



*******************************************************************************************************************
*
*            TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_DEM_0 ///
F_DEM_STR_0 ///
F_HHR_MIS_0 ///
F_HHR_INELI_0 ///
F_DEM_HEAD_PPNO_0 ///
F_DEM_HEAD_NAME_0 ///
F_HHR_HEAD_CONT_0 ///
F_PPNO_0 ///
F_RSP_AVAIL_0 ///
F_RSP_PPNO_0 ///
F_RSP_CONT_0 ///
F_IND_DESC_0 ///
F_DEM_NAME_0 ///
F_DEM_SEX_0 ///
F_DEM_BTH_YEAR_0 ///
F_DEM_BTH_MONTH_0 ///
F_AgeCurrent_0 ///
F_DEM_AGE_CONF_0 ///
F_DEM_AGE_ENT_0 ///
F_DEM_AGE_EST_0 ///
F_DEM_AGE_0 ///
F_DEM_REL_a_0  ///
F_DEM_REL_0 ///
F_DEM_NAT_0 ///
F_DEM_CNTY_0 ///
F_DEM_MRT_0 ///






foreach var of varlist $List_F_DEM_0 {
    tab `var' if `var'>0 , miss
}


global List_F_DEM_1 ///
F_DEM_STR_1 ///
F_HHR_MIS_1 ///
F_HHR_INELI_1 ///
F_DEM_HEAD_PPNO_1 ///
F_DEM_HEAD_NAME_1 ///
F_HHR_HEAD_CONT_1 ///
F_PPNO_1 ///
F_RSP_AVAIL_1 ///
F_RSP_PPNO_1 ///
F_RSP_CONT_1 ///
F_IND_DESC_1 ///
F_DEM_NAME_1 ///
F_DEM_SEX_1 ///
F_DEM_BTH_YEAR_1 ///
F_DEM_BTH_MONTH_1 ///
F_AgeCurrent_1 ///
F_DEM_AGE_CONF_1 ///
F_DEM_AGE_ENT_1 ///
F_DEM_AGE_EST_1 ///
F_DEM_AGE_1 ///
F_DEM_REL_a_1  ///
F_DEM_REL_1 ///
F_DEM_NAT_1 ///
F_DEM_CNTY_1 ///
F_DEM_MRT_1 ///



foreach var of varlist $List_F_DEM_1 {
    tab `var' if `var'>0 , miss
}

