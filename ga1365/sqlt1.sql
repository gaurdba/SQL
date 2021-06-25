set serveroutput on
set long 500000
set lines 350
set pages 3000
col recommendations for a240

var c_tt refcursor

DECLARE
    r CLOB;
    --r varchar2(32767);
    t varchar2(30) := 'SQLT11_&1';
BEGIN

    begin
        dbms_sqltune.drop_tuning_task(t);
    exception
        when others then null;
    end;

    r := DBMS_SQLTUNE.create_tuning_task (begin_snap => &2,end_snap => &3,sql_id => '&1',scope => DBMS_SQLTUNE.scope_comprehensive,time_limit => 1800,task_name => 'SQLT11_&1',description => 'Tuning task for statement &1 in AWR.');
    dbms_output.put_line('r='||r);
dbms_output.put_line('r='||r);
    dbms_sqltune.execute_tuning_task(t);

END;
/

SELECT DBMS_SQLTUNE.report_tuning_task('SQLT11_&1') AS recommendations FROM dual;

