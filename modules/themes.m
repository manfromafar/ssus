package themes
# Theme stuff.
# (C) 1998-2006 Serf <xport525@windstream.net>

alias listtheme {
    @ :thm.themenum = 0
    xecho -b -c Type /theme <number> to switch
    fe ($glob($scriptdir/themes/*.thm)) xx {
        @ thm.themenum++
        xecho -b -c \($thm.themenum) $lformat(14 $basename($xx)) : $afterw(THEMEDESC $desctheme($xx))
        @ thm[$thm.themenum] = [$xx]
    }
    purge thm
}

alias settheme {
    if ( thm[$0] ) {
        ^unload theme-${theme.name}
        ^load $thm[$0]
        xtype ^L
        @ ss.theme = thm[$0]
        ssave -q
        purge thm
    }
}

alias theme {
    if ( [$0] ) {
        @ :thm.themenum = 0
        fe ($glob($scriptdir/themes/*.thm)) xx {
            @ thm.themenum++
            @ thm[$thm.themenum] = xx
        }
        settheme $*
    } {
        listtheme
    }
}
