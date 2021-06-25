SET LINESIZE 120
SET PAGESIZE 1000
COL executions FOR 999,999,999
COL elapsed_time FOR 999,999,999,999
COL avg_ms FOR 999999.99
COL min_ms FOR 999999.99
COL max_ms FOR 999999.99
SELECT
TO_CHAR(TRUNC(snapshot.begin_interval_time + 1/8,'HH24'),'DD-MON-YYYY HH24:MI:SS') || ' EDT' SNAP_BEGIN,
sqlstat.instance_number,
SUM(sqlstat.executions_delta) executions,
MIN(sqlstat.elapsed_time_delta / sqlstat.executions_delta / 1000) min_ms,
MAX(sqlstat.elapsed_time_delta / sqlstat.executions_delta / 1000) max_ms,
SUM(sqlstat.elapsed_time_delta) / SUM(sqlstat.executions_delta) / 1000 avg_Ms
FROM
dba_hist_sqlstat sqlstat,
dba_hist_snapshot snapshot
WHERE
sqlstat.dbid = snapshot.dbid
AND sqlstat.instance_number = snapshot.instance_number
AND sqlstat.snap_id = snapshot.snap_id
AND sqlstat.sql_id = '&1'
AND snapshot.begin_interval_time >= TO_DATE('27-JUL-2009 21:00:00','DD-MON-YYYY HH24:MI:SS')
GROUP
BY TO_CHAR(TRUNC(snapshot.begin_interval_time + 1/8,'HH24'),'DD-MON-YYYY HH24:MI:SS') || ' EDT',
sqlstat.instance_number
ORDER
BY snap_begin
/
