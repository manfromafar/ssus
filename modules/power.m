package power
# /power, op statistics
# (C) 1998-2006 Serf <xport525@windstream.net>

alias _power {
    ^local chanz,foo,nchanz
    @ nchanz = 0
    @ chanz = 0
    @ foo = 0
    fe ($mychannels()) x {
        @ nchanz++
        if (ischanop($N $x) == 1) {
            @ chanz++
            @ foo = foo + numwords($remw($N $chanusers($x)))
        }
    }
   return $chanz $nchanz $foo
}

alias power { xecho -b You are opped in $word(0 $_power()) out of $word(1 $_power()) channels, and can regulate $word(2 $_power()) users }

alias spower { say I am opped in $word(0 $_power()) out of $word(1 $_power()) channels, and I can pwn $word(2 $_power()) users }
