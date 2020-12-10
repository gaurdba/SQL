col STAT_NAME for a20
col VALUE_DIFF for 9999999999
col STAT_PER_MIN for 9999999999
set lines 300 pages 1500 long 99999999
col BEGIN_INTERVAL_TIME for a30
col END_INTERVAL_TIME for a30
set pagesize 5000
select hsys.SNAP_ID,
       to_char(hsnap.BEGIN_INTERVAL_TIME,'DD-Mon-YYYY Hh24:MI') BEGIN_INTERVAL_TIME,
       to_char(hsnap.END_INTERVAL_TIME,'DD-Mon-YYYY Hh24:MI') END_INTERVAL_TIME,
           hsys.STAT_NAME,
           hsys.VALUE,
           hsys.VALUE - LAG(hsys.VALUE,1,0) OVER (ORDER BY hsys.SNAP_ID) AS "VALUE_DIFF",
           round((hsys.VALUE - LAG(hsys.VALUE,1,0) OVER (ORDER BY hsys.SNAP_ID)) /
           round(abs(extract(hour from (hsnap.END_INTERVAL_TIME - hsnap.BEGIN_INTERVAL_TIME))*60 +
           extract(minute from (hsnap.END_INTERVAL_TIME - hsnap.BEGIN_INTERVAL_TIME)) +
           extract(second from (hsnap.END_INTERVAL_TIME - hsnap.BEGIN_INTERVAL_TIME))/60),1)) "STAT_PER_MIN"
from dba_hist_sysstat hsys, dba_hist_snapshot hsnap
 where hsys.snap_id = hsnap.snap_id and to_char(hsnap.BEGIN_INTERVAL_TIME,'DD-Mon-YYYY HH24:MI:SS') between to_date(&1,'DD-Mon-YYYY HH24:MI:SS') and to_date(&2,'DD-Mon-YYYY HH24:MI:SS')
 and hsnap.instance_number in (select instance_number from v$instance)
 and hsnap.instance_number = hsys.instance_number
 and hsys.STAT_NAME='user commits'
 order by 1;
