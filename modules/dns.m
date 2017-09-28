package dns
# mIRC-like /dns command
# (C) 1998-2006 Serf <xport525@windstream.net>
# /dns nickname, /dns ip, /dns host

alias dns {
    if (match(*.* $0)) {
        @ :converted = convert($0)
        xecho -b -c ${converted? [$0 resolves to $converted] : [$0 does not resolve.]}
    } {
        userhost $0 -cmd {
            unless ([$4] == [<UNKNOWN>]) {
                xecho -b -c Looking up $4
                @ :converted = convert($4)
                xecho -b -c ${converted? [$4 resolves to $converted] : [$4 does not resolve.]}
            } {
                xecho -b -c $0 is not on IRC.
            }
        }
    }
}
