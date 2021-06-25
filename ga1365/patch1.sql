set lines 180 pages 190
col VERSION for a50
col status  for a10
col COMP_ID for a40
col COMP_NAME for a50
col ACTION for a35
col COMMENTS for a40
col ACTION_TIME for a45
select name from v$database;
-- select substr(comp_id,1,15) comp_id,substr(comp_name,1,30) comp_name,substr(version,1,10) version,status from dba_registry order by COMP_ID;

select ACTION,comments,ACTION_TIME from  sys.registry$history order by action_time;
exit;
