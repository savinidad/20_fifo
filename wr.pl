#!/usr/bin/perl
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Finally, one table that summarizes pipe behavior, at bottom of entry
# http://unix.stackexchange.com/questions/81763/problem-with-pipes-pipe-terminates-when-reader-done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
BEGIN {
	use warnings;
	use strict;
	use lib "/Users/dad/Sites/00_common/perl/lib";
		# ~dad/Sites/00_common/perl/lib/Html.pm
	use Data::Dumper;
	use JSON;
	use Html;
	use Sav_util;
	$SIG{PIPE} = \&broken_pipe;
	$SIG{ALRM} = \&sig_alrm;
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# MODEL
sub wr_loop {
	printf "try FIFO open\n";
	alarm 1;		# this is to limit time waiting for FIFO open
	if (open(FIFO, ">", "dad")) {
		alarm 0;	# turn off the alarm!
		printf "FIFO open for writing\n";
		for (0..4) { 
			#print FIFO "hi dad:$_:\n";
			# syswrite does not buffer, and $| doesn't help print either
			# also, writing to a pipe without a reader kills this process, but
			# not with EPIPE or SIGPIPE signals, still hunting
			sys_print_to("hi dad :$_:\n", FIFO);
			print "sent this to FIFO: hi dad$_\n";
			sleep 1;
		}
		close FIFO;
	} else {
		printf "FIFO open failed, likely due to alarm\n";
	}
}
sub sys_print_to {
	my ($str, $to) = @_;
	syswrite($to, $str, length($str));
}

sub broken_pipe {
	#die "hi dad, caught :$!: so bye\n";
	printf "hi dad, caught :$!:\n";
	printf "this is a good place to remove an observer\n";
	printf "  apparently, the reading process died, perfectly possible\n";
}
sub sig_alrm {
	printf "sig_alrm\n";
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# main
print "here we go dad\n";
wr_loop();
