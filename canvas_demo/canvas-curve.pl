package CanvasBezierCurve;
#
# canvas-curve.c: bezier curve demo.
#
# Copyright (C) 2002 Mark McLoughlin
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.
#
# Authors:
#     Mark McLoughlin <mark@skynet.ie>
#
use strict;
use Carp;
use Gnome2::Canvas;
use constant TRUE => 1;
use constant FALSE => 0;

use constant STATE_INIT          => 0;
use constant STATE_FIRST_PRESS   => 1;
use constant STATE_FIRST_RELEASE => 2;
use constant STATE_SECOND_PRESS  => 3;

my $current_state = STATE_INIT;
my $current_item;
my @current_points = ();

sub draw_curve {
	my ($item, $x, $y) = @_;
	my $root = $item->parent;

	if ($current_state == STATE_INIT) {
		#g_assert (!current_item);

#		if (!current_points)
#			current_points = gnome_canvas_points_new (4);

		$current_points[0] = $x;
		$current_points[1] = $y;

	} elsif ($current_state == STATE_FIRST_PRESS) {
		$current_points[2] = $x;
		$current_points[3] = $y;

	        my $path_def = Gnome2::Canvas::PathDef->new;

		$path_def->moveto ($current_points[0], $current_points[1]);

		$path_def->lineto ($current_points[2], $current_points[3]);

		if ($current_item) {
			$current_item->set (bpath => $path_def);
		} else {
			# FIXME FIXME FIXME FIXME FIXME FIXME 
			# we crash, very consistently, right here.
			# stack trace from GDB says it happens in
			# gnome_canvas_path_def_new_foreign, attempting
			# to verify the validity of the ArtBPath in the
			# PathDef object, deep in the bowels of
			# gnome_canvas_bpath_set_property.
			# FIXME FIXME FIXME FIXME FIXME FIXME 
			warn "FIXME FIXME FIXME FIXME FIXME FIXME\n"
			   . "i'm about to crash and burn";
			$current_item = Gnome2::Canvas::Item->new (
						$root,
						'Gnome2::Canvas::Bpath',
						bpath => $path_def,
						outline_color => 'blue',
						width_pixels => 5,
						cap_style => 'round');

			$current_item->signal_connect (event => \&item_event);
		}

		#gnome_canvas_path_def_unref (path_def);

	} elsif ($current_state == STATE_FIRST_RELEASE) {
		#g_assert (current_item);

		$current_points[4] = $x;
		$current_points[5] = $y;

	        my $path_def = Gnome2::Canvas::PathDef->new;

		$path_def->moveto ($current_points[0], $current_points[1]);

		$path_def->curveto ($current_points[4], $current_points[5],
				    $current_points[4], $current_points[5],
				    $current_points[2], $current_points[3]);

		$current_item->set (bpath => $path_def);

		#gnome_canvas_path_def_unref (path_def);

	} elsif ($current_state == STATE_SECOND_PRESS) {
		#g_assert (current_item);

		$current_points[6] = $x;
		$current_points[7] = $y;

	        my $path_def = Gnome2::Canvas::PathDef->new;

		$path_def->moveto ($current_points[0], $current_points[1]);

		$path_def->curveto ($current_points[4], $current_points[5],
				    $current_points[6], $current_points[7],
				    $current_points[2], $current_points[3]);

		$current_item->set (bpath => $path_def);

		#gnome_canvas_path_def_unref (path_def);

		$current_item = undef;

	} else {
		croak "not reached";
	}
}

sub item_event {
	my ($item, $event) = @_;
	if ($event->type eq 'button-press' &&
	    $event->button == 1 &&
	    grep {/shift-mask/} @{ $event->state }) {

		if ($item == $current_item) {
			$current_item = undef;
			$current_state = STATE_INIT;
		}

		$item->destroy;
		$item = undef;

		return TRUE;
	}

	return FALSE;
}

sub canvas_event {
	my ($item, $event) = @_;
	if ($event->type eq 'button-press') {
		return FALSE if $event->button != 1;

		if ($current_state == STATE_INIT) {
			draw_curve ($item, $event->x, $event->y);
			$current_state = STATE_FIRST_PRESS;
		} elsif ($current_state == STATE_FIRST_RELEASE) {
			draw_curve ($item, $event->x, $event->y);
			$current_state = STATE_SECOND_PRESS;
		} elsif ($current_state == STATE_SECOND_PRESS) {
			draw_curve ($item, $event->x, $event->y);
			$current_state = STATE_INIT;
		} else {
			croak "shouldn't have reached here $current_state";
		}

	} elsif ($event->type eq 'button-release') {
		return FALSE if $event->button != 1;

		if ($current_state == STATE_FIRST_PRESS) {
			draw_curve ($item, $event->x, $event->y);
			$current_state = STATE_FIRST_RELEASE;
		} else {
		}

	} elsif ($event->type eq 'motion-notify') {
		if ($current_state == STATE_FIRST_PRESS) {
			draw_curve ($item, $event->x, $event->y);
		}
	}

	return FALSE;
}

sub create_canvas {
	my $aa = shift;

#	gtk_widget_push_colormap (gdk_rgb_get_cmap ());

	my $canvas = $aa
	           ? Gnome2::Canvas->new_aa
	           : Gnome2::Canvas->new;

	$canvas->set_size_request (600, 250);
	$canvas->set_scroll_region (0, 0, 600, 250);
	$canvas->show;

	my $root = $canvas->root;

	my $item = Gnome2::Canvas::Item->new ($root,
				      'Gnome2::Canvas::Rect',
				      outline_color => 'black',
				      fill_color => 'white',
				      x1 => 0.0,
				      y1 => 0.0,
				      x2 => 600.0,
				      y2 => 250.0);

	Gnome2::Canvas::Item->new ($root,
			       'Gnome2::Canvas::Text',
			       text => ($aa ? "AntiAlias" : "Non-AntiAlias"),
			       x => 270.0,
			       y => 5.0,
			       font => 'Sans 12',
			       anchor => 'n',
			       fill_color => 'black');

#	gtk_widget_pop_colormap ();

	$item->signal_connect (event => \&canvas_event);

	my $frame = Gtk2::Frame->new;
	$frame->set_shadow_type ('in');

	$frame->add ($canvas);

	return $frame;
}

sub create {
	my $vbox = Gtk2::VBox->new (FALSE, 4);
	$vbox->set_border_width (4);
	$vbox->show;

	my $label = Gtk2::Label->new ("Drag a line with button 1. Then mark 2 control points wth\n"
			      ."button 1. Shift+click with button 1 to destroy the curve.\n");
	$vbox->pack_start ($label, FALSE, FALSE, 0);
	$label->show;

	my $canvas = create_canvas (FALSE);
	$vbox->pack_start ($canvas, TRUE, TRUE, 0);
	$canvas->show;

	my $aa_canvas = create_canvas (TRUE);
	$vbox->pack_start ($aa_canvas, TRUE, TRUE, 0);
	$aa_canvas->show;

	return $vbox;
}


1;
