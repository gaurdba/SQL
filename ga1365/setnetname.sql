col command for a200
set lines 300
set pages 0
select 'set newname for datafile '||''''||file_name ||''''|| ' to '||''''||'&&location/'||REGEXP_SUBSTR(file_name, '[^/"]+', 1, 4)||''''||';' Command from dba_data_files;
undefined location
