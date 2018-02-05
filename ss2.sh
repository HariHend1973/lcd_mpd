#!/bin/sh
ss="$(grep strength /tmp/3ginfotmp | awk '{print $3}' 2> /dev/null)"

# wifi
wifi="$(cat /proc/net/wireless | awk 'NR==3 {print $4}' | sed 's/\.//')"

# tx/rx
txrx=$(grep Rec /tmp/3ginfotmp | cut -d':' -f 2 | sed 's/ //g' | sed 's/i//g' 2> /dev/null)
tx=$(printf $txrx | cut -d"/" -f 1)
rx=$(printf $txrx | cut -d"/" -f 2)
txB=$(printf $tx | sed 's/[0-9\.]*//g')
rxB=$(printf $rx | sed 's/[0-9\.]*//g')
#tx=${tx%??}
#rx=${rx%??}
#tx=${tx/.*}
#rx=${rx/.*}
#echo -n "U/D: $tx$txB/$rx$rxB"

#echo -n "Modem Signal: $ss"

signal=${ss%?};

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