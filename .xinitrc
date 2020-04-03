#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# select monitor
#/home/mashin/bin/select_monitor.sh

numlockx &   # для включения NumLock при загрузке X
xrdb ~/.Xresources
setxkbmap -layout "us,ru(winkeys)" -option grp:ctrl_shift_toggle -option ctrl:nocaps
wmname LG3D

#if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
#    eval "$(dbus-launch --sh-syntax --exit-with-session)"
#fi

#exec devmon &
#exec feh --bg-fill "$(find /home/mashin/documents/Other/wallpapers/simple -name "*.png" | shuf -n 1)" &
#exec feh --bg-fill "/home/mashin/documents/Other/wallpapers/simple/Abduction.png" &

#exec ck-launch-session dbus-launch --exit-with-session  startfluxbox
#exec ck-launch-session openbox-session

# clock for dwm
#while xsetroot -name "`date +%R`"
#    do
#        sleep 15
#    done &

exec dbus-launch --sh-syntax --exit-with-session dwm
