set lines 200
col owner for a25
col object_name for a40
col object_type for a25
col status for a10
select owner,object_name,object_type,status,CREATED from dba_objects where object_name=upper('&Object_name') order by created;
