use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'HTTP::BrowserDetect',
    license             => 'perl',
    dist_author         => q{Olaf Alders <olaf@wundercounter.com>},
    dist_version_from   => 'lib/HTTP/BrowserDetect.pm',
    build_requires => {
        'Data::Dump'   => 0,
        'Exporter'     => 0,
        'Test::More'   => 0,
    },
    add_to_cleanup      => [ 'HTTP-BrowserDetect-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
