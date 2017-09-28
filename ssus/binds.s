package binds
# ssus keybinds.
# (C) 1998-2006 Serf <xport525@windstream.net>

bind ^B self_insert
bind ^C self_insert
bind ^V self_insert
bind ^X switch_channels
bind ^F parse_command wholeft
bind ^D parse_command {
    if ( tmp.query && Q ) { 
            @ tmp.qq = [$Q]
            @ tmp.query = []
            //^query
        } { 
            @ tmp.query = tmp.qq
            //^query $tmp.qq
        }
}

# ^W bindings from lice 4.1.9 (updated 01-24-05)


BIND ^Wa PARSE_COMMAND WINDOW SWAP LAST
BIND ^W^w PARSE_COMMAND WINDOW SWAP LAST
BIND ^Wc PARSE_COMMAND { win_new }
BIND ^W^c PARSE_COMMAND { win_new }
BIND ^Wf CLEAR_SCREEN
BIND ^Wg PARSE_COMMAND { WINDOW GROW 1 }
BIND ^Wh PARSE_COMMAND { WINDOW HIDE }

BIND ^Wj PARSE_COMMAND {
  INPUT "Join channel [key, if needed]: " IF (ischannel($0)) {
    IF ( strlen($1) ) {JOIN $*}
    win_new CHANNEL $0 BIND $0 NAME $0
    ^ON -WINDOW_KILL "$0" {
      IF (onchannel($N $0)) {PART $0}
      ^ON -WINDOW_KILL -"$0"
    }
  }
}

BIND ^Wk PARSE_COMMAND {
    if ( winchan() ) {
        PART $winchan()
    }
    WINDOW KILLSWAP
}

bind ^Wl REFRESH_SCREEN
BIND ^Wn NEXT_WINDOW
BIND ^Wp PREVIOUS_WINDOW
BIND ^Wq PARSE_COMMAND INPUT "Nick to query, =<nick> for CHAT: " IF (@) {win_new ADD $0 QUERY $0 DOUBLE OFF LEVEL NONE }
BIND ^Wr PARSE_COMMAND WINDOW SHRINK 1
BIND ^Ws PARSE_COMMAND INPUT "Server[:port[:password[:nick]]] [channel]: " IF (@) { win_new SERVER $0 ${ischannel($1) ? [CHANNEL $1 BIND $1 NAME $1] : []} }
BIND ^Ww PARSE_COMMAND WINDOW LIST
BIND ^Wy PARSE_COMMAND INPUT "Set window's name to: " IF (@) {^WINDOW NAME $0}
BIND ^Wz STOP_IRC
BIND ^W! PARSE_COMMAND INPUT "Shell command (ENTER to cancel): " IF (@) {EXEC $*}
BIND ^W' PARSE_COMMAND INPUT "Switch to window [curr = $winnum()]: " IF (isdigit($0)) { ^WINDOW SWAP $0 }
BIND ^Wm PARSE_COMMAND WINDOW HOLD_MODE TOGGLE
bind ^[^` PARSE_COMMAND ^window next
bind ^[1 PARSE_COMMAND ^window swap 1
bind ^[2 PARSE_COMMAND ^window swap 2
bind ^[3 PARSE_COMMAND ^window swap 3
bind ^[4 PARSE_COMMAND ^window swap 4
bind ^[5 PARSE_COMMAND ^window swap 5
bind ^[6 PARSE_COMMAND ^window swap 6
bind ^[7 PARSE_COMMAND ^window swap 7
bind ^[8 PARSE_COMMAND ^window swap 8
bind ^[9 PARSE_COMMAND ^window swap 9
bind ^[0 PARSE_COMMAND ^window swap 10
bind ^W1 PARSE_COMMAND ^window swap 1
bind ^W2 PARSE_COMMAND ^window swap 2
bind ^W3 PARSE_COMMAND ^window swap 3
bind ^W4 PARSE_COMMAND ^window swap 4
bind ^W5 PARSE_COMMAND ^window swap 5
bind ^W6 PARSE_COMMAND ^window swap 6
bind ^W7 PARSE_COMMAND ^window swap 7
bind ^W8 PARSE_COMMAND ^window swap 8
bind ^W9 PARSE_COMMAND ^window swap 9

BIND ^[d parse_command rget
BIND ^[r parse_command nget
BIND ^[c parse_command nchat
BIND ^[s parse_command rchat
