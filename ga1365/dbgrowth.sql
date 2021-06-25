 select
  to_char(CREATION_TIME,'RRRR') year,
  to_char(CREATION_TIME,'MM') month,
  sum(bytes)/1024/1024/1024 Size_GB
from
  v$datafile
group by
  to_char(CREATION_TIME,'RRRR'),
  to_char(CREATION_TIME,'MM')
order by
  1, 2
/
