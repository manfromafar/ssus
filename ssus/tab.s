package tab
# Tabkey stuff.
# (C) 1998-2006 Serf <xport525@windstream.net>
# Nick completion from splitfire, modified tabkey /msg thing from the 'tc' script in epic.
# They all work pretty good together, so I see no reason in not using them.

# Shamefully ripped from LiCe

alias _proc.tab_add (serv,nick) {
  IF (serv < 0) {RETURN}
  @ :text = remw($nick $tabnick[$serv])
  @ tabnick[$serv] = nick ## [ ] ## leftw(7 $text)
}

alias msg_completion (cmd) {
  @ :serv = winserv()
  IF (serv < 0) {RETURN}
  @ :nick = shift(tabnick[$serv])
  PARSEKEY ERASE_LINE
  TYPE $cmd $^\^^nick 
  PUSH tabnick[$serv] $nick
}

on #-msg -12782 * _proc.tab_add $lastserver() $0
on #-send_msg -12782 * _proc.tab_add $winserv() $0
on #-dcc_chat -12782 * _proc.tab_add $winserv() =$0
on #-send_dcc_chat -12782 * _proc.tab_add $winserv() =$0

alias chanusers2 return $chanusers($C) $mychannels()
alias wordsfrom return $(${[$0]+1}-${[$1]+1})
alias cutlast return $left(${strlen($*)-1} $*)

# This is the same as wordsfrom(), but accepts quoted words.
alias hasquotedwords (data) {
  fe ($data) xx {
    if (index(" " $xx) != -1) {
      return 1
    }
  }
  @ function_return = 0
}

alias wordsfrom2 (start, finish, data) {
    @ :count = 1
    @ :temp = []
    @ :data = sar(g/\" /\\\"\" /$sar(g/ \"/ \"\\\"/$data))
    fe ($data) xx {
        if ((count >= start) && (count <= finish)) {
            @ temp #= [$xx ]
        }
    @ count++
    }
    @ function_return = cutlast($temp)
}

alias eval_nick_comp @ function_return = [$0$ss.completion_char$1-]

alias complete_last_word {
    if (#L > 0) {
        @ comp = bash_complete($0 $word(${#L-1} $L))
        if (comp != [$^\word(${#L-1} $L)]) { ^utype $sar(g/\\\"/\"/$wordsfrom2(1 ${#L-1} $L)) $comp }
    }
}

alias evalfunc return $*

alias bash_complete (type, data) {
    switch ($type) {
        (file) {
            @ :complete = uniq($^"glob($data\*))
        }
        (nick) {
            if (left(1 $data) == [\$]) {
                @ :complete = sar(g/ / \$/\$$tolower($aliasctl(assign pmatch $mid(1 999 $data)\*)))
            } {
                @ :complete = uniq($^"pattern($^\data\* $chanusers2()))
            }
        }
        (set) {
            @ :complete = getsets($^"data\*)
            if (complete == data) { return $complete $evalfunc(\$$complete) }
        }
        (assign) {
            @ :complete = tolower($aliasctl(assign pmatch $data\*))
            if (complete == data) { return $complete $evalfunc(\$$complete) }
        }
    }
    @ :complete = sar(g/\\\"/\"/$complete)
    @ :complete_has_quoted_words = 0
    if (hasquotedwords($complete)) {
        @ complete = quoteallwords($complete)
        @ complete_has_quoted_words = 1
    }
    if (!complete) { @ function_return = data } {
        if (#complete == 1) { @ function_return = [$complete$chr(32)] } {
            @ :prefix = prefix($complete)
            if (@prefix == [$@data]) {
                @ prefix = data
            }
            @ function_return = prefix
            if (complete_has_quoted_words) { xecho -b -c Possible completions: "$complete" } { xecho_current Possible completions: $complete }
        }
    }
}

bind ^I parse_command {
    @ :stop = 0
    if (!L) { 
        msg_completion /M
        @ :stop = 1
    } {
        if ( match(/M $word(0 $L)) ) {
            if ( numwords($L) < 3 ) {
                msg_completion /M
                @ :stop = 1
            }
        }
    }
    if (!stop) {
        if ([$[1]L] != [/]) {
            if ( [$#L] == 1 ) {
                if (match(*$ss.completion_char* $L)) {
                    if (right(1 $L) == ss.completion_char) {
                        ^utype $L$chr(32)
                    } {
                        ^utype $left($rindex($ss.completion_char $L) $L)
                    }
                } {
                    @ :foundnick = bash_complete(nick $L)
                    if (right(1 $foundnick)==[ ]) {
                        ^utype $eval_nick_comp($foundnick)$chr(32)
                    } {
                        ^utype $foundnick
                    }
                    @ foundnick = []
                }
            } { complete_last_word nick }
        }
        if ( [$[1]L] == [/] ) {
            switch ($^"#L) {
                (1) {
                    if (L!=[/]) { parsekey command_completion }
                }
                (2) {
                    switch ($strip(\/ $word(0 $L))) {
                        (load) { complete_last_word file }
                        (cd) { complete_last_word file }
                        (set) { complete_last_word set }
                        (assign) { complete_last_word assign }
                        () { xecho -b -c Nothing to complete! }
                        (*) { complete_last_word nick }
                    }
                }
                (*) {
                    if (([$^"#L]>=4)&&([$wordsfrom(1 2 $L)]==[/dcc send])) {
                        complete_last_word file
                        break
                    }
                        complete_last_word nick
                    }
            }
        }
    }
}
