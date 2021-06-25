col GRANTEE for a20
col PRIVILEGE for a20
col ADMIN_OPTION for a15
set lines 200
select * from dba_sys_privs where GRANTEE=upper(trim('&username'))
/
