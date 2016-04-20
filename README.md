# tida1vm

Based on the work of [DoubleDensity's Tidebox](https://github.com/DoubleDensity/tidebox)

> A complete Tidal musical live coding and audio streaming environment inside Docker

## Why not Tidebox?

This container has configurations which are probably useful to me only, such as:

* `tidebox` uses tidal+dirt and `tida1vm` uses tidal+tidal-midi.
* Runs `Debian Jessie` instead of `Fedora`
* A particular midi-port <-> tidal-stream config
* Uses `tmux` instead of `screen`
* Doesn't use `Dirt`
* Doesn't use `jack` directly (though the `host` might)
* Doesn't use `ffserver` (so I dropped dependencies on `ffmpeg`, `lame` and its libs)
* Doesn't use `supervisor`
* Doesn't use `sshd`

## Getting started

```bash  
$ git clone https://github.com/lvm/tida1vm
$ cd tida1vm
$ docker build -t tida1vm .
$ docker run -ti --rm --privileged -v /dev/bus/usb:/dev/bus/usb --name tida1vm tida1vm
```

## MIDI Ports

These are the MIDI ports I use on my physical and virtual synths, modify it as needed.  
All of them are connected to ALSA "Midi Through".  

| Device      | Stream | MIDI Port | Tidal Midi     | Soundfont  | Notes              |
| ------------| ------ | --------- | -------------- | ---------- | ------------------ |
| Volca Beats | beats  | 1         | VolcaBeats.hs  |            |                    |
| Volca Bass  | bass   | 2         | VolcaBass.hs   |            |                    |
| Qsynth      | tr808  | 3         | Fake808.hs     | FluidR3_GM | Bank 128 / Prog 25 |
| Qsynth      | bass2  | 4         | SimpleSynth.hs | FluidR3_GM | Bank 0 / Prog 39   |
| Qsynth      | piano  | 5         | SimpleSynth.hs | FluidR3_GM | Bank 0 / Prog 0    |
| Qsynth      | string | 6         | SimpleSynth.hs | FluidR3_GM | Bank 0 / Prog 51   |
| amsynth     | am1    | 7         | SimpleSynth.hs |            |                    |
| amsynth     | am2    | 8         | SimpleSynth.hs |            |                    |
| amsynth     | am3    | 9         | SimpleSynth.hs |            |                    |

### Custom tidal-midi Synths

In the directory `tidal-midi` you can custom synths written for this setup.
To ease the setup, I forked the `tidal-midi` [here](https://github.com/lvm/tidal-midi).

#### Fake808.hs

This is based on `VolcaBeats.hs` but has more mappings to different "notes".  
It uses `drum8` instead of `drum` (which still can be used but won't play tr808 notes).

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

## References

- [Tidebox](https://github.com/DoubleDensity/tidebox)
- [Tidal](http://tidal.lurk.org)
- [GNU Emacs](https://www.gnu.org/software/emacs/)
- [tmux](https://tmux.github.io/)
- [FluidSynth](http://www.fluidsynth.org/)
- [Qsynth](http://qsynth.sourceforge.net/qsynth-index.html)
- [amsynth](https://amsynth.github.io/)
- [TOPLAP The Home of Live Coding](http://toplap.org/)
