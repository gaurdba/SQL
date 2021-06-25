set pages 20 lines 300 
col time for a25
col  for 999999999  head Execution|Total
col disk_reads_avg for 999999999999999 head Disk|Read|Avg
select END_INTERVAL_time time, executions_total, 
trunc(decode(executions_total, 0, 0, rows_processed_total/executions_total)) rows_avg
from dba_hist_sqlstat dhsq, dba_hist_snapshot dhsn
where sql_id = '&sql_id' and dhsq.snap_id=dhsn.snap_id
order by sql_id, dhsq.snap_id; 
