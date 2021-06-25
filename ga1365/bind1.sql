set sqlblanklines on
set trimspool on
set trimout on
set feedback off;
set linesize 300;
set pagesize 50000;
set timing off;
set head off
col sql_fulltext for a250
--
accept sql_id char prompt "Enter SQL ID ==> "
accept child_no char prompt "Enter Child Number ==> " default 0
var isdigits number
var bind_count number
--
--
col sql_fulltext for a140 word_wrap
spool &&sql_id\.sql
begin
--
-- Check for Bind Variables
--
select count(*) into :bind_count
from
V$SQL_BIND_CAPTURE
where sql_id = '&&sql_id';

--
--Check for numeric bind variable names
--
if :bind_count > 0 then
select case regexp_substr(replace(name,':',''),'[[:digit:]]') when replace(name,':','') then 1 end into :isdigits
from
V$SQL_BIND_CAPTURE
where
sql_id='&&sql_id'
and child_number = &&child_no
and rownum < 2;
end if;
end;
/
--
-- Create variable statements
--
select
case when :bind_count > 0 then
   'variable ' ||
   case :isdigits when 1 then replace(name,':','N') else substr(name,2,30) end || ' ' ||
   replace(datatype_string,'CHAR(','VARCHAR2(')
else null end txt
from
V$SQL_BIND_CAPTURE
where
sql_id='&&sql_id'
and child_number = &&child_no;
--
-- Set variable values from V$SQL_BIND_CAPTURE
--
select case when :bind_count > 0 then 'begin' else '-- No Bind Variables' end txt from dual;
select
case when :bind_count > 0 then
   case :isdigits when 1 then replace(name,':',':N') else name end ||
   ' := ' ||
   case datatype_string when 'NUMBER' then null else '''' end ||
   value_string ||
   case datatype_string when 'NUMBER' then null else '''' end ||
   ';'
else null end txt
from
   V$SQL_BIND_CAPTURE
where
   sql_id='&&sql_id'
   and child_number = &&child_no;
select case when :bind_count > 0 then 'end;' else null end txt from dual;
select case when :bind_count > 0 then '/' else null end txt from dual;
--
-- Generate statement
--
select regexp_replace(sql_fulltext,'(select |SELECT )','select /* test &&sql_id */ /*+ gather_plan_statistics */ ',1,1) sql_fulltext from (
select case :isdigits when 1 then replace(sql_fulltext,':',':N') else sql_fulltext end ||';' sql_fulltext
from v$sqlarea
where sql_id = '&&sql_id');
--
spool off;
undef sql_id
undef child_no
set feedback on;
set head on

