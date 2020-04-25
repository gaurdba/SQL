/*
*
*  Purpose       : Diplay foreign key table(s) details
*  Compatibility : 10.1 and above
*  Parameters    : 1 - OWNER
*                  2 - TABLE_NAME
**/
COL p_table for a45
col p_column for a25
col cons for a30
col child_table for a45
col child_cons for a30
COL C_Col for a30
COL child_cons_type for a12
set lines 300 pages 20 feedback off verify off
VARIABLE table_name  VARCHAR2(50)
VARIABLE owner   VARCHAR2(50)
BEGIN
        :owner:=upper('&&1');
        :table_name:=upper('&&2');
END;
/
WITH ptable AS (
    SELECT
        cons.owner,
        cons.table_name,
        column_name,
        cons.constraint_name,
        constraint_type
    FROM
        dba_constraints cons,
        dba_cons_columns col
    WHERE
        cons.constraint_name = col.constraint_name
	AND cons.owner=:owner
        AND cons.table_name = :table_name
        AND cons.constraint_type IN (
            'P',
            'U'
        )
)
SELECT
    ptable.owner||'.'||ptable.table_name p_table,ptable.column_name p_column,DECODE(ptable.constraint_type,'P','Primary','U'',UNIQUE') cons,
    c.owner
    || '.'
    || c.table_name Child_table,
    c.constraint_name child_cons,col.column_name C_Col,
    DECODE(c.constraint_type,'R','FK') child_cons_type
FROM
    dba_constraints c,
    ptable,
    dba_cons_columns col
WHERE
    ptable.constraint_name = c.R_constraint_name and col.constraint_name=c.R_constraint_name;
