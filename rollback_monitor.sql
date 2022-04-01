@@header

set term off
/*
*
*  Purpose : Monitoring rollback currently occurring in database.
*
*/
set term on

COLUMN  spid           HEADING "SPID"                           FORMAT 999999
COLUMN  INST_ID        HEADING "I#"                             FORMAT 99
COLUMN  sid            HEADING "SID"                            FORMAT 99999
COLUMN  PID            HEADING "PID"                            FORMAT 999999
COLUMN  state          HEADING "State"                          FORMAT a12
COLUMN  done           HEADING "Undo|Recovery|SoFar|(MB)"       FORMAT 9,999,999
COLUMN  total          HEADING  "Total|Recovery|Needed|(MB)"    FORMAT 9,999,999
COLUMN  percent_done   HEADING "%Done"                          FORMAT 999.99
COLUMN  cputime        HEADING "CPU Time"                       FORMAT a13           JUSTIFY RIGHT
COLUMN  rcvservers     HEADING "Server|In Last|Recovery"        FORMAT 9999999       JUSTIFY RIGHT
COLUMN  eta            HEADING "ETA"                            FORMAT a18       

PROMPT
PROMPT **************************************
PROMPT * Recovery By SMON
PROMPT **************************************

SELECT r.state
     , decode(cputime,0,'unknown'
            ,TO_CHAR(sysdate+(((undoblockstotal-undoblocksdone) / (undoblocksdone / cputime)) / 86400),'DD-MON-YY HH24:MI:SS')
       ) eta
     , r.INST_ID
     , ROUND((r.undoblocksdone * b.value)/power(1024,2))  done
     , ROUND((r.undoblockstotal * b.value)/power(1024,2)) total
     , ROUND((r.undoblocksdone/r.undoblockstotal)*100,2)  percent_done
     , LPAD(FLOOR(r.cputime/ 3600) || 'h ' 
           || LPAD(FLOOR(MOD(r.cputime, 3600 ) / 60),2) || 'm ' 
       || LPAD(MOD(r.cputime, 60 ) ,2) || 's' ,13)  cputime
     , r.rcvservers
     , r.xid
     , r.pxid
FROM  gv$fast_start_transactions r
      JOIN v$parameter b  ON b.name = 'db_block_size'
      --LEFT OUTER JOIN gv$transaction t ON t.inst_id = r.inst_id AND r.usn = xidusn AND r.slt = t.xidslot AND r.seq = t.xidsqn
where 1=1 
AND r.state <> 'RECOVERED'
;


PROMPT
PROMPT **************************************
PROMPT * Recovery By Shadow process
PROMPT **************************************

select s.inst_id
     , s.sid
     , s.status
     , s.username
     , s.osuser
     , ROUND((t.used_ublk * p.value) / power(1024,2)) "Undo (MB)"
FROM gv$transaction t
   , gv$session s 
   , (select value from v$parameter where name = 'db_block_size') p
WHERE s.status = 'KILLED'
AND t.inst_id = s.inst_id   AND t.ses_addr = s.saddr
;

@@footer
