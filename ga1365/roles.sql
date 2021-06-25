ANTEE for a20
col GRANTED_ROLE for a30
col DEFAULT_ROLE for a15
col ADMIN_OPTION for a15
col GRANTEE for a15
set lines 200
select * from dba_role_privs where GRANTEE=upper(trim('&GRANTEE'));
