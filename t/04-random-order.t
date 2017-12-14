#!/usr/bin/perl

use strict;
use warnings;

use Test::Most;
use Test::FailWarnings;

use FindBin;
use JSON::PP;
use Path::Tiny qw( path );

# test that the module loads without errors
my $w;
{
    local $SIG{__WARN__} = sub { $w = shift };
    require HTTP::BrowserDetect;
}
ok( !$w, 'no warnings on require' );

my $json  = path("$FindBin::Bin/useragents.json")->slurp;
my $tests = JSON::PP->new->ascii->decode($json);

$json = path("$FindBin::Bin/more-useragents.json")->slurp;
my $more_tests = JSON::PP->new->ascii->decode($json);
$tests = { %$tests, %$more_tests };

srand(88);    # Consistent seed for consistent results

my $N_DETECTS = 5;
my $N_TESTS   = 30;

my @detect;

my @methods = (
    qw(
        beta
        browser
        browser_properties
        browser_string
        country
        device
        device
        device_name
        device_string
        engine
        engine_beta
        engine_major
        engine_minor
        engine_string
        engine_version
        engine_major
        engine_minor
        gecko_version
        language
        major
        minor
        os
        os_beta
        os_major
        os_minor
        os_string
        os_version
        public_major
        public_minor
        public_version
        realplayer_browser
        robot_string
        version
        ), &HTTP::BrowserDetect::_all_tests()
);

foreach my $ua ( sort ( keys %{$tests} ) ) {

    my %test_results;

    subtest $ua, sub {
        for my $i ( 0 .. $N_DETECTS - 1 ) {
            $detect[$i] = HTTP::BrowserDetect->new($ua);

            for my $j ( 1 .. $N_TESTS ) {
                my $method = $methods[ int( rand(@methods) ) ];
                my $result = $detect[$i]->$method;
                if ( exists( $test_results{$method} ) ) {
                    if ( !defined($result) ) {
                        ok( !defined( $test_results{$method} ), $method );
                    }
                    elsif ( ref($result) eq 'ARRAY' ) {
                        is_deeply( $result, $test_results{$method}, $method );
                    }
                    else {
                        cmp_ok(
                            $result, 'eq', $test_results{$method},
                            $method
                        );
                    }
                }
                else {
                    $test_results{$method} = $result;
                }
            }
        }
    };
}
done_testing();
