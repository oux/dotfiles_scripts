#!/bin/bash -x


xdotool key --clearmodifiers F12
xset dpms force off
date >> /tmp/toto
echo LOCK >> /tmp/toto
i3lock -c 653356
date >> /tmp/toto
echo UNLOCK >> /tmp/toto
xrandr >> /tmp/toto

#CMD="i3lock -nc 653356"
#LOG=/tmp/totolock
#$CMD &
#echo "loop" >> $LOG
#while true
#do
#    jobs
#    PID=$(jobs -p)
#    test "$PID" || break
#    echo "acting" > $LOG
#    test "$(xset q |grep "Monitor is On")" && xset dpms force off
#    sleep 4
#done
#echo end >> $LOG
