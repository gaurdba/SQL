
set lines 500
break on tijdstip
col error_code format a40
col tijdstip format a20
col diskgroup format a25
col power format 999
col inst_id format 999
col actual format 999
col est_time format A8
col datum format A20
col error_code format a10
select sysdate as tijdstip
   ,inst_id
   ,group_number
   ,(select name from v$asm_diskgroup where group_number=a.group_number) as diskgroup
   ,operation
   ,state
   ,power
   ,actual
   ,sofar
   ,est_work
   ,est_rate
   ,est_minutes
   ,case when est_minutes>0 then TO_CHAR(FLOOR(est_minutes/60))||':'||TO_CHAR(MOD(est_minutes,60),'FM00')  else '' end as est_time
   ,error_code
  from gv$asm_operation a 
  order by group_number,inst_id,state;
