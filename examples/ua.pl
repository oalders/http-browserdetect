use strict;
use warnings;
use feature qw( say );

use HTTP::BrowserDetect ();

my $ua = shift || die qq{Usage: perl $0 "my UA string"};
my $h = HTTP::BrowserDetect->new($ua);

printf "robot: %s\n",      $h->robot      || q{ };
printf "robot name: %s\n", $h->robot_name || q{ };
printf "robot id: %s\n",   $h->robot_id   || q{ };
