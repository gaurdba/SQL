set head off;
--select sys_context('USERENV','DB_NAME')||':'||trunc(sum(bytes/1024/1024/1024)) as db_size from dba_segments ;
 select sys_context('USERENV','DB_NAME')||':'||round(sum(bytes/1024/1024/1024),0) from dba_data_files;
