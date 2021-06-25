col username for a15
col sid for 999
col EXECUTIONS for 9999999
col OPNAME for a20
col target for a15
col "ETime(Min)" for 99999999
col time_remaining for 9999999
SELECT s.username,
       sl.sid,
       sq.executions,
       sl.last_update_time,
       sl.sql_id,
       sl.sql_hash_value,
       opname,
       target,
       trunc(elapsed_seconds/60) "ETime(Min)",
       time_remaining,
       sq.sql_fulltext
  FROM v$session_longops sl
 INNER JOIN v$sql sq ON sq.sql_id = sl.sql_id
 INNER JOIN v$session s ON sl.SID = s.SID AND sl.serial# = s.serial#
 WHERE time_remaining > 0
 and rownum <15
 /
