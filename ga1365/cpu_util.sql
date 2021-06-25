col waitday for a11
col "00" for 99.9
col "01" for 99.9
col "02" for 99.9
col "03" for 99.9
col "04" for 99.9
col "05" for 99.9
col "06" for 99.9
col "07" for 99.9
col "08" for 99.9
col "09" for 99.9
col "10" for 99.9
col "11" for 99.9
col "12" for 99.9
col "13" for 99.9
col "14" for 99.9
col "15" for 99.9
col "16" for 99.9
col "17" for 99.9
col "18" for 99.9
col "19" for 99.9
col "20" for 99.9
col "21" for 99.9
col "22" for 99.9
col "23" for 99.9
set linesize 200
set pagesize 50
 alter session set nls_date_format='DD-Mon-YYYY';
select to_date(to_char(BEGIN_TIME,'DD-Mon-YYYY')) WaitDay,
max(decode(to_char(END_TIME,'HH24'),'00',AVERAGE,0)) "00",
max(decode(to_char(END_TIME,'HH24'),'01',AVERAGE,0)) "01",
max(decode(to_char(END_TIME,'HH24'),'02',AVERAGE,0)) "02",
max(decode(to_char(END_TIME,'HH24'),'03',AVERAGE,0)) "03",
max(decode(to_char(END_TIME,'HH24'),'04',AVERAGE,0)) "04",
max(decode(to_char(END_TIME,'HH24'),'05',AVERAGE,0)) "05",
max(decode(to_char(END_TIME,'HH24'),'06',AVERAGE,0)) "06",
max(decode(to_char(END_TIME,'HH24'),'07',AVERAGE,0)) "07",
max(decode(to_char(END_TIME,'HH24'),'08',AVERAGE,0)) "08",
max(decode(to_char(END_TIME,'HH24'),'09',AVERAGE,0)) "09",
max(decode(to_char(END_TIME,'HH24'),'10',AVERAGE,0)) "10",
max(decode(to_char(END_TIME,'HH24'),'11',AVERAGE,0)) "11",
max(decode(to_char(END_TIME,'HH24'),'12',AVERAGE,0)) "12",
max(decode(to_char(END_TIME,'HH24'),'13',AVERAGE,0)) "13",
max(decode(to_char(END_TIME,'HH24'),'14',AVERAGE,0)) "14",
max(decode(to_char(END_TIME,'HH24'),'15',AVERAGE,0)) "15",
max(decode(to_char(END_TIME,'HH24'),'16',AVERAGE,0)) "16",
max(decode(to_char(END_TIME,'HH24'),'17',AVERAGE,0)) "17",
max(decode(to_char(END_TIME,'HH24'),'18',AVERAGE,0)) "18",
max(decode(to_char(END_TIME,'HH24'),'19',AVERAGE,0)) "19",
max(decode(to_char(END_TIME,'HH24'),'20',AVERAGE,0)) "20",
max(decode(to_char(END_TIME,'HH24'),'21',AVERAGE,0)) "21",
max(decode(to_char(END_TIME,'HH24'),'22',AVERAGE,0)) "22",
max(decode(to_char(END_TIME,'HH24'),'23',AVERAGE,0)) "23"
from DBA_HIST_SYSMETRIC_SUMMARY
where METRIC_NAME like 'Host CPU Utilization%' and INSTANCE_NUMBER = &inst_num
group by to_char(BEGIN_TIME,'DD-Mon-YYYY') order by 1;
 alter session set nls_date_format='DD-Mon-YYYY HH24:MI:SS';
