set lines 190
col RESOURCE_NAME for a40
col INITIAL_ALLOCATION for a20
col LIMIT_VALUE  for a20
select * from v$resource_limit where RESOURCE_NAME like nvl('%&Resource_name%',null);
