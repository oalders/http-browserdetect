#!/usr/bin/perl

use strict;
use warnings;

use Test::Most;
use Test::FailWarnings;

use FindBin;
use JSON::PP;
use List::Util qw();
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

my @robot_tests = HTTP::BrowserDetect->_robot_tests;

foreach my $ua ( sort ( keys %{$tests} ) ) {

    my $test = $tests->{$ua};

    my $detected = HTTP::BrowserDetect->new($ua);
    subtest $ua => sub {

        foreach my $method (
            'browser',     'browser_beta', 'browser_string', 'device',
            'device_beta', 'device_name',  'device_string',  'engine',
            'engine_beta', 'engine_string', 'language', 'os', 'os_beta',
            'os_string', 'robot', 'robot_beta', 'robot_name', 'robot_string',
            ) {
            if ( $test->{$method} ) {
                cmp_ok(
                    $detected->$method || q{}, 'eq', $test->{$method},
                    "$method: $test->{$method}"
                );
            }
        }

        foreach my $method (
            qw(
            os_version
            os_major
            os_minor
            public_version
            public_major
            public_minor
            robot_version
            robot_major
            robot_minor
            version
            major
            minor
            engine_version
            engine_major
            engine_minor
            ios
            tablet
            )
            ) {

            if (    exists $test->{$method}
                and defined $test->{$method}
                and length $test->{$method} ) {
                cmp_ok(
                    $detected->$method, '==', $test->{$method},
                    "$method: $test->{$method}"
                );
            }
        }

        foreach my $type ( @{ $test->{match} } ) {
            # New bots aren't getting added to methods
            next if List::Util::any { lc($type) eq lc($_ )} @robot_tests;
            ok(
                $detected->can($type) && $detected->$type,
                "$type should match"
            );
        }

        eq_or_diff(
            [ sort $detected->browser_properties() ],
            [ sort @{ $test->{match} } ],
            "browser properties match"
        );

        # Test that $ua doesn't match a specific method
        foreach my $type ( @{ $test->{no_match} } ) {
            ok( !$detected->$type, "$type shouldn't match (and doesn't)" );
        }

    };
}

my $detected = HTTP::BrowserDetect->new('Nonesuch');
diag( $detected->user_agent );

foreach my $method (
    qw(
    engine_string
    engine_version
    engine_major
    engine_minor
    device
    device_name
    gecko_version
    )
    ) {
    is_deeply(
        [ $detected->$method ],
        [undef], "$method should return undef in list context"
    );
}

done_testing();
