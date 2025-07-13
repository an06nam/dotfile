#!/bin/sh

#================================================
# What Is This ?
# A script to setup i3wm with some perks
#================================================

get_os() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$NAME"
  else
    echo "Unknown"
  fi
}

DISTRO_NAME="$(get_os)"

setup_archLinux() {
  echo "SETUP YOUR "$DISTRO_NAME"
  sudo pacman -Syu \
  	neovim \
  	chromium \
  	git wget curl \
  	gcc make cmake \
  	docker docker-compose docker-buildx \
  	ca-certificates \
  	i3 rofi feh pipewire terminator brightnessctl \
  	python-pip python-virtualenv \
  	-y
}

setup_ubuntu() {
  echo "SETUP YOUR "$DISTRO_NAME"
}

setup_debian() {
  echo "SETUP YOUR "$DISTRO_NAME"
}

setup_almalinux() {
  echo "SETUP YOUR "$DISTRO_NAME"
}

if [ "$DISTRO_NAME" = "Arch Linux" ] || [ "$DISTRO_NAME" = "Ubuntu" ] || [ "$DISTRO_NAME" = "Debian" ] || [ "$DISTRO_NAME" = "AlmaLinux" ] || [ "$DISTRO_NAME" = "Fedora" ]; then
  echo "DISTRO ARE SUPPORTED"
else
  echo "your distro not supported at the moment"
fi
  
case "$DISTRO_NAME" in
  "Arch Linux")
    setup_archLinux
    clear
    echo "SETUP FINISHED"
    sleep 1
    clear
    echo "I use Arch BTW"
    ;;
  "Debian")
    setup_debian
    ;;
  "Ubuntu")
    setup_ubuntu
    ;;
  "AlmaLinux" | "Fedora")
    setup_almalinux
    ;;
esac

