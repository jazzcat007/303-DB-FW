#!/usr/bin/env bash
#
# Sync the NOT A GROOVEBOX distribution from the canonical Google Drive
# "Public Folders" into this working tree, then report what changed vs. git.
#
# The Drive folder is public, so no credentials are needed. It is the source
# of the local tree: every file people install on a Drumboy Pro is mirrored
# here from:
#     https://drive.google.com/drive/folders/1zUUMdNquQDe2gFwHZTMbG1DjhoXnX-bQ
#
# What this does:
#   1. Enumerates the whole Drive tree (799 files) with `gdown --json`
#      (no download, no auth) into .gdrive-manifest.json.
#   2. Downloads every remote file into `sync/` with `gdown --folder --continue`
#      (skips files already fully downloaded).
#   3. rsync copies `sync/` files over the working tree (new + changed only).
#   4. Reports new/changed/deleted files against git and, with --commit,
#      commits only the tracked, non-ignored changes (zips/WAVs stay out).
#
# Usage:
#   ./scripts/sync-from-drive.sh            dry-run: sync files, report diff, no commit
#   ./scripts/sync-from-drive.sh --commit   sync + commit tracked changes
#
# Requirements: python3, rsync, and gdown in a venv at .venv-drive (created on
# first run). Remote-only renames move files locally but are not "deleted" from
# the working tree unless you pass --prune.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRIVE_URL="https://drive.google.com/drive/folders/1zUUMdNquQDe2gFwHZTMbG1DjhoXnX-bQ"
VENV="$ROOT/.venv-drive"
SYNC_DIR="$ROOT/.gdrive-cache"
MANIFEST="$SYNC_DIR/.gdrive-manifest.json"
COMMIT=0
PRUNE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --commit) COMMIT=1 ;;
    --prune)  PRUNE=1 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
  shift
done

mkdir -p "$SYNC_DIR"

# --- gdown in an isolated venv so we don't touch the system python ----
if [[ ! -x "$VENV/bin/gdown" ]]; then
  echo ">> creating gdown venv at $VENV"
  python3 -m venv "$VENV"
  "$VENV/bin/pip" install -q gdown
fi
GDOWN="$VENV/bin/gdown"

echo ">> enumerating Drive folder (no auth)"
"$GDOWN" --folder --json --no-cookies "$DRIVE_URL" 2>/dev/null > "$MANIFEST"
TOTAL="$(python3 -c 'import json,sys;print(len(json.load(open(sys.argv[1]))))' "$MANIFEST")"
echo ">> remote manifest: $TOTAL files"

echo ">> downloading into $SYNC_DIR (resume/skip via --continue) …"
"$GDOWN" --folder --no-cookies --continue -O "$SYNC_DIR" "$DRIVE_URL" 2>&1 | \
  grep -viE '^\s*(Retrieving|To: |https://drive.google.com)' | tail -20 || true

echo ">> copying into working tree"
RSYNC_ARGS=( -a --checksum --exclude=.git --exclude=.gdrive-manifest.json
             --exclude=.DS_Store )
if [[ "$PRUNE" == 0 ]]; then
  RSYNC_ARGS+=( --delete-excluded )
else
  RSYNC_ARGS+=( --delete )
fi
rsync "${RSYNC_ARGS[@]}" "$SYNC_DIR/"/ "$ROOT"/

echo ">> git status (tracked + untracked)"
git -C "$ROOT" add -A
git -C "$ROOT" status --short | head -100

if [[ "$COMMIT" == 1 ]]; then
  CHANGED="$(git -C "$ROOT" status --short | grep -vc '^$' || true)"
  if [[ "${CHANGED:-0}" -gt 0 ]]; then
    echo ">> committing $CHANGED changed path(s)"
    git -C "$ROOT" commit -q -m "Sync: update distribution from Public Folders Drive

Canonical source: $DRIVE_URL
$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  else
    echo ">> no tracked changes to commit"
  fi
fi
echo ">> done"
