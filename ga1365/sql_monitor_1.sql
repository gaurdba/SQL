select sid, sql_id, sql_exec_id, to_char(sql_exec_start,'DD-Mon-YY HH24:MI:SS') sql_exec_start, sql_plan_hash_value plan_hash_value,
elapsed_time/1000000 etime, buffer_gets, disk_reads
from v$sql_monitor
where sid like nvl('&sid',sid)
and sql_id like nvl('&sql_id',sql_id)
and sql_exec_id like nvl('&sql_exec_id',sql_exec_id)
order by sql_id, sql_exec_id
/
