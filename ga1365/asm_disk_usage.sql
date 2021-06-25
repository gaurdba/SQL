col name for a35
col path for a50
set lines 300
set heading off;
set pagesize 0;
SET LINESIZE 1000
SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
break on name skip 1
select  dg.name,path,d.OS_MB,d.TOTAL_MB,d.FREE_MB,round(((d.total_mb-d.FREE_MB)/d.TOTAL_MB)*100) "usage%" from v$asm_disk d, v$asm_diskgroup dg where path like '%CCAZ%' and d.name is not null and  dg.GROUP_NUMBER=d.GROUP_NUMBER order by 1;
exit;
