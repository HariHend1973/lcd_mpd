#!/bin/bash
while true
do
  echo "$(3ginfo 2> /dev/null)" > /tmp/3ginfotmp;
  # some delay :)
  for i in {1..1000}; do echo $i > /dev/null; done
  echo -n "$(/root/mpdlcd/temp.sh)" > /root/mpdlcd/lcd_b4.txt;
  echo "$(/root/mpdlcd/disk.sh)" > /root/mpdlcd/lcd_disk.txt;
done &
/etc/init.d/mpd start >/dev/null 2>&1 &
cd /root/mpdlcd/
sleep 5 && /usr/bin/python lcd_mpd.py >/dev/null 2>&1 &
sleep 5 && sh /root/mpdlcd/remote.sh > /dev/null 2>&1 &
exit 0