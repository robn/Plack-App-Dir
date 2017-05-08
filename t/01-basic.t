#!perl

use warnings;
use strict;

use Test::More;
use Plack::App::Dir;
use Plack::Test;
use HTTP::Request::Common;

my $app = Plack::App::Dir->new(
  dir => './t/appdir',
)->to_app;

test_psgi $app, sub {
  my $cb = shift;
  my $res = $cb->(GET "/foo");
  is($res->code, 200, "/foo success");
  is($res->content, "foo", "/foo correct content");
};

test_psgi $app, sub {
  my $cb = shift;
  my $res = $cb->(GET "/bar");
  is($res->code, 200, "/bar success");
  is($res->content, "bar", "/bar correct content");
};

test_psgi $app, sub {
  my $cb = shift;
  my $res = $cb->(GET "/baz");
  is($res->code, 200, "/baz success");
  is($res->content, "baz", "/baz correct content");
};

test_psgi $app, sub {
  my $cb = shift;
  my $res = $cb->(GET "/quux");
  is($res->code, 404, "/quux fail");
};

done_testing;
