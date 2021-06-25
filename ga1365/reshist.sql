col BEGIN_INTERVAL_TIME for a35
col RESOURCE_NAME for a30
set lines 300
set pages 100
select BEGIN_INTERVAL_TIME,RESOURCE_NAME,CURRENT_UTILIZATION,MAX_UTILIZATION,limit_value from dba_hist_snapshot s,dba_hist_resource_limit r where r.SNAP_ID=s.SNAP_ID and RESOURCE_NAME like nvl('%&Resouce_name%',RESOURCE_NAME) order by 1;
set lines 120
