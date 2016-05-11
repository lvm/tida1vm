FROM debian:jessie
MAINTAINER Mauro <mauro@sdf.org>

###
#
# Define ENV_VARS
#
###
ENV LANG C.UTF-8
ENV USER root

ENV HOME /home/tidal
ENV PATH $PATH:$HOME/bin

ENV DEBIAN_FRONTEND noninteractive

###
#
# Install dependencies &&
# Create home and user dirs
#
###
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -yq ghc \
    emacs24-nox haskell-mode tmux \
    zlib1g-dev liblo7 libportmidi0 \
    libportmidi-dev libasound2-dev \
    cabal-install wget unzip \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p $HOME \
    && mkdir -p $HOME/.elisp \
    && mkdir -p $HOME/livecode \
    && mkdir -p $HOME/bin \
    && wget --no-check-certificate https://github.com/lvm/tidal-midi/archive/0.6-dev.zip -O $HOME/0.6-dev.zip

###
#
# COPY default configs
#
###
COPY ["config/.bashrc", "$HOME/.bashrc"]
COPY ["config/.bash_profile", "$HOME/.bash_profile"]
COPY ["config/.motd", "$HOME/.motd"]
COPY ["config/.tmux.conf", "$HOME/.tmux.conf"]
COPY ["config/.emacs", "$HOME/.emacs"]
COPY ["config/tidal.el", "$HOME/.elisp/tidal.el"]
COPY ["tidal/init.tidal", "$HOME/livecode/init.tidal"]
COPY ["tidal/lazy-helpers.tidal", "$HOME/livecode/lazy-helpers.tidal"]

###
#
# Install Tidal && Fix perms
#
###
RUN cabal update \
    && cabal install tidal-0.6 \
    && cabal install tidal-midi \
    && unzip $HOME/0.6-dev.zip -d $HOME \
    && cd $HOME/tidal-midi-0.6-dev \
    && cabal configure \
    && cabal build \
    && cabal install \
    && cd $HOME \
    && rm -fr $HOME/tidal-midi-0.6-dev \
    && chown -Rh $USER:$USER -- $HOME


###
#
# Init
#
###
USER $USER
WORKDIR $HOME

