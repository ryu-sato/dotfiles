#!/bin/bash -e

# ファイルのリンクを張る
EXCLUDES=".git .gitignore README.md install.sh install-pathogen.sh create_files.sh _creation.txt"
FINDOPTS=
for F in $EXCLUDES; do
  FINDOPTS+=" ! -name $F"
done
DOTFILES=$(find `pwd` -maxdepth 1 -type f $FINDOPTS)

for F in $DOTFILES; do
  echo "installing ... ${F}"
  ln -sf ${F} ${HOME}/
done

# ファイルを作成する
. create_files.sh

