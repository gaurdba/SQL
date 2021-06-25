col EVENT for a50
select event,count(*) 
from DBA_HIST_ACTIVE_SESS_HISTORY ash,DBA_HIST_SNAPSHOT s 
where event is not null and ash.snap_id=s.snap_id  and BEGIN_INTERVAL_TIME >=systimestamp - &number_of_min/1440 group by event order by 2 desc;
