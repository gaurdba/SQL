COLUMN session_key                            FORMAT 9999999
COLUMN start_Time                               FORMAT a18
COLUMN status                                   FORMAT a25
COLUMN object_type                              FORMAT a15
COLUMN row_type                                 FORMAT a20
COLUMN operation                                FORMAT a15
COLUMN output_device_Type HEADING "Media"       FORMAT a8
col db_name for a10
col command_id for a20
set lines 300
SELECT to_char(s.start_Time,'dd-MON-YY hh24:mi:SS') start_time
      ,s.db_name
      ,s.status
   --  ,s.row_type
      ,s.operation
      ,s.object_type
      ,s.command_id
      ,s.output_device_Type
      ,ROUND( (s.end_time - s.start_time) * 24 * 60,2) duration
FROM DBPNL20_2016_OWNER.rc_rman_status s
--WHERE to_date(trunc(s.start_time),'DD-Mon-YYYY') >= to_date(trunc(sysdate - 7 + 8/24),'DD-Mon-YYYY')
 where trunc(start_time) >=(sysdate -2)
AND s.operation NOT IN ('RMAN'
                         ,'LIST'
                         ,'REPORT'
                         ,'DUPLICATE DB'  -- used to clone db on non-prod
                         ,'RESTORE'
                         ,'RESTORING AND APPLYING LOGS'
                         ,'RECOVER AND APPLYING LOGS'
                         )
AND command_id like 'BACKUP_L%' AND s.status <>'COMPLETED'
UNION ALL
SELECT to_char(s.start_Time,'dd-MON-YY hh24:mi:SS') start_time
      ,s.db_name
      ,s.status
   --  ,s.row_type
      ,s.operation
      ,s.object_type
      ,s.command_id
      ,s.output_device_Type
      ,ROUND( (s.end_time - s.start_time) * 24 * 60,2) duration
FROM DBPNL23_2016_OWNER.rc_rman_status s
 where trunc(start_time) >=(sysdate -2)
AND s.operation NOT IN ('RMAN'
                         ,'LIST'
                         ,'REPORT'
                         ,'DUPLICATE DB'  -- used to clone db on non-prod
                         ,'RESTORE'
                         ,'RESTORING AND APPLYING LOGS'
                         ,'RECOVER AND APPLYING LOGS'
                         )
AND command_id like 'BACKUP_L%' AND s.status <>'COMPLETED'
UNION ALL
SELECT to_char(s.start_Time,'dd-MON-YY hh24:mi:SS') start_time
      ,s.db_name
      ,s.status
   --  ,s.row_type
      ,s.operation
      ,s.object_type
      ,s.command_id
      ,s.output_device_Type
      ,ROUND( (s.end_time - s.start_time) * 24 * 60,2) duration
FROM DBPNL24_2016_OWNER.rc_rman_status s
--WHERE to_date(trunc(s.start_time),'DD-Mon-YYYY') >= to_date(trunc(sysdate - 7 + 8/24),'DD-Mon-YYYY')
 where trunc(start_time) >=(sysdate -2)
AND s.operation NOT IN ('RMAN'
                         ,'LIST'
                         ,'REPORT'
                         ,'DUPLICATE DB'  -- used to clone db on non-prod
                         ,'RESTORE'
                         ,'RESTORING AND APPLYING LOGS'
                         ,'RECOVER AND APPLYING LOGS'
                         )
AND command_id like 'BACKUP_L%' AND s.status <>'COMPLETED'
UNION ALL
SELECT to_char(s.start_Time,'dd-MON-YY hh24:mi:SS') start_time
      ,s.db_name
      ,s.status
   --  ,s.row_type
      ,s.operation
      ,s.object_type
      ,s.command_id
      ,s.output_device_Type
      ,ROUND( (s.end_time - s.start_time) * 24 * 60,2) duration
FROM DBPNL25_2016_OWNER.rc_rman_status s
--WHERE to_date(trunc(s.start_time),'DD-Mon-YYYY') >= to_date(trunc(sysdate - 7 + 8/24),'DD-Mon-YYYY')
 where trunc(start_time) >=(sysdate -2)
AND s.operation NOT IN ('RMAN'
                         ,'LIST'
                         ,'REPORT'
                         ,'DUPLICATE DB'  -- used to clone db on non-prod
                         ,'RESTORE'
                         ,'RESTORING AND APPLYING LOGS'
                         ,'RECOVER AND APPLYING LOGS'
                         )
AND command_id like 'BACKUP_L%' AND s.status <>'COMPLETED'
ORDER BY start_Time,db_name
;
exit;
