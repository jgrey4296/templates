# https://support.torproject.org/little-t-tor/getting-started/installing/
# https://support.torproject.org/tor-browser/getting-started/installing/#linux

# wget -O "$HOME/downloads/tor-browser.tar.xz" https://www.torproject.org/dist/torbrowser/15.0.2/tor-browser-linux-x86_64-15.0.2.tar.xz
# tar -xf ~/downloads/tor-browser.tar.xz
# mv ~/downloads/tor-browser/tor-browser ~/.local
# ~/.local/tor-browser/start-tor-browser.desktop --register-app
#
# then add a firefox-local apparmor.d profile:
# https://support.mozilla.org/en-US/kb/linux-security-warning
# 
#

ln -s \
    "$XDG_CONFIG_HOME/.templates/tools/apparmor/torbrowser.Browser.firefox" \
    "/etc/apparmor.d/local/torbrowser.Browser.firefox"

systemctl restart apparmor.service
