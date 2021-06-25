Set echo off
set pagesize 1000
set lines 200
set verify off
set heading on
set feedback on
col SESS format a12
col status format a10
col SQL_ID format a20
col program format a30
col terminal format a12
col "Machine Name" format a15
col "DB User" format a14
col "Logon Time" format a14
col "OS User" format a10
col EVENT format a35
col MACHINE format a35
col SQL_ID format a15
col inst_id format 9
select rpad(s.username,14,' ') as "DB User",inst_id,
   to_char(logon_time,'hh24:mi Mon/dd') as "Logon Time",status,
   s.sid||','||s.serial# SESS,
   rpad(upper(substr(s.program,instr(s.program,'\',-1)+1)),30,' ') as "Program",
   rpad(lower(osuser),10,' ') as "OS User",machine,
   round(LAST_CALL_ET/60) MINS_ACTIVE
    from gv$session s
   where upper(s.username) like upper('%&Username%')
 order by STATUS,LAST_CALL_ET;
