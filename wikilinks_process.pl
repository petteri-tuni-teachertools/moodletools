#!/usr/bin/perl

=document

Usage: ./CMD.pl SRC_DIR DST_DIR

Finds the HTML files in SRC_DIR and processes their content to the DST_DIR.
Both anonymous and named versions.

For debugging:
$ export DEBUG_ON=1

=cut

use English;
use Env qw(DEBUG_ON);

#$my $DEBUG_ON = ENV('DEBUG_ON');

my $src_file = $ARGV[0];
my $dst_file = $ARGV[1];

open(FILE, '<', $src_file) or die "NO FILE";
open(OUT, '>',  $dst_file);

while (<FILE>) {
	debug_print( $_);
	my $line = $_;
	if ($line =~ m,(https://wiki.tamk.fi[^<> ]+),) {
		debug_print( "WIKI https FOUND\n");
		my $url = $1;
		debug_print( "WIKI https FOUND, URL: $url\n");
		if ($line !~ m,href,) {
			my $qurl = quotemeta($url);
			debug_print( "NO HREF in line QUOTED: $qurl\n");
			if ($line =~ m|$qurl|) {
				debug_print( "URL FOUND $url ... subs\n");
				$line =~ s|$qurl|<a href="$url">$url</a>|;
				}
		}
	}
	print OUT $line;
}

close FILE;
close OUT;

sub debug_print {
	$DEBUG_ON and print @_;
}

