#!/usr/bin/env bash
# Épure une TV Thomson (Google TV / Android TV 14) via ADB.
# Tout est RÉVERSIBLE : on désactive les applis, on ne les supprime pas (voir restaure-tv.sh).
# Usage : ./epure-tv.sh 192.168.1.11
set -u
TV="${1:?Usage: ./epure-tv.sh IP_DE_LA_TV}"

adb connect "$TV:5555" || exit 1
echo "➡️  Accepte la demande 'Autoriser le débogage USB ?' sur la TV si elle s'affiche."
adb -s "$TV:5555" wait-for-device
A="adb -s $TV:5555 shell"

# 1) Pubs et recommandations sponsorisées (recos, écran de veille Ambient, rapports, TalkBack)
PUBS=(
  com.google.android.tvrecommendations
  com.google.android.leanbacklauncher.recommendations
  com.google.android.apps.tv.dreamx
  com.google.android.feedback
  com.google.android.marvin.talkback
)
for p in "${PUBS[@]}"; do
  $A pm disable-user --user 0 "$p" >/dev/null 2>&1 && echo "✅ désactivé : $p" || echo "⏭️  absent : $p"
done

# 2) Fluidité : animations 2x plus rapides
$A settings put global window_animation_scale 0.5
$A settings put global transition_animation_scale 0.5
$A settings put global animator_duration_scale 0.5
echo "✅ animations accélérées"

# 3) Blocage des pubs au niveau réseau (DNS AdGuard)
$A settings put global private_dns_mode hostname
$A settings put global private_dns_specifier dns.adguard-dns.com
echo "✅ DNS anti-pub AdGuard activé"

# 4) Liste des applis installées par Thomson / tiers, pour faire le tri ensemble
echo; echo "📋 Applis non-Google à trier :"
$A pm list packages | sed 's/package://' | grep -v -E '^(com\.google|com\.android|android)' | sort
