col owner for a25
col job_name for a30
col ELAPSED_TIME for a20
col instance_name for a20
col JOB_SUBNAME for a35
set lines 300
select SESSION_ID,OWNER,JOB_NAME,JOB_SUBNAME,ELAPSED_TIME,g.instance_name from dba_scheduler_running_jobs j, gv$instance g where g.inst_id=j.RUNNING_INSTANCE ;
