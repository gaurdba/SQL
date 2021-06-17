#!/bin/bash
# Author	:Sanjay Gaur
# Purpose	:Show the connection Details for given Start & End Timestamp
#
listener_dir=`lsnrctl status|grep 'Listener Log File'|awk '{print $4}'`
list_file=`echo $listener_dir|awk -F "alert" '{print $1 "trace/listener.log" }'`
if ! [ -f $list_file ]
then
	echo "Listener Logfile $list_file Doesn't Exists"
	exit 0;
fi
start_time=$1
end_time=$2
srv_name=$3
echo -e "\n"
if [ $# -eq 0 ]
then
	echo "Enter the Start time, End Time  & Service_name"
	exit 0;
fi
echo "Processing Logfile "
echo -e "Logfile::$list_file \n\n"
ini_line=`grep -no "$start_time" $list_file |head -1|awk -F ":" '{print $1}'`
end_line=`grep -no "$end_time" $list_file|tail -1|awk -F ":" '{print $1}'`
if ! [ $ini_line -gt 0 ]
then
   echo "No Line found for Entered Start Timestamp"
	exit 0;
fi
if ! [ $end_line -gt 0 ]
then
   echo "No Line found for Entered Start Timestamp"
        exit 0;
fi

#echo $ini_line $end_line
sed -n "$ini_line","$end_line"p $list_file >/tmp/list.log
if [ $# -lt 3 ]
then
	for srv in `cat /tmp/list.log|awk -F "SERVICE_NAME=" '{print $2}'|awk -F")" '{print $1}'|grep -v ^$|uniq`
	do
		echo "Total Connection From Service $srv==" `grep -c $srv /tmp/list.log`
	done

	for prg in `cat /tmp/list.log|awk -F "PROGRAM=" '{print $2}'|awk -F")" '{print $1}'|grep -v ^$|uniq`
	do
		echo "Total Connection From $prg Program==" `grep -c $srv /tmp/list.log`
	done

	for hst in `cat /tmp/list.log|awk -F "HOST=" '{print $2}'|awk -F")" '{print $1}'|grep -v ^$|uniq`
	do
		echo "Total Connection From $hst Host==" `grep -c $srv /tmp/list.log`
	done
exit;
fi
if [ $# -eq 3 ]
then
        for srv in `cat /tmp/list.log|grep $srv_name|awk -F "SERVICE_NAME=" '{print $2}'|awk -F")" '{print $1}'|grep -v ^$|uniq`
        do
                echo "Total Connection From Service $srv==" `grep -c $srv /tmp/list.log`
        done

        for prg in `cat /tmp/list.log|grep $srv_name|awk -F "PROGRAM=" '{print $2}'|awk -F")" '{print $1}'|grep -v ^$|uniq`
        do
                echo "Total Connection From $prg Program==" `grep -c $srv /tmp/list.log`
        done

        for hst in `cat /tmp/list.log|grep $srv_name|awk -F "HOST=" '{print $2}'|awk -F")" '{print $1}'|grep -v ^$|uniq`
        do
                echo "Total Connection From $hst Host==" `grep -c $srv /tmp/list.log`
        done
fi
echo -e "\n"
