## Process this file with automake to produce Makefile.in
#
# This is how it goes:
#
# 1.   Generate the  built scripts  using: the  backup libraries;  the
# source preprocessor.
#
# 2.  Generate  the  built  library "libmbfl.bash"  using:  the  built
# scripts; the source preprocessor.
#
# 3.  Generate  the built library "libmbfltest.bash"  using: the built
# scripts; the built "libmbfl.bash"; the source preprocessor.
#
# 4.  Generate the built library "libmbfl-utils.bash" using: the built
# scripts; the built "libmbfl.bash"; the source preprocessor.
#
# 5. Generate the  built examples using: the built  scripts; the built
# "libmbfl.bash"; the source preprocessor.
#

ACLOCAL_AMFLAGS		= -I meta/autotools
AUTOMAKE_OPTIONS	= foreign
EXTRA_DIST		= README COPYING INSTALL NEWS
CLEANFILES		=
MAINTAINERCLEANFILES	=
MBFL_LIB_INSTDIR	= $(datadir)/$(PACKAGE)

## --------------------------------------------------------------------

MBFL_PROGRAM_BASH	= @MBFL_PROGRAM_BASH@

# This  script  is  generated  by  "configure"  after  processing  the
# template in "$(srcdir)/src/bin/mbflpp.bash.in".
#
MBFL_PROGRAM_MBFLPP	= $(builddir)/src/bin/mbflpp.bash
MBFL_RUN_MBFLPP		= $(MBFL_PROGRAM_BASH) $(MBFL_PROGRAM_MBFLPP)

# These flags are always used on  the command line of "mbflpp.bash".  We
# can set "MBFLPPFLAGS" on the command line of "make".
#
MBFLPP_GENERAL_FLAGS	= --no-prepro --library=$(srcdir)/src/lib/preprocessor.m4 $(MBFLPPFLAGS)

EXTRA_DIST		+=			\
	src/backup/libmbfl.bash			\
	src/backup/preprocessor.m4


#### meta infrastructure

autoconfdir		= $(datadir)/aclocal
dist_autoconf_DATA	= src/aclocal/mbfl.m4


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

bin_SCRIPTS			= src/bin/mbflpp.bash
CLEANFILES			+= src/bin/$(am__dirstamp)
MAINTAINERCLEANFILES		+= src/bin/mbflpp.bash

## --------------------------------------------------------------------

# MBFL_SCRIPTS_ENV		=
# MBFL_SCRIPTS_RUN		= $(MBFL_SCRIPTS_ENV) $(MBFL_RUN_MBFLPP)
# MBFL_SCRIPTS_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --add-bash --preserve-comments

# MBFL_SCRIPTS_PREREQUISITES	=		\
# 	$(MBFL_PREPROCESSOR)			\
#	$(MBFL_PROGRAM_MBFLPP)			\
# 	src/bin/$(am__dirstamp)

# src/bin/$(am__dirstamp):
# 	@$(MKDIR_P) src/bin
# 	@: > src/bin/$(am__dirstamp)

# src/bin/%.sh: src/bin/%.sh.m4 $(MBFL_SCRIPTS_PREREQUISITES)
# 	$(MBFL_SCRIPTS_RUN) $(MBFL_SCRIPTS_FLAGS) <$< >$@


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
	src/modules/config-values.sh		\
	src/modules/dialog.sh			\
	src/modules/encode.sh			\
	src/modules/fd.sh			\
	src/modules/file.sh			\
	src/modules/getopts.sh			\
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

MBFL_MODULES_LIBMBFL		= $(srcdir)/src/backup/libmbfl.bash
MBFL_MODULES_ENV		=
MBFL_MODULES_RUN		= $(MBFL_MODULES_ENV) $(MBFL_RUN_MBFLPP)
MBFL_MODULES_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --libmbfl="$(MBFL_MODULES_LIBMBFL)"

MBFL_MODULES_PREREQUISITES	=		\
	$(MBFL_PROGRAM_MBFLPP)			\
	$(MBFL_MODULES_LIBMBFL)			\
	src/modules/$(am__dirstamp)		\
	$(MBFL_PREPROCESSOR)

src/modules/$(am__dirstamp):
	@$(MKDIR_P) src/modules
	@: > src/modules/$(am__dirstamp)

src/modules/%.sh: src/modules/%.sh.m4 $(MBFL_MODULES_PREREQUISITES)
	$(MBFL_MODULES_RUN) $(MBFL_MODULES_FLAGS) <$< >$@


#### libmbfl generation

EXTRA_DIST			+= src/lib/libmbfl.bash.m4
mbfllibdir			= $(MBFL_LIB_INSTDIR)
mbfllib_DATA			= src/lib/libmbfl.bash
CLEANFILES			+=		\
	src/lib/libmbfl.bash			\
	src/lib/$(am__dirstamp)

MBFL_LIB_ENV		=
MBFL_LIB_RUN		= $(MBFL_LIB_ENV) $(MBFL_RUN_MBFLPP)
MBFL_LIB_FLAGS		=  $(MBFLPP_GENERAL_FLAGS) --preserve-comments --include=$(builddir)/src/modules

MBFL_LIB_PREREQUISITES	=			\
	src/lib/$(am__dirstamp)			\
	$(MBFL_PROGRAM_MBFLPP)			\
	$(MBFL_PREPROCESSOR)

src/lib/$(am__dirstamp):
	@$(MKDIR_P) src/lib
	@: > src/lib/$(am__dirstamp)

src/lib/libmbfl.bash: src/lib/libmbfl.bash.m4 $(MBFL_LIB_MODULES) $(MBFL_LIB_PREREQUISITES)
	$(MBFL_LIB_RUN) $(MBFL_LIB_FLAGS) <$< >$@


#### libmbfl-utils generation: modules

EXTRA_DIST			+=		\
	src/utils-modules/utils-file.sh.m4

# This  is *not*  the  order  in which  modules  are  included in  the
# library; that order is established in the file "libmblutils.sh.m4"!
MBFL_LIBUTILS_MODULES		=		\
	src/utils-modules/utils-file.sh

CLEANFILES			+=		\
	$(MBFL_LIBUTILS_MODULES)		\
	src/utils-modules/$(am__dirstamp)

MBFL_UTILS_MODULES_ENV		=
MBFL_UTILS_MODULES_RUN		= $(MBFL_UTILS_MODULES_ENV) $(MBFL_RUN_MBFLPP)
MBFL_UTILS_MODULES_FLAGS	= $(MBFLPP_GENERAL_FLAGS)

MBFL_UTILS_MODULES_PREREQUISITES	=		\
	src/utils-modules/$(am__dirstamp)		\
	$(MBFL_PROGRAM_MBFLPP)				\
	$(MBFL_PREPROCESSOR)

src/utils-modules/$(am__dirstamp):
	@$(MKDIR_P) src/utils-modules
	@: > src/utils-modules/$(am__dirstamp)

src/utils-modules/%.sh: src/utils-modules/%.sh.m4 $(MBFL_UTILS_MODULES_PREREQUISITES)
	$(MBFL_UTILS_MODULES_RUN) $(MBFL_UTILS_MODULES_FLAGS) <$< >$@


#### libmbfl-utils generation

EXTRA_DIST			+= src/lib/libmbfl-utils.bash.m4
mbfllibutilsdir			= $(MBFL_LIB_INSTDIR)
mbfllibutils_DATA		= src/lib/libmbfl-utils.bash
CLEANFILES			+=		\
	src/lib/libmbfl-utils.bash			\
	src/lib/$(am__dirstamp)

MBFL_LIBUTILS_ENV		=
MBFL_LIBUTILS_RUN		= $(MBFL_LIBUTILS_ENV) $(MBFL_RUN_MBFLPP)
MBFL_LIBUTILS_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --preserve-comments --include=$(builddir)/src/utils-modules

MBFL_LIBUTILS_PREREQUISITES	=		\
	src/lib/$(am__dirstamp)			\
	$(MBFL_PROGRAM_MBFLPP)			\
	$(MBFL_PREPROCESSOR)

src/lib/libmbfl-utils.bash: src/lib/libmbfl-utils.bash.m4 $(MBFL_LIBUTILS_MODULES) $(MBFL_LIBUTILS_PREREQUISITES)
	$(MBFL_LIBUTILS_RUN) $(MBFL_LIBUTILS_FLAGS) <$< >$@


#### libmbfltest generation

EXTRA_DIST			+= src/lib/libmbfltest.bash.m4
mbfllibtestdir			= $(MBFL_LIB_INSTDIR)
mbfllibtest_DATA		= src/lib/libmbfltest.bash
CLEANFILES			+=		\
	src/lib/libmbfltest.bash			\
	src/lib/$(am__dirstamp)

MBFL_LIBTEST_ENV		=
MBFL_LIBTEST_RUN		= $(MBFL_LIBTEST_ENV) $(MBFL_RUN_MBFLPP)
MBFL_LIBTEST_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --preserve-comments

MBFL_LIBTEST_PREREQUISITES	=		\
	src/lib/$(am__dirstamp)			\
	$(MBFL_PROGRAM_MBFLPP)			\
	$(MBFL_PREPROCESSOR)

src/lib/libmbfltest.bash: src/lib/libmbfltest.bash.m4 $(MBFL_LIBTEST_PREREQUISITES)
	$(MBFL_LIBTEST_RUN) $(MBFL_LIBTEST_FLAGS) <$< >$@


#### libmbfl-at generation

EXTRA_DIST			+= src/lib/libmbfl-at.bash.m4
mbfllibatdir			= $(MBFL_LIB_INSTDIR)
mbfllibat_DATA			= src/lib/libmbfl-at.bash
CLEANFILES			+=		\
	src/lib/libmbfl-at.bash			\
	src/lib/$(am__dirstamp)

MBFL_LIBAT_ENV			=
MBFL_LIBAT_RUN			= $(MBFL_LIBAT_ENV) $(MBFL_RUN_MBFLPP)
MBFL_LIBAT_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --preserve-comments

MBFL_LIBAT_PREREQUISITES	=		\
	src/lib/$(am__dirstamp)			\
	$(MBFL_PROGRAM_MBFLPP)			\
	$(MBFL_PREPROCESSOR)

src/lib/libmbfl-at.bash: src/lib/libmbfl-at.bash.m4 $(MBFL_LIBAT_PREREQUISITES)
	$(MBFL_LIBAT_RUN) $(MBFL_LIBAT_FLAGS) <$< >$@


#### libmbfl-arch generation

EXTRA_DIST			+= src/lib/libmbfl-arch.bash.m4
mbfllibarchdir			= $(MBFL_LIB_INSTDIR)
mbfllibarch_DATA		= src/lib/libmbfl-arch.bash
CLEANFILES			+=		\
	src/lib/libmbfl-arch.bash		\
	src/lib/$(am__dirstamp)

MBFL_LIBARCH_ENV		=
MBFL_LIBARCH_RUN		= $(MBFL_LIBARCH_ENV) $(MBFL_RUN_MBFLPP)
MBFL_LIBARCH_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --preserve-comments

MBFL_LIBARCH_PREREQUISITES	=		\
	src/lib/$(am__dirstamp)			\
	$(MBFL_PROGRAM_MBFLPP)			\
	$(MBFL_PREPROCESSOR)

src/lib/libmbfl-arch.bash: src/lib/libmbfl-arch.bash.m4 $(MBFL_LIBARCH_PREREQUISITES)
	$(MBFL_LIBARCH_RUN) $(MBFL_LIBARCH_FLAGS) <$< >$@


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

MBFL_EXAMPLES_LIBMBFL		= $(builddir)/src/lib/libmbfl.bash
MBFL_EXAMPLES_ENV		=
MBFL_EXAMPLES_RUN		= $(MBFL_EXAMPLES_ENV) $(MBFL_RUN_MBFLPP)
MBFL_EXAMPLES_FLAGS		=  $(MBFLPP_GENERAL_FLAGS) --add-bash
MBFL_EXAMPLES_FLAGS		+= --libmbfl="$(MBFL_EXAMPLES_LIBMBFL)"
MBFL_EXAMPLES_FLAGS		+= --define=__LIBMBFL_AT__="$(builddir)/src/lib/libmbfl-at.bash"
MBFL_EXAMPLES_FLAGS		+= --define=__LIBMBFL_ARCH__="$(builddir)/src/lib/libmbfl-arch.bash"

MBFL_EXAMPLES_PREREQUISITES	=		\
	examples/$(am__dirstamp)		\
	$(MBFL_EXAMPLES_LIBMBFL)		\
	$(MBFL_PROGRAM_MBFLPP)			\
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
	tests/base.test.m4			\
	tests/arrays.test.m4			\
	tests/atexit.test.m4			\
	tests/bash-feature-coproc.test.m4	\
	tests/compress.test.m4			\
	tests/encode.test.m4			\
	tests/fd.test.m4			\
	tests/file.test.m4			\
	tests/getopts.test.m4			\
	tests/locations.test.m4			\
	tests/message.test.m4			\
	tests/process.test.m4			\
	tests/program.test.m4			\
	tests/script.test.m4			\
	tests/semver.test.m4			\
	tests/signal.test.m4			\
	tests/strings.test.m4			\
	tests/system.test.m4			\
	tests/times-and-dates.test.m4		\
	tests/variables.test.m4			\
	\
	tests/mbflutils-files.test.m4		\
	\
	tests/script-atexit.sh.m4		\
	tests/signaltest.sh.m4

MBFL_CHECK_BUILT_TESTS		=		\
	tests/base.test				\
	tests/arrays.test			\
	tests/atexit.test			\
	tests/bash-feature-coproc.test		\
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
	tests/mbflutils-files.test

MBFL_CHECK_BUILT_EXAMPLES		=	\
	examples/compress.sh			\
	examples/template.sh			\
	examples/template-actions.sh

check_SCRIPTS			=		\
	$(MBFL_CHECK_BUILT_EXAMPLES)		\
	$(MBFL_CHECK_BUILT_TESTS)

TESTS				=		\
	$(MBFL_CHECK_BUILT_TESTS)

CLEANFILES			+=		\
	$(MBFL_CHECK_BUILT_TESTS)		\
	$(builddir)/tests/$(am__dirstamp)	\
	tests/signaltest.sh			\
	tests/script-atexit.sh

## --------------------------------------------------------------------

MBFL_TESTS_VERBENV	= TESTSUCCESS=yes; export TESTSUCCESS; TESTSTART=yes; export TESTSTART;

MBFL_TESTS_LIBMBFL	= $(builddir)/src/lib/libmbfl.bash
MBFL_TESTS_LIBMBFLTEST	= $(builddir)/src/lib/libmbfltest.bash
MBFL_TESTS_LIBMBFLARCH	= $(builddir)/src/lib/libmbfl-arch.bash
MBFL_TESTS_LIBMBFLUTILS	= $(builddir)/src/lib/libmbfl-utils.bash
MBFL_TESTS_ENV		=  MBFL_TESTS_LIBMBFL=$(MBFL_TESTS_LIBMBFL); export MBFL_TESTS_LIBMBFL;
MBFL_TESTS_ENV		+= MBFL_TESTS_LIBMBFLTEST=$(MBFL_TESTS_LIBMBFLTEST); export MBFL_TESTS_LIBMBFLTEST;
MBFL_TESTS_ENV		+= MBFL_TESTS_LIBMBFLARCH=$(MBFL_TESTS_LIBMBFLARCH); export MBFL_TESTS_LIBMBFLARCH;
MBFL_TESTS_ENV		+= MBFL_TESTS_LIBMBFLUTILS=$(MBFL_TESTS_LIBMBFLUTILS); export MBFL_TESTS_LIBMBFLUTILS;
# We  set TMPDIR  because  if the  "/tmp" directory  is  mounted on  a
# separate partition with "noexec"  attribute: tests for executability
# of files  will fail if  the temporary  test files are  created under
# "/tmp".
MBFL_TESTS_ENV		+= TMPDIR=$(PWD)/tmp; export TMPDIR;
# We need to access some files in the examples dir and the tests dir.
MBFL_TESTS_ENV		+= testsdir=$(builddir)/tests; export testsdir;
MBFL_TESTS_ENV		+= examplesdir=$(builddir)/examples; export examplesdir;
MBFL_TESTS_ENV		+= TESTMATCH=$(TESTMATCH); export TESTMATCH;
MBFL_TESTS_RUN		= $(MBFL_TESTS_ENV) $(MBFL_RUN_MBFLPP)
MBFL_TESTS_FLAGS	=  $(MBFLPP_GENERAL_FLAGS) --add-bash --libmbfl="$(MBFL_TESTS_LIBMBFL)"
MBFL_TESTS_FLAGS	+= --define=__LIBMBFL_ARCH__="$(builddir)/src/lib/libmbfl-arch.bash"

MBFL_TESTS_PREREQUISITES	=		\
	tests/$(am__dirstamp)			\
	$(MBFL_TESTS_LIBMBFL)			\
	$(MBFL_TESTS_LIBMBFLTEST)		\
	$(MBFL_TESTS_LIBMBFLARCH)		\
	$(MBFL_TESTS_LIBMBFLUTILS)		\
	$(MBFL_PROGRAM_MBFLPP)			\
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

tests/%.sh: tests/%.sh.m4 $(MBFL_TESTS_PREREQUISITES)
	$(MBFL_TESTS_RUN) $(MBFL_TESTS_FLAGS) <$< >$@

tests/signal.test: tests/signaltest.sh


#### additional test rules

.PHONY: test test-template test-template-actions test-script-atexit
.PHONY: test-sendmail-gmail test-sendmail-poste test-sendmail-localhost

test: all $(check_SCRIPTS)
	shopt -s nullglob; for item in $(srcdir)/tests/*$(file)*.test $(builddir)/tests/*$(file)*.test;	\
	do $(AM_TESTS_ENVIRONMENT) $(MBFL_PROGRAM_BASH) "$$item" $(AM_TEST_LOG_FLAGS);	\
	done

test-template: examples/template.sh src/lib/libmbfl.bash
	$(AM_TESTS_ENVIRONMENT) $(MBFL_PROGRAM_BASH) $(builddir)/examples/template.sh $(MBFLFLAGS)

test-template-actions: examples/template-actions.sh src/lib/libmbfl.bash
	$(AM_TESTS_ENVIRONMENT) $(MBFL_PROGRAM_BASH) $(builddir)/examples/template-actions.sh $(MBFLFLAGS)

test-script-atexit: tests/script-atexit.sh
	$(AM_TESTS_ENVIRONMENT) $(MBFL_PROGRAM_BASH) $(builddir)/tests/script-atexit.sh $(MBFLFLAGS)

test-sendmail-gmail:
	$(AM_TESTS_ENVIRONMENT) $(MBFL_PROGRAM_BASH) $(srcdir)/examples/test-sendmail-gmail.sh $(MBFLFLAGS)

test-sendmail-poste:
	$(AM_TESTS_ENVIRONMENT) $(MBFL_PROGRAM_BASH) $(srcdir)/examples/test-sendmail-poste.sh $(MBFLFLAGS)

test-sendmail-localhost:
	$(AM_TESTS_ENVIRONMENT) $(MBFL_PROGRAM_BASH) $(srcdir)/examples/test-sendmail-localhost.sh $(MBFLFLAGS)


#### interface to "make installcheck"

MBFL_INSTCHECK_FLAGS	= $(user_flags)
# This thing with the PATH environment variable is needed to run
# distcheck successfully.
MBFL_INSTCHECK_ENV	= PATH=$(srcdir)/tests:$(builddir)/tests:$(DESTDIR)$(bindir):$$PATH; export PATH;
MBFL_INSTCHECK_ENV	+= PATH="`mbflpp.bash --print-libdir`":$$PATH; export PATH;
MBFL_INSTCHECK_ENV	+= MBFL_TESTS_LIBMBFL="`mbflpp.bash --print-libmbfl`"; export MBFL_TESTS_LIBMBFL;
MBFL_INSTCHECK_ENV	+= MBFL_TESTS_LIBMBFLTEST="`mbflpp.bash --print-libmbfltest`"; export MBFL_TESTS_LIBMBFLTEST;
MBFL_INSTCHECK_ENV	+= MBFL_TESTS_LIBMBFLARCH="`mbflpp.bash --print-libdir`/libmbfl-arch.bash"; export MBFL_TESTS_LIBMBFLARCH;
MBFL_INSTCHECK_ENV	+= testsdir=$(builddir)/tests; export testsdir;
MBFL_INSTCHECK_ENV	+= examplesdir=$(builddir)/examples; export examplesdir;
MBFL_INSTCHECK_ENV	+= TMPDIR=$(PWD)/tmp; export TMPDIR;
MBFL_INSTCHECK_ENV	+= examplesdir=$(builddir)/examples; export examplesdir;
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
