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

my $data = qx(find $src_dir -name "*.zip");

my %result_hash;
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

	$result_hash{$name} = $line;
};
qx(mkdir $dst_dir);
#qx(mkdir $dst_ano);
qx(mkdir $dst_nm);

my $i=0;
for $name (sort keys %result_hash) {
	my $file = $result_hash{$name};
	$i++;
	#qx(cp "$file" $dst_ano/$i.zip);
	qx(mkdir $dst_nm/$i_$name);
	qx(cp "$file" "$dst_nm/$i_$name/$i.zip");
}

my $i=0;
for $name (sort keys %result_hash) {
	my $file = $result_hash{$name};
	$i++;
	qx(cd "$dst_nm/$i_$name"; unzip $i.zip);
}

exit;

