--SELECT * FROM table(dbms_xplan.display_awr(nvl('&sql_id','a96b61z6vp3un'),nvl('&plan_hash_value',null),null,'ALLSTATS +peeked_binds +PREDICATE'))
SELECT * FROM table(dbms_xplan.display_awr(nvl('&sql_id','a96b61z6vp3un'),nvl('&plan_hash_value',null),null,'typical'))
/
