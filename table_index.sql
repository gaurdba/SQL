set lines 300 verify off
col owner for a20
col table_name for a40
col index_name for a45
col INDEX_TYPE for a25
col UNIQUENESS for a10
col DEGREE for a10
col PARTITIONED for a12
col columns for a40
undefine table_name
undefine owner
with ind as (select TABLE_NAME,OWNER,INDEX_NAME ,INDEX_TYPE,UNIQUENESS,VISIBILITY,status,DEGREE,PARTITIONED from dba_indexes where table_name='&&table_name' and owner='&owner'),
col as (select INDEX_OWNER,INDEX_NAME , listagg(COLUMN_NAME,',') within group( order by column_position) Columns from dba_ind_columns 
where index_owner||'.'||index_name in (select owner||'.'||index_name from dba_indexes where table_name='&&table_name') group by INDEX_OWNER,INDEX_NAME) 
select ind.owner,ind.Index_name ,ind.TABLE_NAME,INDEX_TYPE,UNIQUENESS,DEGREE,VISIBILITY,status,PARTITIONED,Columns from ind,col where ind.index_name=col.index_name and ind.owner=col.index_owner
order by index_name;
