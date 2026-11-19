# Aphex Boy MIDI Numbers 0.02

The MIDI MAP's functions and their numbers: the one list (TASK-4, 18 Nov 2026). The code is the table `kFns` in
`core/ui/PagesMidiMap.inc`; `host/test_midi.cpp` holds the rules below. A fresh list for Aphex Boy, by Berlin Boy's
policy (its `docs/MIDI_Numbers_0.11.md`): Berlin Boy's own numbers are not carried over (its maps were Berlin Boy's,
and its BERLIN-only jobs are not here).

## The house rule

- One file format, never versioned: a map file (`MAP_n.gbm`, Studio Boy's GBXM byte for byte) and `MIDI.abm` keep a
  pairing as a message and a function's **number**. A number never changes its job, so a saved map keeps working.
- Studio Boy's numbers are used only for the jobs Aphex Boy shares with Studio Boy (the "shared" column). Every
  number not in the table is free.
- A pairing on a number with no function (a Studio Boy map's other jobs, a free number) is left out when the map is
  read and does nothing. There is no list of retired numbers and no special code for any number.
- Numbers run from 1 to 255 (a byte; 0 is "none").

## The functions (95)

In the MIDI MAP list's order: the pages' order (APHEX, MIXER, KIT; on each its keys, its knobs, then SHIFT's), then
the pads, the pages and the transport. The name is the list's (the screen's word); the full name is the one a message
gives.

| Number | Name | Full name | Job | Heading | Shared with Studio Boy |
|---:|---|---|---|---|---|
| 172 | REGEN | REGENERATE | key 25: a new piece | APHEX | no |
| 173 | HOLD | APHEX HOLD | key 26: HOLD on / off | APHEX | no |
| 174 | MIX-UP | MIX-UP ON / OFF | key 27: the MIX-UP on / off | APHEX | no |
| 48 | KIT + | PICK THE NEXT KIT | key 8 (+) on APHEX: the next kit | APHEX | yes (KIT +) |
| 49 | KIT - | PICK THE KIT BEFORE | key 20 (-) on APHEX: the kit before | APHEX | yes (KIT -) |
| 47 | CHANGE | CHANGE TO THE KIT | key 14 (\|\|\|) on APHEX: change to the kit picked | APHEX | yes (PLAY / CHANGE) |
| 175 | BUILD / DROP | BUILD / DROP | key 7: a BUILD held, its DROP let go | APHEX | no |
| 176 | ECHO THROW | ECHO THROW | key 9: the ECHO THROW, held | APHEX | no |
| 177 | CHAOS | APHEX CHAOS | APHEX knob 1 | APHEX | no |
| 178 | DENSITY | APHEX DENSITY | APHEX knob 2 | APHEX | no |
| 179 | DRILL | APHEX DRILL | APHEX knob 3 | APHEX | no |
| 1 | FILTER | APHEX FILTER | APHEX knob 4: the master FILTER | APHEX | yes (FILTER) |
| 180 | EVOLVE | APHEX EVOLVE | APHEX knob 5 | APHEX | no |
| 181 | MOOD | APHEX MOOD | APHEX knob 6 | APHEX | no |
| 182 | SPACE | APHEX SPACE | APHEX knob 7 (and the KIT's knob 7) | APHEX | no |
| 183 | GLITCH | APHEX GLITCH | APHEX knob 8 | APHEX | no |
| 184 | WARP | APHEX WARP | APHEX SHIFT (42) + knob 1 | APHEX | no |
| 185 | REGISTER | APHEX REGISTER | APHEX SHIFT (42) + knob 2 | APHEX | no |
| 186 | GRAIN | APHEX GRAIN | APHEX SHIFT (42) + knob 3 | APHEX | no |
| 187 | PAN | APHEX PAN | APHEX SHIFT (42) + knob 4 | APHEX | no |
| 188 | RUMBLE TONE | RUMBLE TONE | APHEX SHIFT (42) + knob 5 | APHEX | no |
| 189 | RUMBLE DUCK | RUMBLE DUCK | APHEX SHIFT (42) + knob 6 | APHEX | no |
| 190 | REVERB | APHEX REVERB | APHEX SHIFT (42) + knob 7: SPACE's REVERB type | APHEX | no |
| 2 | ECHO | APHEX ECHO | APHEX SHIFT (42) + knob 8: the master ECHO | APHEX | yes (ECHO) |
| 191 | DRUMS | DRUMS GROUP | MIXER knob 1 | MIXER | no |
| 192 | BASS | BASS GROUP | MIXER knob 2 | MIXER | no |
| 193 | LEAD | LEAD GROUP | MIXER knob 3 | MIXER | no |
| 194 | FX | FX GROUP | MIXER knob 4 | MIXER | no |
| 195 | STRIP LEVEL | THE STRIP'S LEVEL | MIXER knob 5 | MIXER | no |
| 196 | STRIP PAN | THE STRIP'S PAN | MIXER knob 6 | MIXER | no |
| 12 | TEMPO | TEMPO | MIXER knob 7 | MIXER | yes (TEMPO) |
| 148 | MASTER | MASTER | MIXER knob 8 | MIXER | yes (MASTER) |
| 149 | COMP | COMP | MIXER SHIFT + knob 1 | MIXER | yes (COMP) |
| 197 | LIMITER | LIMITER | MIXER SHIFT + knob 2 | MIXER | no |
| 198 | LINE OUT | LINE OUT | MIXER SHIFT + knob 3 | MIXER | no |
| 199 | CLEAN | CLEAN | MIXER SHIFT + knob 4 | MIXER | no |
| 200 | RUMBLE HALL | RUMBLE HALL | MIXER SHIFT + knob 5 | MIXER | no |
| 201 | FX RETURN | FX RETURN | MIXER SHIFT + knob 6 | MIXER | no |
| 202 | KICK LEVEL | KICK LEVEL | strip 1's level | MIXER | no |
| 203 | SNARE LEVEL | SNARE LEVEL | strip 2's level | MIXER | no |
| 204 | HAT LEVEL | HAT LEVEL | strip 3's level | MIXER | no |
| 205 | OPEN HAT LEVEL | OPEN HAT LEVEL | strip 4's level | MIXER | no |
| 206 | PERC LEVEL | PERC LEVEL | strip 5's level | MIXER | no |
| 207 | BASS LEVEL | BASS LEVEL | strip 6's level | MIXER | no |
| 208 | LEAD LEVEL | LEAD LEVEL | strip 7's level | MIXER | no |
| 209 | DRONE LEVEL | DRONE LEVEL | strip 8's level | MIXER | no |
| 210 | VOCAL 1 LEVEL | VOCAL 1 LEVEL | strip 9's level | MIXER | no |
| 211 | VOCAL 2 LEVEL | VOCAL 2 LEVEL | strip 10's level | MIXER | no |
| 212 | PADS LEVEL | PADS LEVEL | strip 11's level (the pads) | MIXER | no |
| 213 | KICK MUTE | KICK MUTE | strip 1 muted / on (its mute key) | MIXER | no |
| 214 | SNARE MUTE | SNARE MUTE | strip 2 muted / on (its mute key) | MIXER | no |
| 215 | HAT MUTE | HAT MUTE | strip 3 muted / on (its mute key) | MIXER | no |
| 216 | OPEN HAT MUTE | OPEN HAT MUTE | strip 4 muted / on (its mute key) | MIXER | no |
| 217 | PERC MUTE | PERC MUTE | strip 5 muted / on (its mute key) | MIXER | no |
| 218 | BASS MUTE | BASS MUTE | strip 6 muted / on (its mute key) | MIXER | no |
| 219 | LEAD MUTE | LEAD MUTE | strip 7 muted / on (its mute key) | MIXER | no |
| 220 | DRONE MUTE | DRONE MUTE | strip 8 muted / on (its mute key) | MIXER | no |
| 221 | VOCAL 1 MUTE | VOCAL 1 MUTE | strip 9 muted / on (its mute key) | MIXER | no |
| 222 | VOCAL 2 MUTE | VOCAL 2 MUTE | strip 10 muted / on (its mute key) | MIXER | no |
| 223 | PADS MUTE | PADS MUTE | strip 11 muted / on (its mute key) | MIXER | no |
| 224 | TUNE | KIT TUNE | KIT knob 1 | KIT | no |
| 225 | DECAY | KIT DECAY | KIT knob 2 | KIT | no |
| 226 | LEVEL | KIT LEVEL | KIT knob 3 | KIT | no |
| 227 | PAN | KIT PAN | KIT knob 4 | KIT | no |
| 228 | BLEND | KIT BLEND | KIT knob 5 | KIT | no |
| 229 | MIX | MIX-UP MIX | KIT knob 6 | KIT | no |
| 141 | KIT | DRUM KIT | KIT knob 8: the kit | KIT | yes (DRUM KIT) |
| 230 | KICK TUNE | KICK TUNE | KIT SHIFT + knob 1 | KIT | no |
| 231 | KICK DECAY | KICK DECAY | KIT SHIFT + knob 2 | KIT | no |
| 232 | KICK PUNCH | KICK PUNCH | KIT SHIFT + knob 3 | KIT | no |
| 233 | RUMBLE | RUMBLE | KIT SHIFT + knob 4: APHEX's kick into its dark hall, how much | KIT | no |
| 234 | VOICE UP | KIT VOICE UP | key 8 (+) on the KIT | KIT | no |
| 235 | VOICE DOWN | KIT VOICE DOWN | key 20 (-) on the KIT | KIT | no |
| 236 | SAMPLE BACK | KIT SAMPLE BACK | key 13 (left) on the KIT | KIT | no |
| 237 | SAMPLE NEXT | KIT SAMPLE NEXT | key 15 (right) on the KIT | KIT | no |
| 238 | HEAR | KIT HEAR | key 14 (\|\|\|) on the KIT: the row heard | KIT | no |
| 239 | SHIFT | SHIFT (HELD: + PAD SCENES) | key 42 SHIFT, held | PADS | no |
| 162 | PAD 1 | PAD 1 | pad 1 pressed | PADS | yes (SAMPLE PAD 1) |
| 163 | PAD 2 | PAD 2 | pad 2 pressed | PADS | yes (SAMPLE PAD 2) |
| 164 | PAD 3 | PAD 3 | pad 3 pressed | PADS | yes (SAMPLE PAD 3) |
| 165 | PAD 4 | PAD 4 | pad 4 pressed | PADS | yes (SAMPLE PAD 4) |
| 166 | PAD 5 | PAD 5 | pad 5 pressed | PADS | yes (SAMPLE PAD 5) |
| 167 | PAD 6 MUTE | PAD 6 MUTE / ON | pad 6 pressed: its part muted / on | PADS | yes (SAMPLE PAD 6) |
| 168 | PAD 7 MUTE | PAD 7 MUTE / ON | pad 7 pressed: its part muted / on | PADS | yes (SAMPLE PAD 7) |
| 169 | PAD 8 MUTE | PAD 8 MUTE / ON | pad 8 pressed: its part muted / on | PADS | yes (SAMPLE PAD 8) |
| 170 | PAD 9 MUTE | PAD 9 MUTE / ON | pad 9 pressed: its part muted / on | PADS | yes (SAMPLE PAD 9) |
| 171 | PAD 10 MUTE | PAD 10 MUTE / ON | pad 10 pressed: its part muted / on | PADS | yes (SAMPLE PAD 10) |
| 240 | NEXT PAGE | NEXT PAGE | key 31: the next page | PAGES | no |
| 241 | APHEX | APHEX PAGE | the APHEX page opened | PAGES | no |
| 242 | MIXER | MIXER PAGE | the MIXER page opened | PAGES | no |
| 243 | KIT | KIT PAGE | the KIT page opened | PAGES | no |
| 244 | MIDI MAP | MIDI MAP PAGE | the MIDI MAP page opened | PAGES | no |
| 66 | START | START | key 2: START | TRANSPORT | yes (PLAY) |
| 67 | STOP | STOP | key 1: STOP | TRANSPORT | yes (STOP) |
| 245 | REC | REC | key 3: REC, the set recorded to the card | TRANSPORT | no |

95 functions; 21 on Studio Boy's numbers for the same jobs (1, 2, 12, 47, 48, 49, 66, 67, 141, 148, 149, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171), 74 on Aphex Boy's own (172 up, the lowest free
above Studio Boy's 1-171, in the list's order).

## Free numbers (160)

3-11, 13-46, 50-65, 68-140, 142-147, 150-161, 246-255.

Studio Boy uses 1-171 for its own jobs: a number there is taken only for Studio Boy's same job, so a Studio Boy map's
other pairings are left out here rather than landing on another job (Berlin Boy's own numbers were 172 and up the
same way). The free numbers under 172 stay free for Studio Boy's jobs Aphex Boy may share later.

## A new job

1. If it is Studio Boy's same job, it takes Studio Boy's number (if that number is free here).
2. Otherwise it takes the **lowest free number from 172 up**.
3. Add it to `kFns` under its page's heading, in the page's order, and its row here; a number is never given to
   another job once a map can hold it.
