###
#
# Base TidalCycles setup
#
###


FROM alpine:edge
MAINTAINER Mauro <mauro@sdf.org>

ENV LANG C.UTF-8
ENV USER root
ENV HOME /root

RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> \
           /etc/apk/repositories \
    && apk update \
    && add wget \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
    && wget -q -O $HOME/glibc-2.25-r0.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk \
    && apk add $HOME//rootglibc-2.25-r0.apk\
    && apk add \
       build-base ca-certificates linux-headers openssl \
       cabal@testing ghc@testing upx@testing \
       libffi-dev zlib-dev gmp-dev \
    && cabal update \
    && cabal install 'tidal == 0.9'
