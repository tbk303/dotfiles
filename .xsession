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

eval `ssh-agent`

urxvtd -q -o -f

#xrandr --output eDP1 --auto --pos 0x0 --output HDMI1 --auto --above eDP1

xbindkeys

stalonetray &
nm-applet &

setxkbmap de nodeadkeys

autocutsel -fork &
autocutsel -selection PRIMARY -fork &

if dropbox; then
  dropbox start
fi

wuala -silent &

exec xmonad



