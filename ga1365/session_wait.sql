set lines 120 trimspool on
col event head "Waited for" format a30
col total_waits head "Total|Waits" format 999,999
col tw_ms head "Waited|for (ms)" format 999,999.99
col aw_ms head "Average|Wait (ms)" format 999,999.99
col mw_ms head "Max|Wait (ms)" format 999,999.99
select event, total_waits, time_waited*10 tw_ms,
       average_wait*10 aw_ms, max_wait*10 mw_ms
from v$session_event
where sid = &SID
/
