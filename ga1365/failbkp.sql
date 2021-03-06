SELECT  DB_NAME,status,
		CASE
			WHEN OUTPUT_DEVICE_TYPE = 'SBT_TAPE' 
				THEN 'DB FULL'
			ELSE INPUT_TYPE
			END INPUT_TYPE,
  TO_CHAR(END_TIME,'DD-Mon-YYYY HH24:MI:SS') END_TIME_DAY,
    TIME_TAKEN_DISPLAY,
  ROUND(SUM(OUTPUT_BYTES/1024/1024/1024),2) SUM_BACKUP_PIECES_IN_GB,
  OUTPUT_DEVICE_TYPE
FROM RC_RMAN_BACKUP_JOB_DETAILS
WHERE end_time > (sysdate - 1 + 18/24) and (STATUS like '%FAIL%' or status like '%WARNING%' or status like '%RUNNING%')
AND INPUT_TYPE in ('BACKUPSET','DB FULL','DB INCR','CONTROLFILE')
AND OUTPUT_DEVICE_TYPE IS NOT NULL
AND END_TIME            >SYSDATE-90
GROUP BY DB_NAME,
  INPUT_TYPE,
  STATUS,
 END_TIME ,
  TO_CHAR(END_TIME,'mm/dd/yy') ,
  TIME_TAKEN_DISPLAY,
  OUTPUT_DEVICE_TYPE
ORDER BY DB_NAME,
  END_TIME_DAY,
  END_TIME;
