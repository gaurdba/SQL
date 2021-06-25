select segment_name,bytes/1024/1024 from dba_segments where SEGMENT_NAME='&segment_name' and  owner='&owner';
