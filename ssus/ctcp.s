package ctcp
# CTCP handling
# (C) 1998-2006 Serf <xport525@windstream.net>

on ^ctcp "*" secho ${[$3]? theme.ctcprequestarg($*) : theme.ctcprequest($*)}

alias expire if ( ss.suspend_replies && !ss.cloak ) {timer $ss.suspend_reply_for @ ss.suspend_replies = 0}

alias _hanctcp if ( @ ) {
    if ( !ss.suspend_replies ) {
        secho $theme.ctcpreq($*)
    } {
        if ( !ss.quiet_ctcp ) {
            secho $theme.ctcpreqnorep($*)
        }
    }
}

alias _hancheck if ( @ ) {
    if ( !ss.suspend_replies && !ss.cloak ) {
        @ ss.suspend_replies = 1
        expire
        reply $*
    }
}

on ^set "clienti* *" {
    if ( [$1] ) { @ ss.clientinfo = [$1-] }
    xecho -b -c ${[$1]? [Value of CLIENTINFO set to $1-] : [Current value of CLIENTINFO is $ss.clientinfo]}
}

on ^set "fi* *" {
    if ( [$1] ) { @ ss.finger = [$1-] }
    xecho -b -c ${[$1]? [Value of FINGER set to $1-] : [Current value of FINGER is $ss.finger]}
}

on ^set "ti* *" {
    if ( [$1] ) { @ ss.time = [$1-] }
    xecho -b -c ${[$1]? [Value of TIMEREPLY set to $1-] : [Current value of TIMEREPLY is $ss.time]}
}

on ^set "useri* *" {
    if ( [$1] ) { @ ss.userinfo = [$1-] }
    xecho -b -c ${[$1]? [Value of USERINFO set to $1-] : [Current value of USERINFO is $ss.userinfo]}
}

on ^set "vers* *" {
    if ( [$1] != [<unset>]) { @ ss.version = [$1-] } { @ ss.version = [] }
    xecho -b -c ${[$1]? [Value of VERSION_REPLY set to $1-] : [Current value of VERSION is $ss.version]}
}

on ^raw_irc "*!* PRIVMSG % :*CLIENTINFO**" {
    _hanctcp $3 $0 $2
    if (ss.clientinfo) {_hancheck $before(! $0) $strip(: $3) $ss.clientinfo}
}
on ^raw_irc "*!* PRIVMSG % :*FINGER**" {
    _hanctcp $3 $0 $2
    _hancheck $before(! $0) $strip(: $3) ${ss.finger? ss.finger : [.]}
}
on ^raw_irc "*!* PRIVMSG % :*USERINFO**" {
    _hanctcp $3 $0 $2
    _hancheck $before(! $0) $strip(: $3) ${ss.userinfo? ss.userinfo : [EPIC4 -- Get your laundry brighter, not just whiter!]}
}
on ^raw_irc "*!* PRIVMSG % :*TIME**" {
    _hanctcp $3 $0 $2
    _hancheck $before(! $0) $strip(: $3) ${ss.time? ss.time : [$strftime(%c)]}
}
on ^raw_irc "*!* PRIVMSG % :*ERRMSG**" #
on ^raw_irc "*!* PRIVMSG % :*ECHO**" #
on ^raw_irc "*!* PRIVMSG % :*PING%**" {
    _hanctcp $3 $0 $2
    _hancheck $before(! $0) $strip(: $3) $strip( $4-)
}

on ^raw_irc "*!* PRIVMSG % :*VERSION**" {
    _hanctcp $3 $0 $2
    _hancheck $before(! $0) $strip(: $3) ${ss.version? ss.version : [ircII $J \($uname(%s %r)) with $sar(g/././$ssus())]}
}
