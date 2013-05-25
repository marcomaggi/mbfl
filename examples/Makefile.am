## Process this file with automake to produce Makefile.in

EXTRA_DIST		= \
	sendmail-connector.sh		\
	sendmail-plain.sh		\
	test-sendmail-gmail.sh		\
	test-sendmail-localhost.sh	\
	test-sendmail-poste.sh

examplesdir		= $(datadir)/$(PACKAGE)/$(PACKAGE_VERSION)/examples
dist_examples_DATA	= at.sh compress.sh template.sh

if WANT_SENDMAIL

dist_lisp_LISP		= sendmail-mbfl.el
dist_bin_SCRIPTS	= sendmail-mbfl.sh

endif

### end of file
