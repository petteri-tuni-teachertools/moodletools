#!/usr/bin/perl

=document

Usage: ./CMD.pl SRC_DIR DST_DIR

Finds the HTML files in SRC_DIR and processes their content to the DST_DIR.
Both anonymous and named versions.

=cut

use English;

my $src_dir = $ARGV[0];
my $dst_dir = $ARGV[1];
my $dst_ano = "$dst_dir/ano";
my $dst_nm = "$dst_dir/nm";

my $data = qx(find $src_dir -name "*.html");

my %result_hash;
my @data_list = split("[\n\r]", $data);
while (my $line = shift @data_list) {
	my $name;
	# print "LINE: $line \n";
	if ($line =~ m,$src_dir/(.*)_\d,) {
		$name = $1;
		$name =~ s/ /_/g;
	}
	$name and print "NAME: $name\n";
	$name or print "LINE PROBLEM: $line\n";

	$result_hash{$name} = $line;
};
qx(mkdir $dst_dir);
qx(mkdir $dst_ano);
qx(mkdir $dst_nm);

my $all_nm = "$dst_dir/NAMED_$dst_dir.html";
my $all_an = "$dst_dir/ANON_$dst_dir.html";
qx(touch $all_an; touch $all_nm);

my $i=0;
for $name (sort keys %result_hash) {
	my $file = $result_hash{$name};
	$i++;
	qx(cp "$file" $dst_ano/$i.html);
	qx(cp "$file" $dst_nm/$name.html);

	qx(echo "<p /> ===================================== " >> $all_nm; echo >> $all_nm); 
	qx(echo "<br /> $i $name -------------------- <br />" >> $all_nm; echo >> $all_nm);
	qx(cat "$file" >> $all_nm; echo >> $all_nm);
	qx(echo "<p /> ===================================== " >> $all_an); 
	qx(echo "<br /> $i ------------------------- <br />" >> $all_an; echo >> $all_an);
	qx(cat "$file" >> $all_an; echo " " >> $all_an);
}

exit;

