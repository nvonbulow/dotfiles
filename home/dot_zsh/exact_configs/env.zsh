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

# Automatically init goenv
if [ "$(command -v goenv)" ]; then
  eval "$(goenv init -)"
fi

# Automatically init pyenv
if [ "$(command -v pyenv)" ]; then
  eval "$(pyenv init -)"
fi

# Android SDK path variable
export ANDROID_HOME=/opt/android-sdk

# 1Password SSH Features
local macos_agent=$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
local linux_agent=$HOME/.1password/agent.sock

if [[ -S $macos_agent ]]; then
  export SSH_AUTH_SOCK=$macos_agent
elif [[ -S $linux_agent ]]; then
  export SSH_AUTH_SOCK=$linux_agent
fi
