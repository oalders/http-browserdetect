#!/usr/bin/perl

use strict;
use warnings;

use Data::Dump qw( dump );
use File::Slurp;
use FindBin;
use JSON::PP;
use Test::More qw( no_plan );

# test that the module loads without errors
my $w;
{
    local $SIG{__WARN__} = sub { $w = shift };
    require_ok( 'HTTP::BrowserDetect' );
}
ok !$w;


my $json  = read_file( "$FindBin::Bin/useragents.json" );

my $tests = JSON::PP->new->ascii->decode( $json );

foreach my $ua ( sort keys %{$tests} ) {

    my $test = $tests->{$ua};

    #diag( dump $test );

    my $detected = HTTP::BrowserDetect->new( $ua );
    diag( $detected->user_agent );

    foreach my $method ( 'browser_string', 'engine_string', ) {
        if ( $test->{$method} ) {
            cmp_ok( $detected->$method, 'eq', $test->{$method},
                "$method: $test->{$method}" );
        }
    }

    foreach my $method (
        qw(
        public_version
        public_major
        public_minor
        version
        major
        minor
        engine_version
        engine_major
        engine_minor
        ios
        )
        )
    {

        if (    exists $test->{$method}
            and defined $test->{$method}
            and length $test->{$method} )
        {
            cmp_ok( $detected->$method, '==', $test->{$method},
                "$method: $test->{$method}" );
        }
    }

    foreach my $method ( 'language', 'device', 'device_name' ) {
        if (    exists $test->{$method}
            and defined $test->{$method}
            and length $test->{$method} )
        {
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

    is_deeply(
        [ sort $detected->browser_properties() ],
        [ sort @{ $test->{match} } ],
        "browser properties match"
    );

    # Test that $ua doesn't match a specific method
    foreach my $type ( @{ $test->{no_match} } ) {
        ok( !$detected->$type, "$type shouldn't match (and doesn't)" );
    }

}
