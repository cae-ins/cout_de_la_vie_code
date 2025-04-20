

*******************************************************************************************************************
*******************************************************************************************************************                
* 
*            STEP 0 - VALIDATE OUTCOMES
* 
*******************************************************************************************************************
*******************************************************************************************************************


use        "${DIR_DATA_441RD_YQ}\LFS_${YYYY_Q}_RAW.dta", clear


/* remove extra households in the PSU's */
drop if interview__key == "43-67-19-91" // extra hh in PSU 651
drop if interview__key == "63-66-52-44" // extra hh in PSU 652

/* duplicate interview file*/
drop if interview__key == "09-83-60-07"

/*redundant interview file */
drop if interview__key == "64-52-13-68"  // 115_96371 asked for replacement and this file was created and sent, but later they filled out the initial file, so this file became redundant
drop if interview__key == "55-39-06-59" // no information collected, replaced 


collapse (count) selection_year, by(YEAR QUARTER interview__key GHI_HOUSEHOLD_ID id_hh_panel_calc type_ssu rot_group_id  rot_group_wave INTERVIEW_RESULT )

tab YEAR QUARTER 


save        "${DIR_DATA_441RD_YQ}\LFS_${YYYY_Q}_OUTCOMES.dta", replace


tab rot_group_id rot_group_wave if inlist(INTERVIEW_RESULT,1,2,3), missing


/* Check thatm we have only one record per households*/
collapse (count) selection_year, by(YEAR QUARTER GHI_HOUSEHOLD_ID id_hh_panel_calc)

tab YEAR QUARTER 


use        "${DIR_DATA_441RD_YQ}\LFS_${YYYY_Q}_OUTCOMES.dta", clear

tab rot_group_id type_ssu, miss

/* household interviewed that can be reused for reinterviews */
tab rot_group_id type_ssu if inlist(INTERVIEW_RESULT,1,2,3), missing

tab YEAR QUARTER

tab INTERVIEW_RESULT if rot_group_id==""

tab INTERVIEW_RESULT if rot_group_id!=""
