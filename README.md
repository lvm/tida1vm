# tida1vm

Based on the work of [DoubleDensity's Tidebox](https://github.com/DoubleDensity/tidebox)

> A complete Tidal musical live coding and audio streaming environment inside Docker

## Why not Tidebox?

This container has configurations which are probably useful to me only, such as:

* `tidebox` is a ready-to-use-solution and `tida1vm` **not**
* Runs `Debian Jessie` instead of `Fedora`
* A particular midi-port <-> tidal-stream config
* Uses `tmux` instead of `screen`
* Doesn't use `Dirt`
* Doesn't use `jack` directly (though the `host` will)
* Doesn't use `ffserver` (so I dropped dependencies on `ffmpeg`, `lame` and its libs)
* Doesn't uses `supervisor`

## Getting started

```bash  
$ git clone https://github.com/lvm/tida1vm
$ cd tida1vm
$ docker build -t tida1vm .
$ docker run -ti --rm --privileged -v /dev/bus/usb:/dev/bus/usb tida1vm
```

## References

- [Tidebox](https://github.com/DoubleDensity/tidebox)
- [Tidal](http://tidal.lurk.org)
- [GNU Emacs](https://www.gnu.org/software/emacs/)
- [tmux](https://tmux.github.io/)
- [TOPLAP The Home of Live Coding](http://toplap.org/)
