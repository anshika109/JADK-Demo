#!/bin/bash
#read var1
#function function1()
#{
#       echo "$var1"
#}

#function1 $var1

#!/bin/bash
echo -n "Enter the date as YYYYMMDD >"
read date
if [ ${#date} -eq 8 ]; then
                year=${date:0:4}
                month=${date:4:2}
                day=${date:6:2}
                month30="04 06 09 11"
                if [[ "$month30" =~ "$month" ]] && [ "$day" -eq 31 ]; then
                echo "Month $month cannot have 31 days... try again"; exit
            fi
            else echo "Date is out of range"; exit
fi        
else echo "try  again...expecting format as YYYYMMDD"; exit
fi
return 1        
echo "SUCCESS!"
