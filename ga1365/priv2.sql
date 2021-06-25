set serveroutput on size 1000000 format wrapped
alter session set global_names=false

set pages 10000
set line 500
set long 999999
set verify off
set heading off
set feedback off

set termout off
set echo off

column v_spool_database new_value v_spool_database
column v_spool_time     new_value v_spool_time
column v_user           new_value v_user

select  SYS_CONTEXT('userenv','DB_NAME')        v_spool_database
,       to_char(sysdate, 'DD-Mon-YYYY_HH24-MI') v_spool_time
,       user                                    v_user
from   dual;


Drop   table NLSOD_SECURITY_PRIVS;
Create table NLSOD_SECURITY_PRIVS ( banner varchar2(4000)) tablespace users;

spool ${HOME}/log/&v_spool_database._&v_user._&v_spool_time.-SecPrivs.log

set termout on

Declare
  cursor c_usr is
    select username from dba_users where username =upper('&username')
        order by username
  ;
  cursor c_sys(p_grantee in varchar2) is
    select privilege from dba_sys_privs where grantee = p_grantee
and privilege not in ('CREATE SESSION')
    order  by privilege
  ;
  cursor c_rol (p_user in varchar2) is
    select grantee, granted_role, priv_type
    ,      replace(SYS_CONNECT_BY_PATH(granted_role,' => '),' => '||p_user||' => ') roles
    from   (
           /* THE USERS */
             select null grantee, username granted_role, 'USR' priv_type
             from   dba_users
             where  username = p_user
           /* THE ROLES TO ROLES RELATIONS */
             union
             select grantee, granted_role, 'ROLE' priv_type
             from   dba_role_privs where granted_role not in ('CONNECT', 'RESOURCE', 'CREATE SESSION') 
           /* THE ROLES TO PRIVILEGE RELATIONS */
           )
           start   with grantee is null
           connect by   grantee = prior granted_role
  ;
--
  l_cnt       number(1);
  l_inst      varchar2(16);
  l_statement varchar2(4000);
Begin
  select INSTANCE_NAME into l_inst from v$instance;
  for r_usr in c_usr loop
    for r_sys in c_sys(r_usr.USERNAME) loop
      insert into NLSOD_SECURITY_PRIVS values
      ('Instance '||l_inst||': grantee "'||r_usr.USERNAME||'" is granted privilege "'||r_sys.PRIVILEGE||'" via direct grant');
    end loop;  --  r_sys in c_sys(r_usr.USERNAME)
  --
    for r_rol in c_rol(r_usr.USERNAME) loop
      for r_sys in c_sys(r_rol.GRANTED_ROLE) loop
        if r_rol.PRIV_TYPE = 'ROLE' then
          insert into NLSOD_SECURITY_PRIVS values
          ('Instance '||l_inst||': grantee "'||r_usr.USERNAME||'" is granted privilege "'||r_sys.PRIVILEGE||'" via roles: '||r_rol.ROLES);
        end if;
      end loop;  -- r_sys in c_sys(r_rol.GRANTED_ROLE)
    end loop;  --  r_rol in c_rol(r_usr.USERNAME)
  end loop;  --  r_usr in c_usr
  commit;
End;
/

select banner from NLSOD_SECURITY_PRIVS;

spool off

drop table NLSOD_SECURITY_PRIVS;

set feedback on
set heading on
set verify on


