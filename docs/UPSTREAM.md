# Upstream reference

This fork mirrors the public *NOT A GROOVEBOX* distribution by **303 Resistance**. Upstream
source lives in private repositories under the `notagroovebox` account and is **not published
on GitHub**; the commit hashes below are the ones each release archive was built from, as
recorded in the app folders' own `README.txt` files.

| App | Upstream repo | Commit | Archive (in the distribution zip) | Scope |
| --- | --- | --- | --- | --- |
| Aphex Boy 0.02 | `notagroovebox/aphex-boy` | `e77162c` | `Source Code/AphexBoy_0_02_source_e77162c.zip` | Full |
| Ambient Boy 0.03 | `notagroovebox/ambient-boy` | `5aae6b6` | `Source Code/AmbientBoy_0_03_source_5aae6b6.zip` | Full (incl. `LICENSE.md`) |
| Berlin Boy 0.12 | `notagroovebox/berlin-boy` | `8d82468` | `Source Code/BerlinBoy_0_12_source_8d82468.zip` | Full |
| Granular Boy 0.06 | `notagroovebox/granular-boy` | `ef13809` | `Source Code/GranularBoy_0_06_source_ef13809.zip` | Full (incl. `LICENSE.md`) |
| Studio Boy 4.92 | *(not published)* | `5d016ad1` | `Instruments and Effects/StudioBoy_Instruments_Effects_source_5d016ad1.zip` | **Partial** |
| Techno Boy 9.92 | `notagroovebox/techno-boy` | `67d4d78` | `Source Code/TechnoBoy_9_92_source_67d4d78.zip` | Full + PC app key-map overlay |
| Launch Boy 1.03 | *(not published)* | `caf2b49` | `Source Code/LaunchBoy_1_03_source_caf2b49.zip` | Launch Boy only |

## Studio Boy partial source

Studio Boy 4.92's archive contains only the **instruments and effects**:

- the 303 voice and its circuit model
- ACID SYNTH
- the 909-style drum machine and its kits
- Drive, Phaser, Delay, Flanger, Reverb, DubEcho, DjFilter, compressor and ducker,
  Scatter, beat repeat, tape stop, Granulator, Vocoder, Talkbox, AutoTune, NoiseGate

The archive's own `README.md` lists every file. The rest of the studio (sequencers, sampler GUI,
etc.) is not distributed.

## Launch Boy

`LaunchBoy_1_03_source_caf2b49.zip` has Launch Boy's own source: the boot menu, its packaging
tools, and the PC-side virtual Drumboy Pro. Building a firmware for Launch Boy needs the board
code from Techno Boy's source.

## Archive format

The archives are `git archive` output: they carry a top-level commit directory and no `.git`
directory, so they cannot be used to `git pull` upstream. Extract one into a scratch tree and
you have the upstream source at that exact commit.

## Why these files are not in this repo

- `BerlinBoy_0_12_source` (~147 MB) and `AphexBoy_0_02_source` (~136 MB) are over GitHub's
  100 MB per-file push limit.
- The WAV drum kits and sample banks run to ~288 MB.

Both are matched by `.gitignore`; restore them from the original distribution into this tree
when needed.
