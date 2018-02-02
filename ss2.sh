#!/bin/sh
ss="$(grep strength /tmp/3ginfotmp | awk '{print $3}' 2> /dev/null)"
#echo -n "Modem Signal: $ss"

signal=${ss%?};

if [ $signal -eq 0 ]
   then
	#echo -n "4G Signal: $(echo $'\xDB\xDB\xDB\xDB\xDB') $ss"
	echo "signal0"
	echo " $ss"
fi
if [ $signal -gt 0 ] && [ $signal -lt 21 ]
   then
	#echo -n "4G Signal: $(echo $'\xFF\xDB\xDB\xDB\xDB') $ss"
	echo "signal20"
	echo " $ss"
fi
if [ $signal -gt 20 ] && [ $signal -lt 41 ]
   then
	#echo -n "4G Signal: $(echo $'\xFF\xFF\xDB\xDB\xDB') $ss"
	echo "signal40"
	echo " $ss"
fi
if [ $signal -gt 40 ] && [ $signal -lt 61 ]
   then
	#echo -n "4G Signal: $(echo $'\xFF\xFF\xFF\xDB\xDB') $ss"
	echo "signal60"
	echo " $ss"
fi
if [ $signal -gt 60 ] && [ $signal -lt 81 ]
   then
	#echo -n "4G Signal: $(echo $'\xFF\xFF\xFF\xFF\xDB') $ss"
	echo "signal80"
	echo " $ss"
fi
if [ $signal -gt 80 ] && [ $signal -lt 101 ]
   then
	#echo -n "4G Signal: $(echo $'\xFF\xFF\xFF\xFF\xFF') $ss"
	echo "signal100"
	echo " $ss"
fi
