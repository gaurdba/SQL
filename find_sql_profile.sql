col CATEGORY for a15
set lines 400
col NAME for a35
col force_matching for a14
col CREATED for a30
col LAST_MODIFIED for a30
col SIGNATURE for 9999999999999999999
set lines 300 verify off
select SIGNATURE,name, category, status, force_matching,CREATED,LAST_MODIFIED,TYpe
from dba_sql_profiles
where 
--sql_text like nvl('sql_text',sql_text) and
name like nvl('%&name%',name)
order by last_modified
/
