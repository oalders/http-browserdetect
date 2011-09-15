#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use HTTP::BrowserDetect;


my $browser = HTTP::BrowserDetect->new( "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0)" );

ok (!$browser->language, "no language detected");
diag( $browser->language );
done_testing();
