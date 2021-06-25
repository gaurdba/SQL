
SET LONG 1000000
SET LONGCHUNKSIZE 1000000
SET LINESIZE 1000
SET PAGESIZE 0
SET TRIM ON
SET TRIMSPOOL ON
SET ECHO OFF
SET FEEDBACK OFF
SELECT DBMS_SQL_MONITOR.report_sql_monitor(
  sql_id    => '&sql_id',
  --sql_exec_id => 'sql_exec_id',
  type         => 'TEXT',
  report_level => 'ALL') AS report
FROM dual;


--Jab koi bug existing version(11g) me hit ho rhi ho aur uska patch latest release(12.2) me available hain then..Oracle support ko bolte hain ki existing version ke liye backport patch request raise kare.
