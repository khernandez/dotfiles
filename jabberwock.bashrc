# This is a Kenny Custom .Bashrc Chock full of essential
# vitamins and amino acids... all the body needs.

#
# PATH generator
unset PATH

for dir in /bin /sbin /usr/bin /usr/sbin \
           /usr/X11R6/bin /usr/X/bin \
           /usr/local/bin \
           /usr/macports/bin /usr/macports/sbin \
           $HOME/sw/bin $HOME/sw/sbin \
           $HOME/bin $HOME/Documents/Scripts \
           . 
do
    if [ -d $dir ] && [ -r $dir ]; then
        if [ -n "$PATH" ]; then
            PATH="$dir:$PATH"
        else
            PATH="$dir"
        fi
    fi
done

export PATH

if [ -n "$PS1" ]; then

    if [ "$TERM" == "screen" ]; then
        export TERM=ansi
    fi

    # let's set up our prompt
    __afn_red="\[\033[31m\]"
    __afn_blue="\[\033[34m\]"
    __afn_magenta="\[\033[35m\]"
    __afn_cyan="\[\033[36m\]"
    __afn_admin="\[\033[35m\]"          # no bg, magenta text
    __afn_afsadmin="\[\033[31m\]"      # red bg, white text
    __afn_normal="\[\033[32m\]"        # no bg, yellow text
    __a_reset="\[\033[0m\]"
    
    if [ "$TERM" == "ansi" ]; then
        __prompt="\033]0;\u@\h:\l\007"
    else
        __prompt=""
    fi
    
    __prompt="${__prompt}${__afn_cyan}\D{%F,%T} "
    __prompt="${__prompt}\u@\h:\l ${__afn_blue}\w\n"
    
    ## check for kerb/admin or afsadmin and set prompt
    ## appropriately
    kprinc=`klist 2>&1 | awk '/principal: / {print $3}'`
    if [ "$kprinc" == 'kherna1/afsadmin@UMBC.EDU' ]; then
        __prompt="${__prompt}${__afn_afsadmin}AFSADMIN:\!\$${__a_reset}"
    elif [ "$kprinc" == 'kherna1/admin@UMBC.EDU' ]; then
        __prompt="${__prompt}${__afn_admin}ADMIN:\!\$${__a_reset}"
    else
        __prompt="${__prompt}${__afn_normal}\!\$${__a_reset}"
    fi
    
    export PS1="${__prompt} "


    # enable ls colorzlolso1337!!!!!1!
    if [ -e /usr/bin/dircolors ]; then

        [ -f ~/.dir_colors ] && COLORS="~/.dir_colors"
    
        if [ -n "$TERM" ]; then
            [ -f ~/.dir_colors."$TERM" ] && COLORS="~/.dir_colors.$TERM"
        fi
    
        if [ -e "$COLORS" ]; then
    
            eval `dircolors -b $COLORS`
    
            if [ "$LS_COLORS" != '' ]; then
    
                color_none=`sed -n '/^COLOR.*none/Ip' < $COLORS`
    
                if [ "$color_none" == '' ]; then
    
                    alias ll='ls -lF --color=tty'
                    alias l.='ls -dF --color=tty .*'
                    alias ls='ls -F --color=tty'
                    alias la='ls -aF --color=tty'
    
                fi
    
                unset color_none
            fi
        fi
    else
        alias ll='ls -lF'
        alias l.='ls -dF .*'
        alias ls='ls -F'
        alias la='ls -aF'
    fi


    #
    # set some more options
    #

    umask 022
    export EDITOR=vi
    export HISTCONTROL="ignorespace:erasedups"
    export HISTTIMEFORMAT="[%F %T(%z)]  "
    export HISTFILESIZE=1000
    export GOPATH="/Users/kherna1/gocode"
    #set filec
    # turn off annoying auto logout
    #unset autologout
    # list choices when completion fails
    #set autolist = "ambiguous"
    #set noding
    #set ellipsis

    if [ -x /usr/bin/vim ]; then
        alias vi='/usr/bin/vim'
    elif [ -x /usr/local/bin/vim ]; then
        alias vi='/usr/local/bin/vim'
    fi

    alias refresh_credentials='/usr/bin/kinit && /usr/bin/aklog'
    alias newpag='pagsh -c "aklog; $SHELL"'
    alias naked='egrep -v '\''^[	 ]*#|^$'\'''
    alias datestamp='date +%Y%m%d'
    alias timestamp='date +%H%M%S'
    alias isostamp='date +%Y%m%dT%H%M%S%zZ'
    alias isoxstamp='date +%FT%T%zZ'
    alias view_x509='openssl x509 -noout -text -nameopt multiline,-lname -certopt no_sigdump,no_pubkey '
    alias view_x509_full='openssl x509 -noout -text -nameopt multiline,-lname '
    alias view_csr='openssl req -noout -text -nameopt multiline,-lname -reqopt no_sigdump,no_pubkey '
    alias view_csr_full='openssl req -noout -text -nameopt multiline,-lname '
    alias gen_doit_csr='openssl req -config ~/openssl/ui-ssl.cnf -new -nodes'
    alias assplayer='mplayer -ass -embeddedfonts '
    alias vr='vim -R '
    alias ssh-gssapi='ssh -o GSSAPIAuthentication=yes -o GSSAPIDelegateCredentials=yes -o GSSAPITrustDNS=yes -o GSSAPIKeyExchange=yes'
    alias ssh-nogssapi='ssh -o GSSAPIAuthentication=no -o GSSAPIDelegateCredentials=no -o GSSAPITrustDNS=no -o GSSAPIKeyExchange=no'
    alias ssh-root='ssh -i ~/.ssh/keys.d/root-login-key'
    alias scp-root='scp -i ~/.ssh/keys.d/root-login-key'
    alias vbm='VBoxManage'
    alias send_minimap_data='cp /Users/kherna1/Applications/Minecraft/MultiMC.app/Contents/Resources/instances/Standard/minecraft/mods/rei_minimap/* /Users/kherna1/Google\ Drive/minecraft/minimap-data/jabberwock/'
    alias recv_minimap_data='cp /Users/kherna1/Google\ Drive/minecraft/minimap-data/jabberwock/* /Users/kherna1/Applications/Minecraft/MultiMC.app/Contents/Resources/instances/Standard/minecraft/mods/rei_minimap/'
    alias gam='python ~/Documents/Scripts/GAM/gam.py'

fi
