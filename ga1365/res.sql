set lines 300 pages 200
col limit_value for a13
col initial_allocation for a15
col max_utilization for 99999999999999
select * from v$resource_limit where resource_name like nvl('%&Resource_name%',resource_name);
set lines 120
