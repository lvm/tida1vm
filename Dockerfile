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
ENV PATH $PATH:$HOME/bin

ENV DEBIAN_FRONTEND noninteractive

###
#
# Install dependencies &&
# Create home and set user groups
# Note: Don't ever allow root over ssh.
# Except in this particular case :-)
#
###
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -yq ghc \
    emacs24-nox haskell-mode tmux \
    zlib1g-dev liblo7 libportmidi0 \
    libportmidi-dev libasound2-dev \
    cabal-install openssh-server \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && adduser $USER $AUDIOGRP \
    && mkdir -p $HOME \
    && mkdir -p $HOME/.elisp \
    && mkdir -p $HOME/livecode \
    && mkdir -p $HOME/bin \
    && echo 'root:toor' | chpasswd \
    && sed -i 's,PermitRootLogin\s.*,PermitRootLogin yes,' /etc/ssh/sshd_config

###
#
# COPY default configs
#
###
COPY ["config/.tmux.conf", "$HOME/.tmux.conf"]
COPY ["config/.emacs", "$HOME/.emacs"]
COPY ["config/tidal.el", "$HOME/.elisp/tidal.el"]
COPY ["tidal/init.tidal", "$HOME/livecode/init.tidal"]
COPY ["tidal/lazy-helpers.tidal", "$HOME/livecode/lazy-helpers.tidal"]

###
#
# ADD Tidal
# Note: This step is optional.
# `dot-cabal.tar.gz` contains the result of
# `cabal fetch tidal-0.6 && cabal fetch tidal-midi-0.6`
#
###
# ADD ["cabal/dot-cabal.tar.gz", "$HOME"]

###
#
# Install Tidal && Fix perms
#
###
RUN cabal update \
    && cabal install tidal-0.6 \
    && cabal install tidal-midi-0.6 \
    && chown -Rh $USER:$USER -- $HOME

###
#
# Expose sshd port
#
###
EXPOSE 22

###
#
# Init
#
###
USER $USER
WORKDIR $HOME

