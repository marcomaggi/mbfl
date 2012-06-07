## Process this file with automake to produce Makefile.in

EXTRA_DIST	=

BASH_PROGRAM	= @BASH_PROGRAM@

MBFL_LIBRARY	= $(srcdir)/backup/libmbfl.sh
MBFLPP_ENV	= MBFL_LIBRARY=$(MBFL_LIBRARY)
MBFLPP_SCRIPT	= $(srcdir)/scripts/mbflpp.sh
MBFLPP_RUN	= $(MBFLPP_ENV) $(BASH_PROGRAM) $(MBFLPP_SCRIPT)

## --------------------------------------------------------------------

mbfldatadir		= $(datadir)/$(PACKAGE)/$(PACKAGE_VERSION)
dist_mbfldata_DATA	= \
	$(srcdir)/lib/preprocessor.m4	\
	$(srcdir)/lib/libmbfltest.sh

## --------------------------------------------------------------------

EXTRA_DIST	+= \
	modules/base.sh.m4		\
	modules/encode.sh.m4		\
	modules/file.sh.m4		\
	modules/getopts.sh.m4		\
	modules/message.sh.m4		\
	modules/program.sh.m4		\
	modules/signal.sh.m4		\
	modules/string.sh.m4		\
	modules/dialog.sh.m4		\
	modules/main.sh.m4		\
	modules/variable.sh.m4		\
	modules/system.sh.m4		\
	modules/interfaces.sh.m4

# MBFLPP_MODULES_FLAGS	= --include=$(srcdir)/macros				\
# 			  --library=preprocessor.m4	 			\
# 			  --define=__PKGDATADIR__=$(mbfldatadir)		\
# 			  --define=__PACKAGE_NAME__=$(PACKAGE)			\
# 			  --define=__PACKAGE_VERSION__=$(PACKAGE_VERSION)

# $(modules_TARGETS): $(modules_BUILDDIR)/%.sh: $(modules_SRCDIR)/%.sh.m4 preprocessor.m4
# 	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

#page
# $(eval $(call ds-srcdir,libs,$(srcdir)/src/lib))
# $(eval $(call ds-builddir,libs))

# libs_TARGETS	= $(libs_BUILDDIR)/libmbfl.sh
# libs_INSTLST	= $(libs_TARGETS)
# libs_INSTDIR	= $(pkgdatadir)

# $(eval $(call ds-default-clean-variables,libs))
# $(eval $(call ds-module,libs,bin))

# MBFLPP_LIBS_FLAGS	= --include=$(modules_BUILDDIR) --preserve-comments

# $(libs_BUILDDIR)/%.sh: $(libs_SRCDIR)/%.sh.m4 preprocessor.m4 $(modules_TARGETS)
# 	$(MBFLPP) $(MBFLPP_LIBS_FLAGS) <$(<) >$(@)

#page
# $(eval $(call ds-srcdir,scripts,$(srcdir)/src/scripts))
# $(eval $(call ds-builddir,scripts))

# SCRIPTS		= mbflpp.sh mbfltest.sh
# scripts_SOURCES	= $(addprefix $(scripts_SRCDIR)/,$(SCRIPTS))
# scripts_TARGETS	= $(call ds-replace-dir,$(scripts_BUILDDIR),$(scripts_SOURCES))

# $(eval $(call ds-default-install-variables,scripts,$(bindir)))
# $(eval $(call ds-default-clean-variables,scripts))
# $(eval $(call ds-module,scripts,dev,BIN))

# MBFLPP_SCRIPTS_FLAGS	= $(MBFLPP_MODULES_FLAGS) --add-bash --preserve-comments

# $(scripts_BUILDDIR)/%.sh: $(scripts_SRCDIR)/%.sh
# 	$(MBFLPP) $(MBFLPP_SCRIPTS_FLAGS) <$(<) >$(@)


### end of file
