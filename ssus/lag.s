package lag
# Ripped from LiCe 4.1.9
# Credit goes to SrfRoG

ALIAS rlag {
    IF (@) {
        @ temp.last_sping_server = [$0]
        @ temp.last_sping = time()
        QUOTE PING $S $temp.last_sping_server
        RETURN
    }
    ^SET STATUS_USER2 ? 
    @ temp.last_ping = time()
    XQUOTE -S $winserv() PING $temp.last_ping
}
   
ALIAS _proc.update_lag (sname, then) {
  IF (sname == S) {
    @ :fix = isnumber($then) ? then : temp.last_ping
    @ :lag = time() - fix
    ^SET STATUS_USER2 $tdiff2($lag)
    RETURN
  }
  UNLESS (sname == temp.last_sping_server) {RETURN}
  @ :lag = isnumber($temp.last_sping) ? time() - temp.last_sping : 0
  xecho -server $sname latency: $tdiff($lag)
  @ temp.last_sping = temp.last_sping_server = []
}   
ON ^PONG "*" {_proc.update_lag $0 $2}
ON ^RAW_IRC '$^\N!% PRIVMSG $^\N :PING % %' {_proc.update_lag $4 $5}
