/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****                                                                                                                   *****/
/*****                         SUB-PROCESS 4.1.0:    SELECT THEORETHICAL QUARTERLY SAMPLE                                *****/
/*****                                                                                                                   *****/
/*****    1) Retrieve information from sampling list and sampling frame to conduct first interview                       *****/
/*****                                                                                                                   *****/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/


/*****    1) Retrieve information from sampling list and sampling frame to conduct first interview:                       *****/
/*****      Name of the reference person, address, contact numbers, etc.                                                  *****/

global NAME_SUSO LFS_2024_V4

global WEEK_START  2024-12-08

global WEEK_END    2024-12-14


***************************Get Interviewer and Supervisor Information - Sample hh***********************/
import excel "${DIR_DATA_422SU_YQ}\Month${MONTH}\Interviewers_and_Supervisors_LFS_Maale_${YYYY_Q}_M${MONTH}.xlsx", sheet("PSUs_and_Fieldworkers") firstrow clear

save "${DIR_DATA_422SU_YQ}\Month${MONTH}\Interviewers_and_Supervisors_LFS_Maale_${YYYY_Q}_M${MONTH}.dta",replace

***************************Get Interviewer and Supervisor Information - Replacement hh***********************/
import excel "${DIR_DATA_422SU_YQ}\Month${MONTH}\Replacement_Interviewers_and_Supervisors_LFS_Maale_${YYYY_Q}_M${MONTH}.xlsx", sheet("PSUs_and_Fieldworkers") firstrow clear

save "${DIR_DATA_422SU_YQ}\Month${MONTH}\Replacement_Interviewers_and_Supervisors_LFS_Maale_${YYYY_Q}_M${MONTH}.dta",replace


/*******************************************************************************************/
/************************** Prepare data for households     *******************************/
/*******************************************************************************************/

use "${DIR_DATA_422SU_YQ}\Month${MONTH}\Sample_hhlds_first_interview_${YYYYQ}_M${MONTH}.dta", clear

tab year month, miss


merge 1:m id_psu_n id_hh_sas using"${DIR_DATA_412CS}\2024\SSU_sample_2024.dta"

keep if _merge==3

sort id_psu_n id_hh_sas ind__id
bys  id_psu_n id_hh_sas: gen n=1 if _n == 1

keep if n==1
drop n

tab unit_type

keep if unit_type==1

drop _merge

merge 1:m id_psu_n id_hh_sas using"${DIR_DATA_412CS}\2024\SSU_sample_2024_contact.dta"

keep if _merge==3

tab year month, miss


sort id_psu_n id_hh_sas ind__id
bys  id_psu_n id_hh_sas: gen n=1 if _n == 1

keep if n==1

tab unit_type

gen WEEK_ST = date("$WEEK_START", "YMD")
gen WEEK_EN = date("$WEEK_END", "YMD")

format WEEK_ST WEEK_EN %td

save "${DIR_DATA_422SU_YQ}\Month${MONTH}\Sample_hhlds_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", replace


use  "${DIR_DATA_422SU_YQ}\Month${MONTH}\Sample_hhlds_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", clear

/* keeps only the base households or those who are active */
keep if type_ssu==1

		
generate GHI_ISLAND_CODE = island_code
generate GHI_BLOCK_CODE = block_code
generate GHI_STRUCTURE = structure + "  (" + structure__id + ")"
generate GHI_HOUSE_DESC = house_desc
generate GHI_DWELLING = dwelling_name
generate GHI_PSU_ID = id_psu_n
generate GHI_STRATA_ID = stratum
generate GHI_SAMPLE = 1 // for this quarter 2024Q4
egen     GHI_HOUSEHOLD_ID = concat(id_psu_n   id_hh_sas), punct("_")
generate GHI_REFERENCE_PERSON = unit_contact_name
generate CONTACTS = contact_number if unit_type == 2
tostring CONTACTS, generate(GHI_CONTACTS) format(%12.0f)
drop CONTACTS
replace GHI_CONTACTS = "N/A" if unit_type == 1
//generate WEEK_ST =  $WEEK_START 
//generate WEEK_EN =  $WEEK_END 
generate YEAR = "$YEAR"	
generate QUARTER = "$QUARTER"	
generate MONTH = "$MONTH"
generate MONTH_SEQ = month_seq
generate GHI_COUNTRY = "MALDIVES"
generate id_hh_panel_prefilled = 1 // for this quarter 2024Q4
generate UNIT_TYPE = unit_type

keep YEAR QUARTER MONTH MONTH_SEQ ///
GHI_ISLAND_CODE	 ///
GHI_BLOCK_CODE	 ///
GHI_STRUCTURE	 ///
GHI_HOUSE_DESC ///
GHI_DWELLING ///
GHI_PSU_ID ///
GHI_STRATA_ID ///
GHI_SAMPLE ///
GHI_HOUSEHOLD_ID ///	
GHI_REFERENCE_PERSON ///	
GHI_CONTACTS ///	
WEEK_ST	///
WEEK_EN ///
GHI_COUNTRY ///
ward_code ///
type_ssu ///
id_psu_n ///
id_hh_sas ///
selection_year ///
rot_group_id ///
rot_group_wave ///
id_hh_panel_prefilled ///
UNIT_TYPE



order ///
YEAR QUARTER MONTH MONTH_SEQ ///
GHI_COUNTRY ///
GHI_ISLAND_CODE	 ///
GHI_BLOCK_CODE	 ///
GHI_STRUCTURE	 ///
GHI_HOUSE_DESC ///
GHI_DWELLING ///
GHI_PSU_ID ///
GHI_STRATA_ID ///
GHI_SAMPLE ///
GHI_HOUSEHOLD_ID ///	
GHI_REFERENCE_PERSON ///	
GHI_CONTACTS ///	
WEEK_ST	///
WEEK_EN ///	
rot_group_id ///
rot_group_wave ///


save "${DIR_DATA_422SU_YQ}\Month${MONTH}\Sample_hhlds_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", replace





*************
******************
********************

use "${DIR_DATA_422SU_YQ}\Month${MONTH}\Substitute_hhlds_first_interview_${YYYYQ}_M${MONTH}.dta", clear

tab year month, miss


merge 1:m id_psu_n id_hh_sas using"${DIR_DATA_412CS}\2024\SSU_sample_2024.dta"

keep if _merge==3

sort id_psu_n id_hh_sas ind__id
bys  id_psu_n id_hh_sas: gen n=1 if _n == 1

keep if n==1
drop n

tab unit_type

keep if unit_type==1

drop _merge

merge 1:m id_psu_n id_hh_sas using"${DIR_DATA_412CS}\2024\SSU_sample_2024_contact.dta"

keep if _merge==3

tab year month, miss


sort id_psu_n id_hh_sas ind__id
bys  id_psu_n id_hh_sas: gen n=1 if _n == 1

keep if n==1

tab unit_type

gen WEEK_ST = date("$WEEK_START", "YMD")
gen WEEK_EN = date("$WEEK_END", "YMD")

format WEEK_ST WEEK_EN %td

save "${DIR_DATA_422SU_YQ}\Month${MONTH}\Substitute_hhlds_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", replace


use  "${DIR_DATA_422SU_YQ}\Month${MONTH}\Substitute_hhlds_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", clear

/* keeps only the substitute households */
keep if type_ssu==2

		
generate GHI_ISLAND_CODE = island_code
generate GHI_BLOCK_CODE = block_code
generate GHI_STRUCTURE = structure + "  (" + structure__id + ")"
generate GHI_HOUSE_DESC = house_desc
generate GHI_DWELLING = dwelling_name
generate GHI_PSU_ID = id_psu_n
generate GHI_STRATA_ID = stratum
generate GHI_SAMPLE = 1 // for this quarter 2024Q4
egen     GHI_HOUSEHOLD_ID = concat(id_psu_n   id_hh_sas), punct("_")
generate GHI_REFERENCE_PERSON = unit_contact_name
generate CONTACTS = contact_number if unit_type == 2
tostring CONTACTS, generate(GHI_CONTACTS) format(%12.0f)
drop CONTACTS
replace GHI_CONTACTS = "N/A" if unit_type == 1
//generate WEEK_ST =  $WEEK_START 
//generate WEEK_EN =  $WEEK_END 
generate YEAR = "$YEAR"	
generate QUARTER = "$QUARTER"	
generate MONTH = "$MONTH"
generate MONTH_SEQ = month_seq
generate GHI_COUNTRY = "MALDIVES"
generate id_hh_panel_prefilled = 1 // for this quarter 2024Q4
generate UNIT_TYPE = unit_type

keep YEAR QUARTER MONTH MONTH_SEQ ///
GHI_ISLAND_CODE	 ///
GHI_BLOCK_CODE	 ///
GHI_STRUCTURE	 ///
GHI_HOUSE_DESC ///
GHI_DWELLING ///
GHI_PSU_ID ///
GHI_STRATA_ID ///
GHI_SAMPLE ///
GHI_HOUSEHOLD_ID ///	
GHI_REFERENCE_PERSON ///	
GHI_CONTACTS ///	
WEEK_ST	///
WEEK_EN ///
GHI_COUNTRY ///
ward_code ///
type_ssu ///
id_psu_n ///
id_hh_sas ///
selection_year ///
rot_group_id ///
rot_group_wave ///
id_hh_panel_prefilled ///
UNIT_TYPE



order ///
YEAR QUARTER MONTH MONTH_SEQ ///
GHI_COUNTRY ///
GHI_ISLAND_CODE	 ///
GHI_BLOCK_CODE	 ///
GHI_STRUCTURE	 ///
GHI_HOUSE_DESC ///
GHI_DWELLING ///
GHI_PSU_ID ///
GHI_STRATA_ID ///
GHI_SAMPLE ///
GHI_HOUSEHOLD_ID ///	
GHI_REFERENCE_PERSON ///	
GHI_CONTACTS ///	
WEEK_ST	///
WEEK_EN ///	
rot_group_id ///
rot_group_wave ///


save "${DIR_DATA_422SU_YQ}\Month${MONTH}\Substitute_hhlds_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", replace



*************
******************
********************






/*******************************************************************************************/
/************************** Prepare data for labour quarters *******************************/
/*******************************************************************************************/


use "${DIR_DATA_422SU_YQ}\Month${MONTH}\Sample_hhlds_first_interview_${YYYYQ}_M${MONTH}.dta", clear

tab year month, miss


merge 1:m id_psu_n id_hh_sas using"${DIR_DATA_412CS}\2024\SSU_sample_2024.dta"

keep if _merge==3

tab unit_type

keep if unit_type==2

drop _merge

merge 1:m id_psu_n id_hh_sas ind__id using"${DIR_DATA_412CS}\2024\SSU_sample_2024_contact.dta"

keep if _merge==3

sort id_psu_n id_hh_sas ind__id

tab year month, miss

save "${DIR_DATA_422SU_YQ}\Month${MONTH}\Sample_labquart_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", replace


use  "${DIR_DATA_422SU_YQ}\Month${MONTH}\Sample_labquart_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", clear

/* keeps only the base households or those who are active */
keep if type_ssu==1

	
generate GHI_ISLAND_CODE = island_code
generate GHI_BLOCK_CODE = block_code
generate GHI_STRUCTURE = structure + "  (" + structure__id + ")"
generate GHI_HOUSE_DESC = house_desc
generate GHI_DWELLING = dwelling_name
generate GHI_PSU_ID = id_psu_n
generate GHI_STRATA_ID = stratum
generate GHI_SAMPLE = 1 // for this quarter 2024Q4
egen     GHI_HOUSEHOLD_ID = concat(id_psu_n   id_hh_sas), punct("_")
generate GHI_REFERENCE_PERSON = unit_contact_name
generate CONTACTS = contact_number if unit_type == 2
tostring CONTACTS, generate(GHI_CONTACTS) format(%12.0f)
drop CONTACTS
// generate WEEK_ST =  $WEEK_START 
// generate WEEK_EN =  $WEEK_END 

gen WEEK_ST = date("$WEEK_START", "YMD")
gen WEEK_EN = date("$WEEK_END", "YMD")

format WEEK_ST WEEK_EN %td
// generate DEM_NAME = pl_hhmemberlist
// generate DEM_SEX =  m1
// generate DEM_AGE =   age
generate YEAR = "$YEAR"	
generate QUARTER = "$QUARTER"	
generate MONTH = "$MONTH"	
generate MONTH_SEQ = month_seq
generate GHI_COUNTRY = "MALDIVES"
generate id_hh_panel_prefilled = 1 // for this quarter 2024Q4
generate UNIT_TYPE = unit_type




keep YEAR QUARTER MONTH MONTH_SEQ ///
GHI_ISLAND_CODE	 ///
GHI_BLOCK_CODE	 ///
GHI_STRUCTURE	 ///
GHI_HOUSE_DESC ///
GHI_DWELLING ///
GHI_PSU_ID ///
GHI_STRATA_ID ///
GHI_SAMPLE ///
GHI_HOUSEHOLD_ID ///	
GHI_REFERENCE_PERSON ///	
GHI_CONTACTS ///	
WEEK_ST	///
WEEK_EN ///	
GHI_COUNTRY ///
ward_code ///
type_ssu ///
id_psu_n ///
id_hh_sas ///
selection_year ///
rot_group_id ///
rot_group_wave ///
id_hh_panel_prefilled ///
lq_list ///
no_of_ppl ///
UNIT_TYPE ///
ind__id 
// DEM_NAME ///
// DEM_SEX ///
// DEM_AGE ///



order ///
YEAR QUARTER MONTH MONTH_SEQ ///
GHI_COUNTRY ///
GHI_ISLAND_CODE	 ///
GHI_BLOCK_CODE	 ///
GHI_STRUCTURE	 ///
GHI_HOUSE_DESC ///
GHI_DWELLING ///
GHI_PSU_ID ///
GHI_STRATA_ID ///
GHI_SAMPLE ///
GHI_HOUSEHOLD_ID ///	
GHI_REFERENCE_PERSON ///	
GHI_CONTACTS ///	
WEEK_ST	///
WEEK_EN ///	


save "${DIR_DATA_422SU_YQ}\Month${MONTH}\Sample_labquart_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", replace



*************
******************
********************



use "${DIR_DATA_422SU_YQ}\Month${MONTH}\Substitute_hhlds_first_interview_${YYYYQ}_M${MONTH}.dta", clear

tab year month, miss


merge 1:m id_psu_n id_hh_sas using"${DIR_DATA_412CS}\2024\SSU_sample_2024.dta"

keep if _merge==3

tab unit_type

keep if unit_type==2

drop _merge

merge 1:m id_psu_n id_hh_sas ind__id using"${DIR_DATA_412CS}\2024\SSU_sample_2024_contact.dta"

keep if _merge==3

sort id_psu_n id_hh_sas ind__id

tab year month, miss

save "${DIR_DATA_422SU_YQ}\Month${MONTH}\Substitute_labquart_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", replace


use  "${DIR_DATA_422SU_YQ}\Month${MONTH}\Substitute_labquart_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", clear

/* keeps only the base households or those who are active */
keep if type_ssu==2

	
generate GHI_ISLAND_CODE = island_code
generate GHI_BLOCK_CODE = block_code
generate GHI_STRUCTURE = structure + "  (" + structure__id + ")"
generate GHI_HOUSE_DESC = house_desc
generate GHI_DWELLING = dwelling_name
generate GHI_PSU_ID = id_psu_n
generate GHI_STRATA_ID = stratum
generate GHI_SAMPLE = 1 // for this quarter 2024Q4
egen     GHI_HOUSEHOLD_ID = concat(id_psu_n   id_hh_sas), punct("_")
generate GHI_REFERENCE_PERSON = unit_contact_name
generate CONTACTS = contact_number if unit_type == 2
tostring CONTACTS, generate(GHI_CONTACTS) format(%12.0f)
drop CONTACTS
// generate WEEK_ST =  $WEEK_START 
// generate WEEK_EN =  $WEEK_END 
gen WEEK_ST = date("$WEEK_START", "YMD")
gen WEEK_EN = date("$WEEK_END", "YMD")

format WEEK_ST WEEK_EN %td
// generate DEM_NAME = pl_hhmemberlist
// generate DEM_SEX =  m1
// generate DEM_AGE =   age
generate YEAR = "$YEAR"	
generate QUARTER = "$QUARTER"	
generate MONTH = "$MONTH"	
generate MONTH_SEQ = month_seq
generate GHI_COUNTRY = "MALDIVES"
generate id_hh_panel_prefilled = 1 // for this quarter 2024Q4
generate UNIT_TYPE = unit_type




keep YEAR QUARTER MONTH MONTH_SEQ ///
GHI_ISLAND_CODE	 ///
GHI_BLOCK_CODE	 ///
GHI_STRUCTURE	 ///
GHI_HOUSE_DESC ///
GHI_DWELLING ///
GHI_PSU_ID ///
GHI_STRATA_ID ///
GHI_SAMPLE ///
GHI_HOUSEHOLD_ID ///	
GHI_REFERENCE_PERSON ///	
GHI_CONTACTS ///	
WEEK_ST	///
WEEK_EN ///	
GHI_COUNTRY ///
ward_code ///
type_ssu ///
id_psu_n ///
id_hh_sas ///
selection_year ///
rot_group_id ///
rot_group_wave ///
id_hh_panel_prefilled ///
lq_list ///
no_of_ppl ///
UNIT_TYPE ///
ind__id 
// DEM_NAME ///
// DEM_SEX ///
// DEM_AGE ///



order ///
YEAR QUARTER MONTH MONTH_SEQ ///
GHI_COUNTRY ///
GHI_ISLAND_CODE	 ///
GHI_BLOCK_CODE	 ///
GHI_STRUCTURE	 ///
GHI_HOUSE_DESC ///
GHI_DWELLING ///
GHI_PSU_ID ///
GHI_STRATA_ID ///
GHI_SAMPLE ///
GHI_HOUSEHOLD_ID ///	
GHI_REFERENCE_PERSON ///	
GHI_CONTACTS ///	
WEEK_ST	///
WEEK_EN ///	


save "${DIR_DATA_422SU_YQ}\Month${MONTH}\Substitute_labquart_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", replace






/* EXPORT AND CREATE THE ZIP FILES FOR SURVEY SOLUTION */


/* CREATE THE FILE TO PREFILL THE COVER */

/* Select one record per labour quarter */
use "${DIR_DATA_422SU_YQ}\Month${MONTH}\Sample_labquart_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", clear

sort GHI_HOUSEHOLD_ID ind__id
bys  GHI_HOUSEHOLD_ID: gen n=1 if _n == 1

keep if n==1
keep YEAR QUARTER MONTH MONTH_SEQ ///
GHI_COUNTRY ///
GHI_ISLAND_CODE	 ///
GHI_BLOCK_CODE	 ///
GHI_STRUCTURE	 ///
GHI_HOUSE_DESC ///
GHI_DWELLING ///
GHI_PSU_ID ///
GHI_STRATA_ID ///
GHI_SAMPLE ///
GHI_HOUSEHOLD_ID ///	
GHI_REFERENCE_PERSON ///	
GHI_CONTACTS ///	
WEEK_ST	///
WEEK_EN ///	
rot_group_id ///
rot_group_wave ///
ward_code ///
type_ssu ///
id_psu_n ///
id_hh_sas ///
selection_year ///
rot_group_id ///
rot_group_wave ///
id_hh_panel_prefilled ///
lq_list ///
no_of_ppl ///
UNIT_TYPE 

append using "${DIR_DATA_422SU_YQ}\Month${MONTH}\Sample_hhlds_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta"
tostring GHI_PSU_ID, replace 
merge m:1 GHI_PSU_ID using "${DIR_DATA_422SU_YQ}\Month${MONTH}\Interviewers_and_Supervisors_LFS_Maale_${YYYY_Q}_M${MONTH}.dta", keepusing(  GHI_INTERVIEWER_ID GHI_INTERVIEWER_NAME GHI_SUPERVISOR_ID GHI_SUPERVISOR_NAME) nogen

generate _quantity = 1
generate _responsible = ""
replace _responsible = GHI_INTERVIEWER_ID
generate _comment = "Prefilled assignment for LFS 2024Q4M12"


// generate _responsible = "LFS_Sup"
// replace _responsible = "I_001" if inlist(GHI_BLOCK_CODE,4019,4013,4173)
// replace _responsible = "I_002" if inlist(GHI_BLOCK_CODE,3925,4115)
// replace _responsible = "I_003" if inlist(GHI_BLOCK_CODE,3871,3942)
// replace _responsible = "I_004" if inlist(GHI_BLOCK_CODE,3831,3741)
// replace _responsible = "I_005" if inlist(GHI_BLOCK_CODE,4179,4199)


save "${DIR_DATA_422SU_YQ}\Month${MONTH}\\${NAME_SUSO}.dta", replace

drop GHI_INTERVIEWER_ID GHI_INTERVIEWER_NAME GHI_SUPERVISOR_ID GHI_SUPERVISOR_NAME

export delimited using "${DIR_DATA_422SU_YQ}\Month${MONTH}\\${NAME_SUSO}.tab", delimiter(tab) replace


**********
*************
***************


/* CREATE THE FILE TO PREFILL THE COVER */

/* Select one record per labour quarter */
use "${DIR_DATA_422SU_YQ}\Month${MONTH}\Substitute_labquart_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", clear

sort GHI_HOUSEHOLD_ID ind__id
bys  GHI_HOUSEHOLD_ID: gen n=1 if _n == 1

keep if n==1
keep YEAR QUARTER MONTH MONTH_SEQ ///
GHI_COUNTRY ///
GHI_ISLAND_CODE	 ///
GHI_BLOCK_CODE	 ///
GHI_STRUCTURE	 ///
GHI_HOUSE_DESC ///
GHI_DWELLING ///
GHI_PSU_ID ///
GHI_STRATA_ID ///
GHI_SAMPLE ///
GHI_HOUSEHOLD_ID ///	
GHI_REFERENCE_PERSON ///	
GHI_CONTACTS ///	
WEEK_ST	///
WEEK_EN ///	
rot_group_id ///
rot_group_wave ///
ward_code ///
type_ssu ///
id_psu_n ///
id_hh_sas ///
selection_year ///
id_hh_panel_prefilled ///
lq_list ///
no_of_ppl ///
UNIT_TYPE 
// rot_group_id ///
// rot_group_wave ///

append using "${DIR_DATA_422SU_YQ}\Month${MONTH}\Substitute_hhlds_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta"
drop rot_group_id rot_group_wave

merge 1:1 GHI_PSU_ID id_hh_sas using "${DIR_DATA_422SU_YQ}\Month${MONTH}\Replacement_Interviewers_and_Supervisors_LFS_Maale_${YYYY_Q}_M${MONTH}.dta", keepusing(GHI_INTERVIEWER_ID GHI_INTERVIEWER_NAME GHI_SUPERVISOR_ID GHI_SUPERVISOR_NAME rot_group_id active rot_group_wave _comment sent) nogen

generate _quantity = 1
generate _responsible = ""
replace _responsible = GHI_INTERVIEWER_ID
//generate _comment = "Replacement assignment for LFS 2024Q4M12"


keep if _responsible != "" & active == 1 & sent != 1


save "${DIR_DATA_422SU_YQ}\Month${MONTH}\\${NAME_SUSO}_substitute.dta", replace

drop GHI_INTERVIEWER_ID GHI_INTERVIEWER_NAME GHI_SUPERVISOR_ID GHI_SUPERVISOR_NAME active sent

export delimited using "${DIR_DATA_422SU_YQ}\Month${MONTH}\\${NAME_SUSO}_substitute.tab", delimiter(tab) replace



ex



/* CREATE THE FILE TO PREFILL THE UsualMembers */
use "${DIR_DATA_422SU_YQ}\Month${MONTH}\Sample_labquart_first_interview_${YYYYQ}_M${MONTH}_prefilled.dta", clear
keep GHI_HOUSEHOLD_ID lq_list

//DEM_NAME DEM_AGE DEM_SEX

save "${DIR_DATA_422SU_YQ}\Month${MONTH}\\UsualMembers.dta", replace

export delimited using "${DIR_DATA_422SU_YQ}\Month${MONTH}\\UsualMembers.tab", delimiter(tab) replace



/* ZIP THE TWO FILES FOR SURVEY SOLUTIONS */
  
cd      "${DIR_DATA_422SU_YQ}\Month${MONTH}\"

zipfile "${NAME_SUSO}.tab" "UsualMembers.tab", saving("${NAME_SUSO}.zip",replace)



/*   Check results and Identify PSUs without fieldworkers */

use "${DIR_DATA_422SU_YQ}\Month${MONTH}\\${NAME_SUSO}.dta", clear

table YEAR MONTH, miss nototals

table unit_type, miss nototals

table id_psu_n unit_type, miss

table rot_group_id rot_group_wave, miss nototals


