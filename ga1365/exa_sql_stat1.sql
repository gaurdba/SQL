set pages 1000 lines 300
col BEGIN_INTERVAL_TIME for a30
col sql_profile for a32
col Offloadable for a13
select BEGIN_INTERVAL_TIME, hq.snap_id, plan_hash_value, executions_total,
trunc(decode(executions_total, 0, 0, rows_processed_total/executions_total)) rows_avg,
trunc(decode(executions_total, 0, 0, fetches_total/executions_total)) fetches_avg,
trunc(decode(executions_total, 0, 0, disk_reads_total/executions_total)) disk_reads_avg,
trunc(decode(executions_total, 0, 0, buffer_gets_total/executions_total)) buffer_gets_avg,
trunc(decode(executions_total, 0, 0, cpu_time_total/executions_total)) cpu_time_avg,
trunc((decode(executions_total, 0, 0, elapsed_time_total/executions_total))/1000000) elapsed_time_avg,
decode(IO_OFFLOAD_ELIG_BYTES_DELTA,0,'No','Yes') Offloadable
from dba_hist_sqlstat hq,dba_hist_snapshot sp
where sql_id = '&sql_id' and sp.snap_id=hq.snap_id
order by sql_id, snap_id;
