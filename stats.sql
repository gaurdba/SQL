@@header

/*
*
*  Author     : Vishal Gupta
*  Purpose    : Display Statistics of a table (including part, sub-par, ind, ind-part, ind-subpart)
*  Parameters : 1 - OWNER               (% - wildchar, \ - escape char)
*               2 - Table Name          (% - wildchar, \ - escape char) 
*               3 - Parition Name       (% - wildchar, \ - escape char)
*               4 - Sub-Parition Name   (% - wildchar, \ - escape char)
*               5 - Object Type         (% - wildchar, \ - escape char)
*               
*
*  Revision History:
*  ===================
*  Date       Author        Description
*  ---------  ------------  -----------------------------------------
*  30-Jul-15  Vishal Gupta  Increased sizes of LeafBlocks and SampleSize columns
*  27-Jun-12  Vishal Gupta  Added parition, sub-parition and objecttype as input
*  31-May-12  Vishal Gupta  Changed output formatting
*  16-Mar-12  Vishal Gupta  Intial version
*
*
*/


/************************************
*  INPUT PARAMETERS
************************************/
UNDEFINE owner
UNDEFINE table_name
UNDEFINE partition_name
UNDEFINE subpartition_name
UNDEFINE object_type

DEFINE owner="&&1"
DEFINE table_name="&&2"
DEFINE partition_name="&&3"
DEFINE subpartition_name="&&4"
DEFINE object_type="&&5"

COLUMN  _owner             NEW_VALUE owner             NOPRINT
COLUMN  _table_name        NEW_VALUE table_name        NOPRINT
COLUMN  _partition_name    NEW_VALUE partition_name    NOPRINT
COLUMN  _subpartition_name NEW_VALUE subpartition_name NOPRINT
COLUMN  _object_type       NEW_VALUE object_type       NOPRINT

set term off
SELECT CASE 
           WHEN INSTR('&&owner','.') != 0 THEN SUBSTR(UPPER('&&owner'),1,INSTR('&&owner','.')-1) 
           ELSE DECODE(UPPER('&&owner'),'','%',UPPER('&&owner')) 
       END                                                          "_owner"
     , CASE 
           WHEN INSTR('&&owner','.') != 0 THEN SUBSTR(UPPER('&&owner'),INSTR('&&owner','.')+1) 
           ELSE DECODE(UPPER('&&table_name'),'','%',UPPER('&&table_name')) 
       END                                                          "_table_name"
     , DECODE('&&partition_name','','%','&&partition_name')         "_partition_name"
     , DECODE('&&subpartition_name','','%','&&subpartition_name')   "_subpartition_name"
     , DECODE('&&object_type','','%','&&object_type')               "_object_type"
FROM DUAL;
set term on



PROMPT
PROMPT ***********************************************************************
PROMPT *  T A B L E    S T A T I S T I C S
PROMPT *
PROMPT *  Input Parameters 
PROMPT *  - Table Owner       = '&&owner'
PROMPT *  - Table Name        = '&&table_name'
PROMPT *  - Partition Name    = '&&partition_name'
PROMPT *  - SubPartition Name = '&&subpartition_name'
PROMPT *  - Object Type       = '&&object_type'
PROMPT ***********************************************************************

COLUMN owner                   HEADING "Owner"                    FORMAT a20
COLUMN table_name              HEADING "TableName"                FORMAT a60
COLUMN object_type             HEADING "Object|Type"              FORMAT a12
COLUMN object_type_sort_order                                                    NOPRINT
COLUMN partition_name          HEADING "Partition"                FORMAT a25
COLUMN partition_position      HEADING "Part|Pos"                 FORMAT 999
COLUMN subpartition_name       HEADING "Sub-Partition"            FORMAT a25
COLUMN subpartition_position   HEADING "Sub|Part|Pos"             FORMAT 999
--COLUMN stattype_locked         HEADING "Lock|Stat"                FORMAT a4
--COLUMN global_stats            HEADING "Global|Stat"              FORMAT a5
--COLUMN user_stats              HEADING "User|Stat"                FORMAT a4
--COLUMN stale_stats             HEADING "Stale|Stat"               FORMAT a5
--COLUMN stattype_locked         HEADING "Lock|Stat"                FORMAT a4
COLUMN global_stats            HEADING "G|l|o|b|a|l"              FORMAT a1  TRUNCATE
COLUMN user_stats              HEADING "U|s|e|r"                  FORMAT a1  TRUNCATE
COLUMN stale_stats             HEADING "S|t|a|l|e"                FORMAT a1  TRUNCATE
COLUMN stattype_locked         HEADING "L|o|c|k"                  FORMAT a1  TRUNCATE
COLUMN last_analyzed           HEADING "Last|Analyzed"            FORMAT a18
COLUMN SizeMB                  HEADING "Size (MB)"                FORMAT 99,999,999
COLUMN sample_size             HEADING "Sample|Size"              FORMAT 99,999,999,999
COLUMN num_rows                HEADING "Row|Count"                FORMAT 99,999,999,999
COLUMN blocks                  HEADING "Blocks"                   FORMAT 999,999,999
COLUMN empty_blocks            HEADING "Empty|Blocks"             FORMAT 99,999,999
COLUMN avg_space               HEADING "Avg|Space"                FORMAT 999,999
COLUMN chain_cnt               HEADING "Chain|Count"              FORMAT 999,999
COLUMN avg_row_len             HEADING "Avg|Row|Length"           FORMAT 9999


select 
       s.owner || '.' || s.table_name 
       || NVL2(s.partition_name,':' || s.partition_name, '')
       || NVL2(s.subpartition_name,':' || s.subpartition_name, '')
       table_name
     , s.object_type
     , DECODE (s.object_type
           , 'TABLE'        ,1
           , 'PARTITION'    ,2
           , 'SUBPARTITION' ,3
           ,9
           ) object_type_sort_order         
     , stattype_locked
     , global_stats
     , user_stats
     , stale_stats
     , to_char(last_analyzed,'DD-MON-YY HH24:MI:SS') last_analyzed
     , (s.blocks * p.value) /1024/1024  SizeMB
     , num_rows
     , s.blocks 
     , empty_blocks
     , avg_space
     , chain_cnt
     , avg_row_len
     , sample_size
 FROM dba_tab_statistics s
    , v$system_parameter p
WHERE p.name = 'db_block_size'
  AND s.table_name NOT LIKE 'BIN$%'
  AND s.owner                     LIKE upper('&&owner')   ESCAPE '\'
  AND s.table_name                LIKE upper('&&table_name') ESCAPE '\'
  AND NVL(s.partition_name,'%')    LIKE upper('&&partition_name') ESCAPE '\'
  AND NVL(s.subpartition_name,'%') LIKE upper('&&subpartition_name') ESCAPE '\'
  AND NVL(DECODE(s.object_type
               ,'PARTITION','TABLE PARTITION'
               ,'SUBPARTITION','TABLE SUBPARTITION'
               ,s.object_type),'%')       LIKE upper('&&object_type') ESCAPE '\'
ORDER BY owner
       , s.table_name
       , s.object_type DESC
       , s.partition_position
       , s.subpartition_position
/

PROMPT
PROMPT  ***********************************
PROMPT  *  Index Statistics 
PROMPT  ***********************************

COLUMN table_name               HEADING "TableName"                 FORMAT a30
COLUMN index_name               HEADING "IndexName"                 FORMAT a65
COLUMN distinct_keys            HEADING "Distinct|Keys"             FORMAT 99,999,999,999
COLUMN blevel                   HEADING "BLevel"                    FORMAT 99999
COLUMN clustering_factor        HEADING "Clustering|Factor"         FORMAT 99,999,999,999
COLUMN leaf_blocks              HEADING "Leaf|Blocks"               FORMAT 999,999,999
COLUMN avg_leaf_blocks_per_key  HEADING "Avg|Leaf|Blocks|PerKey"    FORMAT 999,999
COLUMN avg_data_blocks_per_key  HEADING "Avg|Data|Blocks|PerKey"    FORMAT 999,999

select 
--s.table_owner || '.' || s.table_name  table_name
--  , 
    s.owner || '.' || s.index_name 
       || NVL2(s.partition_name,':' || s.partition_name, '')
       || NVL2(s.subpartition_name,':' || s.subpartition_name, '')
       index_name
     , s.object_type
     , DECODE (s.object_type
           , 'TABLE'        ,1
           , 'PARTITION'    ,2
           , 'SUBPARTITION' ,3
           ,9
           ) object_type_sort_order         
     , s.stattype_locked
     , s.global_stats
     , s.user_stats
     , s.stale_stats
     , to_char(s.last_analyzed,'DD-MON-YY HH24:MI:SS') last_analyzed
     , ROUND((s.leaf_blocks * p.value) /1024/1024 ) SizeMB
     , s.num_rows
     , s.distinct_keys
     , s.blevel
     , s.clustering_factor
     , s.sample_size
     , s.leaf_blocks
     , s.avg_leaf_blocks_per_key
     , s.avg_data_blocks_per_key
 FROM dba_ind_statistics s
    , v$system_parameter p
WHERE p.name = 'db_block_size'
  AND s.table_name NOT LIKE 'BIN$%'
  AND s.owner                      LIKE upper('&&owner') ESCAPE '\'
  AND s.table_name                 LIKE upper('&&table_name') ESCAPE '\'
  AND NVL(s.partition_name,'%')     LIKE upper('&&partition_name') ESCAPE '\'
  AND NVL(s.subpartition_name,'%')  LIKE upper('&&subpartition_name') ESCAPE '\'
  AND NVL(DECODE(s.object_type
               ,'PARTITION','INDEX PARTITION'
               ,'SUBPARTITION','INDEX SUBPARTITION'
               ,s.object_type),'%')       LIKE upper('&&object_type') ESCAPE '\'
ORDER BY s.owner
       , s.table_name
          , s.index_name
       , object_type_sort_order
       , s.partition_position
       , s.subpartition_position
/

@@footer
