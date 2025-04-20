/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/***                                                                                                                       ***/
/***                                       VARIABLE DERIVATION SYNTAX FOR MALDIVES                                         ***/ 
/***                          ILO Model LFS Questionnaire for CAPI Job-Type Start (JTS 2024 Edition)                       ***/ 
/***                                      Release 1  -  Geneva, 12 May 2024                                                ***/
/***                                                                                                                       ***/
/***             FOR DATA COLLECTED USING THE ILO CAPI TOOLS DEVELOPED WITH SURVEY SOLUTIONS                               ***/
/***                                                                                                                       ***/
/***                                             IMPORTANT NOTE:                                                           ***/
/***      THIS SYNTAX IS FOR DATA OBTAINED FROM THE ILO MODEL QUESTIONNAIRE DEVELOPED IN CSPRO OR SURVEY SOLUTIONS         ***/
/***           (FOR DATA OBTAINED FROM OTHER DATA COLLECTION TOOLS THE SYNTAX MAY REQUIRE SPECIFIC CHANGES)                ***/
/***                                                                                                                       ***/
/***      THE SYNTAX REVOLVES AROUND 4 MAIN STEPS, WHERE THE FIRST THREE ARE SPECIFIC FOR CSPRO OR SUSO AND ARE NEEDED     ***/
/***                                                                                                                       ***/
/***         STEP 3 SURVEY SOLUTIONS - RECODE MULTI-RESPONSE VARIABLES AS DUMMY VARIABLES                                  ***/
/***                                                                                                                       ***/
/***         STEP 4 - DERIVE VARIABLE AND AGGREGATES TO BE USED FOR KEY LABOUR MARKET INDICATORS                           ***/
/***                  BASED ON GUIDANCE AND FLOW CHART ILLUSTRATED IN THE DOCUMENT                                         ***/
/***                  "20240517_LFSQUESTIONNAIRE_JOBTYPESTART_2024_REL1_VARIABLE_DERIVATION_GUIDE.PDF                      ***/
/***                                                                                                                       ***/
/***                                        ILO Department of Statistics                                                   ***/
/***                                Statistical Standards and Methods Unit – SSMU                                          ***/
/***                                           statistics@ilo.org                                                          ***/
/***                                                                                                                       ***/
/***                                 Stata Syntax Version 2 - 15 July 2024                                                 ***/
/***                                                                                                                       ***/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/



/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/***                                                                                                                       ***/
/***  THE FOLLOWING VARIBLES ARE DERIVED IN THIS DO FILE                                                                   ***/
/***                                                                                                                       ***/
/***  VARIABLE NAME                   "VARIABLE DESCRIPTION                                                                ***/
/***                                                                                                                       ***/
/***  ilo_wap 						  "Working-age population"													           ***/
/***                                                                                                                       ***/
/***  ilo_lfs_emp 					  "Employment"					     									               ***/ 
/***                                                                                                                       ***/
/***  ilo_job1_ste_mc_icse18A 		  "Main job: Status in employment (ICSE-18-A Type of authority) – 5 Main categories"   ***/
/***                                                                                                                       ***/
/***  ilo_job1_ste_icse18A_authority  "Main job: Status in employment (ICSE-18-A Type of authority) - 2 Top categories"    ***/
/***                                                                                                                       ***/
/***  ilo_job1_ste_icse18 			  "Main job: Status in employment (ICSE-18) - 10 Detained categories"	               ***/
/***                                                                                                                       ***/
/***  ilo_job1_ste_mc_icse18R 		  "Main job: Status in employment (ICSE-18-R Type of economic risk) – 5 Main categ."   ***/
/***                                                                                                                       ***/
/***  ilo_job1_ste_icse18R_risk 	  "Main job: Status in employment (ICSE-18-R Type of economic risk) - 2 Top categ."    ***/
/***                                                                                                                       ***/
/***  ilo_job1_ins_sector 			  "Main job: Institutional sector (private/public) of economic activities"             ***/
/***                                                                                                                       ***/
/***  ilo_job1_ife_prod 			  "Main job: Nature of economic unit: Informal, Formal and Household Sector"	       ***/
/***                                                                                                                       ***/
/***  ilo_job1_ife_nature 			  "Main job: Nature of job: Informal and Formal Employment"	                           ***/
/***                                                                                                                       ***/
/***  ilo_job2_ste_mc_icse18A 		  "Second Job: Status in employment (ICSE-18-A Type of authority) – 5 Main categories" ***/
/***                                                                                                                       ***/
/***  ilo_job2_ife_nature 			  "Second Job: Nature of job: Informal and Formal Employment"		                   ***/
/***                                                                                                                       ***/
/***  ilo_joball_tru 				  "Time-related underemployment"		                                               ***/
/***                                                                                                                       ***/
/***  ilo_lfs_unemp 				  "Unemployment"		                                                               ***/
/***                                                                                                                       ***/
/***  ilo_long_unempl  				  "Long-term unemployment"			                                                   ***/
/***                                                                                                                       ***/
/***  ilo_lfs_olf 				      "Outside the labour force (in working age)"                                          ***/  
/***                                                                                                                       ***/
/***  ilo_potential_lf  			  "Potential labour force"		                                                       ***/
/***                                                                                                                       ***/
/***  ilo_discouraged  				  "Discouraged jobseekers"		                                                       ***/
/***                                                                                                                       ***/
/***  ilo_willing_non_seekers 		  "Willing non-jobseekers"		                                                       ***/
/***                                                                                                                       ***/
/***  ilo_lfs                         "Labour force status: Employed, Unemployed, Outside the labour force (in working age)***/     
/***                                                                                                                       ***/
/***  ilo_own_use_prod_foodstuff      "Own-use producers of foodstuff"		                                               ***/
/***                                                                                                                       ***/
/***  ilo_own_use_prod_goods 		  "Own-use producers of goods"		                                                   ***/
/***                                                                                                                       ***/
/***  oupg_achrstot 				  "Total hours worked by Own-use producers of goods"		                           ***/
/***                                                                                                                       ***/
/***  ilo_age_10yrbands  			  "AGE GROUPS (TEN YEARS BANDS)"		                                               ***/    
/***                                                                                                                       ***/
/***  ilo_neet      				  "Neet - Not in employment, education or training"                                    ***/    
/***                                                                                                                       ***/
/***  ilo_job1_how_usual_bands	      "Bands of weekly hours usually worked in main job"                                   ***/ 
/***                                                                                                                       ***/
/***  ilo_job1_how_actual_bands	      "Bands of weekly hours actually worked in main job"                                  ***/    
/***                                                                                                                       ***/
/***  ilo_joball_how_usual_bands	  "Bands of weekly hours usually worked in all jobs"                                   ***/ 
/***                                                                                                                       ***/
/***  ilo_joball_how_actual_bands	  "Bands of weekly hours actually worked in all jobs"                                  ***/    
/***                                                                                                                       ***/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/


/***    FOR DATA COLLECTED USING SURVEY SOLUTIONS    ***************************************************************/
/***                                                 ***************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    STEP 1 SURVEY SOLUTIONS - RECODE MULTI-RESPONSE VARIABLES AS DUMMY VARIABLES                             ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/



use       "${DIR_DATA_540IM_YQ}\LFS_2024_Q4_IMP.dta", clear


save      "${DIR_DATA_550DV_YQ}\LFS_2024_Q4_DER.dta", replace	


use       "${DIR_DATA_550DV_YQ}\LFS_2024_Q4_DER.dta", clear	

/*  Rename all variables to lowercase  */ 
rename year year_num
rename _all, lower

/* align with ILO questionnaire that has only for categories to avoid to change all the code */
/* put response category 4 together with c, and recode category 5 as d */ 
gen     agf_chk_a = 1 if agf_chk__1 == 1
gen     agf_chk_b = 1 if agf_chk__2 == 1
gen     agf_chk_c = 1 if agf_chk__3 == 1
replace agf_chk_c = 1 if agf_chk__4 == 1
gen     agf_chk_d = 1 if agf_chk__5 == 1

gen     agf_any_a = 1 if agf_any__1 == 1
gen     agf_any_b = 1 if agf_any__2 == 1
gen     agf_any_c = 1 if agf_any__3 == 1
replace agf_any_c = 1 if agf_any__4 == 1
gen     agf_any_d = 1 if agf_any__5 == 1

gen mjj_rem_typ_a = 1 if mjj_rem_typ__1 == 1
gen mjj_rem_typ_b = 1 if mjj_rem_typ__2 == 1
gen mjj_rem_typ_c = 1 if mjj_rem_typ__3 == 1
gen mjj_rem_typ_d = 1 if mjj_rem_typ__4 == 1
gen mjj_rem_typ_e = 1 if mjj_rem_typ__5 == 1
gen mjj_rem_typ_f = 1 if mjj_rem_typ__6 == 1
gen mjj_rem_typ_g = 1 if mjj_rem_typ__7 == 1
gen mjj_rem_typ_h = 1 if mjj_rem_typ__8 == 1
gen mjj_rem_typ_i = 1 if mjj_rem_typ__9 == 1

gen mjd_sell_client_a = 1 if mjd_sell_client__1 == 1
gen mjd_sell_client_b = 1 if mjd_sell_client__2 == 1
gen mjd_sell_client_c = 1 if mjd_sell_client__3 == 1
gen mjd_sell_client_d = 1 if mjd_sell_client__4 == 1

gen mjd_control_a = 1 if mjd_control__1 == 1
gen mjd_control_b = 1 if mjd_control__2 == 1
gen mjd_control_g = 1 if mjd_control__7 == 1

gen sjd_control_a = 1 if sjd_control__1 == 1
gen sjd_control_b = 1 if sjd_control__2 == 1
gen sjd_control_g = 1 if sjd_control__7 == 1

gen sjd_rem_typ_a = 1 if sjd_rem_typ__1 == 1
gen sjd_rem_typ_b = 1 if sjd_rem_typ__2 == 1
gen sjd_rem_typ_c = 1 if sjd_rem_typ__3 == 1
gen sjd_rem_typ_d = 1 if sjd_rem_typ__4 == 1
gen sjd_rem_typ_e = 1 if sjd_rem_typ__5 == 1
gen sjd_rem_typ_f = 1 if sjd_rem_typ__6 == 1
gen sjd_rem_typ_g = 1 if sjd_rem_typ__7 == 1
gen sjd_rem_typ_h = 1 if sjd_rem_typ__8 == 1
gen sjd_rem_typ_i = 1 if sjd_rem_typ__9 == 1

save      "${DIR_DATA_550DV_YQ}\LFS_2024_Q4_DER.dta", replace	













/***    FOR DATA COLLECTED USING EITHER CSPRO OR SURVEY SOLUTIONS    ***********************************************/
/***                                                                 ***********************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    STEP 4 CSPRO & SURVEY SOLUTIONS - DERIVE VARIABLE AND AGGREGATES TO BE USED FOR KEY LABOUR MARKET        ***/
/***                          INDICATORS BASED ON GUIDANCE AND FLOW CHART ILLUSTRATED IN THE DOCUMENT            ***/
/***                          "20240517_LFSquestionnaire_jobtypestart_2024_Rel1_Variable_Derivation_Guide.pdf"   ***/
/***                                                                                                             ***/
/***                          AT THIS POINT, VARIABLES FROM THE TWO DATA COLLECTION INSTRUMENTS ARE HARMONIZED,  ***/
/***                          THEREFORE THE CODE BELOW CAN BE USED FOR BOTH                                      ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    GLOBAL PARAMETERS: TO BE DEFINED BASED ON NATIONAL PRACTICE                                              ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

use       "${DIR_DATA_550DV_YQ}\LFS_2024_Q4_DER.dta", clear	

/*  Minimum age limit for working age population */

global glo_min_working_age = 15

/*  Threshold of hours worked used to identify Time Related Underemployment */

global glo_threshold_tru = 30  /* less than 30 */


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    CHAPTER 1:  EMPLOYMENT AND SELECTED JOB CHARACTERISTICS                                                 ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 1.1:  WORKING AGE POPULATION as per national context                                             ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

gen     ilo_wap=.
replace ilo_wap=1 if dem_age >= $glo_min_working_age & dem_age!=.
		
label def label_ilo_wap ///
	          1 "1 - Working-age Population"
label value ilo_wap label_ilo_wap
label var ilo_wap "Working-age population"

/* Table Age by Working-age population */
		
table dem_age ilo_wap , miss


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 1.2:  EMPLOYED PERSONS                                                                           ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


/*********************************************************************************************/
/***  Persons employed - two profiles (at work, absent from work)                          ***/ 
/***  To be used when AGF module IS IMPLEMENTED                                            ***/
/***  The generated derived variable uses two categories (1,2) to identify the employed    ***/
/*********************************************************************************************/

gen     ilo_lfs_emp=.

replace ilo_lfs_emp=.
	
replace ilo_lfs_emp=1 if ilo_wap==1 &    atw_pay==1 
	
replace ilo_lfs_emp=1 if ilo_wap==1 &  ( atw_pft==1 | atw_fam==1 ) & ///
                                       ( agf_chk_d==1 | inlist(agf_mkt,1,2) | inlist(agf_his,1,2) | agf_hir==1 )
	
replace ilo_lfs_emp=2 if ilo_wap==1 &    abs_job==1 & ( (abs_why==2 & abs_sea==1) | inlist(abs_why,3,4,5,6) | ( inlist(abs_why,7,8,9,10,11,12,13) & (abs_dur==1 | abs_pay==1) )  )  &  ///
	                                   ( agf_chk_d==1 | inlist(agf_mkt,1,2) | inlist(agf_his,1,2) | agf_hir==1 ) 

replace ilo_lfs_emp=1 if ilo_wap==1 &  ( agf_any_a==1 | agf_any_b==1 | agf_any_c==1 ) & ( inlist(agf_mkt,1,2) | inlist(agf_his,1,2) | agf_hir==1 ) 

replace ilo_lfs_emp=3 if ilo_wap==1 &   ilo_lfs_emp==.

	
lab def lfs_emp_lab  ///
		1 "Employed, at work" ///
		2 "Employed, on temporary absence" ///
		3 "Not employed", replace
		
lab values ilo_lfs_emp lfs_emp_lab
lab var ilo_lfs_emp "Employment"	

/* Table Employment by Working-age population */
		
table  ilo_lfs_emp if ilo_wap==1, miss	
table  ilo_lfs_emp if ilo_wap==1 & inlist(ilo_lfs_emp,1,2), miss	

/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 1.3:  MAIN JOB: STATUS IN EMPLOYMENT ICSE-18-A   TYPE OF AUTHORITY                               ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


/**************************************************************************************/
/***   Creates some recoded variables (prefix REC_) that are used to derive         ***/
/***   ICSE-18, INFORMAL SECTOR AND INFORMAL EMPLOYMENT                             ***/
/**************************************************************************************/

/***   Formal job of an employee based on social protection, paid annual leave and paid sick leave  ***/
/***   Used to derive formal employment and formal sector for specific groups of employed           ***/

gen     rec_formal_job_employees =.
replace rec_formal_job_employees =.
replace rec_formal_job_employees = 1 if mie_socpro==1
replace rec_formal_job_employees = 1 if mie_socpro==97  &  mie_pvaclv==1 &  mie_pscklv==1
replace rec_formal_job_employees = 2 if mie_socpro==2
replace rec_formal_job_employees =97 if mie_socpro==97  &  (inlist(mie_pvaclv,2,97) | inlist(mie_pscklv,2,97) )

tab  mie_socpro rec_formal_job_employees, miss


/***   Dependency from an external entity                                                           ***/
/***   Used to derive distringuish between independent workers and dependnet contractors            ***/


gen     rec_dependency =.
replace rec_dependency = 1 if mjd_single_client==1 
replace rec_dependency = 1 if inlist(mjd_source_client,1,2)
replace rec_dependency = 1 if mjd_sell_client_a==1
replace rec_dependency = 1 if mjd_sell_client_b==1
replace rec_dependency = 1 if mjd_sell_client_c==1

tab mjd_single_client rec_dependency , miss
tab mjd_source_client rec_dependency , miss

/***   Control over the activity by an external entity                                           ***/
/***   Used to derive distringuish between independent workers and dependnet contractors         ***/

gen     rec_control =.
replace rec_control =. 
replace rec_control = 1 if  mjd_control_a==1
replace rec_control = 1 if  mjd_control_b==1




/************************************************************************************************/
/***                                                                                          ***/
/***   STATUS IN EMPLOYMENT IN MAIN JOB (ICSE-18-A Type of authority ) – 5 MAIN CATEGORIES    ***/
/***   Generates a single derived variable for the 5 main categories of ICSE-18-A             ***/
/***                                                                                          ***/
/************************************************************************************************/


gen       ilo_job1_ste_mc_icse18A =.

replace   ilo_job1_ste_mc_icse18A =.



/* 1 - Employers  (ICSE-18=A) */

replace ilo_job1_ste_mc_icse18A = 1  if  inlist(ilo_lfs_emp,1,2)  &    mjj_emp_rel==2 &  mjj_hires==1

replace ilo_job1_ste_mc_icse18A = 1  if  inlist(ilo_lfs_emp,1,2)  &  ( mjj_emp_rel==3 & inlist(mjj_cfw_chk,1,2) )  &  mjj_hires==1



/* 2 - Independent workers without employees  (ICSE-18=B)  */

replace ilo_job1_ste_mc_icse18A = 2  if  inlist(ilo_lfs_emp,1,2)  &   mjj_emp_rel==2  &  mjj_hires==2  &  mjl_corp==1          

replace ilo_job1_ste_mc_icse18A = 2  if  inlist(ilo_lfs_emp,1,2)  & ( mjj_emp_rel==3 & inlist(mjj_cfw_chk,1,2) )  &  mjj_hires==2  &  mjl_corp==1          
 
replace ilo_job1_ste_mc_icse18A = 2  if  inlist(ilo_lfs_emp,1,2)  &   mjj_emp_rel==2  &  mjj_hires==2  &  ( inlist(mjl_regi,2,97) | inlist(mjl_corp,2,97) )  &  (rec_dependency != 1  | rec_control != 1 )

replace ilo_job1_ste_mc_icse18A = 2  if  inlist(ilo_lfs_emp,1,2)  & ( mjj_emp_rel==3 & inlist(mjj_cfw_chk,1,2))   &  mjj_hires==2  &  ( inlist(mjl_regi,2,97) | inlist(mjl_corp,2,97) )  &  (rec_dependency != 1  | rec_control != 1 )



/* 3 - Dependent contractors  (ICSE-18=C) */		

replace ilo_job1_ste_mc_icse18A = 3   if  inlist(ilo_lfs_emp,1,2) &   mjj_emp_rel==2  & mjj_hires==2  &  ( inlist(mjl_regi,2,97) | inlist(mjl_corp,2,97) )  &  rec_dependency ==1  &  rec_control == 1  

replace ilo_job1_ste_mc_icse18A = 3   if  inlist(ilo_lfs_emp,1,2) &  (mjj_emp_rel==3 & inlist(mjj_cfw_chk,1,2))  &  mjj_hires==2  &  ( inlist(mjl_regi,2,97) | inlist(mjl_corp,2,97) )  &  rec_dependency ==1  &  rec_control == 1 

replace ilo_job1_ste_mc_icse18A = 3   if  inlist(ilo_lfs_emp,1,2) &   mjj_emp_rel==1 & mjj_rem_typ_a!=1 & inlist(rec_formal_job_employees,2,97) 
	

	
/* 4 - Employees (ICSE-18=D) */			

replace ilo_job1_ste_mc_icse18A = 4   if  inlist(ilo_lfs_emp,1,2) &  ( inlist(mjj_emp_rel,1,5) | (mjj_emp_rel==3 & inlist(mjj_cfw_chk,3,4)) )  & mjj_rem_typ_a==1

replace ilo_job1_ste_mc_icse18A = 4   if  inlist(ilo_lfs_emp,1,2) &   mjj_emp_rel==1  & mjj_rem_typ_a!=1  &  rec_formal_job_employees == 1 

replace ilo_job1_ste_mc_icse18A = 4   if  inlist(ilo_lfs_emp,1,2) &   mjj_emp_rel==4 


/* 5 - Contributing family workers  (ICSE-18=E)  */

replace ilo_job1_ste_mc_icse18A = 5 if  inlist(ilo_lfs_emp,1,2) &  ( mjj_emp_rel==3  &  inlist(mjj_cfw_chk,3,4))  &  mjj_rem_typ_a!=1

replace ilo_job1_ste_mc_icse18A = 5 if  inlist(ilo_lfs_emp,1,2) &    mjj_emp_rel==5  &  mjj_rem_typ_a!=1



/* 9 - Employed not classifiable by status  (should not exist) */

replace ilo_job1_ste_mc_icse18A = 9 if inlist(ilo_lfs_emp,1,2)  &   ilo_job1_ste_mc_icse18A==. 



/* Labels for the variable ilo_job1_ste_mc_icse18A and its response categories */

label def label_ilo_ste_mc_icse18A   ///
			1 "1 - Employers (ICSE-18 = A)" ///
			2 "2 - Independent workers without employees  (ICSE-18 = B)"  ///
			3 "3 - Dependent contractors  (ICSE-18 = C)"  ///
			4 "4 - Employees  (ICSE-18 = D)"  ///
			5 "5 - Contributing family workers  (ICSE-18 = E)"  ///
			9 "9 - Employed not classifiable by status", replace

label val ilo_job1_ste_mc_icse18A label_ilo_ste_mc_icse18A
label var ilo_job1_ste_mc_icse18A "Status in employment (ICSE-18-A Type of authority) – 5 Main categories"
	
/* Table Status in employment ICSE18-A by working age population */
	
table ilo_job1_ste_mc_icse18A if inlist(ilo_lfs_emp,1,2), missing
	


/***************************************************************************************************/
/***                                                                                             ***/
/***   STATUS IN EMPLOYMENT IN MAIN JOB (ICSE-18-A Type of authority) - 2 TOP LEVEL CATEGORIES   ***/
/***   Generates an aggregated derived variable of status in employment by type of authority     ***/ 	
/***                                                                                             ***/
/***************************************************************************************************/


gen     ilo_job1_ste_icse18A_authority=.

replace ilo_job1_ste_icse18A_authority=.


/* 1 - Independent workers */

replace ilo_job1_ste_icse18A_authority=1 if inlist(ilo_job1_ste_mc_icse18A,1,2)		

/* 2 - Dependent workers */

replace ilo_job1_ste_icse18A_authority=2 if inlist(ilo_job1_ste_mc_icse18A,3,4,5)	

/* 9 - Employed not classifiable by status  (should not exist) */

replace ilo_job1_ste_icse18A_authority=9 if inlist(ilo_job1_ste_mc_icse18A,9)	
	
	
lab def ste_icse18A_authority_lab	///
             1 "1 - Independent workers" /// 
			 2 "2 - Dependent workers" ///
			 9 "9 - Workers not classifiable by status", replace
			 
lab val   ilo_job1_ste_icse18A_authority ste_icse18A_authority_lab
label var ilo_job1_ste_icse18A_authority "Status in employment top-level (ICSE-18-A Type of authority) - Main job"	
    	
/* Table Status in employment top-level ICSE18-A by main categories ICSE18-A  */

table ilo_job1_ste_icse18A_authority if inlist(ilo_lfs_emp,1,2), missing
 
table ilo_job1_ste_mc_icse18A ilo_job1_ste_icse18A_authority if inlist(ilo_lfs_emp,1,2), missing	
	
	

/*******************************************************************************************/
/***                                                                                     ***/
/***   STATUS IN EMPLOYMENT IN MAIN JOB ( ICSE-18 ) – 10 DETAILED CATEGORIES             ***/
/***   Generates a single derived variable for the 10 detailed categories of ICSE-18     ***/
/***                                                                                     ***/
/*******************************************************************************************/
	
gen     ilo_job1_ste_icse18 = .

replace ilo_job1_ste_icse18 = .	

/* 11 - Employers in corporations ( ICSE-18 = 11 ) */

replace ilo_job1_ste_icse18 = 11  if  ilo_job1_ste_mc_icse18A == 1  &  mjl_corp==1

/* 12 - Employers in household market enterprises ( ICSE-18 = 12 ) */   		
		
replace ilo_job1_ste_icse18 = 12  if  ilo_job1_ste_mc_icse18A == 1  &  ( inlist(mjl_regi,2,97) | inlist(mjl_corp,2,97) ) 
 
/* 21 - Owner-operators of corporations without employees ( ICSE-18 = 21 ) */  		

replace ilo_job1_ste_icse18 = 21  if  ilo_job1_ste_mc_icse18A == 2  &  mjl_corp==1

/* 22 - Own-account workers in household market enterprises without employees ( ICSE-18 = 22 ) */			
          	    
replace ilo_job1_ste_icse18 = 22  if  ilo_job1_ste_mc_icse18A == 2  &  ( inlist(mjl_regi,2,97) | inlist(mjl_corp,2,97) ) 


/* 30 - Dependent contractors ( ICSE-18 = 30 ) */ 

replace ilo_job1_ste_icse18 = 30  if ilo_job1_ste_mc_icse18A == 3						
	
	
/* 41 - Permanent employees ( ICSE-18 = 41 ) */
 	
replace ilo_job1_ste_icse18 = 41  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 & mjc_contra==1 & inlist(mjc_conop,3,4)                     & mcd_conthrs==1

replace ilo_job1_ste_icse18 = 41  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 & mjc_contra==1 & inlist(mjc_conop,3,4)                     & mcd_conthrs==2 & inlist(mcd_conmin,1,2)
 
replace ilo_job1_ste_icse18 = 41  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 & mjc_contra==2 &        mjc_conop==3                       & mcd_conthrs==1

replace ilo_job1_ste_icse18 = 41  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 & mjc_contra==2 &        mjc_conop==3                       & mcd_conthrs==2 & inlist(mcd_conmin,1,2)
      
replace ilo_job1_ste_icse18 = 41  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 & mjc_contra==2 & inlist(mjc_conop,4,97) & mjc_temptotal==6 & mcd_conthrs==1 

replace ilo_job1_ste_icse18 = 41  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 & mjc_contra==2 & inlist(mjc_conop,4,97) & mjc_temptotal==6 & mcd_conthrs==2 & inlist(mcd_conmin,1,2)  

replace ilo_job1_ste_icse18 = 41  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 & mjc_contra==97                         & mjc_temptotal==6  



/* 42 - Fixed-term employees ( ICSE-18 = 42 ) */ 
	
replace ilo_job1_ste_icse18 = 42  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 & inlist(mjc_contra,1,2) & inlist(mjc_conop,1,2) & inlist(mjc_tempdur,4,5,6,7)                    & mcd_conthrs==1

replace ilo_job1_ste_icse18 = 42  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 & inlist(mjc_contra,1,2) & inlist(mjc_conop,1,2) & inlist(mjc_tempdur,4,5,6,7)                    & mcd_conthrs==2 & inlist(mcd_conmin,1,2)
     
replace ilo_job1_ste_icse18 = 42  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 & mjc_contra==2          & inlist(mjc_conop,4,97)                     & inlist(mjc_temptotal,4,5) & mcd_conthrs==1  

replace ilo_job1_ste_icse18 = 42  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 & mjc_contra==2          & inlist(mjc_conop,4,97)                     & inlist(mjc_temptotal,4,5) & mcd_conthrs==2 & inlist(mcd_conmin,1,2)  

replace ilo_job1_ste_icse18 = 42  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 & mjc_contra==97                                                      & inlist(mjc_temptotal,4,5)




/* 43 - Short-term and casual employees ( ICSE-18 = 43 ) */ 	

replace ilo_job1_ste_icse18 = 43  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 &        mjc_contra==1   & inlist(mjc_conop,3,4,97)                                                               & mcd_conthrs==2 &  mcd_conmin==3  

replace ilo_job1_ste_icse18 = 43  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 & inlist(mjc_contra,1,2) & inlist(mjc_conop,1,2)  & inlist(mjc_tempdur,1,2,3)

replace ilo_job1_ste_icse18 = 43  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 & inlist(mjc_contra,1,2) & inlist(mjc_conop,1,2)  & inlist(mjc_tempdur,4,5,6,7,8)                                 & mcd_conthrs==2 &  mcd_conmin==3 
                     
replace ilo_job1_ste_icse18 = 43  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 &        mjc_contra==2   &        mjc_conop==3                                                                    & mcd_conthrs==2 &  mcd_conmin==3 

replace ilo_job1_ste_icse18 = 43  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 &        mjc_contra==2   & inlist(mjc_conop,4,97)                                   & inlist(mjc_temptotal,4,5)   & mcd_conthrs==2 &  mcd_conmin==3 

replace ilo_job1_ste_icse18 = 43  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 &        mjc_contra==2   & inlist(mjc_conop,4,97)                                   & inlist(mjc_temptotal,1,2,3) 

replace ilo_job1_ste_icse18 = 43  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel!=4 &        mjc_contra==97                                                             & inlist(mjc_temptotal,1,2,3) 


/* 44 - Paid apprentices, trainees and interns ( ICSE-18 = 44) */ 	

replace ilo_job1_ste_icse18 = 44  if  ilo_job1_ste_mc_icse18A == 4 & mjj_emp_rel==4
	

/* 49 - Employeees not classifiable by duration   */ 	

replace ilo_job1_ste_icse18 = 49  if  ilo_job1_ste_mc_icse18A == 4 & ilo_job1_ste_icse18==.

/* 51 - Contributing family workers  ICSE-18 = 5 ) */ 
  	 	
replace ilo_job1_ste_icse18 = 51 if ilo_job1_ste_mc_icse18A == 5
 
/* 97 - Workers not classifiable by sub-categories of status in employment   */ 

replace ilo_job1_ste_icse18 = 97 if inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_icse18 ==. 	


label def label_ilo_ste_icse18 ///
		11 "11 - Employers in corporations"  ///
		12 "12 - Employers in household market enterprises"  ///
		21 "21 - Owner-operators of corporations without employees"  ///
		22 "22 - Own-account workers in household market enterprises without employees"  ///
		30 "30 - Dependent contractors"  ///
		41 "41 - Permanent employees"  ///
		42 "42 – Fixed-term employees"  ///
		43 "43 - Short-term and casual employees"  ///
		44 "44 - Paid apprentices, trainees and interns"  ///
		49 "49 - Employeees not classifiable by duration"  ///
		51 "51 - Contributing family workers"  ///
		97 "97 - Workers not classifiable by status", replace

label val ilo_job1_ste_icse18 label_ilo_ste_icse18
label var ilo_job1_ste_icse18 "Status in employment (ICSE-18) - 10 Detained categories"
	
/* Table detailed categories of ICSE-18 by Main categories of ICSE-18*/
	
table (ilo_job1_ste_mc_icse18A ilo_job1_ste_icse18)() if inlist(ilo_lfs_emp,1,2), miss
	
list  mjc_contra mjc_conop mjc_tempdur mjc_temptotal mcd_conthrs mcd_conmin  if ilo_job1_ste_mc_icse18A==4 & ilo_job1_ste_icse18 == 49

 
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 1.4:  MAIN JOB: STATUS IN EMPLOYMENT ICSE-18-R   TYPE OF ECONOMIC RISK                           ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

/*****************************************************************************************************/
/***                                                                                               ***/
/***   STATUS IN EMPLOYMENT IN MAIN JOB (ICSE-18-R Type of economic risk ) – 5 Main categories     ***/
/***   Generates a single derived variable for the 5 main categories of ICSE-18-R                  ***/
/***                                                                                               ***/
/*****************************************************************************************************/

gen       ilo_job1_ste_mc_icse18R = .

replace   ilo_job1_ste_mc_icse18R = .


/*  1 - Independent workers in household market enterprises (ICSE-18=F) */

replace   ilo_job1_ste_mc_icse18R  = 1  if  ilo_job1_ste_mc_icse18A == 1  &  ilo_job1_ste_icse18 == 12 

replace   ilo_job1_ste_mc_icse18R  = 1  if  ilo_job1_ste_mc_icse18A == 2  &  ilo_job1_ste_icse18 == 22 

/* 2 - Dependent contractors  (ICSE-18=C) */		

replace   ilo_job1_ste_mc_icse18R  = 2  if  ilo_job1_ste_mc_icse18A == 3

/* 3 - Contributing family workers  (ICSE-18=E)  */

replace   ilo_job1_ste_mc_icse18R  = 3  if  ilo_job1_ste_mc_icse18A == 5 

/* 4 - Owner-operators of corporations (ICSE-18=G) */ 

replace   ilo_job1_ste_mc_icse18R  = 4  if  ilo_job1_ste_mc_icse18A == 1  &  ilo_job1_ste_icse18 == 11 

replace   ilo_job1_ste_mc_icse18R  = 4  if  ilo_job1_ste_mc_icse18A == 2  &  ilo_job1_ste_icse18 == 21 

/* 5 - Employees (ICSE-18=D) */			

replace   ilo_job1_ste_mc_icse18R  = 5  if  ilo_job1_ste_mc_icse18A == 4 

/* 9 - Employed not classifiable by status  (should not exist) */

replace ilo_job1_ste_mc_icse18R = 9 if  inlist(ilo_lfs_emp,1,2)  &   ilo_job1_ste_mc_icse18R==. 



/* Labels for the variable ilo_job1_ste_mc_icse18A and its response categories */

label def label_ilo_ste_mc_icse18R   ///
			1 "1 - Independent workers in household market enterprises (ICSE-18=F)" ///
			2 "2 - Dependent contractors  (ICSE-18=C)"  ///
			3 "3 - Contributing family workers  (ICSE-18=E)"  ///
			4 "4 – Owner-operators of corporations (ICSE-18=G)"  ///
			5 "5 - Employees  (ICSE-18=D)"  ///
			9 "9 - Employed not classifiable by status", replace

label val ilo_job1_ste_mc_icse18R label_ilo_ste_mc_icse18R
label var ilo_job1_ste_mc_icse18R "Status in employment (ICSE-18-R Type of economic risk) – 5 Main categories"
	
/* Table Status in employment ICSE18-A by working age population */

table ilo_job1_ste_mc_icse18R  if inlist(ilo_lfs_emp,1,2) , missing
	
	

/*********************************************************************************************************/
/***                                                                                                   ***/
/***   STATUS IN EMPLOYMENT IN MAIN JOB (ICSE-18-R Type of economic risk) - 2 TOP LEVEL CATEGORIES     ***/
/***   Generates an aggregated derived variable of status in employment by type of economic risk       ***/ 	
/***                                                                                                   ***/
/*********************************************************************************************************/


gen       ilo_job1_ste_icse18R_risk = .

replace   ilo_job1_ste_icse18R_risk = .


/* 1 - Workers in employment for profit */ 
replace ilo_job1_ste_icse18R_risk = 1  if  inlist(ilo_job1_ste_mc_icse18R,1,2,3)		


/* 2 - Workers in employment for pay */ 
replace ilo_job1_ste_icse18R_risk = 2  if  inlist(ilo_job1_ste_mc_icse18R,4,5)	

/* 9 - Employed not classifiable by status  (should not exist) */
replace ilo_job1_ste_icse18R_risk = 9  if  inlist(ilo_job1_ste_mc_icse18R,9)	
	
	
lab def ste_icse18R_risk_lab	///
             1 "1 - Workers in employment for profit" /// 
			 2 "2 - Workers in employment for pay" ///
			 9 "9 - Workers not classifiable by status", replace
			 
lab val ilo_job1_ste_icse18R_risk ste_icse18R_risk_lab
label var ilo_job1_ste_icse18R_risk "Status in employment top-level (ICSE-18-R Type of economic risk) - Main job"	

/* Table Main categories Status in employment ICSE18-R by top-level ICSE18-R  */

	
table ilo_job1_ste_icse18R_risk  if inlist(ilo_lfs_emp,1,2) , missing
	
table ilo_job1_ste_mc_icse18R ilo_job1_ste_icse18R_risk  if inlist(ilo_lfs_emp,1,2) , missing

	

/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 1.5:  MAIN JOB: INSTITUTIONAL SECTOR EMPLOYMENT              	                                 ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/



gen     ilo_job1_ins_sector=.
replace ilo_job1_ins_sector=.

replace ilo_job1_ins_sector = 1  if  inlist(ilo_lfs_emp,1,2) & inlist(mjj_emp_rel,1,4,5) & mju_ins==1	   
replace ilo_job1_ins_sector = 2  if  inlist(ilo_lfs_emp,1,2) & inlist(mjj_emp_rel,2,3)
replace ilo_job1_ins_sector = 2  if  inlist(ilo_lfs_emp,1,2) & inlist(mjj_emp_rel,1,4,5) & inlist(mju_ins,2,3) 
replace ilo_job1_ins_sector = 3  if  inlist(ilo_lfs_emp,1,2) & inlist(mjj_emp_rel,1,4,5) & mju_ins==4
replace ilo_job1_ins_sector = 4  if  inlist(ilo_lfs_emp,1,2) & inlist(mjj_emp_rel,1,4,5) & mju_ins==5 
replace ilo_job1_ins_sector = 5  if  inlist(ilo_lfs_emp,1,2) & inlist(mjj_emp_rel,1,4,5) & mju_ins==6	 

/*   Labels for the variable ilo_job1_ins_sector and its response categories */

lab def ins_sector_lab ///
		1 "1 - Public"  ///
		2 "2 - Private"  ///
		3 "3 - Households"  ///
		4 "4 – Non-profit institutions"  ///
		5 "5 – International institutions"  ///

lab values ilo_job1_ins_sector ins_sector_lab
lab var ilo_job1_ins_sector "Institutional sector (private/public) of economic activities - main job"
	

/* Table Self declared status in employment by institutional sector */

table mjj_emp_rel ilo_job1_ins_sector if  inlist(ilo_lfs_emp,1,2), missing	
	

/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 1.6:  MAIN JOB: NATURE OF THE ECONOMIC UNIT ( INFORMAL, FORMAL, HOUSEHOLDS SECTOR )              ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

tab ilo_job1_ste_mc_icse18A

gen     ilo_job1_ife_prod = .

replace ilo_job1_ife_prod = .


/* Nature of economic unit for Employers, independent workers without employees  and   */
/* contributing family workers  (ICSE-18=A,B,E) */

/* Formal Sector */

replace ilo_job1_ife_prod = 2   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==1 & ( mjl_regi==1 | mis_book==1)

replace ilo_job1_ife_prod = 2   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==2 & ( mjl_regi==1 | mis_book==1)

replace ilo_job1_ife_prod = 2   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==5 &  mjj_emp_rel==3 & ( mjl_regi==1 | mis_book==1)


/* Informal Sector */

replace ilo_job1_ife_prod = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==1 &  inlist(mjl_regi,2,97) & inlist(mis_book,2,97)

replace ilo_job1_ife_prod = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==2 &  inlist(mjl_regi,2,97) & inlist(mis_book,2,97)

replace ilo_job1_ife_prod = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==5 &  mjj_emp_rel==3  &  inlist(mjl_regi,2,97) & inlist(mis_book,2,97)

replace ilo_job1_ife_prod = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==5 &  mjj_emp_rel==5 




/* Nature of economic unit for Dependent contractors  (ICSE-18=C) */


/* Formal Sector */

replace ilo_job1_ife_prod = 2   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==3 & mjj_emp_rel==1 & mjl_regp==1 

replace ilo_job1_ife_prod = 2   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==3 & inlist(mjj_emp_rel,2,3) & ( mjl_regi==1 | mjl_regp==1 | mis_book==1)

 
/* Informal Sector */

replace ilo_job1_ife_prod = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==3 & mjj_emp_rel==1 & inlist(mjl_regp,2,97)

replace ilo_job1_ife_prod = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==3 & inlist(mjj_emp_rel,2,3) & inlist(mjl_regi,2,97) & inlist(mjl_regp,2,97) & inlist(mis_book,2,97) 


/* Nature of economic unit for Employees  (ICSE-18=D) */


/* Formal Sector */

replace ilo_job1_ife_prod = 2   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==4 & inlist(mju_ins,1,5,6)

replace ilo_job1_ife_prod = 2   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==4 & inlist(mju_ins,2,3) & rec_formal_job_employees==1

replace ilo_job1_ife_prod = 2   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==4 & inlist(mju_ins,2,3) & inlist(rec_formal_job_employees,2,97)  & ( mjl_regi==1 | mis_book==1) 



/* Household Sector */

replace ilo_job1_ife_prod = 3   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==4 & mju_ins==4


/* Informal Sector */

replace ilo_job1_ife_prod = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==4 & inlist(mju_ins,2,3) & inlist(rec_formal_job_employees,2,97) & inlist(mjl_regi,2,97) & inlist(mis_book,2,97)


/* Labels for the variable  ilo_job1_ife_prod and its categories */

lab def ilo_ife_prod_lab ///
		1 "1 - Informal" ///
		2 "2 - Formal" ///
		3 "3 - Household", replace 

lab val ilo_job1_ife_prod ilo_ife_prod_lab
lab var ilo_job1_ife_prod "Nature of economic unit: Informal, Formal and Household Sector"	 


/* Table Status in employment ICSE18-A  by nature of economic unit */
tab ilo_job1_ste_mc_icse18A ilo_job1_ife_prod if   inlist(ilo_lfs_emp,1,2), missing




/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 1.7:  MAINN JOB: NATURE ON THE JOB  ( INFORMAL AND FORMAL EMPLOYMENT ) 	                         ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

gen     ilo_job1_ife_nature=.

replace ilo_job1_ife_nature=.

/* Nature of main job for Employers and Independent workers without employees  ( ICSE-18 = A,B ) */

/* Formal employment */

replace ilo_job1_ife_nature = 2   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==1 & ( mjl_regi==1 | mis_book==1)

replace ilo_job1_ife_nature = 2   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==2 & ( mjl_regi==1 | mis_book==1)


/* Informal employment */

replace ilo_job1_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==1 & inlist(mjl_regi,2,97) & inlist(mis_book,2,97)

replace ilo_job1_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==2 & inlist(mjl_regi,2,97) & inlist(mis_book,2,97)



/* Nature of main job for Dependent contractors  ( ICSE-18 = C ) */

/* Formal employment */

replace ilo_job1_ife_nature = 2   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==3 & mjj_emp_rel==1 & mjl_regp==1 & mie_socpro_self==1

replace ilo_job1_ife_nature = 2   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==3 & inlist(mjj_emp_rel,2,3) & ( mjl_regi==1 | mjl_regp==1 | mis_book==1) & mis_socpro_dc==1

 
/* Informal employment */

replace ilo_job1_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==3 & mjj_emp_rel==1 & mjl_regp==1 & inlist(mie_socpro_self,2,97)

replace ilo_job1_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==3 & mjj_emp_rel==1 & inlist(mjl_regp,2,97)

replace ilo_job1_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==3 & inlist(mjj_emp_rel,2,3) & ( mjl_regi==1 | mjl_regp==1 | mis_book==1) & inlist(mis_socpro_dc,2,97)

replace ilo_job1_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==3 & inlist(mjj_emp_rel,2,3) & inlist(mjl_regi,2,97) & inlist(mjl_regp,2,97) & inlist(mis_book,2,97) 


/* Nature of main job for Employees  ( ICSE-18 = D) */

/* Formal employment */

replace ilo_job1_ife_nature = 2   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==4 & rec_formal_job_employees==1

/* Informal employment */

replace ilo_job1_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==4 & inlist(rec_formal_job_employees,2,97) 



/* Nature of main job for Contributing family workers  ( ICSE-18 = E ) */
/* Version A: If the variable "mie_socpro_cfw"is not implemented all CFWs have an informal  */
/* employment   */

/* Informal employment */
/*
replace ilo_job1_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==5
*/


/* Nature of main job for Contributing family workers  ( ICSE-18 = E ) */
/* Version B: If the variable "mie_socpro_cfw" is implemented then CFWs might have an informal or */
/* a formal employment   */

/* Formal employment */

replace ilo_job1_ife_nature = 2   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==5 & mjj_emp_rel==3 & ( mjl_regi==1 | mis_book==1) & mis_socpro_cfw==1


/* Informal employment */

replace ilo_job1_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==5 & mjj_emp_rel==3 & ( mjl_regi==1 | mis_book==1) & inlist(mis_socpro_cfw,2,97)

replace ilo_job1_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==5 & mjj_emp_rel==3 & inlist(mjl_regi,2,97) & inlist(mis_book,2,97)

replace ilo_job1_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2) & ilo_job1_ste_mc_icse18A==5 & mjj_emp_rel==5

/* Labels for the variable  ilo_job1_ife_nature and its categories */

lab def ife_nature_lab ///
		1 "1 - Employed with informal main job"  ///
		2 "2 – Employed with formal main job" 

lab val ilo_job1_ife_nature ife_nature_lab
lab var ilo_job1_ife_nature " Nature of main job: Informal and Formal Employment"		


/* Table Status in employment ICSE18-A by nature of main job */

tab ilo_job1_ste_mc_icse18A ilo_job1_ife_nature if   inlist(ilo_lfs_emp,1,2), missing


/* Table nature of economi unit by nature of main job */

table ilo_job1_ife_prod ilo_job1_ife_nature if   inlist(ilo_lfs_emp,1,2), missing

/* Table Status in employment ICSE18-A by nature of main job and by nature of economic unit */

table (ilo_job1_ste_mc_icse18A ilo_job1_ife_nature ) ilo_job1_ife_prod if   inlist(ilo_lfs_emp,1,2), missing


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 1.08:  SECOND JOB: STATUS IN EMPLOYMENT ICSE-18-A TYPE OF AUTHORITY                              ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

	
/*************************************************************************************************/
/***   STATUS IN EMPLOYMENT IN SECOND JOB (ICSE-18-A Type of authority ) – 5 Main categories   ***/
/***   Generates a single derived variable for the 5 main categories of ICSE-18-A              ***/
/*************************************************************************************************/


gen       ilo_job2_ste_mc_icse18A =.

replace   ilo_job2_ste_mc_icse18A =.


/* 1 - Employers  (ICSE-18=A)  - Second Job */

replace ilo_job2_ste_mc_icse18A = 1  if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2 & sjj_emp_rel==2 &  sjj_hires==1


/* 2 - Independent workers without employees  (ICSE-18=B)  - Second Job  */

replace ilo_job2_ste_mc_icse18A = 2  if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2 &  sjj_emp_rel==2  &  sjj_hires==2  &  sjd_single_client==3

replace ilo_job2_ste_mc_icse18A = 2  if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2 &  sjj_emp_rel==2  &  sjj_hires==2  &  sjd_single_client==2 &  inlist(sjd_source_client,3,4)

replace ilo_job2_ste_mc_icse18A = 2  if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2 &  sjj_emp_rel==2  &  sjj_hires==2  &  sjd_single_client==1  & sjd_control_g==1 

replace ilo_job2_ste_mc_icse18A = 2  if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2 &  sjj_emp_rel==2  &  sjj_hires==2  &  sjd_single_client==2 &  inlist(sjd_source_client,1,2)  &  sjd_control_g==1
          

/* 3 - Dependent contractors  (ICSE-18=C) - Second Job */		

replace ilo_job2_ste_mc_icse18A = 3  if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2 &  sjj_emp_rel==2  &  sjj_hires==2  &  sjd_single_client==1 &  ( sjd_control_a==1 | sjd_control_b==1 )

replace ilo_job2_ste_mc_icse18A = 3  if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2 &  sjj_emp_rel==2  &  sjj_hires==2  &  sjd_single_client==2 &  inlist(sjd_source_client,1,2)  &  ( sjd_control_a==1 | sjd_control_b==1 )
	

replace ilo_job2_ste_mc_icse18A = 3  if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2 &  sjj_emp_rel==1  &  sjd_rem_typ_a!=1 & inlist(sjd_socpro,2,97)

	
/* 4 - Employees (ICSE-18=D)   - Second job */			

replace ilo_job2_ste_mc_icse18A = 4  if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2 &  inlist(sjj_emp_rel,1,3,5)  &    sjd_rem_typ_a==1

replace ilo_job2_ste_mc_icse18A = 4  if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2 &  inlist(sjj_emp_rel,1)  &   sjd_rem_typ_a!=1  & inlist(sjd_socpro,1)

replace ilo_job2_ste_mc_icse18A = 4  if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2 &  inlist(sjj_emp_rel,4)


/* 5 - Contributing family workers  (ICSE-18=E)    - Second job */

replace ilo_job2_ste_mc_icse18A = 5  if  inlist(ilo_lfs_emp,1,2)  & mjj_mult==2  &  inlist(sjj_emp_rel,3,5)  &   sjd_rem_typ_a!=1


/* 9 - Employed not classifiable by status  (should not exist)   - Second job  */

replace ilo_job2_ste_mc_icse18A = 9  if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2  &   ilo_job2_ste_mc_icse18A==. 

/* Labels for the variable ilo_job2_ste_mc_icse18A and its response categories */

label def label_ilo_ste_mc_icse18A   ///
			1 "1 - Employers (ICSE-18 = A)" ///
			2 "2 - Independent workers without employees  (ICSE-18 = B)"  ///
			3 "3 - Dependent contractors  (ICSE-18 = C)"  ///
			4 "4 - Employees  (ICSE-18 = D)"  ///
			5 "5 - Contributing family workers  (ICSE-18 = E)"  ///
			9 "9 - Employed not classifiable by status", replace

label val ilo_job2_ste_mc_icse18A label_ilo_ste_mc_icse18A
label var ilo_job2_ste_mc_icse18A "Status in employment (ICSE-18-A Type of authority) – 5 Main categories"
	
/* Table Status in employment ICSE18-A for employed with second jobs */
	
table ilo_job2_ste_mc_icse18A mjj_mult if  inlist(ilo_lfs_emp,1,2), missing
	




/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 1.09  SECOND JOB: NATURE OF JOB ( INFORMAL AND FORMAL EMPLOYMENT )	                             ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

gen     ilo_job2_ife_nature=.

replace ilo_job2_ife_nature=.

/* Nature of main job for Employers and Independent workers without employees  ( ICSE-18 = A,B ) */

/* 2 - Formal employment */

replace ilo_job2_ife_nature = 2   if  inlist(ilo_lfs_emp,1,2)  & mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 1 &  sjj_regi==1   

replace ilo_job2_ife_nature = 2   if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 2 &  sjj_regi==1   


/* 1 - Informal employment */

replace ilo_job2_ife_nature = 1   if  inlist(ilo_lfs_emp,1,2)  & mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 1 &  inlist(sjj_regi,2,97)    

replace ilo_job2_ife_nature = 1   if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 2 &  inlist(sjj_regi,2,97) 



/* Nature of main job for Employees  ( ICSE-18 = D) */

/* 2 - Formal employment */

replace ilo_job2_ife_nature = 2   if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 4  &  sjd_socpro==1

/* 1 - Informal employment */

replace ilo_job2_ife_nature = 1   if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 4  &  inlist(sjd_socpro,2,97)



/* Nature of main job for Dependent contractors  ( ICSE-18 = C ) */


/* 2 - Formal employment */

replace ilo_job2_ife_nature = 2   if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 3  & sjj_emp_rel==1 &  sjd_socpro_self==1

replace ilo_job2_ife_nature = 2   if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 3  & sjj_emp_rel==2 &  sjj_regi==1 & sjd_socpro_self==1 
 
 
/* 1 - Informal employment */

replace ilo_job2_ife_nature = 1   if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 3  & sjj_emp_rel==1 &  inlist(sjd_socpro_self,2,97)

replace ilo_job2_ife_nature = 1   if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 3  & sjj_emp_rel==2 &  sjj_regi==1  & inlist(sjd_socpro_self,2,97)
 
replace ilo_job2_ife_nature = 1   if  inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 3  & sjj_emp_rel==2 &  inlist(sjj_regi,2,97)




/* Nature of main job for Contributing family workers  ( ICSE-18 = E ) */
/* Version A: If the variable "sjd_socpro_self" is not implemented, all CFWs have an informal  */
/* employment   */

/* Informal employment */

/*
replace ilo_job2_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2)  &  sjb_text==1  &  ilo_job2_ste_mc_icse18A == 5 
*/


/* Nature of main job for Contributing family workers  ( ICSE-18 = E ) */
/* Version B: If the variable "sjd_socpro_self" is implemented, then CFWs might have an informal or */
/* a formal employment   */

/* 2 - Formal employment */

replace ilo_job2_ife_nature = 2   if   inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 5  & sjj_emp_rel==3  &  sjj_regi==1  & sjd_socpro_self==1 


/* 1 - Informal employment */

replace ilo_job2_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 5  & sjj_emp_rel==3  &  sjj_regi==1  & inlist(sjd_socpro_self,2,97)

replace ilo_job2_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 5  & sjj_emp_rel==3  &  inlist(sjj_regi,2,97) 

replace ilo_job2_ife_nature = 1   if   inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2   &  ilo_job2_ste_mc_icse18A == 5  & sjj_emp_rel==5


/* Labels for the variable  ilo_job2_ife_nature and its categories */

lab def ife_nature_lab ///
		1 "1 - Employed with informal second job"  ///
		2 "2 – Employed with formal second job", replace 

lab val ilo_job2_ife_nature ife_nature_lab
lab var ilo_job2_ife_nature " Nature of second job: Informal and Formal Employment"		


/* Table nature of second job  */

table ilo_job2_ife_nature mjj_mult if   inlist(ilo_lfs_emp,1,2)  , missing

/* Table ICSE18-A second job by nature of second job  */

table ilo_job2_ste_mc_icse18A ilo_job2_ife_nature if   inlist(ilo_lfs_emp,1,2)  &  mjj_mult==2 , missing


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 1.10:  Working time in the different jobs  	                                                     ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


/* Hours usually worked per week in the main job */

tab wkt_mj_ushrs if inlist(ilo_lfs_emp,1,2), missing nolabel  

/* Hours actually worked last week in the main job */

tab wkt_mj_acthrs if inlist(ilo_lfs_emp,1,2), missing nolabel  


/* Hours usually worked per week in the second job */

tab wkt_sj_ushrs if inlist(ilo_lfs_emp,1,2) &  mjj_mult==2 , missing nolabel  

/* Hours actually worked last week in the second job */

tab wkt_sj_acthrs if inlist(ilo_lfs_emp,1,2) &  mjj_mult==2, missing nolabel  


/* Hours usually worked per week in other job(s) */

tab wkt_oj_ushrs if inlist(ilo_lfs_emp,1,2) &  mjj_mult==2 & wkt_oj==1, missing nolabel  

/* Hours actually worked last week in other job(s) */

tab wkt_oj_acthrs if inlist(ilo_lfs_emp,1,2) &  mjj_mult==2 & wkt_oj==1, missing nolabel  


/* Total hours usually worked per week in all jobs (only one job) */

tab wkt_ushrstot if inlist(ilo_lfs_emp,1,2) &  (mjj_mult==1 ), missing

/* Total hours usually worked per week in all jobs (two jobs) */

tab wkt_ushrstot if inlist(ilo_lfs_emp,1,2) &  (mjj_mult==2 ) & wkt_oj==2, missing

/* Total hours usually worked per week in all jobs (three or more jobs) */

tab wkt_ushrstot if inlist(ilo_lfs_emp,1,2) &  (mjj_mult==2 ) & wkt_oj==1, missing

/* Total hours usually worked per week in all jobs (all employed) */

tab wkt_ushrstot if inlist(ilo_lfs_emp,1,2) , missing


/* Total hours actually worked last week in all jobs (only one job) */

tab wkt_achrstot if inlist(ilo_lfs_emp,1,2) &  (mjj_mult==1 ), missing

/* Total hours actually worked last week in all jobs (two jobs) */

tab wkt_achrstot if inlist(ilo_lfs_emp,1,2) &  (mjj_mult==2 ) & wkt_oj==2, missing

/* Total hours actually worked last week in all jobs (three or more jobs) */

tab wkt_achrstot if inlist(ilo_lfs_emp,1,2) &  (mjj_mult==2 ) & wkt_oj==1, missing

/* Total hours actually worked last week in all jobs (all employed) */

tab wkt_achrstot if inlist(ilo_lfs_emp,1,2) , missing

/* Plot total usual hours  versus  total actual hours */

plot wkt_ushrstot wkt_achrstot if wkt_ushrstot!=997 & wkt_achrstot!=997


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 1.11:  PERSONS IN TIME-RELATED UNDEREMPLOYMENT                                                   ***/
/***    NOTE: the threshold is to be defined based on national practice                                          ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

/*  Threshold of hours worked used to identify Time Related Underemployment. Based on national practice */
/*  Threshold is set at the beginning of this do file */

gen     ilo_joball_tru = .
replace ilo_joball_tru = .

replace ilo_joball_tru = 1 if  inlist(ilo_lfs_emp,1,2)  & wkt_ushrstot < $glo_threshold_tru &  wkt_wnt_mrh == 1 & wkt_avl_mrh==1 & wkt_num_mrh>0		              

/* Labels for the variable  ilo_joball_tru and its categories */

lab def ilo_joball_tru_lab ///
		1 "1 - Time-related underemployed", replace

lab val ilo_joball_tru ilo_joball_tru_lab
lab var ilo_joball_tru "Time-related underemployed"

/*  Table: Employed in TRU among those usually working less than a specified hours threshold  */

table 	wkt_ushrstot if inlist(ilo_lfs_emp,1,2) & ilo_joball_tru==1 , missing



/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    CHAPTER 2:  UNEMPLOYMENT AND OTHERS OUTSIDE THE LABOUR FORCE                                             ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 2.1:  PERSONS UNEMPLOYED (19th ICLS Resolution)                                                  ***/
/***                  The generated derived variable uses two categories (1,2) to identify the unemployed        ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

gen     ilo_lfs_unemp = .

replace ilo_lfs_unemp = .

/* unemployed, not future starters */

/*
replace ilo_lfs_unemp = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & (srh_job==1 ) & inlist(srh_mtd,1,3,4,5,6,7,8) & (srh_avn==1 | (srh_avn==2 & srh_avl==1 ))
*/

replace ilo_lfs_unemp = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & (srh_job==1 ) & inlist(srh_mtd,1,3,4,5,6,7,8) &  (srh_fan==1 | srh_avl==1) 

replace ilo_lfs_unemp = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & (srh_job==1 ) & srh_mtd==2 & srh_act==1 & inlist(srh_oth,1,3,4,5,6,7,8)  &  (srh_fan==1 | srh_avl==1) 

/* unemployed, future starters */

replace ilo_lfs_unemp = 2 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 &  srh_job==2   & srh_des==1 & srh_dwy==4 & inlist(srh_ftr,1,2) & (srh_fan==1 | srh_avl==1 )

replace ilo_lfs_unemp = 2 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why==1 & inlist(srh_ftr,1,2) & (srh_fan==1 | srh_avl==1 )


/* Labels for the variable  ilo_lfs_unemp and its categories */

label def lfs_unemp_lab ///
			1 "1 - Unemployed: Not futute starters" ///
			2 "2 - Unemployed: Future starters", replace 

label val ilo_lfs_unemp  lfs_unemp_lab
label var ilo_lfs_unemp " Unemployment"

/* Table unemployment  */

table ilo_lfs_unemp , missing
table ilo_lfs_unemp if inlist(ilo_lfs_unemp,1,2), missing

table ilo_lfs_unemp if !inlist(ilo_lfs_emp,1,2) & dem_age>=15 , missing


		
			
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 2.1:  ONOT EMPLOYED WHO SEARCH FOR JOB  (WITHOUT INFORMATION ON AVAILABILITY                     ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


gen     tmp_ilo_lfs_search = .

replace tmp_ilo_lfs_search = .

/* searching. not future starters */

replace tmp_ilo_lfs_search = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==1 & inlist(srh_mtd,1,3,4,5,6,7,8)

replace tmp_ilo_lfs_search = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & (srh_job==1 ) & srh_mtd==2 & srh_act==1 & inlist(srh_oth,1,3,4,5,6,7,8)  

/* future starters */

replace tmp_ilo_lfs_search = 2 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 &  srh_job==2   & srh_des==1 & srh_dwy==4 & inlist(srh_ftr,1,2) & (srh_fan==1 | srh_avl==1 )

replace tmp_ilo_lfs_search = 2 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why==1 & inlist(srh_ftr,1,2) & (srh_fan==1 | srh_avl==1 )


/* Labels for the variable  Searching jobs and its categories */

label def searching_lab ///
			1 "1 - Searching jobs: Not futute starters" ///
			2 "2 - Future starters", replace 

label val tmp_ilo_lfs_search  searching_lab
label var tmp_ilo_lfs_search "Searching jobs"

/* Table not employed who search  */

table tmp_ilo_lfs_search , missing
table tmp_ilo_lfs_search if inlist(tmp_ilo_lfs_search,1,2), missing

table tmp_ilo_lfs_search if !inlist(ilo_lfs_emp,1,2) & dem_age>=15 , missing

/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 2.2:  PERSONS LONG-TERM UNEMPLOYED (19th ICLS Resolution)                                        ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

gen     ilo_long_unempl = .

replace ilo_long_unempl = .

replace ilo_long_unempl = 1 if inlist(ilo_lfs_unemp,1,2) & inlist(srh_dur,5,6) 

/* Labels for the variable  ilo_long_unempl and its categories */

lab def long_unempl_lab ///
        1 "Long-term unemployment", replace

lab values ilo_long_unempl  long_unempl_lab
lab var    ilo_long_unempl  "Long-term unemployment"	

/* Table  Long-term unemployment  */

table ilo_lfs_unemp ilo_long_unempl if inlist(ilo_lfs_unemp,1,2) , missing



/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 2.3:  POTENTIAL LABOUR FORCE     (19th ICLS Resolution)                                          ***/
/***                  includes: UNAVAILABLE JOBSEEKERS and AVAILABLE POTENTIAL JOBSEEKERS                        ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

/**************************************************************************************/
/***                                                                                ***/
/***   UNAVAILABLE JOBSEEKERS   (19th ICLS Resolution)                              ***/
/***   "seek employment", were not "currently available"                            ***/
/***                                                                                ***/
/**************************************************************************************/

gen     ilo_unavail_jobseek = .

replace ilo_unavail_jobseek = .

/*
replace ilo_unavail_jobseek = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==1 & inlist(srh_mtd,1,2,4,5,6,7,8,9,10,11,12,13,14) & srh_avn==2 & srh_avl==2 

replace ilo_unavail_jobseek = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==1 & inlist(srh_mtd,3) & srh_act==1 & inlist(srh_oth,1,2,4,5,6,7,8,9,10,11,12,13,14) &  srh_avn==2 & srh_avl==2 
*/

replace ilo_unavail_jobseek = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==1 & inlist(srh_mtd,1,3,4,5,6,7,8) & srh_avl==2 

replace ilo_unavail_jobseek = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==1 & srh_mtd==2 & srh_act==1 & inlist(srh_oth,1,3,4,5,6,7,8) &srh_avl==2 


replace ilo_unavail_jobseek = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 &  srh_job==2 & srh_des==1 & srh_dwy==4 & inlist(srh_ftr,1,2) & srh_fan==2 & srh_avl==2 

replace ilo_unavail_jobseek = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why==1 & inlist(srh_ftr,1,2) & srh_fan==2 & srh_avl==2


table ilo_unavail_jobseek, missing

table ilo_unavail_jobseek if !inlist(ilo_lfs_emp,1,2) & !inlist(ilo_lfs_unemp,1,2) , missing


/**************************************************************************************/
/***                                                                                ***/
/***   AVAILABLE POTENTIAL JOBSEEKERS   (19th ICLS Resolution)                      ***/
/***   did not "seek employment", wanted employments, were "currently available"    ***/
/***                                                                                ***/
/**************************************************************************************/
 
gen     ilo_avail_pot_jobseek = .

replace ilo_avail_pot_jobseek = .

/*
replace ilo_avail_pot_jobseek = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==1  & srh_mtd==3 & srh_act==2 & (srh_avn==1 | (srh_avn==2 & srh_avl==1) )

replace ilo_avail_pot_jobseek = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==2 & srh_des==1 & inlist(srh_dwy,1,2,3,5,6,7,8,9,10,11,12,13) & (srh_avn==1 | (srh_avn==2 & srh_avl==1) )
*/

replace ilo_avail_pot_jobseek = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==1  & srh_mtd==2 & srh_act==2 & srh_avl==1

replace ilo_avail_pot_jobseek = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==2 & srh_des==1 & inlist(srh_dwy,1,2,3,5,6,7,8,9,10,11,12,13) & srh_avl==1


replace ilo_avail_pot_jobseek = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==2 & srh_des==1 & inlist(srh_dwy,4) & srh_ftr==3 & (srh_fan==1 | srh_avl==1 )

replace ilo_avail_pot_jobseek = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why==1 & srh_ftr==3 & (srh_fan==1 | (srh_fan==2 & srh_avl==1) )


table ilo_avail_pot_jobseek, missing

table ilo_avail_pot_jobseek if !inlist(ilo_lfs_emp,1,2) & !inlist(ilo_lfs_unemp,1,2) , missing

table ilo_avail_pot_jobseek ilo_unavail_jobseek if !inlist(ilo_lfs_emp,1,2) & !inlist(ilo_lfs_unemp,1,2) , missing


/**************************************************************************************/
/***                                                                                ***/
/***   POTENTIAL LABOUR FORCE     (19th ICLS Resolution)                            ***/
/***   includes: UNAVAILABLE JOBSEEKERS and AVAILABLE POTENTIAL JOBSEEKERS          ***/
/***                                                                                ***/
/**************************************************************************************/

gen     ilo_potential_lf = .
replace ilo_potential_lf = .

replace ilo_potential_lf = 1 if  ilo_unavail_jobseek==1
replace ilo_potential_lf = 2 if  ilo_avail_pot_jobseek==1

/* Labels for the variable  ilo_potential_lf and its categories */

/*
lab def potential_lf_lab ///
		1 "1 - Unavailable jobseekers" ///
		2 "2 - Available potential jobseekers", replace
*/

lab def potential_lf_lab ///
		1 "1 - Unavailable jobseekers" ///
		2 "2 - Available potential jobseekers" ///
		3 "3 - Jobseekers with missingavailability", replace

lab val ilo_potential_lf  potential_lf_lab
lab var ilo_potential_lf  "Potential labour force"


/* Table  Potential labour force  */

table ilo_potential_lf if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & !inlist(ilo_lfs_unemp,1,2), missing
		

		


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 2.4:  DISCOURAGED JOBSEEKERS     (19th ICLS Resolution)                                          ***/
/***                  (subgroup of the AVAILABLE POTENTIAL JOBSEEKERS                                            ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
		
gen     ilo_discouraged = .

replace ilo_discouraged = .

replace ilo_discouraged = 1 if ilo_avail_pot_jobseek==1 & inlist(srh_dwy,5,6,7)

/* Labels for the variable  ilo_potential_lf and its categories */

lab def ilo_discouraged_lab ///
		1 "1 - Discouraged jobseekers", replace

lab val ilo_discouraged  ilo_discouraged_lab
lab var ilo_discouraged  "Discouraged jobseekers"


/* Table  Potential labour force  */

table ilo_discouraged ilo_avail_pot_jobseek, missing	


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***   SECTION 2.5:  WILLING NON-JOBSEEKERS  (19th ICLS Resolution)                                              ***/
/***   wanted employment, but did not "seek employment" and were not "currently available"                       ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

gen     ilo_willing_non_seekers = .

replace ilo_willing_non_seekers = .

/*
replace ilo_willing_non_seekers = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==1 & srh_mtd==3 & srh_act==2 & srh_avn==2 & srh_avl==2

replace ilo_willing_non_seekers = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==2 & srh_des==1 & inlist(srh_dwy,1,2,3,5,6,7,8,9,10,11,12,13) & srh_avn==2 & srh_avl==2
*/

replace ilo_willing_non_seekers = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==1 & srh_mtd==3 & srh_act==2 & srh_avl==2

replace ilo_willing_non_seekers = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==2 & srh_des==1 & inlist(srh_dwy,1,2,3,5,6,7,8,9,10,11,12,13) & srh_avl==2

replace ilo_willing_non_seekers = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why!=1 & srh_job==2 & srh_des==1 & srh_dwy==4 & srh_ftr==3 & srh_fan==2 & srh_avl==2

replace ilo_willing_non_seekers = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & abs_why==1 & srh_ftr==3 & srh_fan==2 & srh_avl==2


/* Labels for the variable  willing_non_seekers and its categories */		

lab def ilo_willing_non_seekers_lab ///
		1 "1 - Willing non-jobseekers", replace
		
lab val  ilo_willing_non_seekers ilo_willing_non_seekers_lab
lab var  ilo_willing_non_seekers "Willing non-jobseekers"

/* Table  Willing non-jobseekers  */
	
table ilo_willing_non_seekers ilo_potential_lf if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & !inlist(ilo_lfs_unemp,1,2), missing
		
		
/* Check remaining category */			
tab srh_job if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) &	!inlist(ilo_lfs_unemp,1,2) & !inlist(ilo_potential_lf,1,2)	& !inlist(ilo_willing_non_seekers,1), miss		
tab srh_des if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) &	!inlist(ilo_lfs_unemp,1,2) & !inlist(ilo_potential_lf,1,2)	& !inlist(ilo_willing_non_seekers,1), miss				
		

		
		
		
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 2.6:  OUTSIDE THE LABOUR FORCE (in working age)    (19th ICLS Resolution)                        ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

gen     ilo_lfs_olf = .

replace ilo_lfs_olf = .

replace ilo_lfs_olf = 1 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & !inlist(ilo_lfs_unemp,1,2) & ilo_unavail_jobseek==1 
replace ilo_lfs_olf = 2 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & !inlist(ilo_lfs_unemp,1,2) & ilo_avail_pot_jobseek==1
replace ilo_lfs_olf = 3 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & !inlist(ilo_lfs_unemp,1,2) & ilo_willing_non_seekers==1
replace ilo_lfs_olf = 4 if ilo_wap==1 & !inlist(ilo_lfs_emp,1,2) & !inlist(ilo_lfs_unemp,1,2) & ilo_lfs_olf==.

/* Labels for the variable  ilo_lfs_olf and its categories */

lab def ilo_lfs_olf_lab ///
		1 "1 - Unavailable jobseekers" ///
		2 "2 - Available potential jobseekers" ///
     	3 "3 - Willing non-jobseekers" ///
        4 "4 - Others not willing", replace

lab values ilo_lfs_olf  ilo_lfs_olf_lab
lab var    ilo_lfs_olf  "Outside the labour force"	

/* Table  Long-term unemployment  */

table ilo_lfs_olf  if ilo_wap==1 , missing

table ilo_lfs_olf  ilo_lfs_emp if ilo_wap==1 , missing

table ilo_lfs_olf  ilo_lfs_unemp if ilo_wap==1 , missing
		


		
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***   SECTION 2.7:  LABOUR FORCE STATUS (3 mutual exclusive categories)  (19th ICLS Resolution)                 ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

gen     ilo_lfs = .
replace ilo_lfs = .
replace ilo_lfs = 1 if inlist(ilo_lfs_emp,1,2)										
replace ilo_lfs = 2 if inlist(ilo_lfs_unemp,1,2) 
replace ilo_lfs = 3 if inlist(ilo_lfs_olf,1,2,3,4) 

/* Labels for the variable ilo_lfs and its categories */		

label define ilo_lfs_lab /// 
             1 "1 - Employed"  ///
			 2 "2 - Unemployed"  ///
			 3 "3 - Outside Labour Force", replace

label val ilo_lfs ilo_lfs_lab
label var ilo_lfs "Labour Force Status" 


/* Table  labour force status */

table ilo_lfs    if ilo_wap==1, missing	

table ilo_lfs ilo_lfs_emp   if ilo_wap==1, missing
table ilo_lfs ilo_lfs_unemp if ilo_wap==1, missing
table ilo_lfs ilo_lfs_olf   if ilo_wap==1, missing

/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    CHAPTER 3:  OWN-USE PRODUCERS OF GOODS	(19th ICLS Resolution)                                           ***/
/***                includes OWN-USE PRODUCERS OF FOODSTUFF and OWN-USE PRODUCERS OF NON-FOODSTUFF GOODS         ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 3.1:  OWN-USE PRODUCERS OF FOODSTUFF                                                             ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


gen     ilo_own_use_prod_foodstuff=.

replace ilo_own_use_prod_foodstuff=.

/* own-use producers of foodstuff identified in the AGF module (Primary foodstuff production) */ 
replace ilo_own_use_prod_foodstuff=1 if ilo_wap==1 & ( agf_chk_a==1 | agf_chk_b==1 | agf_chk_c==1 ) & ( inlist(agf_mkt,3,4) | inlist(agf_his,3,4) ) & agf_hir==2 

/* own-use producers of foodstuff identified in the AGF module (Primary foodstuff production) */ 
replace ilo_own_use_prod_foodstuff=1 if ilo_wap==1 & ( agf_any_a==1 | agf_any_b==1 | agf_any_c==1 ) & ( inlist(agf_mkt,3,4) | inlist(agf_his,3,4) ) & agf_hir==2 

/* own-use producers of foodstuff identified in the OPC module (Secondary foodstuff production)*/ 
replace ilo_own_use_prod_foodstuff=1 if ilo_wap==1 & ( opc_hcrop==1 | opf_hfood_a==1 | opf_hfood_b==1 | opf_hfood_c==1 )


/* Labels for the variable  prod_food_sub and its categories */		

lab def ilo_own_use_prod_foodstuff_lab ///
          1 "1 – Own-use producers of foodstuff" , replace

lab val ilo_own_use_prod_foodstuff ilo_own_use_prod_foodstuff_lab
lab var ilo_own_use_prod_foodstuff "Own-use producers of foodstuff"
		
/* Table  Own-use producers of foodstuff */
	
table ilo_own_use_prod_foodstuff if ilo_wap==1, miss		

/* Table  Own-use producers of foodstuff and employed */	

table ilo_own_use_prod_foodstuff ilo_lfs_emp if ilo_wap==1, miss				
	
	

/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 3.2:  OWN-USE PRODUCERS OF GOODS                                                                 ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

	
gen     ilo_own_use_prod_goods=.

replace ilo_own_use_prod_goods =.

/* Own-use producers of foodstuff */
replace ilo_own_use_prod_goods =1 if ilo_wap==1 &   ilo_own_use_prod_foodstuff==1 

/* Own-use producers of non-foodstuff goods */
replace ilo_own_use_prod_goods =1 if ilo_wap==1 & mnf_opg==1

/* Labels for the variable  own_use_prod_goods and its categories */		

lab def ilo_own_use_prod_goods_lab ///
	1 "1 – Own-use producers of goods" , replace

lab val ilo_own_use_prod_goods ilo_own_use_prod_goods_lab
lab var ilo_own_use_prod_goods " Own-use producers of goods "
		
/* Table  Own-use producers of goods */
	
table ilo_own_use_prod_goods if ilo_wap==1, miss		

/* Table Own-use producers of goods and employed */	

table ilo_own_use_prod_goods  ilo_lfs_emp if ilo_wap==1, miss

/* Table Own-use producers of goods and Own-use producers of foodstuff */	

table ilo_own_use_prod_foodstuff ilo_own_use_prod_goods  if ilo_wap==1, miss


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    CHAPTER 4:  HOURS WORKED IN EMPLOYMENT IN HOUR BANDS          	                                         ***/
/***                                                                                                             ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 4.1 HOURS USUALLY WORKED PER WEEK IN HOUR BANDS  IN MAIN JOB                                     ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
	
gen     ilo_job1_how_usual_bands =.
replace ilo_job1_how_usual_bands =.
replace ilo_job1_how_usual_bands =1 if ilo_lfs==1 & wkt_mj_ushrs==0
replace ilo_job1_how_usual_bands =2 if ilo_lfs==1 & wkt_mj_ushrs> 0 & wkt_mj_ushrs<=14
replace ilo_job1_how_usual_bands =3 if ilo_lfs==1 & wkt_mj_ushrs>14 & wkt_mj_ushrs<=29
replace ilo_job1_how_usual_bands =4 if ilo_lfs==1 & wkt_mj_ushrs>29 & wkt_mj_ushrs<=34
replace ilo_job1_how_usual_bands =5 if ilo_lfs==1 & wkt_mj_ushrs>34 & wkt_mj_ushrs<=39
replace ilo_job1_how_usual_bands =6 if ilo_lfs==1 & wkt_mj_ushrs>39 & wkt_mj_ushrs<=48
replace ilo_job1_how_usual_bands =7 if ilo_lfs==1 & wkt_mj_ushrs>48 & wkt_mj_ushrs!=997
replace ilo_job1_how_usual_bands =8 if ilo_lfs==1 & wkt_mj_ushrs==997 
replace ilo_job1_how_usual_bands =8 if ilo_lfs==1 & wkt_mj_ushrs==.
 
/* Labels for the variable  ilo_job1_how_usual_bands and its categories */		

lab def ilo_job1_how_usual_bands_lab ///
						1 "1 - No hours usually worked" ///
						2 "2 - 01 to 14"  ///
						3 "3 - 15 to 29"  ///
						4 "4 - 30 to 34"  ///
						5 "5 - 35 to 39"  ///
						6 "6 - 40 to 48"  ///
						7 "7 - 49 plus"  ///
						8 "8 - Don't know / Missing", replace
						
lab val ilo_job1_how_usual_bands ilo_job1_how_usual_bands_lab
lab var ilo_job1_how_usual_bands "Weekly hours usually worked bands - main job"

	
/* Table  Weekly hours usually worked bands - main job */
	
table ilo_job1_how_usual_bands if ilo_lfs==1, miss		

table wkt_mj_ushrs ilo_job1_how_usual_bands if ilo_lfs==1, miss		

*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 4.2 HOURS ACTUALLY WORKED IN THE REFERENCE WEEK IN HOUR BANDS  IN MAIN JOB                       ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


gen     ilo_job1_how_actual_bands =.
replace ilo_job1_how_actual_bands =.
replace ilo_job1_how_actual_bands =1 if ilo_lfs==1 & wkt_mj_acthrs==0
replace ilo_job1_how_actual_bands =2 if ilo_lfs==1 & wkt_mj_acthrs> 0 & wkt_mj_acthrs<=14
replace ilo_job1_how_actual_bands =3 if ilo_lfs==1 & wkt_mj_acthrs>14 & wkt_mj_acthrs<=29
replace ilo_job1_how_actual_bands =4 if ilo_lfs==1 & wkt_mj_acthrs>29 & wkt_mj_acthrs<=34
replace ilo_job1_how_actual_bands =5 if ilo_lfs==1 & wkt_mj_acthrs>34 & wkt_mj_acthrs<=39
replace ilo_job1_how_actual_bands =6 if ilo_lfs==1 & wkt_mj_acthrs>39 & wkt_mj_acthrs<=48
replace ilo_job1_how_actual_bands =7 if ilo_lfs==1 & wkt_mj_acthrs>48 & wkt_mj_acthrs!=997
replace ilo_job1_how_actual_bands =8 if ilo_lfs==1 & wkt_mj_acthrs==997 
replace ilo_job1_how_actual_bands =8 if ilo_lfs==1 & wkt_mj_acthrs==.
 
/* Labels for the variable  ilo_job1_how_usual_bands and its categories */		

lab def ilo_job1_how_actual_bands_lab ///
						1 "1 - No hours actually worked" ///
						2 "2 - 01 to 14"  ///
						3 "3 - 15 to 29"  ///
						4 "4 - 30 to 34"  ///
						5 "5 - 35 to 39"  ///
						6 "6 - 40 to 48"  ///
						7 "7 - 49 plus"  ///
						8 "8 - Don't know / Missing", replace
						
lab val ilo_job1_how_actual_bands ilo_job1_how_actual_bands_lab
lab var ilo_job1_how_actual_bands "Weekly hours actually worked bands - main job"

	
/* Table  Weekly hours usually worked bands - main job */
	
table ilo_job1_how_actual_bands if ilo_lfs==1, miss		

table wkt_mj_acthrs ilo_job1_how_actual_bands if ilo_lfs==1, miss		

/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 4.3 HOURS USUALLY WORKED PER WEEK IN HOUR BANDS       IN ALL JOBS                                ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
	
gen     ilo_joball_how_usual_bands =.
replace ilo_joball_how_usual_bands =.
replace ilo_joball_how_usual_bands =1 if ilo_lfs==1 & wkt_ushrstot==0
replace ilo_joball_how_usual_bands =2 if ilo_lfs==1 & wkt_ushrstot> 0 & wkt_ushrstot<=14
replace ilo_joball_how_usual_bands =3 if ilo_lfs==1 & wkt_ushrstot>14 & wkt_ushrstot<=29
replace ilo_joball_how_usual_bands =4 if ilo_lfs==1 & wkt_ushrstot>29 & wkt_ushrstot<=34
replace ilo_joball_how_usual_bands =5 if ilo_lfs==1 & wkt_ushrstot>34 & wkt_ushrstot<=39
replace ilo_joball_how_usual_bands =6 if ilo_lfs==1 & wkt_ushrstot>39 & wkt_ushrstot<=48
replace ilo_joball_how_usual_bands =7 if ilo_lfs==1 & wkt_ushrstot>48 & wkt_ushrstot!=997
replace ilo_joball_how_usual_bands =8 if ilo_lfs==1 & wkt_ushrstot==997 
replace ilo_joball_how_usual_bands =8 if ilo_lfs==1 & wkt_ushrstot==.
 
/* Labels for the variable  ilo_job1_how_usual_bands and its categories */		

lab def ilo_joball_how_usual_bands_lab ///
						1 "1 - No hours usually worked" ///
						2 "2 - 01 to 14"  ///
						3 "3 - 15 to 29"  ///
						4 "4 - 30 to 34"  ///
						5 "5 - 35 to 39"  ///
						6 "6 - 40 to 48"  ///
						7 "7 - 49 plus"  ///
						8 "8 - Don't know / Missing", replace
						
lab val ilo_joball_how_usual_bands ilo_joball_how_usual_bands_lab
lab var ilo_joball_how_usual_bands "Weekly hours usually worked bands - all jobs"

	
/* Table  Weekly hours usually worked bands - main job */
	
table ilo_joball_how_usual_bands if ilo_lfs==1, miss		

table wkt_ushrstot ilo_joball_how_usual_bands if ilo_lfs==1, miss	

/* To double check that the calculation of total hours is done correctly */
list wkt_mj_ushrs wkt_sj_ushrs wkt_oj_ushrs wkt_ushrstot_calc wkt_ushrstot

*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    SECTION 4.4 HOURS ACTUALLY WORKED IN THE REFERENCE WEEK IN HOUR BANDS        IN ALL JOBS                 ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


gen     ilo_joball_how_actual_bands =.
replace ilo_joball_how_actual_bands =.
replace ilo_joball_how_actual_bands =1 if ilo_lfs==1 & wkt_achrstot==0
replace ilo_joball_how_actual_bands =2 if ilo_lfs==1 & wkt_achrstot> 0 & wkt_achrstot<=14
replace ilo_joball_how_actual_bands =3 if ilo_lfs==1 & wkt_achrstot>14 & wkt_achrstot<=29
replace ilo_joball_how_actual_bands =4 if ilo_lfs==1 & wkt_achrstot>29 & wkt_achrstot<=34
replace ilo_joball_how_actual_bands =5 if ilo_lfs==1 & wkt_achrstot>34 & wkt_achrstot<=39
replace ilo_joball_how_actual_bands =6 if ilo_lfs==1 & wkt_achrstot>39 & wkt_achrstot<=48
replace ilo_joball_how_actual_bands =7 if ilo_lfs==1 & wkt_achrstot>48 & wkt_achrstot!=997
replace ilo_joball_how_actual_bands =8 if ilo_lfs==1 & wkt_achrstot==997 
replace ilo_joball_how_actual_bands =8 if ilo_lfs==1 & wkt_achrstot==.
 
/* Labels for the variable  ilo_job1_how_usual_bands and its categories */		

lab def ilo_joball_how_actual_bands_lab ///
						1 "1 - No hours actually worked" ///
						2 "2 - 01 to 14"  ///
						3 "3 - 15 to 29"  ///
						4 "4 - 30 to 34"  ///
						5 "5 - 35 to 39"  ///
						6 "6 - 40 to 48"  ///
						7 "7 - 49 plus"  ///
						8 "8 - Don't know / Missing", replace
						
lab val ilo_joball_how_actual_bands ilo_joball_how_actual_bands_lab
lab var ilo_joball_how_actual_bands "Weekly hours actually worked bands - all job"

	
/* Table  Weekly hours usually worked bands - main job */
	
table ilo_joball_how_actual_bands if ilo_lfs==1, miss		

table wkt_achrstot ilo_joball_how_actual_bands if ilo_lfs==1, miss	

/* To double check that the calculation of total hours is done correctly */
list wkt_mj_acthrs wkt_sj_acthrs wkt_oj_acthrs wkt_achrstot_calc wkt_achrstot


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    CHAPTER 5:  OTHER VARIABLES                                    	                                         ***/
/***                                                                                                             ***/
/***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/
/*******************************************************************************************************************/


/*******************************************************************************************************************/
/*******************************************************************************************************************/
/***                                                                                                             ***/
/***    AGE GROUPS - TEN YEARS BANDS                   	                                                         ***/
//***                                                                                                             ***/
/*******************************************************************************************************************/
/*******************************************************************************************************************/

gen     ilo_age_10yrbands =.
replace ilo_age_10yrbands =.
replace ilo_age_10yrbands =1 if inrange(dem_age, 0,14)
replace ilo_age_10yrbands =2 if inrange(dem_age,15,24)
replace ilo_age_10yrbands =3 if inrange(dem_age,25,34)
replace ilo_age_10yrbands =4 if inrange(dem_age,35,44)
replace ilo_age_10yrbands =5 if inrange(dem_age,45,54)
replace ilo_age_10yrbands =6 if inrange(dem_age,55,64)
replace ilo_age_10yrbands =7 if         dem_age>=65

/* Labels for the variable  ilo_age_10yrbands and its categories */		

lab def age_by10_lab ///
		1 "1 -  0 to 14" ///
		2 "2 - 15 to 24" ///
		3 "3 - 25 to 34" ///
		4 "4 - 35 to 44" ///
		5 "5 - 45 to 54" ///
		6 "6 - 55 to 64" ///
		7 "7 - 65 plus", replace

lab val ilo_age_10yrbands ilo_age_10yrbands_lab
lab var ilo_age_10yrbands "Age group (10-year age bands)"
			
	
/* Table  Age group */

table ilo_age_10yrbands, miss	
	
table dem_age ilo_age_10yrbands, miss		




save      "${DIR_DATA_550DV_YQ}\LFS_2024_Q4_DER.dta", replace	


