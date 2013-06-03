## Process this file with automake to produce Makefile.in

ACLOCAL_AMFLAGS		= -I autotools
AUTOMAKE_OPTIONS	= foreign
SUBDIRS			= meta src doc tests examples
EXTRA_DIST		= INSTALL configure.sh ANNOUNCE
dist_doc_DATA		= README COPYING

.PHONY: test-template test-template-actions

test-template:
	MBFL_LIBRARY=$(builddir)/src/libmbfl.sh $(BASH_PROGRAM) $(srcdir)/examples/template.sh $(MFLAGS)

test-template-actions:
	MBFL_LIBRARY=$(builddir)/src/libmbfl.sh $(BASH_PROGRAM) $(srcdir)/examples/template-actions.sh $(MFLAGS)

### end of file
