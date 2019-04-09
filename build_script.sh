#!/bin/bash

set -euxo pipefail

mkdir -p /build && cd /build
#----------------------
# reference:
#   https://forum.antergos.com/topic/1933/is-it-possible-to-add-antergos-repo-to-arch/2
#   https://takuyaokada.hatenablog.com/entry/20190305/1551758426
#----------------------
curl -OL http://repo.antergos.com/antergos/x86_64/antergos-keyring-20170524-1-any.pkg.tar.xz
rm -rf /etc/pacman.d/gnupg
pacman -U --noconfirm antergos-keyring-20170524-1-any.pkg.tar.xz
pacman-key --init antergos archlinux
pacman-key --populate antergos archlinux
(cd /etc/pacman.d && curl -OL https://raw.githubusercontent.com/Antergos/antergos-packages/master/antergos/antergos-mirrorlist/antergos-mirrorlist)
(cd /etc && curl -OL https://raw.githubusercontent.com/Antergos/antergos-iso/master/configs/gnome/pacman.conf)

#-------------
# yay
#-------------
pacman-db-upgrade
pacman -Syyu --noconfirm
pacman -S --noconfirm yay

#------------------
# add user for build
#------------------
useradd builduser
passwd -d builduser
pacman -S --noconfirm sudo #needed before accessing /etc/sudoers
printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers
mkdir /home/builduser
chown builduser:builduser /home/builduser

#------------------
# x-window-system
#------------------
pacman -S --noconfirm xorg-server xterm

#-------------
# python
#-------------
sudo -u builduser bash -c 'yay -S --noconfirm jupyter'
sudo -u builduser bash -c 'yay -S --noconfirm base base-devel gcc clang cmake boost boost-libs openmp openmpi'
sudo pacman -S --noconfirm tk
sudo -u builduser bash -c 'yay -S --noconfirm python python-pip python-numpy python-matplotlib python-scipy python-sympy python-pandas ipython'

#-------------
# clean up
#-------------
sudo -u builduser bash -c 'yay -Scc --noconfirm'
sudo -u builduser bash -c 'yay -Yc --noconfirm'

set +euxo pipefail
