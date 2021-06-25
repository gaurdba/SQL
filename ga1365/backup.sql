COLUMN session_key                            FORMAT 9999999
COLUMN start_Time                               FORMAT a18
COLUMN status                                   FORMAT a25
COLUMN object_type                              FORMAT a15
COLUMN row_type                                 FORMAT a20
COLUMN operation                                FORMAT a35
COLUMN output_device_Type HEADING "Media"       FORMAT a8
set lines 300
SELECT to_char(s.start_Time,'dd-MON-YY hh24:mi:SS') start_time
      ,s.db_name
      ,s.status
   --  ,s.row_type
      ,s.operation
      ,s.object_type
      ,s.output_device_Type
          ,TAG
      ,ROUND( (s.end_time - s.start_time) * 24 * 60,2) duration
FROM DBQNL23_2016_OWNER.rc_rman_status s, DBQNL23_2016_OWNER.RC_BACKUP_PIECE p
WHERE s.start_time > trunc(sysdate - 7 + 8/24) and object_type !='ARCHIVELOG'
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
  --AND s.status NOT IN  ('COMPLETED')
AND trunc(s.start_Time) >= trunc(sysdate -1) and s.RSR_KEY=p.RSR_KEY and tag='MDS-L0-TAPE_M'
UNION ALL
SELECT to_char(s.start_Time,'dd-MON-YY hh24:mi:SS') start_time
      ,s.db_name
      ,s.status
   --  ,s.row_type
      ,s.operation
      ,s.object_type
      ,s.output_device_Type
          ,TAG
      ,ROUND( (s.end_time - s.start_time) * 24 * 60,2) duration
FROM DBQNL24_2016_OWNER.rc_rman_status s, DBQNL24_2016_OWNER.RC_BACKUP_PIECE p
WHERE s.start_time > trunc(sysdate - 7 + 8/24) and object_type !='ARCHIVELOG'
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
  AND s.status NOT IN  ('COMPLETED')
AND trunc(s.start_Time) >= trunc(sysdate -1) and s.RSR_KEY=p.RSR_KEY and tag='MDS-L0-TAPE_M'
UNION ALL
SELECT to_char(s.start_Time,'dd-MON-YY hh24:mi:SS') start_time
      ,s.db_name
      ,s.status
   --  ,s.row_type
      ,s.operation
      ,s.object_type
      ,s.output_device_Type
          ,TAG
      ,ROUND( (s.end_time - s.start_time) * 24 * 60,2) duration
FROM DBQNL20_2016_OWNER.rc_rman_status s, DBQNL20_2016_OWNER.RC_BACKUP_PIECE p
WHERE s.start_time > trunc(sysdate - 7 + 8/24) and object_type !='ARCHIVELOG'
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
  AND s.status NOT IN  ('COMPLETED')
AND trunc(s.start_Time) >= trunc(sysdate -1) and s.RSR_KEY=p.RSR_KEY and tag='MDS-L0-TAPE_M'
UNION ALL
SELECT to_char(s.start_Time,'dd-MON-YY hh24:mi:SS') start_time
      ,s.db_name
      ,s.status
   --  ,s.row_type
      ,s.operation
      ,s.object_type
      ,s.output_device_Type
          ,TAG
      ,ROUND( (s.end_time - s.start_time) * 24 * 60,2) duration
FROM DBQNL25_2016_OWNER.rc_rman_status s, DBQNL25_2016_OWNER.RC_BACKUP_PIECE p
WHERE s.start_time > trunc(sysdate - 7 + 8/24) and object_type !='ARCHIVELOG'
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
  AND s.status NOT IN  ('COMPLETED')
AND trunc(s.start_Time) >= trunc(sysdate -1) and s.RSR_KEY=p.RSR_KEY and tag='MDS-L0-TAPE_M'
/

