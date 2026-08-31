#!/usr/bin/env bash
LOG="$HOME/Library/Logs/gatekeeper.log"
GATEKEEPER="$(command -v gatekeeper || echo /usr/local/bin/gatekeeper)"
{
  echo "=== $(date -u +"%Y-%m-%d %H:%M:%SZ") ==="
  "$GATEKEEPER" status 2>&1 || echo "gatekeeper status failed (exit code: $?)"
  echo "--- gatekeeper list ---"
  "$GATEKEEPER" list 2>&1 || echo "gatekeeper list failed (exit code: $?)"
  echo ""
} >> "$LOG"
