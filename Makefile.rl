# $Id: Makefile.rl,v 1.34 2004/02/05 09:53:52 marco Exp $
#
# Part of: Marco's BASH Functions Library
# Contents: project rules
# Date: Sat Apr 19, 2003
#
# Abstract
#
#	This Makefile must be processed by the "automake.sh" script
#	and by GNU Autoconf: read the README and INSTALL files for
#	more details.
#
# Copyright (C) 2003  by Marco Maggi
#
# This library is free software;  you can redistribute it and/or modify
# it  under the  terms  of the  GNU  Lesser General  Public License  as
# published by the Free Software  Foundation; either version 2.1 of the
# License, or (at your option) any later version.
# 
# This library is  distributed in the hope that it  will be useful, but
# WITHOUT  ANY   WARRANTY;  without   even  the  implied   warranty  of
# MERCHANTABILITY  or FITNESS FOR  A PARTICULAR  PURPOSE.  See  the GNU
# Lesser General Public License for more details.
# 
# You  should have received  a copy  of the  GNU Lesser  General Public
# License along with  this library; if not, write  to the Free Software
# Foundation, Inc.,  59 Temple Place, Suite 330,  Boston, MA 02111-1307
# USA
#

#PAGE
## ------------------------------------------------------------
## Search paths.
## ------------------------------------------------------------

vpath	%.m4		$(top_srcdir)/src/mod
vpath	%.sh.m4		$(top_srcdir)/src/mod
vpath	%.sh.m4		$(top_srcdir)/src/lib
vpath	%.sh.m4		$(top_srcdir)/src/examples
vpath	%.sh.m4		$(builddir)

#PAGE
## ------------------------------------------------------------
## Variables.
## ------------------------------------------------------------

M4FLAGS		= --include=$(top_srcdir)/src/lib \
		  --include=$(top_srcdir)/src/mod \
		  --include=$(builddir)

#PAGE
## ------------------------------------------------------------
## Library rules.
## ------------------------------------------------------------

MODULES			= encode file getopts message programs signal \
			  string dialog
LIBNAME			= libMBFL.sh

library_MODULES		= $(foreach m, $(MODULES), $(m).sh.m4)
library_SOURCES		= $(foreach m, $(MODULES), $(m).sh)
library_TARGETS		= $(LIBNAME)
library_INSTLST		= $(library_TARGETS)
library_INSTDIR		= $(pkglibdir)

library_CLEANFILES	= $(library_TARGETS) $(library_SOURCES)

.PHONY: library-all library-clean library-realclean library-install

library-all: $(library_TARGETS)
library-clean:
	-$(RM) $(library_CLEANFILES)
library-realclean:
	-$(RM) $(library_REALCLEANFILES)

library-install:
AM_INSTALL_DATA(library)


$(library_SOURCES): %.sh: %.sh.m4 macros.m4
	$(M4) $(M4FLAGS) $(<) | \
	grep --invert-match -e '^#' -e '^$$' | sed -e "s/^ \\+//" >$(@)

$(LIBNAME): $(library_SOURCES)
	$(M4) $(M4FLAGS) libMBFL.sh.m4 >$(@)


dev:		library-all
dev-clean:	library-clean
dev-realclean:	library-realclean
dev-install:	library-install

#PAGE
## ------------------------------------------------------------
## Template rules.
## ------------------------------------------------------------

template_SOURCES	= 
template_TARGETS	= template.sh
template_INSTLST	= $(top_srcdir)/src/examples/template.sh.m4
template_INSTDIR	= $(pkgdatadir)

.PHONY: template-all template-clean template-realclean template-install

template-all: $(template_TARGETS)
template-clean:
	-$(RM) $(template_TARGETS)
template-realclean:
	-$(RM) $(template_REALCLEANFILES)

template-install:
AM_INSTALL_DATA([template])


$(template_TARGETS): $(scripts_TARGETS)

dev:		template-all
dev-clean:	template-clean
dev-realclean:	template-realclean
dev-install:	template-install


### end of file
# Local Variables:
# mode: makefile
# page-delimiter: "^#PAGE"
# End:

