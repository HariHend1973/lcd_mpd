#!/bin/sh
temp="$(gigi sbc | grep Temperature | cut -f 3 -d' ')"
temp=${temp%???}
degree="$(echo $'\xDF'C)"
echo -n "$temp$degree"
