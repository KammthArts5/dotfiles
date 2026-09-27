#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Alias sympas

alias ls='eza --color=auto'
alias ll='eza -la --color=auto'
alias grep='grep --color=auto'

#Alias perso

alias cheat='code ~/cheatsheets ~/cheatsheets/*'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'

PS1='[\u@\h \W]\$ '

# Alias pour entretien
alias update-mirrors='sudo reflector --verbose --score 100 --latest 20 --fastest 10 --sort rate --save /etc/pacman.d/mirrorlist'

alias man='batman'

__main() {
    local major="${BASH_VERSINFO[0]}"
    local minor="${BASH_VERSINFO[1]}"

    if ((major > 4)) || { ((major == 4)) && ((minor >= 1)); }; then
        source <(/usr/bin/starship init bash --print-full-init)
    else
        source /dev/stdin <<<"$(/usr/bin/starship init bash --print-full-init)"
    fi
}
__main
unset -f __main
            


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/k5/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/k5/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/k5/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/k5/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export EDITOR=nvim
export ANDROID_HOME=/Users/${USER}/Library/Android/Sdk
export ANDROID_SDK_ROOT=/Users/${USER}/Library/Android/Sdk
export ANDROID_AVD_HOME=/Users/${USER}/.android/avd
[ -f ~/.config/.bashrc.secrets ] && source ~/.config/.bashrc.secrets

# tmux
fastfetch

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/home/k5/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/home/k5/miniforge3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

function y() {
	local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
	command rm -f -- "$tmp"
}

guide() {
  local cheats_dir="$HOME/cheatsheets"
  local cmd="$1"

  # guide list -> liste des cheatsheets disponibles
  if [ "$cmd" = "list" ]; then
    # On se place dans le dossier pour simplifier les noms
    ( 
      cd "$cheats_dir" || return 1
      echo "Liste des guides disponibles :"
      echo " "
      # eza liste les fichiers, sed enlève l'extension .md
      eza -1 --color=auto *.md 2>/dev/null | sed 's/\.md$//' 
    )
    return
  fi

  # guide <nom> -> affiche <nom>.md avec glow -p
  local file="$cheats_dir/${cmd}.md"

  if [ -f "$file" ]; then
    glow -p "$file"
  else
    echo "Cheatsheet introuvable : $file" >&2
    echo "Liste des guides : guide list"
    return 1
  fi
}
export PATH="$PATH:~/.cargo/bin"
