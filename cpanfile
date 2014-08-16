requires "perl" => "5.006";
requires "strict" => "0";
requires "vars" => "0";
requires "warnings" => "0";

on 'build' => sub {
  requires "Module::Build" => "0.28";
};

on 'test' => sub {
  requires "FindBin" => "0";
  requires "JSON::PP" => "0";
  requires "Path::Tiny" => "0";
  requires "Test::FailWarnings" => "0";
  requires "Test::More" => "0";
  requires "Test::Most" => "0";
  requires "Test::NoWarnings" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "Module::Build" => "0.28";
};

on 'develop' => sub {
  requires "Test::CPAN::Changes" => "0.19";
};
