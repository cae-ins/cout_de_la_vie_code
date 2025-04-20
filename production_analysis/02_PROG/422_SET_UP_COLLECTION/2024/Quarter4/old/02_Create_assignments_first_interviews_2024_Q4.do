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

use "${DIR_DATA_422SU_YQ}\Sample_hhlds_first_interview_${YYYYQ}.dta", clear

merge 1:1 id_psu_n id_hh_sas using "${DIR_DATA_412CS}\2024\SSU_sample_households_2024.dta", keepusing( ea u_type block unit_type stratum1 unit__id) //keep all the vaariable to prefill

use "${DIR_DATA_412CS}\2024\SSU_sample_households_2024.dta", replace

keep if _merge==3

drop _merge

save "${DIR_DATA_422SU}\Sample_hhlds_first_interview_final_${YYYYQ}.dta", replace


/*   Check results  */

use "${DIR_DATA_422SU}\Sample_hhlds_first_interview_final_${YYYYQ}.dta", replace



table month (rot_group_id rot_group_wave), miss nototals

table id_psu_n (rot_group_id rot_group_wave), miss nototals


table ea (rot_group_id rot_group_wave), miss nototals

table u_type (rot_group_id rot_group_wave), miss nototals

table (month u_type) (rot_group_id rot_group_wave), miss nototals

table (month ward) (rot_group_id rot_group_wave), miss nototals



