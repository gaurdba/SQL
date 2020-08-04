#!/bin/ksh
# Author	:Sanjay Gaur
# Purpose	:Show SGA & PGA Memory Details of Running DBs
#

clear
echo -e "DB Memory Details in MB\n\n"
printf 'DB Name%-20s SGA%10s PGA%10s\n'
echo "--------------------------------------------------------------------"
sumsga=0
sumpga=0
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
	select round(sum(value)/1024/1024) from v\$sga;
	select round(value/1024/1024) from v\$pgastat where name='aggregate PGA target parameter';
	select round(value/1024/1024) from  v\$pgastat where name='total PGA inuse';
	select value from v\$parameter where name='processes';
	select count(*) from v\$process; 
	exit
	spool off
EOF
	cat aa.txt|grep -v ^$>aa1.txt
	tmplog=aa1.txt
	sga=`awk 'NR==1 {print $1}' $tmplog`
      	pgatarget=`awk 'NR==2 {print $1}' $tmplog`
      	pgaused=`awk 'NR==3 {print $1}' $tmplog`
      	process=`awk 'NR==4 {print $1}' $tmplog`
      	processused=`awk 'NR==5 {print $1}' $tmplog`
      	totalsga=$(($totalsga+$sga))
      	totalpgatarget=$(($totalpgatarget+$pgatarget))
      	totalpgaused=$(($totalpgaused+$pgaused))
      	totalprocess=$(($totalprocess+$process))
      	totalprocessused=$(($totalprocessused+$processused))
      	totalprocessmb=$(($totalprocess*10))
      	totalprocessusedmb=$(($totalprocessused*10))
#echo "Total SGA::"$totalsga
#echo -e "$sid \t $totalsga \t $pgaused"
printf '%-20s %10s %13s\n' $sid $sga $pgaused
sumsga=`expr $sumsga + $totalsga`
sumpga=`expr $sumpga + $pgaused`
totalsga=0
done
echo "--------------------------------------------------------------------"
printf 'Total%26s %13s\n' $sumsga $sumpga
#echo $sumsga
echo -e "\n\n"
