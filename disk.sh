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

echo "S:$size U:$used1"
echo "available: $avail"
echo "T:"$total"M U:"$used2"M S:"$shared"M"
echo "B:"$buffer"M C:"$cached"M F:"$free"M"
echo $cpu" "$usr
echo $nic" "$irq