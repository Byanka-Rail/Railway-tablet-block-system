#!/usr/bin/env sh
set -eu
f="${1:-통표폐색_v2.7.2_원본이식.html}"
[ -f "$f" ] || { echo "FAIL: missing $f"; exit 1; }
size=$(wc -c < "$f" | tr -d ' ')
[ "$size" -le 31457280 ] || { echo "FAIL: over 30 MB ($size bytes)"; exit 1; }
head4k=$(head -c 4096 "$f")
printf '%s' "$head4k" | grep -Eiq '<!doctype|<html' || { echo 'FAIL: not HTML'; exit 1; }
if grep -nE '(src|href)=["'"']\./[^"'"']+["'"']|\./three[a-z.]*\.min\.js|AndroidBridgeShim|file:///android_asset' "$f"; then
  echo 'FAIL: sibling/APK reference found'; exit 1
fi
echo "PASS: $f ($size bytes)"
