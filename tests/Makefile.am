## Process this file with automake to produce Makefile.in

EXTRA_DIST		= \
	compress.test		\
	encode.test		\
	file.test		\
	getopts.test		\
	message.test		\
	program.test		\
	script.test		\
	signal.test		\
	string.test		\
	system.test		\
	variable.test		\
	\
	setup.sh		\
	signal.sh		\
	signaltest.sh

BASH_PROGRAM		= @BASH_PROGRAM@

# Resetting the PATH allows us to load files with the "source" command.
MBFL_TESTS_ENV		= PATH=$(srcdir):$(builddir)/../src:$(srcdir)/../src/lib:$(PATH)
# This is because  I mount the "/tmp" directory  on a separate partition
# with "noexec" attribute; this  causes tests for executability of files
# to fail if the temporary test files are created under "/tmp".
MBFL_TESTS_ENV		+= TMPDIR=$(PWD)/tmp examplesdir=$(srcdir)/../examples
MBFL_TESTS_ENV		+= MBFL_LIBRARY=$(builddir)/../src/libmbfl.sh
MBFL_TESTS_ENV		+= TESTMATCH=$(TESTMATCH)
MBFL_TESTS_VERBENV	= TESTSUCCESS=yes TESTSTART=yes
MBFL_TESTS_RUN		= $(MBFL_TESTS_ENV) $(BASH_PROGRAM)

TESTS_ENVIRONMENT	= $(MBFL_TESTS_RUN)
TESTS			=	\
	encode.test		\
	file.test		\
	message.test		\
	getopts.test		\
	string.test		\
	system.test		\
	variable.test		\
	program.test		\
	signal.test		\
	script.test		\
	compress.test


### end of file
