package config
# ssus configuration system
# (C) 2005 Thomas Morris

@ config[A] = [ss.public_away:Show away status in channel]
@ config[B] = [ss.quiet_ctcp:Do not show halted CTCPs]
@ config[C] = [ss.suspend_reply_for:Seconds between CTCPs sent]
@ config[D] = [ss.cloak:CTCP Cloaking]
@ config[E] = [ss.timestamp:Timestamping]
@ config[F] = [ss.strip_crap:Strip bold/ul/color]
@ config[G] = [ss.beep_on_autoreply:Beep on autoreply]
@ config[H] = [ss.autoreply:Autoreply highlighting]
@ config[I] = [ss.extended_mode_view:Show <+nick> or <@nick>]
@ config[J] = [ss.clientinfo:Your CTCP CLIENTINFO reply]
@ config[K] = [ss.finger:Your CTCP FINGER reply]
@ config[L] = [ss.userinfo:Your CTCP USERINFO reply]
@ config[M] = [ss.time:Your CTCP TIME reply]
@ config[N] = [ss.umode:Your default usermode]
@ config[O] = [ss.dkm:Your default kick message]
@ config[P] = [ss.qm:Your default quit message]
@ config[Q] = [ss.completion_char:Your default nickcomp character]
@ config[R] = [basename($ss.theme):ssus theme]

alias config (letter, args) {
    if (!letter) {
        foreach config xx {
            @ :var = before(: $config[$xx])
            @ :lvar = [$($var)]
            echo [4$xx] $lformat(35 $after(: $config[$xx])) [4${lvar != ""? lvar : [<none>]}]
        }
    } elsif (letter && args == []) {
        @ :var = before(: $config[$letter])
        switch ($letter) {
            (E) { type /timestamp $($var) }
            (R) { type /theme }
            (*) { type /assign $var $($var) }
        }
    } else {
        @ :var = before(: $config[$letter])
        switch ($letter) {
            (E) { /timestamp $args }
            (*) { assign $var $args }
        }
    }
}
