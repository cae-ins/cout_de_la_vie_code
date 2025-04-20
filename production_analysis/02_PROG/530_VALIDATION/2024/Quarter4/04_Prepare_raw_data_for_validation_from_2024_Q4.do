*******************************************************************************************************************
*******************************************************************************************************************                
* 
*            EDITING RULES MALDIVES 2024
* 
* 
*******************************************************************************************************************
*******************************************************************************************************************

*******************************************************************************************************************
*
*           PREPARE THE DATASET WITH THE VARIABLE THAT NEEDS TO BE VALIDATED AND
*           SUBSTITUTE THE 0 and .a WITH . FROM THE DIFFERENT SECTIONS (IN CASE IT IS NEEDED)
* 
*******************************************************************************************************************

/* to be removed once the questionnaire is finalized */

/*
generate YEAR = 2024
*/

generate year = YEAR
destring year,  replace


tab GLO_EMP 
tab DEM_AGE GLO_EMP, missing
 

sort interview__key interview__id UsualMembers__id

keep ///
SUSO_VERSION ///
YEAR QUARTER MONTH MONTH_SEQ GLO_EMP ///
rot_group_id rot_group_wave type_ssu UNIT_TYPE selection_year ///
id_hh_panel_prefilled id_hh_panel_calc ///
interview__key interview__id UsualMembers__id ///
year ///
GHI_COUNTRY ///
GHI_STRUCTURE ///
GHI_HOUSE_DESC ///
GHI_DWELLING ///
GHI_STRATA_ID ///
GHI_PSU_ID ///
GHI_SAMPLE ///
GHI_HOUSEHOLD_ID ///
ENU_1 ///
ENU_2 ///
INTERVIEW_RESULT ///
GHI_REFERENCE_PERSON ///
GHI_CONTACTS ///
WEEK_ST ///
WEEK_EN ///
type_ssu ///
id_psu_n ///
id_hh_sas ///
lq_list ///
no_of_ppl ///
UNIT_TYPE ///
DEM_HEAD_NAME ///
HHR_HEAD_CONT ///
$List_DEM ///
$List_MIG ///
$List_EDU ///
$List_ATW ///
$List_ABS ///
$List_AGF ///
$List_MJB ///
$List_SJB ///
$List_WKT ///
$List_SRH ///
$List_OPC ///
$List_OPF ///
$List_MNF ///
$List_OPA ///


/*
$List_RSP ///
$List_INC ///
*/





