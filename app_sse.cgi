#!/usr/bin/perl
BEGIN {
	use warnings;
	use strict;
	use lib "/Users/dad/Sites/00_common";
	use Scgi;
	use Ssse;
	use Sutil;
	use Data::Dumper;
	use JSON;
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# main
# fundamentals: this script must run for as long as the EventSource on
# the browser, 'cause the Apache is watching the process, so during
# debug keep that in mind
cgi_rt01();
