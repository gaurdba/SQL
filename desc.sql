/*
*
*  Purpose       : Display table's column(s)
*  Compatibility : 10.1 and above
*  Parameters    : 1 - OWNER
*                  2 - TABLE_NAME
                   3 - Column Name (Default All)
**/
undefine &3
VARIABLE table_name  VARCHAR2(50)
VARIABLE owner   VARCHAR2(50)
VARIABLE column_name   VARCHAR2(50)
BEGIN
	:owner:=upper('&&1');
	:table_name:=upper('&&2');
	:column_name:=upper(nvl('&3','%'));
END;
/
COL owner for a30
COL table_name for a45
COL column_name for a30
COL data_type for a35
SET LINES 300 PAGES 100
SET VERIFY on
SELECT
    owner,
    table_name,
    column_name,
    CASE
        WHEN data_type = 'VARCHAR2' THEN data_type|| '('|| DECODE(char_length, 0, '', char_length)||decode(CHAR_USED,'C',' CHAR','')|| ')'||DECODE(NULLABLE,'N',' Not Null')
        WHEN data_type = 'NUMBER' THEN data_type|| '('|| data_precision||','||data_scale|| ')'||DECODE(NULLABLE,'N',' Not Null')
        WHEN data_type = 'DATE' THEN data_type ELSE data_type||DECODE(NULLABLE,'N',' Not Null')
    END AS data_type  
    FROM
    dba_tab_columns
WHERE
    owner=:owner AND
    table_name = :table_name AND
    column_name  LIKE NVL(:column_name,'%')
    ;



undefine &1
undefine &2
undefine column_name
