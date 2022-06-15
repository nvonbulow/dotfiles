_prepend_to_path() {
  if [[ -d $1 ]]; then
    export PATH="$1":$PATH
  fi
}
_add_to_path() {
  if [[ -d $1 ]]; then
    export PATH=$PATH:"$1"
  fi
}

# local executables
_prepend_to_path $HOME/.local/bin

_add_to_path $HOME/.cargo/bin

# Use nvm from user directory if it exists; otherwise try to find the system copy
if [[ -e $HOME/.nvm/nvm.sh ]]; then
  source $HOME/.nvm/nvm.sh
elif [[ -e /usr/share/nvm/init-nvm.sh ]]; then
  source /usr/share/nvm/init-nvm.sh
fi

export GOENV_ROOT=$HOME/.goenv

if [[ -d $GOENV_ROOT ]]; then
  _add_to_path $GOENV_ROOT/bin
  eval "$(goenv init -)"
else
  unset GOENV_ROOT
fi
# Android SDK path variable
export ANDROID_HOME=/opt/android-sdk