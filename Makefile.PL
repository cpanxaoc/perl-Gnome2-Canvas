#
# $Header$
#

use 5.008;
use ExtUtils::MakeMaker;
use Cwd;
use File::Spec;
use ExtUtils::Depends;
use Glib::PkgConfig;
use Gtk2::CodeGen;

%pkgcfg = Glib::PkgConfig->find ('libgnomecanvas-2.0');

mkdir 'build', 0777;

#
# autogeneration
#
Gtk2::CodeGen->parse_maps ('gnomecanvasperl');
Gtk2::CodeGen->write_boot (ignore => '^Gnome2::Canvas$');

# now we're ready to start creating the makefile.
# we need to use ExtUtils::Depends to get relevant information out of
# the Glib extension, and to save config information for other modules which
# will chain from this one.

$gnome2 = ExtUtils::Depends->new ('Gnome2::Canvas', 'Gtk2', 'Glib');
$gnome2->set_inc ($pkgcfg{cflags});
$gnome2->set_libs ($pkgcfg{libs});
$gnome2->add_xs (<xs/*.xs>);
$gnome2->add_pm ('Canvas.pm' => '$(INST_LIBDIR)/Canvas.pm');
my $cwd = cwd();
$gnome2->add_typemaps (map {File::Spec->catfile($cwd,$_)} 'canvas.typemap', 'build/gnomecanvasperl.typemap');
$gnome2->add_headers ('gnomecanvasperl.h');

$gnome2->install (qw(gnomecanvasperl.h build/gnomecanvasperl-autogen.h));
$gnome2->save_config ('build/IFiles.pm');

WriteMakefile(
    NAME            => 'Gnome2::Canvas',
    VERSION_FROM    => 'Canvas.pm', # finds $VERSION
    PREREQ_PM       => {Gtk2 => 0.26}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM   => 'Canvas.pm', # retrieve abstract from module
    XSPROTOARG      => '-noprototypes',
    $gnome2->get_makefile_vars,
);

#
# there's a bug in the MakeMaker output which results in .xs files in a
# subdirectory being turned into .o files in this dir.  the bug is a missing
# -o on the compiler command line.  this is a hackish fix for it.
#
package MY;
sub const_cccmd {
	my $inherited = shift->SUPER::const_cccmd (@_);
	$inherited .= ' -o $@';
	$inherited;
}

sub postamble
{
	"
realclean ::
	-rm -Rf build
"
}
package MAIN;
