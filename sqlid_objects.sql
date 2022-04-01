@@header

/*
*
*  Purpose    : Display objects used in a SQL Id
*  Parameters : 1 - SQLId
*               2 - SQL Child Number
*
*  Revision History:
*  ===================
*  Date       Author        Description
*  ---------  ------------  --------------------------------------------------------------------
*
*
*/


/************************************
*  INPUT PARAMETERS
************************************/
UNDEFINE sql_id
UNDEFINE child_number

DEFINE sql_id="&&1"
DEFINE child_number="&&2"


COLUMN  _child_number             NEW_VALUE child_number             NOPRINT

set term off
SELECT DECODE('&&child_number','','0','&&child_number')          "_child_number"
FROM DUAL;
set term on


PROMPT
PROMPT ***********************************************************************
PROMPT *  Objects Used in a SQL Statement
PROMPT *
PROMPT *  Input Parameters 
PROMPT *  - SQL Id       = '&&sql_id'
PROMPT *  - Child Number = '&&child_number'
PROMPT ***********************************************************************

COLUMN object_name               HEADING "TableName"                       FORMAT a25
COLUMN Object_type               HEADING "Object|Type"                     FORMAT a6
COLUMN stale_stats               HEADING "Stale|Stats"                     FORMAT a5
COLUMN stattype_locked           HEADING "Locked|Stats"                    FORMAT a5
COLUMN last_analyzed             HEADING "LastAnalyzed"                    FORMAT a18
COLUMN user_stats                HEADING "U|s|e|r"                         FORMAT a1  TRUNCATE
COLUMN sample_size               HEADING "SampleSize"                      FORMAT 9,999,999,999
COLUMN num_rows                  HEADING "RowCount"                        FORMAT 9,999,999,999
COLUMN blocks                    HEADING "Blocks"                          FORMAT 9,999,999,999
COLUMN Size_MB                   HEADING "Size(MB)"                        FORMAT 9,999,999,999
COLUMN last_ddl_time             HEADING "LastDDLTime"                     FORMAT a18
COLUMN last_specification_change HEADING "Last|Specification|Change"       FORMAT a18
COLUMN created                   HEADING "Created"                         FORMAT a18

SELECT DISTINCT 
       o.owner
     , o.object_name
     , o.subobject_name
     , REPLACE(o.object_type,'MATERIALIZED','MAT') object_type
     , TO_CHAR(o.last_ddl_time,'DD-MON-YY HH24:MI:SS') last_ddl_time
     , TO_CHAR(TO_DATE(o.timestamp,'YYYY-MM-DD HH24:MI:SS'),'DD-MON-YY HH24:MI:SS') last_specification_change
     , TO_CHAR(o.created,'DD-MON-YY HH24:MI:SS')  created
  FROM gv$sql_plan sp
       JOIN dba_objects o ON sp.object#      = o.object_id
WHERE sp.object_type IS NOT NULL
  AND sp.sql_id       = '&&sql_id'
  AND sp.child_number = '&&child_number'
ORDER BY o.owner
       , o.object_name
       , o.subobject_name
;



@@footer

