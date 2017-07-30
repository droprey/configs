#!/usr/bin/env bash
# Modified from https://www.reddit.com/r/unixporn/comments/3358vu/i3lock_unixpornworthy_lock_screen/cqkmxxi

tmpbg='/tmp/screen.png'

(( $# )) && { icon=$1; }

scrot "$tmpbg"
convert "$tmpbg" -scale 5% -scale 2000% "$tmpbg"
i3lock -u -i "$tmpbg"
amixer -D pulse sset Master mute
sleep 5; xrandr --output eDP-1 --brightness 0.2
sleep 55; pgrep i3lock && xset dpms force off; xrandr --output eDP-1 --brightness 1.0
