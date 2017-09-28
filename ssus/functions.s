package functions
# Script functions.
# (C) 1998-2006 Serf <xport525@windstream.net>

alias basename return $mid(${rindex(/ $0) + 1} $strlen($0) $0)

alias pbefore (char,word) {
    if (before($char $word)) {return $before($char $word)} {return $word}
}

alias kps (sent,time) {
    if (sent && time) {
        @ :kps = sent / time
        @ function_return = kps / 1024
    } {
        return 0
    }
}
alias tsformat return ${theme.tsformat? theme.tslook($strftime($theme.tsformat)) : strftime($ss.tsformat)}

alias zee return $strftime(%X)

alias partmsg return ${@? [because \($*)] : []}

alias rot13 return $tr(/abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM/$*)

alias dc return ${ss.strip_crap? [$stripcrap(COLOR,ANSI,BOLD,UNDERLINE $*)] : [$*]}

alias ldc return $stripcrap(COLOR,ANSI,BOLD,UNDERLINE $*)


alias ssus return ssus v$ssus.version

alias desctheme {
    @ :desc = open($0 R)
    @ :tmp.desc = read($desc)
    @ close($desc)
    @ function_return = tmp.desc
}

alias lformat {
    @ :IRCII.word = [$1-]
    if (@IRCII.word < [$0])
        { @ function_return = [$([$0]IRCII.word)] }
        { @ function_return = IRCII.word }
}
alias chanvoices (channel) {
    fe ($channel($channel)) xx {
        if (mid(1 1 $xx) == [+]) {
            @ :voiced #= [$rest(2 $xx) ]
        }
    }
    @ function_return = voiced
}

alias chanlusers (channel) {
    fe ($channel($channel)) xx {
        if (mid(0 2 $xx) == [..]) {
            @ :lusers #= [$rest(2 $xx) ]
        }
    }
    @ function_return = lusers
}

alias up (type) {
    if (type == 1) {
        return $tdiff2(${time() - F})
    } {
        return $tdiff(${time() - F})}
}

alias cm (user, channel default "$C")
{
    if (ss.extended_mode_view)
    {
        if (ischanvoice($user $channel) == 1)
        {
            @ :vo = [+]
        }

        if (ischanop($user $channel))
        {
            return $theme.vcolor$vo$theme.ocolor@
        }
        {
            return $theme.vcolor$vo
        }
    }
}

alias fix.sc {@ function_return = ischanop($0 $temp.scchan) ? [10@$] : (ischanvoice($0 $temp.scchan) == 1 ? [13+] : [ ])}

