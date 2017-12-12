use strict;
use warnings;

use HTTP::BrowserDetect ();
use Test::More;

my $detect = HTTP::BrowserDetect->new;

my @regexes = $detect->_robot_tests;
my %names = $detect->_robot_names;

foreach my $key ( @regexes ) {
    ok( $names{$key}, $key );
}

done_testing();
