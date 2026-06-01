#!/usr/bin/env bash
# Push a devSixti/xisti-mobile — GitHub Jeronimo0228 (jeronimorestrepo48@gmail.com)
set -euo pipefail
cd "$(dirname "$0")/.."
git remote set-url origin git@github.com-jeronimo0228:devSixti/xisti-mobile.git
git push -u origin "${1:-main}"
