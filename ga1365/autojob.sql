col client_name for a35
col OPTIMIZER_STATS for a15
col SEGMENT_ADVISOR for a15
col SQL_TUNE_ADVISOR for a15
set lines 300
col WINDOW_NAME for a20
col START_TIME for a25
col  DURATION for a25
col JOB_NAME for a30
col  JOB_STATUS for a15
col END_time for a25
col  JOB_DURATION for a15
set verify off
col JOB_INFO for a70
SELECT client_name, status FROM dba_autotask_operation order by client_name;
select WINDOW_NAME,OPTIMIZER_STATS,SEGMENT_ADVISOR,SQL_TUNE_ADVISOR from DBA_AUTOTASK_WINDOW_CLIENTS;
--SELECT * FROM dba_autotask_schedule;
select CLIENT_NAME,JOB_STATUS,to_char(JOB_START_TIME,'DD-Mon-YYYY HH24:MI:SS') START_TIME,to_char(JOB_START_TIME+job_duration,'DD-Mon-YYYY HH24:MI:SS') End_Time,JOB_DURATION,nvl2(JOB_INFO,JOB_INFO,'SUCCEEDED') Job_info from DBA_AUTOTASK_JOB_HISTORY where CLIENT_NAME like nvl('%&client_name%',CLIENT_NAME) order by CLIENT_NAME,JOB_START_TIME desc;
set lines 160
