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

use JSON::PP ();
use Path::Tiny qw( path );

use HTTP::BrowserDetect ();

my $json_text = path( $ARGV[0] )->slurp;
my $tests     = JSON::PP->new->ascii->decode($json_text);

foreach my $ua ( sort keys %{$tests} ) {
    my $test   = $tests->{$ua};
    my $detect = HTTP::BrowserDetect->new($ua);
    foreach my $field (
        qw(browser browser_string device device_string
        engine engine_beta engine_minor engine_major engine_version
        os os_beta os_major os_minor os_version os_string
        robot robot_string
        robot_version robot_major robot_minor robot_beta)
    ) {
        no strict 'refs';

        my $field_name = $field;
        my $value      = $detect->$field;

        if ( $field_name eq 'device_string' ) {
            if ( defined( $test->{device_name} ) ) {
                $field_name = 'device_name';
            }
        }
        elsif ( $field_name eq 'robot_string' ) {
            if ( defined( $test->{robot_name} ) ) {
                $field_name = 'robot_name';
            }
        }
        elsif ( $field_name eq 'robot' ) {
            next unless $value || defined( $test->{$field_name} );
        }

        if ( defined($value) || exists( $test->{$field_name} ) ) {
            $test->{$field_name} = $value;
        }
        else {
            delete $test->{$field_name};
        }
    }
}

my $json   = JSON::PP->new->canonical->pretty;
my $output = $json->encode($tests);
print "$output\n";
