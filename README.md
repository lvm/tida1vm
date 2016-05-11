# tida1vm

Based on the work of [DoubleDensity's Tidebox](https://github.com/DoubleDensity/tidebox)

> A complete Tidal musical live coding and audio streaming environment inside Docker

## Why not Tidebox?

For now, there's not much difference other than this container runs `Debian Jessie` and Tidebox runs `Fedora`. Also, `tidebox` is a ready-to-use-solution and `tida1vm` not. Eventually this will contain custom configurations that probably will be useful to me only, so that.

### Other differences

It uses `tmux` instead of `screen`, it doesn't uses `sshd` nor `supervisor`.  

## Getting started

```bash  
$ git clone https://github.com/lvm/tida1vm
$ cd tida1vm
$ git checkout dirt
$ docker build -t tida1vm .
$ docker run -ti --rm tida1vm
```

Since it uses much of the configuration of `tidebox` you can still use VLC, mplayer, etc to connect to the streaming provided by the container.  
ie:  
```bash    
mplayer http://172.17.0.2:8090/stream.mp3
```
* You may need to find the IP address of your container using the Docker `inspect` command if you don't use the `--net=host` option    


## References

- [Tidebox](https://github.com/DoubleDensity/tidebox)
- [Tidal](http://tidal.lurk.org)
- [Dirt synth](https://github.com/tidalcycles/Dirt)
- [JACK Audio Connection Kit](http://www.jackaudio.org/)
- [FFmpeg](https://www.ffmpeg.org/)
- [GNU Emacs](https://www.gnu.org/software/emacs/)
- [tmux](https://tmux.github.io/)
- [TOPLAP The Home of Live Coding](http://toplap.org/)
