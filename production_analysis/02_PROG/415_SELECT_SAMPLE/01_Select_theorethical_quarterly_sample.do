/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****                                                                                                                   *****/
/*****                         SUB-PROCESS 4.1.0:    SELECT THEORETHICAL QUARTERLY SAMPLE                                *****/
/*****                                                                                                                   *****/
/*****    Select the household that are part of the sample for the currect quarter based on the selected sample          *****/
/*****                                                                                                                   *****/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/



use "${DIR_DATA_412CS}\2024\alloc_hh_maale.dta", clear

save "${DIR_DATA_415SS_YQ}\Sample_Theo_${YYYYQ}.dta", replace

/* select the base households to verify the sample size and the substitute of those groups of rotation */
keep if inlist(rot_group_id,"$YYYYQ","$YYYYQm1","$YYYYQm4","$YYYYQm5") | ///
        ( inlist(selection_year,$YEAR,$YEARminus1,$YEARminus4,$YEARminus5) & rot_group_id=="")


generate rot_group_wave=0
replace  rot_group_wave=1 if rot_group_id=="$YYYYQ"
replace  rot_group_wave=2 if rot_group_id=="$YYYYQm1"
replace  rot_group_wave=3 if rot_group_id=="$YYYYQm4"
replace  rot_group_wave=4 if rot_group_id=="$YYYYQm5"

generate year=${YEAR}
generate quarter=${QUARTER}

generate month= 0
replace  month= 0
replace  month= 1 if month_seq==1 & quarter==1
replace  month= 2 if month_seq==2 & quarter==1
replace  month= 3 if month_seq==3 & quarter==1
replace  month= 4 if month_seq==1 & quarter==2
replace  month= 5 if month_seq==2 & quarter==2
replace  month= 6 if month_seq==3 & quarter==2
replace  month= 7 if month_seq==1 & quarter==3
replace  month= 8 if month_seq==2 & quarter==3
replace  month= 9 if month_seq==3 & quarter==3
replace  month=10 if month_seq==1 & quarter==4
replace  month=11 if month_seq==2 & quarter==4
replace  month=12 if month_seq==3 & quarter==4


/******************   Check results  *********************/

tab year quarter if type_ssu==1, miss

/* You must have something like this.  Total "base" households is always 528

           |    quarter
      year |         4 |     Total
-----------+-----------+----------
      2025 |       528 |       528 
-----------+-----------+----------
     Total |       528 |       528 

*/


tab rot_group_id type_ssu if type_ssu==1, miss

/* You must have something like this. 
   - The total "base" households per group of rotation is 132, and the total is always 528
   - Substitute households can be a variable number 64 and do not have a group of rotation assigned

           |  Base or substitute
  ROTGROUP | 1 – Base   2 – Subst |     Total
-----------+----------------------+----------
           |         0        660 |       660 
    2023Q4 |       132          0 |       132 
    2024Q1 |       132          0 |       132 
    2024Q4 |       132          0 |       132 
    2025Q1 |       132          0 |       132 
-----------+----------------------+----------
     Total |       528        660 |     1,188 


*/


tab selection_year type_ssu if type_ssu==2, miss

/* You must have something like this. 

           |  Base or
selection_ | substitute
      year | 2 – Subst |     Total
-----------+-----------+----------
      2023 |       132 |       132 
      2024 |       264 |       264 
      2025 |       264 |       264 
-----------+-----------+----------
     Total |       660 |       660 
*/


tab month month_seq if type_ssu==1, miss

/* You must have something like this.
   - 176 base households per month, the total is 528

           |            month_seq
     month |         1          2          3 |     Total
-----------+---------------------------------+----------
        10 |       176          0          0 |       176 
        11 |         0        176          0 |       176 
        12 |         0          0        176 |       176 
-----------+---------------------------------+----------
     Total |       176        176        176 |       528 
*/

tab month month_seq if type_ssu==2, miss


/* You must have something like this.
   - 132 substitute households per month, the total is 396 or 
   

           |            month_seq
     month |         1          2          3 |     Total
-----------+---------------------------------+----------
        10 |       132          0          0 |       132 
        11 |         0        132          0 |       132 
        12 |         0          0        132 |       132 
-----------+---------------------------------+----------
     Total |       132        132        132 |       396 


*/



tab id_psu_n rot_group_wave if type_ssu==1, miss

/* you should have something like this. Each cell has the value 2, the total by row is always 8,
the total by column is 132 (528 / 4) and the general total is 528

           |               rot_group_wave
  id_psu_n |         1          2          3          4 |     Total
-----------+--------------------------------------------+----------
        22 |         2          2          2          2 |         8 
        36 |         2          2          2          2 |         8 
        52 |         2          2          2          2 |         8 
        80 |         2          2          2          2 |         8 
        98 |         2          2          2          2 |         8 
...
...
...
       668 |         2          2          2          2 |         8 
       670 |         2          2          2          2 |         8 
      1688 |         2          2          2          2 |         8 
      1690 |         2          2          2          2 |         8 
      1705 |         2          2          2          2 |         8 
-----------+--------------------------------------------+----------
     Total |       132        132        132        132 |       528 

*/


tab id_psu_n rot_group_wave if type_ssu==2, miss


drop selection_num

order year quarter month month_seq ward_code id_psu_n type_ssu rot_group_wave id_hh_sas   selection_year rot_group_id  

sort year quarter month month_seq ward_code id_psu_n type_ssu rot_group_wave id_hh_sas   selection_year rot_group_id 

egen     GHI_HOUSEHOLD_ID = concat(id_psu_n   id_hh_sas), punct("_")

save "${DIR_DATA_415SS_YQ}\Sample_Theo_${YYYYQ}.dta", replace





use "${DIR_DATA_415SS_YQ}\Sample_Theo_${YYYYQ}.dta", clear

collapse (count) year if  type_ssu==1, by (ward id_psu_n month_seq) 
table (ward  id_psu_n) month_seq


use "${DIR_DATA_415SS_YQ}\Sample_Theo_${YYYYQ}.dta", clear
collapse (count) year, by (id_psu_n) 
collapse (count) year
list year

/* You must have something like this.
   - Up to Q4 2025 the numebr of PSU is always 66
   - From Q1 2026 you will have more PSUs because some of them are rotated 
     hence in each quarter you will have both the old and the new

    +----------+
     | id_psu_n |
     |----------|
  1. |       66 |
     +----------+
*/



/*********************************************************************************************************/
/*********************************************************************************************************/
/* attach outcomes from previous quarters */ 
/*********************************************************************************************************/
/*********************************************************************************************************/


use "$DIR_DATA_441RD\$YEARminus1\Quarter$QUARTERminus1\LFS_${YYYY_Qm1}_OUTCOMES.dta", clear


generate year_pi = YEAR
generate quarter_pi = QUARTER
generate rot_group_id_pi = rot_group_id
generate rot_group_wave_pi = rot_group_wave
generate type_ssu_pi = type_ssu
drop YEAR QUARTER rot_group_id rot_group_wave type_ssu interview__key

save "${DIR_DATA_415SS_YQ}\Outcomes_previous_quarters_${YYYYQ}.dta", replace

tab rot_group_id_pi rot_group_wave_pi if inlist(INTERVIEW_RESULT,1,2,3), missing

use "${DIR_DATA_415SS_YQ}\Sample_Theo_${YYYYQ}.dta", clear
merge m:1 GHI_HOUSEHOLD_ID using "${DIR_DATA_415SS_YQ}\Outcomes_previous_quarters_${YYYYQ}.dta"

replace rot_group_id = rot_group_id_pi if rot_group_id=="" & rot_group_id_pi!=""
replace rot_group_wave = 2 if inlist(rot_group_wave,.,0) & rot_group_id=="$YYYYQm1"
replace rot_group_wave = 4 if inlist(rot_group_wave,.,0) & rot_group_id=="$YYYYQm5"

keep if inlist(_merge,1,3)
*keep if inlist(rot_group_id,"$YYYYQ","$YYYYQm1","$YYYYQm4","$YYYYQm5")

tab INTERVIEW_RESULT, miss
tab INTERVIEW_RESULT, miss nolabel

generate ELIGIBILITY=.
replace  ELIGIBILITY=1 if  inlist(rot_group_id,"$YYYYQ","$YYYYQm4")
replace  ELIGIBILITY=1 if  inlist(rot_group_id,"$YYYYQm1","$YYYYQm5") & inlist(INTERVIEW_RESULT,1,2,3)
replace  ELIGIBILITY=2 if  inlist(rot_group_id,"$YYYYQm1","$YYYYQm5") & inlist(INTERVIEW_RESULT,4,5,6,7,8,9,10)

replace  ELIGIBILITY=1 if  inlist(rot_group_id,"") & inlist(INTERVIEW_RESULT,1,2,3,.)
replace  ELIGIBILITY=2 if  inlist(rot_group_id,"") & inlist(INTERVIEW_RESULT,4,5,6,7,8,9,10)

save "${DIR_DATA_415SS_YQ}\Sample_Theo_${YYYYQ}.dta", replace


* expoort in excel
use "${DIR_DATA_415SS_YQ}\Sample_Theo_${YYYYQ}.dta", clear

export excel using "${DIR_DATA_415SS_YQ}\Sample_Theo_${YYYYQ}.xlsx", firstrow(variables) replace

tab rot_group_id ELIGIBILITY, missing

tab rot_group_id rot_group_wave if ELIGIBILITY==1, missing

tab id_psu_n, missing
tab id_hh_sas, missing

collapse (count) year, by (rot_group_id type_ssu ELIGIBILITY ) 






/* Identifiy first interviews, reinterviews and substitutes */

/*FIRST INTERVIEW */
use "${DIR_DATA_415SS_YQ}\Sample_Theo_${YYYYQ}.dta", clear
keep if inlist(rot_group_id,"$YYYYQ","$YYYYQm4") &  ELIGIBILITY==1
tab rot_group_id type_ssu, missing
tab month_seq type_ssu, missing


/*REINTERVIEW */
use "${DIR_DATA_415SS_YQ}\Sample_Theo_${YYYYQ}.dta", clear
keep if inlist(rot_group_id,"$YYYYQm1","$YYYYQm5") &  ELIGIBILITY==1
tab rot_group_id type_ssu, missing
tab month_seq type_ssu, missing

use "${DIR_DATA_415SS_YQ}\Sample_Theo_${YYYYQ}.dta", clear
keep if inlist(rot_group_id,"") & type_ssu==2 &  ELIGIBILITY==1
tab id_psu_n type_ssu, missing
tab month_seq type_ssu, missing



