@@header

/*
*
*  Purpose       : Display Session's events from ASH
*  Compatibility : 10.1 and above
*  Parameters    : 1 - SID
*                  2 - INST_ID         (optional, default to 1)
*                  3 - Serial#         (Default %)
*                  4 - Number of hours (Default 24)
*                  5 - WhereClause     
*                  
*
*
*/


/************************************
*  INPUT PARAMETERS
************************************/
UNDEFINE SID
UNDEFINE INST_ID
UNDEFINE SERIAL
UNDEFINE HOURS
UNDEFINE SQL_ID
UNDEFINE WHERECLAUSE

DEFINE SID="&&1"
DEFINE INST_ID="&&2"
DEFINE SERIAL="&&3"
DEFINE HOURS="&&4"
DEFINE WHERECLAUSE="&&5"

COLUMN  _SID          NEW_VALUE  SID         NOPRINT
COLUMN  _INST_ID      NEW_VALUE  INST_ID     NOPRINT
COLUMN  _SERIAL       NEW_VALUE  SERIAL      NOPRINT
COLUMN  _HOURS        NEW_VALUE  HOURS       NOPRINT

set term off
SELECT DECODE(UPPER('&&SID'),'','%',UPPER('&&SID'))         "_SID"
     , DECODE(UPPER('&&INST_ID'),'','1',UPPER('&&INST_ID')) "_INST_ID"
     , DECODE(UPPER('&&SERIAL'),'','%',UPPER('&&SERIAL'))   "_SERIAL"
     , DECODE(UPPER('&&HOURS'),'','24',UPPER('&&HOURS'))    "_HOURS"
FROM DUAL;
set term on
/***********************************/


PROMPT ***************************************************
PROMPT * AWR ASH Session Events 
PROMPT *
PROMPT * Input Parameter:
PROMPT *   SID             = "&&SID"
PROMPT *   Instance ID     = "&&INST_ID"
PROMPT *   Serial#         = "&&SERIAL"
PROMPT *   Number of Hours = "&&HOURS"
PROMPT *   Where Clause    = "&&WHERECLAUSE"
PROMPT ***************************************************

COLUMN session_id                 HEADING "SID"              FORMAT 99999
COLUMN inst_id                    HEADING "I#"               FORMAT 99
COLUMN "session_serial#"          HEADING "Serial#"          FORMAT 999999
COLUMN FORCE_MATCHING_SIGNATURE                              FORMAT 99999999999999999999999
COLUMN sql_plan_hash_value        HEADING "Plan|Hash|Value"  FORMAT 9999999999 
COLUMN sql_exec_start                                        FORMAT a20
COLUMN sql_exec_end                                          FORMAT a20
COLUMN duration                                              FORMAT a15
COLUMN sql_opname                 HEADING "SQL|Operation"    FORMAT a15 TRUNCATE
COLUMN sql_child_number           HEADING "SQL|Ch#"          FORMAT 999
COLUMN current_dop                HEADING "DOP"              FORMAT 999
COLUMN event                      HEADING "Event"            FORMAT a40 TRUNCATE
COLUMN event_count                HEADING "EventCount"       FORMAT 99999999999

BREAK ON session_id ON  inst_id ON  session_serial# ON sql_exec_start ON sql_opname ON sql_id ON sql_child_number ON sql_plan_hash_value 

-- Get the session events from ASH
SELECT /*+ parallel(ash, 10) */ 
                       --ash.sql_exec_id,
                            NVL(ash.qc_session_id,ash.session_id)                                        session_id 
                          , NVL(ash.qc_instance_id,ash.instance_number)                                          inst_id     
                          , NVL(ash.qc_session_serial#,ash.session_serial#)                              session_serial#
                          , TO_CHAR(NVL(ash.sql_exec_start,MIN(ash.sample_time)),'DD-MON-YY HH24:MI:SS') sql_exec_start
                          , ash.sql_opname
                          , ash.sql_id
                          , ash.sql_child_number
                          , ash.sql_plan_hash_value
                          , count(1)                                                                     event_count
                          , ash.event
                         FROM dba_hist_active_sess_history ash
                        WHERE ash.sql_id                                       IS NOT NULL
                          AND NVL(ash.qc_instance_id,ash.instance_number)      LIKE '&&INST_ID'  
                          AND NVL(ash.qc_session_id,ash.session_id)            LIKE '&&SID' 
                          AND NVL(ash.qc_session_serial#,ash.session_serial#)  LIKE '&&SERIAL'
                          AND ash.sample_time                                  > sysdate - (&&HOURS/24)
                          AND ash.sql_exec_id IS NOT NULL
                          &&WHERECLAUSE
                     GROUP BY NVL(ash.qc_session_id,ash.session_id)
                            , NVL(ash.qc_instance_id,ash.instance_number)   
                            , NVL(ash.qc_session_serial#,ash.session_serial#)
                            , ash.sql_exec_id
                            , ash.sql_exec_start
                            , ash.sql_opname
                            , ash.sql_id
                            , ash.sql_child_number
                            , ash.sql_plan_hash_value
                            , ash.force_matching_signature
                            , ash.event
                     ORDER BY --max(ash.sample_time) asc
                            --, 
                            NVL(ash.sql_exec_start,MIN(ash.sample_time)) ASC   
                          , ash.sql_id
                          , count(1) desc
;


@@footer
