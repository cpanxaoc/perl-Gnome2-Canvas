#
# $Header$
#

package Gnome2::Canvas;

use 5.008;
use strict;
use warnings;

use Gtk2;

require DynaLoader;

our @ISA = qw(DynaLoader);

our $VERSION = '0.90';

sub dl_load_flags { 0x01 }

bootstrap Gnome2::Canvas $VERSION;

# Preloaded methods go here.

1;
__END__

# this pod is included in the pod generated for Gnome2::Canvas from
# the xs source by Glib::GenPod.  NAME is not necessary.

=head1 SYNOPSIS

  use Gtk2 -init;
  use Gnome2::Canvas;
  $win = Gtk2::Window->new;
  $frame = Gtk2::Frame->new;
  $canvas = Gnome2::Canvas->new;
  $frame->add ($canvas);
  $window->add ($frame);
  $window->show_all;
  
  $root = $canvas->root;
  $item = Gnome2::Canvas::Item->new ($root, 'Gnome2::Canvas::Text',
                                     x => $x,
                                     y => $y,
                                     fill_color => 'black',
                                     font => 'Sans 14',
                                     anchor => 'GTK_ANCHOR_NW');
  $box = Gnome2::Canvas::Item->new ($root, 'Gnome2::Canvas::Rect',
                                    fill_color => undef,
                                    outline_color => 'black',
                                    width_pixels => 0);
  $box->signal_connect (event => \&do_box_events);
  
  Gtk2->main;

=head1 DESCRIPTION

The Gnome2::Canvas module allows a perl developer to use the Gnome Canvas.
The Gnome Canvas is a high-level engine for structured graphics; see 
Frederico Mena Quintero's whitepaper for more info:
http://developer.gnome.org/doc/whitepapers/canvas/canvas.html

Like the Gtk2 module on which it depends, Gnome2::Canvas follows the C API
of libgnomecanvas-2.0 as closely as possible while still being perlish.
Thus, the C API reference remains the canonical documentation; the Perl
reference documentation lists call signatures and argument types, and is
meant to be used in conjunction with the C API reference.

To discuss gtk2-perl, ask questions and flame/praise the authors,
join gtk-perl-list@gnome.org at lists.gnome.org.

=head1 SEE ALSO

perl(1), Glib(3pm), Gtk2(3pm), GNOME Canvas Library Reference Manual
http://developer.gnome.org/doc/API/2.0/libgnomecanvas/index.html

Gnome2::Canvas::index(3pm) lists the generated Perl API reference PODs.

=head1 AUTHOR

muppet <scott at asofyet dot org>, with patches from
Torsten Schoenfeld <kaffetisch at web dot de>.

=head1 COPYRIGHT AND LICENSE

Copyright 2003-2004 by the gtk2-perl team.

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
