#!/usr/bin/perl

use strict;
use warnings;

use Data::Dump qw( dump );
use FindBin;
use Test::More qw( no_plan );
use YAML::Tiny qw( LoadFile );
require_ok('HTTP::BrowserDetect');


my @tests = LoadFile("$FindBin::Bin/useragents.yaml");

foreach my $test ( @tests ) {

    #diag( dump $test );
    
    my $detected = HTTP::BrowserDetect->new( $test->{useragent} );
    diag( $detected->user_agent );

    cmp_ok( $detected->version, '==', $test->{version}, "version: $test->{version}") if $test->{version};
    cmp_ok( $detected->major, 'eq', $test->{major}, "major version: $test->{major}") if $test->{major};
    cmp_ok( $detected->minor, 'eq', $test->{minor}, "minor version: $test->{minor}") if $test->{minor};

    cmp_ok( $detected->language, 'eq', $test->{language}, "language: $test->{language}") if $test->{language};


    $test->{os} =~ tr[A-Z][a-z] if $test->{os};

    if ( $test->{os} ) {
        $test->{os} =~ s{\s}{}gxms;
        my $method = $test->{os};
        ok( $detected->$method, $test->{os} ) if $test->{os};
    }

    foreach my $type ( @{ $test->{match} } ) {
        ok( $detected->$type, "$type should match" );
    }

    # Test that $ua doesn't match a specific method
    foreach my $type ( @{ $test->{no_match} } ) {
        ok( !$detected->$type, "$type shouldn't match (and doesn't)" );
    }

}
