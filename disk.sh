#!/bin/sh
size=$(df -h | grep "/dev/root" | awk '{print $2}')
used1=$(df -h | grep "/dev/root" | awk '{print $3}')
avail=$(df -h | grep "/dev/root" | awk '{print $4}')

mem=$(free | grep Mem)
total=$(free | grep Mem | awk '{print $2}')
used2=$(free | grep Mem | awk '{print $3}')
free=$(free | grep Mem | awk '{print $4}')
shared=$(free | grep Mem | awk '{print $5}')
buffer=$(free | grep Mem | awk '{print $6}')
cached=$(free | grep Mem | awk '{print $7}')

total=$((total/1024))
used2=$((used2/1024))
free=$((free/1024))
shared=$((shared/1024))
buffer=$((buffer/1024))
cached=$((cached/1024))

cpu=$(top -bn 1 | head -n 5 | grep "CPU:" | awk '{print $1, $2}')
usr=$(top -bn 1 | head -n 5 | grep "CPU:" | awk '{print $3, $4}')
nic=$(top -bn 1 | head -n 5 | grep "CPU:" | awk '{print $7, $8}')
irq=$(top -bn 1 | head -n 5 | grep "CPU:" | awk '{print $13, $14}')

# 3ginfo
ss="$(grep strength /tmp/3ginfotmp | awk '{print $3}' 2> /dev/null)"
# wifi
wifi="$(cat /proc/net/wireless | awk 'NR==3 {print $4}' | sed 's/\.//')"
# tx/rx
txrx=$(grep Rec /tmp/3ginfotmp | cut -d':' -f 2 | sed 's/ //g' | sed 's/i//g' 2> /dev/null)
tx=$(printf $txrx | cut -d"/" -f 1)
rx=$(printf $txrx | cut -d"/" -f 2)
txB=$(printf $tx | sed 's/[0-9\.]*//g')
rxB=$(printf $rx | sed 's/[0-9\.]*//g')
signal=${ss%?};

echo "S:$size U:$used1"
echo "available: $avail"
echo "T:"$total"M U:"$used2"M S:"$shared"M"
echo "B:"$buffer"M C:"$cached"M F:"$free"M"
echo $cpu" "$usr
echo $nic" "$irq
if [ $signal -eq 0 ]
   then
        #echo -n "4G Signal: $(echo $'\xDB\xDB\xDB\xDB\xDB') $ss"
        echo "signal0"
fi
if [ $signal -gt 0 ] && [ $signal -lt 21 ]
   then
        #echo -n "4G Signal: $(echo $'\xFF\xDB\xDB\xDB\xDB') $ss"
        echo "signal20"
fi
if [ $signal -gt 20 ] && [ $signal -lt 41 ]
   then
        #echo -n "4G Signal: $(echo $'\xFF\xFF\xDB\xDB\xDB') $ss"
        echo "signal40"
fi
if [ $signal -gt 40 ] && [ $signal -lt 61 ]
   then
        #echo -n "4G Signal: $(echo $'\xFF\xFF\xFF\xDB\xDB') $ss"
        echo "signal60"
fi
if [ $signal -gt 60 ] && [ $signal -lt 81 ]
   then
        #echo -n "4G Signal: $(echo $'\xFF\xFF\xFF\xFF\xDB') $ss"
        echo "signal80"
fi
if [ $signal -gt 80 ] && [ $signal -lt 101 ]
   then
        #echo -n "4G Signal: $(echo $'\xFF\xFF\xFF\xFF\xFF') $ss"
        echo "signal100"
fi
echo " $ss"
echo "${wifi}dBm"
echo "$tx/$rx"