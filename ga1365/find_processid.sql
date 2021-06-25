SET LINESIZE 160
SET PAGES 200
COLUMN spid FORMAT A10
COLUMN username FORMAT A10
COLUMN program FORMAT A45
SELECT s.inst_id,
       s.sid,
       s.serial#,
       p.spid,
       s.username,
       s.program
FROM   gv$session s
       JOIN gv$process p ON p.addr = s.paddr AND p.inst_id = s.inst_id
WHERE  s.type != 'BACKGROUND' and UPPER(s.username)=UPPER(NVL('&Username'),Username);