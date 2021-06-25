ttitle  left  'Used Space for each ORACLE User' -
skip 2

set feed      off
set linesize  200
set pagesize  5000
set heading   on
set underline '-'

break on owner skip 1 on tablespace_name on segment_type
column owner           format A16           heading 'Owner'
column segment_type    format A10           heading 'Object'
column tablespace_name format A26           heading 'Tablespace'
column mbytes          format 9,999,999,999 heading 'Used Space|[MBytes]'
column blocks          format     9,999,999 heading 'Used Space|[Blocks]'
compute sum of bytes mbytes blocks on owner
--
-- Count Space for each Oracle Object
--
select
  substr(owner,1,16) owner
, substr(tablespace_name,1,26) tablespace_name
, substr(segment_type,1,10)    segment_type
, sum(bytes)/1024/1024         mbytes
, sum(blocks)                  blocks
from  sys.dba_extents
group by
  substr(owner,1,16)
, substr(tablespace_name,1,26)
, substr(segment_type,1,10)
order by 1,2,3;

clear breaks
clear computes
clear column

ttitle off
