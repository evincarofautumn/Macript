#!/usr/bin/perl
#
# macript 1.0
# By Jon Purdy
#
# Searches source files for anything that looks like a macro invocation
# and replaces them with the result of invoking the corresponding
# script with the given arguments, if such a script exists in the
# directory where macript is invoked. Results are sent to standard
# output, presumably for piping to a compiler or interpreter.
#

use warnings;
use strict;

$#ARGV == 0 or die "Usage: macript.pl FILE\n";
open(FILE, $ARGV[0]) or die "Unable to open $ARGV[0]: $!\n";

while (<FILE>) {
	while (/([A-Z_][0-9A-Z_]*)\((.*?)\)/gio) {
		my ($n, $a) = ($1, $2);
		if (my $s = find($n)) { s|$n\(.*?\)|`./$s $a`|e };
	}
	print;
}

close FILE;

sub find {
	my $n = shift;
	my @t = map {"$n$_"} ('', qw(.pl .py .sh));
	(grep {-e && -x _} @t)[0];
}

