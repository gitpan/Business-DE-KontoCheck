use lib "../..";
use Test;
use Data::Dumper;
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.c'
# $Id: test.t,v 1.12 2002/10/21 20:59:28 tina Exp $

BEGIN {
	$| = 1;
	plan tests => 77;
	$from = "00";
	$to = "74";
	print "$from..$to\n";
	$make_test = ($ARGV[0] && $ARGV[0] eq 'test') ? 0 : 1;
}
END {
if ($loaded) {
	ok(1)
}
else {
	ok(0)
}

}
use Business::DE::KontoCheck;
$Business::DE::KontoCheck::CACHE_ON = 1;
$Business::DE::KontoCheck::CACHE_ALL = 0;
# write test blz file
unless (-e "t/testblzpc.txt") {
	open TESTBLZFILE, ">t/testblzpc.txt";
	open BLZFILE, "<blzpc.txt" or die $!;
	print TESTBLZFILE while <BLZFILE>;
	close BLZFILE;
	open BLZFILE, "<t/testblz.dat" or die $!;
	print TESTBLZFILE while <BLZFILE>;
	close BLZFILE;
	close TESTBLZFILE;
}
open TEST, "<./t/test.dat" or die $!;
chomp(my @lines = <TEST>);
close TEST;
my $kcheck = Business::DE::KontoCheck->new(
	BLZFILE => "./t/testblzpc.txt",
	MODE_BLZ_FILE => 'BANK'
);
#my $kcheck = Business::DE::KontoCheck->new(
#	BLZFILE => "./new.txt",
#	MODE_BLZ_FILE => 'MINIMAL'
#);
exit unless defined $kcheck;
foreach my $ix (0..@lines-1) {
	my ($method,$blz,$knrs) = split /;/, $lines[$ix];
	next if $lines[$ix] =~ m/^#/;
	next if $method lt $from;
	last if $method gt $to;
	my @knrs = grep {m/\d+/} split /[ ,]+/, $knrs;
	my $soll = @knrs;
	my $ist = 0;
	foreach my $kix (0..@knrs-1) {
		my $kontonr = $knrs[$kix];
		#print "testing BLZ ($blz), KNR ($kontonr)\n";
		#print "$method\r";
		my $konto = $kcheck->check(BLZ=>$blz, KONTONR=>$kontonr);
		if (my $res = $konto->check()) {
			print "ok $method.$kix\r" unless $make_test;
			print "Account number ok ($method, $blz, $kontonr)\n" if !$make_test;
			$ist++;
		}
		elsif (!defined $res) {
			# account number invalid
			print "Account number invalid ($method, $blz, $kontonr)\n" if !$make_test;
		}
		else {
			my $err_string = $konto->printErrors();
			my $err_codes = $konto->getErrors();
			if ($err_codes->[0] eq 'ERR_METHOD') {
				print "ok $method.$kix\r" unless $make_test;
				print "m$method not implemented yet @$err_codes\n" unless $make_test;
				$ist++;
			}
			else {
				warn $err_string;
				print "not ok $method.$kix\n";
				#sleep 1;
			}
		}
	}
	if ($ist == $soll) {
		if ($make_test) {
			ok(1);
			#print "ok $method\n";
		}
		else {
			print "ok $method   \n";
		}
	}
	else {
#		print "not ok $method\n";
		ok(0);
	}
}
my $method = $kcheck->getMethod2BLZ("10020383");
if ($method eq "00") {
	ok(1)
}
else {
	ok(0)
}
$loaded = 1;
exit;
