package getnick
# /getnick - tries to get a nick (Original - Fudd/playdough.  Mods - Serf.)
# (C) 1998-2006 Serf <xport525@windstream.net>

alias checkhost {
    wait for userhost $0 -cmd {
        @ user.n = [$0]
        @ user.h = [$4]
        @ user.f = [$3@$4]
        @ function_return = (user.h != [<UNKNOWN>]) ? 1 : 0
    }
}

alias getnick {
    if ( [$0] && [$0] != N ) {
        switch ($0) {
            (-) {xecho -b -c Getnick is now off.;^notify -$s.nick;@ s.gn = s.nick =}
            (*) {
                @ s.nick = [$0]
                @ s.gn = 1
                ^notify +$0
                xecho -b -c Attempting to regain nick $s.nick
                if ( !checkhost($s.nick) ) {_get_nick}
            }
        }
    } {
        if ( [$0] == N ) {
            xecho -b -c error - Your current nick is already $0
        } {
            xecho -b -c Getnick currently ${s.gn? [on $s.nick] : [inactive]}
            xecho -b -c Usage: /getnick <nick> | /getnick -
        }
    }
}

alias _get_nick if ( S ) {
      xecho -b -c Regetting nick $s.nick
      nick $s.nick
      ^notify -$s.nick
      @ s.gn = s.nick =
}
on ^401 '% $s.nick *' if ( s.gn ) { ^timer -ref getnick 30 nick $s.nick }
on #-channel_signoff 20 '% $s.nick *' if ( s.gn ) { _get_nick }
on #-nickname 20 '$s.nick %' if ( s.gn ) { _get_nick }
on #-notify_signoff 20 '$s.nick %' if ( s.gn && [$1] == s.nick ) { _get_nick }
on #-timer 20 * if ( s.gn ) {
    if ( !S ) {@ s.gn = s.nick =;xecho -b -c Getnick has been disabled}
    if ( !checkhost($s.nick) ) { _get_nick }
}

