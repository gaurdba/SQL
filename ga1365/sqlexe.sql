col USERNAME for a20
col SQL_ID for a15
col SQL_TEXT for a60
col sid for 99999
select key, sid, username, sql_id, sql_plan_hash_value plan_hash, elapsed_time, cpu_time, buffer_gets, disk_reads, SQL_EXEC_ID,substr(sql_text,1,50) sql_text
from v$sql_monitor
where status = 'EXECUTING'
/
