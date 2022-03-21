set feedback off pages 0 
select name||':'||value from v$spparameter 
where name  not like 'log_archive%' 
and name not like '%dest%' 
and name not in ('spfile','dg_broker_config_file1','dg_broker_config_file2','control_files','dispatchers','local_listener','remote_listener') 
and value is  not null 
UNION
select name||':'||value from v$parameter 
where name  not like 'log_archive%' 
and name not like '%dest%' 
and name not in ('spfile','dg_broker_config_file1','dg_broker_config_file2','control_files','dispatchers','local_listener','remote_listener') 
and value is  not null order by 1;
