set lines 300
col DESCRIPTION for a50
col broken for a10
set pages 100
col interval for a55
SELECT  job,last_date, next_date,INTERVAL, failures, broken, SUBSTR(what,1,40) DESCRIPTION FROM dba_jobs where to_char(job)  like '%&job%';