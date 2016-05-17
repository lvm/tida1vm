# wat?

This documentation should help you (the livecoder) to install and to start coding music live with TidalCycles using this Docker container.  
  
If you already know {what is,how to use} Docker, you might want to skip these first questions (fixes, comments are welcome btw!).  

## What is Docker?

Docker is a *platform to distribute applications for devs or sysadmins*.  
In other words, you built a web-app and instead of installing this directly to the `host`, you create a `container` which contains everything you can find on a basic installation of your favorite GNU/Linux distro (be it Debian, Ubuntu, Arch, or even BusyBox), this way on one hand you have a clean install on your computer/server and on the other hand you have a piece of software that (ideally) will have the correct dependencies and should *just work* (TM). Think of it as a `chroot` on steroids.  
For example, `Python` has a similar approach using `virtualenv` which allows the developer to install the correct `Python` libraries without messing with *system-wide* libraries.  
  

## Sounds good, but how do I install Docker?

First of all, install `docker`.  
On OS X [here](https://docs.docker.com/engine/installation/mac/) is a nice guide on how to proceed. Same thing for Windows [here](https://docs.docker.com/engine/installation/windows/).  
On Debian based distros:  

```bash
$ sudo apt-get install docker.io
```

Once installed, we need to add your user to the `docker` group, this way we avoid using `sudo` each time we launch `docker`.  

```bash
$ sudo adduser `whoami` docker
```

And pretty much that's it for this part.


## Great, I'm ready

Awesome. Now the next part is to `pull` or `build` a container.  

### Building

To `build`ing a Docker container, what we're doing is creating a clean installation from our favorite OS to start working/deploying our app with our particular requirments.  
In order to do that we need to create a file called `Dockerfile`.  
These files look something like this:  

```
# This is an exmaple on how to install netcat
# taken from Jessie Frazelle repo
# https://github.com/jfrazelle/dockerfiles/

FROM debian:sid
MAINTAINER Jessica Frazelle <jess@docker.com>

RUN apt-get update && apt-get install -y \
	netcat \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "netcat" ]
```

In this *recipe*, we're telling Docker that we'll start `FROM` a clean Debian "sid" image, that the `MAINTAINER` is Jessica Frazelle, and once we downloaded the Debian image, to `RUN` the `apt-get` commands to install `netcat` and to clean the apt cache. Finally, the `ENTRYPOINT` for this container will be `netcat`. This way, we can use it as a stand-alone application, just like if we had `netcat` installed on our computer.  
Perhaps the first time is sort of mind-boggling but it's not that weird after a few tries.  
  
Anyway, once we have our `Dockerfile` we need to tell `docker` to build a local image for us to use.  
Let's say we have our `Dockerfile` recipe in a directory called `docker-nc-test`  

```bash
$ cd docker-netcat-test
$ docker build -t netcat-test .
```

In this command we're telling `docker` to `build` an image called `netcat-test` with the `Dockerfile` resting in this directory (hence `.`).  
After downloading the `debian:sid` image (if we haven't downloaded it before) and the dependencies for `netcat` we should have an image called `netcat-test`.  
To list our local images:  

```bash
$ docker images
```

### Pulling

`pull`ing is way easier. We need only three things: free space, an internet connection, `docker` installed.  
Let's say we want to obtain a clean Debian "jessie" installation:  

```bash
$ docker pull debian:jessie
```

What about an Ubuntu one? 

```bash
$ docker pull ubuntu:14.04
```

Want a minimal distro? Try Alpine

```bash
$ docker pull alpine:edge
```

A webserver? is nginx ok?

```bash
$ docker pull nginx
```

[Dockerhub](https://hub.docker.com/explore/) provides *a lot* of official images ready to pull. But let's start with our topic of interest which is...


## Excellent, I have all setup. Let's start livecoding!

Well, almost there but not yet... We need to choose an image first!
  
For this, I've prepared three `branches` with different setups:  

* tidalcycles 0.6 + tidal-midi
* tidalcycles 0.7 + tidal-midi
* tidalcycles 0.6 + Dirt

### tidalcycles 0.6 + tidal-midi

This image contains TidalCycles 0.6 + tidal-midi 0.6 + a custom module called `GM1Drums.hs` which supports the same as `VolcaBeats.hs` but regarding General MIDI Level 1 (and 2) keys.  
Also, it's possible to use `Dirt` but this should point to another computer (even the `host` machine) with `Dirt` installed. See [here](http://tidalcycles.org/howtos.html#multi_laptop) for more info about this.  
Download:

```bash
$ docker pull lvm23/tida1vm:0.6
```

### tidalcycles 0.7 + tidal-midi

This image is the same as `tidalcycles 0.6 + tidal-midi` except it uses TidalCycles 0.7 :-)  
Download:

```bash
$ docker pull lvm23/tida1vm:0.7
```

### tidalcycles 0.6 + Dirt
  
This image is an alternative version to [TideBox](https://github.com/DoubleDensity/tidebox), I won't maintain this branch really, so use it *at your own risk* :-)  
Download:

```bash
$ docker pull lvm23/tida1vm:dirt
```

## Great, everything is installed and configured!

Perfect!  
Now we need to `run` this image we downloaded and create a `container`. Think of `container`s as *sessions*.  
Anyway, at this point, it's pretty easy. To run *any* container, for example:  

```bash
$ docker -it --rm run lvm23/tida1vm:0.6
```

And that's it. We should see an ASCII art welcoming us and a `bash` prompt, by typing `emacs` inside this `container`, we'll launch `emacs` *inside* the container (which is **not** the same as in our `host`) and an already configured environment is waiting for us to play.  
  
But wait! there's more to it!  
We need to tell this new `container` to communicate via USB to our MIDI Device;  in order to do that we need to pass a couple of extra parameters to `docker run`:  
*Note: This is the full command*
```bash
$ docker run -it --rm \
	--privileged \
	--net=host \
    -p 7771:7771 \
	-v $HOME/tidal:/home/tidal/trax \
	-v /dev/bus/usb:/dev/bus/usb \
	--name 1vm6 lvm23/tida1vm:0.6
```

Explanation:  
`-it`, interactive tty  
`--rm`, remove after exit  
`--privileged`, gives *privileges* to access `host` devices, which usually `docker container`s don't have it  
`--net=host`, uses the `host`'s network stack  
`-p 7771:7771`, publishes `container`s ports to the `host`. In this case `Dirt`'s port  
`-v $HOME/tidal:/home/tidal/trax`, *mounts* a `host` directory to a `docker` `volume`, this way we don't loose our code after exiting the `docker container`  
`-v /dev/bus/usb:/dev/bus/usb`, *mounts* the `host` usb devices to `docker` `container`  
`--name 1vm6`, the `container`'s name
`lvm23/tida1vm:0.6`, the actual `docker image`  


To read more about [`docker volume`](https://docs.docker.com/engine/userguide/containers/dockervolumes/), it's an interesting topic which can save us a headache.


## The end?

Now we *could* start livecoding, except for one little tiny issue: We need MIDI Devices.  
Well, for this part we will need at least `fluidsynth` or a physical synth which supports MIDI In; the package `tidal-midi` already supports a wide variety of devices and if yours isn't supported, writing a module from scratch isn't that hard.  
  
Well, that's it regarding `docker`, `TidalCycles` and `tida1vm`. For more info, look for the complementing docs.  
  
Happy livecoding!
