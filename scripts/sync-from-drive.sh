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
# Modes:
#   --poll     LISTING ONLY. Fetch the Drive tree, print a fingerprint of it,
#              and exit 0. Downloads nothing. This is what the scheduled poll
#              job runs; it costs one folder listing (~2 s, no file bytes).
#   --check    (alias: --poll) same listing, plus a comparison to this tree.
#   --fingerprint FILE
#              write/compare the listing fingerprint at FILE. With an existing
#              FILE, prints "changed" / "unchanged" on the last line.
#   (default)  download changed files, copy them over the tree, report the diff.
#   --commit   additionally commit the tracked, non-ignored changes.
#   --full     re-fetch everything (ignore gdown's resume/skip).
#   --if-changed
#              skip the download entirely when the listing fingerprint matches
#              the one stored in .gdrive-cache/.fingerprint. Lets the scheduled
#              job poll cheaply and only do real work when Drive actually moved.
#
# Requirements: python3, rsync; gdown is installed into a venv at .venv-drive/
# on first run (or point at an existing one with GDOWN=/path/to/gdown).
#
# Design notes:
#   * Never deletes anything from the working tree. Files that exist locally
#     but not on Drive (README.md, LICENSE.md, scripts/, docs/) are the fork's
#     own additions and must survive. Remote-only additions are copied in and
#     removals are *reported*, not applied.
#   * .gitignore still excludes source zips, WAV banks and SD-card runtime
#     data, so those refresh on disk but are never committed.
#   * Drive keeps a file's ID when its contents are replaced, so the listing
#     fingerprint catches *structural* change (files added, removed, renamed)
#     immediately. A same-ID content edit is caught on the next scheduled
#     --full, or by a content hash check in the sync step.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRIVE_URL="https://drive.google.com/drive/folders/1zUUMdNquQDe2gFwHZTMbG1DjhoXnX-bQ"
VENV="${VENV:-$ROOT/.venv-drive}"
SYNC_DIR="${SYNC_DIR:-$ROOT/.gdrive-cache}"
MANIFEST="$SYNC_DIR/.gdrive-manifest.json"
FP_FILE="$SYNC_DIR/.fingerprint"
COMMIT=0
MODE="sync"
FULL=0
IF_CHANGED=0
FP_ARG=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --commit)      COMMIT=1 ;;
    --poll|--check) MODE="poll" ;;
    --full)        FULL=1 ;;
    --if-changed)  IF_CHANGED=1 ;;
    --fingerprint) FP_ARG="${2:-}"; shift ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
  shift
done

mkdir -p "$SYNC_DIR"

# --- gdown: honour an explicit GDOWN=..., else use/create the venv ----
if [[ -n "${GDOWN:-}" ]]; then
  :
elif [[ -x "$VENV/bin/gdown" ]]; then
  GDOWN="$VENV/bin/gdown"
else
  echo ">> creating gdown venv at $VENV"
  python3 -m venv "$VENV"
  "$VENV/bin/pip" install -q --disable-pip-version-check gdown
  GDOWN="$VENV/bin/gdown"
fi

echo ">> enumerating Drive folder (listing only, no file bytes)"
if ! "$GDOWN" --folder --json --no-cookies "$DRIVE_URL" 2>/dev/null > "$MANIFEST"; then
  echo "!! Drive listing failed (network or Drive error)" >&2
  exit 1
fi
TOTAL="$(python3 -c 'import json,sys;print(len(json.load(open(sys.argv[1]))))' "$MANIFEST")"
echo ">> remote manifest: $TOTAL files"

# --- structural fingerprint: sorted "path<TAB>id" over the whole listing ---
FINGERPRINT="$(python3 - "$MANIFEST" <<'PY'
import hashlib, json, sys
entries = json.loads(open(sys.argv[1]).read())
items = sorted((e["path"], e["url"].rsplit("id=", 1)[-1]) for e in entries)
blob = "\n".join(f"{p}\t{i}" for p, i in items)
print(hashlib.sha256(blob.encode()).hexdigest())
PY
)"
echo ">> fingerprint: $FINGERPRINT"

if [[ -n "$FP_ARG" ]]; then
  PREV=""
  [[ -f "$FP_ARG" ]] && PREV="$(tr -d '\r\n' < "$FP_ARG")"
  mkdir -p "$(dirname "$FP_ARG")"
  printf '%s\n' "$FINGERPRINT" > "$FP_ARG"
  if [[ -z "$PREV" ]]; then
    echo "STATE new"
  elif [[ "$PREV" == "$FINGERPRINT" ]]; then
    echo "STATE unchanged"
  else
    echo "STATE changed"
  fi
fi

report_tree_diff() {
  python3 - "$MANIFEST" "$ROOT" <<'PY' || true
import json, pathlib, sys
manifest, root = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
entries = json.loads(manifest.read_text())
remote = {e["path"] for e in entries}
# The fork's own files/dirs; Drive doesn't have these and they must not
# count as drift.
skip_prefix = (".git/", ".github/", ".venv-drive/", ".gdrive-cache/", "docs/", "scripts/")
skip_root = {"README.md", "LICENSE.md", ".gitignore"}
# Files we intentionally relocated; present under a different name, so their
# absence by original path is not drift.
relocated = {"README.txt": "docs/ORIGINAL-README.txt"}
local = set()
for p in root.rglob("*"):
    if not p.is_file():
        continue
    rel = p.relative_to(root).as_posix()
    if rel in skip_root or rel.startswith(skip_prefix):
        continue
    local.add(rel)
missing = sorted(remote - local - relocated.keys())
extra = sorted(local - remote - set(relocated.values()))
for p in missing:
    print(f"  MISSING LOCAL (on Drive): {p}")
for p in extra:
    print(f"  EXTRA LOCAL (not on Drive): {p}")
relocated_note = (f" ({len(relocated)} relocated: "
                  + ", ".join(f"{k}->{v}" for k, v in relocated.items()) + ")"
                  if relocated else "")
print(f"  {len(remote)} remote / {len(local)} local files{relocated_note}"
      + ("" if missing or extra else " — tree matches Drive"))
PY
}

if [[ "$MODE" == "poll" ]]; then
  echo ">> checking tree against Drive (no downloads)"
  report_tree_diff
  echo ">> done (poll mode)"
  exit 0
fi

# --- change gate: skip the expensive download when nothing moved ---
if [[ "$IF_CHANGED" == 1 && "$FULL" == 0 && -f "$FP_FILE" ]]; then
  PREV="$(tr -d '\r\n' < "$FP_FILE")"
  if [[ "$PREV" == "$FINGERPRINT" ]]; then
    echo ">> listing unchanged since last sync — skipping download"
    printf '%s\n' "$FINGERPRINT" > "$FP_FILE"
    report_tree_diff
    echo ">> done (no upstream change)"
    exit 0
  fi
  echo ">> listing changed since last sync — downloading"
fi
printf '%s\n' "$FINGERPRINT" > "$FP_FILE"

echo ">> downloading into $SYNC_DIR (resume/skip via --continue) …"
# --continue makes gdown skip files it believes are already complete and
# resume interrupted ones. --full drops it so everything is re-fetched.
DL_ARGS=( --folder --no-cookies --retries 3 -O "$SYNC_DIR" )
[[ "$FULL" == 1 ]] || DL_ARGS+=( --continue )
"$GDOWN" "${DL_ARGS[@]}" "$DRIVE_URL" 2>&1 | \
  grep -viE '^\s*(Retrieving|To: |https://drive.google.com)' | tail -30 || true

echo ">> copying into working tree"
# -a: preserve modes/times. --checksum: compare bytes so unchanged files keep
# their mtime and git records no diff. NO --delete: see design notes above.
rsync -a --checksum --itemize-changes \
  --exclude=.git --exclude=.gdrive-manifest.json --exclude=.DS_Store \
  "$SYNC_DIR/"/ "$ROOT"/ | sed 's/^/  rsync /' || true

# A failed download must not masquerade as "no changes". Every remote path must
# exist in the cache before we trust the rsync result.
echo ">> verifying download completeness"
MISSING_DL="$(python3 - "$MANIFEST" "$SYNC_DIR" <<'PY'
import json, pathlib, sys
manifest, cache = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
missing = [e["path"] for e in json.loads(manifest.read_text())
           if not (cache / e["path"]).is_file()]
print("\n".join(missing))
PY
)"
if [[ -n "$MISSING_DL" ]]; then
  echo "!! download incomplete — these remote files are not in the cache:" >&2
  printf '%s\n' "$MISSING_DL" | head -20 >&2
  echo "!! not committing a partial sync (re-run to resume with --continue)" >&2
  exit 1
fi
echo "   all remote files present in cache"

echo ">> tree vs Drive"
report_tree_diff

echo ">> git status"
git -C "$ROOT" add -A
git -C "$ROOT" status --short | head -100

if [[ "$COMMIT" == 1 ]]; then
  CHANGED="$(git -C "$ROOT" status --porcelain | grep -c . || true)"
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
