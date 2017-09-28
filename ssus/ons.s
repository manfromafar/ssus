package ons
# On hooks.
# (C) 1998-2006 Serf <xport525@windstream.net>

on -window_create "*" if ( theme.window_double ) {
    ^window double on
}

on ^exit "*" {
    ssave
    xecho -b -c Uptime: $up()
}

on ^leave "*" echo ${[$1] == C? theme.leavea($*) : theme.leaveu($*)}

on ^send_public "*" echo ${[$0] == C? theme.sendpublica($*) : theme.sendpublicu($*)}

on ^send_action "*" echo ${rmatch($0 #* &* +*)? theme.sendactionchan($*) : theme.sendactionpriv($*)}

on -connect "*" {
    umode $ss.umode
    docheck
}

on ^notify_signon "*" echo $theme.notifysignon($*)
on ^notify_signoff "*" echo $theme.notifysignoff($*)
on ^send_msg "*" {
    msglog.write $theme.sendmsg($*)
    echo $theme.sendmsg($*)
}

on ^msg "*" {
    echo $theme.msg($*)
    msglog.write $theme.msg($*)
}

on ^dcc_chat "*" {
    msglog.write $theme.dccchat($*)
    xecho $strip( $theme.dccchat($*))
}

on ^send_dcc_chat "*" {
    msglog.write $theme.senddccchat($*)
    xecho -c $theme.senddccchat($*)
}

on ^notice "*" {
    echo $theme.notice($*)
    msglog.write $theme.notice($*)
}

on ^send_notice "*" {
    msglog.write $theme.sendnotice($*)
    echo $theme.sendnotice($*)
}

on ^dcc_request "*" {
    xecho -b -c DCC $1 requested from $0!$userhost() \($3:$4)
    switch ($1) {
        (CHAT) { xecho -b -c Type /nchat [or ALT+c] to accept or /rchat [ALT+s] to reject;@ tmp.chat = [$0] }
        (SEND) { xecho -b -c [DCC SEND] Filename: $5 \($6 bytes) Type /rget [or ALT+d] to accept/retrieve or /nget [ALT+c] to reject;@ tmp.snick = [$0 $5]}
    }
}

on ^ctcp_reply "*" secho $theme.ctcpreply($*)

on -004 "*" {
    setservdata $1
    xecho -b Client variables optimized for a $type[$winserv()] server
}

on ^221 "*" xecho -b Your mode is: $1-
on ^251 "*" xecho -b There are $3 users, $6 invisible, on $9 servers
on ^252 "*" xecho -b operator(s) online    : $1
on ^253 "*" xecho -b unknown connection(s) : $1
on ^254 "*" xecho -b channel(s) formed     : $1
on ^255 "*" xecho -b I have $3 clients and $6 server(s) connected
on ^256 "*" xecho -b Admin   : $1-
on ^257 "*" xecho -b Admin   : $1-
on ^258 "*" xecho -b Admin   : $1-
on ^259 "*" xecho -b Admin   : $1-
on ^219 "*" xecho -b $1: $rest(1 $2-)
on ^265 "*" xecho -b Local   $lformat(7 $4) Max   $lformat(7 $6)
on ^266 "*" xecho -b Global  $lformat(7 $4) Max   $lformat(6 $6)
on ^307 "*" xecho -b $N $1-
on ^321 "*" xecho -b Channel       Users  Topic
on ^322 "*" xecho -b $[14]1 $[6]2 $left(${word(0 $geom())-25} $3-)
on ^324 "*" xecho -b $1 MODE: $2-
on ^331 "*" xecho -b $1-

on ^333 "*" xecho -b Topic for $1 set by $2 on $stime($3)
on ^341 "*" xecho -b $1 Successfully invited to $2
on ^342 "*" xecho -b $1 Summoning user to IRC
on ^353 "*" {
    @ temp.scchan = [$2]
    @ temp.scusers #= [$3-]
}
on ^366 "*" {
    xecho -b Users on $1: \($#temp.scusers) \(o:$#chops($1) l:$#chanlusers($1) v:$#chanvoices($1))
    fe ($sort($chanusers($1))) n1 n2 n3 n4 n5 n6 {
        xecho -b $fix.sc($n1)$[9]n1 $fix.sc($n2)$[9]n2 $fix.sc($n3)$[9]n3 $fix.sc($n4)$[9]n4 $fix.sc($n5)$[9]n5 $fix.sc($n6)$[9]n6
    }
    @ temp.scusers = []
}
on ^369 "*" xecho -b $1 $rest(1 $2) $3-
on ^371 "*" xecho -b % $1-
on ^372 "*" xecho -b % $1-
on ^374 "*" xecho -b End of /INFO
on ^376 "*" xecho -b End of MOTD
on ^381 "*" xecho -b You are now an IRC Operator
on ^382 "*" xecho -b Server is rehashing config file: $1 
on ^391 "*" xecho -b ServerTime: $2-
on ^401 "*" xecho -b $1: No such nick or channel
on ^404 "*" xecho -b Cannot send to channel $1
on ^405 "*" xecho -b $1: You have joined too many channels
on ^412 "*" xecho -b $N $1-
on ^421 "*" xecho -b Error: $1 Unknown Command
on ^431 "*" xecho -b $N $rest(1 $2-)
on ^433 "*" xecho -b $1 $rest(1 $2-)
on ^438 "*" xecho -b $1: $rest(1 $2-)
on ^441 "*" xecho -b $1 User isn't on $2
on ^448 "*" xecho -b $1: $2-
on ^465 "*" xecho -b G-line: $*
on ^474 "*" xecho -b $1 Cannot join channel, you are banned
on ^475 "*" xecho -b $1 Channel is +k. Must /join #channel [key]
on ^478 "*" xecho -b $1 Can't ban $2: banlist is full
on ^484 "*" xecho -b $2- \($1-)
on ^482 "*" xecho -b $1 $2-
on ^491 "*" xecho -b $N $1-
on ^329 "*" echo 8$BANNER $1 created on $stime($2)

on ^channel_signoff "*" {
    if (Q == [$1]) { query }
    echo ${[$0] == C? theme.signoffa($*) : theme.signoffu($*)}
}
on ^mode "*" {
    if ( ![$0] == [$1] == N ) {
        echo ${[$1] == C? theme.modea($*) : theme.modeu($*)}
    } {
        echo $theme.modes($*)
    }
}
on #-mode_stripped 867 "% % +b %" {
    if (pattern($3 $N!$userhost($N)) && ischanop($N $1)) {
        xecho -b (ssus) Ban on you detected in $1 \($3)
        mode $1 -b $3
    }
}
on ^mode "*.* #% *" echo ${[$1] == C? theme.servmodea($*) : theme.servmodeu($*)}

on -channel_nick "*" {
    if (Q == [$1]) {
        query $2
    }
}
on ^kick "*" {
    if ( [$0] == N ) {
        echo $theme.kicked($*)
    } elsif ( [$2] == C ) {
        echo $theme.kicka($*)
    } else {
        echo $theme.kicku($*)
    }
}

on ^topic "*" echo ${[$1] == C? theme.topica($*) : theme.topicu($*)}
on ^public "*" { echo $theme.pub($*) }
on ^public '% % *\\[${ss.autoreply}\\]*' {
    echo $theme.pub_ar($*)
    if ( SS.BEEP_ON_AUTOREPLY ) { //BEEP }
    msglog.write $theme.pub_ar($*)
}

on ^public_other "*" { echo $theme.pubother($*) }
on ^public_other '% % *\\[${ss.autoreply}\\]*' {
    echo $theme.pubother_ar($*)
    if ( SS.BEEP_ON_AUTOREPLY ) { //BEEP }
    msglog.write $theme.pubother_ar($*)
}

on ^action "*" {
    switch ( $1 ) {
        ( $C ) { echo $theme.actiona($*) }
        ( $N ) { echo $theme.actionm($*);//BEEP }
        ( * ) {
                if ( winchan($1) == winchan($C) ) {
                    echo $theme.actionu($*)
                } {
                    echo $theme.actiona($*)
                }
        }
    }
}

on ^action '% % *\\[${ss.autoreply}\\]*' {
    switch ( $1 ) {
        ( $C ) { echo $theme.action_ara($*);if ( SS.BEEP_ON_AUTOREPLY ) { //BEEP } }
        ( $N ) { echo $theme.action_arm($*);//BEEP }
        ( * ) {
            if ( winchan($1) == winchan($C) ) {
                echo $theme.action_aru($*)
            } {
                echo $theme.action_ara($*)
            }
        }
    }
    msglog.write $theme.action_ara($*)
}

on ^367 "*" {
    secho $BANNER ${[$4]? [Set by $lformat(10 $3) $lformat(27 on $stime($4))  [$2]] : [$1-]}
}

on ^351 "*" {
        xecho : 12Server   : $1-
        xecho : 12Channels : $mychannels()
        xecho : 12Script   : $ssus()
        ^timer 1 setservdata $1
}
# AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH!!!!!!!!
on ^dcc_list "Start *" xecho -b -c 12Num Type Nick         Status   Duration   Size     Sent   KB/s    File
on ^dcc_list "*" {
    @ dccstat.count++
    xecho -b -c [$dccstat.count] $0 $lformat(12 $2) ${[$3]==[Active]? [Active  ] : [Waiting ]} $lformat(10 $tdiff2(${time() - [$4]})) $lformat(6 ${[$5]? [$pbefore(. ${[$5] / 1024})K] : [-     ]})  $lformat(6 ${[$6]? [${[$6] / 1024}K] : [-     ]}) $lformat(3 $trunc(2 $kps($6 ${time() - [$4]})))K/s ${[$7] != [chat]? [$basename($7)] : [-]}
    if ([$0] == [GET]) {@ dccstat.dbwith = dccstat.dbwith + trunc(2 $kps($6 ${time() - [$4]}))} {@ dccstat.ubwith = dccstat.ubwith + trunc(2 $kps($6 ${time() - [$4]}))}
}

on ^dcc_list "End *" {
    xecho -b -c ${dccstat.count? dccstat.count : 0} DCC${dccstat.count >= 1? [s] :[]} in progress.  ${dccstat.ubwith? dccstat.ubwith : 0}K/s upstream in use.  ${dccstat.dbwith? dccstat.dbwith : 0}K/s downstream in use.
    purge dccstat
}
on ^dcc_offer "*" {
    xecho -b -c Sent DCC $1 request to $0 ${[$2]? [\($2, ${[$3] / 1024}K)] : []}
}

on ^dcc_connect "*" {
    xecho -b -c DCC connection with $0[$2:$3] established
    if ( [$1] == [send] ) { xecho -b Sending $4 \($5b) }
}
on ^exec_exit "* 0 *" # Do nothing.
