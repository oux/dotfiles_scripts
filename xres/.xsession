# xrandr --output DP1 --auto --left-of VGA1 --rotate left
xrandr --output DP1 --auto --right-of VGA1
xrandr --output VGA1 --auto
#xrandr --output DP1 --pos 0x-620
#xrandr --output DP1 --pos 0x0
##xrandr --output VGA1 --pos 1200x130

xsetroot -solid darkgrey
compton --vsync drm -b
# rofi -key-window SuperL+Tab -key-run SuperL+d -font "snap 10" -fg "#505050" -bg "#000000" -hlfg "#ffb964" -hlbg "#000000" -o 85
#synergys
#sudo ionice -c 1 -n 1 -p $(pidof synergys)

#blueproximity &
rofi -modi "window,run,win:i3_switch_containers.py,cwd:urxvt_select_cwd.sh" -key-window mod4+Tab -key-win Shift+mod4+Tab -key-run mod4+d -key-cwd Shift+mod4+Return -quiet &
exec i3
