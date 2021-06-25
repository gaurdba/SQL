set lines 300
col owner for a20
col table_name for a35
col PARTITION_NAME for a12
col SUBPARTITION_NAME for a12
select TABLE_OWNER owner,table_name,INSERTS,UPDATES,DELETES,TIMESTAMP,TRUNCATED,DROP_SEGMENTS from sys.dba_tab_modifications where upper(TABLE_OWNER) like nvl(upper('&owner'),TABLE_OWNER)  and  table_name like nvl(upper('&tabl_name'),TABLE_NAME);

select TABLE_OWNER,count(*) from  sys.dba_tab_modifications group by TABLE_OWNER order by 2;
