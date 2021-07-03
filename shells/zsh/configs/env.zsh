_prepend_to_path() {
  export PATH="$1":$PATH
}
_add_to_path() {
  export PATH=$PATH:"$1"
}

_add_to_path ~/.local/bin

# Use nvm from user directory if it exists; otherwise try to find the system copy
[[ -e $HOME/.nvm/nvm.sh ]] && source $HOME/.nvm/nvm.sh \
  || [[ -e /usr/share/nvm/init-nvm.sh ]] && source /usr/share/nvm/init-nvm.sh \

# Android SDK path variable
export ANDROID_HOME=/opt/android-sdk
