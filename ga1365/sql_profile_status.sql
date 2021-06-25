col name for a35
col created for a35
set lines 200
select name,created,status from dba_sql_profiles order by created;
EXEC DBMS_SQLTUNE.ALTER_SQL_PROFILE('&Profile_Name','STATUS','&Status_ENABLE_DISABLE');
