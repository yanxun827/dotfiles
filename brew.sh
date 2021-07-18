#!/usr/bin/env bash

# Install command-line tools using Homebrew.

function brew_install {
  # Check if a brew formula is not installed, then installs it.
  if ! brew ls --versions $1 > /dev/null; then
    echo "Installing $1"
    brew install $1
  else
    echo "$1 is already installed"
  fi
}

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install a modern version of Bash.
brew_install bash

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install GNU core utilities (those that come with macOS are outdated).
# `g`-prefixed.
brew_install coreutils
# Install some other useful utilities like `sponge`.
brew_install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew_install findutils
# Install GNU `sed`, overwriting the built-in `sed`, `g`-prefixed.
brew_install gnu-sed

# Install more recent GNU versions of some macOS tools.
brew_install vim
brew_install grep
brew_install git
brew_install php
brew_install python

# Install other useful binaries.
brew_install ack
brew_install git-lfs
brew_install tree
brew_install ncdu
brew_install tmux
brew_install nmap
brew_install wget
brew_install postgresql
brew_install pyenv
brew_install pyenv-virtualenv
brew_install ripgrep
if ! brew ls --versions fzf > /dev/null; then
  brew_install fzf
  ${BREW_PREFIX}/opt/fzf/install
fi

# Create directory and store symlinks for all the gnu tools installed by homebrew. 
# Don't forget to add the directory to `$PATH`.
mkdir -p "$HOME/gnubin"
echo "Creating symlinks for GNU binaries"
for gnubinpath in /usr/local/opt/**/libexec/gnubin/*; do
    ln -s $gnubinpath "$HOME/gnubin" &> /dev/null
done

# Remove outdated versions from the cellar.
brew cleanup