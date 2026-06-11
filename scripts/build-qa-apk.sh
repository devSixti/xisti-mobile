#!/usr/bin/env bash
# Builds one debug APK under dist/emulador or dist/celular (replaces old APK in that folder).
# Usage:
#   ./scripts/build-qa-apk.sh              # teléfono físico → dist/celular/
#   ./scripts/build-qa-apk.sh celular      # igual que arriba
#   ./scripts/build-qa-apk.sh emulador     # emulador x86_64 → dist/emulador/
#   ./scripts/build-qa-apk.sh emulator     # alias de emulador
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export PATH="${FLUTTER_ROOT:-$HOME/flutter}/bin:${ANDROID_HOME:-$HOME/Android/Sdk}/platform-tools:$PATH"

TARGET="${1:-celular}"
OUT_NAME="xisti-debug-full-branding.apk"
API_DOMAIN="${API_DOMAIN:-https://admin.xistiapp.com}"

case "$TARGET" in
  emulador|emulator)
    DIST_DIR="dist/emulador"
    PLATFORM_ARGS=(--target-platform android-x64)
    SRC_ABI="app-x86_64-debug.apk"
    ;;
  celular|phone)
    DIST_DIR="dist/celular"
    PLATFORM_ARGS=(--target-platform android-arm64)
    SRC_ABI="app-arm64-v8a-debug.apk"
    ;;
  *)
    echo "Uso: $0 [celular|emulador]" >&2
    exit 1
    ;;
esac

mkdir -p "$DIST_DIR"
rm -f "$DIST_DIR"/*.apk
# Limpieza de layout antiguo (APK sueltos en dist/)
rm -f dist/*.apk 2>/dev/null || true

echo "Building QA APK → $DIST_DIR (API_DOMAIN=$API_DOMAIN)..."
flutter build apk --debug --split-per-abi \
  "${PLATFORM_ARGS[@]}" \
  --dart-define=API_DOMAIN="$API_DOMAIN"

SRC="build/app/outputs/flutter-apk/$SRC_ABI"
cp -f "$SRC" "$DIST_DIR/$OUT_NAME"
ls -lh "$DIST_DIR/$OUT_NAME"
echo "Done: $DIST_DIR/$OUT_NAME"
