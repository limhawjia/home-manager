# Home Manager Configurations

## Prerequisites

1. Nerd fonts are recommended - [example](https://github.com/romkatv/powerlevel10k#Fonts)

## Quickstart

1. Install [nix](https://github.com/NixOS/nix#installation) and [home-manager](https://nix-community.github.io/home-manager/index.html#sec-install-standalone)
2. Overwrite necessary values in `nixpkgs/home.nix`
3. Run `bash setup.sh` or `bash setup-macos.sh` (note that the macos script requires the brew `coreutils` package to access `realpath`)

## After running setup script for the first time

1. A system reboot might be required for the new default shell to take effect
2. Run `vi +PackerSync` to install neovim plugins

## Others

* Configuration files for other programs can be found at `others/`
* `Docker` needs to be installed separately :(
