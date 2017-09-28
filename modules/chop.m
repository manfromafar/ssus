package chop
# Aliases related to kicking/banning/op stuff.
# (C) 1998-2006 Serf <xport525@windstream.net>

alias deop dop
alias vox voice
alias ban b
alias kb bk
alias op {
    if ( index(* $0) > -1 ) {
        checkmaxmodes
        fmode + o $*
    } {
        checkmaxmodes
        loopmode * + o $*
    }
}

alias dop {
    if ( index(* $0) > -1 ) {
        checkmaxmodes
        fmode - o $*
    } {
        checkmaxmodes
        loopmode * - o $*
    }
}

alias hm {
    if ( index(* $0) > -1 ) {
        checkmaxmodes
        fmode + h $*
    } {
        checkmaxmodes
        loopmode * + h $*
    }
}

alias dehm {
    if ( index(* $0) > -1 ) {
        checkmaxmodes
        fmode - h $*
    } {
        checkmaxmodes
        loopmode * - h $*
    }
}

alias voice {
    if ( index(* $0) > -1 ) {
        fmode + v $*
    } {
        checkmaxmodes
        loopmode * + v $*
    }
}

alias devoice {
    if ( index(* $0) > -1 ) {
        fmode - v $*
    } {
        checkmaxmodes
        loopmode * - v $*
    }
}

alias mop loopmode * + o $remw($N $nochops())
alias mdop loopmode * - o $remw($N $chops())
alias mvox loopmode * + v $remw($N $nochops())
alias mdvox loopmode * - v $remw($N $nochops())
alias mvoice mvox
alias mdevoice mdvox
alias mdvoice mdvox
alias lb mode $C b

alias mass {
    switch ($0) {
        (o) { mop }
        (d) { mdop }
        (v) { mvox }
        (dv) { mdvox }
        (*) { xecho -b -c Options: /mass o|d|v|dv }
    }
}

alias kkick {
    if ( @ && C ) {
        //kick $C $0 ${[$1]? [$1-] : ss.dkm}
    }
}

alias mk {
    @ :lusers = before(: $*)
    @ :reason = after(: $*)
    fe ($lusers) kk {
        kkick $kk ${reason? reason : ss.dkm}
    }
}

alias fk {
    fe ($remw($N $chanusers())) xx {
        @ :fbk #= [$xx!$userhost($xx) ]
    }
    fe ($pattern($0 $fbk)) xx {
         kkick $before(! $xx) ${[$1]? [$1-] : ss.dkm}
    }
}

alias fmode {
	fe ($remw($N $chanusers())) xx {
		@ :mode #= [$xx!$userhost($xx) ]
	}
	fe ($pattern($2 $mode)) xx {
		checkmaxmodes
		loopmode * $0 $1 $before(! $xx)
	}
}
alias fbk {
    mode $C +b $0
    fk $*
    @ lastbanmask[$encode($C)] = [$0]
}
alias tban vlb

alias b {
    if ( @ && P ) {
        userhost $0 -cmd {
            if ( [$4] != [<UNKNOWN>] ) {
                 mode $C -o+b $0 $mask(3 $0!$3@$4)
                 @ lastbanmask[$encode($C)] = [$mask(3 $0!$3@$4)]
            }
        }
    }
}

alias bk k -b $*

alias bd {
    if ( @ && P ) {
        userhost $0 -cmd {
            if ( [$4] != [<UNKNOWN>] ) {
                mode $C -o+b $0 $mask(4 $0!$3@$4)
                @ lastbanmask[$encode($C)] = [$mask(4 $0!$3@$4)]
            }
        }
    }
}

alias bh {
    if ( @ && P ) {
        userhost $0 -cmd {
            if ( [$4] != [<UNKNOWN>] ) {
                mode $C -o+b $0 $mask(2 $0!$3@$4)
                @ lastbanmask[$encode($C)] = [$mask(2 $0!$3@$4)]
            }
        }
    }
}

alias be {
    if ( @ && P && [$1] ) {
        loopmode $C + b $*
        @ lastbanmask[$encode($C)] = [$*]
    }
}

alias k {
    if ( @ ) {
        if ( left(1 $0) == [-] ) { 
            switch ( $0 ) {
                (-b) { b $1;fk $lastbanmask[$encode($C)] $2- }
                (-d) { bd $1;fk $lastbanmask[$encode($C)] $2- }
                (-h) { bh $1;fk $lastbanmask[$encode($C)] $2- }
                (-m) { mk $1- }
                (-bm)
                (-mb) { be $before(: $1-);mk $1-;sweep $C }
                (-e) { 
                        if ( index(* $1) > -1 || index(? $1) > -1) {
                             fbk $1 $2-
                        } {
                             be $1
                             kkick $1 $2-
                        }
                }
            }
        } {
            if ( index(* $0) > -1 ) {
                fk $*
            } {
               kkick $0 $1-
            }
        }
    }
}

alias vlb {
    if ( P ) {
        purge vban
        @ vbannum = vlist = []
        stack push on 367
        stack push on 368
        stack push set show_end_of_msgs
        ^set show_end_of_msgs on
        ^on ^367 "*" {
            @ vlist #= [$2 ]
            @ vbannum++
            @ vban[$vbannum] = [$2]
        }
        ^on ^368 "*" {
            vlb.wooby
        }
        mode $C b
    }
}
alias vlb.wooby {
    foreach vban xx {
        @ :oink++
        xecho -b -c $oink $vban[$xx]
    }
    input "Ban[s] to undo, seperate with comma, or all to unban all: " {
        if ([$0]) {
            if ([$0] == [all]) {
                loopmode $C - b $vlist
            }
            if (index(, $*)) {
                fe ($split(, $*)) xx {
                    @ :moo #= [$vban[$xx] ]
                }
                loopmode $C - b $moo
            } {
                mode $C -b $vban[$xx]
            }
        } {
            purge vban
            @ vbannum = vlist = []
        }
    stack pop on 367
    stack pop on 368
    stack pop set show_end_of_msgs
}
}
# Orig. Kasi (klirc)
alias rban {
    if ( !C ) {
    xecho -c $theme.youarenot()
    } elsif ( P ) {
        stack push on 367
        stack push on 368
        stack push set show_end_of_msgs
        ^set show_end_of_msgs on
        ^on ^367 * {
            @ buh #= [ $2]
        }
        ^on ^368 * {
            _rban.proc $buh
        }
      mode $C b
    } {
        xecho -c $theme.notchanop()
    }
}

alias _rban.proc {
    if ( ![$0] ) {
      xecho -c $theme.nomatchbans()
    }
    loopmode $C - b $*
    wait
    stack pop on 367
    stack pop on 368
    @ buh = unbuh = []
    stack pop set show_end_of_msgs
}

# This code comes from RuneB, slightly modified to look more readable and work with ssus and EPIC.
# Thanks RuneB.
alias pushmode {
    @ :channel = encode($0)

    if ( modes[$channel][currentmode] == maxmode[$winserv()] ) {
        flushmode $0 $channel
    }

    if ( [$1] != modes[$channel][pre] ) {
        @ modes[$channel][modes] #= [$1$2]
        @ modes[$channel][pre] = [$1]
    } {
        @ modes[$channel][modes] #= [$2]
    }

    if ( [$3] ) @ modes[$channel][users] #= [ $3]
    @ modes[$channel][currentmode]++
}

alias flushmode {
    MODE $0 $modes[$1][modes]$modes[$1][users]
    purge modes.$1
}

alias loopmode {
    fe ($3-) x { pushmode $0-2 $x }
    flushmode $0 $encode($0)
}
