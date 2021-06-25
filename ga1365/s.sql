 col machine for a48 head Machine|name
 col USERNAME for a15
 col OSUSER for a10
 col PROGRAM for a48
set lines 290
col status for a9
col spid for a10
col machine for a15
 select s.sid,s.serial#,s.username,osuser,logon_time,s.program,status,machine,p.spid from gv$session s,gv$process p where p.addr =s.paddr and  &1;
