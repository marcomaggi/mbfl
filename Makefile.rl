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

vpath	%.m4		$(top_srcdir)/macros
vpath	%.sh.m4		$(top_srcdir)/modules
vpath	%.sh.m4		$(top_srcdir)/lib
vpath	%.sh.m4		$(top_srcdir)/examples
vpath	%.sh.m4		$(builddir)

ds-files-from-dir	= $(filter-out %~, $(wildcard $(1)/*))
ds-make-dir		= $(shell test ! -d $(1) && $(MKDIR) $(1))
ds-replace-dir		= $(addprefix $(1)/, $(notdir $(2)))

M4FLAGS		= --include=$(top_srcdir)/macros \
		  --include=$(builddir)/lib

#PAGE
## ------------------------------------------------------------
## Library rules.
## ------------------------------------------------------------

library_SRCDIR		= $(top_srcdir)/modules
library_BUILDDIR	= $(builddir)/lib

MODULES			= base encode file getopts message program signal \
			  string dialog main variable
LIBNAME			= libmbfl.sh
LIBRARIES		= $(top_srcdir)/lib/libmbfltest.sh

library_MODULES		= $(foreach m, $(MODULES), $(m).sh.m4)
library_SOURCES		= $(addprefix $(library_BUILDDIR)/, \
				$(foreach m, $(MODULES), $(m).sh))
library_TARGETS		= $(LIBNAME)
library_INSTLST		= $(library_TARGETS) $(LIBRARIES)
library_INSTDIR		= $(pkgdatadir)

library_CLEANFILES	= $(library_TARGETS) $(library_SOURCES) $(library_BUILDDIR)
library_REALCLEANFILES	= $(library_CLEANFILES)

.PHONY: library-all library-clean library-realclean library-install

library-all: $(call ds-make-dir, $(library_BUILDDIR)) $(library_TARGETS)
library-clean:
	-$(RM) $(library_CLEANFILES)
library-realclean:
	-$(RM) $(library_REALCLEANFILES)

library-install:
AM_INSTALL_DATA(library)


$(library_SOURCES): $(library_BUILDDIR)/%.sh: macros.m4 $(library_SRCDIR)/%.sh.m4
	$(M4) $(M4FLAGS) $(^) | \
	$(GREP) --invert-match -e '^#' -e '^$$' | $(SED) -e "s/^ \\+//" >$(@)

$(LIBNAME): libmbfl.sh.m4 $(library_SOURCES)
	$(M4) $(M4FLAGS) $(<) >$(@)


bin:		library-all
bin-clean:	library-clean
bin-realclean:	library-realclean
bin-install:	library-install

#page
## ------------------------------------------------------------
## Script rules.
## ------------------------------------------------------------

libexec_INSTLST		= mbfl-config
libexec_INSTDIR		= $(pkglibexecdir)

binscript_INSTLST	= mbfl-config
binscript_INSTDIR	= $(bindir)

libexec_CLEANFILES	= $(script_TARGETS)
libexec_REALCLEANFILES	= $(libexec_CLEANFILES)

.PHONY: script-all script-clean script-realclean script-install

script-all: $(libexec_TARGETS)
script-clean:
	-$(RM) $(libexec_CLEANFILES)
script-realclean:
	-$(RM) $(libexec_REALCLEANFILES)

script-install:
AM_INSTALL_BIN(libexec)
AM_INSTALL_BIN(binscript)

bin:		script-all
bin-clean:	script-clean
bin-realclean:	script-realclean
bin-install:	script-install

#page
## ------------------------------------------------------------
## User scripts rules.
## ------------------------------------------------------------

user_SRCDIR	= $(top_srcdir)/user
user_BUILDDIR	= $(builddir)/user

user_SOURCES	= $(call ds-files-from-dir, $(user_SRCDIR))
user_TARGETS	= $(call ds-replace-dir, $(user_BUILDDIR), $(user_SOURCES))
user_INSTLST	= $(user_TARGETS)
user_INSTDIR	= $(libexecdir)/mbfluser_$(PACKAGE_XVERSION)

user_CLEANFILES		= $(user_TARGETS) $(user_BUILDDIR)
user_REALCLEANFILES	= $(user_CLEANFILES)

.PHONY: user-all user-clean user-realclean user-install 

user-all: $(call ds-make-dir, $(user_BUILDDIR)) $(user_TARGETS)
user-clean: 
	-$(RM) $(user_CLEANFILES)
user-realclean: 
	-$(RM) $(user_REALCLEANFILES)
user-install: 
AM_INSTALL_BIN(user)

$(user_TARGETS): $(user_BUILDDIR)/% : $(user_SRCDIR)/%
	{ echo "#!/bin/bash" && cat $(<) ; } >$(@)
	chmod 0700 $(@)

bin:		user-all
bin-clean:	user-clean
bin-realclean:	user-realclean
bin-install:	user-install

#page
## ------------------------------------------------------------
## Vc scripts rules.
## ------------------------------------------------------------

vc_SRCDIR	= $(top_srcdir)/vc
vc_BUILDDIR	= $(builddir)/vc

vc_SOURCES	= $(call ds-files-from-dir, $(vc_SRCDIR))
vc_TARGETS	= $(call ds-replace-dir, $(vc_BUILDDIR), $(vc_SOURCES))
vc_INSTLST	= $(vc_TARGETS)
vc_INSTDIR	= $(libexecdir)/mbflvc_$(PACKAGE_XVERSION)

vc_CLEANFILES		= $(vc_TARGETS) $(vc_BUILDDIR)
vc_REALCLEANFILES	= $(vc_CLEANFILES)

.PHONY: vc-all vc-clean vc-realclean vc-install 

vc-all: $(call ds-make-dir, $(vc_BUILDDIR)) $(vc_TARGETS)
vc-clean: 
	-$(RM) $(vc_CLEANFILES)
vc-realclean: 
	-$(RM) $(vc_REALCLEANFILES)
vc-install: 
AM_INSTALL_BIN(vc)

$(vc_TARGETS): $(vc_BUILDDIR)/% : $(vc_SRCDIR)/%
	{ echo "#!/bin/bash" && cat $(<) ; } >$(@)
	chmod 0700 $(@)

bin:		vc-all
bin-clean:	vc-clean
bin-realclean:	vc-realclean
bin-install:	vc-install

#page
## ------------------------------------------------------------
## Admin scripts rules.
## ------------------------------------------------------------

admin_SRCDIR	= $(top_srcdir)/admin
admin_BUILDDIR	= $(builddir)/admin

admin_SOURCES	= $(call ds-files-from-dir, $(admin_SRCDIR))
admin_TARGETS	= $(call ds-replace-dir, $(admin_BUILDDIR), $(admin_SOURCES))
admin_INSTLST	= $(admin_TARGETS)
admin_INSTDIR	= $(libexecdir)/mbfladmin_$(PACKAGE_XVERSION)

admin_CLEANFILES		= $(admin_TARGETS) $(admin_BUILDDIR)
admin_REALCLEANFILES	= $(admin_CLEANFILES)

.PHONY: admin-all admin-clean admin-realclean admin-install 

admin-all: $(call ds-make-dir, $(admin_BUILDDIR)) $(admin_TARGETS)
admin-clean: 
	-$(RM) $(admin_CLEANFILES)
admin-realclean: 
	-$(RM) $(admin_REALCLEANFILES)
admin-install: 
AM_INSTALL_BIN(admin)

$(admin_TARGETS): $(admin_BUILDDIR)/% : $(admin_SRCDIR)/%
	{ echo "#!/bin/bash" && cat $(<) ; } >$(@)
	chmod 0700 $(@)

bin:		admin-all
bin-clean:	admin-clean
bin-realclean:	admin-realclean
bin-install:	admin-install

#PAGE
## ------------------------------------------------------------
## Template rules.
## ------------------------------------------------------------

template_INSTLST	= $(top_srcdir)/examples/template.sh
template_INSTDIR	= $(pkgexampledir)

.PHONY: template-install

template-install:
AM_INSTALL_DATA([template])

doc-install:	template-install

#page
## ------------------------------------------------------------
## Test rules.
## ------------------------------------------------------------

testdir		= $(top_srcdir)/tests
test_FILES	= $(wildcard $(testdir)/*.test)
test_TARGETS	= test-all

test_ENV	= PATH=$(builddir):$(testdir):$(top_srcdir)/lib:$(PATH)
test_CMD	= $(test_ENV) $(BASHPROG)

.PHONY: test-all test-all-verbose

test-all:
ifneq ($(strip $(test_FILES)),)
	@$(foreach f, $(test_FILES), \
	top_srcdir=$(top_srcdir); $(test_CMD) $(f);)
endif

test-all-verbose:
ifneq ($(strip $(test_FILES)),)
	@$(foreach f, $(test_FILES), top_srcdir=$(top_srcdir); \
	TESTSUCCESS='yes' TESTSTART='yes' $(test_CMD) $(f);)
endif

### end of file
# Local Variables:
# mode: makefile
# page-delimiter: "^#page"
# End:
