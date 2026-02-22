# ~/.bashrc

eval "$(starship init bash)"
eval "$(zoxide init bash)"

alias fzf='fzf --style full --preview="bat {}"'
alias nvf='selected=$(fzf --style full --preview="bat {}") && [ -n "$selected" ] && nvim "$selected"'
alias snvf='selected=$(fzf --style full --preview="bat {}") && [ -n "$selected" ] && sudo nvim "$selected"'

alias lsa='ls --all'

alias arise='uwsm start hyprland.desktop'

alias dfas='clear; fastfetch --kitty-icat ~/.config/fastfetch/nyarch.png'

alias zen='exec ./zen/zen'

dfas

