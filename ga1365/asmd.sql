set lines 200
col path for a20
col header_status for a15
col MOUNT_STATUS for a13
col MODE_STATUS for a15
col FAILGROUP for a20
col name for a20
col state for a10
select path,DISK_NUMBER,MOUNT_STATUS,HEADER_STATUS,MODE_STATUS,STATE,NAME,FAILGROUP,TOTAL_MB,os_mb from v$asm_disk where path like '%&dbnam%' order by 1;
