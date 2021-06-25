PROMPT 
PROMPT 
--PROMPT Backups with errors in last 24 hours
--PROMPT ####################################
COLUMN session_key                              FORMAT 9999999
COLUMN start_Time                               FORMAT a18
COLUMN status                                   FORMAT a25
COLUMN object_type                              FORMAT a15
COLUMN row_type                                 FORMAT a20
COLUMN operation                                FORMAT a35
COLUMN output_device_Type HEADING "Media"       FORMAT a8 
COLUMN input_mb           HEADING "Input|(MB)"  FORMAT 999,990.99
COLUMN output_mb          HEADING "Output|(MB)" FORMAT 999,990.99
COLUMN duration           HEADING "Dur|(Min)"   FORMAT 990.99
set lines 300
SELECT to_char(s.start_Time,'dd-MON-YY hh24:mi:SS') start_time
      ,s.db_name
      ,s.status
   --  ,s.row_type
      ,s.operation
      ,s.object_type
      ,s.output_device_Type 
      ,ROUND(s.input_bytes/1024/1024,2) input_mb 
      ,ROUND(s.output_bytes/1024/1024,2) output_mb
      ,ROUND( (s.end_time - s.start_time) * 24 * 60,2) duration
FROM rc_rman_status s
WHERE s.start_time > trunc(sysdate - 1 + 8/24) and object_type !='ARCHIVELOG' 
  --  exclude manual list command errors and overall session status. 
  --  individual backup/restore/delete step errors will still be reported
  AND s.operation NOT IN ('RMAN'
                         ,'LIST'
                         ,'REPORT'
                         ,'DUPLICATE DB'  -- used to clone db on non-prod
                         ,'RESTORE'
                         ,'RESTORING AND APPLYING LOGS'
                         ,'RECOVER AND APPLYING LOGS'
                         )
  AND s.status NOT IN  ('COMPLETED'
                       ,'COMPLETED WITH WARNINGS'
                       )
ORDER BY start_time asc;
