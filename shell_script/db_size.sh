#!/bin/ksh
# Author	:Sanjay Gaur
# Purpose	:Print DB size of the running db on the node
#

clear
echo -e "DB Size in GB \n\n"
printf 'DB Name%-20s Total%10s Used Segment%10s\n'
echo "--------------------------------------------------------------------"
sumsga=0
sumpga=0
sums=0
for sid in `ps  -ef|grep smon|grep -v grep |awk '{print $8}'|cut -d "_" -f3`
do 
	export ORACLE_SID=$sid
	export ORAENV_ASK=NO
	. oraenv >/dev/null
	sqlplus -s /nolog >/dev/null <<EOF
	connect / as sysdba
	set echo off
	set feedback  off
	set heading off
	SET TERMOUT OFF
	set pagesize 0
	set heading off pages 0 lines 2000 termout on feedback off
	spool aa.txt
	col "Database Size" for a15
	set heading off pages 0 lines 2000 termout on feedback off
col "Database Size" for a15
col "Used space" for a15
col "Free space" for a15
set lines 200

select 'Total'||'|'||round(sum(used.bytes) / 1024 / 1024 / 1024 )||'|'||'USED|'||(round(sum(used.bytes) / 1024 / 1024 / 1024 ) - round(free.p / 1024 / 1024 / 1024))
from (select bytes
from v\$datafile
union all
select bytes
from v\$tempfile
union all
select bytes
from v\$log) used
, (select sum(bytes) as p
from dba_free_space) free
group by free.p
/
	exit
	spool off
EOF
segsize=0
segsize=`sqlplus -s /nolog >/dev/null <<EOF
connect / as sysdba
spool segsize.txt
set echo off
set feedback  off
set heading off
SET TERMOUT OFF
set pagesize 0
set heading off pages 0 lines 2000 termout on feedback off
select to_char(sum(bytes/1024/1025/1024),'0.99') from dba_segments;
spool off
exit;
EOF`
segsize=`echo $segsize|sed -e 's/^[[:space:]]*//'`
segsize=`cat segsize.txt|tr -d ' '`
cat aa.txt|grep -v ^$>aa1.txt
	t=`cat aa1.txt|awk -F'|' '{print $2}'`
#	u=`cat aa1.txt|awk -F'|'  '{print $4}'`
#echo $t $u	
#echo "Total SGA::"$totalsga
#echo -e "$sid \t $totalsga \t $pgaused"
printf '%-20s %10d %19.2f  \n' $sid $t $segsize
sumt=`expr $sumt + $t`
sums=`echo $sums + $segsize|bc`
#sumu=`expr $sumu + $u`
totalsga=0
done
echo "--------------------------------------------------------------------"
printf 'Total%26s %19s\n' $sumt $sums
#echo $sumsga
echo -e "\n\n"
