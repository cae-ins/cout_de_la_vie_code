
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****                                                                                                                   *****/
/*****     MACRO VARIABLES TO IDENTIFY PROVIOUS QUARTERS BASED ON CURRENT QUARTER (see rotation scheme)                  *****/
/*****                                                                                                                   *****/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/


if $QUARTER==1 {
global YEARminus1 = $YEAR-1
global QUARTERminus1 = 4
global YEARminus2 = $YEAR-1
global QUARTERminus2 = 3
global YEARminus3 = $YEAR-1
global QUARTERminus3 = 2
global YEARminus4 = $YEAR-1
global QUARTERminus4 = 1
global YEARminus5 = $YEAR-2
global QUARTERminus5 = 4

global m1 1
global m2 2
global m3 3
}

if $QUARTER==2 {
global YEARminus1 = $YEAR
global QUARTERminus1 = 1
global YEARminus2 = $YEAR-1
global QUARTERminus2 = 4
global YEARminus3 = $YEAR-1
global QUARTERminus3 = 3
global YEARminus4 = $YEAR-1
global QUARTERminus4 = 2
global YEARminus5 = $YEAR-1
global QUARTERminus5 = 1

global m1 4
global m2 5
global m3 6
}

if $QUARTER==3 {
global YEARminus1 = $YEAR
global QUARTERminus1 = 2
global YEARminus2 = $YEAR
global QUARTERminus2 = 1
global YEARminus3 = $YEAR-1
global QUARTERminus3 = 4
global YEARminus4 = $YEAR-1
global QUARTERminus4 = 3
global YEARminus5 = $YEAR-1
global QUARTERminus5 = 2

global m1 7
global m2 8
global m3 9
}

if $QUARTER==4 {
global YEARminus1 = $YEAR
global QUARTERminus1 = 3
global YEARminus2 = $YEAR
global QUARTERminus2 = 2
global YEARminus3 = $YEAR
global QUARTERminus3 = 1
global YEARminus4 = $YEAR-1
global QUARTERminus4 = 4
global YEARminus5 = $YEAR-1
global QUARTERminus5 = 3

global m1 10
global m2 11
global m3 12
}

global   YYYY_Q  "${YEAR}_Q${QUARTER}"
display "$YYYY_Q"  

global   YYYYQ  "${YEAR}Q${QUARTER}"
display "$YYYYQ"  

global   YYYY_Qm1  "${YEARminus1}_Q${QUARTERminus1}"
display "$YYYY_Qm1" 

global   YYYYQm1  "${YEARminus1}Q${QUARTERminus1}"
display "$YYYYQm1"  

global   YYYYQm2  "${YEARminus2}Q${QUARTERminus2}"
display "$YYYYQm2"

global   YYYYQm3  "${YEARminus3}Q${QUARTERminus3}"
display "$YYYYQm3"

global   YYYY_Qm4  "${YEARminus4}_Q${QUARTERminus4}"
display "$YYYY_Qm4"

global   YYYYQm4  "${YEARminus4}Q${QUARTERminus4}"
display "$YYYYQm4"

global   YYYYQm5  "${YEARminus5}Q${QUARTERminus5}"
display "$YYYYQm5"

display "MESSAGE: Currect quarter is" "$YYYYQ"
display "MESSAGE: Quarter Q-1 is    " "$YYYYQm1" 
display "MESSAGE: Quarter Q-2 is    " "$YYYYQm2"
display "MESSAGE: Quarter Q-3 is    " "$YYYYQm3"
display "MESSAGE: Quarter Q-4 is    " "$YYYYQm4"
display "MESSAGE: Quarter Q-5 is    " "$YYYYQm5"



/*****************************************************************************************************************************/
/*****************************************************************************************************************************/
/*****                                                                                                                   *****/
/*****     MACRO VARIABLES TO IDENTIFY PATHS FOR THE CURRENT QUARTER                                                     *****/
/*****                                                                                                                   *****/
/*****************************************************************************************************************************/
/*****************************************************************************************************************************/


/* Assign the path of the main working directory (change using your own path) */

global    LFS_PATH 	"W:\LFS_GSBPM"
display "$LFS_PATH"


/* STEP 411 - CREATE FRAME */

global    DIR_DATA_411CF  "${LFS_PATH}\DATA\411_CREATE_FRAME\"
display "$DIR_DATA_411CF"

global    DIR_PROG_411CF  "${LFS_PATH}\PROG\411_CREATE_FRAME\"
display "$DIR_PROG_411CF"

/* STEP 412 - CREATE SAMPLE */

global    DIR_DATA_412CS  "${LFS_PATH}\DATA\412_CREATE_SAMPLE\"
display "$DIR_DATA_412CS"

global    DIR_PROG_412CS  "${LFS_PATH}\PROG\412_CREATE_SAMPLE\"
display "$DIR_PROG_412CS"


/* STEP 415 - SELECT QUARTERLY SAMPLE */

global    DIR_DATA_415SS  "${LFS_PATH}\DATA\415_SELECT_SAMPLE\\"
display "$DIR_DATA_415SS"

global    DIR_DATA_415SS_YQ  "${LFS_PATH}\DATA\415_SELECT_SAMPLE\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_DATA_415SS_YQ"

global    DIR_PROG_415SS  "${LFS_PATH}\PROG\415_SELECT_SAMPLE\"
display "$DIR_PROG_415SS"


/* STEP 422 - SET UP COLLECTION */

global    DIR_DATA_422SU_YQ  "${LFS_PATH}\DATA\422_SET_UP_COLLECTION\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_DATA_422SU_YQ"

global    DIR_PROG_422SU_YQ  "${LFS_PATH}\PROG\422_SET_UP_COLLECTION\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_PROG_422SU_YQ"

*added by shafeeu
global    DIR_DATA_422SU_test  "${LFS_PATH}\DATA\422_SET_UP_COLLECTION\testing\"
display "$DIR_DATA_422SU_test"


/* STEP 432 - RECEIVED DATA */

global    DIR_DATA_432RD_YQ  "${LFS_PATH}\DATA\432_RECEIVED_DATA\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_DATA_432RD_YQ"


/* STEP 433 - FIELDWORK MONITORING */

global    DIR_DATA_433FM_YQ  "${LFS_PATH}\DATA\433_FIELDWORK_MONITORING\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_DATA_433FM_YQ"

global    DIR_PROG_433FM_YQ  "${LFS_PATH}\PROG\433_FIELDWORK_MONITORING\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_PROG_433FM_YQ"


/* STEP 441 - RAW DATA */

global    DIR_DATA_441RD  "${LFS_PATH}\DATA\441_RAW_DATA\"
display "$DIR_DATA_441RD"

global    DIR_DATA_441RD_YQ  "${LFS_PATH}\DATA\441_RAW_DATA\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_DATA_441RD_YQ"

global    DIR_PROG_441RD_YQ  "${LFS_PATH}\PROG\441_RAW_DATA\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_PROG_441RD_YQ"

/* STEP 442 - RAW DATA FOR REINTERVIEW */

global    DIR_DATA_442DR_YQ  "${LFS_PATH}\DATA\442_RAW_DATA_FOR_REINTERVIEW\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_DATA_442DR_YQ"

global    DIR_PROG_442DR_YQ  "${LFS_PATH}\PROG\442_RAW_DATA_FOR_REINTERVIEW\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_PROG_442DR_YQ"

/* STEP 530 - VALIDATION / CHECK */


global    DIR_DATA_530CV      "${LFS_PATH}\DATA\530_VALIDATION\"
display "$DIR_DATA_530CV"

global    DIR_DATA_530CV_YQ  "${LFS_PATH}\DATA\530_VALIDATION\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_DATA_530CV_YQ"

global    DIR_PROG_530CV     "${LFS_PATH}\PROG\530_VALIDATION\"
display "$DIR_PROG_530CV"

global    DIR_PROG_530CV_YQ  "${LFS_PATH}\PROG\530_VALIDATION\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_PROG_530CV_YQ"



/* STEP 540 - IMPUTATION */

global    DIR_DATA_540IM_YQ  "${LFS_PATH}\DATA\540_IMPUTATION\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_DATA_540IM_YQ"

global    DIR_PROG_540IM_YQ  "${LFS_PATH}\PROG\540_IMPUTATION\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_PROG_540IM_YQ"


/* STEP 550 - DERIVED VARIABLES */

global    DIR_DATA_550DV_YQ  "${LFS_PATH}\DATA\550_DERIVED_VARIABLES\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_DATA_550DV_YQ"

global    DIR_PROG_550DV_YQ  "${LFS_PATH}\PROG\550_DERIVED_VARIABLES\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_PROG_550DV_YQ"



/* STEP 560 - POPULATION FIGURES */

global    DIR_PROG_560PF  "${LFS_PATH}\PROG\560_POPULATION_FIGURES\"
display "$DIR_PROG_560PF"

global    DIR_DATA_560PF_YQ  "${LFS_PATH}\DATA\560_POPULATION_FIGURES\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_DATA_560PF_YQ"

global    DIR_PROG_560PF_YQ  "${LFS_PATH}\PROG\560_POPULATION_FIGURES\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_PROG_560PF_YQ"


/* STEP 562 - QUARTERLY WEIGHTING */

global    DIR_DATA_562QW_YQ  "${LFS_PATH}\DATA\562_QUARTERLY_WEIGHTING\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_DATA_562QW_YQ"

global    DIR_PROG_562QW_YQ  "${LFS_PATH}\PROG\562_QUARTERLY_WEIGHTING\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_PROG_562QW_YQ"


global    DIR_PROG_562QW  "${LFS_PATH}\PROG\562_QUARTERLY_WEIGHTING\"
display "$DIR_PROG_562QW"

/* STEP 580 - FINAL DATA */

global    DIR_DATA_580FD_YQ "${LFS_PATH}\DATA\580_FINAL_DATA\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_DATA_580FD_YQ"

global    DIR_PROG_580FD_YQ  "${LFS_PATH}\PROG\580_FINAL_DATA\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_PROG_580FD_YQ"


/* STEP 610 - DRAFT TABLES */

global    DIR_DATA_610DT  "${LFS_PATH}\DATA\610_DRAFT_TABLES\"
display "$DIR_DATA_610DT"

global    DIR_DATA_610DT_YQ  "${LFS_PATH}\DATA\610_DRAFT_TABLES\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_DATA_610DT_YQ"

global    DIR_PROG_610DT  "${LFS_PATH}\PROG\610_DRAFT_TABLES\"
display "$DIR_PROG_610DT"


global    DIR_PROG_610DT_YQ  "${LFS_PATH}\PROG\610_DRAFT_TABLES\\${YEAR}\Quarter${QUARTER}\"
display "$DIR_PROG_610DT_YQ"