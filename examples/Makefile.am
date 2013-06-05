## Process this file with automake to produce Makefile.in

EXTRA_DIST		= \
	at.sh					\
	compress.sh				\
	template.sh				\
	template-actions.sh			\
	\
	sendmail-connector.sh			\
	sendmail-plain.sh			\
	test-sendmail-gmail.sh			\
	test-sendmail-localhost.sh		\
	test-sendmail-poste.sh			\
	\
	actions-scripts/one-level-actions.sh

if WANT_SENDMAIL

dist_lisp_LISP		= sendmail-mbfl.el
dist_bin_SCRIPTS	= sendmail-mbfl.sh

endif

### end of file
