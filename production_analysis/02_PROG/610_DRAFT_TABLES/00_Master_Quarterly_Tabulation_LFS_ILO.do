/*********************************************************************************************************/
/*********************************************************************************************************/
/*********************************************************************************************************/                
/***                                                                                                   ***/
/***                 MASTER DO FILE TO CALCULATE STANDARD TABLES FOR LABOUR FORCE SURVEYS              ***/ 
/***                          ALIGNED TO 19th, 20th and 21st ICLS REsolutions                          ***/
/***                                                                                                   ***/
/***                      Antonio R. Discenza - ILO STATISTICS - discenza@ilo.org                      ***/
/***                                                                                                   ***/
/***                                                                                                   ***/
/*********************************************************************************************************/
/*********************************************************************************************************/
/*********************************************************************************************************/



*******************************************************************************************************************
*
*      CREATES TABLES IN EXCEL     
* 
*******************************************************************************************************************

clear all 
log close _all

/* TABLE 1 */
run "$DIR_PROG_610DT\Tables_quarterly_press_release\01_Create_standard_table_T1_ILO.do"

/* TABLE 2 */
run "$DIR_PROG_610DT\Tables_quarterly_press_release\02_Create_standard_table_T2_ILO.do"

/* FIGURE 1 */
run "$DIR_PROG_610DT\Tables_quarterly_press_release\03_Create_standard_Figure_F1_ILO.do"

/* TABLE V1 Variations three and 12 months */
run "$DIR_PROG_610DT\Tables_quarterly_press_release\04_Create_standard_table_V1_ILO.do"

