set pages 9999
set lines 300
select * from table(dbms_xplan.display_cursor('&sql_id','&child_no','advanced +PEEKED_BINDS +ALLSTATS +outline'));
set lines 60
