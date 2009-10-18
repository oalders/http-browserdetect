use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'HTTP::BrowserDetect',
    'VERSION_FROM' => 'BrowserDetect.pm', # finds $VERSION
    'dist' => { PREOP=>'perldoc -t BrowserDetect.pm > README', COMPRESS=>"gzip", SUFFIX=>"gz" },
);
