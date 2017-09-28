package tig
# /tig like BX, easy to remove ignore list thingy. 
# (C) 1998-2006 Serf <xport525@windstream.net>


alias tig {
    ^local ig,i,igmask,igtype
    purge ig
    fe ($igmask(*)) igmask {
        fe ($igtype($igmask)) igtype {
            @ i++
            @ ig[$i] = [$igmask $igtype]
        }
    }
    foreach ig xx {
        echo    14[9$[-2]xx14] $lformat(25 $word(0 $ig[$xx]):)  $word(1 $ig[$xx])
    }
    input_char "Which ignore to delete: " {
        if (isnumber($0)) {
            if (ig[$0]) {
                ignore $word(0 $ig[$0]) none
            } {
                xecho -b -c No matching ignore
            }
        } {
            xecho -b -c Please enter a valid number
        }
    }
}
