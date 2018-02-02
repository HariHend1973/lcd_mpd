#!/bin/sh
while true 
do
  echo "$(3ginfo 2> /dev/null)" > /tmp/3ginfotmp;
  sleep 3;
  # get wifi signal stat
  echo -n "$(/root/mpdlcd/wifi.sh)" > /root/mpdlcd/lcd_wifi.txt;
  # get tx/rx usage stat
  echo -n "$(/root/mpdlcd/txrx.sh)" > /root/mpdlcd/lcd_b2.txt;
  # get modem signal stat
  echo -n "$(/root/mpdlcd/ss2.sh)" > /root/mpdlcd/lcd_b3.txt;
  # get sbc temperature stat (gigi sbc)
  echo -n "$(/root/mpdlcd/temp.sh)" > /root/mpdlcd/lcd_b4.txt;
done &
/etc/init.d/mpd start >/dev/null 2>&1 &
cd /root/mpdlcd/
/usr/bin/python lcd_mpd.py >/dev/null 2>&1 &
exit 0