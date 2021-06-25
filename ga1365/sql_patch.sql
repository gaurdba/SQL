SET SERVEROUT ON SIZE 1000000

DECLARE
    v_sql_text  CLOB;
    ret         VARCHAR2(100);
BEGIN
    -- rownum = 1 because there may be multiple children with this SQL_ID
    DBMS_OUTPUT.PUT_LINE(q'[Looking up SQL_ID &1]');
    SELECT sql_fulltext INTO v_sql_text FROM v$sql WHERE sql_id = '&1' AND rownum = 1;
    DBMS_OUTPUT.PUT_LINE('Found: '||SUBSTR(v_sql_text,1,80)||'...');

    -- TODO: should use PL/SQL conditional compilation here 
    -- The leading space in hint_text is intentional.

    -- 12.2+
    ret := DBMS_SQLDIAG.CREATE_SQL_PATCH(sql_id=>'&1', hint_text=>q'[ &2]', name=>'SQL_PATCH_&1');

    -- 11g and 12.1
    --DBMS_SQLDIAG_INTERNAL.I_CREATE_PATCH(sql_text=>v_sql_text, hint_text=>q'[ &2]', name=>'SQL_PATCH_&1');
    DBMS_OUTPUT.PUT_LINE(q'[SQL Patch Name = SQL_PATCH_&1]');
END;
/

SET SERVEROUT OFF
