#!/usr/bin/bash
read indate
read outdate
isValidDate() {
    local d="$1"
    date "+%Y-%m-%d" -d "$d"
    if [ $? != 0 ]
    then
        retval=0
        return $retval
        exit 1
    fi
    retval=1
    return $retval
    
}


isValidDate $indate
if [ $retval -eq 1 ]
then
        echo "In date is valid"
        isValidDate $outdate
        if [ $retval -eq 1 ]
        then
                echo "Out date is valid"
                echo " Finding files..."
                find /home/ec2-user/scripts -type f -newermt $indate ! -newermt $outdate
        else
                echo "Out date is invalid. Ending the flow"
        fi
else
        echo "In date is invalid. Ending the flow"
fi
