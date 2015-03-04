#!/usr/bin/perl -w

# Script for making regression test patterns.
#
# Recommended use:
#
# $ perl -I../lib make-more-useragents.pl < /wherever/apache.log > more-useragents.json
#
# This will create a test suite based on any user agents that seem at
# all dissimilar to ones we're already testing. The answers are given
# by the same code that the test suite runs against, meaning the tests
# will start out all passing. The main usefulness is:
#
# (a) You can make -I different, getting the answers according to a
# different version of the code, and then run it against the current
# version to see what's different.
#
# (b) You can manually inspect the more-useragents.json file and see
# if there are any results in it that don't make sense.
#
# (c) Any changes in behavior in the future will cause a test failure.

use strict;

use FindBin;
use JSON::PP;
use Path::Tiny qw( path );

use HTTP::BrowserDetect;

my $json_text = path("$FindBin::Bin/useragents.json")->slurp;
my $tests     = JSON::PP->new->ascii->decode($json_text);

my %seen_tokens;

foreach my $ua ( sort keys %{$tests} ) {
    my @tokens = ( $ua =~ m{ (\w+) }g );
    foreach (@tokens) {
        $seen_tokens{$_} = 1;
    }
}

my %new_tests;

while (<>) {

    # Match tokens, either single words or quote- or bracket-delimited strings
    my @tokens = (
        $_ =~ m{ ( \"  [^\"]*      \"   |
                                  [^\[\]\"\s]+       |
                              \[  [^\[\]]*    \]   )
                    }xg
    );
    my ($ua) = ( $tokens[8] =~ m{\"(.*)\"} ) or next;
    @tokens = ( $ua =~ m{ (\w+) }g );    # Words within the user agent
    my $added = 0;
    foreach my $word (@tokens) {
        if ( !$seen_tokens{ lc $word } && !$added ) {
            my $test = {
                match => [],
            };

            my $detect = HTTP::BrowserDetect->new($ua);

            foreach my $method (
                qw(
                browser_string
                engine_string
                os_string
                os_version
                public_version
                public_major
                public_minor
                public_beta
                version
                major
                minor
                beta
                engine_version
                engine_major
                engine_minor
                language
                device
                device_name
                robot_name
                os_string )
                ) {
                my $result = $detect->$method;

                if ( defined($result) ) {
                    $test->{$method} = $result;
                }
            }

            for my $prop ( 'device', @HTTP::BrowserDetect::ALL_TESTS ) {
                if ( $detect->$prop ) {
                    push @{ $test->{match} }, $prop;
                }
            }

            $new_tests{$ua} = $test;
            $added = 1;
        }
        $seen_tokens{ lc $word } = 1;
    }
}

my $json   = JSON::PP->new->canonical->pretty;
my $output = $json->encode( \%new_tests );
print "$output\n";
