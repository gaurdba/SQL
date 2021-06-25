 col owner for a25
 col START_DATE for a40
 col REPEAT_INTERVAL for a85
 col STATE for a15
 col LAST_START_DATE for a25
col ENABLED for a10
set lines 300
select OWNER,JOB_NAME,state,ENABLED,to_char(LAST_START_DATE,'DD-Mon-YYYY HH24:MI:SS') LAST_START_DATE,REPEAT_INTERVAL  
from dba_scheduler_jobs 
where  lower(owner) like lower(nvl('&owner',owner))  AND lower(JOB_NAME) like lower(nvl('&JOB_NAME',JOB_NAME))
order by owner,ENABLED desc;
