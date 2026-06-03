#!/usr/bin/env bash
# Builds a single debug APK for QA. Replaces any previous APK in dist/.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

OUT_NAME="xisti-debug-full-branding.apk"
API_DOMAIN="${API_DOMAIN:-http://54.159.169.235}"

mkdir -p dist
rm -f dist/*.apk

echo "Building QA APK (API_DOMAIN=$API_DOMAIN)..."
flutter build apk --debug \
  --dart-define=API_DOMAIN="$API_DOMAIN"

cp -f build/app/outputs/flutter-apk/app-debug.apk "dist/$OUT_NAME"
ls -lh "dist/$OUT_NAME"
echo "Done: dist/$OUT_NAME"
