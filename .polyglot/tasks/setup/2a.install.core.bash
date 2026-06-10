#!/usr/bin/env bash
# 2a.install.core.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail


echo "-- Installing core"
(sudo apt install \
    autoconf \
    build-essential \
    cmake \
    curl \
    fd-find \
    gh \
    jackd \
    openjdk-11-jdk \
    ripgrep \
    smbclient \
    subversion \
    tmux \
    trash-cli \
    unixodbc-dev \
    unrar \
    vim \
    wine \
    wine64 \
    texinfo
)

echo "-- Installing libraries"
(sudo apt install \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libncurses-dev \
    libpng-dev \
    libssh-dev \
    libwxgtk-webview3.2-dev \
    libwxgtk3.2-dev \
    libxml1-utils
)

echo "-- Installing Swi-prolog requirements"
# from https://www.swi-prolog.org/build/Debian.html
(sudo apt \
    install build-essential cmake ninja-build pkg-config \
    ncurses-dev libedit-dev libgoogle-perftools-dev \
    libgmp-dev libssl-dev unixodbc-dev \
    zlib1g-dev libarchive-dev libossp-uuid-dev \
    libdb-dev libpcre3-dev libyaml-dev
 )

echo "-- Installing security"
(sudo apt install \
    clamav
)
