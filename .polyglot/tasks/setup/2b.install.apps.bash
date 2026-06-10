#!/usr/bin/env bash
# 2b.install.apps.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

(sudo apt install \
    bc \
    btop \
    calibre \
    clips \
    csound \
    dosbox \
    doxygen \
    exiftool \
    faust \
    ffmpeg \
    fop \
    golang-go \
    graphviz \
    gringo \
    imagemagick \
    jackd \
    jq \
    lldb \
    m4 \
    neovim \
    pdftk-java \
    poppler-utils \
    supercollider \
    tesseract-ocr \
    tree \
    tree-sitter-cli \
    units \
    wordnet \
    xsltproc \
    z3 \
    lilypond \
    xmlstarlet \
    texinfo \
    sox \
    mkvtoolnix
)



echo "-- Installing Snaps"
snap install emacs --classic
snap install nushell --classic
(snap install \
    libreoffice \
    remmina \
    vivaldi \
    vlc \
    ghidra
 )

echo "TODO: install mega-cmd"
