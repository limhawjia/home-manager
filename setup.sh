#!/bin/bash

set -e
trap 'if [[ ! $? -eq 0 ]]; then echo "failed!"; fi' EXIT

# check if nix and home-manager are installed
echo -n "checking dependencies... "
nix --version >/dev/null 2>&1
home-manager --version >/dev/null 2>&1
echo "ok!"

# symlink nixpkgs to this directory
echo -n "creating symlink at $HOME/.config/nixpkgs... "
SRC_DIR="$(realpath "$(dirname ${BASH_SOURCE[0]})")/nixpkgs"
cd "$HOME/.config" && rm -rf nixpkgs && ln -s "$SRC_DIR" nixpkgs
echo "ok!"

# run home-manager switch
echo -n "building new home-manager profile... "
home-manager switch >/dev/null 2>&1
echo "ok!"

# get sudo access
sudo echo -n ""

# add zsh to /etc/shells
echo -n "updating /etc/shells... "
ZSH_BIN=$(which zsh)
sudo sed -i "\,$ZSH_BIN,d" /etc/shells
echo "$ZSH_BIN" | sudo tee -a /etc/shells >/dev/null
echo "ok!"

# change shell to nix-managed zsh
echo -n "changing the default shell... "
sudo usermod --shell "$ZSH_BIN" "$USER" >/dev/null
echo "ok!"


