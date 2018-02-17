#!/usr/bin/perl
BEGIN {
	use warnings;
	use strict;
	use lib "/Users/dad/Sites/00_common";
	use Scgi;
	use Sutil;
	use Data::Dumper;
	use JSON;
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# MODEL
# http://man7.org/linux/man-pages/man7/fifo.7.html
#   When a process tries to write to a FIFO that is not opened for read on the
#   other side, the process is sent a SIGPIPE signal.
sub message_enter {
	my ($args, $cgi) = @_;
	my $msg = $args->{msg};
	# the dat sent here is put into fifos as JSON
	# ends up on each user browser as:  user: msg
	send_obs_dat({
		function => 'message_receive',
		args => {
			user => $cgi->{cookies}{user},
			msg => $msg,
		},
	});
	# the data returned becomes ret in ajax success: function(ret, status)
	# so you can respond to sender here, all observers above
	return {
		function => 'el_prepend', 
		args => {
			el => "debug", 
			text => "echo:$msg\n",
		},
	};
}

# VIEW
sub view {
	my ($cgi) = @_;
	html_head_body(
		$cgi,
		{
			title => 'dad\'s apps fifo/sse explore',
			script => [ {src => 'app.js'}, ],
		},
		fifo_page(),
	);
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# the pages
sub fifo_page {
	div({id => 'fifo_page'},
		p("Type a message, on [return] or [done] it will be distributed:"),
		textfield({name => 'message', id => 'message'}),
		p({id => 'msg'}, ''),
		pre({id => 'debug'}, ''),
	),
}

sub fake_cgi {
	# hand-written $cgi right here
	return {
		params => {
			from => 'message_enter',
			msg => 'fake_cgi message',
		},
		cookies => {
			user => 'dad',
		}
	}
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# main
cgi_rt00();
