#
# $Header$
#

package Gnome2::Canvas;

use 5.008;
use strict;
use warnings;

use Gtk2;

require Exporter;
require DynaLoader;

our @ISA = qw(Exporter DynaLoader);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Gnome2 ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.20';

sub dl_load_flags { 0x01 }

bootstrap Gnome2::Canvas $VERSION;

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Gnome2::Canvas - Perl interface to the Gnome Canvas

=head1 SYNOPSIS

  use Gnome2::Canvas;
  Gnome2::Program->init ($appname, $appversion);
  my $app = Gnome2::App->new ($appname);
  $app->show;
  Gtk2->main;

=head1 ABSTRACT

  Perl bindings to the 2.x series of the Gtk+ widget set.
  This module allows you to write graphical user interfaces in a perlish
  and object-oriented way, freeing you from the casting and memory 
  management in C, yet remaining very close in spirit to original API.

=head1 DESCRIPTION

The Gnome2 module allows a perl developer to use the Gnome libraries.
Find out more about Gnome+ at http://www.gnome.org.

To discuss gtk2-perl, ask questions and flame/praise the authors,
join gtk-perl-list@gnome.org at lists.gnome.org.

If you have a web site set up for your module, mention it here.

FIXME we have no other documentation, but we probably need it.

=head1 SEE ALSO

perl(1), Glib(1), Gtk2(1).

=head1 AUTHOR

muppet E<lt>scott@asofyet.orgE<gt>

If you want to own this project, please let me know.

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by the gtk2-perl team.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the 
Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
Boston, MA  02111-1307  USA.

=cut
