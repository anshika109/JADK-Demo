#!/bin/bash
echo -n "Enter the date as YYYYMMDD >"
read date
if [ ${#date} -eq 8 ]; then
    year=${date:0:4}
    month=${date:4:2}
    day=${date:6:2}
    month30="04 06 09 11"
    leapyear=$((year%4)) # if leapyear this is 0
    if [ "$year" -ge 1901 -a "$month" -le 12 -a "$day" -le 31 ]; then
            if [[ "$month30" =~ "$month" ]] && [ "$day" -eq 31 ]; then
                    echo "Month $month cannot have 31 days... try again"; exit
            fi
    else echo "Date is out of range"; exit
    fi
else echo "try again...expecting format as YYYYMMDD"; exit
fi
echo "SUCCESS!"
return 1;
