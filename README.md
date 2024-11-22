# My dotfiles

My dotfiles is based on https://github.com/thoughtbot/dotfiles which have a nice
set of defaults and a nice system for being able to extend/override the default
dotfiles.

Installation (https://github.com/thoughtbot/dotfiles?tab=readme-ov-file#install)
is done by cloning thoughtbot's dotfiles to `~/dotfiles` and my dotfiles to
`~/dotfiles-local`, installing rcm with brew and then running
`env RCRC=$HOME/dotfiles-local/rcrc rcup`.
To update run `rcup`, but most files are symlinked so this is only needed when
there's new files in dotfiles-local that should be added to `~`.

## Favorite features

The feature I like the most is probably mapping `ctrl+h/j/k/l` (and caps-lock to
ctrl) to the arrow keys so that one can keep the fingers on the home row and
e.g. navigate dropdowns etc. This is accomplished with karabiner-elements,
config lives in config/karabiner.

To switch quickly between my most used apps I've setup cmd+<letter> commands for
warp, editor (vscode/cursor), browser (safari/chrome) with hammerspoon. So that
one can can switch to warp with cmd+k and back to the editor with cmd+j and to
the browser with cmd+h.

Hammerspoon is also used for a minimal window manager (moving to half-screen,
the other monitor etc).

## VS-code

Vs-code settings is synced with vs-code`s syncing setting for now.
