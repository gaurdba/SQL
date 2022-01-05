@@header

/*
*
*  Purpose    : Create SQL Profile
*  Parameters : 1 - SQL ID
*               2 - PLAN_HASH_VALUE
*               3 - SQL Profile Categor, usually "DEFAULT"
*               4 - FORCE_MATCH, possibile values - TRUE or FALSE
*               5 - SQL Profile Description
*          
*
*
*/

UNDEFINE SQLID
UNDEFINE PLAN_HASH_VALUE
UNDEFINE CATEGORY
UNDEFINE FORCE_MATCH
UNDEFINE DESCRIPTION

DEFINE SQLID="&&1" 
DEFINE PLAN_HASH_VALUE="&&2"
DEFINE CATEGORY="&&3"
DEFINE FORCE_MATCH="&&4"
DEFINE DESCRIPTION="&&5"

set serveroutput on
declare
     ar_profile_hints sys.sqlprof_attr;
     cl_profile_hints    clob;
     cl_sql_text         clob;
     buffer              VARCHAR2(4000);
     l_profile_name      VARCHAR2(30) := 'PROF_' || '&&SQLID' || '_' || '&&PLAN_HASH_VALUE';
begin

  SELECT sql.sql_text 
    INTO cl_sql_text 
    FROM dba_hist_sqltext sql
       , v$database d
    WHERE d.dbid = sql.dbid
      AND sql.sql_id = '&&SQLID';

    SELECT XMLQuery( '/*/outline_data'  passing  xmltype(other_xml) RETURNING CONTENT ).getClobVal()  xmlval
     INTO cl_profile_hints
     FROM dba_hist_sql_plan s
        , v$database d
    WHERE d.dbid = s.dbid
      AND sql_id           = '&&SQLID'
      AND plan_hash_value  = &&PLAN_HASH_VALUE
      AND other_xml IS NOT NULL
      ;

     dbms_sqltune.import_sql_profile(  sql_text    => cl_sql_text
                                     , profile_xml => cl_profile_hints
                                     , category    => '&&CATEGORY'
                                     , name        => l_profile_name
                                     , description => '&&DESCRIPTION'
                                     , force_match => &&FORCE_MATCH
                                     , validate    => TRUE
                                     , replace     => FALSE
      );


/*
Sometimes hint are larger than 500 character and it was failing with following error. 
So modified this script to use CLOB instead of array of VARCHAR2(500) from sys.sqlprof_attr type.

ORA-06502: PL/SQL: numeric or value error: Bulk Bind: Truncated Bind

*/      
      
--      SELECT extractvalue(value(a), '/hint') AS outline_hints 
--      bulk collect
--      INTO ar_profile_hints
--      FROM xmltable('/*/outline_data/hint' passing  (SELECT xmltype(other_xml) AS xmlval
--                                                       FROM dba_hist_sql_plan s
--                                                          , v$database d
--                                                      WHERE d.dbid = s.dbid
--                                                        AND sql_id           = '&&SQLID'
--                                                        AND plan_hash_value  = &&PLAN_HASH_VALUE
--                                                       AND other_xml IS NOT NULL
--                                                     ) 
--                   ) a;

/*
     dbms_sqltune.import_sql_profile(  sql_text    => cl_sql_text
                                     , profile     => ar_profile_hints
                                     , category    => '&&CATEGORY'
                                     , name        => l_profile_name
                                     , description => '&&DESCRIPTION'
                                      -- use force_match => true,  to use CURSOR_SHARING=SIMILAR
                                      -- behaviour, i.e. match even with differing literals
                                    , force_match  => &&FORCE_MATCH
                                 -- , replace      => true
      );
*/
  

      
      dbms_output.put_line(' ');
      dbms_output.put_line('SQL Profile '||l_profile_name||' created.');
      dbms_output.put_line(' ');

end;
/

@@footer
