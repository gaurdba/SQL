set lines 180 pages 190
col VERSION for a20
col status  for a10
col COMP_ID for a20
col COMP_NAME for a40
col ACTION for a15
col COMMENTS for a35
col ACTION_TIME for a40
select name from v$database;
 select substr(comp_id,1,15) comp_id,substr(comp_name,1,30) comp_name,substr(version,1,10) version,status from dba_registry order by COMP_ID;

select ACTION,comments,ACTION_TIME from  sys.registry$history order by action_time;
col parameter for a25
col value form a10
set lines 200
select * from v$option where parameter = 'Real Application Testing';
