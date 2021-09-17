pkill -u $UID polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload primary &
  done
else
  polybar --reload primary &
fi
