set long 200000 pages 0 lines 131 doc off
column ddl format a121 word_wrapped
select dbms_metadata.get_ddl(upper('&Object_type'),upper('&Object_name'),upper('&Owner')) ddl from dual;