## Process this file with automake to produce Makefile.in
#
# This is how it goes:
#
# 1.   Generate the  built scripts  using: the  backup libraries;  the
# source preprocessor.
#
# 2.  Generate the built  library "libmbfl-core.bash" using: the built
# scripts; the source preprocessor.
#
# 3.  Generate the built library "libmbfl-tests.bash" using: the built
# scripts; the built "libmbfl-core.bash"; the source preprocessor.
#
# 4.  Generate the built library "libmbfl-utils.bash" using: the built
# scripts; the built "libmbfl-core.bash"; the source preprocessor.
#
# 5. Generate the  built examples using: the built  scripts; the built
# "libmbfl-core.bash"; the source preprocessor.
#

ACLOCAL_AMFLAGS		= -I meta/autotools
AUTOMAKE_OPTIONS	= foreign
EXTRA_DIST		= README COPYING INSTALL NEWS
BUILT_SOURCES		=
CLEANFILES		=
DISTCLEANFILES		=

# These flags are always used on the command line of "mbflpp.bash".
# We can set "MBFLPPFLAGS" on the command line of "make".
#
MBFLPP_GENERAL_FLAGS	= --no-prepro --library=$(MBFL_PREPROCESSOR) --define=__LIBMBFL_LINKER__="$(builddir)/src/lib/libmbfl-linker.bash" $(MBFLPPFLAGS)

## --------------------------------------------------------------------

MBFL_PROGRAM_BASH	= @MBFL_PROGRAM_BASH@
MBFL_LIB_INSTDIR	= $(datadir)/$(PACKAGE)

BUILT_SOURCES		+=			\
	src/bin/mbflpp.bash.m4			\
	src/modules/config-values.bash.m4

EXTRA_DIST		+=			\
	src/backup/mbflpp.bash			\
	src/backup/libmbfl-core.bash		\
	src/backup/libmbfl-preprocessor.m4

ETAGS_ARGS		=
AM_ETAGSFLAGS		= --language=none					\
	--regex='/function[ \t]+\([a-zA-Z0-9_\-]+\)/\1/'			\
	--regex='/mbfl_default_class_declare(\([a-zA-Z0-9_\-]+\))/\1/'


#### GNU Automake am__dirstamp files

MBFL_AM_DIRSTAMP_FILES	=				\
	doc/$(am__dirstamp)				\
	doc/mbfl.html/$(am__dirstamp)			\
	examples/$(am__dirstamp)			\
	src/bin/$(am__dirstamp)				\
	src/etc/bash_completion.d/$(am__dirstamp)	\
	src/lib/$(am__dirstamp)				\
	src/modules/$(am__dirstamp)			\
	src/utils-modules/$(am__dirstamp)		\
	tests/$(am__dirstamp)

BUILT_SOURCES		+= $(MBFL_AM_DIRSTAMP_FILES)
DISTCLEANFILES		+= $(MBFL_AM_DIRSTAMP_FILES)

doc/mbfl.html/$(am__dirstamp): doc/$(am__dirstamp)
	@$(MKDIR_P) doc/mbfl.html/
	@: > doc/mbfl.html/$(am__dirstamp)

src/bin/$(am__dirstamp):
	@$(MKDIR_P) src/bin
	@: > src/bin/$(am__dirstamp)

src/modules/$(am__dirstamp):
	@$(MKDIR_P) src/modules
	@: > src/modules/$(am__dirstamp)

src/lib/$(am__dirstamp):
	@$(MKDIR_P) src/lib
	@: > src/lib/$(am__dirstamp)

src/utils-modules/$(am__dirstamp):
	@$(MKDIR_P) src/utils-modules
	@: > src/utils-modules/$(am__dirstamp)

examples/$(am__dirstamp):
	@$(MKDIR_P) examples
	@: > examples/$(am__dirstamp)

src/etc/bash_completion.d/$(am__dirstamp):
	@$(MKDIR_P) src/etc/bash_completion.d
	@: > src/etc/bash_completion.d/$(am__dirstamp)

$(builddir)/tests/$(am__dirstamp):
	@$(MKDIR_P) tests
	@: > tests/$(am__dirstamp)


#### meta infrastructure

autoconfdir		= $(datadir)/aclocal
dist_autoconf_DATA	= src/aclocal/mbfl.m4


#### documentation

EXTRA_DIST		+=						\
	doc/one-level-actions.sh					\
	doc/two-levels-actions.sh					\
	doc/mbfl.style.css
CLEANFILES		+= doc/mbfl.css

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
	doc/one-level-actions.sh

## --------------------------------------------------------------------

doc/mbfl.html/mbfl.css: doc/mbfl.style.css
	$(INSTALL) -m 0444 \
		"$(top_srcdir)/doc/mbfl.style.css" \
		"$(builddir)/doc/mbfl.html/mbfl.css"

## --------------------------------------------------------------------

html-local: doc/mbfl.html/mbfl.css

install-html-local:
	$(MKDIR_P) "$(DESTDIR)$(htmldir)/mbfl.html/"
	$(INSTALL) -m 0444 $(builddir)/doc/mbfl.html/mbfl.css "$(DESTDIR)$(htmldir)/mbfl.html/"


#### support for GNU Emacs

if WANT_EMACS
sharelispdir		= $(datadir)/emacs/site-lisp
dist_sharelisp_LISP	= src/emacs/mbfl.el
endif


#### preprocessor macros file

MBFL_PREPROCESSOR		= $(top_srcdir)/src/lib/libmbfl-preprocessor.m4
mbflpreprodir			= $(MBFL_LIB_INSTDIR)
dist_mbflprepro_DATA		= $(MBFL_PREPROCESSOR)


#### scripts generation

bin_SCRIPTS			= src/bin/mbflpp.bash
CLEANFILES			+= src/bin/mbflpp.bash

## ------------------------------------------------------------------------

# We use the backup preprocessor to generate the new preprocessor scrpt.
#
MBFL_BACKUP_PROGRAM_MBFLPP	= $(top_srcdir)/src/backup/mbflpp.bash
MBFL_BACKUP_RUN_MBFLPP		= $(MBFL_PROGRAM_BASH) $(MBFL_BACKUP_PROGRAM_MBFLPP)

MBFL_SCRIPTS_ENV		=
MBFL_SCRIPTS_RUN		= $(MBFL_SCRIPTS_ENV) $(MBFL_BACKUP_RUN_MBFLPP)
MBFL_SCRIPTS_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --add-bash

MBFL_SCRIPTS_PREREQUISITES	=		\
	$(MBFL_PREPROCESSOR)			\
	$(MBFL_BACKUP_PROGRAM_MBFLPP)

src/bin/%.bash: src/bin/%.bash.m4 $(MBFL_SCRIPTS_PREREQUISITES)
	$(MBFL_SCRIPTS_RUN) $(MBFL_SCRIPTS_FLAGS) --output=$@ $<

## ------------------------------------------------------------------------

# We use these variables in this Makefile.
#
MBFL_PROGRAM_MBFLPP	= $(builddir)/src/bin/mbflpp.bash
MBFL_RUN_MBFLPP		= $(MBFL_PROGRAM_BASH) $(MBFL_PROGRAM_MBFLPP)


#### libmbfl-linker generation

libmbfl_linkerdir		= $(MBFL_LIB_INSTDIR)
libmbfl_linker_DATA		= src/lib/libmbfl-linker.bash
libmbfl_linker_BSOURCES		= $(srcdir)/src/lib/libmbfl-linker.bash.m4
EXTRA_DIST			+= $(libmbfl_linker_BSOURCES)
ETAGS_ARGS			+= $(libmbfl_linker_BSOURCES)
CLEANFILES			+= src/lib/libmbfl-linker.bash

libmbfl_linker_ENV		=
libmbfl_linker_RUN		= $(libmbfl_linker_ENV) $(MBFL_RUN_MBFLPP)
libmbfl_linker_FLAGS		= $(MBFLPP_GENERAL_FLAGS)

libmbfl_linker_PREREQUISITES	=	\
	$(MBFL_PROGRAM_MBFLPP)		\
	$(MBFL_PREPROCESSOR)

src/lib/libmbfl-linker.bash: src/lib/libmbfl-linker.bash.m4 $(libmbfl_linker_PREREQUISITES)
	$(libmbfl_linker_RUN) $(libmbfl_linker_FLAGS) --output=$@ $<


#### libmbfl modules generation

libmbfldir		= $(MBFL_LIB_INSTDIR)
libmbfl_DATA		= src/lib/libmbfl-core.bash

# We use the prefix "$(srcdir)/" so that "etags" will find the
# sources.
#
libmbfl_MODULES		=					\
	$(srcdir)/src/modules/actions.bash.m4			\
	$(srcdir)/src/modules/arrays.bash.m4			\
	$(srcdir)/src/modules/atexit.bash.m4			\
	$(srcdir)/src/modules/base.bash.m4			\
	$(srcdir)/src/modules/dialog.bash.m4			\
	$(srcdir)/src/modules/encode.bash.m4			\
	$(srcdir)/src/modules/exception-handlers.bash.m4	\
	$(srcdir)/src/modules/exceptional-conditions.bash.m4	\
	$(srcdir)/src/modules/fd.bash.m4			\
	$(srcdir)/src/modules/file.bash.m4			\
	$(srcdir)/src/modules/getopts.bash.m4			\
	$(srcdir)/src/modules/hooks.bash.m4			\
	$(srcdir)/src/modules/functions.bash.m4			\
	$(srcdir)/src/modules/integers.bash.m4			\
	$(srcdir)/src/modules/locations.bash.m4			\
	$(srcdir)/src/modules/main.bash.m4			\
	$(srcdir)/src/modules/math.bash.m4			\
	$(srcdir)/src/modules/message.bash.m4			\
	$(srcdir)/src/modules/process.bash.m4			\
	$(srcdir)/src/modules/program.bash.m4			\
	$(srcdir)/src/modules/semver.bash.m4			\
	$(srcdir)/src/modules/signal.bash.m4			\
	$(srcdir)/src/modules/string.bash.m4			\
	$(srcdir)/src/modules/object.bash.m4			\
	$(srcdir)/src/modules/system.bash.m4			\
	$(srcdir)/src/modules/times-and-dates.bash.m4		\
	$(srcdir)/src/modules/variable.bash.m4

libmbfl_BSOURCES	= $(libmbfl_MODULES) $(srcdir)/src/lib/libmbfl-core.bash.m4
EXTRA_DIST		+= $(libmbfl_BSOURCES)
ETAGS_ARGS		+= $(libmbfl_BSOURCES)

# This  is *not*  the  order  in which  modules  are  included in  the
# library; that order is established in the file "libmbfl-core.bash.m4"!
#
libmbfl_PROCESSED_MODULES	=			\
	src/modules/actions.bash			\
	src/modules/arrays.bash				\
	src/modules/atexit.bash				\
	src/modules/base.bash				\
	src/modules/config-values.bash			\
	src/modules/dialog.bash				\
	src/modules/encode.bash				\
	src/modules/exception-handlers.bash		\
	src/modules/exceptional-conditions.bash		\
	src/modules/fd.bash				\
	src/modules/file.bash				\
	src/modules/getopts.bash			\
	src/modules/hooks.bash				\
	src/modules/functions.bash			\
	src/modules/integers.bash			\
	src/modules/locations.bash			\
	src/modules/main.bash				\
	src/modules/math.bash				\
	src/modules/message.bash			\
	src/modules/process.bash			\
	src/modules/program.bash			\
	src/modules/semver.bash				\
	src/modules/signal.bash				\
	src/modules/string.bash				\
	src/modules/object.bash				\
	src/modules/system.bash				\
	src/modules/times-and-dates.bash		\
	src/modules/variable.bash

.INTERMEDIATE:	$(libmbfl_PROCESSED_MODULES)
.SECONDARY:	$(libmbfl_PROCESSED_MODULES)

CLEANFILES			+=			\
	src/lib/libmbfl-core.bash			\
	$(libmbfl_PROCESSED_MODULES)

## ------------------------------------------------------------------------

libmbfl_MODULES_ENV		=
libmbfl_MODULES_RUN		= $(libmbfl_MODULES_ENV) $(MBFL_RUN_MBFLPP)
libmbfl_MODULES_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --libmbfl="$(srcdir)/src/backup/libmbfl-core.bash"

libmbfl_MODULES_PREREQUISITES	=		\
	$(MBFL_PROGRAM_MBFLPP)			\
	$(MBFL_PREPROCESSOR)			\
	$(srcdir)/src/backup/libmbfl-core.bash	\
	$(builddir)/src/lib/libmbfl-linker.bash

src/modules/%.bash: src/modules/%.bash.m4 $(libmbfl_MODULES_PREREQUISITES)
	$(libmbfl_MODULES_RUN) $(libmbfl_MODULES_FLAGS) $< >$@

## ------------------------------------------------------------------------

libmbfl_ENV		=
libmbfl_RUN		= $(libmbfl_ENV) $(MBFL_RUN_MBFLPP)
libmbfl_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --include=$(builddir)/src/modules

libmbfl_PREREQUISITES	=			\
	$(MBFL_PROGRAM_MBFLPP)			\
	$(MBFL_PREPROCESSOR)

src/lib/libmbfl-core.bash: src/lib/libmbfl-core.bash.m4 $(libmbfl_PROCESSED_MODULES) $(libmbfl_PREREQUISITES)
	$(libmbfl_RUN) $(libmbfl_FLAGS) --output=$@ $<

install-data-hook:
	cd $(DESTDIR)$(libmbfldir) && \
	$(LN_S) libmbfl-core.bash libmbfl.bash


#### libmbfl-utils generation: modules

libmbfl_utilsdir	= $(MBFL_LIB_INSTDIR)
libmbfl_utils_DATA	= src/lib/libmbfl-utils.bash

libmbfl_utils_MODULES	=		\
	$(srcdir)/src/utils-modules/utils-file.bash.m4

libmbfl_utils_BSOURCES	= $(libmbfl_utils_MODULES) $(srcdir)/src/lib/libmbfl-utils.bash.m4
EXTRA_DIST		+= $(libmbfl_utils_BSOURCES)
ETAGS_ARGS		+= $(libmbfl_utils_BSOURCES)

libmbfl_utils_PROCESSED_MODULES	=		\
	src/utils-modules/utils-file.bash

.INTERMEDIATE:	$(libmbfl_utils_PROCESSED_MODULES)
.SECONDARY:	$(libmbfl_utils_PROCESSED_MODULES)

CLEANFILES		+=			\
	src/lib/libmbfl-utils.bash		\
	$(libmbfl_utils_PROCESSED_MODULES)

## ------------------------------------------------------------------------

libmbfl_utils_MODULES_ENV	=
libmbfl_utils_MODULES_RUN	= $(libmbfl_utils_MODULES_ENV) $(MBFL_RUN_MBFLPP)
libmbfl_utils_MODULES_FLAGS	= $(MBFLPP_GENERAL_FLAGS)

libmbfl_utils_MODULES_PREREQUISITES	=	\
	$(MBFL_PROGRAM_MBFLPP)			\
	$(MBFL_PREPROCESSOR)			\
	$(builddir)/src/lib/libmbfl-linker.bash

src/utils-modules/%.bash: src/utils-modules/%.bash.m4 $(libmbfl_utils_MODULES_PREREQUISITES)
	$(libmbfl_utils_MODULES_RUN) $(libmbfl_utils_MODULES_FLAGS) --output=$@ $<

## ------------------------------------------------------------------------

libmbfl_utils_ENV		=
libmbfl_utils_RUN		= $(libmbfl_utils_ENV) $(MBFL_RUN_MBFLPP)
libmbfl_utils_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --include=$(builddir)/src/utils-modules

libmbfl_utils_PREREQUISITES	=		\
	$(MBFL_PROGRAM_MBFLPP)			\
	$(MBFL_PREPROCESSOR)

src/lib/libmbfl-utils.bash: src/lib/libmbfl-utils.bash.m4 $(libmbfl_utils_PROCESSED_MODULES) $(libmbfl_utils_PREREQUISITES)
	$(libmbfl_utils_RUN) $(libmbfl_utils_FLAGS) --output=$@ $<


#### libmbfl-tests generation

libmbfl_testsdir	= $(MBFL_LIB_INSTDIR)
libmbfl_tests_DATA	= src/lib/libmbfl-tests.bash
libmbfl_tests_BSOURCES	= $(srcdir)/src/lib/libmbfl-tests.bash.m4
EXTRA_DIST		+= $(libmbfl_tests_BSOURCES)
ETAGS_ARGS		+= $(libmbfl_tests_BSOURCES)
CLEANFILES		+= src/lib/libmbfl-tests.bash

libmbfl_tests_ENV	=
libmbfl_tests_RUN	= $(libmbfl_tests_ENV) $(MBFL_RUN_MBFLPP)
libmbfl_tests_FLAGS	= $(MBFLPP_GENERAL_FLAGS)

libmbfl_tests_PREREQUISITES	=		\
	$(MBFL_PROGRAM_MBFLPP)			\
	$(MBFL_PREPROCESSOR)			\
	$(builddir)/src/lib/libmbfl-linker.bash

src/lib/libmbfl-tests.bash: src/lib/libmbfl-tests.bash.m4 $(libmbfl_tests_PREREQUISITES)
	$(libmbfl_tests_RUN) $(libmbfl_tests_FLAGS) --output=$@ $<


#### libmbfl-at generation

libmbfl_atdir		= $(MBFL_LIB_INSTDIR)
libmbfl_at_DATA		= src/lib/libmbfl-at.bash
libmbfl_at_BSOURCES	= $(srcdir)/src/lib/libmbfl-at.bash.m4
EXTRA_DIST		+= $(libmbfl_at_BSOURCES)
ETAGS_ARGS		+= $(libmbfl_at_BSOURCES)
CLEANFILES		+= src/lib/libmbfl-at.bash

libmbfl_at_ENV		=
libmbfl_at_RUN		= $(libmbfl_at_ENV) $(MBFL_RUN_MBFLPP)
libmbfl_at_FLAGS	= $(MBFLPP_GENERAL_FLAGS)

libmbfl_at_PREREQUISITES	=			\
	$(MBFL_PROGRAM_MBFLPP)				\
	$(MBFL_PREPROCESSOR)				\
	$(builddir)/src/lib/libmbfl-linker.bash

src/lib/libmbfl-at.bash: src/lib/libmbfl-at.bash.m4 $(libmbfl_at_PREREQUISITES)
	$(libmbfl_at_RUN) $(libmbfl_at_FLAGS) --output=$@ $<


#### libmbfl-arch generation

libmbfl_archdir		= $(MBFL_LIB_INSTDIR)
libmbfl_arch_DATA	= src/lib/libmbfl-arch.bash
libmbfl_arch_BSOURCES	= $(srcdir)/src/lib/libmbfl-arch.bash.m4
EXTRA_DIST		+= $(libmbfl_arch_BSOURCES)
ETAGS_ARGS		+= $(libmbfl_arch_BSOURCES)
CLEANFILES		+= src/lib/libmbfl-arch.bash

libmbfl_arch_ENV	=
libmbfl_arch_RUN	= $(libmbfl_arch_ENV) $(MBFL_RUN_MBFLPP)
libmbfl_arch_FLAGS	= $(MBFLPP_GENERAL_FLAGS)

libmbfl_arch_PREREQUISITES	=			\
	$(MBFL_PROGRAM_MBFLPP)				\
	$(MBFL_PREPROCESSOR)				\
	$(builddir)/src/lib/libmbfl-linker.bash

src/lib/libmbfl-arch.bash: src/lib/libmbfl-arch.bash.m4 $(libmbfl_arch_PREREQUISITES)
	$(libmbfl_arch_RUN) $(libmbfl_arch_FLAGS) --output=$@ $<


#### libmbfl-passwords generation

libmbfl_passwordsdir	= $(MBFL_LIB_INSTDIR)
libmbfl_passwords_DATA	= src/lib/libmbfl-passwords.bash
libmbfl_passwords_BSOURCES= $(srcdir)/src/lib/libmbfl-passwords.bash.m4
EXTRA_DIST		+= $(libmbfl_passwords_BSOURCES)
ETAGS_ARGS		+= $(libmbfl_passwords_BSOURCES)
CLEANFILES		+= src/lib/libmbfl-passwords.bash

libmbfl_passwords_ENV	=
libmbfl_passwords_RUN	= $(libmbfl_passwords_ENV) $(MBFL_RUN_MBFLPP)
libmbfl_passwords_FLAGS	= $(MBFLPP_GENERAL_FLAGS)

libmbfl_passwords_PREREQUISITES	=			\
	$(MBFL_PROGRAM_MBFLPP)				\
	$(MBFL_PREPROCESSOR)				\
	$(builddir)/src/lib/libmbfl-linker.bash

src/lib/libmbfl-passwords.bash: src/lib/libmbfl-passwords.bash.m4 $(libmbfl_passwords_PREREQUISITES)
	$(libmbfl_passwords_RUN) $(libmbfl_passwords_FLAGS) --output=$@ $<


#### libmbfl-git generation

libmbfl_gitdir	= $(MBFL_LIB_INSTDIR)
libmbfl_git_DATA	= src/lib/libmbfl-git.bash
libmbfl_git_BSOURCES	= $(srcdir)/src/lib/libmbfl-git.bash.m4
EXTRA_DIST		+= $(libmbfl_git_BSOURCES)
ETAGS_ARGS		+= $(libmbfl_git_BSOURCES)
CLEANFILES		+= src/lib/libmbfl-git.bash

libmbfl_git_ENV		=
libmbfl_git_RUN		= $(libmbfl_git_ENV) $(MBFL_RUN_MBFLPP)
libmbfl_git_FLAGS	= $(MBFLPP_GENERAL_FLAGS)

libmbfl_git_PREREQUISITES	=			\
	$(MBFL_PROGRAM_MBFLPP)				\
	$(MBFL_PREPROCESSOR)				\
	$(builddir)/src/lib/libmbfl-linker.bash

src/lib/libmbfl-git.bash: src/lib/libmbfl-git.bash.m4 $(libmbfl_git_PREREQUISITES)
	$(libmbfl_git_RUN) $(libmbfl_git_FLAGS) --output=$@ $<


#### libmbfl-containers generation

libmbfl_containersdir	= $(MBFL_LIB_INSTDIR)
libmbfl_containers_DATA	= src/lib/libmbfl-containers.bash
libmbfl_containers_BSOURCES= $(srcdir)/src/lib/libmbfl-containers.bash.m4
EXTRA_DIST		+= $(libmbfl_containers_BSOURCES)
ETAGS_ARGS		+= $(libmbfl_containers_BSOURCES)
CLEANFILES		+= src/lib/libmbfl-containers.bash

libmbfl_containers_ENV	=
libmbfl_containers_RUN	= $(libmbfl_containers_ENV) $(MBFL_RUN_MBFLPP)
libmbfl_containers_FLAGS= $(MBFLPP_GENERAL_FLAGS)

libmbfl_containers_PREREQUISITES	=		\
	$(MBFL_PROGRAM_MBFLPP)				\
	$(MBFL_PREPROCESSOR)				\
	$(builddir)/src/lib/libmbfl-linker.bash

src/lib/libmbfl-containers.bash: src/lib/libmbfl-containers.bash.m4 $(libmbfl_containers_PREREQUISITES)
	$(libmbfl_containers_RUN) $(libmbfl_containers_FLAGS) --output=$@ $<


#### examples

EXTRA_DIST			+=		\
	examples/at.sh.m4			\
	examples/compress.sh.m4			\
	examples/pwentries.sh.m4		\
	examples/template-actions.sh.m4		\
	examples/template.sh.m4			\
	examples/semver.m4			\
	examples/vc.m4

MBFL_EXAMPLES_BUILT_FILES	=		\
	examples/at.sh				\
	examples/compress.sh			\
	examples/pwentries.sh			\
	examples/template-actions.sh		\
	examples/template.sh			\
	examples/semver				\
	examples/vc

noinst_SCRIPTS			= $(MBFL_EXAMPLES_BUILT_FILES)

CLEANFILES			+= $(MBFL_EXAMPLES_BUILT_FILES)

MBFL_EXAMPLES_ENV		=
MBFL_EXAMPLES_RUN		= $(MBFL_EXAMPLES_ENV) $(MBFL_RUN_MBFLPP)
MBFL_EXAMPLES_FLAGS		= $(MBFLPP_GENERAL_FLAGS) --add-bash
MBFL_EXAMPLES_FLAGS		+= --libmbfl="$(builddir)/src/lib/libmbfl-core.bash"

MBFL_EXAMPLES_PREREQUISITES	=			\
	$(builddir)/src/lib/libmbfl-core.bash		\
	$(builddir)/src/lib/libmbfl-at.bash		\
	$(builddir)/src/lib/libmbfl-arch.bash		\
	$(builddir)/src/lib/libmbfl-utils.bash		\
	$(builddir)/src/lib/libmbfl-git.bash		\
	$(builddir)/src/lib/libmbfl-containers.bash	\
	$(builddir)/src/lib/libmbfl-passwords.bash	\
	$(MBFL_PROGRAM_MBFLPP)				\
	$(MBFL_PREPROCESSOR)				\
	$(builddir)/src/lib/libmbfl-linker.bash

examples/at.sh: examples/at.sh.m4 $(MBFL_EXAMPLES_PREREQUISITES)
	$(MBFL_EXAMPLES_RUN) $(MBFL_EXAMPLES_FLAGS) --output=$@ $<

examples/compress.sh: examples/compress.sh.m4 $(MBFL_EXAMPLES_PREREQUISITES)
	$(MBFL_EXAMPLES_RUN) $(MBFL_EXAMPLES_FLAGS) --output=$@ $<

examples/pwentries.sh: examples/pwentries.sh.m4 $(MBFL_EXAMPLES_PREREQUISITES)
	$(MBFL_EXAMPLES_RUN) $(MBFL_EXAMPLES_FLAGS) --output=$@ $<

examples/template.sh: examples/template.sh.m4 $(MBFL_EXAMPLES_PREREQUISITES)
	$(MBFL_EXAMPLES_RUN) $(MBFL_EXAMPLES_FLAGS) --output=$@ $<

examples/template-actions.sh: examples/template-actions.sh.m4 $(MBFL_EXAMPLES_PREREQUISITES)
	$(MBFL_EXAMPLES_RUN) $(MBFL_EXAMPLES_FLAGS) --output=$@ $<

examples/vc: examples/vc.m4 src/lib/libmbfl-git.bash $(MBFL_EXAMPLES_PREREQUISITES)
	$(MBFL_EXAMPLES_RUN) $(MBFL_EXAMPLES_FLAGS) --output=$@ $<

examples/semver: examples/semver.m4 $(MBFL_EXAMPLES_PREREQUISITES)
	$(MBFL_EXAMPLES_RUN) $(MBFL_EXAMPLES_FLAGS) --output=$@ $<

if WANT_VC
bin_SCRIPTS		+= examples/vc
endif
if WANT_SEMVER
bin_SCRIPTS		+= examples/semver
endif

## ------------------------------------------------------------------------

noinst_SCRIPTS			+= \
	src/etc/bash_completion.d/semver.bash		\
	src/etc/bash_completion.d/vc.bash

completions_PREREQUISITES	=

CLEANFILES			+=			\
	src/etc/bash_completion.d/semver.bash		\
	src/etc/bash_completion.d/vc.bash

completionsdir			= $(sysconfdir)/bash_completion.d
completions_SCRIPTS		=
if WANT_VC
completions_SCRIPTS		+= src/etc/bash_completion.d/vc.bash
endif
if WANT_SEMVER
completions_SCRIPTS		+= src/etc/bash_completion.d/semver.bash
endif

src/etc/bash_completion.d/vc.bash:					\
		examples/vc						\
		$(completions_PREREQUISITES)
	MBFL_LIBRARY_PATH=$(builddir)/src/lib/ $(MBFL_PROGRAM_BASH) examples/vc help print-completions-script >$(@)

src/etc/bash_completion.d/semver.bash:					\
		examples/semver						\
		$(completions_PREREQUISITES)
	MBFL_LIBRARY_PATH=$(builddir)/src/lib/ $(MBFL_PROGRAM_BASH) examples/semver help print-completions-script >$(@)


#### interface to "make check"

EXTRA_DIST			+=		\
	tests/base.test.m4			\
	tests/arrays.test.m4			\
	tests/atexit.test.m4			\
	tests/bash-feature-coproc.test.m4	\
	tests/compress.test.m4			\
	tests/exceptional-conditions.test.m4	\
	tests/encode.test.m4			\
	tests/exception-handlers.test.m4	\
	tests/fd.test.m4			\
	tests/fifo.test.m4			\
	tests/file.test.m4			\
	tests/getopts.test.m4			\
	tests/functions.test.m4			\
	tests/hooks.test.m4			\
	tests/integers.test.m4			\
	tests/locations.test.m4			\
	tests/math.test.m4			\
	tests/message.test.m4			\
	tests/preprocessor.test.m4		\
	tests/process.test.m4			\
	tests/program.test.m4			\
	tests/script.test.m4			\
	tests/semver.test.m4			\
	tests/signal.test.m4			\
	tests/strings.test.m4			\
	tests/tests.test.m4			\
	tests/object.test.m4			\
	tests/system.test.m4			\
	tests/times-and-dates.test.m4		\
	tests/variables.test.m4			\
	\
	tests/mbfl-arch.test.m4			\
	tests/mbfl-containers.test.m4		\
	tests/mbfl-git.test.m4			\
	tests/mbfl-passwords.test.m4		\
	tests/mbflutils-files.test.m4		\
	\
	tests/script-atexit.sh.m4		\
	tests/fifotest.sh.m4			\
	tests/signaltest.sh.m4

MBFL_CHECK_BUILT_TESTS		=		\
	tests/base.test				\
	tests/arrays.test			\
	tests/atexit.test			\
	tests/bash-feature-coproc.test		\
	tests/compress.test			\
	tests/exceptional-conditions.test	\
	tests/encode.test			\
	tests/exception-handlers.test		\
	tests/fd.test				\
	tests/fifo.test				\
	tests/file.test				\
	tests/getopts.test			\
	tests/hooks.test			\
	tests/integers.test			\
	tests/functions.test			\
	tests/locations.test			\
	tests/math.test				\
	tests/message.test			\
	tests/preprocessor.test			\
	tests/process.test			\
	tests/program.test			\
	tests/script.test			\
	tests/semver.test			\
	tests/signal.test			\
	tests/strings.test			\
	tests/object.test			\
	tests/tests.test			\
	tests/system.test			\
	tests/times-and-dates.test		\
	tests/variables.test			\
	\
	tests/mbfl-arch.test			\
	tests/mbfl-containers.test		\
	tests/mbfl-git.test			\
	tests/mbfl-passwords.test		\
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
	tests/fifotest.sh			\
	tests/signaltest.sh			\
	tests/script-atexit.sh

## --------------------------------------------------------------------

MBFL_TESTS_VERBENV	= TESTSUCCESS=yes; export TESTSUCCESS; TESTSTART=yes; export TESTSTART;

# This  environment setting  is used  both  to compile  ".test.m4" files  and to  run
# ".test" files.
#
MBFL_TESTS_ENV		= MBFL_LIBRARY_PATH=$(builddir)/src/lib; export MBFL_LIBRARY_PATH;
# We set TMPDIR  because if the "/tmp"  directory is mounted on  a separate partition
# with  "noexec"  attribute: tests  for  executability  of  files  will fail  if  the
# temporary test files are created under "/tmp".
MBFL_TESTS_ENV		+= TMPDIR=$(abs_top_builddir)/tests; export TMPDIR;
# We need to access some files in the examples dir and the tests dir.
MBFL_TESTS_ENV		+= testsdir=$(builddir)/tests; export testsdir;
MBFL_TESTS_ENV		+= examplesdir=$(builddir)/examples; export examplesdir;
MBFL_TESTS_ENV		+= TESTMATCH=$(TESTMATCH); export TESTMATCH;
MBFL_TESTS_RUN		= $(MBFL_TESTS_ENV) $(MBFL_RUN_MBFLPP)
MBFL_TESTS_FLAGS	= $(MBFLPP_GENERAL_FLAGS)

MBFL_TESTS_PREREQUISITES=				\
	$(builddir)/src/lib/libmbfl-core.bash		\
	$(builddir)/src/lib/libmbfl-tests.bash		\
	$(builddir)/src/lib/libmbfl-linker.bash		\
	$(MBFL_PROGRAM_MBFLPP)				\
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

tests/%.test: tests/%.test.m4 $(MBFL_TESTS_PREREQUISITES)
	$(MBFL_TESTS_RUN) $(MBFL_TESTS_FLAGS) --output=$@ $<

tests/%.sh: tests/%.sh.m4 $(MBFL_TESTS_PREREQUISITES)
	$(MBFL_TESTS_RUN) $(MBFL_TESTS_FLAGS) --output=$@ $<

tests/signal.test:		tests/signaltest.sh
tests/fifo.test:		tests/fifotest.sh

tests/mbfl-arch.test:		$(builddir)/src/lib/libmbfl-arch.bash
tests/mbfl-containers.test.m4:	$(builddir)/src/lib/libmbfl-containers.bash
tests/mbfl-git.test.m4:		$(builddir)/src/lib/libmbfl-git.bash
tests/mbfl-passwords.test:	$(builddir)/src/lib/libmbfl-passwords.bash
tests/mbflutils-files.test.m4:	$(builddir)/src/lib/libmbfl-utils.bash


#### additional test rules

.PHONY: test test-template test-template-actions test-script-atexit

test: all $(check_SCRIPTS)
	$(AM_TESTS_ENVIRONMENT)					\
	shopt -s nullglob					;\
	for item in $(builddir)/tests/*$(file)*.test		;\
	do $(MBFL_PROGRAM_BASH) "$$item" $(AM_TEST_LOG_FLAGS)	;\
	done

test-template: examples/template.sh src/lib/libmbfl-core.bash
	$(AM_TESTS_ENVIRONMENT) $(MBFL_PROGRAM_BASH) $(builddir)/examples/template.sh $(MBFLFLAGS)

test-template-actions: examples/template-actions.sh src/lib/libmbfl-core.bash
	$(AM_TESTS_ENVIRONMENT) $(MBFL_PROGRAM_BASH) $(builddir)/examples/template-actions.sh $(MBFLFLAGS)

test-script-atexit: tests/script-atexit.sh
	$(AM_TESTS_ENVIRONMENT) $(MBFL_PROGRAM_BASH) $(builddir)/tests/script-atexit.sh $(MBFLFLAGS)


#### interface to "make installcheck"

# This  thing with  the PATH  environment  variable is  needed to  run
# distcheck successfully.   We need  to remember  that, for  some sick
# reason, the  Bash built-in "source"  will search for the  file under
# PATH's directories.
#
MBFL_ICHECK_ENV	 = PATH=$(DESTDIR)$(bindir):$$PATH; export PATH;
MBFL_ICHECK_ENV	 = MBFL_LIBRARY_PATH=$(DESTDIR)$(MBFL_LIB_INSTDIR); export MBFL_LIBRARY_PATH;
MBFL_ICHECK_ENV	+= TMPDIR=$(PWD)/tmp; export TMPDIR;
MBFL_ICHECK_ENV	+= testsdir=$(builddir)/tests; export testsdir;
MBFL_ICHECK_ENV	+= examplesdir=$(builddir)/examples; export examplesdir;
MBFL_ICHECK_ENV	+= examplesdir=$(builddir)/examples; export examplesdir;
MBFL_ICHECK_RUN	 = $(MBFL_PROGRAM_BASH) $(MBFL_ICHECK_FLAGS)

# If a  test script executes no  test functions: its exit  code is 77,
# which signals  GNU Automake's  test harness that  the test  has been
# skipped.  This is fine when running  "make check", but will cause an
# error when  running "make installcheck";  so we intercept  that exit
# code and normalise it to 0.
#
# We  want  to support  the  case  of  a  ".test" script  being  under
# "$(srcdir)" rather than under "$(builddir)"; so we look for the file
# in both directories.
#
installcheck-local: $(TESTS)
	$(MBFL_ICHECK_ENV) RV=0					;\
	for FILE in $(TESTS)					;\
	do  echo "running: '$(builddir)/$$FILE'"		;\
	    if ! $(MBFL_ICHECK_RUN) "$(builddir)/$$FILE"	;\
	    then RV=$$?; break					;\
	    fi							;\
	done							;\
	if test "$$RV" = 77; then exit 0; else exit $$RV; fi	;

### end of file
