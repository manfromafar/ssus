package alias
# ssus aliases
# (C) 1998-2006 Serf <xport525@windstream.net>


# /wall <message>, sends a message to chanops in the current channel.
alias wall if ( @ && P ) {
    if ( atnotice[$winserv()] ) {
        notice @$C [WallOp:$C\($#chops($C)\)] $*
    } {
        fe ($chops($C)) wall.1 wall.2 wall.3 wall.4 wall.5 wall.6 {
            notice $wall.1,$wall.2,$wall.3,$wall.4,$wall.5,$wall.6 [WallOp:$C\($#chops($C)\)] $*
        }
    }
}

# /resetmode to clear modes in current channel.
alias resetmode { mode $C -$chanmode($C) }

# From LiCe 4.1.9
alias c {
  switch ($0) {
    (-c) { //MODE $C -$chanmode($C) }
    (-k) { //MODE $C -k $key($C) }
    (-1) { //MODE $C +inst-lmpmk $key($C) }
    (-2) { //MODE $C +nst-ilmkpm $key($C) }
    (-3) { //MODE $C +nt-ilmkspm $key($C) }
    () (*) {//MODE $C $*}
  }
}

alias themedesc # nothing

# Re-alias /query so I can toggle between channel/person with a bind.
alias query {
    if ( [$0] ) {
        @ tmp.query = [$0]
        //^query $0
    } {
        @ tmp.query = []
        //^query
    }
}

# /reply <nick> <command> <reply>
alias reply if ( @ ) {
    quote NOTICE $0 :$1-
}

alias reconnect if (@) {//reconnect $*} {//reconnect $ss.qm}
# Reject DCC chat.
alias rchat {
    ^dcc close chat $tmp.chat
    @ tmp.chat = []
}

# Accept DCC chat.
alias nchat {
    ^dcc chat $tmp.chat
    @ tmp.chat = []
}

# Reject DCC send.
alias nget {
    ^dcc close send $tmp.snick
    @ tmp.snick = []
}

# Accept a DCC send.
alias rget {
    ^dcc get $tmp.snick
    @ tmp.snick = []
}

# Accept a DCC send
alias fget rget

alias quit signoff
alias exit signoff
alias bye signoff

alias signoff {
    xecho -b -c Signoff: $N \(${@? [$*] : ss.qm})
    //quit ${@? [$*] : ss.qm}
}

alias save {
    xecho -b -c To save your ssus settings, use /ssave, if you really want to use /save (RTFM), use $//save
}

alias ssave {
    if ( [$0] != [-q] ) {
        xecho -b -c Saving your settings.
    }
    if ( fexist(~/.ss.save) == 1 ) {
        @ unlink(~/.ss.save)
    }
    @ :fd = open(~/.ss.save W)
    @ write($fd # Saved ssus settings)
    foreach ss ii {
        @ write($fd @ ss.$ii = [$ss[$ii]])
    }
    @ close($fd)
}

alias version {
    ^echo : 12Client   : ircII $J \(Commit Id: $info(i)\) \(Internal Version: $V\)
    ^quote VERSION
}

# /sv [nick|channel] - say version to current channel or if an arg is specified, user.
alias sv //msg ${@? [$0] : C} epic\(r$strip(- $msar(g,pre,,.,.,$after(1 4 $J)))) \($uname(%s %r)) \(th/$theme.name) with $sar(g/././$ssus()) $etc_v2

# /mme <text> - Send an action to all channels you're on.
alias mme if ( @ ) {
    if ( !match(*hybrid6* $type[$winserv()]) ) {
        describe $tr(/ /,/$mychannels()) $*
    } {
        fe ($mychannels()) mme {
            quote PRIVMSG $mme :ACTION $*
        }
        xecho -b -c * -> $tr(/ /,/$mychannels()): $N $*
    }
}

# Purges an array.
alias purge if ( @ ) {
    foreach $0 ii { purge $0.$ii }
    @ ii = $0 = []
}

alias hold { //set hold_mode toggle }
alias ig (...) { //ignore }
alias ver ctcp ${@? [$0] : C} VERSION
alias ww (...) { whowas $* }
alias wii (...) { idle $* }
alias idle if (@) {whois $0 $0}
alias wi (...) { whois }
alias j (...) { join $* }
alias l (...) { part $* }
alias lj (...) { cycle $* }
alias cl { cwho }
alias m msg

alias checkmaxmodes {
    if ( !maxmode[$winserv()] ) {
        @ maxmode[$winserv()] = 3
        docheck
    }
}

alias t {
    //TOPIC $*
}

# /cycle [message] - cycle (part/joins) current channel.  If you're on a server that allows for part messages, the [message] part will be displayed as you part the channel, otherwise it will have no effect.
alias cycle {
    if (match(*i* $word(0 $chanmode($C))))
    {
        xecho -b Can't cycle an invite-only channel.
    } {
        if (match(*l* $word(0 $chanmode($C)))) {
            @ :limit = rightw(1 $chanmode($C))
            @ :users = numonchannel($C) - 1
            if (limit <= users) {
                xecho -b Can't cycle channel, limit too low.
            } 
        } {
                @ :current = C
                leave $C ${[$0]? [$*] : []}
                wait -cmd join $current $key($current)
        }
    }
}
# From LiCe4
alias win_new {
    WINDOW NEW ${@? strlen($1) ? [$*] : [NAME $0] : []} HIDE
    WINDOW SWAP LAST
}

alias utype if ( @ ) {
    xtype ^U
    xtype -l $*
}


alias fix.sc {@ function_return = ischanop($0 $temp.scchan) ? [10@$] : (ischanvoice($0 $temp.scchan) == 1 ? [13+] : [ ])}

# /timestamp [on|off] - toggle timestamping.
alias timestamp {
    switch ( $0 ) {
        (1) (on) {
            ^set output_rewrite \$tsformat() \$1-
            @ ss.timestamp = 1
            echo $BANNER Timestamping is on
            ssave -q
        }
        (0) (off) {
            ^set -output_rewrite
            @ ss.timestamp = 0
            echo $BANNER Timestamping is off
            ssave -q
        }
        (*) {
            xecho -b /timestamp <on|off>
        }
    }
}

alias theme.init (msg) {
    fe ($winrefs()) xx { ^window $xx double ${theme.window_double? [ON] : [OFF]} }
    ^set reverse_status ${theme.reverse_status? [OFF] : [ON]}
    if (msg) {
        xecho -c $msg
    }
}

alias docheck {
    stack push on 351
    ^on ^351 "$S *" {
        setservdata $1
        stack pop on 351
        ^on ^351 -"$S *"
    }
    wait for QUOTE VERSION
}

alias tt {
    stack push on 332
    ^on ^332 "* $C *" {
        xtype ^U
        xtype -l /t $2-
        stack pop on 332
        ^on ^332 -"* $C *"
    }
    wait for TOPIC $C
}

alias tta if ( @ ) {
    @ topic = [$*]
    stack push on 332
    ^on ^332 "* $C *" {
        TOPIC $C $2- || $topic
        ^on ^332 -"* $C *"
        @ topic = []
    }
    wait for TOPIC $C
}
alias names (chan default "$C", void)
{
    //names $chan
}
alias sc { if (C) {scan} {echo $theme.youarenot()} }
alias scan {//names ${@? [$0] : C}}
alias rel {
    ^dump
    @ quiet = 1
    ^load ~/.ss/ss.scr
    @ quiet = []
}

alias grel {
    ^dump
    @ quiet = 1
    ^load ~/.ircrc
    @ quiet = []
}

alias wj {
    if ( @ ) {
        win_new CHANNEL $0 BIND $0 NAME $0
        ^ON -WINDOW_KILL "$0" {
            IF (onchannel($N $0)) {//PART $0}
            ^ON -WINDOW_KILL -"$0"
        }
    }
}

alias cloak {
    if ( !ss.cloak ) {
        @ ss.suspend_replies = ss.cloak = 1
        xecho -b -c CTCP Cloaking Now On
    } {
        @ ss.suspend_replies = ss.cloak = 0
        xecho -b -c CTCP Cloaking Now Off
    }
}


alias joinhandle { echo ${[$1] == C? theme.joina($*) : theme.joinu($*)} }

alias msglog.write {
    if ( isaway() ) {
        if (aliasctl(alias get theme.onmsglog)) { theme.onmsglog }
        @ away_cnt++
        @ away_msg[$away_cnt] = [\($strftime(%X)) $*]
    }
}

alias umode (opts default "") {
    mode $N $opts
}

alias xecho_current { xecho -b -c }

alias secho { if (winserv($winnum()) == lastserver()) {xecho -c $*} {echo $*} }

alias uptime { xecho -b -c $J uptime: $up() }
