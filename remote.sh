#!/bin/sh
stty -F /dev/ttyACM0 9600 cs8 -cstopb -parenb -icanon min 1 time 1
state="false"
while true; do
        read -n 8 LINE < /dev/ttyACM0
        LINE=$(echo -n $LINE | sed 's/[ \t\r\n]*//g')
        echo $LINE
        # PREV
        if [[ "$LINE" == "FF22DD" ]]
        then
           mpc prev
        fi
        # NEXT
        if [[ "$LINE" == "FF02FD" ]]
        then
           mpc next
        fi
        # VOLUME DOWN -10
        if [[ "$LINE" == "FFE01F" ]]
        then
           mpc volume -10
        fi
        if [[ "$LINE" == "FFA857" ]]
        # VOLUME UP +10
        then
           mpc volume +10
        fi
        # mpc clear && mpc load Radio && mpc play
        if [[ "$LINE" == "FF906F" ]]
        then
           mpc clear && mpc load Radio && mpc play
        fi
        # mpc clear && mpc load "the beatles" && mpc play
        if [[ "$LINE" == "FF9867" ]]
        then
           mpc clear && mpc load "the beatles" && mpc play
        fi
        # POWER OFF
        if [[ "$LINE" == "FFA25D" ]]
        then
           poweroff
        fi
        # PLAY/PAUSE TOGGLE
        if [[ "$LINE" == "FFC23D" ]] && [[ "$state" == "false" ]]
        then
           mpc play
           state="true"
        elif [[ "$LINE" == "FFC23D" ]] && [[ "$state" == "true" ]]
        then
           mpc stop
           state="false"
        fi
done
