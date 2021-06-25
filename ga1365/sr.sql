set echo on
COL NAME FORMAT A32
COL VALUE FORMAT A40
SPOOL SGAPARAMS.TXT
/* Database Identification */
select NAME, PLATFORM_ID, DATABASE_ROLE from v$database;
select * from V$version where banner like 'Oracle Database%';
/* Shared Pool parameters */
select nam.ksppinm NAME, val.KSPPSTVL VALUE
from x$ksppi nam, x$ksppsv val
where nam.indx = val.indx and (nam.ksppinm like '%shared_pool%' or nam.ksppinm like '_4031%' or nam.ksppinm in ('_kghdsidx_count','_ksmg_granule_size','_memory_imm_mode_without_autosga'))
order by 1;
SPOOL OFF

SET PAGESIZE 900
SET LINESIZE 255
COL BYTES FORMAT 999999999999999
COL CURRENT_SIZE FORMAT 999999999999999
COL 'Total Shared Pool Usage' FORMAT 99999999999999999999999
set echo on

SPOOL SPINFO.TXT

/* Database Identification */
select NAME, PLATFORM_ID, DATABASE_ROLE from v$database;
select * from V$version where banner like 'Oracle Database%';

/* Shared Pool 4031 information */
select REQUEST_FAILURES, LAST_FAILURE_SIZE from V$SHARED_POOL_RESERVED;

/* Shared Pool Reserved 4031 information */
select REQUESTS, REQUEST_MISSES, free_space, avg_free_size, free_count, max_free_size from V$SHARED_POOL_RESERVED;

/* Shared Pool Memory Allocations by Size */
select name, bytes from v$sgastat
where pool = 'shared pool' and (bytes > 999999 or name = 'free memory')
order by bytes desc;


/* Current SGA Buffer & Pool sizes */

col name for a40
col value for a10

select component, current_size from v$sga_dynamic_components;

select name,value from v$system_parameter where name in ( 'memory_max_target', 'memory_target', 'sga_max_size', 'sga_target', 'shared_pool_size', 'db_cache_size', 'large_pool_size', 'java_pool_size', 'pga_aggregate_target', 'workarea_size_policy', 'streams_pool_size' ) ;


/* Shared pool Changes */

ALTER SESSION SET nls_date_format = 'DD/MM/YYYY HH:MI:SS';

COL COMPONENT FORMAT A25
COL INITIAL_SIZE FORMAT A10
COL FINAL_SIZE FORMAT A10


select component,oper_type,initial_size,target_size,final_size,status,to_char(start_time,'dd-mm-yyyy hh:mi:ss'),to_char(end_time,'dd-mm-yyyy hh:mi:ss') from v$sga_resize_ops;


SELECT COMPONENT ,OPER_TYPE,INITIAL_SIZE "Initial",FINAL_SIZE "Final",to_char(start_time,'dd-mon hh24:mi:ss') Started FROM V$MEMORY_RESIZE_OPS;


select a.ksppinm "Parameter", b.ksppstvl "Session Value", c.ksppstvl "Instance Value"
from sys.x$ksppi a, sys.x$ksppcv b, sys.x$ksppsv c
where a.indx = b.indx and a.indx = c.indx and a.ksppinm in
('__shared_pool_size','__db_cache_size','__large_pool_size','__java_pool_size','__streams_pool_size','__pga_aggregate_target','__sga_target','memory_target');


/* Library Cache Stats */
select NAMESPACE,GETHITRATIO,PINHITRATIO,RELOADS,INVALIDATIONS from v$librarycache; 
spool off

