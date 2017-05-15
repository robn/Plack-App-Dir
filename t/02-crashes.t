#!perl

use warnings;
use strict;

use Test::More;
use Test::Exception;
use Plack::App::Dir;

throws_ok {
  Plack::App::Dir->new(dir => './t/no_appdir');
} qr/dir '.+' doesn't exist/, "crashes when appdir not found";

throws_ok {
  Plack::App::Dir->new(dir => './t/crash_appdir');
} qr/compile failure/, "propagates crash during app compile";

done_testing;
