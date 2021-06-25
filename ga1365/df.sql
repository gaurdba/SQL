SET LINESIZE 300
COLUMN "Tablespace Name" FORMAT A20
COLUMN "File Name" FORMAT A80
 
SELECT  Substr(df.tablespace_name,1,20) "Tablespace Name",
        Substr(df.file_name,1,80) "File Name",
        g.TotalSpace "Size (M)",
        decode(e.used_bytes,NULL,0,Round(e.used_bytes,0)) "Used (M)",
        round(g.TotalSpace - e.used_bytes) "Free (M)",
		round(100 * (e.used_bytes/g.TotalSpace)) "% Used"
		FROM    DBA_DATA_FILES DF,
       (SELECT file_id,sum(bytes/1024/1024) used_bytes 
	     FROM dba_extents
        GROUP by file_id) E,
       (SELECT Max(bytes/1024/1024) free_bytes,
               file_id
        FROM dba_free_space
        GROUP BY file_id) f,(select tablespace_name, round(sum(GREATEST(bytes,maxbytes)) / 1024/1024) TotalSpace
from dba_data_files group by tablespace_name) g
WHERE    e.file_id (+) = df.file_id and df.tablespace_name=upper('&Tablespace_name')
AND      df.file_id  = f.file_id (+) and df.tablespace_name=g.tablespace_name
ORDER BY df.tablespace_name,
         df.file_name
/
