#!/usr/bin/env bash
# Frees emulator storage by wiping AVD user data (factory reset). Emulator must be closed.
set -euo pipefail

export ANDROID_HOME="${ANDROID_HOME:-$HOME/Android/Sdk}"
export PATH="$HOME/flutter/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"

AVD="${1:-Medium_Phone_API_36.0}"
CONFIG="$HOME/.android/avd/Medium_Phone.avd/config.ini"

echo "Cerrando emulador si está abierto..."
adb emu kill 2>/dev/null || true
sleep 2
pkill -f "qemu.*Medium_Phone" 2>/dev/null || true
sleep 1

if [ -f "$CONFIG" ]; then
  if ! grep -q '^disk.dataPartition.size=8589934592' "$CONFIG"; then
    echo "Ampliando partición /data a 8 GB en $CONFIG"
    sed -i 's/^disk.dataPartition.size=.*/disk.dataPartition.size=8589934592/' "$CONFIG"
  fi
fi

echo "Arrancando $AVD con -wipe-data (borra apps y datos del emulador)..."
emulator -avd "$AVD" -wipe-data -no-snapshot-load &

echo "Espera a que arranque el teléfono virtual, luego:"
echo "  adb wait-for-device"
echo "  adb shell getprop sys.boot_completed   # debe devolver 1"
echo "  adb install -r dist/emulador/xisti-debug-full-branding.apk"
