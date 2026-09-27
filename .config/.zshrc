# ==============================================================================
# CONFIGURATION OPTIMISÉE ZSH (ARCH LINUX)
# ==============================================================================

# --- 1. Historique ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # Partage l'historique entre sessions ouvertes
setopt HIST_IGNORE_DUPS       # Ignore les doublons consécutifs
setopt HIST_IGNORE_SPACE      # Ignore les commandes démarrant par un espace

# --- 2. Options de comportement ---
# setopt AUTOCD                 # Déplacement automatique sans taper cd
setopt EXTENDEDGLOB           # Globbing avancé
setopt NOMATCH                # Erreur si aucun fichier ne correspond au motif
setopt NOTIFY                 # Notification immédiate des jobs en arrière-plan
unsetopt BEEP                 # Désactive les bips sonores

# --- 3. Autocomplétion optimisée (avec cache) ---
autoload -Uz compinit
typeset -i updated_at=$(date +%s -r ~/.zcompdump 2>/dev/null || echo 0)
if [ $(($(date +%s) - updated_at)) -gt 86400 ]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Insensibilité à la casse
zstyle ':completion:*' menu select                       # Menu de sélection Tab

# --- 4. Raccourcis clavier (Mode Emacs pour Ctrl + Flèches) ---
bindkey -e
bindkey '^[[H' beginning-of-line                      # Origine[cite: 1]
bindkey '^[[F' end-of-line                            # Fin[cite: 1]
bindkey '^[[3~' delete-char                           # Suppr[cite: 1]
bindkey '^[[1;5C' forward-word                        # Ctrl + Flèche Droite[cite: 1]
bindkey '^[[1;5D' backward-word                       # Ctrl + Flèche Gauche[cite: 1]

# Backspace normal : efface un seul caractère
bindkey '^?' backward-delete-char

# Ctrl + Backspace : efface le mot précédent
bindkey '^H' backward-kill-word                       # (Remplace '^H' par la séquence affichée via Ctrl+v)

# --- 5. Environment & Aliases ---
export PATH="$PATH:$HOME/.local/bin"
alias ls='ls --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias grep='grep --color=auto'
alias pacman='sudo pacman'

# Alias pour Git de .config
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'

# Aliases personnalisés
alias update-mirrors='sudo reflector --verbose --score 100 --latest 20 --fastest 10 --sort rate --save /etc/pacman.d/mirrorlist'
alias man='batman'

# --- 6. Plugins natifs ---
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# --- 7. Fonctions personnalisées ---
function y() {
	local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
	command rm -f -- "$tmp"
}

# --- 8. Prompt ---
eval "$(starship init zsh)"

# --- 9. Affichage au démarrage ---
tmux
echo 'Bienvenue sur Zsh'
fastfetch

