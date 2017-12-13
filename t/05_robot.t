use strict;
use warnings;

use HTTP::BrowserDetect ();
use List::Util qw( uniq );
use Test::Most;

my $detect = HTTP::BrowserDetect->new;

my %names   = $detect->_robot_names;
my %ids     = $detect->_robot_ids;

foreach my $key (uniq( keys %names, keys %ids )) {
    subtest $key => sub {
        ok( $names{$key}, 'name' );
        ok( $ids{$key},   'id' );
        unlike(
            $ids{$key}, qr{[^0-9a-z-]},
            'id contains only lower case letters or dashes'
        );
    };
}

done_testing();
