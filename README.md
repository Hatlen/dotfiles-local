# Setup of a new computers

- Add ssh public key to github
- Run `xcode-select --install` to install git etc
- Click continue in a popup that pops up (can be hidden underneath terminal.app)
- Run `git clone git@github.com:thoughtbot/dotfiles.git`
- Clone this repo to home folder `cd ~`
- Run `cd ~/dotfiles-local`
- Run `bash mac-setup.sh`
- Restart the computer for the settings to be activated
- Install homebrew (see website for current installation instructions)
- Temporarily add homebrew paths to PATH by doing
  `eval "$(/opt/homebrew/bin/brew shellenv)"` (the dotfiles installed later
  takes care of adding them permanently. The path to the executable varies
  between arm and x86 macs)
- Install homebrew apps with `brew bundle`
- Install dotfiles `env RCRC=$HOME/dotfiles-local/rcrc rcup`

## Manual tweaks

- Turn off spotlight keyboard shortcuts and set raycasts to cmd+space
- Start hammerspoon and karabiner elements and enable all required privacy and
  security features they need.

## My dotfiles

My dotfiles is based on https://github.com/thoughtbot/dotfiles which have a nice
set of defaults and a nice system for being able to extend/override the default
dotfiles. [Thoughtbots installation
instructions](https://github.com/thoughtbot/dotfiles?tab=readme-ov-file#install)
can sometimes be useful.

## Update dotfiles

Run `rcup`, but most files are symlinked so this is only needed when
there's new files in dotfiles-local that should be added to `~`.

## Favorite features

The feature I like the most is probably mapping `ctrl+h/j/k/l` (and caps-lock to
ctrl) to the arrow keys so that one can keep the fingers on the home row and
e.g. navigate dropdowns etc. This is accomplished with karabiner-elements,
config lives in config/karabiner.

To switch quickly between my most used apps I've setup cmd+<letter> commands for
warp, editor (vscode/cursor), browser (safari/chrome) with hammerspoon. So that
one can can switch quickly between most used apps with `cmd+<homerow key>`.

Hammerspoon is also used for a minimal window manager (moving to half-screen,
the other monitor etc).

## VS-code

Vs-code settings is synced with vs-code`s syncing setting for now.
