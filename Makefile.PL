#
# $Header$
#

use 5.008;
use ExtUtils::MakeMaker;
use Cwd;
use File::Spec;

# minimum required versions of Gtk2 and Glib with which we can work.
my $req_glib_ver = '0.97';
my $req_gtk2_ver = '0.97';

# Writing a fake Makefile ensures that CPAN will pick up the correct
# dependencies and install them.
unless (eval "use ExtUtils::Depends;"
           . "use Glib::PkgConfig;"
           # just seeing if Glib is available isn't enough, make sure
           # it's recent enough, too 
           . "use Glib $req_glib_ver;"
           . "use Gtk2 $req_gtk2_ver;"
           . "use Gtk2::CodeGen;"
           . "1") {
   warn "$@\n";
   WriteMakefile(
         PREREQ_FATAL => 1,
         PREREQ_PM    => {
            Glib::              => $req_glib_ver, # keep this in sync
            Gtk2::              => $req_gtk2_ver, # keep this in sync
            ExtUtils::Depends:: => 0.1,
         },
   );
   exit 1; # not reached
}

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
use Cwd;

sub const_cccmd {
	my $inherited = shift->SUPER::const_cccmd (@_);
	$inherited .= ' -o $@';
	$inherited;
}

sub postamble
{
	my @dirs = qw{rpms rpms/BUILD rpms/RPMS rpms/SOURCES
		      rpms/SPECS rpms/SRPMS};
	my $cwd = getcwd();

	"
realclean ::
	-rm -Rf build

rpms/:
	-mkdir @dirs

perl-\$(DISTNAME).spec: perl-\$(DISTNAME).spec.in
	sed -e \"s/\@VERSION\@/\$(VERSION)/g\" -e \"s/\@SOURCE\@/\$(DISTNAME)-\$(VERSION).tar.gz/g\" \$< > \$@

dist-rpms: Makefile dist perl-\$(DISTNAME).spec rpms/
	cp \$(DISTNAME)-\$(VERSION).tar.gz rpms/SOURCES/
	rpmbuild -ba --define \"_topdir $cwd/rpms\" perl-\$(DISTNAME).spec
"
}
package MAIN;
