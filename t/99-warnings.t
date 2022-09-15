#!/usr/bin/env perl

use strict;
use warnings;

use HTTP::BrowserDetect ();
use Test::Warnings;
use Test::More import => [qw( done_testing is ok subtest )];

ok( my $ua = HTTP::BrowserDetect->new(undef), 'undef produces no warnings' );

subtest 'no warnings on fake MSIE' => sub {
    my $ua = HTTP::BrowserDetect->new(
        'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Trident/F3E)');
    is( $ua->engine_version, undef, 'undef browser_version' );
    is( $ua->engine_major,   undef, 'undef engine_major' );
    is( $ua->engine_minor,   undef, 'undef engine_minor' );
    is( $ua->engine_beta,    undef, 'undef engine_beta' );
};

done_testing();
