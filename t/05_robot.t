use strict;
use warnings;

use HTTP::BrowserDetect ();
use Test::More;

my $detect = HTTP::BrowserDetect->new;

my @regexes = $detect->_robot_tests;
my %names   = $detect->_robot_names;
my %ids     = $detect->_robot_ids;

foreach my $key (@regexes) {
    subtest $key => sub {
        ok( $names{$key}, 'name' );
        ok( $ids{$key},   'id' );
        unlike( $ids{$key}, qr{[^0-9a-z-]}, 'id contains only lower case letters or dashes' );
    };
}

done_testing();
