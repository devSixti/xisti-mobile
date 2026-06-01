#!/usr/bin/env bash
# Push a devSixti/xisti-mobile usando SSH de JeronimoRestrepo48 (jeronimorestrepo48@gmail.com)
set -euo pipefail
cd "$(dirname "$0")/.."
git remote set-url origin git@github.com-jeronimo:devSixti/xisti-mobile.git
git push -u origin "${1:-main}"
