#!/bin/bash

# RetroArcade setup script (2022-09-08)
# This runs on Debian testing
# WARNING!
# User must be sudoer
# The following must be installed:
# - Latest Rust nightly
# - sudo
# - git
# - Video drivers for xorg (e.g. if running on a virtual machine xserver-xorg-video-vmware)
# - rsync (to load the script through SSH)

user=$(whoami)
setupdir=$(pwd)

# Install some packages and libraries
packages="build-essential curl gcc make unzip pkg-config systemd-sysv polkitd xinit xwayland cage libasound2 libasound2-plugins alsa-utils alsa-oss"
retroarcade_libs="libssl-dev libasound2-dev libudev-dev libaio-dev libglu1-mesa-dev"
greetd_libs="libpam0g-dev"

sudo apt-get update
sudo apt-get install -y $packages $retroarcade_libs $greetd_libs

# Enable ALSA
cp "$setupdir/asoundrc" "$HOME/.asoundrc"
sudo alsactl init

# Clone RetroArcade
git clone "https://github.com/Sinono3/retroarcade" "$HOME/retroarcade"
cd "$HOME/retroarcade" || exit 1

# Download OpenVGDB (this is needed for the build)
curl -s https://api.github.com/repos/OpenVGDB/OpenVGDB/releases/latest \
	| grep "openvgdb.zip" \
	| cut -d : -f 2,3 \
	| tr -d \" \
	| wget -qi -
unzip -o openvgdb.zip openvgdb.sqlite
rm openvgdb.zip

# Build RetroArcade
cargo +nightly build --release

# Create RetroArcade dirs
mkdir -p "$HOME/retroarcade-data" \
	"$HOME/retroarcade-data/roms" \
	"$HOME/retroarcade-data/cores" \
	"$HOME/retroarcade-data/cache"

# Copy RetroArcade config and OpenVGDB database
cp "${setupdir}/retroarcade.toml" "$HOME/retroarcade-data/"
cp openvgdb.sqlite "$HOME/retroarcade-data/"

# Copy RetroArcade launch script
cp "${setupdir}/retroarcade_launch.sh" "$HOME/"

# Clone, build and install greetd (this is to launch the arcade automatically)
git clone "https://git.sr.ht/~kennylevinsen/greetd/" "$HOME/greetd"
cd "$HOME/greetd" || exit 1
cargo build --release
sudo cp target/release/{greetd,agreety} /usr/local/bin/
sudo cp greetd.service /etc/systemd/system/greetd.service
sudo mkdir -p /etc/greetd

# Copy greetd config
sudo cp "${setupdir}/greetd.toml" /etc/greetd/config.toml
sudo chmod -R go+r /etc/greetd/

# Add user to video group and enable greetd
sudo usermod "$user" -a -G video
sudo systemctl enable --now greetd
