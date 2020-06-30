FROM debian:stable
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
    ca-certificates ghc git \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p $HOME \
    && mkdir -p $HOME/livecode \
    && mkdir -p $HOME/.emacs.d/themes \
    && mkdir -p $HOME/.emacs.d/lisp \
    && wget https://raw.githubusercontent.com/lvm/monochrome-theme.el/master/monochrome-transparent-theme.el -O $HOME/.emacs.d/themes/monochrome-transparent-theme.el

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
    && cabal install tidal-1.6.1 \
    && cd $HOME \
    && chown -Rh $USER:$USER -- $HOME


###
#
# Init
#
###
USER $USER
WORKDIR $HOME
