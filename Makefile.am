## Process this file with automake to produce Makefile.in
#
# This is how it goes:
#
# 1.   Generate the  built scripts  using: the  backup libraries;  the
# backup scripts; the source preprocessor.
#
# 2. Generate the built library "libmbfl.sh" using: the built scripts;
# the source preprocessor.
#
# 3.   Generate the  built library  "libmbfltest.sh" using:  the built
# scripts; the built "libmbfl.sh"; the source preprocessor.
#
# 4.  Generate  the built  library "libmbflutils.sh" using:  the built
# scripts; the built "libmbfl.sh"; the source preprocessor.
#
# 5. Generate the  built examples using: the built  scripts; the built
# "libmbfl.sh"; the source preprocessor.
#

ACLOCAL_AMFLAGS		= -I meta/autotools
AUTOMAKE_OPTIONS	= foreign
EXTRA_DIST		= README COPYING INSTALL NEWS
CLEANFILES		=
MBFL_LIB_INSTDIR	= $(datadir)/$(PACKAGE)

## --------------------------------------------------------------------

MBFL_PROGRAM_BASH	= @MBFL_PROGRAM_BASH@

# These flags are always used on  the command line of "mbflpp.sh".  We
# can set "MBFLPPFLAGS" on the command line of "make".
#
MBFLPP_GENERAL_FLAGS	= --no-prepro 						\
			  --include=$(srcdir)/src/lib				\
			  --library=$(srcdir)/src/lib/preprocessor.m4	 	\
			  --define=__PACKAGE_NAME__=$(PACKAGE)			\
			  --define=__PACKAGE_VERSION__=$(MBFL_CORE_VERSION)	\
			  --define=__SEMANTIC_VERSION__=$(MBFL_SEMANTIC_VERSION)\
			  $(MBFLPPFLAGS)

EXTRA_DIST		+=			\
	src/lib/loader.sh			\
	src/backup/libmbfl.sh			\
	src/backup/mbflpp.sh			\
	src/backup/mbfltest.sh			\
	src/backup/preprocessor.m4


#### meta infrastructure

dist_bin_SCRIPTS	= meta/scripts/mbfl-config

autoconfdir		= $(datadir)/aclocal
dist_autoconf_DATA	= meta/autoconf/mbfl.m4


#### documentation

EXTRA_DIST		+=						\
	doc/one-level-actions.sh					\
	doc/two-levels-actions.sh					\
	doc/mbfl.style.css
CLEANFILES		+=						\
	doc/mbfl.css							\
	doc/mbfl.html/$(am__dirstamp)

AM_MAKEINFOFLAGS	= --no-split -I $(srcdir)/examples
AM_MAKEINFOHTMLFLAGS	= --split=node  -I $(srcdir)/examples		\
	-c WORDS_IN_PAGE=0 --css-ref=mbfl.css				\
	-c PRE_BODY_CLOSE="<p>This document describes version <tt>$(PACKAGE_VERSION)</tt> of <em>$(PACKAGE_NAME)</em>.</p>"

# Notice that  we need the  *.sh files in  the doc directory  to allow
# generation of PDF documents.  Unfortunately, texi2pdf does not allow
# the selection of include directories.  (Marco Maggi; Nov 26, 2018)
#
info_TEXINFOS		= doc/mbfl.texi
doc_mbfl_TEXINFOS	=			\
	doc/fdl-1.3.texi			\
	doc/lgpl-3.0.texi			\
	doc/macros.texi				\
	doc/one-level-actions.sh		\
	doc/loader.sh				\
	doc/sendmail-plain.sh			\
	doc/sendmail-connector.sh

## --------------------------------------------------------------------

doc/mbfl.html/$(am__dirstamp): doc/$(am__dirstamp)
	@$(MKDIR_P) doc/mbfl.html/
	@: > doc/mbfl.html/$(am__dirstamp)

doc/mbfl.html/mbfl.css: doc/mbfl.style.css doc/mbfl.html/$(am__dirstamp)
	$(INSTALL) -m 0444 \
		"$(top_srcdir)/doc/mbfl.style.css" \
		"$(builddir)/doc/mbfl.html/mbfl.css"

## --------------------------------------------------------------------

html-local: doc/mbfl.html/mbfl.css

install-html-local:
	$(MKDIR_P) "$(DESTDIR)$(htmldir)/mbfl.html/"
	$(INSTALL) -m 0444 $(builddir)/doc/mbfl.html/mbfl.css "$(DESTDIR)$(htmldir)/mbfl.html/"


#### preprocessor macros file

MBFL_PREPROCESSOR		= src/lib/preprocessor.m4
mbflpreprodir			= $(MBFL_LIB_INSTDIR)
dist_mbflprepro_DATA		= $(MBFL_PREPROCESSOR)


#### scripts generation

EXTRA_DIST			+=		\
	src/bin/mbflpp.sh.m4			\
	src/bin/mbfltest.sh.m4

bin_SCRIPTS			=		\
	src/bin/mbflpp.sh			\
	src/bin/mbfltest.sh

CLEANFILES			+=		\
	src/bin/mbflpp.sh			\
	src/bin/mbfltest.sh			\
	src/bin/$(am__dirstamp)

MBFL_SCRIPTS_PREREQUISITES	=		\
	src/bin/$(am__dirstamp)

## --------------------------------------------------------------------

MBFL_SCRIPTS_LIBRARY		= $(srcdir)/src/backup/libmbfl.sh
MBFL_SCRIPTS_MBFLPP		= $(srcdir)/src/backup/mbflpp.sh
MBFL_SCRIPTS_ENV		= MBFL_LIBRARY=$(MBFL_SCRIPTS_LIBRARY); export MBFL_LIBRARY;
MBFL_SCRIPTS_RUN		= $(MBFL_SCRIPTS_ENV) $(MBFL_PROGRAM_BASH) $(MBFL_SCRIPTS_MBFLPP)
MBFLPP_SCRIPTS_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --add-bash --preserve-comments

## --------------------------------------------------------------------

src/bin/$(am__dirstamp):
	@$(MKDIR_P) src/bin
	@: > src/bin/$(am__dirstamp)

src/bin/%.sh: src/bin/%.sh.m4 $(MBFL_SCRIPTS_PREREQUISITES)
	$(MBFL_SCRIPTS_RUN) $(MBFLPP_SCRIPTS_FLAGS) <$< >$@


#### libmbfl modules generation

EXTRA_DIST			+=		\
	src/modules/actions.sh.m4		\
	src/modules/arrays.sh.m4		\
	src/modules/atexit.sh.m4		\
	src/modules/base.sh.m4			\
	src/modules/dialog.sh.m4		\
	src/modules/encode.sh.m4		\
	src/modules/fd.sh.m4			\
	src/modules/file.sh.m4			\
	src/modules/getopts.sh.m4		\
	src/modules/interfaces.sh.m4		\
	src/modules/locations.sh.m4		\
	src/modules/main.sh.m4			\
	src/modules/message.sh.m4		\
	src/modules/process.sh.m4		\
	src/modules/program.sh.m4		\
	src/modules/semver.sh.m4		\
	src/modules/shell.sh.m4			\
	src/modules/signal.sh.m4		\
	src/modules/string.sh.m4		\
	src/modules/system.sh.m4		\
	src/modules/times-and-dates.sh.m4	\
	src/modules/variable.sh.m4

# This  is *not*  the  order  in which  modules  are  included in  the
# library; that order is established in the file "libmbl.sh.m4"!
MBFL_LIB_MODULES		=		\
	src/modules/actions.sh			\
	src/modules/arrays.sh			\
	src/modules/atexit.sh			\
	src/modules/base.sh			\
	src/modules/config-pathnames.sh		\
	src/modules/dialog.sh			\
	src/modules/encode.sh			\
	src/modules/fd.sh			\
	src/modules/file.sh			\
	src/modules/getopts.sh			\
	src/modules/interfaces.sh		\
	src/modules/locations.sh		\
	src/modules/main.sh			\
	src/modules/message.sh			\
	src/modules/process.sh			\
	src/modules/program.sh			\
	src/modules/semver.sh			\
	src/modules/shell.sh			\
	src/modules/signal.sh			\
	src/modules/string.sh			\
	src/modules/system.sh			\
	src/modules/times-and-dates.sh		\
	src/modules/variable.sh

CLEANFILES			+=		\
	$(MBFL_LIB_MODULES)			\
	src/modules/$(am__dirstamp)

MBFL_MODULES_LIBRARY		= $(srcdir)/src/backup/libmbfl.sh
MBFL_MODULES_MBFLPP		= $(builddir)/src/bin/mbflpp.sh
MBFL_MODULES_ENV		= MBFL_LIBRARY=$(MBFL_MODULES_LIBRARY); export MBFL_LIBRARY;
MBFL_MODULES_RUN		= $(MBFL_MODULES_ENV) $(MBFL_PROGRAM_BASH) $(MBFL_MODULES_MBFLPP)
MBFL_MODULES_FLAGS		= $(MBFLPP_GENERAL_FLAGS)

MBFL_MODULES_PREREQUISITES	=		\
	$(MBFL_MODULES_LIBRARY)			\
	$(MBFL_MODULES_MBFLPP)			\
	src/modules/$(am__dirstamp)		\
	$(MBFL_PREPROCESSOR)

src/modules/$(am__dirstamp):
	@$(MKDIR_P) src/modules
	@: > src/modules/$(am__dirstamp)

src/modules/%.sh: src/modules/%.sh.m4 $(MBFL_MODULES_PREREQUISITES)
	$(MBFL_MODULES_RUN) $(MBFL_MODULES_FLAGS) <$< >$@


#### libmbfl generation

EXTRA_DIST			+= src/lib/libmbfl.sh.m4
mbfllibdir			= $(MBFL_LIB_INSTDIR)
mbfllib_DATA			= src/lib/libmbfl.sh
CLEANFILES			+=		\
	src/lib/libmbfl.sh			\
	src/lib/$(am__dirstamp)

MBFL_LIB_LIBRARY		= $(srcdir)/src/backup/libmbfl.sh
MBFL_LIB_MBFLPP			= $(builddir)/src/bin/mbflpp.sh
MBFL_LIB_ENV			= MBFL_LIBRARY=$(MBFL_LIB_LIBRARY); export MBFL_LIBRARY;
MBFL_LIB_RUN			= $(MBFL_LIB_ENV) $(MBFL_PROGRAM_BASH) $(MBFL_LIB_MBFLPP)
MBFL_LIB_FLAGS			= $(MBFLPP_GENERAL_FLAGS) --preserve-comments --include=$(builddir)/src/modules

MBFL_LIB_PREREQUISITES	=			\
	$(MBFL_LIB_LIBRARY)			\
	$(MBFL_LIB_MBFLPP)			\
	src/lib/$(am__dirstamp)			\
	$(MBFL_PREPROCESSOR)

src/lib/$(am__dirstamp):
	@$(MKDIR_P) src/lib
	@: > src/lib/$(am__dirstamp)

src/lib/libmbfl.sh: src/lib/libmbfl.sh.m4 $(MBFL_LIB_MODULES) $(MBFL_LIB_PREREQUISITES)
	$(MBFL_LIB_RUN) $(MBFL_LIB_FLAGS) <$< >$@


#### libmbflutils generation

EXTRA_DIST			+= src/lib/libmbflutils.sh.m4
mbfllibutilsdir			= $(MBFL_LIB_INSTDIR)
mbfllibutils_DATA		= src/lib/libmbflutils.sh
CLEANFILES			+=		\
	src/lib/libmbflutils.sh			\
	src/lib/$(am__dirstamp)

MBFL_LIBUTILS_LIBRARY		= $(builddir)/src/lib/libmbfl.sh
MBFL_LIBUTILS_MBFLPP		= $(builddir)/src/bin/mbflpp.sh
MBFL_LIBUTILS_ENV		= MBFL_LIBRARY=$(MBFL_LIBUTILS_LIBRARY); export MBFL_LIBRARY;
MBFL_LIBUTILS_RUN		= $(MBFL_LIBUTILS_ENV) $(MBFL_PROGRAM_BASH) $(MBFL_LIBUTILS_MBFLPP)
MBFL_LIBUTILS_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --preserve-comments

MBFL_LIBUTILS_PREREQUISITES	=		\
	$(MBFL_LIBUTILS_LIBRARY)		\
	$(MBFL_LIBUTILS_MBFLPP)			\
	src/lib/$(am__dirstamp)			\
	$(MBFL_PREPROCESSOR)

src/lib/libmbflutils.sh: src/lib/libmbflutils.sh.m4 $(MBFL_LIBUTILS_PREREQUISITES)
	$(MBFL_LIBUTILS_RUN) $(MBFL_LIBUTILS_FLAGS) <$< >$@


#### libmbfltest generation

EXTRA_DIST			+= src/lib/libmbfltest.sh.m4
mbfllibtestdir			= $(MBFL_LIB_INSTDIR)
mbfllibtest_DATA		= src/lib/libmbfltest.sh
CLEANFILES			+=		\
	src/lib/libmbfltest.sh			\
	src/lib/$(am__dirstamp)

MBFL_LIBTEST_LIBRARY		= $(builddir)/src/lib/libmbfl.sh
MBFL_LIBTEST_MBFLPP		= $(builddir)/src/bin/mbflpp.sh
MBFL_LIBTEST_ENV		= MBFL_LIBRARY=$(MBFL_LIBTEST_LIBRARY); export MBFL_LIBRARY;
MBFL_LIBTEST_RUN		= $(MBFL_LIBTEST_ENV) $(MBFL_PROGRAM_BASH) $(MBFL_LIBTEST_MBFLPP)
MBFL_LIBTEST_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --preserve-comments

MBFL_LIBTEST_PREREQUISITES	=		\
	$(MBFL_LIBTEST_LIBRARY)			\
	$(MBFL_LIBTEST_MBFLPP)			\
	src/lib/$(am__dirstamp)			\
	$(MBFL_PREPROCESSOR)

src/lib/libmbfltest.sh: src/lib/libmbfltest.sh.m4 $(MBFL_LIBTEST_PREREQUISITES)
	$(MBFL_LIBTEST_RUN) $(MBFL_LIBTEST_FLAGS) <$< >$@


#### examples

EXTRA_DIST			+=		\
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

MBFL_EXAMPLES_BUILT_FILES	=		\
	examples/at.sh				\
	examples/compress.sh			\
	examples/pwentries.sh			\
	examples/sendmail-mbfl.sh		\
	examples/template-actions.sh		\
	examples/template.sh

noinst_SCRIPTS			= $(MBFL_EXAMPLES_BUILT_FILES)

CLEANFILES			+=		\
	$(MBFL_EXAMPLES_BUILT_FILES)		\
	examples/$(am__dirstamp)

MBFL_EXAMPLES_LIBRARY		= $(builddir)/src/lib/libmbfl.sh
MBFL_EXAMPLES_MBFLPP		= $(builddir)/src/bin/mbflpp.sh
MBFL_EXAMPLES_ENV		= MBFL_LIBRARY=$(MBFL_EXAMPLES_LIBRARY); export MBFL_LIBRARY;
MBFL_EXAMPLES_RUN		= $(MBFL_EXAMPLES_ENV) $(MBFL_PROGRAM_BASH) $(MBFL_EXAMPLES_MBFLPP)
MBFL_EXAMPLES_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --add-bash

MBFL_EXAMPLES_PREREQUISITES	=		\
	$(MBFL_EXAMPLES_LIBRARY)		\
	$(MBFL_EXAMPLES_MBFLPP)			\
	examples/$(am__dirstamp)		\
	$(MBFL_PREPROCESSOR)

examples/$(am__dirstamp):
	@$(MKDIR_P) examples
	@: > examples/$(am__dirstamp)

examples/at.sh: examples/at.sh.m4 $(MBFL_EXAMPLES_PREREQUISITES)
	$(MBFL_EXAMPLES_RUN) $(MBFL_EXAMPLES_FLAGS) <$< >$@

examples/compress.sh: examples/compress.sh.m4 $(MBFL_EXAMPLES_PREREQUISITES)
	$(MBFL_EXAMPLES_RUN) $(MBFL_EXAMPLES_FLAGS) <$< >$@

examples/pwentries.sh: examples/pwentries.sh.m4 $(MBFL_EXAMPLES_PREREQUISITES)
	$(MBFL_EXAMPLES_RUN) $(MBFL_EXAMPLES_FLAGS) <$< >$@

examples/sendmail-mbfl.sh: examples/sendmail-mbfl.sh.m4 $(MBFL_EXAMPLES_PREREQUISITES)
	$(MBFL_EXAMPLES_RUN) $(MBFL_EXAMPLES_FLAGS) <$< >$@

examples/template.sh: examples/template.sh.m4 $(MBFL_EXAMPLES_PREREQUISITES)
	$(MBFL_EXAMPLES_RUN) $(MBFL_EXAMPLES_FLAGS) <$< >$@

examples/template-actions.sh: examples/template-actions.sh.m4 $(MBFL_EXAMPLES_PREREQUISITES)
	$(MBFL_EXAMPLES_RUN) $(MBFL_EXAMPLES_FLAGS) <$< >$@

if WANT_SENDMAIL

dist_lisp_LISP		= examples/sendmail-mbfl.el
bin_SCRIPTS		+= examples/sendmail-mbfl.sh

endif


#### interface to "make check"

EXTRA_DIST			+=		\
	tests/getopts.test.m4			\
	tests/process.test.m4			\
	tests/program.test.m4			\
	tests/semver.test.m4			\
	tests/strings.test.m4			\
	tests/system.test.m4			\
	tests/variables.test.m4			\
	\
	tests/arrays.test			\
	tests/atexit.test			\
	tests/compress.test			\
	tests/encode.test			\
	tests/fd.test				\
	tests/file.test				\
	tests/locations.test			\
	tests/message.test			\
	tests/script.test			\
	tests/signal.test			\
	tests/times-and-dates.test		\
	tests/bash-feature-coproc.test		\
	\
	tests/setup.sh				\
	tests/signaltest.sh

CHECK_BUILT_EXAMPLES		=		\
	examples/compress.sh			\
	examples/template.sh			\
	examples/template-actions.sh

CHECK_BUILT_TESTS		=		\
	tests/getopts.test			\
	tests/process.test			\
	tests/program.test			\
	tests/semver.test			\
	tests/strings.test			\
	tests/system.test			\
	tests/variables.test

check_SCRIPTS			=		\
	$(CHECK_BUILT_EXAMPLES)			\
	$(CHECK_BUILT_TESTS)

TESTS				=		\
	tests/arrays.test			\
	tests/atexit.test			\
	tests/compress.test			\
	tests/encode.test			\
	tests/fd.test				\
	tests/file.test				\
	tests/getopts.test			\
	tests/locations.test			\
	tests/message.test			\
	tests/process.test			\
	tests/program.test			\
	tests/script.test			\
	tests/semver.test			\
	tests/signal.test			\
	tests/strings.test			\
	tests/system.test			\
	tests/times-and-dates.test		\
	tests/variables.test			\
	\
	tests/bash-feature-coproc.test

CLEANFILES			+=		\
	$(CHECK_BUILT_TESTS)			\
	$(builddir)/tests/$(am__dirstamp)

## --------------------------------------------------------------------

MBFL_TESTS_VERBENV	= TESTSUCCESS=yes; export TESTSUCCESS; TESTSTART=yes; export TESTSTART;

MBFL_TESTS_LIBRARY	= $(builddir)/src/lib/libmbfl.sh
MBFL_TESTS_MBFLPP	= $(builddir)/src/bin/mbflpp.sh
MBFL_TESTS_ENV		= MBFL_LIBRARY=$(MBFL_TESTS_LIBRARY); export MBFL_LIBRARY;
# We reset PATH so we can load files with the "source" command.
MBFL_TESTS_ENV		+= PATH=$(srcdir)/tests:$(builddir)/tests:$(srcdir)/src/lib:$(PATH); export PATH;
# We  set TMPDIR  because  if the  "/tmp" directory  is  mounted on  a
# separate partition with "noexec"  attribute: tests for executability
# of files  will fail if  the temporary  test files are  created under
# "/tmp".
MBFL_TESTS_ENV		+= TMPDIR=$(PWD)/tmp; export TMPDIR;
# We need to access some files in the examples dir.
MBFL_TESTS_ENV		+= examplesdir=$(builddir)/examples; export examplesdir;
MBFL_TESTS_ENV		+= MBFLTEST_LIBRARY=$(builddir)/src/lib/libmbfltest.sh; export MBFLTEST_LIBRARY;
MBFL_TESTS_ENV		+= TESTMATCH=$(TESTMATCH); export TESTMATCH;
MBFL_TESTS_RUN		= $(MBFL_TESTS_ENV) $(MBFL_PROGRAM_BASH) $(MBFL_TESTS_MBFLPP)
MBFL_TESTS_FLAGS	= $(MBFLPP_GENERAL_FLAGS) --add-bash

MBFL_TESTS_PREREQUISITES	=		\
	$(MBFL_TESTS_LIBRARY)			\
	$(MBFL_TESTS_MBFLPP)			\
	tests/$(am__dirstamp)			\
	$(MBFL_PREPROCESSOR)

# Read "Parallel Test Harness" in the documentation of GNU Automake to
# understand how to use this interface for "make check".
#
# We must make sure that this ends with a semicolon!!!
AM_TESTS_ENVIRONMENT	= $(MBFL_TESTS_VERBENV) $(MBFL_TESTS_ENV)
TEST_EXTENSIONS		= .test
TEST_LOG_COMPILER	= $(MBFL_PROGRAM_BASH)
AM_TEST_LOG_FLAGS	= $(MBFLFLAGS)

## --------------------------------------------------------------------

$(builddir)/tests/$(am__dirstamp):
	@$(MKDIR_P) tests
	@: > tests/$(am__dirstamp)

tests/%.test: tests/%.test.m4 $(MBFL_TESTS_PREREQUISITES)
	$(MBFL_TESTS_RUN) $(MBFL_TESTS_FLAGS) <$< >$@


#### additional test rules

.PHONY: test test-template test-template-actions test-script-atexit
.PHONY: test-sendmail-gmail test-sendmail-poste test-sendmail-localhost

test: all $(check_SCRIPTS)
	shopt -s nullglob; for item in $(srcdir)/tests/*$(file)*.test $(builddir)/tests/*$(file)*.test;	\
	do $(AM_TESTS_ENVIRONMENT) $(MBFL_PROGRAM_BASH) "$$item" $(AM_TEST_LOG_FLAGS);	\
	done

test-template: examples/template.sh src/lib/libmbfl.sh
	MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh $(MBFL_PROGRAM_BASH) $(builddir)/examples/template.sh $(MBFLFLAGS)

test-template-actions: examples/template-actions.sh src/lib/libmbfl.sh
	MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh $(MBFL_PROGRAM_BASH) $(builddir)/examples/template-actions.sh $(MBFLFLAGS)

test-script-atexit:
	MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh $(MBFL_PROGRAM_BASH) $(srcdir)/tests/script-atexit.sh $(MBFLFLAGS)

test-sendmail-gmail:
	MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh $(MBFL_PROGRAM_BASH) $(srcdir)/examples/test-sendmail-gmail.sh $(MBFLFLAGS)

test-sendmail-poste:
	MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh $(MBFL_PROGRAM_BASH) $(srcdir)/examples/test-sendmail-poste.sh $(MBFLFLAGS)

test-sendmail-localhost:
	MBFL_LIBRARY=$(builddir)/src/lib/libmbfl.sh $(MBFL_PROGRAM_BASH) $(srcdir)/examples/test-sendmail-localhost.sh $(MBFLFLAGS)


#### interface to "make installcheck"

MBFL_INSTCHECK_FLAGS	= $(user_flags)
# This thing with the PATH environment variable is needed to run
# distcheck successfully.
MBFL_INSTCHECK_ENV	= PATH=$(srcdir)/tests:$(builddir)/tests:$(DESTDIR)$(bindir):$$PATH; export PATH;
MBFL_INSTCHECK_ENV	+= PATH="`mbfl-config --libpath`":$$PATH; export PATH;
MBFL_INSTCHECK_ENV	+= MBFL_LIBRARY="`mbfl-config --library`"; export MBFL_LIBRARY;
MBFL_INSTCHECK_ENV	+= MBFLTEST_LIBRARY="`mbfl-config --testlib`"; export MBFLTEST_LIBRARY;
MBFL_INSTCHECK_ENV	+= TMPDIR=$(PWD)/tmp; export TMPDIR; examplesdir=$(srcdir)/examples; export examplesdir;
MBFL_INSTCHECK_RUN	= $(MBFL_INSTCHECK_ENV) $(MBFL_PROGRAM_BASH) $(MBFL_INSTCHECK_FLAGS)

installcheck-local:
	@for f in $(TESTS);					\
	do							\
		if   test -f $(srcdir)/$$f ;			\
		then $(MBFL_INSTCHECK_RUN) $(srcdir)/$$f ;	\
		elif test -f $(builddir)/$$f ;			\
		then $(MBFL_INSTCHECK_RUN) $(builddir)/$$f ;	\
		fi;						\
	done

### end of file
