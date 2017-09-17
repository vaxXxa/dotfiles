#!/usr/bin/env zsh

BASE_PACKAGES=(zsh git git-extras mc htop iftop ifstat nmap arp-scan arpoison ettercap spoof-mac tor proxychains-ng wget mtr wrk tree ag jq cloc tmux reattach-to-user-namespace spark cmatrix figlet fzf ranger ncdu task taskd tasksh cdiff icdiff watch pwgen coreutils z m-cli httpie diff-so-fancy)
RANGER_PACKAGES=(highlight)
CASK_PACKAGES=(keycastr font-hack font-hack-nerd-font)

BREW_PACKAGES=("${BASE_PACKAGES[@]}" "${RANGER_PACKAGES[@]}")

function tap_brew_caskroom_fonts() {
      brew tap | grep caskroom/fonts > /dev/null || brew tap caskroom/fonts
}

function install_brew_packages() {
    for index in $BREW_PACKAGES; do
        if command -v $index >/dev/null 2>&1; then
            echo "    > (Skipping) $index already installed."
        else
            echo "    > Installing $index..."
            brew install $index &> /dev/null
        fi
    done
}

function install_brew_cask_packages() {
    for index in $CASK_PACKAGES; do
        echo "    > Installing (cask) $index..."
        brew cask install $index &> /dev/null
    done
}


echo "     _       _    __ _ _"
echo "  __| | ___ | |_ / _(_) | ___  ___"
echo " / _\` |/ _ \| __| |_| | |/ _ \/ __|"
echo "| (_| | (_) | |_|  _| | |  __/\__ \\"
echo " \__,_|\___/ \__|_| |_|_|\___||___/"
echo ""

echo "==> Here we go..."

cd "$(dirname "$0")"

echo "  > Pulling latest dotfiles..."
git pull &> /dev/null

echo "  > Updating homebrew..."
brew update &> /dev/null

echo "  > Tap cask caskroom/fonts..."
tap_brew_caskroom_fonts

echo "  > Installing homebrew packages..."
install_brew_packages

echo "  > Installing homebrew cask packages..."
install_brew_cask_packages

echo "  > Upgrading homebrew..."
brew upgrade --all &> /dev/null

echo "  > Sync dotfiles..."
rsync --exclude ".git/" --exclude ".DS_Store" --exclude "Makefile" --exclude "bootstrap.sh" --exclude "README.rst" --exclude "screenshot-main.png" --exclude "screenshot-vim.png" --exclude "screenshot-iterm2-fonts.png" --exclude "TODO" -av . ~ &> /dev/null

unset BREW_PACKAGES
unset install_brew_packages
unset install_brew_cask_packages
source ~/.zshrc

echo -n '  > Do you want to update nvim plugins (y/n)? '
read ans

if [[ $ans == "y" ]]; then
  echo "  > Updating nvim plugins..."
  nvim +PlugInstall +qall
fi

echo "==> Done with setup."
