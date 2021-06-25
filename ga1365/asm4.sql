Prompt 'Enter Diskgroup name::'
accept dgname char format a35 prompt 'Diskgroup Name: '
WHENEVER SQLERROR EXIT FAILURE;
set lines 120
set pages 2000
set tab off
col diskgroup for a30
col "    TOTAL_GB" for a12
col "     USED_GB" for a12
col "     FREE_GB" for a12
col usage for a5
col directory for a60
col "     SIZE_MB" for a12
col "    SPACE_MB" for a12

select g.name diskgroup
,      to_char(sum(d.TOTAL_MB)/1024,'999,999,999') "    TOTAL_GB"
,      to_char((sum(d.TOTAL_MB)-sum(d.FREE_MB))/1024,'999,999,999') "     USED_GB"
,      to_char(sum(d.FREE_MB)/1024,'999,999,999') "     FREE_GB"
,      to_char(100*(sum(d.TOTAL_MB)-sum(d.FREE_MB))/sum(d.TOTAL_MB),'999')||'%' usage
from v$asm_disk d
     join v$asm_diskgroup g on (g.GROUP_NUMBER = d.GROUP_NUMBER) where lower(g.name)=lower('&dgname')
group by g.name
/

define path_depth=3
set verify off
SELECT substr(d.path,1,decode(instr(d.path||'/','/',1,&path_depth),0,length(d.path),instr(d.path||'/','/',1,&path_depth)-1)) DIRECTORY
,      to_char(sum(f.bytes)/(1024*1024),'999,999,999') "     SIZE_MB"
,      to_char(sum(f.space)/(1024*1024),'999,999,999') "    SPACE_MB"
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
            WHERE alias_directory = 'Y' and g.name='&dgname')
      START WITH (mod(pindex, power(2, 24))) = 0
      CONNECT BY PRIOR rindex = pindex) d
     join v$asm_alias a on (a.parent_index = d.rindex)
     join v$asm_file  f on (f.group_number = a.group_number AND f.file_number = a.file_number)
GROUP BY substr(d.path,1,decode(instr(d.path||'/','/',1,&path_depth),0,length(d.path),instr(d.path||'/','/',1,&path_depth)-1))
order by 2
/


