#!/bin/bash
# To monitor CPU, memory and disk usage
HOSTNAME=$(hostname)
DATE=$(date "+%Y-%m-%d %H:%M:%S")
CPUUSAGE=$(top -b -n 1 -d1 | grep "Cpu(s)" |awk '{print $2}' |awk -F. '{print $1}')
MEMUSAGE=$(free |grep Mem |awk '{print $3/$2 * 100.0}')
DISKUSAGE=$(df -P |column -t |awk '{print $5}' | tail -n 1 |sed 's/%//g')

#echo 'HostName, Date&Time, CPUi(%), Disk(%), Mem(%)' >> /opt/usagereport
#echo "$HOSTNAME, $DATE, $CPUUSAGE, $DISKUSAGE, $MEMUSAGE" >> /opt/usagereport

rm -rf /home/ubuntu/usagereport
printf "Hostname %s\t\t| Date %s\t\t| CPUUSAGE %s\t\t| DISKUSAGE %s\t\t|MEMUSAGE \n$HOSTNAME %s\t| $DATE %s\t| $CPUUSAGE %s\t| $DISKUSAGE %s\t| $MEMUSAGE \n" >> /home/ubuntu/usagereport

THRESHOLD=20
mailto="anshikabhasin1@gmail.com"

for path in `/bin/df -h |awk '{print $5}' |sed 's/%//g'`
do
        if [[ $path -ge $THRESHOLD ]]; then
        df -h | grep $path% > /home/ubuntu/output.txt
        fi
done

VALUE=`cat /home/ubuntu/output.txt | wc -l`
        if [[ $VALUE -ge 1 ]]; then
                mail -s "$HOSTNAME Disk usage is critical" $mailto < /home/ubuntu/output.txt
        fi
