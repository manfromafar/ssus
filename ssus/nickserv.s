package nickserv
# auto-identify for nickserv.
# (C) 1998-2006 Serf <xport525@windstream.net>

alias nconf {
    echo Your nickserv nicks:password, f.e. nick:blahpass nick2:fehpass 
    input "NickServ>" {
        @ ss.nickserv_nicks = [${@? [$*] : []}]
        echo Nickserv's n!u@h, for example - NickServ!s@NickServ
        ssave -q
    }
    input "NickServ>" {
        @ ss.nickserv_host = [${@? [$*] : []}]
        echo Nickserv's ident string, for example - *This nickname is registered and protected*
        ssave -q
    }
    input "NickServ>" {
        @ ss.nickserv_string = [${@? [$*] : []}]
        ssave -q
    }
}

on #-notice -1 '$before(! $ss.nickserv_host) *' {
    if (match("$ss.nickserv_string" "$1-")) {
        if ([$0!$userhost()] == ss.nickserv_host) {
            fe ($ss.nickserv_nicks) ii {
                if (N == word(0 $split(: $ii))) {
                    QUOTE PRIVMSG $0 :IDENTIFY $word(1 $split(: $ii))
                    timer 0.2 echo $G [Auto Identify] Identified to $before(! $ss.nickserv_host)
                }
            }
        }
    }
}
