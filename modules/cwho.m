# From the original lice.cwho, packed in LiCe v4.1.9 ->
# #   IRC Script Program. For use with ircii-EPIC4 clients.
# #   Copyright (C) 2000 SrfRoG (cag@codehack.com)
# # ---------------------------------------------------------------------------
# # All code by SrfRoG, unless specified. Visit http://lice.codehack.com
# # ---------------------------------------------------------------------------
# Modifications by serf for ssus
package cwho
alias cwho {
    @ :cwho.dmask = [*!*]
    @ :cwho.opts =
    @ :cwho.flag = 0
    @ :cwho.count = 0
    while (cwho.opts = getopt(opt arg alov $*)) {
        switch ($cwho.opts) {
            (a) { @ :cwho.flag = 1 }
            (l) { @ :cwho.flag ^= 2 }
            (o) { @ :cwho.flag ^= 4 }
            (v) { @ :cwho.flag ^= 8 }
            (!) { xecho_current Invalid option. }
        }
    }
    if (arg) {
        @ :cwho.dmask = uhc($word(0 $arg))
        @ arg =
    }
    unless (cwho.flag) { @ :cwho.flag = 1 }
    @ :cwho.hash = hash_32bit($C)
    fe ($channel()) cwho.lusers {
        @ :cwho.nick = rest(2 $cwho.lusers)
        @ :cwho.type =
        @ :cwho.mode = left(1 $cwho.lusers)
        if ( cwho.mode == [@] ) {
            if ( cwho.flag & 1 || cwho.flag & 4 ) {
                @ :cwho.host = userhost($cwho.nick)
                if (pattern($cwho.dmask ${cwho.nick}!${cwho.host})) {
                    @ cwho.count++
                    xecho_current [$lformat(3 $cwho.count)] 10@$lformat(15 $cwho.nick) $cwho.host
                }
            }
            continue
        }
        @ :cwho.mode = mid(1 1 $cwho.lusers)
        if (cwho.mode == [+]) {
            if (cwho.flag & 1 || cwho.flag & 8) {
                @ :cwho.host = userhost($cwho.nick)
                if (pattern($cwho.dmask ${cwho.nick}!${cwho.host})) {
                    @ cwho.count++
                    xecho_current [$lformat(3 $cwho.count)] 13+$lformat(15 $cwho.nick) $cwho.host
                }
            }
            continue
        }
        if (cwho.flag & 1 || cwho.flag & 2) {
            @ :cwho.host = userhost($cwho.nick)
            if (pattern($cwho.dmask ${cwho.nick}!${cwho.host})) {
                @ cwho.count++
                xecho_current [$lformat(3 $cwho.count)]  $lformat(15 $cwho.nick) $cwho.host
            }
        }
    }
     UNLESS (cwho.count) {xecho_current No matches for $cwho.dmask}
}
