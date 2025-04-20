
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
 
 
/********************************************************      INC_START_MODULE    ********************************************/
* drop    	F_INC_START_MODULE_0
generate  	F_INC_START_MODULE_0=0
replace   	F_INC_START_MODULE_0=1 if DEM_AGE>= 15 & (GLO_WAP==1 & (WKT_END_MODULE==1 | SRH_END_MODULE==1))
tab      	F_INC_START_MODULE_0

* drop F_INC_START_MODULE_1
generate  	F_INC_START_MODULE_1=0
replace   	F_INC_START_MODULE_1=1 if DEM_AGE>= 15 & (GLO_WAP==1 & (WKT_END_MODULE==1 | SRH_END_MODULE==1))
tab      	F_INC_START_MODULE_1 	

/********************************************************      INC_MJ    ********************************************/
* drop   F_INC_MJ_0
generate F_INC_MJ_0=0
replace  F_INC_MJ_0=1 if DEM_AGE>= 15 & INC_START_MODULE==1 & GLO_EMP==1
tab      F_INC_MJ_0, missing

* drop   F_INC_MJ_1
generate F_INC_MJ_1=0
replace  F_INC_MJ_1=1 if DEM_AGE>= 15 & F_INC_MJ_0==1 & !inrange(INC_MJ,100,45000) & INC_MJ !=99999
replace  F_INC_MJ_1=2 if DEM_AGE>= 15 & F_INC_MJ_0==1 & inlist(INC_MJ,0,.)
replace  F_INC_MJ_1=3 if DEM_AGE<  15 & F_INC_MJ_0==1 & !inlist(INC_MJ,0,.)
replace  F_INC_MJ_1=9 if DEM_AGE<  15                 & !inlist(INC_MJ,0,.)
tab      F_INC_MJ_1 
tab      INC_MJ if F_INC_MJ_0==1 & INC_MJ, miss
tab      INC_MJ if F_INC_MJ_0==1 & INC_MJ !=99999, miss

/********************************************************      INC_MJF    ********************************************/
* drop   F_INC_MJF_0
generate F_INC_MJF_0=0
replace  F_INC_MJF_0=1 if DEM_AGE>= 15 & INC_START_MODULE==1 & GLO_EMP==1 & (INC_MJ == 99999)
tab      F_INC_MJF_0, missing

* drop   F_INC_MJF_1
generate F_INC_MJF_1=0
replace  F_INC_MJF_1=1 if DEM_AGE>= 15 & F_INC_MJF_0==1   & !inrange(INC_MJF,1,9) & (INC_MJF !=99999)
replace  F_INC_MJF_1=2 if DEM_AGE>= 15 & F_INC_MJF_0==1   &  inlist(INC_MJF,0,.)
replace  F_INC_MJF_1=3 if DEM_AGE>= 15 & !(F_INC_MJF_0==1)& !inlist(INC_MJF,0,.)
replace  F_INC_MJF_1=9 if DEM_AGE<  15 &                    !inlist(INC_MJF,0,.)
tab      F_INC_MJF_1  
tab      INC_MJF if F_INC_MJF_0==1 , miss
tab      INC_MJF, miss

/********************************************************      INC_SJ   ********************************************/
* drop   F_INC_SJ_0
generate F_INC_SJ_0=0
replace  F_INC_SJ_0=1 if DEM_AGE>= 15 & INC_START_MODULE==1 & GLO_EMP==1 & MJJ_MULT==2 & inlist(WKT_NUMJBS,2,3)
tab      F_INC_SJ_0, missing

* drop   F_INC_SJ_1
generate F_INC_SJ_1=0
replace  F_INC_SJ_1=1 if DEM_AGE>= 15 & F_INC_SJ_0==1   & !inrange(INC_SJ,100,45000) & (INC_SJ !=99999)
replace  F_INC_SJ_1=2 if DEM_AGE>= 15 & F_INC_SJ_0==1   &  inlist(INC_SJ,0,.)
replace  F_INC_SJ_1=3 if DEM_AGE>= 15 & !(F_INC_SJ_0==1)& !inlist(INC_SJ,0,.)
replace  F_INC_SJ_1=9 if DEM_AGE<  15                   & !inlist(INC_SJ,0,.)
tab      F_INC_SJ_1, miss
tab      INC_SJ if F_INC_SJ_0==1, miss

/********************************************************      INC_SJF   ********************************************/
* drop   F_INC_SJF_0
generate F_INC_SJF_0=0
replace  F_INC_SJF_0=1 if DEM_AGE>= 15 & INC_START_MODULE==1 & GLO_EMP==1 & MJJ_MULT==2 & inlist(WKT_NUMJBS,2,3) & (INC_SJ==99999)
tab      F_INC_SJF_0, missing

* drop   F_INC_SJF_1
generate F_INC_SJF_1=0
replace  F_INC_SJF_1=1 if DEM_AGE>= 15 & F_INC_SJF_0==1   & !inrange(INC_SJF,100,45000) & (INC_SJF !=99999)
replace  F_INC_SJF_1=2 if DEM_AGE>= 15 & F_INC_SJF_0==1   &  inlist(INC_SJF,0,.)
replace  F_INC_SJF_1=3 if DEM_AGE>= 15 & !(F_INC_SJF_0==1)& !inlist(INC_SJF,0,.)
replace  F_INC_SJF_1=9 if DEM_AGE<  15                   & !inlist(INC_SJF,0,.)
tab      F_INC_SJF_1, miss
tab      INC_SJF if F_INC_SJF_0==1, miss

/********************************************************      INC_OJ   ********************************************/
* drop   F_INC_OJ_0
generate F_INC_OJ_0=0
replace  F_INC_OJ_0=1 if DEM_AGE>= 15 & INC_START_MODULE==1 & GLO_EMP==1 & WKT_NUMJBS==3
tab      F_INC_OJ_0, missing

* drop   F_INC_OJ_1
generate F_INC_OJ_1=0
replace  F_INC_OJ_1=1 if DEM_AGE>= 15 & F_INC_OJ_0==1   & !inrange(INC_OJ,100,45000) & (INC_OJ !=99999)
replace  F_INC_OJ_1=2 if DEM_AGE>= 15 & F_INC_OJ_0==1   &  inlist(INC_OJ,0,.)
replace  F_INC_OJ_1=3 if DEM_AGE>= 15 & !(F_INC_OJ_0==1)& !inlist(INC_OJ,0,.)
replace  F_INC_OJ_1=9 if DEM_AGE<  15                   & !inlist(INC_OJ,0,.)
tab      F_INC_OJ_1, miss
tab      INC_OJ if F_INC_OJ_0==1, miss

********************************************************      INC_OJF   ********************************************/
* drop   F_INC_SJF_0
generate F_INC_SJF_0=0
replace  F_INC_SJF_0=1 if DEM_AGE>= 15 & INC_START_MODULE==1 & GLO_EMP==1 & WKT_NUMJBS==3 & (INC_OJ==99999)
tab      F_INC_SJF_0, missing

* drop   F_INC_SJF_1
generate F_INC_SJF_1=0
replace  F_INC_SJF_1=1 if DEM_AGE>= 15 & F_INC_SJF_0==1   & !inrange(INC_SJF,100,45000) & (INC_SJF !=99999)
replace  F_INC_SJF_1=2 if DEM_AGE>= 15 & F_INC_SJF_0==1   &  inlist(INC_SJF,0,.)
replace  F_INC_SJF_1=3 if DEM_AGE>= 15 & !(F_INC_SJF_0==1)& !inlist(INC_SJF,0,.)
replace  F_INC_SJF_1=9 if DEM_AGE<  15                    & !inlist(INC_SJF,0,.)
tab      F_INC_SJF_1, miss
tab      INC_SJF if F_INC_SJF_0==1, miss

********************************************************     INC_MSFS   ********************************************/
*drop   F_INC_MSFS_0
generate F_INC_MSFS_0=0
replace  F_INC_MSFS_0=1 if DEM_AGE>= 15 & INC_START_MODULE==1 & GLO_EMP==1 & (INC_MJ == 99999)
tab      F_INC_MSFS_0, missing

* drop   F_INC_MSFS_1
generate F_INC_MSFS_1=0
replace  F_INC_MSFS_1=1 if DEM_AGE>= 15 & F_INC_MSFS_0==1   & !inrange(INC_MSFS,1,8) & (INC_MSFS !=99999)
replace  F_INC_MSFS_1=2 if DEM_AGE>= 15 & F_INC_MSFS_0==1   &  inlist(INC_MSFS,0,.)
*replace  F_INC_MSFS_1=3 if DEM_AGE>= 15 & !(F_INC_MSFS_0==1)& !inlist(INC_MSFS,0,.)
replace  F_INC_MSFS_1=9 if DEM_AGE<  15 &                    !inlist(INC_MSFS,0,.)
tab      F_INC_MSFS_1  
tab      INC_MSFS if F_INC_MSFS_0==1 , miss
tab      INC_MSFS, miss

/********************************************************      INC_MFSF_OTH    ********************************************/
*drop    F_INC_MFSF_OTH_0
generate F_INC_MFSF_OTH_0=0
replace  F_INC_MFSF_OTH_0=1 if DEM_AGE>= 15 & INC_START_MODULE==1 & (GLO_EMP==0 & GLO_AGF_OPF==0) | (GLO_EMP==0 & GLO_AGF_OPF==1) & INC_MSFS==8
tab      F_INC_MFSF_OTH_0, miss

*drop    F_INC_MFSF_OTH_1
generate F_INC_MFSF_OTH_1=0
replace  F_INC_MFSF_OTH_1=1 if DEM_AGE>= 15 & F_INC_MFSF_OTH_0==1   & !inlist(INC_MFSF_OTH>="0" & INC_MFSF_OTH<="9999999999999999")
replace  F_INC_MFSF_OTH_1=2 if DEM_AGE>= 15 & F_INC_MFSF_OTH_0==1   &  inlist(INC_MFSF_OTH=="")
replace  F_INC_MFSF_OTH_1=3 if DEM_AGE>= 15 & !(F_INC_MFSF_OTH_0==1)& !inlist(INC_MFSF_OTH!=""
replace  F_INC_MFSF_OTH_1=9 if DEM_AGE<  15                         & !inlist(INC_MFSF_OTH!="")
tab      F_INC_MFSF_OTH_1, miss
tab      INC_MFSF_OTH  if F_INC_MFSF_OTH_1>0 , miss
tab      INC_MFSF_OTH , miss

/********************************************************      INC_FSA    ********************************************/
*drop    F_INC_FSA_0
generate F_INC_FSA_0=0
replace  F_INC_FSA_0=1 if DEM_AGE>= 15 & INC_START_MODULE==1 
tab      F_INC_FSA_0, miss

*drop    F_INC_FSA_1
generate F_INC_FSA_1=0
replace  F_INC_FSA_1=1 if DEM_AGE>= 15 & F_INC_FSA_0==1 &   !inlist(INC_FSA,1,2)
replace  F_INC_FSA_1=2 if DEM_AGE>= 15 & F_INC_FSA_0==1 &    inlist(INC_FSA,0,.)
replace  F_INC_FSA_1=3 if DEM_AGE>= 15 & !(F_INC_FSA_0==1)& !inlist(INC_FSA,0,.)
replace  F_INC_FSA_1=9 if DEM_AGE<  15                    & !inlist(INC_FSA,0,.)
tab      F_INC_FSA_1, miss
tab      INC_FSA  if F_INC_FSA_1>0 , miss
tab      INC_FSA , miss





*******************************************************************************************************************
*
*            TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_OPF_0 ///
F_OPF_START_MODULE_0 ///
F_OPF_CROP_CHK_0 ///
F_OPF_CROP_MKT_0 ///
F_OPF_CROP_MKT_MAIN_0 ///
F_OPF_CROP_HIS_0 ///
F_OPF_CROP_HIR_0 ///
F_OPF_CROP_HRS_0 ///
F_OPF_LIV_CHK_0 ///
F_OPF_LIV_MKT_0 ///
F_OPF_LIV_MKT_MAIN_0 ///
F_OPF_LIV_HIS_0 ///
F_OPF_LIV_HIR_0 ///
F_OPF_LIV_HRS_0 ///
F_OPF_FISH_CHK_0 ///
F_OPF_FISH_MKT_0 ///
F_OPF_FISH_MKT_MAIN_0 ///
F_OPF_FISH_HIS_0 ///
F_OPF_FISH_HIR_0 ///
F_OPF_FISH_HRS_0 ///
F_OPF_GATH_CHK_0 ///   
F_OPF_GATH_HRS_0 ///   
F_OPF_HUNT_CHK_0 ///   
F_OPF_HUNT_HRS_0 

foreach var of varlist $List_F_OPF_0 {
    tab `var' QUE_VERSION if `var'>0 , miss
}

global List_F_OPF_1 ///
F_OPF_START_MODULE_1 ///
F_OPF_CROP_CHK_1 ///
F_OPF_CROP_MKT_1 ///
F_OPF_CROP_MKT_MAIN_1 ///
F_OPF_CROP_HIS_1 ///
F_OPF_CROP_HIR_1 ///
F_OPF_CROP_HRS_1 ///
F_OPF_LIV_CHK_1 ///
F_OPF_LIV_MKT_1 ///
F_OPF_LIV_MKT_MAIN_1 ///
F_OPF_LIV_HIS_1 ///
F_OPF_LIV_HIR_1 ///
F_OPF_LIV_HRS_1 ///
F_OPF_FISH_CHK_1 ///
F_OPF_FISH_MKT_1 ///
F_OPF_FISH_MKT_MAIN_1 ///
F_OPF_FISH_HIS_1 ///
F_OPF_FISH_HIR_1 ///
F_OPF_FISH_HRS_1 ///
F_OPF_GATH_CHK_1 ///   
F_OPF_GATH_HRS_1 ///   
F_OPF_HUNT_CHK_1 ///   
F_OPF_HUNT_HRS_1 

foreach var of varlist $List_F_OPF_1 {
    tab `var' QUE_VERSION if `var'>0 , miss
}
