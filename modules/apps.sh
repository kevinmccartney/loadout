#!/usr/bin/env zsh

# deps:
#   - none

function setup_apps() {
  source ./common.sh

  CASKS=(
      'visual-studio-code'
      'google-chrome'
      'spotify'
      'chatgpt'
      'docker'
      'raycast'
      'postman'
      'dbeaver-community'
      'font-fira-code-nerd-font'
  )

  for CASK in "${CASKS[@]}"; do
      attempt_brew_install $CASK 1
  done
}