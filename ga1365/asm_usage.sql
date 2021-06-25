set lines 300 
col name format A28 

select name,lun_size_gb,luns_no,est_req_mirr_free_perc,redundancy,used_mb,free_mb,total_mb,usable_file_mb,usable_total_mb, 
    case when usable_total_mb<>0 then to_char(round((100-(usable_file_mb/usable_total_mb)*100),1),'999.9')||' %' else 'Err' end as used_of_safely_usable 
  from ( 
    select name,lun_size_mb,lun_size_gb,luns_no,est_req_mirr_free_perc,redundancy,used_mb,free_mb,total_mb, 
        round((free_mb-(lun_size_mb*luns_no*est_req_mirr_free_perc/100))/redundancy,0) as usable_file_mb, 
        round((total_mb-(total_mb*est_req_mirr_free_perc/100))/redundancy,0) as usable_total_mb 
      from ( 
        select b.name, max(a.TOTAL_MB) as lun_size_mb, max(a.TOTAL_MB)/1024 as lun_size_gb, count(a.TOTAL_MB) as luns_no,
            1/count(a.TOTAL_MB)*100 as est_req_mirr_free_perc, 
            2 as redundancy,(max(a.TOTAL_MB)*count(a.TOTAL_MB))-b.free_mb as used_mb,b.free_mb,(max(a.TOTAL_MB)*count(a.TOTAL_MB)) as total_mb           from v$asm_disk a, 
               v$asm_diskgroup b 
          where a.group_number=b.group_number and b.name not like '%_VOCR_%'  and upper(b.name) =upper('&diskgroup_name')
          group by b.name, b.free_mb)) 
  order by name; 
