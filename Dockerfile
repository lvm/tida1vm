FROM debian:jessie
MAINTAINER Mauro <mauro@sdf.org>

###
#
# Define ENV_VARS
#
###
ENV LANG C.UTF-8
ENV USER root
ENV AUDIOGRP audio

ENV HOME /home/tidal
ENV PATH $PATH:$HOME/bin:$HOME/apps/Dirt

ENV DEBIAN_FRONTEND noninteractive

###
#
# Setup backports repo
#
###
COPY ["config/sources.list.d/backports.list", "/etc/apt/sources.list.d/backports.list"]

###
#
# Install dependencies &&
# Create home and set user groups
#
###
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -yq jackd git ghc \
    emacs24-nox haskell-mode tmux \
    ffmpeg lame libmp3lame0 \
    zlib1g-dev liblo7 libportmidi0 \
    libportmidi-dev  libasound2-dev \
    cabal-install \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && adduser $USER $AUDIOGRP \
    && mkdir -p $HOME \
    && mkdir -p $HOME/.elisp \
    && mkdir -p $HOME/livecode \
    && mkdir -p $HOME/repos \
    && mkdir -p $HOME/apps/Dirt \
    && mkdir -p $HOME/bin

###
#
# COPY default configs
#
###
COPY ["config/.tmux.conf", "$HOME/.tmux.conf"]
COPY ["config/.emacs", "$HOME/.emacs"]
COPY ["config/ffserver.conf", "$HOME/ffserver.conf"]
COPY ["config/tidal.el", "$HOME/.elisp/tidal.el"]
COPY ["tidal/init.tidal", "$HOME/livecode/init.tidal"]

###
#
# Install executables
#
###
COPY ["bin/start-1vm", "$HOME/bin/start-1vm"]
COPY ["bin/start-dirt", "$HOME/bin/start-dirt"]
COPY ["bin/start-ffserver", "$HOME/bin/start-ffserver"]
COPY ["bin/start-jack", "$HOME/bin/start-jack"]
COPY ["bin/ffmpeg-jack", "$HOME/bin/ffmpeg-jack"]
COPY ["bin/dirt", "$HOME/apps/Dirt/dirt"]

###
#
# ADD Tidal and samples
# Note:
# This step is optional.
# `samples.tar.gz` contains custom samples, you might want to do
# the same for your samples.
# `dot-cabal.tar.gz` contains the result of `cabal fetch tidal-0.6`
# to avoid downloading multiple times because i have a very bad
# internet connection.
#
###
# ADD ["samples/samples.tar.gz", "$HOME/apps/Dirt"]
# ADD ["cabal/dot-cabal.tar.gz", "$HOME"]

###
#
# Instal Tidal &&
# Fix perms
#
###
RUN cabal update && cabal install tidal-0.6 \
    && chmod +x $HOME/bin/start-1vm \
    && chmod +x $HOME/bin/start-dirt \
    && chmod +x $HOME/bin/start-ffserver \
    && chmod +x $HOME/bin/start-jack \
    && chmod +x $HOME/bin/ffmpeg-jack \
    && chown -Rh $USER:$USER -- $HOME

###
#
# Expose ffserver ports
#
###
EXPOSE 8090

###
#
# Init
#
###
USER $USER
WORKDIR $HOME

