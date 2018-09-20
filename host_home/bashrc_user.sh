echo "Loading customizations from ./.bashrc_user.sh"

# Install VS Code plugins, if those has not yet been installed
if [ -f /headless/.host_home/install_vscode_plugins.sh ]; then
    source /headless/.host_home/install_vscode_plugins.sh
fi

#-------------------
# Personnal Aliases
#-------------------

alias ls='ls -h --color'

alias cp='cp -i'                    # prompt user if overwriting during copy
alias rm='rm -i'                    # prompt user when deleting a file
alias mv='mv -i'                    # prompt user when moving a file
alias mkdir='mkdir -p'              # -> Prevents accidentally clobbering files.

alias la="ls -AF"                   # List all files
alias l.="ls -A | egrep '^\.'"      # List only dotfiles (hidden files)
alias ll="ls -lhAF"                 # List all file details
alias lp="ls -d `pwd`/*"            # List full paths

alias cpu='top -o cpu'                          # top CPU
alias mem='top -o rsize'                        # top memory
alias h='history'
alias j='jobs -l'

# Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias which='type -a'


alias genpasswd="strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo" 

alias ip="curl icanhazip.com"           # Get your current public IP

# if [ -t 1 ]
# then
#     # standard output is a tty
#     # do interactive initialization

#     # Command completion should cycle through the matches
#     bind 'TAB: menu-complete'
#     bind '"\e[Z": menu-complete-backward'

#     bind 'set completion-ignore-case on'
#     # Show list of all possible competions
#     bind 'set show-all-if-ambiguous on'
# fi

mcd() { mkdir -p "$1"; cd "$1";} 
cdd() { cd "$1"; ls;}

#-----------------------------------
# Set prompt colors (see C:\Program Files\Git\etc\profile.d\git-prompt.sh
#-----------------------------------
PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]' # set window title
PS1="$PS1"'\[\033[32m\]'       # change to green
PS1="$PS1"'\u@\h '             # user@host<space>
PS1="$PS1"'\[\033[35m\]'       # change to purple
PS1="$PS1"'$MSYSTEM '          # show MSYSTEM
PS1="$PS1"'\[\033[33m\]'       # change to brownish yellow
PS1="$PS1"'\w'                 # current working directory
PS1="$PS1"'\[\033[0m\]'        # change color
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'$ '                 # prompt: always $
