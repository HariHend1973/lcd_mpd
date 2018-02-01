#!/bin/sh
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
echo -n "$tx/$rx"
