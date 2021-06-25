@@header

/*
*
*  Author     : Vishal Gupta
*  Purpose    : Display Temporary tablespace stats from AWR Repository
*  Parameter : 1 - InstanceNumber (Use % for all instances)
*              2 - From Timestamp (In YYYY-MM-DD HH24:MI:SS format)
*              3 - To Timestamp   (In YYYY-MM-DD HH24:MI:SS format)
*              4 - TablespaceName (Use % as wild card)
*
*  Revision History:
*  ===================
*  Date       Author        Description
*  ---------  ------------  -----------------------------------------
*  04-Jul-12  Vishal Gupta  Created
*
*/


/************************************
*  INPUT PARAMETERS
************************************/
DEFINE INST_ID="&&1"
DEFINE FROM_TIMESTAMP="&2"
DEFINE TO_TIMESTAMP="&3"
DEFINE tablespace_name="&4"


COLUMN  _owner           NEW_VALUE owner            NOPRINT
COLUMN  _object_name     NEW_VALUE object_name      NOPRINT
COLUMN  _object_type     NEW_VALUE object_type      NOPRINT




/************************************
*  CONFIGURATION PARAMETERS
************************************/

DEFINE COUNT_FORMAT=999,999,999
DEFINE COUNT_DIVIDER="1"
DEFINE COUNT_HEADING="#"
--DEFINE COUNT_DIVIDER="1000"
--DEFINE COUNT_HEADING="#1000"

DEFINE BYTES_FORMAT="999,999"
--DEFINE BYTES_DIVIDER="1024"
--DEFINE BYTES_HEADING="KB"
DEFINE BYTES_DIVIDER="1024/1024"
DEFINE BYTES_HEADING="MB"
--DEFINE BYTES_DIVIDER="1024/1024/1024"
--DEFINE BYTES_HEADING="GB"

DEFINE TIME_FORMAT=99,999
DEFINE TIME_DIVIDER="1"
DEFINE TIME_HEADING="sec"
--DEFINE TIME_DIVIDER="60"
--DEFINE TIME_HEADING="min"

PROMPT ******************************************************************
PROMPT * T E M P O R A R Y    T A B L E S P A C E    S T A T I S T I C S 
PROMPT * (From AWR Repository)
PROMPT * 
PROMPT * Input Parameters 
PROMPT *   - For Instance ID - '&INST_ID'
PROMPT *   - Snap Between    - '&&FROM_TIMESTAMP' and '&&TO_TIMESTAMP' (YYYY-MM-DD HH24:MI:SS)
PROMPT *   - Tablespace Name - '&&tablespace_name'
PROMPT ******************************************************************

set pages 50000

COLUMN end_interval_time         HEADING "SnapTime"                                     FORMAT a15
COLUMN instance_number           HEADING "I#"                                           FORMAT 99
COLUMN tsname                    HEADING "Tablespace|Name"                              FORMAT a20
COLUMN phyrds                    HEADING "Phy|Reads|(&&COUNT_HEADING)"                  FORMAT &&COUNT_FORMAT
COLUMN phywrts                   HEADING "Phy|Writes|(&&COUNT_HEADING)"                 FORMAT &&COUNT_FORMAT
COLUMN readtim                   HEADING "Read|Time|(&&TIME_HEADING)"                   FORMAT &&TIME_FORMAT
COLUMN writetim                  HEADING "Write|Time|(&&TIME_HEADING)"                  FORMAT &&TIME_FORMAT
COLUMN singleblkrds              HEADING "SingleBlock|PhyReads|(&&COUNT_HEADING)"       FORMAT &&COUNT_FORMAT
COLUMN singleblkrdtim            HEADING "SingleBlock|ReadTime|(&&TIME_HEADING)"        FORMAT &&TIME_FORMAT
COLUMN phyrd_size                HEADING "PhyRead|Size|(&&BYTES_HEADING)"               FORMAT &&BYTES_FORMAT
COLUMN phywrt_size               HEADING "PhyWrite|Size|(&&BYTES_HEADING)"              FORMAT &&BYTES_FORMAT
COLUMN wait_count                HEADING "Wait Count|(&&COUNT_HEADING)"                 FORMAT &&COUNT_FORMAT
COLUMN wait_time                 HEADING "Wait Time|(&&TIME_HEADING)"                   FORMAT &&TIME_FORMAT
COLUMN separator                 HEADING "!|!|!"                                        FORMAT a1

WITH snap
AS
 (SELECT s.dbid
       , s.instance_number
       , s.snap_id
       , LEAD (s.snap_id) OVER (ORDER BY s.dbid, s.instance_number, s.snap_id) next_snap_id
       , s.end_interval_time
   FROM  dba_hist_snapshot s
       , v$database d
  WHERE s.dbid = d.dbid
      AND s.instance_number LIKE '&&INST_ID'
      AND s.end_interval_time BETWEEN TO_TIMESTAMP('&&FROM_TIMESTAMP','YYYY-MM-DD HH24:MI:SS') 
                                AND TO_TIMESTAMP('&&TO_TIMESTAMP'  ,'YYYY-MM-DD HH24:MI:SS')
 )
, tempstats  AS
(
  SELECT 
        s.end_interval_time
      , t.instance_number
      , t.tsname
      , t.block_size
      , t.phyrds         - LEAST(t_prev.phyrds,t.phyrds)                  phyrds
      , t.phywrts        - LEAST(t_prev.phywrts,t.phywrts)                phywrts
      , t.readtim        - LEAST(t_prev.readtim,t.readtim)                readtim
      , t.writetim       - LEAST(t_prev.writetim,t.writetim)              writetim
      , t.singleblkrds   - LEAST(t_prev.singleblkrds,t.singleblkrds)      singleblkrds
      , t.singleblkrdtim - LEAST(t_prev.singleblkrdtim,t.singleblkrdtim)  singleblkrdtim
      , t.phyblkrd       - LEAST(t_prev.phyblkrd,t.phyblkrd)              phyblkrd
      , t.phyblkwrt      - LEAST(t_prev.phyblkwrt,t.phyblkwrt)            phyblkwrt
      , t.wait_count     - LEAST(t_prev.wait_count,t.wait_count)          wait_count
      , t.time           - LEAST(t_prev.time,t.time)                      time
    FROM snap s
       , dba_hist_tempstatxs t
       , dba_hist_tempstatxs t_prev
  WHERE s.next_snap_id IS NOT NULL
    AND s.dbid = t_prev.dbid
    AND s.instance_number = t_prev.instance_number
    AND s.snap_id = t_prev.snap_id
    AND s.dbid = t.dbid
    AND s.instance_number = t.instance_number
    AND s.next_snap_id = t.snap_id
    AND t_prev.file# = t.file#
    AND t.tsname LIKE '&&tablespace_name'
)
SELECT TO_CHAR(t.end_interval_time,'DD-MON-YY HH24:MI') end_interval_time
     , t.instance_number
     , t.tsname
     , '|'                                                  separator
     , SUM(t.phyblkrd * t.block_size)/&&BYTES_DIVIDER       phyrd_size
     , SUM(t.phyrds)/&&COUNT_DIVIDER                        phyrds
     , ROUND(avg(t.readtim)/100)/&&TIME_DIVIDER             readtim
     , '|'                                                  separator
     , SUM(t.singleblkrds)/&&COUNT_DIVIDER                  singleblkrds
     , ROUND(avg(t.singleblkrdtim)/100)/&&TIME_DIVIDER      singleblkrdtim
     , '|'                                                  separator
     , SUM(t.phyblkwrt * t.block_size)/&&BYTES_DIVIDER      phywrt_size
     , SUM(t.phywrts)/&&COUNT_DIVIDER                       phywrts
     , ROUND(avg(t.writetim)/100)/&&TIME_DIVIDER            writetim
     , '|'                                                  separator
     , SUM(t.wait_count)/&&COUNT_DIVIDER                    wait_count
     , SUM(t.time)/&&TIME_DIVIDER                           wait_time
FROM tempstats t
GROUP BY TO_CHAR(t.end_interval_time,'DD-MON-YY HH24:MI')
       , t.instance_number
       , t.tsname  
ORDER BY TO_DATE(TO_CHAR(t.end_interval_time,'DD-MON-YY HH24:MI'),'DD-MON-YY HH24:MI') asc
       , t.instance_number
       , t.tsname  
;
  

@@footer