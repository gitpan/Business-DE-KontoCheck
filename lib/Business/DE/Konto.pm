package Business::DE::Konto;
#---------------------------------------------
# $Id: Konto.pm,v 1.12 2002/09/12 21:59:37 tina Exp $
#---------------------------------------------
use strict;
use Data::Dumper;
require Exporter;
use base qw(Exporter);
use vars qw(%error_codes @EXPORT_OK %EXPORT_TAGS $VERSION);
$VERSION = '0.02';
@EXPORT_OK = qw(%error_codes);
%EXPORT_TAGS = ( 'errorcodes' => [@EXPORT_OK]);
sub new {
	my $type = shift;
	my $args = shift;
	my $self = {};
	my @args = qw(PLZ BLZ INST METHOD ORT KONTONR BIC);
	@$self{@args} = @$args{@args};
	bless ($self, $type);
}
sub setValue {
	my $self = shift;
	my %args = @_;
	while (my ($key,$value) = each %args) {
		$self->{$key} = $value;
	}
}
sub check {
	my $self = shift;
	#print "debug 1\n";
	return 1 unless $self->{ERRORS};
	#print "debug 2\n";
	return if $self->{ERRORS}->{ERR_KNR_INVALID} && (keys %{$self->{ERRORS}}) == 1;
	#print "debug 3\n";
	return 0;
}

sub setErrorCodes {
	my $self = shift;
	my $codes = shift or return;
	%error_codes = %$codes;
}
sub setError {
	my $self = shift;
	my $error = shift;
	$self->{ERRORS}->{$error}++
}
sub printErrors {
	my $self = shift;
	my $errors = $self->{ERRORS} || return '';
	#print Dumper $self->{ERRORS};
	my $err_string;
	for my $error (keys %$errors) {
		$err_string .= "Error $error: $error_codes{$error}\n";
		#print "Error $error: $error_codes{$error}\n";
	}
	return $err_string;
}
sub getErrors {
	my $self = shift;
	my $errors = $self->{ERRORS} || return '';
	return [keys %$errors];
}
%error_codes = (
	ERR_NO_BLZ      => 'Please supply a BLZ',
	ERR_BLZ         => 'Please supply a BLZ with 8 digits',
	ERR_BLZ_EXIST   => 'BLZ doesn\'t exist',
	ERR_BLZ_FILE    => 'BLZ-File corrupted',
	ERR_NO_KNR      => 'Please supply an account number',
	ERR_KNR         => 'Please supply a valid account number with only digits',
	ERR_KNR_INVALID => 'Account-number is invalid',
	ERR_METHOD      => 'Method not implemented yet',
);
1;
