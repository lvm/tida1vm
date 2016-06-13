# tida1vm

Based on the work of [DoubleDensity's Tidebox](https://github.com/DoubleDensity/tidebox)

> A complete Tidal musical live coding and audio streaming environment inside Docker

## Getting started

```bash  
$ git clone https://github.com/lvm/tida1vm
$ cd tida1vm
$ git checkout 0.8
$ docker build -t tida1vm-0.8 .
$ docker run -ti --rm --privileged -v /dev/bus/usb:/dev/bus/usb --name 1vm8 tida1vm-0.8
```

## MIDI Ports

All of them are connected to ALSA "Midi Through".  

| Device      | Stream | MIDI Port | Tidal Midi     | Soundfont   | Notes              |
| ------------| ------ | --------- | -------------- | ----------- | ------------------ |
| Volca Beats | beats  | 1         | VolcaBeats.hs  |             |                    |
| Volca Bass  | bass   | 2         | VolcaBass.hs   |             |                    |
| Qsynth      | drums  | 3         | GMPerc.hs      | GeneralUser | Bank 145 / Prog 25 |
| {Q,am}synth | midi4  | 4         | Synth.hs       |             |                    |
| {Q,am}synth | midi5  | 5         | Synth.hs       |             |                    |
| {Q,am}synth | midi6  | 6         | Synth.hs       |             |                    |
| {Q,am}synth | midi7  | 7         | Synth.hs       |             |                    |
| {Q,am}synth | midi8  | 8         | Synth.hs       |             |                    |
| {Q,am}synth | midi9  | 9         | Synth.hs       |             |                    |
| {Q,am}synth | midi10 | 10        | Synth.hs       |             |                    |
| {Q,am}synth | midi11 | 11        | Synth.hs       |             |                    |
| {Q,am}synth | midi12 | 12        | Synth.hs       |             |                    |
| {Q,am}synth | midi13 | 13        | Synth.hs       |             |                    |
| {Q,am}synth | midi14 | 14        | Synth.hs       |             |                    |
| {Q,am}synth | midi15 | 15        | Synth.hs       |             |                    |
| {Q,am}synth | midi16 | 16        | Synth.hs       |             |                    |


The [GeneralUser SoundFont](http://www.schristiancollins.com/generaluser.php) is a work by [S. Christian Collins](http://www.schristiancollins.com/).  
  
They used to be named based on a particular use, now it's more generic.  
In order to alias any stream, just write in your `.tidal` file, something like:

```
let something = midi4

-- now it can be used as:

something $ n "c d e f"
```

### Custom `tidal-midi` Synths

For `0.8`, I updated the `General MIDI Percussion keymap` module [here](https://github.com/lvm/tidal-midi-gm/) with the idea to integrate it to the rest of `tidal-midi`.

### midithru-connect

There's a small script in the `helper` directory called `midithru-connect` which connects clients to "Midi Through".

```bash
usage: midithru-connect [-h] [-v] [-a] [-c CONNECT] [-d DISCONNECT]

optional arguments:
  -h, --help            show this help message and exit
  -v, --version         shows the current version
  -a, --all             auto connects all clients available
  -c CONNECT, --connect CONNECT
                        connects a client to midi through
  -d DISCONNECT, --disconnect DISCONNECT
                        disconnects a client off midi through
```
## Extra docs

For more info, take a look at the [wiki](https://github.com/lvm/tida1vm/wiki).


## References

- [Tidebox](https://github.com/DoubleDensity/tidebox)
- [Tidal](http://tidal.lurk.org)
- [GNU Emacs](https://www.gnu.org/software/emacs/)
- [tmux](https://tmux.github.io/)
- [FluidSynth](http://www.fluidsynth.org/)
- [Qsynth](http://qsynth.sourceforge.net/qsynth-index.html)
- [amsynth](https://amsynth.github.io/)
- [GM Level 1 Sound Set](https://www.midi.org/specifications/item/gm-level-1-sound-set)
- [GeneralUser SoundFont](http://www.schristiancollins.com/generaluser.php)
- [TOPLAP The Home of Live Coding](http://toplap.org/)
