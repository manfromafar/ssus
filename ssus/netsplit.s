package netsplit
# Netsplit detection script - Original Daemon, mods - Serf.
# (C) 1998-2006 Serf <xport525@windstream.net>

@ valid.domains = [?? com edu net org]

on ^channel_signoff '% % %.\\[${valid.domains}\\] %.\\[${valid.domains}\\]' {
	netbroke $encode($tolower($0)) $encode($1) $encode($2).$encode($3) $2 $3
}

# Stuff array. Tell us what server broke and set split flag.
alias netbroke {
	@ netsplit.signcross[$2][$0][$1] = 1
	@ netsplit.signoffs[$0][$1] = [$2]
	@ netsplit.splittime[$2] = time()
	if ( !netsplit.isbroke[$2] )
	{
		xecho -b -level OPNOTES Netsplit at $Z \($3-\) -- hit CTRL+F to see who left
		@ netsplit.isbroke[$2] = 1
		@ netsplit.splitname[$2] = [$3-]
	}
}

# When a person joins a channel.. Check them against the array.
# If they are in array, then remove silently.  Otherwards echo normally
ON ^JOIN "*" {
    @ temp.joinstuff = [$*]
	netjoined $encode($tolower($1)) $encode($0) $1 $0 $USERHOST()
}

# Unset the split flag
alias netjoined {
	if ( netsplit.signoffs[$0][$1] )
	{
		if ( netsplit.isbroke[$netsplit.signoffs[$0][$1]] )
		{
			xecho -level OPNOTES $BANNER Netjoined at $Z \($netsplit.splitname[$netsplit.signoffs[$0][$1]]\)
		}
		@ netsplit.isbroke[$netsplit.signoffs[$0][$1]] = netsplit.signcross[$netsplit.signoffs[$0][$1]][$0][$1] = netsplit.signoffs[$0][$1] = []
		@ netsplit.rejoin = 1
	} {
        joinhandle $temp.joinstuff
    }
}

# Clear the array every 10 minutes to prevent excess garbage
on #^timer 70 * netclean

alias netclean {
	foreach netsplit.splittime ii
	{
		foreach netsplit.splittime.$ii jj
		{
			if ( time() - netsplit.splittime[$ii][$jj] > 300 )
			{
				foreach netsplit.signcross.$(ii).$jj xx
				{
					foreach netsplit.signcross.$(ii).$(jj).$xx yy
					{
						@ netsplit.signcross[$ii][$jj][$xx][$yy] = []
						@ netsplit.signoffs[$xx][$yy] = []
					}
				}
				@ xx = yy = netsplit.isbroke[$ii][$jj] = netsplit.splitname[$ii][$jj] = netsplit.splittime[$ii][$jj] = []
			}
		}
	}
	@ ii = jj = []
}

alias netpurge {
    purge netsplit
}

# If you want to look an array.. Type /show <arrayname>
# Lists keys and contents
alias showsplit {
	if ([$($0)]) {echo $0 $($0)}
	foreach $0 ii
	{
		showsplit $0.$ii
	}
}


alias wholeft {
	foreach netsplit.signoffs ii
	{
		foreach netsplit.signoffs.$ii jj
		{
			echo $lformat(15 $decode($ii)) $lformat(10 $decode($jj)) $netsplit.splitname[$netsplit.signoffs[$ii][$jj]]
		}
	}
	@ ii = jj = []
}
