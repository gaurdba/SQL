spool tmp/fix_stat.sql
select 'exec dbms_stats.drop_stat_table(ownname =>'||''''||tab.owner||''''||', stattab => ''SAVED_STATISTICS1'');' from (select distinct owner from dba_tab_statistics) tab;
ALTER SESSION SET NLS_LENGTH_SEMANTICS = BYTE;
select 'exec dbms_stats.create_stat_table(ownname =>'||''''||tab.owner||''''||', stattab => ''SAVED_STATISTICS1'');' from (select distinct owner from dba_tab_statistics) tab;
spool off
@tmp/fix_stat.sql
