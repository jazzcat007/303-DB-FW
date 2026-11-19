# Studio Boy 4.92 - Instruments and Effects

Studio Boy's sound engines for the Drumboy Pro, from notagroovebox/studio-boy at commit `5d016ad1` (18 Nov 2026):
the instruments and the effects, as source. Plain C++17, real-time safe (no
allocation or locks in the audio path); each file explains itself at its top.

Free for non-commercial use: the PolyForm Noncommercial License 1.0.0, Copyright (c) 2026 303 Resistance
(`LICENSE.md`). Commercial use needs written permission from 303 Resistance.

## What's included

### Instruments

| File | What it is |
|---|---|
| `core/synth/Tb303.h`, `.cpp` | The TB-303 voice: the Acid303Core circuit model at the host rate with the pedals (drive, phaser, delay) after it; knob-style parameters 0-1 like the TB-03 panel |
| `core/dsp/Acid303Core.h`, `.cpp` | The 303 circuit model: VCO, diode ladder VCF, envelopes, accent sweep, slide and VCA |
| `core/synth/AcidSynth.h`, `.cpp` | ACID SYNTH, a chord / swarm synth (inspired by Serum): twelve oscillators in six pairs play up to six chord notes, each pair spread by SWARM into a detuned stereo stack, with a sub and drive; twelve shapes plus PULSE with its PULSE WIDTH (PWM from any modulator) and NOISE (4.92) |
| `core/drums/DrumMachine.h`, `.cpp` | A TR-909 style sample drum machine: 10 voices, each one sample with tune, decay, level and pan, a global accent and the open / closed hi-hat choke; the samples come from the host |
| `core/drums/DrumKits.h` | The drum machine's kits: a folder of up to ten samples per kit, named `01-...` to `10-...` in voice order |

### Effects

| File | What it is |
|---|---|
| `core/dsp/Drive.h`, `.cpp` | Drive for the 303, 4x oversampled: OVERDRIVE (TB-03 style soft clipping) and RAT (a model of the ProCo RAT circuit) |
| `core/dsp/Phaser.h`, `.cpp` | Phaser pedal, MXR Phase 90 style: matched all-pass stages swept by one LFO; feedback from the "script" to the resonant "block logo" sound |
| `core/dsp/Delay.h`, `.cpp` | Tempo-synced delay, TB-03 style: repeats darkened on the way in, soft-limited feedback, time changes that glide like tape |
| `core/dsp/Flanger.h`, `.cpp` | The master flanger: a short swept delay against the dry mix, the "jet" sound; one knob fades it in, then adds feedback |
| `core/dsp/Reverb.h`, `.cpp` | The bus reverb: Schroeder-Moorer after Freeverb's layout, eight damped combs into four all-passes per side, stereo |
| `core/dsp/DubEcho.h`, `.cpp` | The master echo: a dub-style tape echo on the whole mix for throws; repeats ring on after the send drops, darker each time, a dotted quarter of the tempo |
| `core/dsp/DjFilter.h`, `.cpp` | The master filter: one knob, low-pass below the middle, off at the middle, high-pass above (the DJ mixer's filter) |
| `core/dsp/Dynamics.h`, `.cpp` | Mix-bus dynamics: the master compressor (one AMOUNT knob, stereo-linked, feed-forward) and a sidechain ducker |
| `core/dsp/Scatter.h`, `.cpp` | The scatter: the mix chopped in sixteenth steps in time with the beat (the MX-1 / TR-8 idea) |
| `core/dsp/Performer.h`, `.cpp` | Performance effects held on a key: beat repeat (a bar down to a 1/32 looped) and tape stop |
| `core/dsp/Granulator.h` | A real-time granulator: grains of the last seconds of the input, SIZE, DENSITY, PITCH, SPRAY, SHAPE |
| `core/dsp/Vocoder.h`, `.cpp` | A 16-band channel vocoder for the line input, with a built-in carrier (saw, square, three-saw chord, noise) |
| `core/dsp/Talkbox.h`, `.cpp` | A talkbox for the line input: the voice's mouth shape on a synth lead |
| `core/dsp/AutoTune.h`, `.cpp` | Pitch correction for the line input: a voice snapped to a scale's notes |
| `core/dsp/NoiseGate.h` | A soft noise gate for the line input |

### Building blocks

| File | What it is |
|---|---|
| `core/dsp/DspUtil.h` | Small shared helpers (denormal flushing and the like) |
| `core/dsp/LevelGlide.h` | A level that glides to a new value over 64 samples instead of stepping |
| `core/seq/Scale.h` | The musical scales ACID SYNTH uses for scale lock |
| `core/util/Hot.h` | `GB_HOT`: places audio-path functions in the STM32H7's fast ITCM on the box (nothing on a PC) |
| `core/util/Bytes.h` | Little-endian, bounds-checked byte reading / writing |
