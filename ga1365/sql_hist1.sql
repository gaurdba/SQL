col plan_hash_value clear
set pages 20 lines 300 
col time for a38
col executions_total  for 999999999  head Execution|Total
col disk_reads_avg for 999999999999999 head Disk|Read|Avg
select END_INTERVAL_time time, dhsn.snap_id, plan_hash_value, executions_total, 
trunc(decode(executions_total, 0, 0, rows_processed_total/executions_total)) rows_avg,
trunc(decode(executions_total, 0, 0, disk_reads_total/executions_total)) disk_reads_avg,
trunc(decode(executions_total, 0, 0, buffer_gets_total/executions_total)) buffer_gets_avg,
trunc(decode(executions_total, 0, 0, cpu_time_total/executions_total)) cpu_time_avg,
trunc(decode(executions_total, 0, 0, elapsed_time_total/executions_total)) elapsed_time_avg,
trunc(decode(executions_total, 0, 0, iowait_total/executions_total)) iowait_time_avg,
trunc(decode(executions_total, 0, 0, clwait_total/executions_total)) clwait_time_avg
from dba_hist_sqlstat dhsq, dba_hist_snapshot dhsn
where sql_id = '&sql_id' and dhsq.snap_id=dhsn.snap_id
order by sql_id, snap_id; 
