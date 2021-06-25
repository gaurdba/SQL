column table_name format a50
set lines 200
select /*+ ordered */
  u.name ||'.'|| o.name  table_name,
  1 + s.groups + t.blkcnt + t.empcnt  analyzed_size,
  s.blocks  current_size,
  substr(
    to_char(
      100 * (s.blocks - 1 - s.groups - t.blkcnt - t.empcnt) /
            (1 + s.groups + t.blkcnt + t.empcnt),
      '999.00'
    ),
    2
  ) ||
  '%'  change
from
  sys.file$ f,
  sys.seg$  s,
  sys.tab$  t,
  sys.obj$  o,
  sys.user$ u
where
  s.file#  = f.file#  and
  s.type#  = 5        and
  t.ts#    = s.ts#    and
  t.file#  = s.file#  and
  t.block# = s.block# and
  abs(s.blocks - 1 - s.groups - t.blkcnt - t.empcnt) > 4 and
  o.obj#  = t.obj#    and
  u.user# = o.owner# and u.name not in ('SYS','SYSTEM','MDSYS','DBSNMP','XDB','EXFSYS','WMSYS','SYSMAN')
and u.name like upper('%&Username%')
order by 4
/
