/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the 
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
 * Boston, MA  02111-1307  USA.
 *
 * $Header$
 */

#ifndef _GNOME2PERL_H_
#define _GNOME2PERL_H_

#include <gtk2perl.h>
///#undef _ /* gnome and perl disagree on this one */
#include <libgnomecanvas/libgnomecanvas.h>
#include "gnomecanvasperl-autogen.h"


/* special handling for libart affine transform arrays */
SV * newSVArtAffine (double affine[6]);
double * SvArtAffine (SV * sv);

/* custom boxed wrapper for GnomeCanvasPathDef, since the library doesn't 
 * supply one. */
#define GNOME_TYPE_CANVAS_PATH_DEF	(gnomecanvasperl_canvas_path_def_get_type())
GType gnomecanvasperl_canvas_path_def_get_type (void) G_GNUC_CONST;

#ifdef GNOME_TYPE_CANVAS_PATH_DEF
  /* GBoxed GnomeCanvasPathDef */
  typedef GnomeCanvasPathDef GnomeCanvasPathDef_ornull;
# define SvGnomeCanvasPathDef(sv)	(gperl_get_boxed_check ((sv), GNOME_TYPE_CANVAS_PATH_DEF))
# define SvGnomeCanvasPathDef_ornull(sv)	(((sv) && SvTRUE (sv)) ? SvGnomeCanvasPathDef (sv) : NULL)
  typedef GnomeCanvasPathDef GnomeCanvasPathDef_own;
  typedef GnomeCanvasPathDef GnomeCanvasPathDef_copy;
  typedef GnomeCanvasPathDef GnomeCanvasPathDef_own_ornull;
# define newSVGnomeCanvasPathDef(val)	(gperl_new_boxed ((val), GNOME_TYPE_CANVAS_PATH_DEF, FALSE))
# define newSVGnomeCanvasPathDef_own(val)	(gperl_new_boxed ((val), GNOME_TYPE_CANVAS_PATH_DEF, TRUE))
# define newSVGnomeCanvasPathDef_copy(val)	(gperl_new_boxed_copy ((val), GNOME_TYPE_CANVAS_PATH_DEF))
# define newSVGnomeCanvasPathDef_own_ornull(val)	((val) ? newSVGnomeCanvasPathDef_own(val) : &PL_sv_undef)
#endif /* GNOME_TYPE_CANVAS_PATH_DEF */

#endif /* _GNOME2PERL_H_ */
