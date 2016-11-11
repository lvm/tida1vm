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

####
#
# Add backports.
# `ghc` is kinda old in Jessie, luckily someone backported it.
#
##
COPY ["config/etc/apt/sources.list.d/backports.list", "/etc/apt/sources.list.d/backports.list"]

###
#
# Install dependencies &&
# Create home and user dirs
#
###
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -yq \
    emacs24-nox haskell-mode tmux \
    zlib1g-dev liblo7 libasound2-dev \
    cabal-install wget unzip \
    ca-certificates \
    --no-install-recommends \
    && apt-get install -yt jessie-backports ghc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p $HOME \
    && mkdir -p $HOME/.elisp \
    && mkdir -p $HOME/livecode \
    && mkdir -p $HOME/.emacs.d/themes \
    && wget https://github.com/lvm/tidal-drum-patterns/archive/master.zip -O $HOME/tidal-drum-patterns.zip \
    && wget https://github.com/lvm/tidal-scales/archive/master.zip -O $HOME/tidal-scales.zip \
    && wget https://raw.githubusercontent.com/lvm/cyberpunk-theme.el/master/cyberpunk-transparent-theme.el -O $HOME/.emacs.d/themes/cyberpunk-transparent-theme.el

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
COPY ["tidal/helpers.tidal", "$HOME/livecode/helpers.tidal"]

###
#
# Install Tidal && Fix perms
#
###


RUN cabal update \
    && cabal install tidal \
    && cabal configure && cabal build && cabal install \
    && unzip $HOME/tidal-scales.zip -d $HOME \
    && cd $HOME/tidal-scales-master \
    && cabal configure && cabal build && cabal install \
    && unzip $HOME/tidal-drum-patterns.zip -d $HOME \
    && cd $HOME/tidal-drum-patterns-master \
    && cabal configure && cabal build && cabal install \
    && cd $HOME \
    && rm -fr $HOME/tidal-drum-patterns-master $HOME/tidal-drum-patterns.zip \
    && rm -fr $HOME/tidal-scales-master $HOME/tidal-scales.zip \
    && chown -Rh $USER:$USER -- $HOME


###
#
# Init
#
###
USER $USER
WORKDIR $HOME
