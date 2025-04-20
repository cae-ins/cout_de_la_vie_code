*******************************************************************************************************************
*
*           SUBSTITUTE THE 0 and .a WITH . FROM THE DIFFERENT SECTIONS (IN CASE IT IS NEEDED)
* 
*******************************************************************************************************************


*******************************************************************************************************************

global List_DEM_miss ///
HHR_MIS ///
HHR_INELI ///
PPNO ///
RSP_AVAIL ///
RSP_PPNO ///
DEM_HEAD_PPNO ///
DEM_STR ///
DEM_SEX  ///
DEM_BTH_YEAR  ///
DEM_BTH_MONTH  ///
DEM_AGE_CONF  ///
DEM_REL_a  ///
DEM_REL  ///
DEM_NAT  ///
DEM_CNTY  ///
DEM_MRT /// 


foreach var of varlist $List_DEM_miss {
    replace `var'=. if inlist(`var',.a,0)
}



global List_DEM_miss ///
DEM_AGE_ENT  ///
DEM_AGE_EST  ///
DEM_AGE  ///
GLO_WAP ///

foreach var of varlist $List_DEM_miss {
    replace `var'=. if inlist(`var',.a)
}



*******************************************************************************************************************




global List_MIG_miss ///
MIG_CNTY_MAL  ///
MIG_BTH  ///
MIG_BTH_ATL   ///
MIG_BTH_ISL  ///
MIG_BTH_CNTY  ///
MIG_REG  ///
MIG_REG_ATL  ///
MIG_REG_ISL  ///
MIG_USL  ///
MIG_USL_ATL  ///
MIG_USL_ISL  ///
MIG_USL_CNTY  ///
MIG_ERO  ///
MIG_PREV  ///
MIG_PREV_ATL  ///
MIG_PREV_ISL  ///
MIG_PREV_CNTY  ///
MIG_USL_YR  ///
MIG_REAS  ///


foreach var of varlist $List_MIG_miss {
    replace `var'=. if inlist(`var',0,.a)
}

global List_MIG_miss ///
MIG_LARR_DUR  ///
MIG_USL_DUR  ///

foreach var of varlist $List_MIG_miss {
    replace `var'=. if inlist(`var',.a)
}
*******************************************************************************************************************


global List_EDU_miss ///
EDU_MOT ///
EDU_ENG ///
DEM_EDC ///
EDU_EVR ///


foreach var of varlist $List_EDU_miss {
    replace `var'=. if inlist(`var',.a,0)
}


global List_EDU_miss ///
EDU_LVL ///
EDU_HIGH ///
EDU_YRS ///
DEM_EDL ///

foreach var of varlist $List_EDU_miss {
    replace `var'=. if inlist(`var',.a)
}




*******************************************************************************************************************

global List_ATW_miss ///
ATW_PAY ///
ATW_PFT ///
ATW_FAM ///

foreach var of varlist $List_ATW_miss {
    replace `var'=. if inlist(`var',.a,0)
}

*******************************************************************************************************************

global List_ABS_miss ///
ABS_JOB /// 
ABS_WHY /// 
ABS_SEA ///
ABS_DUR ///
ABS_PAY ///

foreach var of varlist $List_ABS_miss {
    replace `var'=. if inlist(`var',.a,0)
}

*******************************************************************************************************************

global List_AGF_miss ///
AGF_MKT  ///
AGF_HIS ///
AGF_HIR ///
AGF_DYS ///
AGF_HRSD ///
AGF_HRSW_REP 

foreach var of varlist $List_AGF_miss {
    replace `var'=. if inlist(`var',.a,0)
}


* multiresponse have to be 0 and 1, so only substitute .a
global List_AGF_miss ///
AGF_CHK__1 ///
AGF_CHK__2 ///
AGF_CHK__3 ///
AGF_CHK__4 ///
AGF_CHK__5 ///
AGF_ANY__1 /// 
AGF_ANY__2 ///
AGF_ANY__3 ///
AGF_ANY__4 ///
AGF_ANY__5 ///


foreach var of varlist $List_AGF_miss {
    replace `var'=. if inlist(`var',.a)
}


*******************************************************************************************************************

global List_SRH_miss ///
SRH_JOB ///
SRH_MTD ///
SRH_ACT ///
SRH_OTH ///
SRH_DUR ///
SRH_DES ///
SRH_DWY ///
SRH_FTR ///
SRH_FAN ///
SRH_AVL ///
SRH_AVN ///
SRH_NAR ///
SRH_MAC ///
DWO_3 ///
DWO_4 ///
DWO_7 

foreach var of varlist $List_SRH_miss {
    replace `var'=. if inlist(`var',.a,0)
}

global List_SRH_miss ///
DWO_6 ///

foreach var of varlist $List_SRH_miss {
    replace `var'=. if inlist(`var',.a)
}

*******************************************************************************************************************

global List_MJB_miss ///
MJJ_MULT ///
MJU_REF ///
MJJ_EMP_REL ///
MJJ_EMP_REL_NAT ///
MJJ_GRW_CHK ///
MJJ_CFW_CHK ///
MJJ_HIRES ///
MJD_SINGLE_CLIENT ///
MJD_SOURCE_CLIENT ///
MJC_CONTRA ///
MJC_CONOP ///
MJC_TEMPTOTAL ///
MJC_TEMPDUR ///
MCD_TASKSE ///
MCD_CONTHRS_a ///
MCD_CONTHRS_b ///
MCD_CONTHRS ///
MCD_CONTHRS_NUM ///
MCD_CONMIN_a ///
MCD_CONMIN_b ///
MCD_CONMIN ///
MIE_SOCPRO_a ///
MIE_SOCPRO_b ///
MIE_SOCPRO ///
MIE_SOCPRO_SELF ///
MJJ_HINS ///
MIE_PVACLV ///
MIE_PSCKLV ///
MJU_INS ///
MJU_PLC ///
MJU_SIZ ///
MJL_REGI ///
MJL_CORP ///
MJL_REGP ///
MIS_BOOK_TYP ///
MIS_BOOK ///
MIS_SOCPRO_DC_a ///
MIS_SOCPRO_DC_b ///
MIS_SOCPRO_DC ///
MIS_SOCPRO_CFW ///
MJT_SYR ///
MJT_SMO



foreach var of varlist $List_MJB_miss {
    replace `var'=. if inlist(`var',.a,0)
}

* multiresponse have to be 0 1and 1, so only substitute .a
global List_MJB_miss ///
MJJ_REM_TYP__1 ///
MJJ_REM_TYP__2 ///
MJJ_REM_TYP__3 ///
MJJ_REM_TYP__4 ///
MJJ_REM_TYP__5 ///
MJJ_REM_TYP__6 ///
MJJ_REM_TYP__7 ///
MJJ_REM_TYP__8 ///
MJJ_REM_TYP__9 ///
MJD_SELL_CLIENT__1 ///
MJD_SELL_CLIENT__2 ///
MJD_SELL_CLIENT__3 ///
MJD_SELL_CLIENT__4 ///
MJD_CONTROL__1 ///
MJD_CONTROL__2 ///
MJD_CONTROL__7 ///

foreach var of varlist $List_MJB_miss {
    replace `var'=. if inlist(`var',.a)
}




*******************************************************************************************************************

global List_SJB_miss ///
/*SJB_TEXT*/ ///
/*SJJ_OCC_TLE*/ ///
/*SJJ_OCC_MTD*/ ///
/*SJJ_IND_MAC*/ ///
SJJ_EMP_REL ///
SJJ_HIRES ///
SJJ_REGI ///
SJD_SOCPRO_a ///
SJD_SOCPRO_b ///
SJD_SOCPRO ///
SJD_SINGLE_CLIENT ///
SJD_SOURCE_CLIENT ///
SJD_SOCPRO_SELF_a ///
SJD_SOCPRO_SELF_b ///
SJD_SOCPRO_SELF

foreach var of varlist $List_SJB_miss {
    replace `var'=. if inlist(`var',.a,0)
}

* multiresponse ans strat end module have to be 0 and 1, so only substitute .a

global List_SJB_miss ///
SJD_REM_TYP__1 ///
SJD_REM_TYP__2 ///
SJD_REM_TYP__3 ///
SJD_REM_TYP__4 ///
SJD_REM_TYP__5 ///
SJD_REM_TYP__6 ///
SJD_REM_TYP__7 ///
SJD_REM_TYP__8 ///
SJD_REM_TYP__9 ///
/*SJD_REM_TYP_other*/ ///
SJD_CONTROL__1 ///
SJD_CONTROL__2 ///
SJD_CONTROL__7 ///


foreach var of varlist $List_SJB_miss {
    replace `var'=. if inlist(`var',.a)
}


*******************************************************************************************************************

global List_WKT_miss ///
WKT_MJ_USHRS_REP ///
WKT_MJ_USDAY ///
WKT_MJ_USHRDY ///
WKT_MJ_USHRS ///
WKT_MJ_SAMEHRS ///
WKT_ABS_CHK1 ///
WKT_MJ_ACTHRS_REP ///
WKT_MJ_ACTHRS ///
WKT_SJ_USHRS ///
WKT_SJ_SAMEHRS ///
WKT_SJ_ACTHRS_REP ///
WKT_SJ_ACTHRS ///
WKT_OJ_USHRS ///
WKT_OJ_SAMEHRS ///
WKT_OJ_ACTHRS_REP ///
WKT_OJ_ACTHRS ///
WKT_USHRSTOT_CALC ///
WKT_USHRSTOT_CHK ///
WKT_USHRSTOT_REP ///
WKT_USHRSTOT ///
WKT_ACHRSTOT_CALC ///
WKT_ACHRSTOT_CHK ///
WKT_ACHRSTOT_REP ///
WKT_ACHRSTOT ///
WKT_SRH_OJB ///
WKT_WNT_MRH ///
WKT_AVL_MRH ///
WKT_NUM_MRH ///


foreach var of varlist $List_WKT_miss {
    replace `var'=. if inlist(`var',.a)
}

*******************************************************************************************************************


global List_OPC_miss ///
OPC_HCROP ///

foreach var of varlist $List_OPC_miss {
    replace `var'=. if inlist(`var',0,.a)
}


global List_OPC_miss ///
OPC_ACTHR ///

foreach var of varlist $List_OPC_miss {
    replace `var'=. if inlist(`var',.a)
}



*******************************************************************************************************************


global List_OPF_miss ///
OPF_HFOOD_a /// 
OPF_HFOOD_b  ///
OPF_HFOOD_c /// 

foreach var of varlist $List_OPF_miss {
    replace `var'=. if inlist(`var',0,.a)
}

global List_OPF_miss ///
OPF_HFOOD_a_HRS  ///
OPF_HFOOD_b_HRS  ///
OPF_HFOOD_c_HRS ///

foreach var of varlist $List_OPF_miss {
    replace `var'=. if inlist(`var',.a)
}


*******************************************************************************************************************


global List_MNF_miss ///
MNF_OPG ///

foreach var of varlist $List_MNF_miss {
    replace `var'=. if inlist(`var',0,.a)
}


global List_MNF_miss ///
MNF_OPG_HRS ///

foreach var of varlist $List_MNF_miss {
    replace `var'=. if inlist(`var',.a)
}



*******************************************************************************************************************


