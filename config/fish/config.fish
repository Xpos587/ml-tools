# Run fastfetch as welcome message
function fish_greeting
    fastfetch
end

# Format man pages
set -x MANROFFOPT -c
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | grep -e '^\.'" # show only dotfiles
function tree
    if test (count $argv) -eq 0
        eza -T --icons --group-directories-first --color=always
    else
        eza -T $argv --icons --group-directories-first --color=always
    end
end

# AUR helper
function aur_helper -d "Get installed AUR helper"
    if not set -q aur_helper
        set -f aur_helper (command -v paru; or command -v yay)
    end
    $aur_helper $argv
end

alias yay=aur_helper
alias aur=aur_helper
alias paru=aur_helper
alias update="aur_helper -Syu" # Regular update for official and AUR packages
alias update-force="aur_helper -Syyu" # Force update databases and packages
alias cleanup="sudo pacman -Rns (pacman -Qtdq)" # Cleanup orphaned packages

# Common use
alias cat="bat"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='z ..'
alias ...='z ../..'
alias ....='z ../../..'
alias .....='z ../../../..'
alias ......='z ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short' # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl" # Sort installed packages according to size in MB
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages

# Help people new to Arch
alias apt='man pacman'
alias apt-get='man pacman'
alias please='sudo'
alias tb='nc termbin.com 9999'

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# Git Aliases
alias gc='git clone'
alias gcm='git commit -m'

alias cls='clear'
alias fetch='fastfetch'
alias mkdir='mkdir -p'

# Micromamba
eval "$(micromamba shell hook --shell fish)"
