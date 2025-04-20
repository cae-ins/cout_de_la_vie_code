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
***                                            CHECK ON THE WKT  -  WORKING  TIME                               ***
***                                                                                                             *** 
*******************************************************************************************************************
*******************************************************************************************************************


/***************************************************     WKT_MJ_USHRS_REP     *****************************************/
* drop    	F_WKT_MJ_USHRS_REP_0
generate  	F_WKT_MJ_USHRS_REP_0=0
replace   	F_WKT_MJ_USHRS_REP_0=0
replace   	F_WKT_MJ_USHRS_REP_0=1 if DEM_AGE>= 15 & GLO_EMP==1
tab         F_WKT_MJ_USHRS_REP_0, miss

* drop    	F_WKT_MJ_USHRS_REP_1
generate  	F_WKT_MJ_USHRS_REP_1=0
replace   	F_WKT_MJ_USHRS_REP_1=0
replace   	F_WKT_MJ_USHRS_REP_1=1 if DEM_AGE>= 15 &   F_WKT_MJ_USHRS_REP_0==1   & !inrange(WKT_MJ_USHRS_REP,0,168) & WKT_MJ_USHRS_REP!=997 
replace   	F_WKT_MJ_USHRS_REP_1=2 if DEM_AGE>= 15 &   F_WKT_MJ_USHRS_REP_0==1   &  WKT_MJ_USHRS_REP==.
replace   	F_WKT_MJ_USHRS_REP_1=3 if DEM_AGE>= 15 & !(F_WKT_MJ_USHRS_REP_0==1)  &  WKT_MJ_USHRS_REP!=.
replace  	F_WKT_MJ_USHRS_REP_1=9 if DEM_AGE<  15                               &  WKT_MJ_USHRS_REP!=.

tab      	F_WKT_MJ_USHRS_REP_0  F_WKT_MJ_USHRS_REP_1, miss



/***************************************************     WKT_MJ_USDAY     *****************************************/
* drop    	F_WKT_MJ_USDAY_0
generate  	F_WKT_MJ_USDAY_0=0
replace   	F_WKT_MJ_USDAY_0=0
replace   	F_WKT_MJ_USDAY_0=1 if DEM_AGE>= 15 &  (GLO_EMP==1 & WKT_MJ_USHRS_REP==997)
tab         F_WKT_MJ_USDAY_0, miss

* drop    	F_WKT_MJ_USDAY_1
generate  	F_WKT_MJ_USDAY_1=0
replace   	F_WKT_MJ_USDAY_1=0
replace   	F_WKT_MJ_USDAY_1=1 if DEM_AGE>= 15 &  (F_WKT_MJ_USDAY_0==1)  & !inrange(WKT_MJ_USDAY,1,7) & WKT_MJ_USDAY!=997 
replace   	F_WKT_MJ_USDAY_1=2 if DEM_AGE>= 15 &  (F_WKT_MJ_USDAY_0==1)  &  WKT_MJ_USDAY==.
replace   	F_WKT_MJ_USDAY_1=3 if DEM_AGE>= 15 & !(F_WKT_MJ_USDAY_0==1)  &  WKT_MJ_USDAY!=.
replace  	F_WKT_MJ_USDAY_1=9 if DEM_AGE<  15 &                            WKT_MJ_USDAY!=.


tab      	F_WKT_MJ_USDAY_0  F_WKT_MJ_USDAY_1, miss

tab           WKT_MJ_USDAY if WKT_MJ_USDAY!=., miss



/***************************************************     WKT_MJ_USHRDY     *****************************************/
* drop    	F_WKT_MJ_USHRDY_0
generate  	F_WKT_MJ_USHRDY_0=0
replace   	F_WKT_MJ_USHRDY_0=0 
replace   	F_WKT_MJ_USHRDY_0=1 if DEM_AGE>= 15 &  GLO_EMP==1 & inlist(WKT_MJ_USHRS_REP,997) & WKT_MJ_USDAY!=997 
tab         F_WKT_MJ_USHRDY_0, miss

* drop    	F_WKT_MJ_USHRDY_1
generate  	F_WKT_MJ_USHRDY_1=0
replace   	F_WKT_MJ_USHRDY_1=0 
replace   	F_WKT_MJ_USHRDY_1=1 if DEM_AGE>= 15 &   F_WKT_MJ_USHRDY_0==1  & !inrange(WKT_MJ_USHRDY,0,16) & WKT_MJ_USHRDY!=997  
replace   	F_WKT_MJ_USHRDY_1=2 if DEM_AGE>= 15 &   F_WKT_MJ_USHRDY_0==1  &  WKT_MJ_USHRDY==.
replace   	F_WKT_MJ_USHRDY_1=3 if DEM_AGE>= 15 & !(F_WKT_MJ_USHRDY_0==1) &  WKT_MJ_USHRDY!=.
replace  	F_WKT_MJ_USHRDY_1=9 if DEM_AGE<  15                           &  WKT_MJ_USHRDY!=.

tab      	F_WKT_MJ_USHRDY_0  F_WKT_MJ_USHRDY_1, missing

tab           WKT_MJ_USHRDY if WKT_MJ_USHRDY!=., miss

/***************************************************     WKT_MJ_USHRS     *****************************************/
* drop    	F_WKT_MJ_USHRS_0
generate  	F_WKT_MJ_USHRS_0=0
replace   	F_WKT_MJ_USHRS_0=0
replace   	F_WKT_MJ_USHRS_0=1 if DEM_AGE>= 15 &  GLO_EMP==1
tab         F_WKT_MJ_USHRS_0, miss

* drop    	F_WKT_MJ_USHRS_1
generate  	F_WKT_MJ_USHRS_1=0
replace   	F_WKT_MJ_USHRS_1=0
replace   	F_WKT_MJ_USHRS_1=1 if DEM_AGE>= 15 &   F_WKT_MJ_USHRS_0==1   & !inrange(WKT_MJ_USHRS,0,168) & WKT_MJ_USHRS!=997 
replace   	F_WKT_MJ_USHRS_1=2 if DEM_AGE>= 15 &   F_WKT_MJ_USHRS_0==1   &          WKT_MJ_USHRS==.
replace   	F_WKT_MJ_USHRS_1=3 if DEM_AGE>= 15 & !(F_WKT_MJ_USHRS_0==1)  &          WKT_MJ_USHRS!=.
replace  	F_WKT_MJ_USHRS_1=9 if DEM_AGE<  15                           &          WKT_MJ_USHRS!=.

tab      	F_WKT_MJ_USHRS_0  F_WKT_MJ_USHRS_1, miss

tab           WKT_MJ_USHRS if WKT_MJ_USHRS!=., miss



/***************************************************     WKT_MJ_SAMEHRS     *****************************************/
* drop    	F_WKT_MJ_SAMEHRS_0
generate  	F_WKT_MJ_SAMEHRS_0=0
replace   	F_WKT_MJ_SAMEHRS_0=0
replace   	F_WKT_MJ_SAMEHRS_0=1 if DEM_AGE>= 15 & (GLO_EMP==1 &  ABS_JOB !=1 & WKT_MJ_USHRS!=997)
tab         F_WKT_MJ_SAMEHRS_0, miss

* drop    	F_WKT_MJ_SAMEHRS_1

generate  	F_WKT_MJ_SAMEHRS_1=0
replace   	F_WKT_MJ_SAMEHRS_1=0 
replace   	F_WKT_MJ_SAMEHRS_1=1 if DEM_AGE>= 15 &   F_WKT_MJ_SAMEHRS_0==1  & !inlist(WKT_MJ_SAMEHRS,1,2)
replace   	F_WKT_MJ_SAMEHRS_1=2 if DEM_AGE>= 15 &   F_WKT_MJ_SAMEHRS_0==1  &  inlist(WKT_MJ_SAMEHRS,.)
replace   	F_WKT_MJ_SAMEHRS_1=3 if DEM_AGE>= 15 & !(F_WKT_MJ_SAMEHRS_0==1) & !inlist(WKT_MJ_SAMEHRS,.)
replace  	F_WKT_MJ_SAMEHRS_1=9 if DEM_AGE<  15                            & !inlist(WKT_MJ_SAMEHRS,.)

tab      	F_WKT_MJ_SAMEHRS_0 F_WKT_MJ_SAMEHRS_1, miss

tab           WKT_MJ_SAMEHRS if WKT_MJ_SAMEHRS!=., miss 

/***************************************************     WKT_ABS_CHK1     *****************************************/
* drop    	F_WKT_ABS_CHK1_0
generate  	F_WKT_ABS_CHK1_0=0
replace   	F_WKT_ABS_CHK1_0=1 if DEM_AGE>= 15 & GLO_EMP==1 & ABS_JOB==1 
tab         F_WKT_ABS_CHK1_0, miss

* drop    	F_WKT_ABS_CHK1_1
generate  	F_WKT_ABS_CHK1_1=0
replace   	F_WKT_ABS_CHK1_1=1 if DEM_AGE>= 15 &   F_WKT_ABS_CHK1_0==1  & !inlist(WKT_ABS_CHK1,1,2)
replace   	F_WKT_ABS_CHK1_1=2 if DEM_AGE>= 15 &   F_WKT_ABS_CHK1_0==1  &  inlist(WKT_ABS_CHK1,.)
replace   	F_WKT_ABS_CHK1_1=3 if DEM_AGE>= 15 & !(F_WKT_ABS_CHK1_0==1) & !inlist(WKT_ABS_CHK1,.)
replace  	F_WKT_ABS_CHK1_1=9 if DEM_AGE<  15                          & !inlist(WKT_ABS_CHK1,.)

tab      	F_WKT_ABS_CHK1_0 F_WKT_ABS_CHK1_1, miss
tab           WKT_ABS_CHK1 



* 560 + 84 = 644
tab WKT_MJ_ACTHRS_REP


/***************************************************     WKT_MJ_ACTHRS_REP     *****************************************/

* drop    	F_WKT_MJ_ACTHRS_REP_0
generate  	F_WKT_MJ_ACTHRS_REP_0=0
replace   	F_WKT_MJ_ACTHRS_REP_0=0
replace   	F_WKT_MJ_ACTHRS_REP_0=1 if DEM_AGE>= 15 & GLO_EMP==1 & ((WKT_MJ_USHRS == 997 & WKT_ABS_CHK1 !=2) | WKT_MJ_SAMEHRS == 2 | WKT_ABS_CHK1 == 1)
tab         F_WKT_MJ_ACTHRS_REP_0, miss

* drop    	F_WKT_MJ_ACTHRS_REP_1
generate  	F_WKT_MJ_ACTHRS_REP_1=0
replace   	F_WKT_MJ_ACTHRS_REP_1=0 
replace   	F_WKT_MJ_ACTHRS_REP_1=1 if DEM_AGE>= 15 &   F_WKT_MJ_ACTHRS_REP_0==1  &    !inrange(WKT_MJ_ACTHRS_REP,0,168) & WKT_MJ_ACTHRS_REP !=997  
replace   	F_WKT_MJ_ACTHRS_REP_1=2 if DEM_AGE>= 15 &   F_WKT_MJ_ACTHRS_REP_0==1  &             WKT_MJ_ACTHRS_REP ==.
replace   	F_WKT_MJ_ACTHRS_REP_1=3 if DEM_AGE>= 15 & !(F_WKT_MJ_ACTHRS_REP_0==1) &             WKT_MJ_ACTHRS_REP !=.
replace  	F_WKT_MJ_ACTHRS_REP_1=9 if DEM_AGE<  15                           &             WKT_MJ_ACTHRS_REP !=.

tab      	F_WKT_MJ_ACTHRS_REP_0  F_WKT_MJ_ACTHRS_REP_1, miss


// list        interview__key ENU_1 ENU_2 PPNO DEM_NAME WKT_MJ_ACTHRS WKT_MJ_ACTHRS_REP SUSO_VERSION WKT_MJ_USHRS WKT_MJ_SAMEHRS WKT_ABS_CHK1 if F_WKT_MJ_ACTHRS_REP_0==1 & F_WKT_MJ_ACTHRS_REP_1==2



/***************************************************     WKT_MJ_ACTHRS     *****************************************/

* drop    	F_WKT_MJ_ACTHRS_0
generate  	F_WKT_MJ_ACTHRS_0=0
replace   	F_WKT_MJ_ACTHRS_0=0
replace   	F_WKT_MJ_ACTHRS_0=1 if DEM_AGE>= 15 & GLO_EMP==1
tab         F_WKT_MJ_ACTHRS_0, miss

* drop    	F_WKT_MJ_ACTHRS_1
generate  	F_WKT_MJ_ACTHRS_1=0
replace   	F_WKT_MJ_ACTHRS_1=0 
replace   	F_WKT_MJ_ACTHRS_1=1 if DEM_AGE>= 15 &   F_WKT_MJ_ACTHRS_0==1  &    !inrange(WKT_MJ_ACTHRS,0,168) & WKT_MJ_ACTHRS !=997  
replace   	F_WKT_MJ_ACTHRS_1=2 if DEM_AGE>= 15 &   F_WKT_MJ_ACTHRS_0==1  &             WKT_MJ_ACTHRS ==.
replace   	F_WKT_MJ_ACTHRS_1=3 if DEM_AGE>= 15 & !(F_WKT_MJ_ACTHRS_0==1) &             WKT_MJ_ACTHRS !=.
replace  	F_WKT_MJ_ACTHRS_1=9 if DEM_AGE<  15                           &             WKT_MJ_ACTHRS !=.

tab      	F_WKT_MJ_ACTHRS_0  F_WKT_MJ_ACTHRS_1, miss

tab            WKT_MJ_ACTHRS WKT_MJ_SAMEHRS if F_WKT_MJ_ACTHRS_0==1


/***************************************************     WKT_SJ_USHRS     *****************************************/
* drop    	F_WKT_SJ_USHRS_0
generate  	F_WKT_SJ_USHRS_0=0
replace   	F_WKT_SJ_USHRS_0=1 if DEM_AGE>= 15 & GLO_EMP==1 & MJJ_MULT==2
tab         F_WKT_SJ_USHRS_0, miss

* drop    	F_WKT_SJ_USHRS_1
generate  	F_WKT_SJ_USHRS_1=0
replace   	F_WKT_SJ_USHRS_1=1 if DEM_AGE>= 15 &   F_WKT_SJ_USHRS_0==1   & !inrange(WKT_SJ_USHRS,0,168) & WKT_SJ_USHRS!=997
replace   	F_WKT_SJ_USHRS_1=2 if DEM_AGE>= 15 &   F_WKT_SJ_USHRS_0==1   &          WKT_SJ_USHRS==.
replace   	F_WKT_SJ_USHRS_1=3 if DEM_AGE>= 15 & !(F_WKT_SJ_USHRS_0==1)  &          WKT_SJ_USHRS!=.
replace  	F_WKT_SJ_USHRS_1=9 if DEM_AGE<  15                           &          WKT_SJ_USHRS!=.

tab      	F_WKT_SJ_USHRS_0  F_WKT_SJ_USHRS_1, miss

tab           WKT_SJ_USHRS if WKT_SJ_USHRS!=., miss



/***************************************************     WKT_SJ_SAMEHRS     *****************************************/
* drop    	F_WKT_SJ_SAMEHRS_0
generate  	F_WKT_SJ_SAMEHRS_0=0
replace   	F_WKT_SJ_SAMEHRS_0=1 if DEM_AGE>= 15 & GLO_EMP==1 & MJJ_MULT==2 & WKT_SJ_USHRS!=997
tab         F_WKT_SJ_SAMEHRS_0, miss

* drop    	F_WKT_SJ_SAMEHRS_1
generate  	F_WKT_SJ_SAMEHRS_1=0
replace   	F_WKT_SJ_SAMEHRS_1=1 if DEM_AGE>= 15 &  F_WKT_SJ_SAMEHRS_0==1  & !inlist(WKT_SJ_SAMEHRS,1,2)
replace   	F_WKT_SJ_SAMEHRS_1=2 if DEM_AGE>= 15 &  F_WKT_SJ_SAMEHRS_0==1  &  inlist(WKT_SJ_SAMEHRS,.)
replace   	F_WKT_SJ_SAMEHRS_1=3 if DEM_AGE>= 15 & !(F_WKT_SJ_SAMEHRS_0==1)& !inlist(WKT_SJ_SAMEHRS,.)
replace  	F_WKT_SJ_SAMEHRS_1=9 if DEM_AGE<  15                           & !inlist(WKT_SJ_SAMEHRS,.)

tab      	F_WKT_SJ_SAMEHRS_0  F_WKT_SJ_SAMEHRS_1, miss
tab           WKT_SJ_SAMEHRS if WKT_SJ_SAMEHRS!=., miss 


/***************************************************     WKT_SJ_ACTHRS_REP     *****************************************/
* drop    	F_WKT_SJ_ACTHRS_REP_0
generate  	F_WKT_SJ_ACTHRS_REP_0=0
replace   	F_WKT_SJ_ACTHRS_REP_0=1 if DEM_AGE>= 15 &GLO_EMP==1 & MJJ_MULT==2 & (WKT_SJ_SAMEHRS==2 | WKT_SJ_USHRS==997)
tab         F_WKT_SJ_ACTHRS_REP_0, miss

* drop    	F_WKT_SJ_ACTHRS_REP_1
generate  	F_WKT_SJ_ACTHRS_REP_1=0
replace   	F_WKT_SJ_ACTHRS_REP_1=1 if DEM_AGE>= 15 &   F_WKT_SJ_ACTHRS_REP_0==1  & !inrange(WKT_SJ_ACTHRS_REP,0,168) & WKT_SJ_ACTHRS_REP!=997
replace   	F_WKT_SJ_ACTHRS_REP_1=2 if DEM_AGE>= 15 &   F_WKT_SJ_ACTHRS_REP_0==1  &          WKT_SJ_ACTHRS_REP==.
replace   	F_WKT_SJ_ACTHRS_REP_1=3 if DEM_AGE>= 15 & !(F_WKT_SJ_ACTHRS_REP_0==1) &          WKT_SJ_ACTHRS_REP!=.
replace  	F_WKT_SJ_ACTHRS_REP_1=9 if DEM_AGE<  15                               &          WKT_SJ_ACTHRS_REP!=.

tab      	F_WKT_SJ_ACTHRS_REP_0 F_WKT_SJ_ACTHRS_REP_1, miss


/***************************************************     WKT_SJ_ACTHRS     *****************************************/
* drop    	F_WKT_SJ_ACTHRS_0
generate  	F_WKT_SJ_ACTHRS_0=0
replace   	F_WKT_SJ_ACTHRS_0=1 if DEM_AGE>= 15 & GLO_EMP==1 & MJJ_MULT==2
tab         F_WKT_SJ_ACTHRS_0, miss

* drop    	F_WKT_SJ_ACTHRS_1
generate  	F_WKT_SJ_ACTHRS_1=0
replace   	F_WKT_SJ_ACTHRS_1=1 if DEM_AGE>= 15 &  F_WKT_SJ_ACTHRS_0==1  & !inrange(WKT_SJ_ACTHRS,0,168) & WKT_SJ_ACTHRS!=997
replace   	F_WKT_SJ_ACTHRS_1=2 if DEM_AGE>= 15 &  F_WKT_SJ_ACTHRS_0==1  &          WKT_SJ_ACTHRS==.
replace   	F_WKT_SJ_ACTHRS_1=3 if DEM_AGE>= 15 & !(F_WKT_SJ_ACTHRS_0==1)&          WKT_SJ_ACTHRS!=.
replace  	F_WKT_SJ_ACTHRS_1=9 if DEM_AGE<  15                          &          WKT_SJ_ACTHRS!=.

tab      	F_WKT_SJ_ACTHRS_0 F_WKT_SJ_ACTHRS_1, miss


/***************************************************     WKT_OJ_USHRS     *****************************************/
* drop    	F_WKT_OJ_USHRS_0
generate  	F_WKT_OJ_USHRS_0=0
replace   	F_WKT_OJ_USHRS_0=1 if DEM_AGE>= 15 &  GLO_EMP==1 & MJJ_MULT==2 & WKT_OJ==1
tab         F_WKT_OJ_USHRS_0, miss

* drop    	F_WKT_OJ_USHRS_1
generate  	F_WKT_OJ_USHRS_1=0
replace   	F_WKT_OJ_USHRS_1=1 if DEM_AGE>= 15 &   F_WKT_OJ_USHRS_0==1  & !inrange(WKT_OJ_USHRS,0,168) & WKT_OJ_USHRS!=997 
replace   	F_WKT_OJ_USHRS_1=2 if DEM_AGE>= 15 &   F_WKT_OJ_USHRS_0==1  &          WKT_OJ_USHRS==.
replace   	F_WKT_OJ_USHRS_1=3 if DEM_AGE>= 15 & !(F_WKT_OJ_USHRS_0==1) &          WKT_OJ_USHRS!=.
replace  	F_WKT_OJ_USHRS_1=9 if DEM_AGE<  15                          &          WKT_OJ_USHRS!=.

tab      	F_WKT_OJ_USHRS_0  F_WKT_OJ_USHRS_1, miss

/***************************************************     WKT_OJ_SAMEHRS     *****************************************/
* drop    	F_WKT_OJ_SAMEHRS_0
generate  	F_WKT_OJ_SAMEHRS_0=0
replace   	F_WKT_OJ_SAMEHRS_0=1 if DEM_AGE>= 15 &  GLO_EMP==1 & MJJ_MULT==2 & WKT_OJ==1 & WKT_OJ_USHRS!=997
tab         F_WKT_OJ_SAMEHRS_0, miss

* drop    	F_WKT_OJ_SAMEHRS_1
generate  	F_WKT_OJ_SAMEHRS_1=0
replace   	F_WKT_OJ_SAMEHRS_1=1 if DEM_AGE>= 15 &   F_WKT_OJ_SAMEHRS_0==1  & !inlist(WKT_OJ_SAMEHRS,1,2)
replace   	F_WKT_OJ_SAMEHRS_1=2 if DEM_AGE>= 15 &   F_WKT_OJ_SAMEHRS_0==1  &  inlist(WKT_OJ_SAMEHRS,.)
replace   	F_WKT_OJ_SAMEHRS_1=3 if DEM_AGE>= 15 & !(F_WKT_OJ_SAMEHRS_0==1) & !inlist(WKT_OJ_SAMEHRS,.)
replace  	F_WKT_OJ_SAMEHRS_1=9 if DEM_AGE<  15                            & !inlist(WKT_OJ_SAMEHRS,.)

tab      	F_WKT_OJ_SAMEHRS_0  F_WKT_OJ_SAMEHRS_1, miss

/***************************************************     WKT_OJ_ACTHRS_REP     *****************************************/
* drop    	F_WKT_OJ_ACTHRS_REP_0
generate  	F_WKT_OJ_ACTHRS_REP_0=0
replace   	F_WKT_OJ_ACTHRS_REP_0=1 if DEM_AGE>= 15 & GLO_EMP==1 & MJJ_MULT==2 & WKT_OJ==1 & ( WKT_OJ_SAMEHRS==2 | WKT_OJ_USHRS==997 )
tab         F_WKT_OJ_ACTHRS_REP_0, miss

* drop    	F_WKT_OJ_ACTHRS_REP_1
generate  	F_WKT_OJ_ACTHRS_REP_1=0
replace   	F_WKT_OJ_ACTHRS_REP_1=1 if DEM_AGE>= 15 &   F_WKT_OJ_ACTHRS_REP_0==1  & !inrange(WKT_OJ_ACTHRS_REP,0,168) & WKT_OJ_ACTHRS_REP!=997 
replace   	F_WKT_OJ_ACTHRS_REP_1=2 if DEM_AGE>= 15 &   F_WKT_OJ_ACTHRS_REP_0==1  &          WKT_OJ_ACTHRS_REP==.
replace   	F_WKT_OJ_ACTHRS_REP_1=3 if DEM_AGE>= 15 & !(F_WKT_OJ_ACTHRS_REP_0==1) &          WKT_OJ_ACTHRS_REP!=.
replace  	F_WKT_OJ_ACTHRS_REP_1=9 if DEM_AGE<  15                               &          WKT_OJ_ACTHRS_REP!=.

tab      	F_WKT_OJ_ACTHRS_REP_0  F_WKT_OJ_ACTHRS_REP_1, miss

/***************************************************     WKT_OJ_ACTHRS     *****************************************/
* drop    	F_WKT_OJ_ACTHRS_0
generate  	F_WKT_OJ_ACTHRS_0=0
replace   	F_WKT_OJ_ACTHRS_0=1 if DEM_AGE>= 15 & GLO_EMP==1 & MJJ_MULT==2 & WKT_OJ==1
tab         F_WKT_OJ_ACTHRS_0, miss

* drop    	F_WKT_OJ_ACTHRS_1
generate  	F_WKT_OJ_ACTHRS_1=0
replace   	F_WKT_OJ_ACTHRS_1=1 if DEM_AGE>= 15 &   F_WKT_OJ_ACTHRS_0==1  & !inrange(WKT_OJ_ACTHRS,0,168) & WKT_OJ_ACTHRS!=997 
replace   	F_WKT_OJ_ACTHRS_1=2 if DEM_AGE>= 15 &   F_WKT_OJ_ACTHRS_0==1  &          WKT_OJ_ACTHRS==.
replace   	F_WKT_OJ_ACTHRS_1=3 if DEM_AGE>= 15 & !(F_WKT_OJ_ACTHRS_0==1) &          WKT_OJ_ACTHRS!=.
replace  	F_WKT_OJ_ACTHRS_1=9 if DEM_AGE<  15                           &          WKT_OJ_ACTHRS!=.

tab      	F_WKT_OJ_ACTHRS_0  F_WKT_OJ_ACTHRS_1, miss

tab           WKT_OJ_ACTHRS if WKT_OJ_ACTHRS!=., miss


/***************************************************     WKT_USHRSTOT_CALC     *****************************************/
* drop    	F_WKT_USHRSTOT_CALC_0
generate  	F_WKT_USHRSTOT_CALC_0=0
replace   	F_WKT_USHRSTOT_CALC_0=0
replace   	F_WKT_USHRSTOT_CALC_0=1 if DEM_AGE>= 15 &  GLO_EMP==1
tab         F_WKT_USHRSTOT_CALC_0, miss

* drop    	F_WKT_USHRSTOT_CALC_1
generate  	F_WKT_USHRSTOT_CALC_1=0
replace   	F_WKT_USHRSTOT_CALC_1=1 if DEM_AGE>= 15 &   F_WKT_USHRSTOT_CALC_0==1  & !inrange(WKT_USHRSTOT_CALC,0,168) & WKT_USHRSTOT_CALC !=997
replace   	F_WKT_USHRSTOT_CALC_1=2 if DEM_AGE>= 15 &   F_WKT_USHRSTOT_CALC_0==1  &          WKT_USHRSTOT_CALC==.
replace   	F_WKT_USHRSTOT_CALC_1=3 if DEM_AGE>= 15 & !(F_WKT_USHRSTOT_CALC_0==1) &          WKT_USHRSTOT_CALC!=.
replace  	F_WKT_USHRSTOT_CALC_1=9 if DEM_AGE<  15                               &          WKT_USHRSTOT_CALC!=.

tab      	F_WKT_USHRSTOT_CALC_0  F_WKT_USHRSTOT_CALC_1, miss

                                                  
/***************************************************     WKT_USHRSTOT_CHK     *****************************************/
* drop    	F_WKT_USHRSTOT_CHK_0
generate  	F_WKT_USHRSTOT_CHK_0=0
replace   	F_WKT_USHRSTOT_CHK_0=1 if DEM_AGE>= 15 &  GLO_EMP==1 & MJJ_MULT==2 &  !inlist(WKT_USHRSTOT_CALC,.,997) 
tab         F_WKT_USHRSTOT_CHK_0, miss

* drop    	F_WKT_USHRSTOT_CHK_1
generate  	F_WKT_USHRSTOT_CHK_1=0
replace   	F_WKT_USHRSTOT_CHK_1=1 if DEM_AGE>= 15 &   F_WKT_USHRSTOT_CHK_0==1   &  !inlist(WKT_USHRSTOT_CHK,1,2)
replace   	F_WKT_USHRSTOT_CHK_1=2 if DEM_AGE>= 15 &   F_WKT_USHRSTOT_CHK_0==1   &   inlist(WKT_USHRSTOT_CHK,.)
replace   	F_WKT_USHRSTOT_CHK_1=3 if DEM_AGE>= 15 & !(F_WKT_USHRSTOT_CHK_0==1)  &  !inlist(WKT_USHRSTOT_CHK,.)
replace  	F_WKT_USHRSTOT_CHK_1=9 if DEM_AGE<15                                 &  !inlist(WKT_USHRSTOT_CHK,.)

tab      	F_WKT_USHRSTOT_CHK_0  F_WKT_USHRSTOT_CHK_1, miss

tab           WKT_USHRSTOT_CHK if WKT_USHRSTOT_CHK!=., miss

/***************************************************     WKT_USHRSTOT_REP    *****************************************/
* drop    	F_WKT_USHRSTOT_REP_0
generate  	F_WKT_USHRSTOT_REP_0=0
replace   	F_WKT_USHRSTOT_REP_0=1 if DEM_AGE>= 15 &  GLO_EMP==1 & MJJ_MULT==2 & (WKT_USHRSTOT_CHK==2 | WKT_USHRSTOT_CALC==997) 
tab         F_WKT_USHRSTOT_REP_0, miss

* drop    	F_WKT_USHRSTOT_REP_1
generate  	F_WKT_USHRSTOT_REP_1=0
replace   	F_WKT_USHRSTOT_REP_1=1 if DEM_AGE>= 15 &   F_WKT_USHRSTOT_REP_0==1  & !inrange(WKT_USHRSTOT_REP,0,168) &  WKT_USHRSTOT_REP!=997
replace   	F_WKT_USHRSTOT_REP_1=2 if DEM_AGE>= 15 &   F_WKT_USHRSTOT_REP_0==1  &          WKT_USHRSTOT_REP==.
replace   	F_WKT_USHRSTOT_REP_1=3 if DEM_AGE>= 15 & !(F_WKT_USHRSTOT_REP_0==1) &          WKT_USHRSTOT_REP!=.
replace  	F_WKT_USHRSTOT_REP_1=9 if DEM_AGE<  15                              &          WKT_USHRSTOT_REP!=.

tab      	F_WKT_USHRSTOT_REP_0  F_WKT_USHRSTOT_REP_1, miss

tab           WKT_USHRSTOT_REP, miss

/***************************************************     WKT_USHRSTOT    *****************************************/

generate  	F_WKT_USHRSTOT_0=0
replace   	F_WKT_USHRSTOT_0=0
replace   	F_WKT_USHRSTOT_0=1 if DEM_AGE>= 15 &  GLO_EMP==1
tab         F_WKT_USHRSTOT_0, miss							   

generate  	F_WKT_USHRSTOT_1=0
replace   	F_WKT_USHRSTOT_1=0
replace   	F_WKT_USHRSTOT_1=1 if DEM_AGE>= 15 &   F_WKT_USHRSTOT_0==1  &    !inrange(WKT_USHRSTOT,0,168)  &  WKT_USHRSTOT!=997
replace   	F_WKT_USHRSTOT_1=2 if DEM_AGE>= 15 &   F_WKT_USHRSTOT_0==1  &             WKT_USHRSTOT ==.
replace   	F_WKT_USHRSTOT_1=3 if DEM_AGE>= 15 & !(F_WKT_USHRSTOT_0==1) &             WKT_USHRSTOT !=.
replace  	F_WKT_USHRSTOT_1=9 if DEM_AGE<  15                          &             WKT_USHRSTOT !=.

tab      	F_WKT_USHRSTOT_0  F_WKT_USHRSTOT_1, miss

tab              WKT_USHRSTOT F_WKT_USHRSTOT_0, miss



/***************************************************     WKT_ACHRSTOT_CALC     *****************************************/
* drop    	F_WKT_ACHRSTOT_CALC_0
generate  	F_WKT_ACHRSTOT_CALC_0=0
replace   	F_WKT_ACHRSTOT_CALC_0=1 if DEM_AGE>= 15 &  GLO_EMP==1
tab         F_WKT_ACHRSTOT_CALC_0, miss

* drop    	F_WKT_ACHRSTOT_CALC_1
generate  	F_WKT_ACHRSTOT_CALC_1=0
replace   	F_WKT_ACHRSTOT_CALC_1=1 if DEM_AGE>= 15 &   F_WKT_ACHRSTOT_CALC_0==1  & !inrange(WKT_ACHRSTOT_CALC,0,168) & WKT_ACHRSTOT_CALC !=997
replace   	F_WKT_ACHRSTOT_CALC_1=2 if DEM_AGE>= 15 &   F_WKT_ACHRSTOT_CALC_0==1  &          WKT_ACHRSTOT_CALC==.
replace   	F_WKT_ACHRSTOT_CALC_1=3 if DEM_AGE>= 15 & !(F_WKT_ACHRSTOT_CALC_0==1) &          WKT_ACHRSTOT_CALC!=.
replace  	F_WKT_ACHRSTOT_CALC_1=9 if DEM_AGE<  15                               &          WKT_ACHRSTOT_CALC!=.

tab      	F_WKT_ACHRSTOT_CALC_0  F_WKT_ACHRSTOT_CALC_1, miss


/***************************************************     WKT_ACHRSTOT_CHK     *****************************************/
* drop    	F_WKT_ACHRSTOT_CHK_0
generate  	F_WKT_ACHRSTOT_CHK_0=0
replace   	F_WKT_ACHRSTOT_CHK_0=1 if DEM_AGE>= 15 & GLO_EMP==1 & MJJ_MULT==2 & WKT_ACHRSTOT_CALC!=997
tab         F_WKT_ACHRSTOT_CHK_0, miss

* drop    	F_WKT_ACHRSTOT_CHK_1
generate  	F_WKT_ACHRSTOT_CHK_1=0
replace   	F_WKT_ACHRSTOT_CHK_1=1 if DEM_AGE>= 15 &   F_WKT_ACHRSTOT_CHK_0==1   &  !inlist(WKT_ACHRSTOT_CHK,1,2)
replace   	F_WKT_ACHRSTOT_CHK_1=2 if DEM_AGE>= 15 &   F_WKT_ACHRSTOT_CHK_0==1   &   inlist(WKT_ACHRSTOT_CHK,.)
replace   	F_WKT_ACHRSTOT_CHK_1=3 if DEM_AGE>= 15 & !(F_WKT_ACHRSTOT_CHK_0==1)  &  !inlist(WKT_ACHRSTOT_CHK,.)
replace  	F_WKT_ACHRSTOT_CHK_1=9 if DEM_AGE<  15                               &  !inlist(WKT_ACHRSTOT_CHK,.)

tab      	F_WKT_ACHRSTOT_CHK_0  F_WKT_ACHRSTOT_CHK_1, miss
tab           WKT_ACHRSTOT_CHK if WKT_ACHRSTOT_CHK!=., miss

/***************************************************     WKT_ACHRSTOT_REP    *****************************************/
* drop    	F_WKT_ACHRSTOT_REP_0
generate  	F_WKT_ACHRSTOT_REP_0=0
replace   	F_WKT_ACHRSTOT_REP_0=1 if DEM_AGE>= 15 &  GLO_EMP==1 & MJJ_MULT==2  & (WKT_ACHRSTOT_CHK==2 | WKT_ACHRSTOT_CALC==997)
tab         F_WKT_ACHRSTOT_REP_0, miss

* drop    	F_WKT_ACHRSTOT_REP_1
generate  	F_WKT_ACHRSTOT_REP_1=0
replace   	F_WKT_ACHRSTOT_REP_1=1 if DEM_AGE>= 15 &   F_WKT_ACHRSTOT_REP_0==1  &  !inrange(WKT_ACHRSTOT_REP,0,168) &  WKT_ACHRSTOT_REP!=997
replace   	F_WKT_ACHRSTOT_REP_1=2 if DEM_AGE>= 15 &   F_WKT_ACHRSTOT_REP_0==1  &           WKT_ACHRSTOT_REP==.
replace   	F_WKT_ACHRSTOT_REP_1=3 if DEM_AGE>= 15 & !(F_WKT_ACHRSTOT_REP_0==1) &           WKT_ACHRSTOT_REP!=.
replace  	F_WKT_ACHRSTOT_REP_1=9 if DEM_AGE<  15                              &           WKT_ACHRSTOT_REP!=.

tab      	F_WKT_ACHRSTOT_REP_0  F_WKT_ACHRSTOT_REP_1, miss
tab           WKT_ACHRSTOT_REP if WKT_ACHRSTOT_REP!=., miss

/***************************************************     WKT_ACHRSTOT    *****************************************/
* drop    	F_WKT_ACHRSTOT_0
generate  	F_WKT_ACHRSTOT_0=0
replace   	F_WKT_ACHRSTOT_0=0
replace   	F_WKT_ACHRSTOT_0=1 if DEM_AGE>= 15 &  GLO_EMP==1
tab         F_WKT_ACHRSTOT_0, miss							   

* drop    	F_WKT_ACHRSTOT_1
generate  	F_WKT_ACHRSTOT_1=0
replace   	F_WKT_ACHRSTOT_1=1 if DEM_AGE>= 15 &   F_WKT_ACHRSTOT_0==1  &  !inrange(WKT_ACHRSTOT,0,168) &  WKT_ACHRSTOT!=997
replace   	F_WKT_ACHRSTOT_1=2 if DEM_AGE>= 15 &   F_WKT_ACHRSTOT_0==1  &           WKT_ACHRSTOT==.
replace   	F_WKT_ACHRSTOT_1=3 if DEM_AGE>= 15 & !(F_WKT_ACHRSTOT_0==1) &           WKT_ACHRSTOT!=.
replace  	F_WKT_ACHRSTOT_1=9 if DEM_AGE<  15                          &           WKT_ACHRSTOT!=.

tab      	F_WKT_ACHRSTOT_0  F_WKT_ACHRSTOT_1, miss
tab           WKT_ACHRSTOT 

/***************************************************     WKT_SRH_OJB     *****************************************/
* drop    	F_WKT_SRH_OJB_0
generate  	F_WKT_SRH_OJB_0=0
replace   	F_WKT_SRH_OJB_0=1 if DEM_AGE>= 15 &  GLO_EMP==1
tab         F_WKT_SRH_OJB_0, miss

* drop    	F_WKT_SRH_OJB_1
generate  	F_WKT_SRH_OJB_1=0
replace   	F_WKT_SRH_OJB_1=1 if DEM_AGE>= 15 &   F_WKT_SRH_OJB_0==1  & !inlist(WKT_SRH_OJB,1,2)
replace   	F_WKT_SRH_OJB_1=2 if DEM_AGE>= 15 &   F_WKT_SRH_OJB_0==1  &  inlist(WKT_SRH_OJB,0,.)
replace   	F_WKT_SRH_OJB_1=3 if DEM_AGE>= 15 & !(F_WKT_SRH_OJB_0==1) & !inlist(WKT_SRH_OJB,.)
replace  	F_WKT_SRH_OJB_1=9 if DEM_AGE<  15                         & !inlist(WKT_SRH_OJB,.)

tab      	F_WKT_SRH_OJB_0 F_WKT_SRH_OJB_1, miss

tab           WKT_SRH_OJB 

/***************************************************     WKT_WNT_MRH     *****************************************/
* drop    	F_WKT_WNT_MRH_0
generate  	F_WKT_WNT_MRH_0=0
replace   	F_WKT_WNT_MRH_0=0
replace   	F_WKT_WNT_MRH_0=1 if DEM_AGE>= 15 &  GLO_EMP==1
tab         F_WKT_WNT_MRH_0, miss

* drop    	F_WKT_WNT_MRH_1
generate  	F_WKT_WNT_MRH_1=0
replace     F_WKT_WNT_MRH_1=0
replace   	F_WKT_WNT_MRH_1=1 if DEM_AGE>= 15 &   F_WKT_WNT_MRH_0==1   & !inlist(WKT_WNT_MRH,1,2)
replace   	F_WKT_WNT_MRH_1=2 if DEM_AGE>= 15 &   F_WKT_WNT_MRH_0==1   &  inlist(WKT_WNT_MRH,.)
replace   	F_WKT_WNT_MRH_1=3 if DEM_AGE>= 15 & !(F_WKT_WNT_MRH_0==1)  & !inlist(WKT_WNT_MRH,.)
replace  	F_WKT_WNT_MRH_1=9 if DEM_AGE<  15                          & !inlist(WKT_WNT_MRH,.)

tab      	F_WKT_WNT_MRH_0  F_WKT_WNT_MRH_1, miss
tab           WKT_WNT_MRH 

/***************************************************     WKT_AVL_MRH     *****************************************/
* drop    	F_WKT_AVL_MRH_0
generate  	F_WKT_AVL_MRH_0=0
replace     F_WKT_AVL_MRH_0=0
replace   	F_WKT_AVL_MRH_0=1 if DEM_AGE>= 15 & GLO_EMP==1 & WKT_WNT_MRH==1 & WKT_USHRSTOT<30
tab         F_WKT_AVL_MRH_0, miss

* drop    	F_WKT_AVL_MRH_1
generate  	F_WKT_AVL_MRH_1=0
replace	    F_WKT_AVL_MRH_1=0
replace   	F_WKT_AVL_MRH_1=1 if DEM_AGE>= 15 &   F_WKT_AVL_MRH_0==1  & !inlist(WKT_AVL_MRH,1,2)
replace   	F_WKT_AVL_MRH_1=2 if DEM_AGE>= 15 &   F_WKT_AVL_MRH_0==1  &  inlist(WKT_AVL_MRH,.)
replace   	F_WKT_AVL_MRH_1=3 if DEM_AGE>= 15 & !(F_WKT_AVL_MRH_0==1) & !inlist(WKT_AVL_MRH,.)
replace  	F_WKT_AVL_MRH_1=9 if DEM_AGE<  15                         & !inlist(WKT_AVL_MRH,.)

tab      	F_WKT_AVL_MRH_0  F_WKT_AVL_MRH_1, miss
tab           WKT_AVL_MRH if WKT_AVL_MRH!=., miss

/***************************************************     WKT_NUM_MRH     *****************************************/
* drop    	F_WKT_NUM_MRH_0
generate  	F_WKT_NUM_MRH_0=0
replace   	F_WKT_NUM_MRH_0=1 if DEM_AGE>= 15 &  (GLO_EMP==1 & WKT_AVL_MRH==1) 
tab         F_WKT_NUM_MRH_0, miss

* drop    	F_WKT_NUM_MRH_1
generate  	F_WKT_NUM_MRH_1=0
replace   	F_WKT_NUM_MRH_1=1 if DEM_AGE>= 15 &   F_WKT_NUM_MRH_0==1  &  !inrange(WKT_NUM_MRH,0,168) &  WKT_NUM_MRH!=997
replace   	F_WKT_NUM_MRH_1=2 if DEM_AGE>= 15 &   F_WKT_NUM_MRH_0==1  &           WKT_NUM_MRH==.
replace   	F_WKT_NUM_MRH_1=3 if DEM_AGE>= 15 & !(F_WKT_NUM_MRH_0==1) &           WKT_NUM_MRH!=.
replace  	F_WKT_NUM_MRH_1=9 if DEM_AGE<  15                         &           WKT_NUM_MRH!=.

tab      	F_WKT_NUM_MRH_0  F_WKT_NUM_MRH_1, miss
tab           WKT_NUM_MRH 



*******************************************************************************************************************
*
*            TABULATION OF EDITING FLAGS
* 
*******************************************************************************************************************

global List_F_WKT_0 ///
F_WKT_MJ_USHRS_REP_0 ///
F_WKT_MJ_USDAY_0 ///
F_WKT_MJ_USHRDY_0 ///
F_WKT_MJ_USHRS_0 ///
F_WKT_MJ_SAMEHRS_0 ///
F_WKT_ABS_CHK1_0 ///
F_WKT_MJ_ACTHRS_REP_0 ///
F_WKT_MJ_ACTHRS_0 ///
F_WKT_SJ_USHRS_0 ///
F_WKT_SJ_SAMEHRS_0 ///
F_WKT_SJ_ACTHRS_REP_0 ///
F_WKT_SJ_ACTHRS_0 ///
F_WKT_OJ_USHRS_0 ///
F_WKT_OJ_SAMEHRS_0 ///
F_WKT_OJ_ACTHRS_REP_0 ///
F_WKT_OJ_ACTHRS_0 ///
F_WKT_USHRSTOT_CALC_0 ///
F_WKT_USHRSTOT_CHK_0 ///
F_WKT_USHRSTOT_REP_0 ///
F_WKT_USHRSTOT_0 ///
F_WKT_ACHRSTOT_CALC_0 ///
F_WKT_ACHRSTOT_CHK_0 ///
F_WKT_ACHRSTOT_REP_0 ///
F_WKT_ACHRSTOT_0 ///
F_WKT_SRH_OJB_0 ///
F_WKT_WNT_MRH_0 ///
F_WKT_AVL_MRH_0 ///
F_WKT_NUM_MRH_0 ///


foreach var of varlist $List_F_WKT_0 {
    tab `var' if `var'>0 , miss
}

global List_F_WKT_1 ///
F_WKT_MJ_USHRS_REP_1 ///
F_WKT_MJ_USDAY_1 ///
F_WKT_MJ_USHRDY_1 ///
F_WKT_MJ_USHRS_1 ///
F_WKT_MJ_SAMEHRS_1 ///
F_WKT_ABS_CHK1_1 ///
F_WKT_MJ_ACTHRS_REP_1 ///
F_WKT_MJ_ACTHRS_1 ///
F_WKT_SJ_USHRS_1 ///
F_WKT_SJ_SAMEHRS_1 ///
F_WKT_SJ_ACTHRS_REP_1 ///
F_WKT_SJ_ACTHRS_1 ///
F_WKT_OJ_USHRS_1 ///
F_WKT_OJ_SAMEHRS_1 ///
F_WKT_OJ_ACTHRS_REP_1 ///
F_WKT_OJ_ACTHRS_1 ///
F_WKT_USHRSTOT_CALC_1 ///
F_WKT_USHRSTOT_CHK_1 ///
F_WKT_USHRSTOT_REP_1 ///
F_WKT_USHRSTOT_1 ///
F_WKT_ACHRSTOT_CALC_1 ///
F_WKT_ACHRSTOT_CHK_1 ///
F_WKT_ACHRSTOT_REP_1 ///
F_WKT_ACHRSTOT_1 ///
F_WKT_SRH_OJB_1 ///
F_WKT_WNT_MRH_1 ///
F_WKT_AVL_MRH_1 ///
F_WKT_NUM_MRH_1 ///

foreach var of varlist $List_F_WKT_1 {
    tab `var'  if `var'>0 , miss
}
