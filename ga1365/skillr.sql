select inst_id,sid,serial#,username,osuser,logon_time,program,machine,status,sql_id from gv$session where  &1;
select 'alter system kill session '||''''||sid||','||serial#||',@'||inst_id||''''||' immediate;' "Kill Statement"  from gv$session where  &1;
