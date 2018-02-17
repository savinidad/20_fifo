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
	use Fcntl qw(:flock);
	$SIG{PIPE} = \&broken_pipe;
	$SIG{ALRM} = \&sig_alrm;
	our $alarm;
}

sub sig_alrm {
	printf "%s\n", $alarm;
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
sub lock_user {
	my ($user) = @_;
	# protect against a zombie observer no longer reading fifo
	# fifo open blocks until a listener is open, 
	#   but if I open for RW, I myself qualify as a listener!
	#alarm 1; $alarm = "timeout waiting to open fifo $user for wr";
	if (open($fifo_fh, "+<", $user)) {
		#alarm 0; $alarm = "";
		# alarm 1; $alarm = "timeout waiting to lock fifo $user for wr";
		printf "flock:%s:\n", 
			flock($fifo_fh, 2);# waits for exclusive lock opportunity
			#alarm 0; $alarm = "";
			print $fifo_fh encode_json([$0]);	# format and send the data
			print $fifo_fh "\n";
			for (0..4) {
				printf "holding lock %s\n", $_;
				sleep 1;
			}
		close $fifo_fh;
	} else {
		note("send_obs_dat failed user:$user FIFO open:$!");
	}
}

# main
print "here we go dad\n";
lock_user('dad.lck');
