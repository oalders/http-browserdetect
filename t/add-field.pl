#!/usr/bin/perl -w

# Script for adding fields to existing regression tests
#
# Recommended use:
#
# $ perl -I../lib add-field.pl useragents.json > new-useragents.json
#
# This will add a field to existing regression tests, based on what
# the code currently returns for a particular test.
#
# As currently written, this script adds the "browser" method to
# existing tests.

use strict;

use FindBin;
use JSON::PP;
use Path::Tiny qw( path );

use HTTP::BrowserDetect;

my $json_text = path($ARGV[0])->slurp;
my $tests     = JSON::PP->new->ascii->decode($json_text);

foreach my $ua ( sort keys %{$tests} ) {
    my $test = $tests->{$ua};
    my $detect = HTTP::BrowserDetect->new($ua);
    foreach my $field ( qw(browser browser_string device device_string
        engine engine_beta engine_minor engine_major engine_version
        os os_beta os_major os_minor os_version os_string
        robot robot_string) )
    {
	no strict 'refs';
	my $value = $detect->$field;
	if ($field eq 'robot' ? $value : defined($value)) {
	    $test->{$field} = $value;
	} else {
	    delete $test->{$field};
	}
    }
    delete $test->{device_name};
}

my $json   = JSON::PP->new->canonical->pretty;
my $output = $json->encode( $tests );
print "$output\n";
