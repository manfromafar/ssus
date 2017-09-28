package logging
# Per-channel logging (derived from logz.bx by eth0)
# (C) 1998-2006 Serf <xport525@windstream.net>

if ( fexist(~/sslogs) != 1 || fexist(~/sslogs/channels) != 1 || fexist(~/sslogs/messages) != 1 || fexist(~/sslogs/dcc) != 1 || fexist(~/sslogs/ctcps) != 1 ) {
    xecho -b -c Warning, log directory not found. Autocreating it.
    @ mkdir(~/sslogs ~/sslogs/channels ~/sslogs/messages ~/sslogs/dcc ~/sslogs/ctcps)
}

if ( ss.lprivate == [] && ss.lchannel == [] && ss.lctcp == [] ) {
    xecho -b -c No logging configuration. Please type /slog
}

alias slog {
    input "log private events? [${ss.lprivate? [Y/n] : [y/N]}]: " {
        @ ss.lprivate = [${[$0] == [Y]? 1 : 0}]
        xecho -b Logging private messages is now ${ss.lprivate? [on] : [off]}
        ssave -q
    }
    input "log channel events? [${ss.lchannel? [Y/n] : [y/N]}]: " {
        @ ss.lchannel = [${[$0] == [Y]? 1 : 0}]
        xecho -b Logging channels is now ${ss.lchannel? [on] : [off]]}
        ssave -q
    }
    input "log ctcp events? [${ss.lctcp? [Y/n] : [y/N]}]: " {
        @ ss.lctcp = [${[$0] == [Y]? 1 : 0}]
        xecho -b Logging CTCPs is now ${ss.lctcp? [on] : [off]]}
        ssave -q
	}

}

alias l.sw {
    @ :l.sw = open(~/sslogs/$tolower($0) W)
    @ write($l.sw $1-)
    @ close($l.sw)
}

on #-notice 333 "*" if ( ss.lprivate ) { l.sw messages/$0.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] -$0\- $ldc($1-) }
on #-send_notice 333 "*" if ( ischannel($0) ) {
    if ( ss.lchannel ) {
        l.sw channels/$0.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] -> -$0\- $1-
    }
} {
    if ( ss.lprivate ) {
        l.sw messages/$0.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] -> -$0\- $1-
    }
}
on #-public_notice 333 "*" if ( lpublic ) { l.sw channels/$1.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] -$0:$1\- $2- }
on #-msg 333 "*" if ( ss.lprivate ) { l.sw messages/$0.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] *$0* $ldc($1-) }
on #-send_msg 333 "*" if ( ss.lprivate ) { l.sw messages/$0.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] -> *$0* $ldc($1-) }
on #-dcc_chat 333 "*" if ( ss.lprivate ) { l.sw dcc/=$0.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] =$0= $ldc($1-) }
on #-send_dcc_Chat 333 "*" if ( ss.lprivate ) { l.sw dcc/=$0.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] -> =$0\ $ldc($1-) }
on #-action 333 "*" if ( ss.lchannel ) {
    if ( ischannel($1) ) { 
        l.sw channels/$1.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] * $0 $ldc($2-) 
    } { 
        l.sw messages/$0.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] <= * $0 $ldc($2-)
    }
}
on #-public 333 "*" if ( ss.lchannel ) { l.sw channels/$1.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] <$0> $ldc($2-) }
on #-public_other 333 "*" if ( ss.lchannel ) { l.sw channels/$1.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] <$0> $ldc($2-) }
on #-send_public 333 "*" if ( ss.lchannel ) { l.sw channels/$0.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] > <$N> $ldc($1-) }
on #-channel_signoff 333 "*" if ( ss.lchannel ) { l.sw channels/$0.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] *<* Signoff: $1 \($2-\) }
on #-send_action 333 "*" if ( ischannel($0) ) {
    if ( ss.lchannel ) {
        l.sw channels/$0.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] * $N $ldc($1-)
    }
} {
    if ( ss.lprivate ) {
        l.sw messages/$0.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] -> $0 * $N $ldc($1-)
    }
}
on #-leave 333 "*" if ( ss.lchannel ) { l.sw channels/$1.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] *<* $0 \($2-\) has left $1 }
on #-join 333 "*" if ( ss.lchannel ) { l.sw channels/$1.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] *>* $0 \($2-\) has joined $1 }
on #-topic 333 "*" if ( ss.lchannel ) { l.sw channels/$1.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] [T] $0 has changed the topic on channel $1 to $ldc($2-) }
on #-channel_nick 333 "*" if ( ss.lchannel ) { l.sw channels/$0.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] [S] Signoff: $1 $0 \($ldc($2-)\) }
on #-mode 333 "*" if ( ischannel($1) ) {
    if ( ss.lchannel ) { l.sw channels/$1.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] [M] mode: $1 $2- by $0 }
}
on #-channel_kick 333 "*" if ( ss.lchannel ) { l.sw channels/$2.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] [K] $0 has been kicked off $2 by $1 \($3-) }
on #-ctcp 333 "*" if ( ss.lctcp ) { l.sw ctcps/ctcps.$strftime(%m_%d_%y).log [ $strftime(%x - %X) ] $0 \($userhost()\): $2- }

