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

# Resetting the PATH allows us to load files with the "source" command.
MBFL_TESTS_ENV		= PATH=$(srcdir):$(builddir)/../src:$(srcdir)/../src/lib:$(PATH); export PATH;
# This is because  I mount the "/tmp" directory  on a separate partition
# with "noexec" attribute; this  causes tests for executability of files
# to fail if the temporary test files are created under "/tmp".
MBFL_TESTS_ENV		+= TMPDIR=$(PWD)/tmp examplesdir=$(srcdir)/../examples; export TMPDIR;
MBFL_TESTS_ENV		+= MBFL_LIBRARY=$(builddir)/../src/libmbfl.sh; export MBFL_LIBRARY;
MBFL_TESTS_ENV		+= TESTMATCH=$(TESTMATCH); export TESTMATCH;
MBFL_TESTS_VERBENV	= TESTSUCCESS=yes; export TESTSUCCESS; TESTSTART=yes; export TESTSTART;
MBFL_TESTS_RUN		= $(MBFL_TESTS_ENV) $(BASH_PROGRAM)

#page
#### interface to "make check"

# Read "Parallel Test Harness" in the documentation of GNU Automake to
# understand how to use this interface for "make check".
#
# We must make sure that this ends with a semicolon!!!
AM_TESTS_ENVIRONMENT	= $(MBFL_TESTS_VERBENV) $(MBFL_TESTS_ENV)
TEST_EXTENSIONS		= .test
TEST_LOG_COMPILER	= $(BASH_PROGRAM)
AM_TEST_LOG_FLAGS	= $(user_flags)

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
