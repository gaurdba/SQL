set lines 155
set pages 9999
SELECT * FROM table(dbms_xplan.display_awr(nvl('&sql_id','a96b61z6vp3un'),nvl('&plan_hash_value',null),null,'advanced -ALIAS +PEEKED_BINDS +ALLSTATS -PROJECTION +PARALLEL'))
/

