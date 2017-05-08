package Plack::App::Dir;

# ABSTRACT: make a directory full of PSGI apps into a single app

use 5.010;
use warnings;
use strict;

use Moo;
use Types::Standard qw(Str);
use Path::Tiny;

has dir => ( is => 'ro', isa => Str, required => 1 );

sub to_app {
  my ($self) = @_;

  state $apps = {};

  return sub {
    my ($env) = @_;
    
    my ($app_name, $req_uri) = $env->{REQUEST_URI} =~ m{^/([^\/]+)(.*)$};
    $req_uri ||= '/';

    my $app = do {
      my $app_path = path($self->dir, "$app_name.psgi");

      $apps->{$app_name} ||= do {
        if ($app_path->is_file) {
          do $app_path;
        }
        else {
          sub { [ 404, [], [] ] };
        }
      }
    };

    $env->{REQUEST_URI} = $req_uri;
    $app->($env);
  };
}

1;

__END__

=pod

=encoding UTF-8

=for markdown [![Build Status](https://secure.travis-ci.org/robn/Plack-App-Dir.png)](http://travis-ci.org/robn/Plack-App-Dir)

=head1 NAME

Plack::App::Dir - make a directory full of PSGI apps into a single app

=head1 SYNOPSIS

    use Plack::App::Dir;
    
    Plack::App::Dir->new(
      dir => '/path/to/apps',
    )->to_app;

=head1 DESCRIPTION

So you've got a bunch of C<.psgi> files that you want to run. You'll usually
either run a bunch of separate servers via C<plackup>, or you'll run them
through a single server with some sort of router or even L<Plack::Builder> to
hook them all up.

Instead, use L<Plack::App::Dir>. Point it at a directory full of C<.psgi>
files. It will give you a single PSGI app back. When you request some endpoint,
like C</foo>, it will try to load C<foo.psgi> and if that works, pass the
request on to it.

=head1 SUPPORT

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at L<https://github.com/robn/Plack-App-Dir/issues>.
You will be notified automatically of any progress on your issue.

=head2 Source Code

This is open source software. The code repository is available for
public review and contribution under the terms of the license.

L<https://github.com/robn/Plack-App-Dir>

  git clone https://github.com/robn/Plack-App-Dir.git

=head1 AUTHORS

=over 4

=item *

Rob N ★ <rob@robn.io>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Rob N ★

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
