# @configure_input@
#

vpath	%.m4		$(srcdir)/src/macros
vpath	%.sh.m4		$(srcdir)/src/modules
vpath	%.sh.m4		$(srcdir)/src/lib
vpath	%.sh.m4		$(srcdir)/examples
vpath	%.sh.m4		$(builddir)

MBFL_LIBRARY	= $(srcdir)/src/backup/libmbfl.sh
MBFLPP_SCRIPT	= $(srcdir)/src/scripts/mbflpp.sh
MBFLPP		= MBFL_LIBRARY=$(MBFL_LIBRARY) $(BASH_PROGRAM) $(MBFLPP_SCRIPT)

# This is to include example scripts in the documentation.
texi_MORE_FLAGS	= -I$(srcdir)/examples

#page
MODULES	= base encode file getopts message program signal \
	  string dialog main variable system interfaces

$(eval $(call ds-srcdir,modules,$(srcdir)/src/modules))
$(eval $(call ds-builddir,modules))

modules_SOURCES	= $(foreach m,$(MODULES),$(modules_SRCDIR)/$(m).sh.m4)
modules_TARGETS	= $(call ds-replace-dir,$(modules_BUILDDIR),$(modules_SOURCES:.sh.m4=.sh))

$(eval $(call ds-default-clean-variables,modules))
$(eval $(call ds-module-no-install,modules,bin))

MBFLPP_MODULES_FLAGS	= --include=$(srcdir)/src/macros			\
			  --library=preprocessor.m4	 			\
			  --define=__PKGDATADIR__=$(pkgdatadir)			\
			  --define=__PACKAGE_NAME__=$(PACKAGE_NAME)		\
			  --define=__PACKAGE_VERSION__=$(PACKAGE_VERSION)

$(modules_TARGETS): $(modules_BUILDDIR)/%.sh: $(modules_SRCDIR)/%.sh.m4 preprocessor.m4
	$(MBFLPP) $(MBFLPP_MODULES_FLAGS) <$(<) >$(@)

#page
$(eval $(call ds-srcdir,libs,$(srcdir)/src/lib))
$(eval $(call ds-builddir,libs))

libs_TARGETS	= $(libs_BUILDDIR)/libmbfl.sh
libs_INSTLST	= $(libs_TARGETS)
libs_INSTDIR	= $(pkgdatadir)

$(eval $(call ds-default-clean-variables,libs))
$(eval $(call ds-module,libs,bin))

MBFLPP_LIBS_FLAGS	= --include=$(modules_BUILDDIR) --preserve-comments

$(libs_BUILDDIR)/%.sh: $(libs_SRCDIR)/%.sh.m4 preprocessor.m4 $(modules_TARGETS)
	$(MBFLPP) $(MBFLPP_LIBS_FLAGS) <$(<) >$(@)

## --------------------------------------------------------------------

$(eval $(call ds-srcdir,testlibs,$(srcdir)/src/lib))

testlibs_TARGETS	= $(testlibs_SRCDIR)/libmbfltest.sh
testlibs_INSTLST	= $(testlibs_TARGETS)
testlibs_INSTDIR	= $(pkgdatadir)

$(eval $(call ds-module,testlibs,dev))

#page
$(eval $(call ds-srcdir,scripts,$(srcdir)/src/scripts))
$(eval $(call ds-builddir,scripts))

SCRIPTS		= mbflpp.sh mbfltest.sh
scripts_SOURCES	= $(addprefix $(scripts_SRCDIR)/,$(SCRIPTS))
scripts_TARGETS	= $(call ds-replace-dir,$(scripts_BUILDDIR),$(scripts_SOURCES))

$(eval $(call ds-default-install-variables,scripts,$(bindir)))
$(eval $(call ds-default-clean-variables,scripts))
$(eval $(call ds-module,scripts,dev,BIN))

MBFLPP_SCRIPTS_FLAGS	= $(MBFLPP_MODULES_FLAGS) --add-bash --preserve-comments

$(scripts_BUILDDIR)/%.sh: $(scripts_SRCDIR)/%.sh
	$(MBFLPP) $(MBFLPP_SCRIPTS_FLAGS) <$(<) >$(@)

#page
macros_INSTLST		= $(srcdir)/src/macros/preprocessor.m4
macros_INSTDIR		= $(pkgdatadir)

$(eval $(call ds-module-install-rules,macros,dev))

examples_INSTLST	= $(call ds-files-from-dir,$(srcdir)/examples)
examples_INSTDIR	= $(pkgexampledir)

$(eval $(call ds-module-install-rules,examples,dev))

#page
mtests_SRCDIR	= $(srcdir)/tests
mtests_FILES	= $(call ds-glob,mtests,*.test)
mtests_TARGETS	= test-all

mtests_ENV	= PATH=$(mtests_SRCDIR):$(libs_BUILDDIR):$(libs_SRCDIR):$(PATH)
# This is because  I mount the "/tmp" directory  on a separate partition
# with "noexec" attribute; this  causes tests for executability of files
# to fail if the temporary test files are created under "/tmp".
mtests_ENV	+= TMPDIR=$(PWD)/tmp
mtests_ENV	+= MBFL_LIBRARY=$(libs_BUILDDIR)/libmbfl.sh
mtests_ENV	+= TESTMATCH=$(TESTMATCH)
mtests_VERBENV	= TESTSUCCESS=yes TESTSTART=yes
mtests_CMD	= $(mtests_ENV) $(BASH_PROGRAM)

tests-silent:
	@$(foreach f,$(mtests_FILES),$(mtests_CMD) $(f);)

tests:
	@$(foreach f,$(mtests_FILES),$(mtests_VERBENV) $(mtests_CMD) $(f);)


### end of file
# Local Variables:
# mode: makefile-gmake
# End:
