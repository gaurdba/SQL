-- Purpose:     show wait events for a SQL_ID or SQL_ID’s that have waited for some event - ASH
select event, sql_id, count(*)
from v$active_session_history
where event like nvl('&event',event)
and sql_id like nvl('&sql_id',sql_id)
group by event, sql_id
order by event, 3
/
