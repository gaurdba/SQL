set lin 200
set pagesize 50
col name for a25
col state for a10
col type for a9
select name, state, type, total_mb, free_mb, required_mirror_free_mb req_free, usable_file_mb usable_mb,
case when total_mb=0 then 0 else round((TOTAL_MB-usable_file_mb)/TOTAL_MB*100) end "USABLE_PERCENT", 
round(TOTAL_MB/3) Add_Space_1, 
case when total_mb=0 then 0 else round((TOTAL_MB+(TOTAL_MB/3)-(usable_file_mb+((TOTAL_MB/3)/2)))/(TOTAL_MB+(TOTAL_MB/3))*100) end USABLE_PERCENT_1 
from v$asm_diskgroup where name like '%&Diskgroup_name%';

