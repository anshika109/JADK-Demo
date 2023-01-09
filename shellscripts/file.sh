#!/bin/bash
echo -n "Enter indate  >"
read indate
echo -n "Enter outdate >"
read outdate
function validateDate() {
echo "Start $date"
if [ ${#date} -eq 8 ]; then
    year=${date:0:4}
    month=${date:4:2}
    day=${date:6:2}
    month30="04 06 09 11"
    leapyear=$((year%4)) # if leapyear this is 0
    if [ "$year" -ge 1901 -a "$month" -le 12 -a "$day" -le 31 ]; then
            if [ "$month" -eq 02 -a "$day" -gt 29 ] || [ "$leapyear" -ne 0 -a "$month" -eq 02 -a "$day" -gt 28 ]; then
                    retval=0
                    echo "Too many days for February... try again"; exit
            fi
            if [[ "$month30" =~ "$month" ]] && [ "$day" -eq 31 ]; then
                    retval=0
                    echo "Month $month cannot have 31 days... try again"; exit
            fi
    else 
            retval=0
            echo "Date is out of range"; exit
    fi
else 
        retval=0
        echo "try again...expecting format as YYYYMMDD"; exit
fi
retval=1
echo "SUCCESS!"

return $retval
}
date=$indate
validateDate
echo "$retval"
#validateDate $outdate
#find /home/ec2-user/scripts -type f -newermt $indate ! -newermt $outdate
#echo "$output1"
#echo "$output2"




#######
#echo "Enter the days value: "
#read value
#find /home/ec2-user/scripts/ -mtime $value -type f | xargs wc -c |awk '{print $1, $2}'
#######
#if [ -f $var ]
#then
#       temp=temp.txt
#       size=$(wc -c <"$temp")
#       echo $size
#else
 #   echo "nok"
#fi
