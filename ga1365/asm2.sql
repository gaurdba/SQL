col name for a50 head 'ASM_DISK|Name'
col g_name for a25 head 'ASM_Group|Name'
col path for a20 head 'Disk|Path'
col DISK_NUMBER head 'DISK|NUM#'   for 99999
col GROUP_NUMBER head 'Grp|NUM' for 999
col HEADER_STATUS head 'HEADER|STATUS'
col MOUNT_STATUS head 'MOUNT|STATUS' for a8
col TOTAL_MB for 999,999,999
col FREE_MB for 999,999,999
col ALLOC for 99999 head 'Alloc|Unit_KB'
col SECTOR_SIZE head 'Sector|Size'
col Block_Size head 'Block|Size'
col offline_disks head 'Offline|Disks'
set linesize 300
set pagesize 250
select name     "g_name", TYPE, round(TOTAL_MB/1024,2) TOTAL_GB , round(FREE_MB/1024,2) FREE_GB ,round(usable_file_mb/1024,2) usable_file_GB, round(FREE_MB/TOTAL_MB * 100,1) PCT_FREE,BLOCK_SIZE, SECTOR_SIZe, OFFLINE_DISKS, ALLOCATION_UNIT_SIZE/1024 Alloc, STATE from v$asm_diskgroup order by 1;

