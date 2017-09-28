package oper 
# Some stuff stolen from hybrid 6 script / obv
# Orig credit:
# hybrid-6 script (c) 2000 Edward Brocklesby
# includes modified code from da5id's newons.irc

alias oecho {
    if (_ov)
    {
        xecho -w OperView $*
    }
    {
        xecho $*
    }
}

alias fmt.num.ver return $cparse(%K[%w   version%K]%n) server $2 version $chop(1 $1) flags $3 $4

alias fmt.snot.gen {
    if (opermotd == [YES]) {
        return $cparse(%K[%w  opermotd%K]%n) $2-
    } else {
        return $cparse(%K[%w    server%K]%n) $1-
    }
}

alias fmt.wallops.squit return $cparse(%K[%w  servwall%K]%n %r!%R$0%r!%n) $2-
alias fmt.wallops.connect return $cparse(%K[%w  servwall%K]%n %r!%R$0%r!%n) $2-
alias fmt.wallops.wallops return $cparse(%K[%w   wallops%K]%n %r!%R$0%r!%n) $4-
alias fmt.wallops.operwall return $cparse(%K[%w  operwall%K]%n %r!%R$0%r!%n) $4-
alias fmt.wallops.locops return $cparse(%K[%w    locops%K]%n %r!%R$0%r!%n) $4-
alias fmt.wallops.none return $cparse(%K[%w   wallops%K]%n %r!%R$0%r!%n) $2-
alias fmt.snot.netjoin return $cparse(%K[%w   netjoin%K]%n) $2 -> $6
alias fmt.snot.maxcli return $cparse(%K[%wmaxclients%K]%n) $1-
alias fmt.snot.names return $cparse(%K[%w     names%K]%n) $1-
alias fmt.snot.spoof return $cparse(%K[%w     spoof%K]%n) $1 [$3] as $5
alias fmt.snot.qline return $cparse(%K[%w    q-line%K]%n) $2-
alias fmt.snot.xline return $cparse(%K[%w    x-line%K]%n) $2-
alias fmt.snot.con return $cparse(%K[%w   connect%K]%n) $3 $4
alias fmt.snot.ucon return $cparse(%K[%w    unauth%K]%n) $5 $6
alias fmt.snot.disco return $cparse(%K[%w      exit%K]%n) $3 $4 $5-
alias fmt.snot.stats return $cparse(%K[%w     stats%K]%n) $2 requested by $5 $6
from $7
alias fmt.snot.links return $cparse(%K[%w     links%K]%n) $2 requested by $5 $6
from $7
alias fmt.snot.kline return $cparse(%K[%w     kline%K]%n) $1 for $chop(1 $rest(1 $5)) reason: $chop(1 $rest(1 $6-))
alias fmt.snot.dline return $cparse(%K[%w     dline%K]%n) $1 for $5 $6-
alias fmt.snot.active return $cparse(%K[%w    active%K]%n) $1-
alias fmt.snot.addline return $cparse(%K[%w     added%K]%n) $2 $3-
alias fmt.snot.remline return $cparse(%K[%w   removed%K]%n) $2 $3 $4
alias fmt.snot.unkline return $cparse(%K[%w   unkline%K]%n) $1 for $chop(1 $rest(1 $7))
alias fmt.snot.untkline return $cparse(%K[%w   unkline%K]%n) $1 for $chop(1 $rest(1 $8))
alias fmt.snot.whois return $cparse(%K[%w     whois%K]%n) $1-
alias fmt.snot.nick return $cparse(%K[%w      nick%K]%n) $[-9]4 to $[9]6 $7
alias fmt.snot.flood return $cparse(%K[%w   flooder%K]%n) $2-
alias fmt.snot.dflood return $cparse(%K[%w   flooder%K]%n) $1-
alias fmt.snot.count return $cparse(%K[%w    client%K]%n) $1-
alias fmt.snot.tempk return $cparse(%K[%w     tempk%K]%n) $1 for $8 lasting $4 mins reason: $chop(1 $rest(1 $9-))
alias fmt.snot.rehash return $cparse(%K[%w    rehash%K]%n) $1-
alias fmt.snot.htm return $cparse(%K[%w       htm%K]%n) $1-
alias fmt.snot.skill return $cparse(%K[%w  servkill%K]%n) $7 killed $3 $10-
alias fmt.snot.okill return $cparse(%K[%w  operkill%K]%n) $4 $5 $6 $7 $10-
alias fmt.snot.mflood return $cparse(%K[%w  msgflood%K]%n) $[-9]2 $3-
alias fmt.snot.motd return $cparse(%K[%w      motd%K]%n) requested by $4 $5 from $6
alias fmt.snot.oper return $cparse(%K[%w      oper%K]%n) $1-
alias fmt.snot.onot return $cparse(%K[%w    server%K]%n) $1-

alias operview (void)
{
    if (winnam(OperView)) { @ _ov = 1 } { @ _ov = 0 }
    if (_ov == 1) 
    {
        xecho -b -c Operview OFF
        ^window kill_others
        @ _ov = 0
    }
    {
        @ _ov = 1
        xecho -b -c Operview ON
        if (theme.window_double)
        {
            ^set status_format 11operview14>14Ä%>14<11operview
        }
        ^window new fixed on size 7 name OperView level snotes,opnotes,wallops double off
        ^window number 69
        umode +cfiksw
        ^window back
    }
}
alias operwall quote operwall :$*
alias locops quote locops :$*
alias opermsg msg opers@$0 $1-

alias dline (luser, reason)
{
    if (reason)
    {
        quote dline $luser :[$N] $reason
    }
    {
        quote dline $luser :[$N] No reason
    }
}

alias pkline (luser, reason)
{
    if (reason)
    {
        quote kline $luser :[$N] $reason
    }
    {
        quote kline $luser :[$N] No reason
    }
}

alias kline {
        if (isnumber($0))
                {if ([$2-])
                        {quote kline $0 $1 :[$N] $2-}
                        {quote kline $0 $1 :[$N] No reason}}
                {if ([$1-])
                        {quote kline 60 $0 :[$N] $1-}
                        {quote kline 60 $0 :[$N] No reason
                        }
                }
}

alias unkline {
    quote unkline $*
}

alias gline {
        if ([$1-])
                {quote gline $0 :$1-}
                {quote gline $0 :No reason}
}


on ^kill "% % % *" oecho $cparse(%K[%w  operkill%K]%n $2 killed $1 reason: $4-)
on ^kill "% % %.% *" oecho $cparse(%K[%w  servkill%K]%n $2 killed $1)
on ^oper_notice "* unauthori%ed client connection *" oecho $fmt.snot.ucon($*)
on ^oper_notice "* client connecting% *" oecho $fmt.snot.con($*)
on ^oper_notice "* client exit% *" oecho $fmt.snot.disco($*)
on ^oper_notice "* stats *" oecho $fmt.snot.stats($*)
on ^oper_notice "* links *" oecho $fmt.snot.links($*)
on ^oper_notice "* % added k-line *" oecho $fmt.snot.kline($*)
on ^oper_notice "* % added d-line *" oecho $fmt.snot.dline($*)
on ^oper_notice "* %-line active *" oecho $fmt.snot.active($*)
on ^server_notice "% % added %line *" oecho $fmt.snot.addline($*)
on ^server_notice "* %line for * removed" oecho $fmt.snot.remline($*)
on ^oper_notice "* % has removed the K-Line*" oecho $fmt.snot.unkline($*)
on ^oper_notice "* % has removed the temporary K-Line*" oecho $fmt.snot.untkline($*)
on ^oper_notice "* * is doing a %whois *" oecho $fmt.snot.whois($*)
on ^oper_notice "* Nick change: From*" oecho $fmt.snot.nick($*)
on ^oper_notice "* * count off by %" oecho $fmt.snot.count($*)
on ^oper_notice "* % added temp% *" oecho $fmt.snot.tempk($*)
on ^oper_notice "* % is clearing temp *" oecho $fmt.snot.rehash($*)
on ^oper_notice "* % is forcing %reading *" oecho $fmt.snot.rehash($*)
on ^oper_notice "* % is rehashing server *" oecho $fmt.snot.rehash($*)
on ^oper_notice "* got signal sighup% *" oecho $fmt.snot.rehash($*)
on ^oper_notice "* % high-traffic *" oecho $fmt.snot.htm($*)
on ^oper_notice "* resuming standard *" oecho $fmt.snot.htm($*)
on ^oper_notice "* user % % tried to *" oecho $fmt.snot.mflood($*)
on ^oper_notice "* MOTD requested *" oecho $fmt.snot.motd($*)
on ^oper_notice "* Flooder * on * target: *" oecho $fmt.snot.flood($*)
on ^oper_notice "* Possible Drone Flooder*" oecho $fmt.snot.dflood($*)
on ^oper_notice "* % % is now operator %" oecho $fmt.snot.oper($*)
on ^oper_notice "* Quarantined nick *" oecho $fmt.snot.qline($*)
on ^oper_notice "* X-Line Warning *" oecho $fmt.snot.xline($*)
on ^oper_notice "* X-Line Rejecting *" oecho $fmt.snot.xline($*)
on ^oper_notice "* spoofing:* *as*" oecho $fmt.snot.spoof($*)
on ^oper_notice "* POSSIBLE /names abuser *" oecho $fmt.snot.names($*)
on ^oper_notice "* New Max Local Clients: *" oecho $fmt.snot.maxcli($*)
on ^oper_notice "* server % being introduced by *" oecho $fmt.snot.netjoin($*)
on ^oper_notice "*" oecho $fmt.snot.onot($*)
on ^server_notice "*" oecho $fmt.snot.gen($*)

on ^wallop "% *" {
        switch ($2) {
                (Received) {
                        oecho $fmt.wallops.squit($*)
                }
                (Remote) {
                        oecho $fmt.wallops.connect($*)
                }
                (WALLOPS) {
                        oecho $fmt.wallops.wallops($*)
                }
                (OPERWALL) {
                        oecho $fmt.wallops.operwall($*)
                }
                (LOCOPS) {
                        oecho $fmt.wallops.locops($*)
                }
                (*) {
                        oecho $fmt.wallops.none($*)
                }
        }
}

on ^211 * {
    oecho $cparse(%K[%w servstats%K]%n $[-40]1%K%K: %wS%K:%W$[4]{[$4]/1024} %wR%K:%n$[4]{[$6]/1024} %wQ%K:%n$2 %wT%K:%n$[12]tdiff2($7) %wI%K:%n$[3]8 %K[%w$9-%K])
}

on ^249 * {
    oecho $cparse(%K[%w servstats%K]%n $1-)
}

@ opermotd = [NO]

on ^server_notice "*Start of OPER MOTD*" @ opermotd = [YES]
on ^server_notice "*End" @ opermotd = [NO]

