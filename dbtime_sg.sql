set lines 155 pages 300 verify off
col dbtime for 999,999.99
col begin_timestamp for a40
--alter session set nls_date_format='DD-Mon-YYYY HH24:MI';
--select * from (
select begin_snap, end_snap, timestamp begin_timestamp, inst, a/1000000/60 DBtime from
(
select
 e.snap_id end_snap,
 lag(e.snap_id) over (order by e.instance_number,e.snap_id) begin_snap,
 to_char(lag(s.end_interval_time) over (order by e.instance_number,e.snap_id),'DD-Mon-YYYY HH24:MI') timestamp,
 s.instance_number inst,
 e.value,
 nvl(value-lag(value) over (order by e.instance_number,e.snap_id),0) a
from dba_hist_sys_time_model e, DBA_HIST_SNAPSHOT s
where s.snap_id = e.snap_id and BEGIN_INTERVAL_TIME >=(sysdate - &Days_to_Report )
 and e.instance_number = s.instance_number
 and to_char(e.instance_number) like nvl('&instance_number',to_char(e.instance_number))
 and stat_name             = 'DB time'
)
order by begin_snap
/
