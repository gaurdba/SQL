select DB_NAME, DB_KEY from   rc_rman_backup_job_details rbd
      where  start_time >  (trunc(sysdate) - 8+ (18/24)) and DB_name not IN ('P1AC','P1CUST','P1USG1' ,'P1USG2','E1AC', 'E1CUST','E1USG1','E1USG2')
	  minus
	select DB_NAME, DB_KEY
    from RC_BACKUP_PIECE_DETAILS
    where  (INCREMENTAL_LEVEL = 0 ) and    start_time > trunc(sysdate - 8)
    group  by DB_NAME, DB_KEY, INCREMENTAL_LEVEL
	/
	
    
