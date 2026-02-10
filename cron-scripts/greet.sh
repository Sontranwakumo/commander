#!/bin/bash
# Chạy commander aim-scan --off (cron 17:30 hoặc test lúc phút 33)
COMMANDER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_FILE="$COMMANDER_DIR/logs/greet.log"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"; }

cd "$COMMANDER_DIR" || exit 1
# Cron không có PATH đầy đủ — thêm chỗ thường cài node (Homebrew, nvm)
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"

log "START cron greet"
node "$COMMANDER_DIR/index.js" greet --name "Artteiv" --lang vi >> "$LOG_FILE" 2>&1
exit_code=$?
log "END exit_code=$exit_code"
exit $exit_code
