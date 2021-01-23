#!/usr/bin/perl

=document

Usage: ./CMD.pl SRC_DIR DST_DIR

Finds the HTML files in SRC_DIR and processes their content to the DST_DIR.
Both anonymous and named versions.

=cut

use English;

my $src_file = $ARGV[0];
my $dst_file = $ARGV[1];

open(FILE, '<', $src_file) or die "NO FILE";
open(OUT, '>',  $dst_file);

while (<FILE>) {
	print $_;
	my $line = $_;
	if ($line =~ m,(https://wiki.tamk.fi[^<> ]+),) {
		my $url = $1;
		if ($line !~ m,href,) {
			$line =~ s,$1,<a href="$url">$url</a>,;
		}
	}
	print OUT $line;
}

close FILE;
close OUT;

