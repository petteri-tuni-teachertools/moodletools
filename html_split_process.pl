#!/usr/bin/perl

=document

Usage: ./CMD.pl SRC_DIR DST_DIR KEYWORD

Finds the HTML files in SRC_DIR and processes their content to the DST_DIR.
Both anonymous and named versions.
Uses KEYWORD to filter in lines.

=cut

use strict;
use English;
use Env qw(DEBUG_ON);

my $src_dir = $ARGV[0];
my $dst_dir = $ARGV[1];
my $keyword = $ARGV[2];
my $dst_ano = "$dst_dir/ano";
my $dst_nm = "$dst_dir/nm";

my @active_list;
my $keyfile = '/home/pj/tamk-kurssit/ohjtuot-c21/opiskelijat-utf.csv';
my $total = 0;
my $total_unknown = 0;
my %key_list_hash = ();
my %tagged_result_hash;

read_keyfile($keyword);

for my $tag_key (keys %key_list_hash) {
	print "$tag_key -> ", @{$key_list_hash{$tag_key}}, "\n";
}

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

	my $found = '-';

	
	my $cur_tag = 0;
	for my $tag_key (keys %key_list_hash) {	
		my @active_list = @{$key_list_hash{$tag_key}};
		foreach my $cond (@active_list) {
			if ($cond =~ $name) {
				$cur_tag = $tag_key; 
			}			
		}
	}
	
	$name and print "NAME: $name $cur_tag\n";
	$name or print "LINE PROBLEM: $line\n";
	
	
	$cur_tag or $total_unknown++;	
	$cur_tag or $cur_tag = 'unknown';
	$tagged_result_hash{$cur_tag}{$name} = $line;		
	
	$total++;
};
print "\n$total, $total_unknown\n";

my @tmp_tag_list = keys %key_list_hash;
$total_unknown and push @tmp_tag_list, 'unknown';
 
for my $tag_key (@tmp_tag_list) {
	my $tag_dir = $dst_dir.'-'.lc($tag_key);
	my $tag_ano = "$tag_dir/ano";
	my $tag_nm = "$tag_dir/nm";
	qx(mkdir $tag_dir);
	qx(mkdir $tag_ano);
	qx(mkdir $tag_nm);

	my $all_nm = "$tag_dir/NAMED.html";
	my $all_an = "$tag_dir/ANON.html";
	qx(touch $all_an; touch $all_nm);

	my $i=0;
	for my $name (sort keys %{$tagged_result_hash{$tag_key}}  ) {
		%result_hash = %{$tagged_result_hash{$tag_key}};
		my $file = $result_hash{$name};
		$i++;
		qx(cp "$file" $tag_ano/$i.html);
		qx(cp "$file" $tag_nm/$name.html);
	
		qx(echo "<p /> ===================================== " >> $all_nm; echo >> $all_nm); 
		qx(echo "<br /> $i $name -------------------- <br />" >> $all_nm; echo >> $all_nm);
		qx(cat "$file" >> $all_nm; echo >> $all_nm);
		qx(echo "<p /> ===================================== " >> $all_an); 
		qx(echo "<br /> $i ------------------------- <br />" >> $all_an; echo >> $all_an);
		qx(cat "$file" >> $all_an; echo " " >> $all_an);
	}
}

exit;




exit;

sub debug_print {
        $DEBUG_ON and print @_;
}

sub read_keyfile {
	my $tag = shift;
	

	open(FILE, '<', $keyfile) or die "NO FILE $keyfile";
	while (<FILE>) {
		my $line = $_;
		my ($kandi, $first, $last, $name);
		($kandi, undef, $last, $first, $name) = split(',', $line);
		my $cond = $first.'_'.$last;
		my $active = ($kandi eq $tag)?"YES $cond":'NO ';
		if ($kandi eq $tag) {
			push @active_list, $cond;
		}		
		if (not exists $key_list_hash{$kandi}) {
			$key_list_hash{$kandi} = []; # Create empty list
		}
		push @{$key_list_hash{$kandi}}, $cond; # Store all the possible keys to a hash
        debug_print("$active $line");
	}
	debug_print(@active_list);
}
