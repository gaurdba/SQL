SET LINES 300
col BEGIN_INTERVAL_TIME for a30
col END_INTERVAL_TIME for a30
select BEGIN_INTERVAL_TIME,END_INTERVAL_TIME,RESOURCE_NAME,CURRENT_UTILIZATION,MAX_UTILIZATION,LIMIT_VALUE from DBA_HIST_RESOURCE_LIMIT l,dba_hist_snapshot s where l.SNAP_ID=s.SNAP_ID and RESOURCE_NAME='&parameter' order by 1;