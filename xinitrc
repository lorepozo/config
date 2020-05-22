#!/bin/sh

setxkbmap -option ctrl:nocaps
xinput set-prop bcm5974 "libinput Natural Scrolling Enabled" 1
xinput set-prop bcm5974 "libinput Tapping Drag Enabled" 0
eval $(ssh-agent -s)
# xrandr -s 2560x1600
# xset m 35/3 1

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

exec xmonad
