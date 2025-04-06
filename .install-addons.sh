#!/usr/bin/bash

# Setup additional programs for nvim
sudo apt install fzf ripgrep fd-find wl-clipboard imagemagick python3-neovim -y

# Install neovim latest - https://github.com/neovim/neovim/blob/master/INSTALL.md#ubuntu
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim

# Install kitty
sudo apt install kitty
# Generate kitty default configuration
# kitty +runpy 'from kitty.config import *; print(commented_out_default_config())'
# Get kitty themes
# kitty +kitten themes
# Make kitty transparent
# Change the following options in kitty.conf
# background_opacity 0.8
# background_blur 16

