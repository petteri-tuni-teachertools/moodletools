#!/usr/bin/perl
use LWP::UserAgent;
use English;

my $arg_student = $ARGV[0];
$arg_student or $arg_student = 'tunnus24';

my $auth_uid = $ARGV[1];
$auth_uid or $auth_uid = 'cyber';

my $secret = $ARGV[2];
$secret or $secret = 'verysecret';

my $pass = '';
my $uid = '';

if ($arg_student =~ m/file:(.*)/) {
	my $filename = $1;
	open ($file, $filename);
	my $i = 0;
	while (<$file>) {
		$i++;
		chomp;
		my $line = $_;
		$line =~ s/[\r\n]//g;
		my ($mail, $curuser);
		($mail, $curuser, undef) = split('[ \t]', $line);
		$curuser and assess($curuser, $mail, $i);
	}
} else {
	assess($arg_student, $arg_student);
}
exit;

sub LWP::UserAgent::get_basic_credentials {
#    warn "@_\n";
        my ($self, $realm, $url) = @_;

	$pass or return '';
        return $uid, $pass;
}

sub assess {
	my $student = shift;
	my $mail = shift;
	my $num = shift;

my $open1 = open_site("http://home.tamk.fi/~$student/index.html" );
my $open2 = open_site("http://home.tamk.fi/~$student/secure/index.html" );
my $auth1 = auth_site("http://home.tamk.fi/~$student/secure/index.html", $auth_uid, $student.$secret );

print "================================================\n";
print "## $mail # $student ($num) ------------\n";

if ($open1 =~ m/$student/) {
	print "$student - OPEN 1 SUCCESS\n";
} else {
	print "$student - OPEN 1 FAILED\n";
	#print "$student - OPEN 1: $open1\n";
}

if ($open2 =~ m/unauthori/i) {
	print "$student - OPEN 2 SUCCESS\n";
} else {
	print "$student - OPEN 2: FAILED\n";
	#print "$student - OPEN 2: $open2\n";
}

if ($auth1 =~ m/$student/i) {
	print "$student - AUTH 1 SUCCESS\n";
} else {
	print "$student - AUTH 1 FAILED\n";
	#print "$student - AUTH 1: $auth1\n";
}

#print "$open1 \n";
#print "$open2 \n";
#print "$auth1 \n";
}

sub open_site {
  my $url = shift;
  $pass = '';

  my $ua = LWP::UserAgent->new;
  my $resp = $ua->get($url);
  my $ret_value = '';
  if ($resp->is_success) {
    $ret_value = $resp->decoded_content;
  } else {
    $ret_value .= $resp->status_line;
    $ret_value .= $resp->decoded_content;
  }
  return $ret_value;
}

sub auth_site {
  my $url = shift;
  my $userid = shift;
  my $pwd = shift;

  $uid = $userid;
  $pass = $pwd;

#print "UID: $uid\n";
#print "PASS: $pass\n";

  my $ua = LWP::UserAgent->new;
  my $resp = $ua->get($url);
  my $ret_value = '';
  if ($resp->is_success) {
    $ret_value = $resp->decoded_content;
  } else {
    $ret_value .= $resp->status_line;
    $ret_value .= $resp->decoded_content;
  }
  return $ret_value;
}

