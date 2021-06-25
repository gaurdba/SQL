-- Purpose:     show wait events for a SQL_ID or SQL_ID.s that have waited for some event - ASH DBA_HIST_ACTIVE_SESS_HISTORY
set lines 155
col avg_time_waited for 999,999.99
select event, sql_id, count(*),
avg(time_waited) avg_time_waited
from DBA_HIST_ACTIVE_SESS_HISTORY
where event like nvl('&event',event)
and sql_id like nvl('&sql_id',sql_id)
group by event, sql_id
order by event, 3
/

