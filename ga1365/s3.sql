set head off
set verify off
set echo off
set pages 1500
set linesize 100
set lines 120
prompt
prompt Details of SID / SPID / Client PID
prompt ==================================
select /*+ CHOOSE*/
'Session  Id.............................................: '||s.sid,
'Serial Num..............................................: '||s.serial#,
'User Name ..............................................: '||s.username,
'Session Status .........................................: '||s.status,
'Client Process Id on Client Machine ....................: '||'*'||s.process||'*'  Client,
'Server Process ID ......................................: '||p.spid Server,
'Sql_Address ............................................: '||s.sql_address,
'Sql_hash_value .........................................: '||s.sql_hash_value,
'Schema Name ..... ......................................: '||s.SCHEMANAME,
'Program  ...............................................: '||s.program,
'Module .................................................: '|| s.module,
'Action .................................................: '||s.action,
'Terminal ...............................................: '||s.terminal,
'Client Machine .........................................: '||s.machine,
'LAST_CALL_ET ...........................................: '||s.last_call_et,
'S.LAST_CALL_ET/3600 ....................................: '||s.last_call_et/3600
from v$session s, v$process p
where p.addr=s.paddr and
s.sid=nvl('&sid',s.sid) and
p.spid=nvl('&spid',p.spid) and
nvl(s.process,-1) = nvl('&ClientPid',nvl(s.process,-1));

set head on
set verify on
set echo on

