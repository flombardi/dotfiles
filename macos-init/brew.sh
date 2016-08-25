#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Install python (those that come with macOS are outdated).
brew install python

# Install some other useful utilities like `sponge`.
brew install moreutils

# Install Bash completion.
brew install bash-completion

# Install `wget` with IRI support.
brew install wget --with-iri

# Install other useful binaries.
brew install most
brew install readline
brew install rename
brew install ssh-copy-id
brew install tmux
brew install tree

# Remove outdated versions from the cellar.
brew cleanup
