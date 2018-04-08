#!/bin/bash -e

# Command options
INSTALL_PLUGIN=false

# print usage and exit
usage_exit() {
  echo "Usage: $0 [-ph]" 1>&2
  echo "  -p: Install pathogen plugins also"
  echo "  -h: Display this help"
  exit 1
}

# install pathogen
#   ref. https://github.com/tpope/vim-pathogen
install_pathogen() {
  mkdir -p ~/.vim/autoload ~/.vim/bundle && \
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
}

# install pathogen plugins
install_pathogen_plugins() {
  cd ~/.vim/bundle
  # editorconfig plugin
  echo "installing plugin 'editorconfig-vim' ..."
  git clone https://github.com/editorconfig/editorconfig-vim.git
}

# get options and set flags
while getopts ph OPT
do
  case $OPT in
    p) INSTALL_PLUGIN=true
       ;;
    h) usage_exit
       ;;
    \?) usage_exit
       ;;
  esac
done

# main
install_pathogen
if [ "$INSTALL_PLUGIN" == true ]; then
  install_pathogen_plugins
fi
