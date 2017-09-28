^set BANNER ::
^set STATUS_DOES_EXPANDOS on
^set status_format %T [%*%=%N%#] [%@%C%+] %W %A %L %H%B %F%M%Q %1 %>%D%2 %3
^set status_format1 %T [%*%N%#] [%@%=%C%+] %A %L %F %1 %>%2 %3
^set status_format2 [<ssus> %H%B %A %M %Q %4 %5 %>%Z %6 %7 %8
^set status_away [dead]
^set status_channel %C 
^set status_chanop @
^set status_clock [%T]
^set status_cpu_saver [CPU Saver]
^set status_hold [hold]
^set status_hold_lines :%B
^set status_mail [Mail: %M]
^set status_mode +%+
^set status_nickname %N 
^set status_notify (%F)
^set status_oper *
^set status_query [Query: %Q]
^set status_server [On: %S]
^set status_umode +%#
^set status_window ^^^^^^^^^^^^^^^^
@ theme.window_double = 0
@ theme.reverse_status = 0
@ theme.tsformat = [%X]
alias theme.tslook @ function_return = [[$*]]
alias theme.pub @ function_return = [2<$02> $dc($2-)]
alias theme.pub_ar @ function_return = [2<$02> $dc($2-)]
alias theme.pubother @ function_return = [2<$0\/$12> $dc($2-)]
alias theme.pubother_ar @ function_return = [2<$0\/$12> $dc($2-)]
alias theme.leavea @ function_return = [2$BANNER $0 \($2) left $1 ${ss.timestamp? [at $ZEE()] : []} $partmsg($3-)]
alias theme.leaveu @ function_return = [2$BANNER $0 \($2) left $1 ${ss.timestamp? [at $ZEE()] : []} $partmsg($3-)]
alias theme.joina @ function_return = [12$BANNER $0 \($2) joined $1 ${ss.timestamp? [at $ZEE()] : []}]
alias theme.joinu @ function_return = [12$BANNER $0 \($2) joined $1 ${ss.timestamp? [at $ZEE()] : []}]
alias theme.sendpublica @ function_return = [4<${N}4> $1-]
alias theme.sendpublicu @ function_return = [[$0] 4<${N}4> $1-]
alias theme.sendactionchan @ function_return = [4* $N $1-]
alias theme.sendactionpriv @ function_return = [4* -> $0: $N $1-]
alias theme.notifysignon @ function_return = [$BANNER [ Signon\($0\!$1) ]]
alias theme.notifysignoff @ function_return = [$BANNER [ Signoff\($0) ]]
alias theme.sendmsg @ function_return = [-> *$0* $1-]
alias theme.msg @ function_return = [*\($0!$userhost())* $dc($1-)]
alias theme.notice @ function_return = [-$0!$userhost()\- $dc($1-)]
alias theme.sendnotice @ function_return = [-> -$0\- $1-]
alias theme.ctcpreply @ function_return = [2$BANNER CTCP $1 reply from $0: $dc($2-)]
alias theme.youarenot @ function_return = [10$BANNER You're not on a channel]
alias theme.cantfindarg @ function_return = [10$BANNER Can't find $arg\.]
alias theme.notchanop @ function_return = [10$BANNER You are not chanop on $C\.]
alias theme.nomatchbans @ function_return = [11$BANNER No matching BANs found on $C\.]
alias theme.signoffa @ function_return = [4$BANNER Signoff: $1 \($dc($2-))]
alias theme.signoffu @ function_return = [4$BANNER Signoff: $1 $0 \($dc($2-))]
alias theme.modea @ function_return = [11$BANNER Mode Change \"$2-\" on $1 by $0] 
alias theme.modeu @ function_return = [11$BANNER Mode Change \"$2-\" on $1 by $0]
alias theme.modes @ function_return = [11$BANNER Mode change \"$2-\" for user $1 by $0]
alias theme.servmodea @ function_return = [11$BANNER Mode hack \"$2-\" on $1 by $0]
alias theme.servmodeu @ function_return = [11$BANNER Mode hack \"$2-\" on $1 by $0]
alias theme.kicked @ function_return = [11$BANNER You have been kicked off channel $2 by $1 \($dc($3-))]
alias theme.kicka @ function_return = [11$BANNER $0 has been kicked off $2 by $1 \($dc($3-))]
alias theme.kicku @ function_Return = [11$BANNER $0 has been kicked off $2 by $1 \($dc($3-))]
alias theme.topica @ function_return = [11$BANNER $0 has changed the topic on $1 to $dc($2-)]
alias theme.topicu @ function_return = [11$BANNER $0 has changed topic on $1 to $dc($2-)]
alias theme.action_ara @ function_return = [* $0 $dc($2-)]
alias theme.action_arm @ function_return = [* $0 $dc($2-)]
alias theme.action_aru @ function_return = [* $0/$1 $dc($2-)]
alias theme.actiona @ function_return = [* $0 $dc($2-)]
alias theme.actionm @ function_return = [*> $0 $dc($2-)]
alias theme.actionu @ function_return = [* $0/$1 $dc($2-)]
alias theme.ctcpreq @ function_return = [11$BANNER CTCP $strip(: $0) request from $before(! $1) \($after(! $1)) to $2]
alias theme.ctcpreqnorep @ function_return = [11$BANNER CTCP $strip(: $0) request from $before(! $1) \($after(! $1)) to $2 [no reply]]
alias theme.ctcprequest @ function_return = [11$BANNER CTCP $2 request from $0 \($userhost()) to $1]
alias theme.ctcprequestarg @ function_return = [11$BANNER CTCP \($2-) request from $0 \($userhost()) to $1]
alias theme.mail @ function_return = [13$BANNER You have $0 new message${[$0] > 1 ? [s] : []}, $1 total]
alias theme.away @ function_return = [is away, $*]
alias theme.backa @ function_return = [is back "$*", gone $tdiff2(${time() - diedtime[$winserv()]})]
alias theme.backn @ function_return = [is back, gone $tdiff2(${time() - diedtime[$winserv()]})]
alias theme.dccchat @ function_return = [=$0= $1-]
alias theme.senddccchat @ function_return = [-> =$0= $1-]
theme.init
