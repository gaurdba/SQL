Set echo off
set pagesize 1000
set lines 250
set verify off
set heading on
set feedback on
col SESS format a12
col status format a10
col program format a30
col terminal format a12
col "Machine Name" format a15
col "Machine Name" format a15
col "DB User" format a14
col Logon_Time format a21
col "OS User" format a10
col SQL_ID for a15
col "Event" for a39
select s.inst_id "Instance",rpad(s.username,14,' ') as "DB User",s.sid||','||s.serial# SESS,
 rpad(upper(substr(s.program,instr(s.program,'\',-1)+1)),30,' ') as "Program",  rpad(lower(osuser),10,' ') as "OS User",rpad(initcap(machine),15,' ') as "Machine Name",round (LAST_CALL_ET/60) MINS_ACTIVE,logon_time,sql_id  ,substr(event,1,35) "Event"
 from gv$session s 
 where upper(s.username) like upper('%&Username%') and s.status='ACTIVE' and username not in ('SYS','DBSNMP')  order by LAST_CALL_ET
/

