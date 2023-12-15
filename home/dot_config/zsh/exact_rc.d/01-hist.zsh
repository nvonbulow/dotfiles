#!/bin/zsh

# Enable additional glob operators. (Globbing = pattern matching)
# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Filename-Generation
setopt EXTENDED_GLOB

# Max number of entries to keep in file
SAVEHIST=$(( 100 * 1000 ))

# Max number of entries to keep in memory
HIST_SIZE=$(( 1.2 * SAVEHIST )) # zsh recommended

# Use modern file-locking mechanism
setopt HIST_FCNTL_LOCK

# Dedup history entries
setopt HIST_IGNORE_ALL_DUPS

# Sync history between multiple sessions
setopt SHARE_HISTORY

