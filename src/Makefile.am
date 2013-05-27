## Process this file with automake to produce Makefile.in

EXTRA_DIST	= \
	scripts/mbflpp.sh		\
	scripts/mbfltest.sh		\
	\
	modules/base.sh.m4		\
	modules/encode.sh.m4		\
	modules/file.sh.m4		\
	modules/getopts.sh.m4		\
	modules/actions.sh.m4		\
	modules/message.sh.m4		\
	modules/program.sh.m4		\
	modules/signal.sh.m4		\
	modules/string.sh.m4		\
	modules/dialog.sh.m4		\
	modules/main.sh.m4		\
	modules/variable.sh.m4		\
	modules/system.sh.m4		\
	modules/interfaces.sh.m4	\
	\
	lib/libmbfl.sh.m4		\
	lib/libmbfltest.sh		\
	lib/loader.sh			\
	lib/preprocessor.m4		\
	\
	backup/libmbfl.sh		\
	backup/libmbfltest.sh		\
	backup/mbflpp.sh		\
	backup/mbfltest.sh		\
	backup/preprocessor.m4

MBFL_MODULES		= \
	base.sh		encode.sh	file.sh		\
	getopts.sh	actions.sh	message.sh	\
	program.sh	signal.sh	string.sh	\
	dialog.sh	main.sh		variable.sh	\
	system.sh	interfaces.sh

MBFL_PREPRO		= $(srcdir)/lib/preprocessor.m4

mbfldatadir		= $(datadir)/$(PACKAGE)/$(PACKAGE_VERSION)
dist_mbfldata_DATA	= \
	$(MBFL_PREPRO)	\
	$(srcdir)/lib/libmbfltest.sh	\
	libmbfl.sh

bin_SCRIPTS		= mbflpp.sh mbfltest.sh

clean-local:
	-rm -f mbflpp.sh mbfltest.sh libmbfl.sh $(MBFL_MODULES)

## --------------------------------------------------------------------

BASH_PROGRAM	= @BASH_PROGRAM@

MBFL_LIBRARY	= $(srcdir)/backup/libmbfl.sh
MBFLPP_ENV	= MBFL_LIBRARY=$(MBFL_LIBRARY)
MBFLPP_SCRIPT	= $(srcdir)/scripts/mbflpp.sh
MBFLPP_RUN	= $(MBFLPP_ENV) $(BASH_PROGRAM) $(MBFLPP_SCRIPT)

## --------------------------------------------------------------------

MBFLPP_MODULES_FLAGS	= --include=$(srcdir)/lib				\
			  --library=preprocessor.m4	 			\
			  --define=__PKGDATADIR__=$(mbfldatadir)		\
			  --define=__PACKAGE_NAME__=$(PACKAGE)			\
			  --define=__PACKAGE_VERSION__=$(PACKAGE_VERSION)
MBFLPP_LIBS_FLAGS	= --include=. --preserve-comments
MBFLPP_SCRIPTS_FLAGS	= $(MBFLPP_MODULES_FLAGS) --add-bash --preserve-comments

base.sh		: $(srcdir)/modules/base.sh.m4		$(MBFL_PREPRO)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

encode.sh	: $(srcdir)/modules/encode.sh.m4	$(MBFL_PREPRO)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

file.sh		: $(srcdir)/modules/file.sh.m4		$(MBFL_PREPRO)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

getopts.sh	: $(srcdir)/modules/getopts.sh.m4	$(MBFL_PREPRO)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

actions.sh	: $(srcdir)/modules/actions.sh.m4	$(MBFL_PREPRO)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

message.sh	: $(srcdir)/modules/message.sh.m4	$(MBFL_PREPRO)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

program.sh	: $(srcdir)/modules/program.sh.m4	$(MBFL_PREPRO)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

signal.sh	: $(srcdir)/modules/signal.sh.m4	$(MBFL_PREPRO)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

string.sh	: $(srcdir)/modules/string.sh.m4	$(MBFL_PREPRO)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

dialog.sh	: $(srcdir)/modules/dialog.sh.m4	$(MBFL_PREPRO)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

main.sh		: $(srcdir)/modules/main.sh.m4		$(MBFL_PREPRO)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

variable.sh	: $(srcdir)/modules/variable.sh.m4	$(MBFL_PREPRO)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

system.sh	: $(srcdir)/modules/system.sh.m4	$(MBFL_PREPRO)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

interfaces.sh	: $(srcdir)/modules/interfaces.sh.m4	$(MBFL_PREPRO)
	$(MBFLPP_RUN) $(MBFLPP_MODULES_FLAGS) <$< >$@

## --------------------------------------------------------------------

libmbfl.sh: $(srcdir)/lib/libmbfl.sh.m4 $(MBFL_PREPRO) $(MBFL_MODULES)
	$(MBFLPP_RUN) $(MBFLPP_LIBS_FLAGS) <$< >$@

mbflpp.sh : $(srcdir)/scripts/mbflpp.sh
	$(MBFLPP_RUN) $(MBFLPP_SCRIPTS_FLAGS) <$< >$@

mbfltest.sh : $(srcdir)/scripts/mbfltest.sh
	$(MBFLPP_RUN) $(MBFLPP_SCRIPTS_FLAGS) <$< >$@


### end of file
