*******************************************************************************************************************
*******************************************************************************************************************                
* 
*            IMPUTATION / CORRECTION LFS ILO model 2024 - Antonio Discenza
* 
* 
* 
*******************************************************************************************************************

* Name of the input datasets containing raw prepared for validation and correction 
global fileinp     "$DIR_DATA_441RD_YQ\LFS_Maale_${YYYY_Q}_RAW.dta"

* Name of the output datasets containing the cleaned data  
global fileout     "$DIR_DATA_540IV_YQ\LFS_Maale_${YYYY_Q}_IMP.dta"


use "$fileinp", clear


run "$DIR_PROG_530CV\04_Substitute_missings_by_section.do"

run "$DIR_PROG_540IM_YQ\01_Impute_data_DEM_${YYYY_Q}.do"
run "$DIR_PROG_540IM_YQ\02_Impute_data_MIG_${YYYY_Q}.do"
run "$DIR_PROG_540IM_YQ\04_Impute_data_RSP_${YYYY_Q}.do"
run "$DIR_PROG_540IM_YQ\05_Impute_data_ATW_${YYYY_Q}.do" 
run "$DIR_PROG_540IM_YQ\06_Impute_data_ABS_${YYYY_Q}.do"
run "$DIR_PROG_540IM_YQ\07_Impute_data_AGF_${YYYY_Q}.do"
run "$DIR_PROG_540IM_YQ\09_Impute_data_MJB_${YYYY_Q}.do"
run "$DIR_PROG_540IM_YQ\10_Impute_data_SJB_${YYYY_Q}.do"
run "$DIR_PROG_540IM_YQ\11_Impute_data_WKT_${YYYY_Q}.do"
run "$DIR_PROG_540IM_YQ\12_Impute_data_SRH_${YYYY_Q}.do"
run "$DIR_PROG_540IM_YQ\14_Impute_data_OPC_${YYYY_Q}.do"
run "$DIR_PROG_540IM_YQ\15_Impute_data_OPF_${YYYY_Q}.do"
run "$DIR_PROG_540IM_YQ\16_Impute_data_BLD_${YYYY_Q}.do"
run "$DIR_PROG_540IM_YQ\17_Impute_data_MNF_${YYYY_Q}.do"


save "$fileout", replace

tab DEM_AGE , missing