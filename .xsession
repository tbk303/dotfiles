#!/bin/bash

#export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Load resources
xrdb -merge .Xresources

# Set the background color
xsetroot -solid black 

# Fire up apps

eval `ssh-agent`

urxvtd -q -o -f

xbindkeys

stalonetray &
gnome-settings-daemon &
gnome-session &
gnome-screensaver &

# Set up the trackpad

# Disable tapping
synclient TapButton1=0

# Enable palm detect
synclient PalmDetect=1

# Enable two finger right click
synclient TapButton2=3

# Disable right button area click
synclient RTCornerButton=0
synclient RBCornerButton=0
synclient RightButtonAreaLeft=0
synclient RightButtonAreaTop=0

# Disable right edge scrolling
synclient VertEdgeScroll=0

# Disable trackpad while typing
syndaemon -i 2 -d -t

#setxkbmap de nodeadkeys

autocutsel -fork &
autocutsel -selection PRIMARY -fork &

wuala -silent &

xbacklight '=70'
xset +dpms
xset dpms 300 300 600

dbus-launch nm-applet &

exec xmonad



