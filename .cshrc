# This is the default standard .cshrc provided to csh users.
# They are expected to edit it to meet their own needs.

# My custom .cshrc
if ( -r ~/.dotfiles/mygoodies.cshrc ) then
    source ~/.dotfiles/mygoodies.cshrc
else

    #
    # set our path
    #
    
    if ( -o /bin/su ) then
        unset path
    	set path = ()
    else
        set path = ( $HOME/bin )
    endif 

    set path=( $path /usr/local/bin /usr/bsd /usr/bin /bin /usr/sbin \
               /sbin /usr/bin/X11 \
               /usr/local/X11 /etc /usr/etc . )

    #
    # load in machine-specific settings
    #

    if ( -r /usr/site/etc/system.cshrc ) then
        source /usr/site/etc/system.cshrc
    endif

    if ($?prompt) then
        if ( -o /bin/su ) then
            set prompt = "`hostname | sed 's/\..*//'`[\!]# "
        else
            set prompt = "`hostname | sed 's/\..*//'`[\!]% "
        endif

        stty intr "^C" kill "^U" echoe
        setenv EDITOR /usr/local/bin/emacs
        umask 0022
        set history = 100
        set filec
        alias h  history
        alias help apropos
        alias rm "rm -i"
        alias ls 'ls -C'
    endif


#alias svn /usr/bin/svn
#alias svnserve /usr/bin/svnserve

endif
