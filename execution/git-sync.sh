#!/usr/bin/env bash
# Syncs the OpenClaw workspace to GitHub. No AI involved — pure shell.
set -e

WORKSPACE="/home/openclaw/.openclaw/workspace"
LOG="/tmp/openclaw-git-sync.log"

cd "$WORKSPACE"

# Stage all changes
git add -A

# Only commit if there's something staged
if ! git diff --cached --quiet; then
  git commit -m "Auto-sync: memory update $(date -u '+%Y-%m-%d %H:%M UTC')"
  git push origin main
  echo "[$(date -u '+%Y-%m-%d %H:%M UTC')] Pushed changes" >> "$LOG"
else
  echo "[$(date -u '+%Y-%m-%d %H:%M UTC')] No changes" >> "$LOG"
fi
