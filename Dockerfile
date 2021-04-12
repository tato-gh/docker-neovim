FROM alpine:edge
MAINTAINER Ta-To

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    curl \
    gcc \
    g++ \
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
    file \
    ripgrep \
    sudo \
    bash
RUN rm -rf /var/cache/apk/*

RUN npm install -g yarn

ENV LANG="ja_JP.UTF-8" LANGUAGE="ja_JP:ja" LC_ALL="ja_JP.UTF-8"
RUN pip3 install --upgrade pip wheel pynvim && \
    rm -rf /root/.cache

COPY run.sh /root/run.sh
WORKDIR /srv

# MEMO
# gccとg++はバージョンを合わせる必要がある。状況によってはエラーになる？

# MEMO
#
# sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
# CocInstall coc-fzf-preview in neovim
