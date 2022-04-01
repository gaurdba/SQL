col index_name for a35
col owner for a20
col table_name for a35
set lines 300
select owner,table_name,index_name,last_analyzed from dba_indexes where lower(index_name)=lower('&index_name');

