#!/usr/bin/bash
read indate
read outdate
isValidDate() {
    echo "Validation for date: $1"
    local d="$1"
    date "+%Y-%m-%d" -d "$d" > /dev/null  2>&1
    if [ $? != 0 ]
    then
        echo "Date $d NOT a valid YYYY-MM-DD date"
        exit 1
    fi
    echo "date is valid"
}

isValidDate $date1
