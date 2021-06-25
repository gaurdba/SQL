select * from table(dbms_workload_repository.awr_sql_report_text(&dbid, &inst_id, '&begin_snapid', '&end_snapid', '&sql_id'));
