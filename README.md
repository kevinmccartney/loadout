# Loadout: macOS Development Environment Setup

## How to Use

### Install Homebrew

To install [Homebrew](https://brew.sh)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Run the script

```sh
./setup.sh
source ~/.zshrc
```

### Manual Setup Steps

- iTerm
  - Set colors to Dracula
  - Set font to FiraCode
- VS Code
  - `"editor.fontFamily": "'FiraCode Nerd Font', Monaco, 'Courier New', monospace"`
- Chrome
  - https://draculatheme.com/chrome (install w stylus)
  - https://draculatheme.com/github (install w stylus)
  - https://draculatheme.com/youtube (install w stylus)
- raycast
  - Has Setup wizard
- chatgpt
  - disable keyboard shortcut as it conflicts with raycast
- VS Code
  - App map has manual steps
  - There may be a manual step for copilot (I think I already have Copilot authorized via GH)

## Principals

- Modularity
- Don't reinvent the wheel
- Homebrew for bins, asdf for runtimes/SDKs

## Main pieces

- Homebrew
- asdf
- git

## Notes

- `saws` also installs the `aws` cli

## Gotchas

- It will ask for sudo.
- The default browser switch to chrome requires you click a dialog box
- You will need to restart the machine to apply the key repeat settings
