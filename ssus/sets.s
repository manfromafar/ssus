package sets
# /sets
# (C) 1998-2006 Serf <xport525@windstream.net>

set always_split_biggest off
set auto_newnick on
set auto_reconnect on
set auto_reconnect_delay 0
set auto_whowas off
set banner_expand off
set beep on
set beep_max 3
set beep_on_msg msgs
set beep_when_away 0
set blink_video off
set bold_video on
set channel_name_width 0
set clock on
set clock_24hour off
set -clock_format
set color on
set command_mode off
set comment_hack on
set connect_timeout 20
set continued_line     
set cpu_saver_after 10
set cpu_saver_every 5
set dcc_long_pathnames off
set dcc_sliding_window 1
set dcc_store_path ~
set dcc_timeout 1200
set dispatch_unknown_commands off
set display on
set display_ansi on
set eight_bit_characters on
set floating_point_math on
set flood_warning off
set hide_private_channels off
set high_bit_escape 2
set indent on
set input_prompt [$T] 
set history 25
set insert_mode on
set inverse_video on
set lastlog 10000
set max_reconnects 10
set max_recursions 40
set mirc_broken_resume on
set mode_stripper on
set no_control on
set scrollback 5000
set show_channel_names on
set show_numerics off
set -status_user
set suppress_server_motd on
eval set banner $theme.banner
eval set quit_message $ss.qm
set status_user8 $sar(g/././$ssus())
