set lines 400
col START_TIME for a25
set pages 10000
col sid for 99999
column message format a89
column percent format a8
col estimate_fin for a15
col START_TIME for a15
col broken for a7
SELECT sid,
  serial#,
  percent,
  sofar,TIME_REMAINING,message,
  totalwork,
  to_char(start_time,   'dd-mon-yy hh24:mi') start_time,
  to_char(efin,   'dd-mon-yy hh24:mi') estimate_fin,
  case when sofar <> totalwork and last_update_time < sysdate-1/10000 then '*' else null end broken
FROM
  (SELECT sid,
     serial#,
     TIME_REMAINING,message,
     sofar,
     totalwork,
     to_char(CASE
             WHEN totalwork = 0 THEN 1
             ELSE sofar / totalwork
             END *100,    '990') percent,
     start_time,
     last_update_time,
     start_time +((elapsed_seconds + time_remaining) / 86400) efin
   FROM gv$session_longops 
   ORDER BY  CASE
             WHEN sofar = totalwork 
                THEN 1
                ELSE 0 END,
          efin DESC)
WHERE sofar < totalwork order by message,sid; 
