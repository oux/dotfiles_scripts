#!/bin/bash

if $(xrandr |grep -q 'VGA-1[^x]*(')
then
    xrandr --output DP-1 --auto
    xrandr --output VGA-1 --auto --right-of DP-1
else
    xrandr --output VGA-1 --off
fi
