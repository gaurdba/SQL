COL session_id FOR 999999999 HEAD sid

COL session_serial# FOR 999999999 HEAD session|SERIAL#
col inst_id for 9999 HEAD INST|ID
col username for a30
col SQL_OPNAME for a15
col plan_hash for 99999999999999 head PLAN|HASH
col Start_TIME for a25
col END_TIME for a25
col duration for a20
set lines 300 pages 300
COL Physical_Read for 99999999999 HEAD Physical|READ|Gb
COL Physical_WRITE for 99999999999 HEAD Physical|WRITE|Gb
SET VERIFY OFF
VARIABLE SID VARCHAR2(10);
VARIABLE INST_ID VARCHAR2(10);
VARIABLE SERIAL VARCHAR2(10);
VARIABLE SQL_ID VARCHAR2(20);
VARIABLE HRS NUMBER;

UNDEFINE SID
UNDEFINE INST_ID
UNDEFINE SERIAL#
UNDEFINE HOURS
UNDEFINE SQL_ID
UNDEFINE HRS

DEFINE HRS=24
DEFINE SID=&1
DEFINE INST_ID="&2"
DEFINE SERIAL="&3"
DEFINE SQL_ID="&4"
DEFINE HRS=&5

PROMPT ***************************************************
PROMPT * AWR - ASH SQL Ids 
PROMPT *
PROMPT * Input Parameter:
PROMPT *   SID             = "&&SID"
PROMPT *   Instance ID     = "&&INST_ID"
PROMPT *   Serial#         = "&&SERIAL"
PROMPT *   Number of Hours = "&&HRS" Default 24Hrs
PROMPT *   SQL Id          = "&&SQL_ID"
PROMPT ***************************************************
WITH query_runs AS (
    SELECT
        nvl(ash.qc_session_id, ash.session_id) session_id,
        nvl(ash.qc_instance_id, ash.inst_id) inst_id,
        nvl(ash.qc_session_serial#, ash.session_serial#) session_serial#,
        u.username,
        ash.sql_opname,
        ash.sql_id,
        ash.sql_plan_hash_value   AS plan_hash,
        trunc(px_flags / 2097152) dop,
        CAST(MIN(ash.sample_time) AS DATE) AS start_time,
        CAST(MAX(ash.sample_time) AS DATE) AS end_time,
        round(SUM(ash.delta_read_io_bytes / 1024 / 1024 / 1024), 0) physical_read,
        round(SUM(ash.delta_write_io_bytes / 1024 / 1024 / 1024), 0) physical_write,
        round(MAX(ash.temp_space_allocated / 1024 / 1024 / 1024), 2) temp
    FROM
        gv$active_session_history ash,
        dba_users u
    WHERE
        u.user_id = ash.user_id
        AND nvl(ash.qc_session_id, ash.session_id) LIKE '&&SID'
        AND nvl(ash.qc_session_serial#, ash.session_serial#) LIKE '&&SERIAL'
        AND nvl(ash.qc_instance_id, ash.inst_id) LIKE '&&INST_ID'
        AND ash.sql_id LIKE '&&SQL_ID'
        AND ash.sample_time >= ( SYSDATE - &&HRS/24 )
    GROUP BY
        nvl(ash.qc_session_id, ash.session_id),
        nvl(ash.qc_instance_id, ash.inst_id),
        nvl(ash.qc_session_serial#, ash.session_serial#),
        u.username,
        ash.sql_opname,
        ash.sql_id,
        ash.sql_plan_hash_value,
        trunc(px_flags / 2097152)
)
--SELECT query_runs.*,
--to_char(to_date(ROUND ( (end_time - start_time) * 24*60*60, 0),'sssss'),'hh24:mi:ss') AS duration
SELECT
    session_id,
    inst_id,
    session_serial#,
    username,
    TO_CHAR(start_time, 'DD-Mon-YYYY HH24:MI:SS') start_time,
    TO_CHAR(end_time, 'DD-MON-YYYY HH24:MI:SS') end_time,
    TO_CHAR(TO_DATE(round((end_time - start_time) * 24 * 60 * 60, 0), 'sssss'), 'hh24:mi:ss') AS duration,
    SQL_OPNAME,
    sql_id,
    plan_hash,
    dop,
    physical_read,
    physical_write,
    temp
FROM
    query_runs
ORDER BY
    start_time;
    
DEFINE 1=""
DEFINE 2=""
DEFINE 3=""
DEFINE 4=""
DEFINE 5=""

