#!/bin/bash

if $(xrandr |grep -q 'VGA1[^x]*(')
then
    xrandr --output VGA1 --auto
    xrandr --output DP1 --auto --right-of VGA1
else
    xrandr --output VGA1 --off
fi
