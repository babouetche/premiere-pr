# TV Thomson 4K (Google TV, Android 14) — interface épurée

## 1. Préparer la TV (2 min, à la télécommande)
1. **Paramètres > Système > À propos** → clique **7 fois** sur « Build Android TV » → « Vous êtes développeur ».
2. **Paramètres > Système > Options pour les développeurs** → active **Débogage USB** (et **Débogage réseau / ADB sans fil** si présent).
3. **Paramètres > Comptes et profils** → ton compte → active **« Applications uniquement »** (Apps only mode) : supprime d'un coup toutes les suggestions de films/séries sponsorisées de l'accueil.

## 2. Depuis un ordi (Mac/Linux) sur le même Wi-Fi
```bash
brew install android-platform-tools   # Mac (Linux : apt install adb)
./epure-tv.sh 192.168.1.11
```
Windows : installer « SDK Platform-Tools » de Google et taper les mêmes commandes `adb` à la main.

## 3. Option « zéro pub » totale
Installer **Projectivy Launcher** (Play Store de la TV) et le choisir comme écran d'accueil : plus aucune bannière, que tes applis.

## Annuler
`./restaure-tv.sh 192.168.1.11` — tout revient comme avant.
