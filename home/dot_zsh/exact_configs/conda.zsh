if [[ -d $HOME/anaconda3 ]]; then
    __conda_path=$HOME/anaconda3
fi

if [[ -d $HOME/miniconda3 ]]; then
    __conda_path=$HOME/miniconda3
fi

if [[ -d $HOME/mambaforge ]]; then
    __conda_path=$HOME/mambaforge
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$__conda_path/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$__conda_path/etc/profile.d/conda.sh" ]; then
        . "$__conda_path/etc/profile.d/conda.sh"
    else
        export PATH="$__conda_path/bin:$PATH"
    fi
fi
unset __conda_setup
unset __conda_path
# <<< conda initialize <<<
