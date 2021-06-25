col name format a35
col FAILGROUP format a15
col HEADER_STATUS format a 15
select a.name,a.FAILGROUP,a.HEADER_STATUS,a.count "Missing Disk" ,b.count2*2 "Total Disk" from  
(select dg.name,fAILGROUP,header_status,count(*) count from v$asm_disk d,v$asm_diskgroup dg where dg.GROUP_NUMBER=d.GROUP_NUMBER and  FAILGROUP='CCAZ' and HEADER_STATUS='UNKNOWN' group by dg.name,FAILGROUP,header_status) a,
(select dg.GROUP_NUMBER,dg.name,count(*)/2 count2 from v$asm_disk d,v$asm_diskgroup dg where dg.GROUP_NUMBER=d.GROUP_NUMBER group by dg.group_number,dg.name) b
where a.NAME=b.name and a.count<>b.count2;
exit;
