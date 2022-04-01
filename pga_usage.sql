BREAK ON REPORT
COMPUTE SUM LABEL 'TOTAL' OF max_mb ON Report
COMPUTE SUM LABEL 'TOTAL' OF alloc_mb ON Report
COMPUTE SUM LABEL 'TOTAL' OF used_mb ON Report
COMPUTE SUM LABEL 'TOTAL' OF free_mb ON Report
set lines 300 pages 50
col serial# for 99999999
col sid for 999999
col inst_id for 9999999
col spid for 9999999999
col program for a50

with proc as (SELECT addr,inst_id,spid, program,
            round(pga_max_mem/1024/1024,0)      max_mb,
            round(pga_alloc_mem/1024/1024,0)    alloc_mb,
            round(pga_used_mem/1024/1024,0)     used_mb,
            pga_freeable_mem/1024/1024 free_mb FROM gV$PROCESS order by  pga_alloc_mem desc fetch first 10 rows only)
select sid,serial#,proc.* from gv$session s,proc where proc.inst_id=s.inst_id and  s.paddr =proc.addr;
