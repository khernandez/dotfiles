# This is a Kenny Custom .Cshrc Chock full of essential
# vitamins and amino acids... all the body needs.

set my_vol_root = /afs/umbc.edu/users/k/h/kherna1

#
# load in system-wide settings
if ( -r /usr/site/etc/system.cshrc ) then
    source /usr/site/etc/system.cshrc

endif

#
# PATH generator
unset path

foreach dir ( /bin /sbin /usr/bin /usr/sbin \
              /usr/afsws/bin /usr/afsws/etc /usr/afs/bin \
              /usr/X11R6/bin /usr/X/bin \
              /usr/sfw/bin /opt/SUNWspro/bin /usr/xpg4/bin /usr/ucb \
              /usr/local/qt-4.5/bin \
              /usr/local/bin \
              /afs/umbc.edu/admin/bin \
              /afs/umbc.edu/admin/afsadmin \
              /afs/umbc.edu/admin/mail/scripts \
              /afs/umbc.edu/admin/oracle/bin \
              $my_vol_root/home/sw/\@sys/bin \
              $my_vol_root/admin/Scripts \
              . )
    if ( -r $dir ) then
        if ( $?path ) then
            set path = ( $path $dir )
        else
            set path = ( $dir )
        endif
    endif
end

# for kerberos stuff on RHEL5 machines
if ( -r /usr/kerberos/bin ) then
    set path = ( /usr/kerberos/bin /usr/kerberos/sbin $path )
endif

# for kerberos stuff on Solaris machines
if ( `uname -s` == "SunOS" ) then
	set path = ( /usr/k5/bin /usr/k5/sbin $path )
endif



if ($?prompt) then
    if ( "$TERM" == "screen" ) then
        setenv TERM ansi

    endif

    # let's set up our prompt
    set __afn_red = "%{\033[31m%}"
    set __afn_blue = "%{\033[34m%}"
    set __afn_magenta = "%{\033[35m%}"
    set __afn_cyan = "%{\033[36m%}"
    set __afn_admin = "%{\033[35m%}"          # no bg, magenta text
    set __afn_afsadmin = "%{\033[31m%}"      # red bg, white text
    set __afn_normal = "%{\033[32m%}"        # no bg, yellow text
    set __a_reset = "%{\033[0m%}"

    if ( "$TERM" == "ansi" ) then
        set __prompt = "%{\033]0;%n@%m<%l>\007%}"

    else
        set __prompt = ""

    endif

    set __prompt = "${__prompt}${__afn_cyan}%Y-%W-%D,%P "
    set __prompt = "${__prompt}%n@%m:%l ${__afn_blue}%C03%L\n"

    # check for kerb/admin or afsadmin and set prompt
    # appropriately
    set kprinc = `klist |& awk '/principal: / {print $3}'`

    if ( $kprinc == 'kherna1/afsadmin@UMBC.EDU' ) then
        set __prompt = "${__prompt}${__afn_afsadmin}AFSADMIN:%h%#${__a_reset}"

    else if ( $kprinc == 'kherna1/admin@UMBC.EDU' ) then
        set __prompt = "${__prompt}${__afn_admin}ADMIN:%h%#${__a_reset}"

    else
        set __prompt = "${__prompt}${__afn_normal}%h%#${__a_reset}"

    endif

    set prompt = "${__prompt} "


    # enable ls colorzlolso1337!!!!!1!
    if ( `uname -s` == "Linux" ) then
        if ( -f ~/.dir_colors ) set COLORS=~/.dir_colors

        if ($?TERM) then
            if ( -f ~/.dir_colors."$TERM" ) set COLORS=~/.dir_colors."$TERM"

        endif
    
        if ( -e "$COLORS" ) then
            eval `dircolors -c $COLORS`
    
            if ( "$LS_COLORS" != '' ) then 
                set color_none=`sed -n '/^COLOR.*none/Ip' < $COLORS`
    
                if ( "$color_none" == '' ) then    
                    alias ll 'ls -lF --color=tty'
                    alias l. 'ls -dF --color=tty .*'
                    alias ls 'ls -F --color=tty'
                    alias la 'ls -aF --color=tty'

                endif

                unset color_none

            endif

        endif

    else
            alias ll 'ls -lF'
            alias l. 'ls -dF .*'
            alias ls 'ls -F'
            alias la 'ls -aF'

    endif


    #
    # set some more options
    #

    setenv CVSROOT /afs/umbc.edu/src/cvs
    setenv EDITOR vi
    
    set currGroup = `id | awk '{ print $2 }' | sed -e 's/gid=\(.*\)/\1/'`
    if ( $currGroup == "50000(kickstart_maintainers)" ) then
        umask 002
    else 
        umask 022
    endif

    set history = 100
    set filec
    # turn off annoying auto logout
    unset autologout
    # list choices when completion fails
    set autolist = "ambiguous"
    set noding
    set ellipsis

    if ( -x /usr/bin/vim ) then
        alias vi /usr/bin/vim

    else if ( -x /usr/local/bin/vim ) then
        alias vi /usr/local/bin/vim

    endif

    # set some git env variables
    #setenv GIT_AUTHOR_EMAIL kendrick.hernandez@umbc.edu
    #setenv GIT_AUTHOR_NAME "Kendrick Hernandez"
    #setenv GIT_COMMITTER_EMAIL kendrick.hernandez@umbc.edu
    #setenv GIT_COMMITTER_NAME "Kendrick Hernandez"

    # some admin aliases
    # for when I log into old core linux systems, blecch
    alias oldafsadmin  '/usr/afsws/bin/pagsh -c '\''KRB5CCNAME=${KRB5CCNAME}.afsadmin; \\
                        export KRB5CCNAME; \\
                        /usr/k5/bin/kinit $USER/afsadmin && tcsh; \\
	                    /usr/k5/bin/kdestroy'\'
    alias oldadmin     'sh -c '\''KRB5CCNAME=${KRB5CCNAME}.admin; \\
                        export KRB5CCNAME; \\
                        /usr/k5/bin/kinit -a $USER/admin && tcsh; \\
                        /usr/k5/bin/kdestroy'\'  

    # for when I log into regular systems 
    alias afsadmin  'pagsh -c '\''KRB5CCNAME=${KRB5CCNAME}.afsadmin; \\
                     export KRB5CCNAME; \\
                     kinit $USER/afsadmin && aklog && tcsh; \\
                     unlog; \\
                     kdestroy'\'
    alias admin     'sh -c '\''KRB5CCNAME=${KRB5CCNAME}.admin; \\
                     export KRB5CCNAME; \\
                     kinit -a $USER/admin && tcsh; \\
                     kdestroy'\'

    # quigon only... sigh.
    alias emtadmin	'/usr/afsws/bin/pagsh -c '\''if [ "`hostname`" = "quigon.umbc.edu" ]; then \\
                     KRB5CCNAME=${KRB5CCNAME}.emtadmin; \\
                     export KRB5CCNAME; \\
                     /usr/afsws/bin/klog ${USER}; \\
                     /usr/k5/bin/kinit ${USER}/afsadmin; \\
                     /usr/k5/bin/krb524init; \\
                     /usr/afsws/bin/emt; \\
                     kdestroy; \\
                     fi'\'

    alias refresh_credentials   'kinit && aklog'
    alias fix_tokens            '/usr/k5/bin/kinit && cd && source .cshrc'
    alias newpag                'pagsh -c "aklog; $SHELL"'
    alias naked                 'egrep -v '\''^[	 ]*#|^$'\'
    alias vr                    'vi -RZ'
    alias datestamp	        'date +%Y%m%d'
    alias timestamp	        'date +%H%M%S'
    alias isostamp	        'date +%Y%m%dT%H%M%SZ'
    alias isoxstamp	        'date +%FT%TZ'
    alias strftime              'perl -nle '\''print "".localtime($_)'\'
    alias test_clamav_sig       'sudo /afs/umbc.edu/admin/cfengine/scripts/cfit; /local/mail/bin/clamscan umbc_spear_phishing.eml'
    alias view_csr              'openssl req -noout -text -nameopt multiline,-lname '
    alias view_x509             'openssl x509 -noout -text -nameopt multiline,-lname '
    alias whosecampusid         'lsearch '\''umbccampusid=\!{#:1}'\'' | egrep "(cn|givenName|sn|umbcprimaryaccountuid):" | sort '
    alias whoseuserid           'lsearch '\''umbcprimaryaccountuid=\!{#:1}'\'' | egrep "(cn|givenName|sn|umbccampusid):"  | sort '
    alias ole_ass_kadmin        '/afs/umbc.edu/i386_linux24/usr/k5/sbin/kadmin'
    alias unreleased_changes_oldcf  'diff -ur /afs/{,.}umbc.edu/admin/cfengine -x ng'
    alias unreleased_changes_delta  'diff -ur /afs/{,.}umbc.edu/admin/cfengine/ng/delta'
    alias unreleased_changes_gamma  'diff -ur /afs/umbc.edu/admin/cfengine/ng/{gamma,delta} -x thirstboot -x cfengine.cron'

endif
