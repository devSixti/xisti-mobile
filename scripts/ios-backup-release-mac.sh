#!/usr/bin/env bash
# Build + upload XISTI iOS to TestFlight from a Mac (backup when GitHub Actions iOS CD hangs).
# Requires: macOS, Xcode, Flutter 3.41.x, Ruby 3.2+, network.
#
# 1) Copy ios/xisti-ios-secrets.local.env.example → ios/xisti-ios-secrets.local.env
# 2) Fill values from GitHub repo secrets (devSixti/xisti-mobile)
# 3) ./scripts/ios-backup-release-mac.sh
#
# Optional SSH: run this script ON the Mac (local Terminal or ssh user@your-mac).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SECRETS_FILE="${SECRETS_FILE:-$ROOT/ios/xisti-ios-secrets.local.env}"
if [[ ! -f "$SECRETS_FILE" ]]; then
  echo "Missing $SECRETS_FILE" >&2
  echo "Copy ios/xisti-ios-secrets.local.env.example and fill from GitHub Secrets." >&2
  exit 1
fi

# shellcheck disable=SC1090
set -a
source "$SECRETS_FILE"
set +a

for v in APPLE_TEAM_ID APP_STORE_CONNECT_API_KEY_ID APP_STORE_CONNECT_ISSUER_ID \
  APP_STORE_CONNECT_API_KEY MATCH_PASSWORD MATCH_GIT_URL MATCH_GIT_BASIC_AUTHORIZATION; do
  if [[ -z "${!v:-}" ]]; then
    echo "Missing required env: $v in $SECRETS_FILE" >&2
    exit 1
  fi
done

export DART_DEFINES="${DART_DEFINES:---dart-define=API_DOMAIN=https://admin.xistiapp.com}"
export COCOAPODS_DISABLE_STATS=true

echo "==> Flutter pub get"
flutter pub get

echo "==> Ruby gems (ios/)"
cd ios
bundle install
cd ..

echo "==> Fastlane deploy_app_store (Match + IPA + TestFlight)"
cd ios
bundle exec fastlane deploy_app_store
cd ..

echo "Done. Check App Store Connect → TestFlight."
