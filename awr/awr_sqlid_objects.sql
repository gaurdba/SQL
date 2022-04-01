@@header

/*
*
*  Purpose    : Display objects used in a SQL Id
*  Parameters : 1 - SQLId
*               2 - SQL Child Number
*
*
*
*/


/************************************
*  INPUT PARAMETERS
************************************/
UNDEFINE sql_id
UNDEFINE plan_hash_value

DEFINE sql_id="&&1"
DEFINE plan_hash_value="&&2"



PROMPT
PROMPT ***********************************************************************
PROMPT *  Objects Used in a SQL Statement
PROMPT *
PROMPT *  Input Parameters 
PROMPT *  - SQL Id          = '&&sql_id'
PROMPT *  - Plan Hash Value = '&&plan_hash_value'
PROMPT ***********************************************************************

COLUMN object_name               HEADING "TableName"                       FORMAT a50
COLUMN Object_type               HEADING "Object|Type"                     FORMAT a15
COLUMN Size_MB                   HEADING "Size(MB)"                        FORMAT 9,999,999,999
COLUMN last_ddl_time             HEADING "LastDDLTime"                     FORMAT a18
COLUMN last_specification_change HEADING "Last|Specification|Change"       FORMAT a18
COLUMN created                   HEADING "Created"                         FORMAT a18

SELECT DISTINCT 
       o.owner || '.' || o.object_name  || NVL2(o.subobject_name,':' || o.subobject_name, '') object_name
     , REPLACE(o.object_type,'MATERIALIZED','MAT') object_type
     , TO_CHAR(o.last_ddl_time,'DD-MON-YY HH24:MI:SS') last_ddl_time
     , TO_CHAR(TO_DATE(o.timestamp,'YYYY-MM-DD HH24:MI:SS'),'DD-MON-YY HH24:MI:SS') last_specification_change
     , TO_CHAR(o.created,'DD-MON-YY HH24:MI:SS')  created
  FROM dba_hist_sql_plan sp
       JOIN dba_objects o ON o.owner = sp.object_owner AND o.object_name = sp.object_name AND ( sp.object# = o.object_ID OR o.object_type not like '%PARTITION')
       /* Dont join by object id, as it does not cover cases when object has been dropped and recreated*/
WHERE sp.object_type IS NOT NULL
  AND sp.sql_id          = '&&sql_id'
  AND sp.plan_hash_value = '&&plan_hash_value'
ORDER BY 1
;



@@footer
