 
/*   IMPUTATION MODULE DEM    */
/*   EXAMPLES OF IMPUTATION AND CORRECTION    */




/* ** Drop Refusals and empty records  */

drop if DEM_SEX==.



/* ************************* DEM_AGE  ************************* */

/* Insert Age for respondents whose age was not given or estimated */

/*
replace DEM_AGE =27 if interview__key=="64-23-24-07" & PPNO==1
replace DEM_AGE =37 if interview__key=="64-23-24-07" & PPNO==2

replace DEM_EDC =.    if interview__key=="01-76-66-83" & PPNO==3  
replace DEM_APP =.    if interview__key=="01-76-66-83" & PPNO==3  
replace DEM_TRN_a =.  if interview__key=="01-76-66-83" & PPNO==3  
replace DEM_TRN =.    if interview__key=="01-76-66-83" & PPNO==3  
*/


/* ************************* DEM_REL  ************************* */
/*
replace DEM_REL =1 if interview__key=="11-63-28-54" & PPNO==1
*/

/* ************************* DEM_EDL  ************************* */

/* Fix DEM_EDL for Ages below the 5 years threshold (DEM_EDL Not Applicable) */

/*
replace DEM_EDL =3 if interview__key=="60-70-49-99" & PPNO==1
*/




/* kids under 15 to clean */ 

/*
global List_to_delete1 ///
DEM_MRT DEM_TRN_a DEM_TRN DEM_APP ///
GLO_WAP RSP_START_MODULE RSP_AVAIL RSP_PPNO RSP_REL RSP_END_MODULE ///
ATW_START_MODULE ATW_PAY_2 ATW_PAY ATW_PFT ATW_FAM ATW_END_MODULE ///
ABS_START_MODULE ABS_JOB ABS_END_MODULE ///
AGF_START_MODULE AGF_ANY__4 AGF_END_MODULE ///
SRH_START_MODULE SRH_JOB_a SRH_JOB SRH_BUS_a SRH_BUS SRH_YER SRH_DES_a SRH_DES SRH_MAC SHR_EVW SHR_OPW SRH_END_MODULE ///
WKT_ACHRS2J  ///
INC_START_MODULE INC_MSFS INC_FSA INC_OS__9 INC_END_MODULE ///
OPC_START_MODULE OPC_HCROP_2 OPC_HCROP OPC_END_MODULE ///
OPF_START_MODULE OPF_HFOOD_a__6 OPF_HFOOD_how_many OPF_END_MODULE /// 
BLD_START_MODULE BLD_OPG BLD_END_MODULE ///
MNF_START_MODULE MNF_OPG MNF_END_MODULE ///
DER_START_MODULE DER_NWE DER_END_MODULE
 

foreach var of varlist $List_to_delete1 {

replace `var' =. if (interview__key=="13-21-87-57" & PPNO==2) | ///  
                    (interview__key=="31-57-59-18" & PPNO==3) | ///
				    (interview__key=="88-73-18-31" & PPNO==5) | ///
                    (interview__key=="88-73-18-31" & PPNO==6)
}
*/

