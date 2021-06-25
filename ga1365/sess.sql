select status,count(*) from v$session where username is not null group by status
/
