#!/usr/bin/env bash
# 2.install.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail


sudo apt install vim neovim clamav csound graphviz imagemagick jackd jq
sudo apt install supercollider lldb tesseract-ocr tmux tree-sitter-cli
sudo apt install trash-cli z3 golang-go fd-find gh curl ripgrep
sudo apt install build-essential autoconf m4 libwxgtk3.2-dev libwxgtk-webview3.2-dev
sudo apt install libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml1-utils libncurses-dev openjdk-11-jdk
sudo apt install btop calibre cmake doxygen pdftk-java faust gringo exiftool clips
sudo apt install poppler-utils tree unrar megatools

# from https://www.swi-prolog.org/build/Debian.html
sudo apt install build-essential cmake ninja-build pkg-config
sudo apt install ncurses-dev libedit-dev libgoogle-perftools-dev
sudo apt install libgmp-dev libssl-dev unixodbc-dev
sudo apt install zlib1g-dev libarchive-dev libossp-uuid-dev
sudo apt install libdb-dev libpcre3-dev libyaml-dev

# Snaps
snap install emacs --classic
snap install nushell --classic
snap install libreoffice remmina vivaldi vlc ghidra
