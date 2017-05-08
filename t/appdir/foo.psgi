#!/usr/bin/env plackup

use 5.010;
use warnings;
use strict;

return sub {
  my ($env) = @_;

  return [200, ['Content-type' => 'text/plain'], ['foo']];
}
