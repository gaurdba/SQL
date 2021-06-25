col name for a30
col DB_NAME for a13
col Creation_Time for a20
col GUARANTEE_FLASHBACK_DATABASE for a30
set lines 200
select  sys_context('USERENV','DB_NAME') db_name,name,to_char(time,'DD-Mon-YYYY HH24:MI:SS') "Creation_Time",GUARANTEE_FLASHBACK_DATABASE from v$restore_point;
