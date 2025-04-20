********************************************************************************
*********Take eligible households for reinterviews 2025Q1 from 2024Q4***********
********************************************************************************


global    fileinterm    "$DIR_DATA_530CV_YQ\LFS_${YYYY_Q}_CHK_step_0.dta"
display "$fileinterm"

use "$fileinterm", clear

keep rot_group_id rot_group_wave interview__key GHI_PSU_ID MONTH_SEQ GHI_HOUSEHOLD_ID

* interview completed after it was replaced, and kept to meet the hh count
replace rot_group_id = "2023Q3" if interview__key == "23-81-24-40" //PSU 115
replace rot_group_wave = 4 if interview__key == "23-81-24-40" //PSU 115

* Sort the dataset by PSU, month seq and rotation group
sort GHI_PSU_ID MONTH_SEQ rot_group_wave GHI_HOUSEHOLD_ID

bys GHI_HOUSEHOLD_ID: gen n = 1 if _n == 1

keep if n == 1
drop n

* Create a new variable to count households by PSU, month seq and rotation group
bysort GHI_PSU_ID MONTH_SEQ rot_group_wave: gen household_count = _N

* Keep only the first two households for each PSU, month seq and rotation group
bysort GHI_PSU_ID MONTH_SEQ rot_group_wave (GHI_HOUSEHOLD_ID): keep if _n <= 2

display "$YEAR"
display "$QUARTER"
display $m1

//keep if YEAR == "$YEAR" & QUARTER == "$QUARTER" & MONTH == "$m1"

tab GHI_PSU_ID rot_group_wave


save "$DIR_DATA_442DR_YQ\LFS_${YEAR}_Q${QUARTER}_RAW_for_REINT.dta", replace

merge 1:m GHI_HOUSEHOLD_ID using "$fileinterm", nogen

gen year_microdata = YEAR
gen quarter_microdata = QUARTER
gen month_microdata = MONTH

sort YEAR QUARTER MONTH GHI_PSU_ID GHI_HOUSEHOLD_ID PPNO

save "$DIR_DATA_442DR_YQ\LFS_${YEAR}_Q${QUARTER}_RAW_for_REINT.dta", replace

