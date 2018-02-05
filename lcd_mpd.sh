#!/bin/sh
while true
do
  echo "$(3ginfo 2> /dev/null)" > /tmp/3ginfotmp;
  sleep 1; -n "$(/root/mpdlcd/temp.sh)" > /root/mpdlcd/lcd_b4.txt;
  echo -n "$(/root/mpdlcd/disk.sh)" > /root/mpdlcd/lcd_disk.txt;
done &
/etc/init.d/mpd start >/dev/null 2>&1 &
cd /root/mpdlcd/
/usr/bin/python lcd_mpd.py >/dev/null 2>&1 &
sh /root/mpdlcd/remote.sh > /dev/null 2>&1 &
exit 0