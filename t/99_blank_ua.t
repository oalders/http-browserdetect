#!/usr/bin/env perl
use strict;
use warnings;
use Test::More; 

use Test::FailWarnings;

use_ok q{HTTP::BrowserDetect};

ok my $ua = HTTP::BrowserDetect->new(undef) , q{undef produces no warnings};

done_testing();
