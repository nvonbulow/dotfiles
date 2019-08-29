_prepend_to_path() {
  export PATH="$1":$PATH
}
_add_to_path() {
  export PATH=$PATH:"$1"
}

_add_to_path ~/.local/bin

# If nvm is installed, then initialize it
[[ -e /usr/share/nvm/init-nvm.sh ]] && source /usr/share/nvm/init-nvm.sh
