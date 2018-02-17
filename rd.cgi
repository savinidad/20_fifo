#!/usr/bin/perl
BEGIN {
	use warnings;
	use strict;
	use lib "/Users/dad/Sites/00_common/perl/lib";
		# ~dad/Sites/00_common/perl/lib/Html.pm
	use Data::Dumper;
	use JSON;
	use Html;
	use Sav_util;
	$SIG{TERM} = \&sig_term;
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# MODEL
sub rd_loop {
	printf "try FIFO open\n";
	open(FIFO, "<", "dad") or die "failed open";
	printf "FIFO open for reading\n";
	while (<FIFO>) {
		print;
		last if (/2/);
	}
	close FIFO;
}

sub sig_term {
	note "hi dad, caught :$!: so bye\n";
	# 2017-04-02.074108  hi dad, caught :Interrupted system call: so bye
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# main
#note sprintf("%s  rd.cgi started, let's see how long to die..", date_x());
#print "Content-Type: text/event-stream\n\n";
rd_loop();
