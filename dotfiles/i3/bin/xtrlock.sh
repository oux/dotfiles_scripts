# env > /tmp/xtrlock.log
xset dpms force off &>> /tmp/xtrlock.log
sleep 5
if xset q |grep -q "Monitor is Off"
then
    xdotool key --clearmodifiers F12 
    xset dpms force off &>> /tmp/xtrlock.log
    xtrlock
fi
