#!/usr/bin/perl

=head1 NAME

Macript - Replaces macros with the output of scripts.

=head1 SYNOPSIS

    macript.pl source.cpp > target.cpp

=head1 DESCRIPTIOIN

Searches source files for anything that looks like a macro invocation (C<NAME(PARAMS)>) and replaces them with the result of invoking the corresponding executable with the given arguments, if such an executable exists in the directory where B<macript> is invoked. Results are sent to standard output, presumably for piping to a compiler or interpreter.

=head1 CAVEATS

Be very careful about what executables you have in your working directory when running this, and verify the output you get before it breaks your build; if you're crazy enough to use this in a makefile, you're going to have to use, e.g.:

    macript $< | gcc -x c++ - -o $@

=head1 COPYRIGHT

Copyright (c) 2011 Jon Purdy

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=head1 AVAILABILITY

http://github.com/evincarofautumn/Macript

=head1 AUTHOR

Jon Purdy <evincarofautumn@gmail.com>

=cut

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

