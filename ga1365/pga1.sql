col c1 heading 'Workarea|Profile' format a35
col c2 heading 'Count' format 999,999,999
col c3 heading 'Percentage' format 99
select name c1,count c2,decode(total, 0, 0, round(count*100/total)) c3
from
(
select name,value count,(sum(value) over ()) total
from
v$sysstat
where
name like 'workarea exec%'
);
