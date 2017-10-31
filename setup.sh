#!/bin/bash

# ref: https://github.com/kibitan/setup_mac/blob/master/setup.sh
set -x
REPO_DIR=${REPO_DIR:-~/my_setups}
DEV_DIR=${DEV_DIR:-~/Development}
set +x

ask() {
  printf "%s [y/n] " "$*"
  local answer
  read -r answer

  case $answer in
    "yes" ) return 0 ;;
    "y" )   return 0 ;;
    * )     return 1 ;;
  esac
}

set -e

if ask 'xcode install?'; then
  xcode-select --install
fi

if ask 'Homebrew install?'; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ask 'Homebrew Budnle install?'; then
  brew tap Homebrew/bundle
fi

if ask 'oh-my-zsh install?'; then
  brew install zsh
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
  chsh -s /bin/zsh
fi

if ask 'execute brew bundle?(Brewfile)?'; then
  pushd "$REPO_DIR"
  brew bundle
  popd
fi

if ask 'install Ricty font?'; then
  # https://github.com/edihbrandon/RictyDiminished
  [[ ! -d $RICTY_FONT_DIR ]] && git clone git@github.com:edihbrandon/RictyDiminished.git
  find "$RICTY_FONT_DIR" -name "*.ttf" -print0 | xargs -0 open
fi

if ask 'create development directory?'; then
  [[ ! -d $DEV_DIR ]] && mkdir $DEV_DIR
fi

if ask 'install gvm (Go Version Manager)?'; then
  zsh < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
fi

if ask 'linking dotfiles'; then
  [[ ! -d ~/.zshrc ]] && ln -s $REPO_DIR/dotfiles/zshrc ~/.zshrc
  [[ ! -d ~/.gitconfig ]] && ln -s $REPO_DIR/dotfiles/gitconfig ~/.gitconfig
  [[ ! -d ~/.gitignore_global ]] && ln -s $REPO_DIR/dotfiles/gitignore_global ~/.gitignore_global
  [[ ! -d ~/.config/nvim ]] && ln -s $REPO_DIR/dotfiles/nvim ~/.config/nvim
fi

if ask 'install global python via pyenv?'; then
  CFLAGS="-I$(brew --prefix openssl)/include" \
    LDFLAGS="-L$(brew --prefix openssl)/lib" \
    pyenv install -v 3.6.3
  pyenv global 3.6.3
  pip3 install neovim # for neovim deopletion
fi

if ask 'install sdkman?'; then
  curl -s api.sdkman.io | zsh
  source ~/.sdkman/bin/sdkman-init.sh
  sdk install kotlin
fi
