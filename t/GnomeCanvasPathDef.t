#!/usr/bin/perl -w
use strict;
use Test::More tests => 20;
use Gnome2::Canvas;

my $def_one = Gnome2::Canvas::PathDef -> new_sized(10);
isa_ok($def_one, "Gnome2::Canvas::PathDef");
isa_ok($def_one -> duplicate(), "Gnome2::Canvas::PathDef");

my $def_two = Gnome2::Canvas::PathDef -> new();
isa_ok($def_two, "Gnome2::Canvas::PathDef");

$def_two -> ensure_space(10);

$def_one -> moveto(0, 0);
$def_two -> moveto(23, 42);

$def_one -> lineto(10, 10);
$def_two -> lineto(30, 43);

$def_one -> lineto_moving(15, 20);
$def_two -> curveto(35, 45, 50, 50, 55, 60);

ok($def_one -> has_currentpoint());
ok($def_one -> any_open());
ok($def_one -> all_open());
ok(not $def_one -> any_closed());
ok(not $def_one -> all_closed());

$def_one -> closepath_current();
$def_two -> closepath();

is($def_one -> length(), 4);
ok(not $def_one -> is_empty());

my $concat = Gnome2::Canvas::PathDef -> concat($def_one, $def_two);
isa_ok($concat, "Gnome2::Canvas::PathDef");

foreach ($concat -> split(), $concat -> open_parts(), $concat -> closed_parts()) {
  isa_ok($_, "Gnome2::Canvas::PathDef");
}

$def_one -> close_all();
$def_two -> close_all();

# $def_one -> finish();
# $def_two -> finish();

$def_one -> reset();
$def_two -> reset();
