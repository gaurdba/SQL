undefine sql_id
undefine begin_snap_id
undefine end_snap_id
set serveroutput on
set verify off
DECLARE
    t varchar2(30) := 'SQLT_baseline_&&sql_id';
  begin
       DBMS_SQLTUNE.drop_sqlset('SQLT_baseline_&&sql_id');
    exception
        when others then null;
    end;
/
exec DBMS_SQLTUNE.CREATE_SQLSET(SQLSET_NAME =>  'SQLT_baseline_&&sql_id', DESCRIPTION => 'Turning Set for &&sql_id  ');
WITH
p AS (
SELECT DISTINCT plan_hash_value
  FROM gv$sql_plan
 WHERE sql_id = TRIM('&&sql_id.')
   AND other_xml IS NOT NULL ),
m AS (
SELECT plan_hash_value,
       SUM(elapsed_time)/SUM(executions) avg_et_secs
  FROM gv$sql
 WHERE sql_id = TRIM('&&sql_id.')
   AND executions > 0
 GROUP BY
       plan_hash_value )
SELECT p.plan_hash_value,
       ROUND(m.avg_et_secs/1e6, 3) avg_et_secs
  FROM p, m
 WHERE p.plan_hash_value = m.plan_hash_value
 ORDER BY
       avg_et_secs NULLS LAST;

declare
baseline_ref_cur DBMS_SQLTUNE.SQLSET_CURSOR;
begin_snap_id number;
end_snap_id number;
plans NUMBER;
text varchar2(20);
sqlid varchar2(30);
begin
select /*+ parallel(4) */ min(snap_id),max(snap_id) into begin_snap_id,end_snap_id from dba_hist_sqlstat sq and DBA_HIST_SNAPSHOT ss where sql_id='&&sql_id' and plan_hash_value=&&plan_hash_value and  ss.snap_id=sq.snap_id and BEGIN_INTERVAL_TIME>=(sysdate - &days);
open baseline_ref_cur for
select VALUE(p) from table(
DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(begin_snap_id, end_snap_id,'sql_id='||CHR(39)||'&sql_id'||CHR(39)||' and plan_hash_value='||&&plan_hash_value,NULL,NULL,NULL,NULL,NULL,NULL,'ALL')) p;
DBMS_SQLTUNE.LOAD_SQLSET('SQLT_baseline_&&sql_id', baseline_ref_cur);
select sql_id, substr(sql_text,1, 15) into sqlid,text
from dba_sqlset_statements 
where sqlset_name = 'SQLT_baseline_&&sql_id'
order by sql_id;
DBMS_OUTPUT.PUT_LINE(text);
plans := dbms_spm.load_plans_from_sqlset (
sqlset_name => 'SQLT_baseline_&&sql_id',
sqlset_owner => 'OE',
fixed => 'YES',
enabled => 'YES');
DBMS_OUTPUT.PUT_LINE('Plans Loaded: '||plans);
end;
/
col first_load_time for a12
col parsing_schema_name for a15
col sql_id for a15
set lines 300
SELECT
  first_load_time          ,
  executions as execs              ,
  parsing_schema_name      ,
  elapsed_time  / 1000000 as elapsed_time_secs  ,
  cpu_time / 1000000 as cpu_time_secs           ,
  buffer_gets              ,
  disk_reads               ,
  direct_writes            ,
  rows_processed           ,
  fetches                  ,
  plan_hash_value          ,
  sql_id                   
   FROM TABLE(DBMS_SQLTUNE.SELECT_SQLSET(sqlset_name => 'SQLT_baseline_&&sql_id'));
undefine all
