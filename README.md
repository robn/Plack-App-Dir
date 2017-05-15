[![Build Status](https://secure.travis-ci.org/robn/Plack-App-Dir.png)](http://travis-ci.org/robn/Plack-App-Dir)

# NAME

Plack::App::Dir - make a directory full of PSGI apps into a single app

# SYNOPSIS

    use Plack::App::Dir;
    
    Plack::App::Dir->new(
      dir => '/path/to/apps',
    )->to_app;

# DESCRIPTION

So you've got a bunch of `.psgi` files that you want to run. You'll usually
either run a bunch of separate servers via `plackup`, or you'll run them
through a single server with some sort of router or even [Plack::Builder](https://metacpan.org/pod/Plack::Builder) to
hook them all up.

Instead, use [Plack::App::Dir](https://metacpan.org/pod/Plack::App::Dir). Point it at a directory full of `.psgi`
files. It will give you a single PSGI app back, with all the PSGI files in that
dir mounted by their name, such that when you request an endpoint like `/foo`,
`foo.psgi` will be called.

# SUPPORT

## Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at [https://github.com/robn/Plack-App-Dir/issues](https://github.com/robn/Plack-App-Dir/issues).
You will be notified automatically of any progress on your issue.

## Source Code

This is open source software. The code repository is available for
public review and contribution under the terms of the license.

[https://github.com/robn/Plack-App-Dir](https://github.com/robn/Plack-App-Dir)

    git clone https://github.com/robn/Plack-App-Dir.git

# AUTHORS

- Rob N ★ <rob@robn.io>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Rob N ★

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
