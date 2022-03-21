#!/bin/ksh
# Author	:Sanjay Gaur
# Purpose	:Show SGA & PGA Memory Details of Running DBs
# Usage		: save the parameter with txt files db1.txt & db2.txt


clear
echo -e "\n\n*********************\n* Parameter Compare *\n*********************\n"
printf '%-60s\n' '------------------------------------------------------------------------------------------------------------------------'
printf 'Parameter Name%-40s %4s |             PR%11s %3s |         ST%6s %7s |\n'
printf '%-60s\n' '------------------------------------------------------------------------------------------------------------------------'
p1=`grep instance_name db1.param|cut -d':' -f1`
v1=`grep instance_name db1.param|cut -d':' -f2`
p2=`grep -w instane_name db2.param|cut -d':' -f1`
v2=`grep -w instance_name db2.param|cut -d':' -f2|tr -d ' '`
 printf '%-40s %20s %15s %15s %15s %10s\n ' "|$p1" '|' $v1 '|' $v2 '|'
 printf '%-60s\n' '-----------------------------------------------------------------------------------------------------------------------'

for st in `cat db1.param|egrep -v 'instane_name|connection_brokers'`
do 
	p1=`echo $st|cut -d':' -f1`
	v1=`echo $st|cut -d':' -f2|tr -d ' ' |tr '[:upper:]' '[:lower:]' `
	p2=`grep -w $p1 db2.param|cut -d':' -f1`
	v2=`grep -w $p1 db2.param|cut -d':' -f2|tr -d ' '|tr '[:upper:]' '[:lower:]' `
	if [ -z "$v1" ]
	then
        	 v1='Not Set'
	fi
	if [ -z "$v2" ]
	then
		 v2='Not Set'
	fi
	if ! [ "$v1" = "$v2" ]
	then 
	      #printf '%-40s %30s %30s %20s\n ' $p1 $v1 $v2 '|'
		printf '%-40s %20s %15s %15s %15s %10s\n ' "| $p1" '|' "$v1" '|' "$v2" '|'
        	printf '%-60s\n' '-----------------------------------------------------------------------------------------------------------------------'
	fi
done
for st in `cat db2.param|egrep -v 'instane_name|connection_brokers'`
do
	p1="0"
	p2=`echo $st|cut -d':' -f1`
	v2=`echo $st|cut -d':' -f2|tr '[:upper:]' '[:lower:]'`
	p1=`grep -iw $p2 db1.param|cut -d':' -f1`
	v1=`grep -iw $p2 db1.param|cut -d':' -f2|tr -d ' '|tr '[:upper:]' '[:lower:]'`
        if [ "$p1" = "$p2" ]
	then
		#echo $p1
		continue;	
	fi
	if [ -z "$v1" ]
	then
        	 v1="Not Set"
	fi
	if [ -z "$v2" ]
	then
		 v2="Not Set"
	fi
	if ! [ "$v1" = "$v2" ]
	then 
	      #printf '%-40s %30s %30s %20s\n ' $p1 $v1 $v2 '|'
		printf '%-40s %20s %15s %15s %15s %10s\n ' "| $p2" '|' "$v1" '|' "$v2" '|'
        	printf '%-60s\n' '-----------------------------------------------------------------------------------------------------------------------'
	fi
done
