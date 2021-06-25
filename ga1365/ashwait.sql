col EVENT format a30
set pagesize 100
set lin 200
prompt ************************************
prompt **** ASH I/O by SQL_ID
prompt ************************************

COLUMN force_matching_signature FOR 999999999999999999999999999
select * from (
select
sql_id ,sql_plan_hash_value,force_matching_signature,
NVL(event,'CPU') Event,
count(*),
round((ratio_to_report(sum(1)) over ()*100),1) rr
from gv$active_session_history
where
1=1
AND event LIKE '%&wait%'
--AND event IS null
and user_id<>0
AND sql_id IS NOT NULL
group by
sql_id,sql_plan_hash_value,event,force_matching_signature
order by 5 desc
) where rownum<30;
