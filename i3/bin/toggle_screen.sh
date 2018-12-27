#!/bin/bash

if $(xrandr |grep -q 'VGA1[^x]*(')
then
    xrandr --output DP1 --auto
    xrandr --output VGA1 --auto --right-of DP1
else
    xrandr --output VGA1 --off
fi
