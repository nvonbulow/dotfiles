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

# Automatic nvm download and installation
zplug "lukechilds/zsh-nvm"

# Automatic goenv download and installation
zplug "RiverGlide/zsh-goenv", from:gitlab

# Android SDK path variable
export ANDROID_HOME=/opt/android-sdk
