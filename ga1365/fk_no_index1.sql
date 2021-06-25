column owner_name format a10 
column table_name format a40 
column key_name format a40 
column referencing_table format a40
column foreign_key_name format a40

SELECT a.owner owner_name,
  a.table_name table_name,
  a.constraint_name key_name,
  b.table_name referencing_table,
  b.constraint_name foreign_key_name
FROM dba_constraints a,
  DBA_constraints b
WHERE a.constraint_name = b.r_constraint_name and a.owner=upper('&owner') 
--and a.TABLE_NAME like 'upper(nvl(table_name',sql_text))'
AND b.constraint_type   = 'R'
ORDER BY 2,  3,  4;

