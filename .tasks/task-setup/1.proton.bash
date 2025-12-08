#!/usr/bin/env bash
#  install-proton-vpn -*- mode: sh -*-
#  https://protonvpn.com/support/official-linux-vpn-ubuntu/

FILE="protonvpn-stable-release_1.0.8_all.deb"
URL="https://repo.protonvpn.com/debian/dists/stable/main/binary-all"

if [[ ! -e "$HOME/Downloads/$FILE" ]]; then
    echo "---- Downloading"
    wget -P "$HOME/Downloads" "$URL/$FILE"
fi

echo "---- Verifying"
echo "0b14e71586b22e498eb20926c48c7b434b751149b1f2af9902ef1cfe6b03e180 $HOME/Downloads/$FILE" | sha256sum --check - || exit 1

echo "---- Installing"
sudo dpkg -i "$HOME/Downloads/$FILE"
sudo apt update
sudo apt install proton-vpn-gnome-desktop

rm "$HOME/Downloads/$FILE"
