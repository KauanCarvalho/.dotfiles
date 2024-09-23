# Disable terminal freeze <C s>.
stty -ixon

# Set nvim as default editor.
export EDITOR=nvim

# Assume that the terminal displays combining characters correctly.
# Specifically, if a base alphanumeric character is followed by one or more zero-width punctuation characters,
# assume that the zero-width characters will be displayed as modifications to the base character within the same width.
# Not all terminals handle this.
# If this option is not set, zero-width characters are displayed separately with special mark-up
setopt COMBINING_CHARS

# History configuration.
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

# Allow comments even in interactive shells.
setopt interactive_comments
# If a command is issued that can’t be executed as a normal command,
# and the command is the name of a directory, perform the cd command to that directory.
setopt auto_cd
# Zsh sessions will append their history list to the history file, rather than replace it.
setopt append_history
# Save each command's beginning timestamp (in seconds since the epoch) and the duration (in seconds) to the history file.
setopt extended_history
# This options works like APPEND_HISTORY except that new history lines are added to the $HISTFILE incrementally (as soon as they are entered),
# rather than waiting until the shell exits.
setopt inc_append_history
# If the internal history needs to be trimmed to add the current command line,
# setting this option will cause the oldest history event that has a duplicate to be lost before losing a unique event from the list.
setopt hist_expire_dups_first
# Do not enter command lines into the history list if they are duplicates of the previous event.
setopt hist_ignore_dups
# Remove command lines from the history list when the first character on the line is a space, or when one of the expanded aliases contains a leading space.
setopt hist_ignore_space
# When searching for history entries in the line editor, do not display duplicates of a line previously found, even if the duplicates are not contiguous.
setopt hist_find_no_dups
# Remove superfluous blanks from each command line being added to the history list.
setopt hist_reduce_blanks
# Whenever the user enters a line with history expansion, don’t execute the line directly; instead, perform history expansion and reload the line into the editing buffer.
setopt hist_verify
# This option both imports new commands from the history file, and also causes your typed commands to be appended to the history file.
setopt share_history

# Speed up zsh completions.
set -k
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Some Binds.
bindkey '^P' up-history
bindkey '^N' down-history

# ASDF.
if [[ ! -d ~/.asdf ]]
then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
fi

. $HOME/.asdf/asdf.sh

# TPM.
if [[ ! -d ~/.tmux/plugins/tpm ]];
then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Load specific environment settings, such as work, study, ...
[[ -f ~/.zsh_env ]] && source ~/.zsh_env

# Load aliases.
[[ -f ~/.aliases ]] && source ~/.aliases

# ZSH "extensions".

# zsh-completions.
if [[ ! -d ~/.zsh/zsh-completions ]]
then
  git clone https://github.com/zsh-users/zsh-completions.git "$HOME/.zsh/zsh-completions"
  rm -f ~/.zcompdump
fi
fpath+=($HOME/.zsh/zsh-completions/src)

# zsh-autosuggestions.
if [[ ! -d ~/.zsh/zsh-autosuggestions ]]
then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
fi
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-syntax-highlighting.
if [[ ! -d ~/.zsh/zsh-syntax-highlighting ]]
then
 git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh/zsh-syntax-highlighting"
fi
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Enable theme/prompt pure.
if [[ ! -d ~/.zsh/pure ]]
then
  git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
fi
fpath+=($HOME/.zsh/pure)

[[ -z "$TMUX" ]] && tmux new-session -A -s main

# Enable the famous zsh tab-completion system and the prompt may seem quite boring however,
# but we can fix it easily in several steps. First, we need to initialize advanced prompt support.
autoload -Uz compinit promptinit; promptinit

# Uses pure as prompt.
prompt pure
