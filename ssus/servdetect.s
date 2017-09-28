package servdetect
# (C) 1998-2006 Serf <xport525@windstream.net>
# Idea from ircII-rune / splitfire
alias servadd @ type.servers #= [$* ]

servadd u2.* Undernet 6 @
servadd bahamut* "Dalnet Bahamut" 6 @
servadd 2.8*TS4* "EFNet TS4" 4 @
servadd 2.8*hybrid-5* "EFNet Hybrid5" 4 0 
servadd 2.8*hybrid-6* "EFNet Hybrid6" 4 @
servadd 2.8*comstud* "EFNet comstud" 4 0
servadd 5.5.* "Microsoft Exchange" 25 0
servadd *Ptlink6.* "Hybrid6/PTLINK" 4 @
servadd *Hybrid6* "EFNet Hybrid6" 4 @
servadd Unreal3* UnrealIRCD 6 @
servadd *hyperion* 4 @

alias setservdata {
    fe ($type.servers) string type maxmodes atnotice {
        if (match($string $0)) { 
            @ type[$lastserver()]     = type
            @ maxmode[$lastserver()]  = maxmodes
            @ atnotice[$lastserver()] = [${atnotice == [@]? [@] : []}]
        }
        if ( !type[$lastserver()] ) {
            @ type[$lastserver()]     = [Generic]
            @ maxmode[$lastserver()]  = 3
            @ maxmode[$lastserver()]  = []
        }
    }
}
