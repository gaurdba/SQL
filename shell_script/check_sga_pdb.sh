#!/bin/bash
# Author        :Sanjay Gaur
# Purpose       :Show SGA Details for CDB  & PDB
#

color_code()
{
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White
}
print_header()
{
	echo -e "DB Memory Details in GB\n\n"
	echo "-----------------------------------------------------------"
	printf 'DB Type%-20s DBName%10s SGA%10s|\n'
	echo "-----------------------------------------------------------"
}
output_format()
{
        #Formatting the Output
        for db in `cat /sftp-tank/sanjay/sqlscripts/sgatot.txt|grep -v '^$'`
        do
                dbt=`echo $db|cut -d':' -f1`
                cdb=`echo $db|cut -d':' -f2`
                sga=`echo $db|cut -d':' -f3`
                if [ "$dbt" = "CDB" ]
                then
			echo -en $Green 
                        printf '%-24s | %8s     | %14s  |\n' $dbt $cdb $sga
                        tsizecdb=$(($sga+$tsizecdb))
			echo -en $Color_Off
                else
                        printf '%-24s | %12s | %14s  |\n' $dbt $cdb $sga
                        tsizepdb=$(($sga+$tsizepdb))
                fi
        done
	echo "-----------------------------------------------------------"
}
execute_on_pdb()
{
        count=0
        for i in `cat /sftp-tank/sanjay/sqlscripts/out.txt`
        do
                if [ $count = 0 ]
                then
                        sqlplus -s "/ as sysdba" <<EOF >/sftp-tank/sanjay/sqlscripts/sgatot.txt
                        set lines 300 pages 0 heading off feedback off
                        select 'CDB'||':'||sys_context('userenv','DB_NAME')||':'||value/1024/1024/1024 Size_GB from v\$parameter where name='sga_max_size';
                        exit;
EOF
                count=$(($count+1))
                fi
                sqlplus -s "/ as sysdba" <<EOF >>/sftp-tank/sanjay/sqlscripts/sgatot.txt
                set lines 300 pages 1 heading on feedback off
                alter session set container=$i;
                select 'PDB'||':'||sys_context('userenv','DB_NAME')||':'||value/1024/1024/1024 Size_GB from v\$parameter where name='sga_target';
                exit;
EOF
        done

}
list_container()
{
	for db in `ps -ef|grep ora_pmon|grep -v grep|awk '{print $8}'|grep -v zdm|cut -d '_' -f3|rev|cut -c2-|rev|awk '{print "/home/oracle/" $1 ".env"}'`
	do
        source $db
        sqlplus -s "/ as sysdba" <<EOF >/sftp-tank/sanjay/sqlscripts/out.txt
        col name for a20
        col profile for a35
        col resource_name for a35
        col limit for a30
        set lines 300 pages 0 heading off feedback off
        select name from v\$containers where name not in ('PDB\$SEED','CDB\$ROOT') ;
        exit;
EOF
        execute_on_pdb
        output_format

done

}
print_footer()
{
	echo "-----------------------------------------------------------"
       printf '%-24s | %14s\t  |\n' "Total CDB SIZE(GB):$tsizecdb" "Total PDB SIze(GB):$tsizepdb"
	echo "-----------------------------------------------------------"

}
cleanup ()
{
	if [ -f $container ]
	then
	        rm -f $container
	fi
	if [ -f $cdbquery ]
	then
        	rm -f $cdbquery
	fi
	if [ -f $pdbquery ]
	then
        	rm -f $pdbquery
	fi
}
#Main
#container=`mktemp -p /tmp pdblist.XXXXXXXXXX`
#cdbquery=`mktemp -p /tmp cdbq.XXXXXXXXXX`
#pdbquery=`mktemp -p /tmp pdbq.XXXXXXXXXX`
tsizepdb=0
tsizecdb=0
color_code
print_header
list_container
print_footer
#echo "-----------------------------------------------------------"
 #      printf '%-24s | %14s\t  |\n' "Total CDB SIZE(GB):$tsizecdb" "Total PDB SIze(GB):$tsizepdb"
#echo "-----------------------------------------------------------"

