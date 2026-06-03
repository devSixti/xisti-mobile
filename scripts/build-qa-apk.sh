#!/usr/bin/env bash
# Builds one debug APK in dist/ (replaces any previous *.apk).
# Usage:
#   ./scripts/build-qa-apk.sh          # teléfono físico (arm64, ~110 MB)
#   ./scripts/build-qa-apk.sh emulator # emulador x86_64 (~110 MB, no fat 157 MB)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export PATH="${FLUTTER_ROOT:-$HOME/flutter}/bin:${ANDROID_HOME:-$HOME/Android/Sdk}/platform-tools:$PATH"

TARGET="${1:-phone}"
OUT_NAME="xisti-debug-full-branding.apk"
API_DOMAIN="${API_DOMAIN:-http://54.159.169.235}"

mkdir -p dist
rm -f dist/*.apk

echo "Building QA APK (target=$TARGET, API_DOMAIN=$API_DOMAIN)..."
if [ "$TARGET" = "emulator" ]; then
  flutter build apk --debug --split-per-abi \
    --target-platform android-x64 \
    --dart-define=API_DOMAIN="$API_DOMAIN"
  SRC="build/app/outputs/flutter-apk/app-x86_64-debug.apk"
else
  flutter build apk --debug --split-per-abi \
    --target-platform android-arm64 \
    --dart-define=API_DOMAIN="$API_DOMAIN"
  SRC="build/app/outputs/flutter-apk/app-arm64-v8a-debug.apk"
fi

cp -f "$SRC" "dist/$OUT_NAME"
ls -lh "dist/$OUT_NAME"
echo "Done: dist/$OUT_NAME ($TARGET)"
