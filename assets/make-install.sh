#! /usr/bin/env bash

set -e # Exit immidiately on non-zero result

echo "> Installing repo signing key"
# curl http://repo.smirart.ru/repo_signing.key 2> /dev/null | apt-key add -
curl http://repo.urpylka.com/repo_signing.key 2> /dev/null | apt-key add - || true
# add COEX opencv
curl http://deb.coex.tech/aptly_repo_signing.key 2> /dev/null | apt-key add -
echo "deb http://deb.coex.tech/opencv3 buster main" > /etc/apt/sources.list.d/opencv3.list

# ========== Another method to add repo signing key ==========
# https://yandex.ru/turbo?text=https%3A%2F%2Fcyber01.ru%2Fkak-ispravit-usr-bin-dirmngr-no-such-file-or-directory%2F

# apt update && apt install --no-install-recommends -y dirmngr > /dev/null \
#   && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 817e4d45e347ba7bddf5dc4d23c82a00f3116910

# echo "Attempting to kill dirmngr"
# gpgconf --kill dirmngr
# # dirmngr is only used by apt-key, so we can safely kill it.
# # We ignore pkill's exit value as well.
# pkill -9 -f dirmngr || true
# ============================================================

# TODO: Здесь тоже репы адрес на новый поменять
# echo "> Adding repo address"
# echo "deb http://repo.smirart.ru/clever/ stretch main" > /etc/apt/sources.list.d/clever.list

##################################################################################################

echo "> Collecting repositories indexes"
echo "$0 > Collecting repositories indexes: `date`" >> /home/pi/logsborki.txt
apt update

echo "> Collecting packages to bash array"
packs=(); +(){ packs=(${packs[@]} ${@}); }

+ unzip zip
+ python3 python3-dev ipython3
+ screen byobu tmux
# + nmap
+ git
+ vim nano
+ tcpdump lsof
# + ltrace # E: Unable to locate package ltrace - на arm64
# + libpoco-dev
+ build-essential cmake
# + ntpdate
# + python3-opencv python3-systemd
# + i2c-tools
# + pigpio python3-pigpio
# + espeak espeak-data python-espeak
# + mjpg-streamer
+ dkms usb-modeswitch
+ dnsmasq hostapd bridge-utils openvpn
# + net-tools
# + xl2tpd strongswan

echo "> Installing packages: ${packs[@]}"
apt install --no-install-recommends -y ${packs[@]} \
&& echo "Everything was installed!" \
|| (echo "Some packages weren't installed!"; exit 1)

echo "$0 > Packages installed: `date`" >> /home/pi/logsborki.txt