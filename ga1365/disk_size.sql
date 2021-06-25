col FAILGROUP for a30
col STATE for a15
col PATH for a30
col HEADER_STATUS for a15 

select group_number, nvl(failgroup,' ') failgroup, disk_number, mount_status, header_status , path 
from v$asm_disk 
where upper(name) like upper('%&Diskgroup_name%');
