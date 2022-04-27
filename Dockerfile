FROM debian:bookworm-slim
MAINTAINER Ta-To

# ENV LANG="ja_JP.UTF-8" LANGUAGE="ja_JP:ja" LC_ALL="ja_JP.UTF-8"
COPY run.sh /root/run.sh

# REFS
# https://hub.docker.com/r/thawk/neovim/dockerfile

# python3-dev, py3-pip for deoplete
RUN apt update && \
    apt install -y \
    git \
    curl \
    automake \
    cmake \
    make \
    libtool \
    musl-dev\
    zlib1g-dev \
    unzip \
    openssl \
    autoconf \
    gettext-base \
    gcc \
    g++ \
    byobu \
    sudo \
    bash \
    ripgrep \
    python3-dev \
    python3-pip \
    elixir \
    erlang-edoc \
    ruby
RUN rm -rf /var/cache/apt/*


# Neovim
# # nvim.appimage がうまく動作しないためビルドする
# # neovim v5が正式リリース後はheadである必要はなくなる(はず
# RUN git clone https://github.com/neovim/neovim.git \
#   && cd neovim \
#   && make CMAKE_BUILD_TYPE=Release \
#   && make install \
#   && cd ../ \
#   && rm -rf neovim

WORKDIR /usr/local/src
COPY files/nvim.appimage /usr/local/src/
RUN chmod a+x nvim.appimage && \
    ./nvim.appimage --appimage-extract && \
    ln -s /usr/local/src/squashfs-root/usr/bin/nvim /usr/bin/nvim

# Deno for denops
WORKDIR /tmp
ENV DENO_VERSION=1.19.2
RUN curl -fsSL https://github.com/denoland/deno/releases/download/v${DENO_VERSION}/deno-x86_64-unknown-linux-gnu.zip --output deno.zip && \
    unzip deno.zip && \
    chmod 777 deno && \
    mv deno /bin/deno

# # Go lang for efm-langserver
# WORKDIR /tmp
# ENV GO_VERSION=1.17.3
# RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
#     tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
#     ln -s /usr/local/go/bin/go /usr/bin/go
# 
# # mix credo for elixir package
# # - ちょっと遅いので現状悩ましい
# RUN mix escript.install --force hex credo && \
#     cp /root/.mix/escripts/credo /usr/local/bin/

WORKDIR /srv
