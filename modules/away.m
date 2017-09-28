package away
# away/logging system
# (C) 1998-2006 Serf <xport525@windstream.net>

alias away {
    if ( @ ) {
        //away -a $*
        @ diedtime[$winserv()] = time()
        if (ss.public_away) {if (C) {describe $C $theme.away($*)}}
    } {
        back
    }
}

alias back {
    if ( isaway() ) {
        xecho -b -c ${away_msg.1? [10Type 11/play 10to see saved messages.] : [10No messages recorded while you were away.]}
        //away -a
        if (ss.public_away) {if (C) {describe $C ${[$0]? theme.backa($*) : theme.backn($*)}}}
        xecho -b -c You were gone for $tdiff2(${time() - diedtime[$winserv()]})
        @ diedtime[$winserv()] = []
    } {
        xecho -b -c You are not /away
    }
}

alias play {
    if ( away_cnt != 0 ) {
        for (@ :i = 1, i <= away_cnt, @ i++) {
            xecho -nolog .: MsgLog :. \#$[-3]i]: $away_msg[$i]
            @  :input = [$"Press 'q' to abort, any other key to continue "]
            if ( input == [q] ) {
                break
            }
            if ( i == away_cnt ) {
                purge away_msg
                @ away_cnt = 0
            }
        }
    } { 
        xecho -b -c No messages were recorded
    }
}
