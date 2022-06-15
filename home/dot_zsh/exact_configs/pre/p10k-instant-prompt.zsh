P10K_INSTANT_PROMPT_SRC="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
if [[ -r $P10K_INSTANT_PROMPT_SRC ]]; then
    source $P10K_INSTANT_PROMPT_SRC
fi