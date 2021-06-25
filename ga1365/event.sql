 col SQL_ID for a20
set lines 300
 col EVENT for a50
prompt ************************************
prompt **** ASH OVERALL WAIT PROFILE
prompt ************************************
SELECT MIN(sample_time) min_ash_available,sysdate-MIN(sample_time) available_duration FROM v$active_session_history;
 
select * from (
select NVL(event,'CPU') event,count(*),
round((ratio_to_report(sum(1)) over ()*100),1) rr
from gv$active_session_history
WHERE user_id<>0
AND sample_time<trunc(SYSDATE+1) AND sample_time>trunc(sysdate-1)
group by event
order by 2 desc
) where rownum<10;
 
prompt ************************************
prompt **** ASH I/O by SQL_ID
prompt ************************************
 set pages 200
COLUMN force_matching_signature FOR 999999999999999999999999999
select * from (
select
sql_id ,sql_plan_hash_value,force_matching_signature,
NVL(event,'CPU') Event,
count(*),
round((ratio_to_report(sum(1)) over ()*100),1) "RR"
from gv$active_session_history
where
1=1
AND wait_class LIKE '%I/O'
--AND event IS null
and user_id<>0
AND sql_id IS NOT NULL
group by
sql_id,sql_plan_hash_value,event,force_matching_signature
order by 5 desc
) where rownum<30;
