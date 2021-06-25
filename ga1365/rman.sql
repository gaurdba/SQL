set feedback off
col opname for a35
set lines 300
alter session set nls_date_format='DD-Mon-YYYY HH24:MI:SS';
set feedback on
select sid,serial#,opname, START_TIME,TOTALWORK, sofar, (sofar/totalwork) * 100 "Done%",
sysdate + TIME_REMAINING/3600/24 end_at,sysdate Current_Time
from v$session_longops
where totalwork > sofar
AND opname NOT LIKE '%aggregate%'
/
