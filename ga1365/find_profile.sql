col CATEGORY for a15
set lines 400
col NAME for a35
select name, category, status, sql_text, force_matching
from dba_sql_profiles
where sql_text like nvl('&sql_text',sql_text)
and name like nvl('&name',name)
order by last_modified
/
