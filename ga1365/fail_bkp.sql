set serveroutput on 
Declare
cursor bkp is 
select distinct bjs.DB_NAME,backup_type||incremental_level lvl_bkp,bjs.status,bjs.start_time
from rc_rman_backup_job_details bjs,rc_BACKUP_SET_DETAILS  bst 
where bjs.start_time >  (trunc(sysdate) - 1 + (18/24)) and 
(bjs.status like '%FAIL%' or bjs.status like '%WARN%') and bjs.DB_NAME!='S9999100' and backup_type!='L'  and 
bjs.db_name=bst.db_name and bjs.db_key=bst.db_key order by bjs.DB_NAME;
Begin
dbms_output.put_line('<-------------------------------------------------------------------------------------------------->');
dbms_output.put_line('DB_Name			Level		Start_Time			Status');
dbms_output.put_line('<-------------------------------------------------------------------------------------------------->');
for cur in bkp
loop
CASE cur.lvl_bkp
WHEN 'D'THEN 
dbms_output.put_line(cur.db_name||'		'||'L0'||'		'||cur.start_time||'		'||cur.status);
WHEN 'D0'THEN dbms_output.put_line(cur.db_name||'		'||'L0'||'		'||cur.start_time||'		'||cur.status);
WHEN 'I1'THEN dbms_output.put_line(cur.db_name||'		'||'L1'||'		'||cur.start_time||'		'||cur.status);
END CASE;
end loop;
end;
/
