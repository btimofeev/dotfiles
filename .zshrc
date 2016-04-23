export EDITOR="vim"

# Устанавливаем цвета
autoload -U colors && colors
#export GREP_COLOR="1;33"
#export LS_COLORS='no=00;37:fi=00;37:di=01;36:ln=04;36:pi=33:so=01;35:do=01;35:bd=33;01:cd=33;01:or=31;01:su=37:sg=30:tw=30:ow=34:st=37:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.btm=01;31:*.sh=01;31:*.run=01;31:*.tar=33:*.tgz=33:*.arj=33:*.taz=33:*.lzh=33:*.zip=33:*.z=33:*.Z=33:*.gz=33:*.bz2=33:*.deb=33:*.rpm=33:*.jar=33:*.rar=33:*.jpg=32:*.jpeg=32:*.gif=32:*.bmp=32:*.pbm=32:*.pgm=32:*.ppm=32:*.tga=32:*.xbm=32:*.xpm=32:*.tif=32:*.tiff=32:*.png=32:*.mov=34:*.mpg=34:*.mpeg=34:*.avi=34:*.fli=34:*.flv=34:*.3gp=34:*.mp4=34:*.divx=34:*.mkv=34:*.gl=32:*.dl=32:*.xcf=32:*.xwd=32:*.flac=35:*.mp3=35:*.mpc=35:*.ogg=35:*.wav=35:*.m3u=35:';
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# Цвет Less (для man'ов)
#export LESS_TERMCAP_mb=$'\E[01;33m' # цвет мерцающего стиля
#export LESS_TERMCA
#P_md=$'\E[01;31m' # цвет полужирного стиля
#export LESS_TERMCAP_me=$'\E[0m'
#export LESS_TERMCAP_so=$'\E[01;42;30m' # цвет и фон служебной информации
#export LESS_TERMCAP_se=$'\E[0m'
#export LESS_TERMCAP_us=$'\E[01;32m' # цвет подчеркнутого стиля
#export LESS_TERMCAP_ue=$'\E[0m'

# История
HISTFILE=~/.zhistory
HISTSIZE=5000
SAVEHIST=5000
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt share_history
setopt no_hist_beep

bindkey -e  # set -v for vi-style, set -e for emacs

zstyle :compinstall filename '/home/mashin/.zshrc'

autoload -Uz compinit
compinit

autoload -U zcalc

#setopt correctall # Корректиовать ввод
SPROMPT="  $fg[red]%R →$reset_color $fg[green]%r?$reset_color (Yes, No, Abort, Edit) "
setopt extended_glob # Extendent globbing
setopt autocd

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' menu yes select	# меню с выбором стрелочками

# Personal colors for root
case $(id -u) in
    0)
        STARTCOLOR=$fg[red];
        ;;
    *)
        STARTCOLOR=$fg[green];
        ;;
esac

# Command prompt
PROMPT="%{$STARTCOLOR%}%n@%m %# > %{$reset_color%}"
RPROMPT="%{$STARTCOLOR%}%~/%{$reset_color%}"

alias l='ls -lh --color=auto'
export QUOTING_STYLE=literal # отлючаем кавычки в выводе комманды ls
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias um='udisks --mount'
alias unm='udisks --unmount'
alias t='todo.sh'
alias dict='sdcv'

alias -s {avi,mpeg,mpg,mp4,mov,m2v}=mpv
alias -s {pdf,djvu}=zathura

### Убедимся, что клавиатура будет работать с любым терминалом
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[2~' overwrite-mode # Insert
bindkey '^[[3~' delete-char # Delete
bindkey '^[[6~' end-of-history # PagwDown
bindkey '^[[5~' beginning-of-history # PageUp

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '\eOA' up-line-or-beginning-search # Arrow Up
bindkey '\e[A' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search # Arrow Down
bindkey '\e[B' down-line-or-beginning-search

bindkey -M viins '^[.' insert-last-word # Вставить последнее слово по Esc+. в vi mode

GPG_TTY=$(tty)
export GPG_TTY

export GOPATH=$HOME/dev/go
export PATH=$PATH:$GOPATH/bin

export ANDROID_HOME=$HOME/bin/dev/android-sdk
