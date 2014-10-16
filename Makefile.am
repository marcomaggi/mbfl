## Process this file with automake to produce Makefile.in

ACLOCAL_AMFLAGS		= -I autotools
AUTOMAKE_OPTIONS	= foreign
EXTRA_DIST		= INSTALL configure.sh ANNOUNCE
CLEANFILES		=
dist_doc_DATA		= README COPYING

#page
#### meta infrastructure

pkgconfigdir		= $(libdir)/pkgconfig
dist_pkgconfig_DATA	= meta/mbfl.pc

dist_bin_SCRIPTS	= meta/mbfl-config

autoconfdir		= $(datadir)/aclocal/$(PACKAGE)/$(PACKAGE_VERSION)
dist_autoconf_DATA	= meta/mbfl.m4

#page
#### source modules

EXTRA_DIST	+= \
	src/scripts/mbflpp-pre.sh		\
	src/scripts/mbfltest-pre.sh		\
	\
	src/modules/base.sh.m4			\
	src/modules/encode.sh.m4		\
	src/modules/file.sh.m4			\
	src/modules/getopts.sh.m4		\
	src/modules/actions.sh.m4		\
	src/modules/message.sh.m4		\
	src/modules/program.sh.m4		\
	src/modules/signal.sh.m4		\
	src/modules/string.sh.m4		\
	src/modules/dialog.sh.m4		\
	src/modules/main.sh.m4			\
	src/modules/variable.sh.m4		\
	src/modules/system.sh.m4		\
	src/modules/interfaces.sh.m4		\
	\
	src/lib/libmbfl.sh.m4			\
	src/lib/libmbfltest.sh			\
	src/lib/loader.sh			\
	src/lib/preprocessor.m4			\
	\
	src/backup/libmbfl.sh			\
	src/backup/libmbfltest.sh		\
	src/backup/mbflpp.sh			\
	src/backup/mbfltest.sh			\
	src/backup/preprocessor.m4

MBFL_MODULES		= \
	src/modules/base.sh	src/modules/encode.sh		src/modules/file.sh	\
	src/modules/getopts.sh	src/modules/actions.sh		src/modules/message.sh	\
	src/modules/program.sh	src/modules/signal.sh		src/modules/string.sh	\
	src/modules/dialog.sh	src/modules/main.sh		src/modules/variable.sh	\
	src/modules/system.sh	src/modules/interfaces.sh

MBFL_PREPRO		= src/lib/preprocessor.m4

mbfldatadir		= $(datadir)/$(PACKAGE)/$(PACKAGE_VERSION)
dist_mbfldata_DATA	= \
	$(MBFL_PREPRO)				\
	src/lib/libmbfltest.sh			\
	src/lib/libmbfl.sh

bin_SCRIPTS		= src/scripts/mbflpp.sh src/scripts/mbfltest.sh

CLEANFILES		+= \
	src/lib/libmbfltest.sh			\
	src/lib/libmbfl.sh			\
	src/scripts/mbflpp.sh			\
	src/scripts/mbfltest.sh			\
	$(MBFL_MODULES)

## --------------------------------------------------------------------

BASH_PROGRAM	= @BASH_PROGRAM@

MBFL_LIBRARY	= $(srcdir)/src/backup/libmbfl.sh
MBFLPP_ENV	= MBFL_LIBRARY=$(MBFL_LIBRARY)
MBFLPP_SCRIPT	= $(srcdir)/src/backup/mbflpp.sh
MBFLPP_RUN	= $(MBFLPP_ENV) $(BASH_PROGRAM) $(MBFLPP_SCRIPT)

## --------------------------------------------------------------------

MBFLPP_MODULES_FLAGS	= --include=$(srcdir)/src/lib				\
			  --library=$(srcdir)/lib/preprocessor.m4	 	\
			  --define=__PKGDATADIR__=$(mbfldatadir)		\
			  --define=__PACKAGE_NAME__=$(PACKAGE)			\
			  --define=__PACKAGE_VERSION__=$(PACKAGE_VERSION)
MBFLPP_LIBS_FLAGS	= --include=$(builddir)/src/modules  --preserve-comments
MBFLPP_SCRIPTS_FLAGS	= $(MBFLPP_MODULES_FLAGS) --add-bash --preserve-comments

src/modules/%.sh	: src/modules/%.sh.m4	$(MBFL_PREPRO)
	test -d src/modules || $(MKDIR_P) src/modules
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

src/lib/libmbfl.sh: src/lib/libmbfl.sh.m4 $(MBFL_PREPRO) $(MBFL_MODULES)
	test -d src/lib || $(MKDIR_P) src/lib
	$(MBFLPP_RUN) $(MBFLPP_LIBS_FLAGS) <$< >$@

src/scripts/mbflpp.sh : src/scripts/mbflpp-pre.sh
	test -d src/scripts || $(MKDIR_P) src/scripts
	$(MBFLPP_RUN) $(MBFLPP_SCRIPTS_FLAGS) <$< >$@

src/scripts/mbfltest.sh : src/scripts/mbfltest-pre.sh
	test -d src/scripts || $(MKDIR_P) src/scripts
	$(MBFLPP_RUN) $(MBFLPP_SCRIPTS_FLAGS) <$< >$@

#page
#### tests

EXTRA_DIST	+= \
	tests/compress.test		\
	tests/encode.test		\
	tests/file.test			\
	tests/getopts.test		\
	tests/message.test		\
	tests/program.test		\
	tests/script.test		\
	tests/signal.test		\
	tests/string.test		\
	tests/system.test		\
	tests/variable.test		\
	\
	tests/setup.sh			\
	tests/signal.sh			\
	tests/signaltest.sh

## --------------------------------------------------------------------
## interface to "make check"

# Resetting the PATH allows us to load files with the "source" command.
MBFL_TESTS_ENV		= PATH=$(srcdir)/tests:$(builddir)/tests:$(srcdir)/src/lib:$(PATH); export PATH;
MBFL_TESTS_ENV		+= srcdir=$(srcdir)/tests; export srcdir; builddir=$(builddir)/tests; export builddir;
# This is because  I mount the "/tmp" directory  on a separate partition
# with "noexec" attribute; this  causes tests for executability of files
# to fail if the temporary test files are created under "/tmp".
MBFL_TESTS_ENV		+= TMPDIR=$(PWD)/tmp; export TMPDIR; examplesdir=$(srcdir)/examples; export examplesdir;
MBFL_TESTS_ENV		+= MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh; export MBFL_LIBRARY;
MBFL_TESTS_ENV		+= MBFLTEST_LIBRARY=$(srcdir)/src/lib/libmbfltest.sh; export MBFLTEST_LIBRARY;
MBFL_TESTS_ENV		+= TESTMATCH=$(TESTMATCH); export TESTMATCH;
MBFL_TESTS_VERBENV	= TESTSUCCESS=yes; export TESTSUCCESS; TESTSTART=yes; export TESTSTART;
#MBFL_TESTS_RUN		= $(MBFL_TESTS_ENV) $(BASH_PROGRAM)

# Read "Parallel Test Harness" in the documentation of GNU Automake to
# understand how to use this interface for "make check".
#
# We must make sure that this ends with a semicolon!!!
AM_TESTS_ENVIRONMENT	= $(MBFL_TESTS_VERBENV) $(MBFL_TESTS_ENV)
TEST_EXTENSIONS		= .test
TEST_LOG_COMPILER	= $(BASH_PROGRAM)
AM_TEST_LOG_FLAGS	= $(user_flags)

TESTS			= \
	tests/encode.test	\
	tests/file.test		\
	tests/message.test	\
	tests/getopts.test	\
	tests/string.test	\
	tests/system.test	\
	tests/variable.test	\
	tests/program.test	\
	tests/signal.test	\
	tests/script.test	\
	tests/compress.test

## --------------------------------------------------------------------
## additional test rules

.PHONY: test-template test-template-actions

test-template:
	MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh $(BASH_PROGRAM) $(srcdir)/examples/template.sh $(MFLAGS)

test-template-actions:
	MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh $(BASH_PROGRAM) $(srcdir)/examples/template-actions.sh $(MFLAGS)

#page
#### interface to "make installcheck"

MBFL_INSTCHECK_FLAGS	= $(user_flags)
# This thing with the PATH environment variable is needed to run
# distcheck successfully.
MBFL_INSTCHECK_ENV	= PATH=$(srcdir)/tests:$(DESTDIR)$(bindir):$$PATH; export PATH;
MBFL_INSTCHECK_ENV	+= PATH="`mbfl-config --libpath`":$$PATH; export PATH;
MBFL_INSTCHECK_ENV	+= MBFL_LIBRARY="`mbfl-config --library`"; export MBFL_LIBRARY;
MBFL_INSTCHECK_ENV	+= MBFLTEST_LIBRARY="`mbfl-config --testlib`"; export MBFLTEST_LIBRARY;
MBFL_INSTCHECK_ENV	+= TMPDIR=$(PWD)/tmp; export TMPDIR; examplesdir=$(srcdir)/examples; export examplesdir;
MBFL_INSTCHECK_RUN	= $(MBFL_INSTCHECK_ENV) $(BASH_PROGRAM) $(MBFL_INSTCHECK_FLAGS)

installcheck-local:
	@for f in $(TESTS); do $(MBFL_INSTCHECK_RUN) $(srcdir)/$$f; done

#page
#### documentation

EXTRA_DIST		+= \
	doc/one-level-actions.sh		\
	doc/two-levels-actions.sh

AM_MAKEINFOFLAGS	= --no-split -I $(srcdir)/examples

info_TEXINFOS		= doc/mbfl.texi
doc_mbfl_TEXINFOS	= \
	doc/fdl-1.3.texi		\
	doc/lgpl-3.0.texi		\
	doc/macros.texi			\
	doc/sendmail-plain.sh		\
	doc/sendmail-connector.sh

#page
#### examples

EXTRA_DIST		+= \
	examples/at.sh				\
	examples/compress.sh			\
	examples/template.sh			\
	examples/template-actions.sh		\
	\
	examples/sendmail-connector.sh		\
	examples/sendmail-plain.sh		\
	examples/test-sendmail-gmail.sh		\
	examples/test-sendmail-localhost.sh	\
	examples/test-sendmail-poste.sh

if WANT_SENDMAIL

dist_lisp_LISP		= examples/sendmail-mbfl.el
dist_bin_SCRIPTS	+= examples/sendmail-mbfl.sh

endif

### end of file
