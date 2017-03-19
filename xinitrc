#!/bin/sh

setxkbmap -option ctrl:nocaps
# xrandr -s 2560x1600
# xset m 35/3 1
eval $(ssh-agent -s)

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

exec xmonad
