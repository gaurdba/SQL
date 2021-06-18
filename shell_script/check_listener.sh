#!/bin/bash
# Author	:Sanjay Gaur
# Purpose	:Show the connection Details for given Start & End Timestamp
# Usage		: check_listener.sh 'Start_Time' 'End_Time' [service_name]
# Example 	: check_listener.sh 'DD-Mon-YYYY HH24:MI' 'DD-Mon-YYYY HH24:MI' [service_name]
#
listener_dir=`lsnrctl status|grep 'Listener Log File'|awk '{print $4}'`
list_file=`echo $listener_dir|awk -F "alert" '{print $1 "trace/listener.log" }'`
#list_file='/u002/app/grid/diag/tnslsnr/ab3s3p02/listener/trace/listener_102.log'
if ! [ -f $list_file ]
then
	echo "Listener Logfile $list_file Doesn't Exists"
	exit 0;
fi
start_time=$1
end_time=$2
srv_name=$3
in_lsnr_file=$4
echo -e "\n"
if [ $# -eq 0 ]
then
	echo "Enter the Start time, End Time  & Service_name"
	exit 0;
fi
echo "Processing Logfile "
echo -e "Logfile::$list_file \n\n"
ini_line=0
ini_line=`grep -no "$start_time" $list_file |head -1|awk -F ":" '{print $1}'`
end_line=`grep -no "$end_time" $list_file|tail -1|awk -F ":" '{print $1}'`
#echo "INI:$ini_line" end $end_line
if [ -z $ini_line ]
then
   echo "No Line found for Entered Start Timestamp"
	exit 0;
fi
if [ -z $end_line ]
then
   echo "No Line found for Entered Start Timestamp"
        exit 0;
fi
#echo Line $ini_line $end_line
sed -n "$ini_line","$end_line"p $list_file >/tmp/list.log
if [ $# -lt 3 ]
then
	for srv in `cat /tmp/list.log|awk -F "SERVICE_NAME=" '{print $2}'|awk -F")" '{print $1}'|grep -v ^$|sort|uniq`
	do
		echo "Total Connection From Service $srv==" `grep -c $srv /tmp/list.log`
	done
	for prg in `cat /tmp/list.log|awk -F "PROGRAM=" '{print $2}'|awk -F")" '{print $1}'|grep -v ^$|sort|uniq`
	do
		echo "Total Connection From $prg Program==" `grep -c $srv /tmp/list.log`
	done
	for hst in `cat /tmp/list.log|awk -F "HOST=" '{print $2}'|awk -F")" '{print $1}'|grep -v ^$|sort|uniq`
	do
		echo "Total Connection From $hst Host==" `grep -c $srv /tmp/list.log`
	done
exit;
fi
if [ $# -eq 3 ]
then
        for srv in `cat /tmp/list.log|grep -i $srv_name|awk -F "SERVICE_NAME=" '{print $2}'|awk -F")" '{print $1}'|grep -v ^$|sort|uniq`
        do
                echo "Total Connection From Service $srv==" `grep -c $srv /tmp/list.log`
        done
        for prg in `cat /tmp/list.log|grep $srv_name|awk -F "PROGRAM=" '{print $2}'|awk -F")" '{print $1}'|grep -v ^$|sort|uniq`
        do
                echo "Total Connection From $prg Program==" `grep -c $prg /tmp/list.log`
        done
        for hst in `cat /tmp/list.log|grep $srv_name|awk -F "HOST=" '{print $2}'|awk -F")" '{print $1}'|grep -v ^$|sort|uniq`
        do
                echo "Total Connection From $hst Host==" `grep -c $hst /tmp/list.log`
        done
fi
echo -e "\n"
