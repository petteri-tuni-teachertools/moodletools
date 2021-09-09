#!/usr/bin/perl

=document

Usage: ./CMD.pl SRC_DIR DST_DIR

Finds the PDF files in SRC_DIR and processes their content to the DST_DIR.
Both anonymous and named versions.

=cut

use English;

my $src_dir = $ARGV[0];
my $dst_dir = $ARGV[1];
my $dst_ano = "$dst_dir/ano";
my $dst_nm = "$dst_dir/nm";

my $data = qx(find $src_dir -name "*.pdf");

my %result_hash;
my %file_cnt_hash;
my @data_list = split("[\n\r]", $data);
while (my $line = shift @data_list) {
	my $name;
	# print "LINE: $line \n";
	if ($line =~ m,$src_dir/([^_]*)_\d,) {
		$name = $1;
		$name =~ s/ /_/g;
	}
	$name and print "NAME: $name\n";
	$name or print "LINE PROBLEM: $line\n";

	if (exists $file_cnt_hash{$name}) {
		$file_cnt_hash{$name}++;
	} else {
		$file_cnt_hash{$name} = 1;
	}
	my $key_value = $name.'-'.$file_cnt_hash{$name};
	$result_hash{$key_value} = $line;
};
qx(mkdir $dst_dir);
qx(mkdir $dst_ano);
qx(mkdir $dst_nm);

my $i=0;
for $name (sort keys %result_hash) {
	my $file = $result_hash{$name};
	$i++;
	qx(cp "$file" $dst_ano/$i.pdf);
	qx(cp "$file" "$dst_nm/$i_$name.pdf");
}

exit;

