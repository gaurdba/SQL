set lines 250
set pages 50
col BEGIN_INTERVAL_TIME for a30
col PARAMETER_NAME for a35
col value for a160
select to_date( to_char(BEGIN_INTERVAL_TIME,'DD-Mon-YYYY HH24:MI')) BEGIN_INTERVAL_TIME,PARAMETER_NAME,VALUE from dba_hist_parameter p,dba_hist_snapshot s where s.SNAP_ID=p.SNAP_ID and lower(PARAMETER_NAME)=lower('&Parameter_name') order by 1;
