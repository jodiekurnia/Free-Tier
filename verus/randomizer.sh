#!/bin/bash
program=$1
min=$2
max=$3
while [ 1 ]
do
core=$(lscpu | egrep '^CPU\(s\):' | awk -v FS=: '{print $2}' | tr -d '[:blank:]' )
(( full = $core * 100 ))
(( low = $(( $full * $min )) / 100 ))
(( high = $(( $full * $max )) / 100 ))
limit=$(shuf -i $low-$high -n 1)
timer=$(shuf -i 100-500 -n 1)
sleep $timer
screen -X -S limit quit || echo "limit terminated"
screen -dmS limit cpulimit -l $limit -e $program
done