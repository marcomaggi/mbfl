# Makefile.rl --
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
# Copyright (C)  2003, 2004  by Marco Maggi
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

vpath	%.m4		$(top_srcdir)/mod
vpath	%.sh.m4		$(top_srcdir)/mod
vpath	%.sh.m4		$(top_srcdir)/lib
vpath	%.sh.m4		$(top_srcdir)/examples
vpath	%.sh.m4		$(builddir)

#PAGE
## ------------------------------------------------------------
## Variables.
## ------------------------------------------------------------

M4FLAGS		= --include=$(top_srcdir)/lib \
		  --include=$(top_srcdir)/mod \
		  --include=$(builddir)

#PAGE
## ------------------------------------------------------------
## Library rules.
## ------------------------------------------------------------

MODULES			= encode file getopts message programs signal \
			  string dialog main
LIBNAME			= libmbfl.sh

library_MODULES		= $(foreach m, $(MODULES), $(m).sh.m4)
library_SOURCES		= $(foreach m, $(MODULES), $(m).sh)
library_TARGETS		= $(LIBNAME)
library_INSTLST		= $(library_TARGETS)
library_INSTDIR		= $(pkgdatadir)

library_CLEANFILES	= $(library_TARGETS) $(library_SOURCES)
library_REALCLEANFILES	= $(library_CLEANFILES)

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
	$(GREP) --invert-match -e '^#' -e '^$$' | $(SED) -e "s/^ \\+//" >$(@)

$(LIBNAME): $(library_SOURCES)
	$(M4) $(M4FLAGS) libmbfl.sh.m4 >$(@)


bin:		library-all
bin-clean:	library-clean
bin-realclean:	library-realclean
bin-install:	library-install

#page
## ------------------------------------------------------------
## Script rules.
## ------------------------------------------------------------

script_TARGETS		= mbfl.sh
script_INSTLST		= mbfl.sh
script_INSTDIR		= $(pkglibexecdir)

script_CLEANFILES	= $(script_TARGETS)
script_REALCLEANFILES	= $(script_TARGETS)

.PHONY: script-all script-clean script-realclean script-install

script-all: $(script_TARGETS)
script-clean:
	-$(RM) $(script_CLEANFILES)
script-realclean:
	-$(RM) $(script_REALCLEANFILES)

script-install:
AM_INSTALL_BIN(script)
AM_INSTALL_DIR($(bindir))
	cd $(INSTALL_ROOT)$(bindir) && \
	$(SYMLINK) $(libexecdir)/mbfl.sh

mbfl.sh:
	@echo -e "#!$(BASH)\necho $(pkgdatadir)/libmbfl.sh\n###end of file\n" >$(@)

bin:		script-all
bin-clean:	script-clean
bin-realclean:	script-realclean
bin-install:	script-install

#page
## ------------------------------------------------------------
## Macro files.
## ------------------------------------------------------------

macro_INSTLST	= $(top_srcdir)/macros/mbfl.m4
macro_INSTDIR	= $(pkgdatadir)

.PHONY: macro-install

macro-install:
AM_INSTALL_DATA(macro)

dev-install: macro-install

#PAGE
## ------------------------------------------------------------
## Template rules.
## ------------------------------------------------------------

template_SOURCES	= 
template_TARGETS	= template.sh
template_INSTLST	= $(top_srcdir)/examples/template.sh.m4
template_INSTDIR	= $(pkgdatadir)

template_CLEANFILES	= $(template_TARGETS)
template_REALCLEANFILES	= $(template_TARGETS)

.PHONY: template-all template-clean template-realclean template-install

template-all: $(template_TARGETS)
template-clean:
	-$(RM) $(template_CLEANFILES)
template-realclean:
	-$(RM) $(template_REALCLEANFILES)

template-install:
AM_INSTALL_DATA([template])


$(template_TARGETS): $(library_TARGETS)
template.sh : template.sh.m4 $(top_srcdir)/macros/mbfl.m4
	$(M4) $(M4FLAGS) $(top_srcdir)/macros/mbfl.m4 $(<) | \
	$(GREP) --invert-match -e '^#' -e '^$$' | $(SED) -e "s/^ \\+//" >$(@)


dev:		template-all
dev-clean:	template-clean
dev-realclean:	template-realclean
dev-install:	template-install


### end of file
# Local Variables:
# mode: makefile
# page-delimiter: "^#PAGE"
# End:

