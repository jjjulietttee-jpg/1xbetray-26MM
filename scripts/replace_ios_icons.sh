#!/bin/sh
# Копирует иконки из assets/app_icons в ios/Runner/Assets.xcassets/AppIcon.appiconset
# Запуск из корня проекта: sh scripts/replace_ios_icons.sh

set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
A="$ROOT/assets/app_icons/Assets.xcassets/AppIcon.appiconset"
B="$ROOT/ios/Runner/Assets.xcassets/AppIcon.appiconset"

cp -f "$A/29.png"   "$B/Icon-App-29x29@1x.png"
cp -f "$A/58.png"   "$B/Icon-App-29x29@2x.png"
cp -f "$A/87.png"   "$B/Icon-App-29x29@3x.png"
cp -f "$A/40.png"   "$B/Icon-App-20x20@2x.png"
cp -f "$A/60.png"   "$B/Icon-App-20x20@3x.png"
cp -f "$A/40.png"   "$B/Icon-App-20x20@1x.png"
cp -f "$A/80.png"   "$B/Icon-App-40x40@2x.png"
cp -f "$A/120.png"  "$B/Icon-App-40x40@3x.png"
cp -f "$A/40.png"   "$B/Icon-App-40x40@1x.png"
cp -f "$A/120.png"  "$B/Icon-App-60x60@2x.png"
cp -f "$A/180.png"  "$B/Icon-App-60x60@3x.png"
cp -f "$A/80.png"   "$B/Icon-App-76x76@1x.png"
cp -f "$A/180.png"  "$B/Icon-App-76x76@2x.png"
cp -f "$A/180.png"  "$B/Icon-App-83.5x83.5@2x.png"
cp -f "$A/1024.png" "$B/Icon-App-1024x1024@1x.png"

echo "iOS AppIcon replaced from assets/app_icons."
