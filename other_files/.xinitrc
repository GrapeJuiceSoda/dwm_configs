#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xrandr --output eDP1 --mode 1920x1080 --pos 0x1079 --rotate normal --output DP1 --off --output DP1-1 --off --output DP1-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP1-3 --off --output DP2 --off --output HDMI1 --off --output HDMI2 --off --output VIRTUAL1 --off &

picom &

xscreensaver &

start-pulseaudio-x11 &

dunst &

#skippy-xd --start-daemon &

sxhkd &

nm-applet &

flameshot &

ibus
 export GTK_IM_MODULE=ibus
 export XMODIFIERS=@im=ibus
 export QT_IM_MODULE=ibus
 ibus-daemon -drx &

xset s off # Disable screen saver blinking

xset -dpms # Turns on display power management signaling (+dpms to turn on)

xclock & 

xload &

stalonetray --geometry 5x1-0+320 -bg "#808080" --window-strut none &

exec ctwm

#exec dwm

#slstatus &

#exec rio -term termite
