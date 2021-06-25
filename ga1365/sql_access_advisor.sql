alter session set current_schema=ga0145;
prompt "Enter SQL ID for Access Adviser==>" for sql_id
EXEC DBMS_SQLTUNE.CREATE_SQLSET(sqlset_name => 'saa_1_&&SQL_Id', description => 'STS for sql_id &&SQL_ID' , sqlset_owner=>'GA0145');
DECLARE
  cursor1 DBMS_SQLTUNE.SQLSET_CURSOR;
BEGIN
  OPEN cursor1 FOR SELECT VALUE(p)
  FROM TABLE(DBMS_SQLTUNE.SELECT_CURSOR_CACHE('sql_id = ''&&sql_id'' and plan_hash_value=''1654789573''')) p;
  DBMS_SQLTUNE.LOAD_SQLSET(sqlset_name => 'saa_1_&&sql_id', populate_cursor => cursor1);
END;
/
DECLARE
  task_id NUMBER;
  task_name VARCHAR2(30);
  workload_name VARCHAR2(30);
  saved NUMBER;
  failed NUMBER;
BEGIN
  task_name := 'Task_&&sql_id';
  workload_name := 'Workload_&&sql_id';
	dbms_output.put_line('create SQL Access Advisor Task');
   DBMS_ADVISOR.CREATE_TASK('SQL Access Advisor', task_id, task_name, 'Task for sql_id &&sql_id');
	 dbms_output.put_line('create SQL Access Advisor  Workload');
  DBMS_ADVISOR.CREATE_SQLWKLD(workload_name, 'Workload for sql_id &&sql_id');
dbms_output.put_line('add workload');
  DBMS_ADVISOR.ADD_SQLWKLD_REF(task_name, workload_name);
   dbms_output.put_line('import workload');
  DBMS_ADVISOR.IMPORT_SQLWKLD_STS(workload_name,'ga0145', 'Workload_&&sql_id', 'NEW', 1, saved, failed);
   dbms_output.put_line('execute task'); 
  DBMS_ADVISOR.EXECUTE_TASK(task_name);
END;
/
