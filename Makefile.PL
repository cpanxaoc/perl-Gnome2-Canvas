#
# $Header$
#

use 5.008;
use ExtUtils::MakeMaker;
use Cwd;
use File::Spec;

# minimum required version of dependancies we need to build
our %build_reqs = (
	'perl-ExtUtils-Depends'   => '0.1',
	'perl-ExtUtils-PkgConfig' => '0.1',
	'perl-Glib'               => '1.01',
	'perl-Gtk2'               => '1.00',
	'GnomeCanvas'             => '2.0.0',
);

# minimum required version of dependancies we need to run
our %runtime_reqs = (
	'GnomeCanvas' => undef,
);

# Writing a fake Makefile ensures that CPAN will pick up the correct
# dependencies and install them.
unless (eval "use ExtUtils::Depends;"
           . "use ExtUtils::PkgConfig;"
           # just seeing if Glib is available isn't enough, make sure
           # it's recent enough, too 
           . "use Glib '$build_reqs{'perl-Glib'}';"
	   . "use Glib::MakeHelper;"
           . "use Gtk2 '$build_reqs{'perl-Gtk2'}';"
           . "use Gtk2::CodeGen;"
           . "1") {
   warn "$@\n";
   WriteMakefile(
         PREREQ_FATAL => 1,
         PREREQ_PM    => {
            Glib::                => $build_reqs{'perl-Glib'},
            Gtk2::                => $build_reqs{'perl-Gtk2'},
            ExtUtils::Depends::   => $build_reqs{'perl-ExtUtils-Depends'},
            ExtUtils::PkgConfig:: => $build_reqs{'perl-ExtUtils-PkgConfig'},
         },
   );
   exit 1; # not reached
}

%pkgcfg = ExtUtils::PkgConfig->find ('libgnomecanvas-2.0 >= '
				     .$build_reqs{GnomeCanvas});

$runtime_reqs{GnomeCanvas} = $pkgcfg{modversion};

mkdir 'build', 0777;

#
# autogeneration
#
Gtk2::CodeGen->parse_maps ('gnomecanvasperl');
Gtk2::CodeGen->write_boot (ignore => '^Gnome2::Canvas$');

@xs_files = <xs/*.xs>;
%pm_files = (
	'Canvas.pm' => '$(INST_LIBDIR)/Canvas.pm',
);
%pod_files = (
#	'Canvas.pm' => '$(INST_MAN3DIR)/Gnome2::Canvas.$(MAN3EXT)',
	Glib::MakeHelper->do_pod_files (@xs_files),
);

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
    MAN3PODS        => \%pod_files,
    $gnome2->get_makefile_vars,
);

package MY;

sub postamble
{
	return Glib::MakeHelper->postamble_clean ()
	     . Glib::MakeHelper->postamble_docs (@main::xs_files)
	     . Glib::MakeHelper->postamble_rpms (
		'GNOME_CANVAS_RUN' => $runtime_reqs{'GnomeCanvas'},
		'GNOME_CANVAS' => $build_reqs{'GnomeCanvas'},
		'PERL_EXTUTILS_DEPENDS' => 
			$build_reqs{'perl-ExtUtils-Depends'},
		'PERL_EXTUTILS_PKGCONFIG' => 
			$build_reqs{'perl-ExtUtils-PkgConfig'},
		'PERL_GLIB' => $build_reqs{'perl-Glib'},
		'PERL_GTK' => $build_reqs{'perl-Gtk2'},
	       );
}
package MAIN;
