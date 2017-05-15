package Plack::App::Dir;

# ABSTRACT: make a directory full of PSGI apps into a single app

use 5.010;
use warnings;
use strict;

use parent 'Plack::Component';

use Moo;
use Types::Standard qw(Str);
use Type::Utils qw(class_type);

use Path::Tiny;
use Carp qw(croak);
use Plack::App::URLMap;

has dir     => ( is => 'ro',   isa => Str, required => 1 );
has _urlmap => ( is => 'lazy', isa => class_type('Plack::App::URLMap'),
                 default => sub { Plack::App::URLMap->new } );

sub BUILD {
  my ($self, $args) = @_;

  my $path = path($self->dir);
  croak "dir '$path' doesn't exist" unless $path->is_dir;

  for my $app_path ($path->children(qr/\.psgi$/)) {
    my $app_name = $app_path->basename('.psgi');
    my $app = do $app_path;
    die $@ if $@;
    $self->_urlmap->map("/$app_name" => $app);
  }
}

# crappy delegation
sub prepare_map { shift->_urlmap->prepare_map(@_) }
sub to_app      { shift->_urlmap->to_app(@_) }
sub response_cb { shift->_urlmap->response_cb(@_) }

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
files. It will give you a single PSGI app back, with all the PSGI files in that
dir mounted by their name, such that when you request an endpoint like C</foo>,
C<foo.psgi> will be called.

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
