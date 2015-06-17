#!/usr/bin/env perl

use strict;
use warnings;

use HTTP::BrowserDetect;
use Test::More;
use Test::FailWarnings;

ok( my $ua = HTTP::BrowserDetect->new(undef), q{undef produces no warnings} );

done_testing();
