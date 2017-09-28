package dict
# Dictionary lookup using raw sockets
# (C) 1998-2006 Serf <xport525@windstream.net>

alias dict if (@) {
    @ :fd = connect(dict.org 2628)
    @ dict.word = [$*]
}

on ^dcc_raw "% dict.org d 220 *" {
    xecho -b -c Dict server ready.
    DCC RAW $0 $1 DEFINE ! "$dict.word"
}

on ^dcc_raw "% dict.org d 150 *" {
    xecho -c 4[$dict.word] $tr(///$4-)
}

on ^dcc_raw "% dict.org d 151 *" {
    xecho -c 4[$dict.word] Current dictionary: $tr(///$6-)
}

on ^dcc_raw "% dict.org d 221 *" #

on ^dcc_raw "% dict.org d 250 ok *" {
    DCC RAW $0 $1 QUIT
}

on ^dcc_raw "% dict.org d *" {
    xecho 4[$dict.word] $tr(///$3-)
}

on ^dcc_raw "% dict.org c" purge dict
