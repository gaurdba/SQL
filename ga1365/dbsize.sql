col "DB Size(GB)" for a30
select to_char((sum(bytes/1073741824)),'9999.99') "DB Size(GB)" from dba_segments
/
