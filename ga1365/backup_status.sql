col db_name for a12
col command_id for a35
col start_time for a30
col end_time for a30
col TIME_TAKEN_DISPLAY for a15
col status for a30
col OUTPUT_DEVICE_TYPE for a15
set lines 250
select * from (
select  DB_NAME,COMMAND_ID,START_TIME,END_TIME,TIME_TAKEN_DISPLAY,STATUS,OUTPUT_DEVICE_TYPE
from    DBPNL25_2016_OWNER.RC_RMAN_BACKUP_JOB_DETAILS
     where   status not in ('COMPLETED','COMPLETED WITH WARNINGS')
     and     start_time   > trunc(sysdate - 8)
UNION ALL
select  DB_NAME,COMMAND_ID,START_TIME,END_TIME,TIME_TAKEN_DISPLAY,STATUS,OUTPUT_DEVICE_TYPE
from    DBPNL24_2016_OWNER.RC_RMAN_BACKUP_JOB_DETAILS
     where   status not in ('COMPLETED','COMPLETED WITH WARNINGS')
     and     start_time   > trunc(sysdate - 8)
UNION ALL
select  DB_NAME,COMMAND_ID,START_TIME,END_TIME,TIME_TAKEN_DISPLAY,STATUS,OUTPUT_DEVICE_TYPE
from    DBPNL23_2016_OWNER.RC_RMAN_BACKUP_JOB_DETAILS
     where   status not in ('COMPLETED','COMPLETED WITH WARNINGS')
     and     start_time   > trunc(sysdate - 8)
UNION ALL
select  DB_NAME,COMMAND_ID,START_TIME,END_TIME,TIME_TAKEN_DISPLAY,STATUS,OUTPUT_DEVICE_TYPE
from    DBMNL20_2016_OWNER.RC_RMAN_BACKUP_JOB_DETAILS
     where   status not in ('COMPLETED','COMPLETED WITH WARNINGS')
     and     start_time   > trunc(sysdate - 8)
UNION ALL
select  DB_NAME,COMMAND_ID,START_TIME,END_TIME,TIME_TAKEN_DISPLAY,STATUS,OUTPUT_DEVICE_TYPE
from    DBPNL20_2016_OWNER.RC_RMAN_BACKUP_JOB_DETAILS
     where   status not in ('COMPLETED','COMPLETED WITH WARNINGS')
     and     start_time   > trunc(sysdate - 8)) order by DB_NAME, start_time;
