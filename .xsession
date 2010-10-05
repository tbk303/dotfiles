#!/bin/bash

# Load resources

#source ~/.profile

xrdb -merge .Xresources
  
# Set up an icon tray
   
#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent true --tint 0x000000 --height 12 &

# Set up the mouse

#imwheel -k
#xmodmap ~/.Xmodmap
#xsetroot -cursor_name left_ptr

# Set the background color
xsetroot -solid black 

# Fire up apps
xscreensaver -no-splash &

export OOO_FORCE_DESKTOP=gnome

eval `ssh-agent`

urxvtd -q -o -f

xrandr --output HDMI2 --auto --pos 0x0 --output HDMI1 --auto --right-of HDMI2

xbindkeys

stalonetray &
nm-applet &

setxkbmap de nodeadkeys

exec xmonad



