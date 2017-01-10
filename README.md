# tida1vm

> A complete Tidal musical live coding and audio streaming environment inside Docker

## Getting started

### Branches for each TidalCycles version

Currently, there's a branch for:  

#### TidalCycles 0.6 + MIDI  

* :seedling: [branch](https://github.com/lvm/tida1vm/tree/0.6)
* :link: [download](https://github.com/lvm/tida1vm/archive/0.6.zip)
* :whale: `docker pull lvm23/tida1vm:0.6` 

#### TidalCycles 0.7 + MIDI

* :seedling: [branch](https://github.com/lvm/tida1vm/tree/0.7)
* :link: [download](https://github.com/lvm/tida1vm/archive/0.7.zip)  
* :whale: `docker pull lvm23/tida1vm:0.7` 

#### TidalCycles 0.7 + Dirt

* :seedling: [branch](https://github.com/lvm/tida1vm/tree/dirt)
* :link: [Download](https://github.com/lvm/tida1vm/archive/dirt.zip)
* :whale: `docker pull lvm23/tida1vm:0.6` 

#### TidalCycles 0.8 + MIDI

* :seedling: [branch](https://github.com/lvm/tida1vm/tree/0.8)
* :link: [Download](https://github.com/lvm/tida1vm/archive/0.8.zip)
* :whale: `docker pull lvm23/tida1vm:0.8` 

#### TidalCycles 0.8 + MIDI (Volca Beats + Volca Bass only)

* :seedling: [branch](https://github.com/lvm/tida1vm/tree/volca)
* :link: [Download](https://github.com/lvm/tida1vm/archive/volca.zip)
* :whale: `docker pull lvm23/tida1vm:volca` 

#### TidalCycles 0.8 + MIDI + EspGrid

* :seedling: [branch](https://github.com/lvm/tida1vm/tree/esp)
* :link: [Download](https://github.com/lvm/tida1vm/archive/esp.zip)
* :whale: `docker pull lvm23/tida1vm:espgrid` 

#### TidalCycles 0.8 + SuperDirt

* :seedling: [branch](https://github.com/lvm/tida1vm/tree/superdirt)
* :link: [Download](https://github.com/lvm/tida1vm/archive/superdirt.zip)
* :whale: `docker pull lvm23/tida1vm:superdirt` 

#### TidalCycles 0.9 + SuperDirt (:see_no_evil: DEVELOPMENT BRANCH :see_no_evil:)

* :seedling: [branch](https://github.com/lvm/tida1vm/tree/0.9)
* :link: [Download](https://github.com/lvm/tida1vm/archive/0.9.zip)
* :whale: `docker pull lvm23/tida1vm:0.9` 

All of them are equally stable (ie: run at your own risk :neckbeard:)

So, let's say, you want to run the `0.8` version, simply:

```bash  
$ git clone https://github.com/lvm/tida1vm
$ cd tida1vm
$ git checkout 0.8
$ docker build -t tida1vm-0.8 .
$ docker run -ti --rm --privileged -v /dev/bus/usb:/dev/bus/usb --name tida1vm tida1vm-0.8
```
or just:
```bash
$ docker pull lvm23/tida1vm:0.8
$ docker run -ti --rm --privileged -v /dev/bus/usb:/dev/bus/usb --name tida1vm lvm23/tida1vm:0.8
```

## MIDI Ports

See the `README` for each branch.

### Custom `tidal-midi` Synths

For `0.6`, there's a forked version of `tidal-midi` [here](https://github.com/lvm/tidal-midi), removing most of the synths (which I don't have) and added `GM1Drums.hs` configured after GM1 standards for percussion in GM soundfonts. Uses `gdrum` (works with `drum` too, but won't recognize all GM1 values).  
For `0.7`, since it has MIDI integrated, I created a repo for FluidSynth [here](https://github.com/lvm/tidal-midi-fluidsynth) with two exposed modules: `GMDrums.hs` and `GMInst.hs`, one for Drums and other for the rest of the instruments.  
For `0.8`, it should be integrated within `tidal-midi`.



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

## What's the difference with [Tidebox](https://github.com/DoubleDensity/tidebox)?

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

## References

- [Tidebox](https://github.com/DoubleDensity/tidebox)
- [Tidal](http://tidal.lurk.org)
- [GNU Emacs](https://www.gnu.org/software/emacs/)
- [tmux](https://tmux.github.io/)
- [FluidSynth](http://www.fluidsynth.org/)
- [Qsynth](http://qsynth.sourceforge.net/qsynth-index.html)
- [amsynth](https://amsynth.github.io/)
- [GM Level 1 Sound Set](https://www.midi.org/specifications/item/gm-level-1-sound-set)
- [TOPLAP The Home of Live Coding](http://toplap.org/)
