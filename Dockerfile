FROM debian:stretch
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
    && apt-get install -yq \
    emacs24-nox haskell-mode \
    zlib1g-dev liblo7 libasound2-dev \
    cabal-install wget unzip \
    ca-certificates ghc \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p $HOME \
    && mkdir -p $HOME/livecode \
    && mkdir -p $HOME/.emacs.d/themes \
    && mkdir -p $HOME/.emacs.d/lisp \
    && wget https://github.com/tidalcycles/Tidal/archive/1.0-dev.zip -O $HOME/tidal-1.0.zip \
    && wget https://github.com/lvm/tidal-drum-patterns/archive/master.zip -O $HOME/tidal-drum-patterns.zip \
    && wget https://raw.githubusercontent.com/lvm/monochrome-theme.el/master/monochrome-transparent-theme.el -O $HOME/.emacs.d/themes/monochrome-transparent-theme.el \
    && wget https://www.emacswiki.org/emacs/download/centered-cursor-mode.el -O $HOME/.emacs.d/lisp/centered-cursor-mode.el

###
#
# COPY default configs
#
###
COPY ["config/.bashrc", "$HOME/.bashrc"]
COPY ["config/.motd", "$HOME/.motd"]
COPY ["config/.emacs", "$HOME/.emacs"]
COPY ["config/tidal.el", "$HOME/.emacs.d/lisp/tidal.el"]
COPY ["tidal/init.tidal", "$HOME/livecode/init.tidal"]
COPY ["tidal/helpers.tidal", "$HOME/livecode/helpers.tidal"]

###
#
# Install Tidal && Fix perms
#
###


RUN cabal update \
    && cabal install colour hashable hmt 'hosc >= 0.16' \
        mersenne-random-pure64 monad-loops \
        'mtl >=2.1' parsec text 'websockets > 0.8' \
        containers time safe \
    && unzip $HOME/tidal-1.0.zip -d $HOME \
    && cd $HOME/Tidal-1.0-dev \
    && cabal configure && cabal build && cabal install \
    && unzip $HOME/tidal-drum-patterns.zip -d $HOME \
    && cd $HOME/tidal-drum-patterns-master \
    && cabal configure && cabal build && cabal install \
    && cd $HOME \
    && rm -fr $HOME/tidal-drum-patterns-master $HOME/tidal-drum-patterns.zip \
    && rm -fr $HOME/Tidal-0.9-dev $HOME/tidal-1.0.zip \
    && chown -Rh $USER:$USER -- $HOME


###
#
# Init
#
###
USER $USER
WORKDIR $HOME
