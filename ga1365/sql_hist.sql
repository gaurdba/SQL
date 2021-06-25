col begin_time for a25
col end_time for a11
col inst for 99999
col snapid for 99999
col PARSING_SCHEMA_NAME for a20
set lines 200
set pages 2000
 select snap_id snapid,
(select substr(BEGIN_INTERVAL_TIME,1,18)||' '||substr(BEGIN_INTERVAL_TIME,24,2) from dba_hist_snapshot b where b.snap_id=a.snap_id and a.INSTANCE_NUMBER=b.INSTANCE_NUMBER) begin_time
,(select substr(end_INTERVAL_TIME,11,8)||' '||substr(end_INTERVAL_TIME,24,2) from dba_hist_snapshot b where b.snap_id=a.snap_id and a.INSTANCE_NUMBER=b.INSTANCE_NUMBER) end_time
,INSTANCE_NUMBER inst , PLAN_HASH_VALUE, EXECUTIONS_DELTA Executions, ROWS_PROCESSED_DELTA rows1,round( CPU_TIME_DELTA /1000000,0) cpu_time,round(IOWAIT_DELTA /1000000,0) io_wait, 
round( ELAPSED_TIME_DELTA /1000000,0) elapsed,PARSING_SCHEMA_NAME from dba_hist_sqlstat a where snap_id is not null and sql_id in('&SQL_ID') order by snap_id, INSTANCE_NUMBER;
