set lines 300
col name format A28
set pages 200
col USED_OF_SAFELY_USABLE for a19
select name,lun_size_gb,luns_no,est_req_mirr_free_perc,redundancy,round(used_mb/1024) used_gb,round(free_mb/1024) free_gb,round(total_mb/1024 )total_gb,round(usable_file_mb/1024) usable_file_gb,round(usable_total_mb/1024) usable_tatal_gb,
case when usable_total_mb<>0 then to_char(round((100-(usable_file_mb/usable_total_mb)*100),1),'999.9')||' %' else 'Err' end as used_of_safely_usable
from (
select name,lun_size_mb,lun_size_gb,luns_no,est_req_mirr_free_perc,redundancy,used_mb,free_mb,total_mb,
round((free_mb-(lun_size_mb*luns_no*est_req_mirr_free_perc/100))/redundancy,0) as usable_file_mb,
round((total_mb-(total_mb*est_req_mirr_free_perc/100))/redundancy,0) as usable_total_mb
from (
select b.name, max(a.TOTAL_MB) as lun_size_mb, max(a.TOTAL_MB)/1024 as lun_size_gb, count(a.TOTAL_MB) as luns_no,
1/count(a.TOTAL_MB)*100 as est_req_mirr_free_perc,
2 as redundancy,(max(a.TOTAL_MB)*count(a.TOTAL_MB))-b.free_mb as used_mb,b.free_mb,(max(a.TOTAL_MB)*count(a.TOTAL_MB)) as total_mb from v$asm_disk a,
v$asm_diskgroup b
where a.group_number=b.group_number and b.name not like '%_VOCR_%' and b.name like upper('%&Diskgroup_name%')
group by b.name, b.free_mb))
order by name;

