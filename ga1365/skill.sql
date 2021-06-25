set lines 300
set pages 100
col machine for a20
col status for a10
col osuser for a15
col program for a20
col username for a20
col "Kill Statement" for a65
--set feedback off
PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Session detail being killed                                 |
PROMPT +------------------------------------------------------------------------+
select sid,s.serial#,substr(s.username,1,20) username,substr(osuser,1,15)osuser,logon_time,substr(s.program,1,20) program,substr(machine,1,20) machine,status,sql_id,spid from v$session s,gv$process p  where  p.addr=s.paddr and  &1;
PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Kill Statement for the Database Session                     |
PROMPT +------------------------------------------------------------------------+
select 'alter system kill session '||''''||sid||','||serial#||''''||' immediate;' "Kill Statement"  from gv$session s where  &1;
PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Kill Statement for the OS Process                           |
PROMPT +------------------------------------------------------------------------+
select 'kill -9 '||spid "Kill Server Process" from v$session s,gv$process p  where  p.addr=s.paddr and  &1;
