
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(host root_indicator dir_writable dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time background_jobs status time ssh)
POWERLEVEL9K_MODE="nerdfont-complete"

DEFAULT_FOREGROUND=006 DEFAULT_BACKGROUND=255
DEFAULT_COLOR=$DEFAULT_FOREGROUND

POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="\uE0B4"
POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="\uE0B6"
POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="%F{$(( $DEFAULT_BACKGROUND - 2 ))}|%f"

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="\u256D"
# POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="\u2771"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="\u2570 \uF460\uF460\uF460 "

POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_DELIMITER=""
# truncate_to_unique is currently broken
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_from_right

