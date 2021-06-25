set pagesize 5000
set linesize 350
col TABLE_NAME for a35
col FK_COLUMNS for a55
col FK_NAME for aa35
column status        format a10
column index_name    format a30
column index_columns format a30

select
case
   when b.table_name is null then
      'unindexed'
   else
      'indexed'
end as status,
   a.table_name      as table_name,
   a.constraint_name as fk_name,
  a.fk_columns      as fk_columns,
  b.index_name      as index_name,
  b.index_columns   as index_columns
from
(
   select
    a.table_name,
   a.constraint_name,
   listagg(a.column_name, ',') within
group (order by a.position) fk_columns
from
   dba_cons_columns a,
   dba_constraints b
where
   a.constraint_name = b.constraint_name
and
   b.constraint_type = 'R'
and
   a.owner = '&&schema_owner'
and
   a.owner = b.owner
group by
   a.table_name,
   a.constraint_name
) a
,(
select
   table_name,
   index_name,
   listagg(c.column_name, ',') within
group (order by c.column_position) index_columns
from
   dba_ind_columns c
where
   c.index_owner = '&&schema_owner'
group by
   table_name,
   index_name
) b
where
   a.table_name = b.table_name(+)
and
   b.index_columns(+) like a.fk_columns || '%' 
and b.table_name is null --to show only unindexed records,remove to see all
order by
   1 desc, 2;
