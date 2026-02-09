#!/bin/bash
# Chạy commander aim-scan --off (dùng bởi cron lúc 17:30)
#
# Test thủ công (giống môi trường cron):
#   /Users/artteiv/Desktop/Workspace/commander/scripts/cron-aim-scan-off.sh
#
# Log (khi chạy qua cron): <project>/logs/aim-scan-off.log
#
COMMANDER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$COMMANDER_DIR" || exit 1
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"
node "$COMMANDER_DIR/index.js" aim-scan --off
