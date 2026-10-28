#!/usr/bin/env bash
# Annule epure-tv.sh. Usage : ./restaure-tv.sh 192.168.1.11
set -u
TV="${1:?Usage: ./restaure-tv.sh IP_DE_LA_TV}"
adb connect "$TV:5555" || exit 1
A="adb -s $TV:5555 shell"
for p in $($A pm list packages -d | sed 's/package://'); do
  $A pm enable "$p" && echo "♻️  réactivé : $p"
done
for k in window_animation_scale transition_animation_scale animator_duration_scale; do
  $A settings put global "$k" 1
done
$A settings put global private_dns_mode opportunistic
echo "✅ TV remise comme avant"
