FROM alpine:edge
MAINTAINER Ta-To

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    curl \
    gcc \
    git \
    linux-headers \
    musl-dev\
    vim \
    neovim \
    py-pip \
    python3-dev \
    py3-pip \
    nodejs \
    npm \
    byobu \
    sudo \
    bash
RUN rm -rf /var/cache/apk/*

RUN npm install -g yarn

ENV LANG="ja_JP.UTF-8" LANGUAGE="ja_JP:ja" LC_ALL="ja_JP.UTF-8"
RUN pip3 install --upgrade pip neovim pynvim && \
    rm -rf /root/.cache

COPY run.sh /root/run.sh
WORKDIR /srv
