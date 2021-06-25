col sid for 9999999
select
   ss.username,
   se.SID,ss.sql_id,
   VALUE/100 cpu_usage_seconds
from
   v$session ss,
   v$sesstat se,
   v$statname sn
where VALUE/100 >0 and
   se.STATISTIC# = sn.STATISTIC#
and
   NAME like '%CPU used by this session%'
and
   se.SID = ss.SID
and
   ss.status='ACTIVE'
and
   ss.username is not null
order by VALUE desc
/
