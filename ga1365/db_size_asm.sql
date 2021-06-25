define path_depth=3
 set lines 300
 set heading off
 col Diskgroup for a25
 col SPACE_MB for a15
 col dbname for a15
 set colsep |
 set pages 1000
 SELECT trim('+' from REGEXP_SUBSTR(d.path, '[^/"]+', 1, 1)) Diskgroup,REGEXP_SUBSTR (d.path, '[^/"]+', 1, 2) dbname
 ,      to_char(sum(f.space)/(1024*1024),'999,999,999') SPACE_MB
 FROM (SELECT rindex, group_number, file_number, concat('+'||gname, sys_connect_by_path(aname, '/')) path
 FROM (SELECT g.name gname
 ,      a.parent_index pindex
             ,      a.name aname
             ,      a.group_number
             ,      a.file_number
             ,      a.reference_index rindex
             ,      a.system_created
             FROM v$asm_alias     a
join v$asm_diskgroup g on (g.group_number = a.group_number)
WHERE alias_directory = 'Y' and g.name like '%DATA_AREA%')
START WITH (mod(pindex, power(2, 24))) = 0
CONNECT BY PRIOR rindex = pindex) d
join v$asm_alias a on (a.parent_index = d.rindex)
join v$asm_file  f on (f.group_number = a.group_number AND f.file_number = a.file_number)
GROUP BY trim('+' from REGEXP_SUBSTR(d.path, '[^/"]+', 1, 1)),REGEXP_SUBSTR (d.path, '[^/"]+', 1, 2)
order by 1,2;

