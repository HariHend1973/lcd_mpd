#!/bin/sh
while true 
do
  echo "$(3ginfo 2> /dev/null)" > /tmp/3ginfotmp;
  sleep 3;
  echo -n "$(/root/mpdlcd/wifi.sh)" > /root/mpdlcd/lcd_wifi.txt;  
  echo -n "$(/root/mpdlcd/txrx.sh)" > /root/mpdlcd/lcd_b2.txt;
  echo -n "$(/root/mpdlcd/ss2.sh)" > /root/mpdlcd/lcd_b3.txt;
  echo -n "$(/root/mpdlcd/temp.sh)" > /root/mpdlcd/lcd_b4.txt;
  #echo -n "$(/root/mpdlcd/ss.sh)" > /root/mpdlcd/lcd_ss.txt;
done &
/etc/init.d/mpd start >/dev/null 2>&1 &
cd /root/mpdlcd/
/usr/bin/python lcd_mpd.py >/dev/null 2>&1 &
exit 0