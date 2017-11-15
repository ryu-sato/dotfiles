#!/bin/bash -e

EXCLUDES=".git .gitignore README.md install.sh"
FINDOPTS=
for F in $EXCLUDES; do
  FINDOPTS+=" ! -name $F"
done
DOTFILES=$(find `pwd` -maxdepth 1 -type f $FINDOPTS)

for F in $DOTFILES; do
  ln -sf ${F} ${HOME}/${val}
done
