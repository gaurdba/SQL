set feedback off
col opname for a35
set lines 300
col sid for 99999
alter session set nls_date_format='DD-Mon-YYYY HH24:MI:SS';
set feedback on
select sid,serial#,opname, START_TIME,TOTALWORK, sofar, (sofar/totalwork) * 100 "Done%",
sysdate + TIME_REMAINING/3600/24 end_at,sysdate Current_Time
from gv$session_longops
where totalwork > sofar
AND opname NOT LIKE '%aggregate%'
AND opname like 'RMAN%'
/
