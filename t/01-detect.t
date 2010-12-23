#!/usr/bin/perl

use strict;
use warnings;

use Data::Dump qw( dump );
use FindBin;
use Test::More qw( no_plan );
use YAML qw( LoadFile );
require_ok( 'HTTP::BrowserDetect' );

my @tests = LoadFile( "$FindBin::Bin/useragents.yaml" );

foreach my $test ( @tests ) {

    #diag( dump $test );

    my $detected = HTTP::BrowserDetect->new( $test->{useragent} );
    diag( $detected->user_agent );

    foreach my $method ( 'browser_string', 'engine_string', ) {
        if ( $test->{$method} ) {
            cmp_ok( $detected->$method, 'eq', $test->{$method},
                "$method: $test->{$method}" );
        }
    }

    foreach my $method (qw(
        public_version
        public_major
        public_minor
        version
        major
        minor
        engine_version
        engine_major
        engine_minor
        ))
    {
        if ( exists $test->{$method} and defined $test->{$method} and length $test->{$method} ) {
            cmp_ok( $detected->$method, '==', $test->{$method},
                "$method: $test->{$method}" );
        }
    }

    foreach my $method ( 'language', 'device', 'device_name' ) {
        if ( exists $test->{$method} and defined $test->{$method} and length $test->{$method} ) {
            cmp_ok( $detected->$method, 'eq', $test->{$method},
                "$method: $test->{$method}" );
        }  
    }


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
