#!/bin/sh
stty -F /dev/ttyACM0 9600 cs8 -cstopb -parenb -icanon min 1 time 1
state="false"
while true; do
        read -n 8 LINE < /dev/ttyACM0
        LINE=$(echo -n $LINE | sed 's/[ \t\r\n]\+//g')
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
        # Play #1
        if [[ "$LINE" == "FF30CF" ]]
        then
           mpc play 1
        fi
        # Play #2
        if [[ "$LINE" == "FF18E7" ]]
        then
           mpc play 2
        fi
        # Play #3
        if [[ "$LINE" == "FF7A85" ]]
        then
           mpc play 3
        fi
        # Play #4
        if [[ "$LINE" == "FF10EF" ]]
        then
           mpc play 4
        fi
        # Play #5
        if [[ "$LINE" == "FF38C7" ]]
        then
           mpc play 5
        fi
        # Play #6
        if [[ "$LINE" == "FF5AA5" ]]
        then
           mpc play 6
        fi
        # Play #7
        if [[ "$LINE" == "FF42BD" ]]
        then
           mpc play 7
        fi
        # Play #8
        if [[ "$LINE" == "FF4AB5" ]]
        then
           mpc play 8
        fi
        # Play #9
        if [[ "$LINE" == "FF52AD" ]]
        then
           mpc play 9
        fi
        # Play #0
        if [[ "$LINE" == "FF6897" ]]
        then
           mpc play 10
        fi
done
