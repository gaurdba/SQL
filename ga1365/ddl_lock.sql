 set lines 250
col MACHINE for a30
 col USERNAME for a30
 col OSUSER for a30
 col PROGRAM for a45
 select s.sid,serial#,username,osuser,logon_time,program,machine from v$session s,v$access a where a.sid=s.sid and owner=Upper('&Owner_Name') and object=Upper('&Object_name');
