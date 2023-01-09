#!/bin/bash
if [ -e temp.txt ]
then
        temp=temp.txt
        size=$(wc -c <"$temp")
        echo $size
else
    echo "nok"
fi
