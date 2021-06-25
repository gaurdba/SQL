col segment_name for a30
set lines 200
select segment_name,sum(bytes/1024/1024) from dba_segments 
where segment_name like nvl(upper('&Segment_Name'),segment_name) and owner like nvl(upper('&Owner'),Owner) group by segment_name order by 2;
