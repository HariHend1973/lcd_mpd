#!/bin/sh
wifi="$(cat /proc/net/wireless | awk 'NR==3 {print $4}' | sed 's/\.//')"
echo -n "${wifi}dBm"

#sstmp=${ss:1}
#signal=${sstmp%.*}

