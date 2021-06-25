col event for a60
set lines 280
SELECT NVL(a.event, 'ON CPU') AS event,
       COUNT(*) AS total_wait_time
FROM   v$active_session_history a
WHERE  a.sample_time > SYSDATE - &minute/(24*60) -- 5 mins
GROUP BY a.event
ORDER BY total_wait_time DESC;
