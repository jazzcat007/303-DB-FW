# 303-DB-FW

**Unofficial fork / mirror** of the *NOT A GROOVEBOX* firmware collection published by
[303 Resistance](https://www.instagram.com/303resistance) for the **Drumboy Pro** groovebox.

> This repository is **not** affiliated with, endorsed by, or maintained by 303 Resistance.
> The upstream source repositories (`notagroovebox/<app>`) are private and not published on
> GitHub, so this fork preserves the public distribution — stock firmware builds, user guides
> and documentation — alongside pinned references to the exact upstream commits each release
> was built from. See [`docs/UPSTREAM.md`](docs/UPSTREAM.md).

> **Canonical source** is 303 Resistance's public Google Drive folder:
> <https://drive.google.com/drive/folders/1zUUMdNquQDe2gFwHZTMbG1DjhoXnX-bQ>.
> This repo is kept in sync with it — see [Keeping up to date](#keeping-up-to-date).

## Contents

| App | Version | Firmware | Source |
| --- | --- | --- | --- |
| [Aphex Boy](Aphex%20Boy%200.02) | 0.02 | `APHEX` — generative glitch electronica: polymeter, drills, grains; MIXER, drum kits, pads, scenes, MIDI MAP | Full — `notagroovebox/aphex-boy` @ `e77162c` |
| [Ambient Boy](Ambient%20Boy%200.03) | 0.03 | `AMBIENT DRIFT` — generative ambient, live grains | Full — `notagroovebox/ambient-boy` @ `5aae6b6` |
| [Berlin Boy](Berlin%20Boy%200.12) | 0.12 | `BERLIN` — generative Berlin techno; MIXER, drum kits, pads, scenes, MIDI MAP | Full — `notagroovebox/berlin-boy` @ `8d82468` |
| [Granular Boy](Granular%20Boy%200.06) | 0.06 | Granular instrument built from your own samples | Full — `notagroovebox/granular-boy` @ `ef13809` |
| [Studio Boy](Studio%20Boy%204.92) | 4.92 | The full studio: 303, drums, ACID SYNTH, sequencers, sampler | **Partial** — instruments & effects only, `5d016ad1` |
| [Techno Boy](Techno%20Boy%209.92) | 9.92 | APHEX, BERLIN and INSANE mixed live | Full — `notagroovebox/techno-boy` @ `67d4d78` |
| [Launch Boy With All Apps](Launch%20Boy%20With%20All%20Apps) | 1.03 | Multi-app boot menu — every app on one card, chosen at power-on | Full — `caf2b49` (builds against Techno Boy's board code) |

The per-app folders contain the firmware for the box's stock bootloader, the User Guide, and —
where 303 Resistance released it — the source archive.

## What this fork adds

- A single index (this README) of every app, version and firmware file.
- [`docs/UPSTREAM.md`](docs/UPSTREAM.md) — upstream repo, commit, and archive filename for each
  release, plus the Studio Boy partial-source breakdown.
- A `LICENSE.md` covering the documentation/firmware terms.
- A `.gitignore` that keeps large binaries (source zips, WAV sample banks) out of the repo;
  they remain in the [original distribution](#getting-the-source-code).

## Installing an app

1. Format a microSD card as **FAT32**.
2. Copy the app's SD Card folder contents to the card root:
   - Aphex Boy → contents of its `Firmware` folder
   - Studio Boy → its single firmware file
   - everyone else → contents of `SD Card/`
3. Keep exactly **one** `Drumboy_Pro_Fw` file at the card root, insert, and power on.

`Launch Boy With All Apps` is a complete card image: copy everything to the root, power on, and
choose an app from the Launch Boy menu (`+`/`-` to change, `|||` to start).

Each app folder's `README.txt` has the details.

## Getting the source code

Upstream does not publish code on GitHub. The distribution ships each release as a git-archive
zip in each app's `Source Code/` folder (Studio Boy: `Instruments and Effects/`). Restore those
archives from the original download into this tree — they are matched by `.gitignore`, so they
stay out of git — then the commit hashes in [`docs/UPSTREAM.md`](docs/UPSTREAM.md) line them up
with upstream:

```sh
unzip "<App> <ver>/Source Code/<Archive>.zip" -d vendor/<app>
```

## Keeping up to date

This repo mirrors 303 Resistance's public Drive folder
([`Public Folders`](https://drive.google.com/drive/folders/1zUUMdNquQDe2gFwHZTMbG1DjhoXnX-bQ)),
which is the upstream distribution point for these apps. To pull the latest files into the
tree, diff them against `main`, and optionally commit:

```sh
./scripts/sync-from-drive.sh            # sync files, show git diff, no commit
./scripts/sync-from-drive.sh --commit   # sync + commit the tracked changes
```

What it does, step by step:

1. Enumerates the whole Drive tree (no credentials needed — it's public) with `gdown --json`.
2. Downloads/resumes every file into `.gdrive-cache/`, skipping already-fetched files.
3. Copies new/changed files over the working tree with `rsync --checksum`.
4. Reports the git diff, and (with `--commit`) commits only the tracked, non-ignored changes.

`.gitignore` still keeps the source zips, WAV sample banks and SD-card runtime data out of git;
the sync refreshes them on disk but they are never pushed. `scripts/sync-from-drive.sh` creates
its own `gdown` venv under `.venv-drive/` on first run.

The exact set of files is captured in the (git-ignored) `.gdrive-cache/.gdrive-manifest.json`
if you want to diff the Drive folder against the tree without re-downloading.

## Licence

Free for non-commercial use. The apps are released under the
[**PolyForm Noncommercial License 1.0.0**](https://polyformproject.org/licenses/noncommercial/1.0.0),
Copyright (c) 2026 303 Resistance, with trademark and notice terms — see [`LICENSE.md`](LICENSE.md).
Aphex Boy 0.02 and the Studio Boy partial source ship under their own terms in their folders.
