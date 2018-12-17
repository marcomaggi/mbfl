## Process this file with automake to produce Makefile.in

ACLOCAL_AMFLAGS		= -I meta/autotools
AUTOMAKE_OPTIONS	= foreign
EXTRA_DIST		= README COPYING INSTALL NEWS configure.sh
CLEANFILES		=


#### meta infrastructure

dist_bin_SCRIPTS	= meta/scripts/mbfl-config

autoconfdir		= $(datadir)/aclocal
dist_autoconf_DATA	= meta/autoconf/mbfl.m4


#### documentation

EXTRA_DIST		+= \
	doc/one-level-actions.sh		\
	doc/two-levels-actions.sh

AM_MAKEINFOFLAGS	= --no-split -I $(srcdir)/examples
AM_MAKEINFOHTMLFLAGS	= --split=node  -I $(srcdir)/examples -c WORDS_IN_PAGE=0

# Notice that  we need the  *.sh files in  the doc directory  to allow
# generation of PDF documents.  Unfortunately, texi2pdf does not allow
# the selection of include directories.  (Marco Maggi; Nov 26, 2018)
#
info_TEXINFOS		= doc/mbfl.texi
doc_mbfl_TEXINFOS	= \
	doc/fdl-1.3.texi				\
	doc/lgpl-3.0.texi				\
	doc/macros.texi					\
	doc/one-level-actions.sh			\
	doc/loader.sh					\
	doc/sendmail-plain.sh				\
	doc/sendmail-connector.sh

html-local:
	$(top_srcdir)/meta/scripts/add-footer-to-html-pages.sh "$(PACKAGE_NAME)" "$(PACKAGE_VERSION)" $(builddir)/doc/mbfl.html/*.html


#### source modules

EXTRA_DIST	+= \
	src/scripts/mbflpp.sh.m4		\
	src/scripts/mbfltest.sh.m4		\
	\
	src/modules/base.sh.m4			\
	src/modules/encode.sh.m4		\
	src/modules/file.sh.m4			\
	src/modules/fd.sh.m4			\
	src/modules/getopts.sh.m4		\
	src/modules/actions.sh.m4		\
	src/modules/message.sh.m4		\
	src/modules/program.sh.m4		\
	src/modules/signal.sh.m4		\
	src/modules/string.sh.m4		\
	src/modules/dialog.sh.m4		\
	src/modules/times-and-dates.sh.m4	\
	src/modules/main.sh.m4			\
	src/modules/variable.sh.m4		\
	src/modules/arrays.sh.m4		\
	src/modules/system.sh.m4		\
	src/modules/interfaces.sh.m4		\
	src/modules/atexit.sh.m4		\
	src/modules/locations.sh.m4		\
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
	src/modules/base.sh	src/modules/encode.sh		src/modules/file.sh	      \
	src/modules/getopts.sh	src/modules/actions.sh		src/modules/message.sh	      \
	src/modules/program.sh	src/modules/signal.sh		src/modules/string.sh	      \
	src/modules/dialog.sh	src/modules/main.sh		src/modules/variable.sh	      \
	src/modules/system.sh	src/modules/arrays.sh		src/modules/interfaces.sh     \
	src/modules/atexit.sh	src/modules/locations.sh	src/modules/times-and-dates.sh \
	src/modules/fd.sh

MBFL_PREPRO		= src/lib/preprocessor.m4

mbfldatadir		= $(datadir)/$(PACKAGE)
dist_mbfldata_DATA	= \
	$(MBFL_PREPRO)				\
	src/lib/libmbfltest.sh			\
	src/lib/libmbfl.sh

bin_SCRIPTS		= src/scripts/mbflpp.sh src/scripts/mbfltest.sh

CLEANFILES		+= \
	src/lib/libmbfltest.sh		\
	src/lib/libmbfl.sh		\
	src/scripts/mbflpp.sh		\
	src/scripts/mbfltest.sh		\
	$(MBFL_MODULES)			\
	src/modules/$(am__dirstamp)	\
	src/scripts/$(am__dirstamp)	\
	src/lib/$(am__dirstamp)

## --------------------------------------------------------------------

BASH_PROGRAM	= @BASH_PROGRAM@

MBFL_LIBRARY	= $(srcdir)/src/backup/libmbfl.sh
MBFLPP_ENV	= MBFL_LIBRARY=$(MBFL_LIBRARY)
MBFLPP_SCRIPT	= $(srcdir)/src/backup/mbflpp.sh
MBFLPP_RUN	= $(MBFLPP_ENV) $(BASH_PROGRAM) $(MBFLPP_SCRIPT)

## --------------------------------------------------------------------

MBFLPP_MODULES_FLAGS	= --no-prepro 						\
			  --include=$(srcdir)/src/lib				\
			  --library=$(srcdir)/src/lib/preprocessor.m4	 	\
			  --define=__PKGDATADIR__=$(mbfldatadir)		\
			  --define=__PACKAGE_NAME__=$(PACKAGE)			\
			  --define=__PACKAGE_VERSION__=$(MBFL_CORE_VERSION)	\
			  --define=__PATHNAME_SUDO__=$(PATHNAME_SUDO)		\
			  --define=__PATHNAME_WHOAMI__=$(PATHNAME_WHOAMI)	\
			  $(MBFLPPFLAGS)
MBFLPP_LIBS_FLAGS	= --no-prepro 						\
			  --include=$(srcdir)/src/lib				\
			  --library=$(srcdir)/src/lib/preprocessor.m4	 	\
			  --include=$(builddir)/src/modules  --preserve-comments
MBFLPP_SCRIPTS_FLAGS	= $(MBFLPP_MODULES_FLAGS) --add-bash --preserve-comments

src/modules/$(am__dirstamp):
	@$(MKDIR_P) src/modules
	@: > src/modules/$(am__dirstamp)

src/scripts/$(am__dirstamp):
	@$(MKDIR_P) src/scripts
	@: > src/scripts/$(am__dirstamp)

src/lib/$(am__dirstamp):
	@$(MKDIR_P) src/lib
	@: > src/lib/$(am__dirstamp)

src/modules/%.sh: src/modules/%.sh.m4 $(MBFL_PREPRO) src/modules/$(am__dirstamp)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

src/lib/libmbfl.sh: src/lib/libmbfl.sh.m4 $(MBFL_PREPRO) $(MBFL_MODULES) src/lib/$(am__dirstamp)
	$(MBFLPP_RUN) $(MBFLPP_LIBS_FLAGS) <$< >$@

src/scripts/mbflpp.sh: src/scripts/mbflpp.sh.m4 src/scripts/$(am__dirstamp)
	$(MBFLPP_RUN) $(MBFLPP_SCRIPTS_FLAGS) <$< >$@

src/scripts/mbfltest.sh: src/scripts/mbfltest.sh.m4 src/scripts/$(am__dirstamp)
	$(MBFLPP_RUN) $(MBFLPP_SCRIPTS_FLAGS) <$< >$@


#### examples

EXTRA_DIST		+= \
	examples/at.sh.m4			\
	examples/compress.sh.m4			\
	examples/pwentries.sh.m4		\
	examples/sendmail-mbfl.sh.m4		\
	examples/template-actions.sh.m4		\
	examples/template.sh.m4			\
	\
	examples/sendmail-connector.sh		\
	examples/sendmail-plain.sh		\
	examples/test-sendmail-gmail.sh		\
	examples/test-sendmail-localhost.sh	\
	examples/test-sendmail-poste.sh

EXAMPLES_BUILT_FILES	= \
	examples/at.sh				\
	examples/compress.sh			\
	examples/pwentries.sh			\
	examples/sendmail-mbfl.sh		\
	examples/template-actions.sh		\
	examples/template.sh

noinst_SCRIPTS		= $(EXAMPLES_BUILT_FILES)

CLEANFILES		+= $(EXAMPLES_BUILT_FILES) examples/$(am__dirstamp)

MBFL_EXAMPLES_LIBRARY	= $(builddir)/src/lib/libmbfl.sh
MBFL_EXAMPLES_ENV	= MBFL_LIBRARY=$(MBFL_EXAMPLES_LIBRARY); export MBFL_LIBRARY;
MBFL_EXAMPLES_PREPRO	= $(builddir)/src/scripts/mbflpp.sh
MBFL_EXAMPLES_PPFLAGS	= --no-prepro --library=$(srcdir)/src/lib/preprocessor.m4 --add-bash $(MBFLPPFLAGS)
MBFL_EXAMPLES_RUNPP	= $(MBFL_EXAMPLES_ENV) $(BASH_PROGRAM) $(MBFL_EXAMPLES_PREPRO) $(MBFL_EXAMPLES_PPFLAGS)
MBFL_EXAMPLES_PREREQ	= examples/$(am__dirstamp) $(MBFL_EXAMPLES_PREPRO) $(MBFL_EXAMPLES_LIBRARY)

examples/$(am__dirstamp):
	@$(MKDIR_P) examples
	@: > examples/$(am__dirstamp)

examples/at.sh: examples/at.sh.m4 $(MBFL_EXAMPLES_PREREQ)
	$(MBFL_EXAMPLES_RUNPP) <$< >$@

examples/compress.sh: examples/compress.sh.m4 $(MBFL_EXAMPLES_PREREQ)
	$(MBFL_EXAMPLES_RUNPP) <$< >$@

examples/pwentries.sh: examples/pwentries.sh.m4 $(MBFL_EXAMPLES_PREREQ)
	$(MBFL_EXAMPLES_RUNPP) <$< >$@

examples/sendmail-mbfl.sh: examples/sendmail-mbfl.sh.m4 $(MBFL_EXAMPLES_PREREQ)
	$(MBFL_EXAMPLES_RUNPP) <$< >$@

examples/template.sh: examples/template.sh.m4 $(MBFL_EXAMPLES_PREREQ)
	$(MBFL_EXAMPLES_RUNPP) <$< >$@

examples/template-actions.sh: examples/template-actions.sh.m4 $(MBFL_EXAMPLES_PREREQ)
	$(MBFL_EXAMPLES_RUNPP) <$< >$@

if WANT_SENDMAIL

dist_lisp_LISP		= examples/sendmail-mbfl.el
bin_SCRIPTS		+= examples/sendmail-mbfl.sh

endif


#### interface to "make check"

EXTRA_DIST	+= \
	tests/variables.test.m4		\
	tests/strings.test.m4		\
	\
	tests/arrays.test		\
	tests/atexit.test		\
	tests/compress.test		\
	tests/encode.test		\
	tests/fd.test			\
	tests/file.test			\
	tests/getopts.test		\
	tests/locations.test		\
	tests/message.test		\
	tests/program.test		\
	tests/script.test		\
	tests/signal.test		\
	tests/system.test		\
	tests/times-and-dates.test	\
	\
	tests/bash-feature-coproc.test	\
	\
	tests/setup.sh			\
	tests/signaltest.sh

CHECK_BUILT_EXAMPLES	= \
	examples/compress.sh		\
	examples/template.sh		\
	examples/template-actions.sh

CHECK_BUILT_TESTS		= \
	tests/strings.test		\
	tests/variables.test

check_SCRIPTS		= $(CHECK_BUILT_EXAMPLES) $(CHECK_BUILT_TESTS)

CLEANFILES		+= $(CHECK_BUILT_TESTS) tests/$(am__dirstamp)

## --------------------------------------------------------------------

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

MBFL_TESTS_LIBRARY	= $(builddir)/src/lib/libmbfl.sh
MBFL_TESTS_PREPRO	= $(builddir)/src/scripts/mbflpp.sh
MBFL_TESTS_PPFLAGS	= --no-prepro --library=$(srcdir)/src/lib/preprocessor.m4 --add-bash $(MBFLPPFLAGS)
MBFL_TESTS_RUNPP	= $(MBFL_TESTS_ENV) $(BASH_PROGRAM) $(MBFL_TESTS_PREPRO) $(MBFL_TESTS_PPFLAGS)
MBFL_TESTS_PREREQ	= tests/$(am__dirstamp) $(MBFL_TESTS_PREPRO) $(MBFL_TESTS_LIBRARY)

# Read "Parallel Test Harness" in the documentation of GNU Automake to
# understand how to use this interface for "make check".
#
# We must make sure that this ends with a semicolon!!!
AM_TESTS_ENVIRONMENT	= $(MBFL_TESTS_VERBENV) $(MBFL_TESTS_ENV)
TEST_EXTENSIONS		= .test
TEST_LOG_COMPILER	= $(BASH_PROGRAM)
AM_TEST_LOG_FLAGS	= $(MBFLFLAGS)

TESTS			= \
	tests/arrays.test		\
	tests/atexit.test		\
	tests/compress.test		\
	tests/encode.test		\
	tests/fd.test			\
	tests/file.test			\
	tests/getopts.test		\
	tests/locations.test		\
	tests/message.test		\
	tests/program.test		\
	tests/script.test		\
	tests/signal.test		\
	tests/strings.test		\
	tests/system.test		\
	tests/times-and-dates.test	\
	tests/variables.test		\
	\
	tests/bash-feature-coproc.test

tests/variables.test: tests/variables.test.m4 $(MBFL_TESTS_PREREQ)
	$(MBFL_TESTS_RUNPP) <$< >$@

tests/strings.test: tests/strings.test.m4 $(MBFL_TESTS_PREREQ)
	$(MBFL_TESTS_RUNPP) <$< >$@

tests/$(am__dirstamp):
	@$(MKDIR_P) tests
	@: > tests/$(am__dirstamp)


#### additional test rules

.PHONY: test test-template test-template-actions test-script-atexit
.PHONY: test-sendmail-gmail test-sendmail-poste test-sendmail-localhost

test: all $(check_SCRIPTS)
	shopt -s nullglob; for item in $(srcdir)/tests/*$(file)*.test $(builddir)/tests/*$(file)*.test;	\
	do $(AM_TESTS_ENVIRONMENT) $(BASH_PROGRAM) "$$item" $(AM_TEST_LOG_FLAGS);	\
	done

test-template: examples/template.sh src/lib/libmbfl.sh
	MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh $(BASH_PROGRAM) $(builddir)/examples/template.sh $(MBFLFLAGS)

test-template-actions: examples/template-actions.sh src/lib/libmbfl.sh
	MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh $(BASH_PROGRAM) $(builddir)/examples/template-actions.sh $(MBFLFLAGS)

test-script-atexit:
	MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh $(BASH_PROGRAM) $(srcdir)/tests/script-atexit.sh $(MBFLFLAGS)

test-sendmail-gmail:
	MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh $(BASH_PROGRAM) $(srcdir)/examples/test-sendmail-gmail.sh $(MBFLFLAGS)

test-sendmail-poste:
	MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh $(BASH_PROGRAM) $(srcdir)/examples/test-sendmail-poste.sh $(MBFLFLAGS)

test-sendmail-localhost:
	MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh $(BASH_PROGRAM) $(srcdir)/examples/test-sendmail-localhost.sh $(MBFLFLAGS)


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

### end of file
