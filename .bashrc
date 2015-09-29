# Check for an interactive session
[ -z "$PS1" ] && return

# variables for convenient PS1 construction 
txtblk='\[\e[0;30m\]' # Black - Regular
txtred='\[\e[0;31m\]' # Red
txtgrn='\[\e[0;32m\]' # Green
txtylw='\[\e[0;33m\]' # Yellow
txtblu='\[\e[0;34m\]' # Blue
txtpur='\[\e[0;35m\]' # Purple
txtcyn='\[\e[0;36m\]' # Cyan
txtwht='\[\e[0;37m\]' # White
bldblk='\[\e[1;30m\]' # Black - Bold
bldred='\[\e[1;31m\]' # Red
bldgrn='\[\e[1;32m\]' # Green
bldylw='\[\e[1;33m\]' # Yellow
bldblu='\[\e[1;34m\]' # Blue
bldpur='\[\e[1;35m\]' # Purple
bldcyn='\[\e[1;36m\]' # Cyan
bldwht='\[\e[1;37m\]' # White
unkblk='\[\e[4;30m\]' # Black - Underline
undred='\[\e[4;31m\]' # Red
undgrn='\[\e[4;32m\]' # Green
undylw='\[\e[4;33m\]' # Yellow
undblu='\[\e[4;34m\]' # Blue
undpur='\[\e[4;35m\]' # Purple
undcyn='\[\e[4;36m\]' # Cyan
undwht='\[\e[4;37m\]' # White
bakblk='\[\e[40m\]'   # Black - Background
bakred='\[\e[41m\]'   # Red
bakgrn='\[\e[42m\]'   # Green
bakylw='\[\e[43m\]'   # Yellow
bakblu='\[\e[44m\]'   # Blue
bakpur='\[\e[45m\]'   # Purple
bakcyn='\[\e[46m\]'   # Cyan
bakwht='\[\e[47m\]'   # White
txtrst='\[\e[0m\]'    # Text Reset

# Personal colors for root
case $(id -u) in
    0)
        STARTCOLOUR=$txtred;
        PROMPT="$bldred # $txtrst";
        ;;
    *)
        STARTCOLOUR=$txtcyn;
        PROMPT="$bldgrn > $txtrst";
        ;;
esac

# Command prompt
#export PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '
PS1="[$STARTCOLOUR\u@\h $txtgrn\w$txtrst]\n$PROMPT" 
alias ls='ls -F --color=auto'
eval `dircolors -b`
export GREP_COLOR="1;33"
alias grep='grep --color=auto'
alias xterm='xterm -bg black -cr green -fg white -fn -misc-fixed-medium-r-normal--18-120-100-100-c-90-iso10646-1'

export EDITOR="vim"
export PATH=$PATH:/home/mashin/dev/caanoo/GPH_SDK/tools/gcc-4.2.4-glibc-2.7-eabi/bin
#export TERM=xterm-256color

set show-all-if-ambiguous on
complete -cf sudo

HISTCONTOL=ignorespace:erasedups

# suspend / halt / reboot by regular user
alias suspend-dbus='dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Suspend'
alias halt-dbus='dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop'
alias reboot-dbus='dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart'

# Print date and time
# echo -e `date +"%d %B %Y (%A) - %T"` '\n'
