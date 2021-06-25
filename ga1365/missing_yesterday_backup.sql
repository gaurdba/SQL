set lines 100
set feedback off
select DB_NAME, DB_KEY from   rc_rman_backup_job_details rbd
      where  start_time >  (trunc(sysdate) - 6 + (18/24)) and DB_name not IN ('P1AC','P1CUST','P1USG1' ,'P1USG2','E1AC','E1CUST','E1USG1' ,'E1USG2') and ((db_name like 'P%')or (db_name like 'E%')) 
	  minus
	select DB_NAME, DB_KEY
    from RC_BACKUP_PIECE_DETAILS
    where  ((INCREMENTAL_LEVEL = 0 ) or (INCREMENTAL_LEVEL = 1 ) or ( BACKUP_TYPE='I') )and    start_time > trunc(sysdate - 1) 
    group  by DB_NAME, DB_KEY, INCREMENTAL_LEVEL
	order by 1
	/
	
