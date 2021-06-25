col sid for 999999
col sql_text for a70 wrap
set lines 300
set echo on

WITH px_session AS (  SELECT   qcsid, qcserial#, MAX (degree) degree,
                               MAX (req_degree) req_degree,
                               COUNT ( * ) no_of_processes
                        FROM   v$px_session p
                    GROUP BY   qcsid, qcserial#)
SELECT   s.sid, s.username, degree, req_degree, no_of_processes, 
         sql_text
  FROM   v$session s  JOIN px_session p
           ON (s.sid = p.qcsid AND s.serial# = p.qcserial#)
         JOIN v$sql sql
           ON (sql.sql_id = s.sql_id 
               AND sql.child_number = s.sql_child_number)
/
set lines 120
clear col
