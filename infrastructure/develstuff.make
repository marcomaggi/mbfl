# @configure_input@
#
# Part of: DevelStuff
# Contents: library of functions for GNU Make
# Date: Mon Aug 20, 2007
#
# Abstract
#
#	This is  a library of functions  for GNU Make. It  will not work
#	with  other 'make' programs.   Along with  this file  you should
#	have  received  a documentation  file  in  Texinfo format  named
#	"infrastructure.texi".
#
# Copyright (c) 2007-2010 Marco Maggi <marco.maggi-ipsu@poste.it>
#
# This program is  free software: you can redistribute  it and/or modify
# it under the  terms of the GNU General Public  License as published by
# the Free Software Foundation, either  version 3 of the License, or (at
# your option) any later version.
#
# This program  is distributed in the  hope that it will  be useful, but
# WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# General Public License for more details.
#
# You  should have received  a copy  of the  GNU General  Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

#page
## --------------------------------------------------------------------
## Modules inclusion and configuration.
## --------------------------------------------------------------------

ds_include_BIN_RULES			= @DS_INCLUDE_BIN_RULES@
ds_include_DOC_RULES			= @DS_INCLUDE_DOC_RULES@
ds_include_DEV_RULES			= @DS_INCLUDE_DEV_RULES@
ds_include_AUTOCONF_DIRS		= @DS_INCLUDE_AUTOCONF_DIRS@
ds_include_DEVELSTUFF_DIRS		= @DS_INCLUDE_DEVELSTUFF_DIRS@
ds_include_C_LANGUAGE			= @DS_INCLUDE_C_LANGUAGE@
ds_include_CXX_LANGUAGE			= @DS_INCLUDE_CXX_LANGUAGE@
ds_include_GENERIC_DOCUMENTATION	= @DS_INCLUDE_GENERIC_DOCUMENTATION@
ds_include_TEXINFO_DOCUMENTATION	= @DS_INCLUDE_TEXINFO_DOCUMENTATION@
ds_include_META_SCRIPTS			= @DS_INCLUDE_META_SCRIPTS@
ds_include_PKGCONFIG			= @DS_INCLUDE_PKGCONFIG@
ds_include_AUTOCONF			= @DS_INCLUDE_AUTOCONF@
ds_include_CONFIG_INSPECTION_SCRIPT	= @DS_INCLUDE_CONFIG_INSPECTION_SCRIPT@
ds_include_SOURCE_DISTRIBUTION		= @DS_INCLUDE_SOURCE_DISTRIBUTION@
ds_include_BINARY_DISTRIBUTION		= @DS_INCLUDE_BINARY_DISTRIBUTION@
ds_include_SLACKWARE_DISTRIBUTION	= @DS_INCLUDE_SLACKWARE_DISTRIBUTION@
ds_include_UNINSTALL_SCRIPTS		= @DS_INCLUDE_UNINSTALL_SCRIPTS@

ds_config_ABI			?= @DS_CONFIG_ABI@
ds_config_USE_SUDO		?= @DS_CONFIG_USE_SUDO@
ds_config_VERSIONED_LAYOUT	?= @DS_CONFIG_VERSIONED_LAYOUT@
ds_config_VERBOSE_MESSAGES	?= yes

ds_config_SLACKWARE_CHOWN		?= @DS_CONFIG_SLACKWARE_CHOWN@
ds_config_SLACKWARE_LINKADD		?= @DS_CONFIG_SLACKWARE_LINKADD@
ds_config_SLACKWARE_USE_PREFIX_TOOLS	?= @DS_CONFIG_SLACKWARE_USE_PREFIX_TOOLS@

ds_config_ENABLE_DOC		?= @DS_CONFIG_ENABLE_DOC@
ds_config_ENABLE_DOC_INFO	?= @DS_CONFIG_ENABLE_DOC_INFO@
ds_config_ENABLE_DOC_HTML	?= @DS_CONFIG_ENABLE_DOC_HTML@
ds_config_ENABLE_DOC_DVI	?= @DS_CONFIG_ENABLE_DOC_DVI@
ds_config_ENABLE_DOC_PDF	?= @DS_CONFIG_ENABLE_DOC_PDF@
ds_config_ENABLE_DOC_PS		?= @DS_CONFIG_ENABLE_DOC_PS@

ds_config_ENABLE_STATIC		?= @ds_config_ENABLE_STATIC@
ds_config_ENABLE_SHARED		?= @ds_config_ENABLE_SHARED@
ds_config_ENABLE_STRIP		?= @ds_config_ENABLE_STRIP@
ds_config_ENABLE_PTHREADS	?= @ds_config_ENABLE_PTHREADS@
ds_config_ENABLE_GCC_WARNING	?= @ds_config_ENABLE_GCC_WARNING@
ds_config_ENABLE_SHLIB_SYMLINK	?= @ds_config_ENABLE_SHLIB_SYMLINK@

ds_config_COMPRESSOR		?= @DS_CONFIG_COMPRESSOR@

#page
## --------------------------------------------------------------------
## Package variables.
## --------------------------------------------------------------------

PACKAGE_NAME		= @PACKAGE_NAME@
PACKAGE_VERSION		= @PACKAGE_VERSION@
PKG_ID			?= @PKG_ID@
PKG_DIR			?= @PKG_DIR@

#page
## ---------------------------------------------------------------------
## Directories.
## ---------------------------------------------------------------------

ds_meta_srcdir		?= $(srcdir)/meta
ds_meta_builddir	?= $(builddir)/meta.d
infrastructuredir	?= @INFRASTRUCTUREDIR@
configurationdir	?= @CONFIGURATIONDIR@

ifeq ($(strip $(TMPDIR)),)
TMPDIR		= /tmp
endif

ifeq ($(ds_include_AUTOCONF_DIRS),yes)
prefix		= @prefix@
exec_prefix	= @exec_prefix@
bindir		= @bindir@
datarootdir	= @datarootdir@
datadir		= @datadir@
docdir		= @datarootdir@/doc
includedir	= @includedir@
infodir		= @infodir@
htmldir		= @htmldir@
pdfdir		= @pdfdir@
psdir		= @psdir@
dvidir		= @dvidir@
libdir		= @libdir@
libexecdir	= @libexecdir@
localstatedir	= @localstatedir@
mandir		= @mandir@
sbindir		= @sbindir@
sharedstatedir	= @sharedstatedir@
sysconfdir	= @sysconfdir@
endif

ifeq ($(ds_include_DEVELSTUFF_DIRS),yes)
pkgdatadir	?= @pkgdatadir@
pkgdocdir	?= @pkgdocdir@
pkgexampledir	?= @pkgexampledir@
pkginfodir	?= @pkginfodir@
pkghtmldir	?= @pkghtmldir@
pkgpdfdir	?= @pkgpdfdir@
pkgpsdir	?= @pkgpsdir@
pkgdvidir	?= @pkgdvidir@
pkgincludedir	?= @pkgincludedir@
pkglibdir	?= @pkglibdir@
pkglibexecdir	?= @pkglibexecdir@
pkgsysconfdir	?= @pkgsysconfdir@
endif

#page
## ---------------------------------------------------------------------
## Programs.
## ---------------------------------------------------------------------

BASH_PROGRAM	= @BASH_PROGRAM@
SHELL		= @SHELL@
@SET_MAKE@
MAKE_SILENT	= $(MAKE) --silent
MAKE_NODIR	= $(MAKE) --no-print-directory
BZIP		= @BZIP@
CAT		= @CAT@
CP		= @CP@ --force --verbose --preserve=mode,timestamp --
DATE		= @DATE@
GREP		= @GREP@
GAWK		= @GAWK@
GZIP		= @GZIP@
M4		= @M4@
MAKEINFO	= @MAKEINFO@
MKDIR		= @MKDIR@ --parents --verbose
MV		= @MV@ --verbose --
RM		= @RM@ --force --recursive --verbose --
RM_FILE		= @RM@ --force --verbose --
RM_SILENT	= @RM@ --force --recursive --
RMDIR		= @RMDIR@ --parents --ignore-fail-on-non-empty --
SED		= @SED@
SYMLINK		= @SYMLINK@ --symbolic
TAR		= @TAR@
TEXI2PDF	= @TEXI2PDF@
DVIPS		= @DVIPS@
SUDO		= @SUDO@

INSTALL		= @INSTALL@
INSTALL_DIR_MODE	?= 0755
INSTALL_BIN_MODE	?= 0555
INSTALL_DATA_MODE	?= 0444
INSTALL_LIB_MODE	?= 0444

INSTALL_DIR	= $(INSTALL) -p -m $(INSTALL_DIR_MODE) -d
INSTALL_BIN	= $(INSTALL) -p -m $(INSTALL_BIN_MODE)
INSTALL_DATA	= $(INSTALL) -p -m $(INSTALL_DATA_MODE)

ifeq ($(ds_config_COMPRESSOR),gzip)
ds_COMPRESSOR_PROGRAM	= $(GZIP)
ds_COMPRESSOR_TAR	= --gzip
ds_COMPRESSOR_EXT	= gz
else ifeq ($(ds_config_COMPRESSOR),bzip)
ds_COMPRESSOR_PROGRAM	= $(BZIP)
ds_COMPRESSOR_TAR	= --bzip2
ds_COMPRESSOR_EXT	= bz2
endif

#page
## ---------------------------------------------------------------------
## Main rules.
## ---------------------------------------------------------------------

define ds-included-phony-rules
$(1):	$$(addsuffix -$(1),$$(ds_RULESETS))
endef

define ds-ruleset
.PHONY: $(1)							\
	$(1)-clean	$(1)-mostlyclean			\
	$(1)-install	$(1)-uninstall				\
	\
	$(1)-print-install-layout				\
	$(1)-print-install-dirs-layout				\
	$(1)-print-install-files-layout				\
	\
	$(1)-print-uninstall-script				\
	$(1)-print-uninstall-dirs-script			\
	$(1)-print-uninstall-files-script

$(1):
$(1)-clean:
$(1)-mostlyclean:
$(1)-install:
$(1)-uninstall:

$(1)-print-install-layout:
$(1)-print-install-dirs-layout:
$(1)-print-install-files-layout:

$(1)-print-uninstall-script:
$(1)-print-uninstall-dirs-script:
$(1)-print-uninstall-files-script:

endef

ds_RULESETS = \
	$(if $(filter yes,$(ds_include_BIN_RULES)),bin) \
	$(if $(filter yes,$(ds_include_DEV_RULES)),dev) \
	$(if $(filter yes,$(ds_include_DOC_RULES)),doc)


.PHONY:	all						\
	clean		mostlyclean			\
	install		uninstall			\
	\
	print-install-layout				\
	print-install-dirs-layout			\
	print-install-files-layout			\
	\
	print-uninstall-script				\
	print-uninstall-dirs-script			\
	print-uninstall-files-script

all:	$(ds_RULESETS)
$(eval $(call ds-included-phony-rules,clean))
$(eval $(call ds-included-phony-rules,mostlyclean))
$(eval $(call ds-included-phony-rules,install))
$(eval $(call ds-included-phony-rules,uninstall))

$(eval $(call ds-included-phony-rules,print-install-layout))
$(eval $(call ds-included-phony-rules,print-install-dirs-layout))
$(eval $(call ds-included-phony-rules,print-install-files-layout))

$(eval $(call ds-included-phony-rules,print-uninstall-script))
$(eval $(call ds-included-phony-rules,print-uninstall-dirs-script))
$(eval $(call ds-included-phony-rules,print-uninstall-files-script))

$(eval $(call ds-ruleset,bin))
$(eval $(call ds-ruleset,doc))
$(eval $(call ds-ruleset,dev))

.PHONY: info html dvi pdf ps man

info html dvi pdf ps man:

.PHONY: abi abu bi bu

abi:	all bi
abu:	all bu

ifeq ($(ds_config_ABI),direct)
bi:	install
bu:	uninstall install
else ifeq ($(ds_config_ABI),bindist)
bi:	bindist bindist-install
bu:	uninstall bindist bindist-install
else ifeq ($(ds_config_ABI),slackware)
bi:	slackware slackware-install
bu:	slackware slackware-upgrade
else ifeq ($(ds_config_ABI),local-slackware)
bi:	local-slackware local-slackware-install
bu:	local-slackware local-slackware-upgrade
endif

.PHONY: clean-builddir

clean-builddir:
	-@printf '*** The build directory is: %s\n' "$(abspath $(builddir))";	\
	if test -d .git ;							\
	then echo '*** Refusing to clean directory with ".git" subdir';		\
	else read -p '*** Are you sure to clean it? (yes/no) ' ANSWER;		\
	     test "$${ANSWER}" = yes && $(RM) "$(builddir)"/*;			\
	     true;								\
	fi

.PHONY: examples examples-clean examples-mostlyclean

examples:
examples-mostlyclean:
examples-clean:

clean:		examples-clean
mostlyclean:	examples-mostlyclean

.PHONY: tests tests-clean tests-mostlyclean check

tests:
tests-mostlyclean:
tests-clean:

clean:		tests-clean
mostlyclean:	tests-mostlyclean

.PHONY: nop nop-clean nop-mostlyclean

nop:
nop-clean:
nop-mostlyclean:

clean:		nop-clean
mostlyclean:	nop-mostlyclean

.PHONY: nothing

nothing:
# If  the ':'  command  is not  used, and  the  target is  left with  no
# commands,  "make" will  print  the  message "Nothing  to  be done  for
# 'nothing'"; we do not want to fill the user's terminal with this.
	@:

Makefile: $(srcdir)/Makefile.in $(srcdir)/configure $(builddir)/config.status
	$(builddir)/config.status

config.status: $(srcdir)/configure
	$(builddir)/config.status --recheck

.PHONY: echo-variable echo-list-variable

echo-variable:
	@echo $($(VARIABLE))

echo-list-variable:
	@$(foreach f,$($(VARIABLE)),echo $(f);)

.PHONY: ds-upgrade-infrastructure

ds-upgrade-infrastructure:
	$(CP)	$(shell develstuff-config --pkgdatadir)/infrastructure/* \
		$(infrastructuredir)

# This  appears to  be ignored  by GNU  Make 3.81;  at least  it  is not
# mentioned in the Info documentation.   But it was used in the makefile
# of  Tcl  and it  seems  to  do no  harm.   On  the  Net the  following
# explanation was found:  "tell versions [3.59,3.63) of GNU  Make not to
# export all variables, otherwise a system limit (for SysV at least) may
# be exceeded".
.NOEXPORT:

#page
define ds-verbose
$(if $(ds_config_VERBOSE_MESSAGES),$(1),$(2))
endef

define ds-echo
@$(call ds-verbose,echo $(1))
endef

define ds-if-yes
$(if $(filter yes,$(1)),$(2),$(3))
endef
#page
define ds-drop-backup-files
$(filter-out %~,$(1))
endef

define ds-drop-equal-prefixed-files
$(foreach f,$(1),$(if $(filter =%,$(notdir $(f))),,$(f)))
endef

define ds-drop-unwanted-files
$(call ds-drop-equal-prefixed-files,$(call ds-drop-backup-files,$(1)))
endef

define ds-files-from-dir
$(call ds-drop-unwanted-files,$(wildcard $(addprefix $(1)/,$(if $(2),$(2),*))))
endef

define ds-replace-dir
$(addprefix $(1)/,$(notdir $(2)))
endef

define ds-glob
$(if $($(1)_SRCDIR),\
	$(call ds-files-from-dir,$($(1)_SRCDIR),$(2)),\
	$(error null source directory variable "$(1)_SRCDIR"))
endef

#page
define ds-module-with-defaults
# $(1) - is the module identifier
# $(2) - is the ruleset: bin, dev, doc, nop, test, or whatever
# $(3) - is the installation mode, second argument to 'ds-install-module'
# $(4) - is the installation directory

$$(eval $$(call ds-default-clean-variables,$(1)))
$$(eval $$(call ds-default-install-variables,$(1),$(4)))
$$(eval $$(call ds-module,$(1),$(2)))
endef

define ds-module
# $(1) - is the module identifier
# $(2) - is the ruleset: bin, dev, doc, nop, test, or whatever
# $(3) - is the installation mode, second argument to 'ds-install-module'

$$(eval $$(call ds-module-no-install,$(1),$(2)))
$$(eval $$(call ds-module-install-rules,$(1),$(2),$(3)))
endef

define ds-module-no-install
# $(1) - is the module identifier
# $(2) - is the ruleset: bin, dev, doc, nop, test, or whatever
$$(eval $$(call ds-module-all-rule,$(1),$(2)))
$$(eval $$(call ds-module-clean-rules,$(1),$(2)))
endef

define ds-module-all-rule
# $(1) - is the module identifier
# $(2) - is the ruleset: bin, dev, doc, nop, test, or whatever
.PHONY: $(1)-all
$(1)-all:	$$($(1)_TARGETS)
$(2):		$(1)-all
endef

define ds-module-clean-rules
# $(1) - is the module identifier
# $(2) - is the ruleset: bin, dev, doc, nop, test, or whatever
.PHONY: $$(addprefix $(1)-,mostlyclean clean)
$(1)-mostlyclean:	; -@$$(call ds-mostlyclean-files,$(1))
$(2)-mostlyclean:	$(1)-mostlyclean
$(1)-clean:		; -@$$(call ds-clean-files,$(1))
$(2)-clean:		$(1)-clean
endef

define ds-module-install-rules
# $(1) - is the module identifier
# $(2) - is the ruleset: bin, dev, doc, nop, test, or whatever
# $(3) - is the installation mode, second argument to 'ds-install-module'
.PHONY: $$(addprefix $(1)-,install install-pre install-body install-post)

$(1)-install:		$$(addprefix $(1)-install-,pre body post)
$(1)-install-pre:
$(1)-install-body:	; @$$(call ds-install-module,$(1),$$(if $(3),$(3),DATA))
$(1)-install-post:

.PHONY: $$(addprefix $(1)-,uninstall uninstall-pre uninstall-body uninstall-post)

$(1)-uninstall:		$$(addprefix $(1)-uninstall-,pre body post)
$(1)-uninstall-pre:
$(1)-uninstall-body:	; @$$(call ds-uninstall-module,$(1))
$(1)-uninstall-post:

.PHONY: $$(addprefix $(1)-print-install-files-,layout layout-pre layout-body layout-post)

$(1)-print-install-files-layout:	\
	$$(addprefix $(1)-print-install-files-layout-,pre body post)
$(1)-print-install-files-layout-pre:
$(1)-print-install-files-layout-body: ; @$$(call ds-print-files-layout,$(1))
$(1)-print-install-files-layout-post:

.PHONY: $$(addprefix $(1)-print-install-dirs-,layout layout-pre layout-body layout-post)

$(1)-print-install-dirs-layout:		\
	$$(addprefix $(1)-print-install-dirs-layout-,pre body post)
$(1)-print-install-dirs-layout-pre:
$(1)-print-install-dirs-layout-body: ; @$$(call ds-print-dirs-layout,$(1))
$(1)-print-install-dirs-layout-post:

.PHONY: $$(addprefix $(1)-print-install-,layout layout-pre layout-body layout-post)

$(1)-print-install-layout:	\
	$$(addprefix $(1)-print-install-layout-,pre body post)
$(1)-print-install-layout-pre:	\
	$(1)-print-install-dirs-layout-pre  $(1)-print-install-files-layout-pre
$(1)-print-install-layout-body:	\
	$(1)-print-install-dirs-layout-body $(1)-print-install-files-layout-body
$(1)-print-install-layout-post:	\
	$(1)-print-install-dirs-layout-post $(1)-print-install-files-layout-post

.PHONY: $$(addprefix $(1)-print-uninstall-files-,script script-pre script-body script-post)

$(1)-print-uninstall-files-script:	\
	$$(addprefix $(1)-print-uninstall-files-script,pre body post)
$(1)-print-uninstall-files-script-pre:
$(1)-print-uninstall-files-script-body: ; @$$(call ds-print-uninstall-files-script,$(1))
$(1)-print-uninstall-files-script-post:

.PHONY: $$(addprefix $(1)-print-uninstall-dirs-,script script-pre script-body script-post)

$(1)-print-uninstall-dirs-script:	\
	$$(addprefix $(1)-print-uninstall-dirs-script, pre body post)
$(1)-print-uninstall-dirs-script-pre:
$(1)-print-uninstall-dirs-script-body: ; @$$(call ds-print-uninstall-dirs-script,$(1))
$(1)-print-uninstall-dirs-script-post:

.PHONY: $$(addprefix $(1)-print-uninstall-,script script-pre script-body script-post)

$(1)-print-uninstall-script:	\
	$$(addprefix $(1)-print-uninstall-script-, pre body post)
$(1)-print-uninstall-script-pre:	\
	$(1)-print-uninstall-files-script-pre  $(1)-print-uninstall-dirs-script-pre
$(1)-print-uninstall-script-body:	\
	$(1)-print-uninstall-files-script-body $(1)-print-uninstall-dirs-script-body
$(1)-print-uninstall-script-post:	\
	$(1)-print-uninstall-files-script-post $(1)-print-uninstall-dirs-script-post

$(2)-install:		$(1)-install
$(2)-uninstall:		$(1)-uninstall

$(2)-print-install-files-layout:	$(1)-print-install-files-layout
$(2)-print-install-dirs-layout:		$(1)-print-install-dirs-layout
$(2)-print-install-layout:		$(1)-print-install-layout

# Special handling of "ds_uninstall_*" modules.
ifneq (ds_uninstall,$$(patsubst ds_uninstall%,ds_uninstall,$(1)))
$(2)-print-uninstall-files-script:	$(1)-print-uninstall-files-script
$(2)-print-uninstall-dirs-script: 	$(1)-print-uninstall-dirs-script
$(2)-print-uninstall-script:		$(1)-print-uninstall-script
endif
endef

#page
define ds-srcdir
$(1)_SRCDIR	?= $$(if $(2),$(2),$$(srcdir)/$(1))
# do not indenti this call
$$(call ds-assert-srcdir,$(1))
endef

define ds-assert-srcdir
$(if $($(1)_SRCDIR),\
	$(shell test -d $($(1)_SRCDIR) || \
		printf "*warning*: missing srcdir '%s'\n" $($(1)_SRCDIR) >&2),\
	$(error null source directory variable "$(1)_SRCDIR"))
endef

define ds-builddir
$(1)_BUILDDIR	?= $$(if $(2),$(2),$$(builddir)/$(1).d)

.PHONY: $(1)-make-builddir

$(1)-make-builddir:
# do not indenti this call
$$(call ds-make-builddir,$(1))
$(1)-all: $(1)-make-builddir
endef

define ds-make-builddir
$(if $($(1)_BUILDDIR),\
	$(shell test -d "$($(1)_BUILDDIR)" || $(MKDIR) "$($(1)_BUILDDIR)"),\
	$(error null build directory variable "$(1)_BUILDDIR"))
endef

#page
define ds-clean-files
$(if $($(1)_CLEANFILES),$(RM) $($(1)_CLEANFILES),\
	$(warning empty clean variable "$(1)_CLEANFILES"))
endef

define ds-mostlyclean-files
$(if $($(1)_MOSTLYCLEANFILES),$(RM) $($(1)_MOSTLYCLEANFILES),\
	$(warning empty mostly clean variable "$(1)_MOSTLYCLEANFILES"))
endef

define ds-default-clean-variables
$(1)_MOSTLYCLEANFILES	+= $$($(1)_TARGETS)
$(1)_CLEANFILES		+= $$($(1)_MOSTLYCLEANFILES)
endef

#page
define ds-default-install-variables
$(1)_INSTLST	= $$($(1)_TARGETS)
$(1)_INSTDIR	?= $(2)
endef

define ds-permissions
$(1)_OWNER	= $(strip $(2))
$(1)_GROUP	= $(strip $(3))
$(1)_FMODE	= $(strip $(4))
$(1)_DMODE	= $(strip $(5))
endef

define ds-install-directory
$(if $($(1)_INSTDIR),$(INSTALL) \
	-m $(if $($(1)_DMODE),$($(1)_DMODE),$(INSTALL_DIR_MODE)) \
        $(if $($(1)_OWNER),-o $($(1)_OWNER)) \
        $(if $($(1)_GROUP),-g $($(1)_GROUP)) \
	-d $(DESTDIR)$($(1)_INSTDIR),\
	$(error null install directory variable "$(1)_INSTDIR"))
endef

define ds-install-files
$(if $($(1)_INSTLST),\
	$(if $($(1)_INSTDIR),\
		$(INSTALL) \
			-m $(if $($(1)_FMODE),$($(1)_FMODE),$(INSTALL_$(2)_MODE)) \
			$(if $($(1)_OWNER),-o $($(1)_OWNER)) \
			$(if $($(1)_GROUP),-g $($(1)_GROUP)) \
			$($(1)_INSTLST) $(DESTDIR)$($(1)_INSTDIR),\
		$(error null install directory variable "$(1)_INSTDIR")),\
	$(error empty install list variable "$(1)_INSTLST"))
endef

define ds-install-module
$(call ds-echo,'## ---------------------------------------------------------------------')
$(call ds-echo,'## Installing $(1) files...')
$(call ds-install-directory,$(1))
$(call ds-install-files,$(1),$(2))
$(call ds-echo,'## done.')
endef

define ds-install-data
$(call ds-install-module,$(1),DATA)
endef

define ds-install-bin
$(call ds-install-module,$(1),BIN)
endef

define ds-install-lib
$(call ds-install-module,$(1),LIB)
endef

#page
define ds-uninstall-module
$(call ds-uninstall-files,$(1))
$(call ds-uninstall-directory,$(1))
endef

define ds-uninstall-files
$(foreach f,$($(1)_INSTLST),$(RM_FILE) $(DESTDIR)$($(1)_INSTDIR)/$(notdir $(f));)
endef

define ds-uninstall-directory
$(RMDIR) $(DESTDIR)$($(1)_INSTDIR)
endef

define ds-print-layout
$(call ds-print-files-layout,$(1))
$(call ds-print-dirs-layout,$(1))
endef

define ds-print-files-layout
$(foreach f,$($(1)_INSTLST),echo $($(1)_INSTDIR)/$(notdir $(f));)
endef

define ds-print-dirs-layout
echo $($(1)_INSTDIR)
endef

define ds-print-uninstall-script
$(call ds-print-uninstall-files-script,$(1))
$(call ds-print-uninstall-dirs-script,$(1))
endef

define ds-print-uninstall-files-script
$(foreach f,$($(1)_INSTLST),echo $(RM_FILE) $($(1)_INSTDIR)/$(notdir $(f));)
endef

define ds-print-uninstall-dirs-script
echo $(RMDIR) $($(1)_INSTDIR)
endef

#page
define ds-generic-documentation
ifeq ($$(ds_config_ENABLE_DOC),yes)

$$(eval $$(call ds-srcdir,ds_gendoc,$$(srcdir)))
$$(eval $$(call ds-builddir,ds_gendoc,$$(builddir)/doc-generic.d))

ds_gendoc_PATTERNS	?= README* COPYING license.terms INSTALL* BUGS \
			   NEWS ChangeLog DESCRIPTION.txt TODO
ds_gendoc_SOURCES	= $$(call ds-glob,ds_gendoc,$$(ds_gendoc_PATTERNS))
ds_gendoc_TARGETS	= $$(call ds-replace-dir,$$(ds_gendoc_BUILDDIR),\
				$$(ds_gendoc_SOURCES:=.gz))

$$(eval $$(call ds-default-install-variables,ds_gendoc,$$(pkgdocdir)))
$$(eval $$(call ds-default-clean-variables,ds_gendoc))
$$(eval $$(call ds-module,ds_gendoc,doc,DATA))

$$(ds_gendoc_TARGETS): $$(ds_gendoc_BUILDDIR)/%.gz : $$(ds_gendoc_SRCDIR)/%
	$$(GZIP) --best --stdout $$(<) >$$(@)

endif # ds_config_ENABLE_DOC = yes
endef

#page
define ds-texinfo-documentation
ifeq ($$(ds_config_ENABLE_DOC),yes)

$$(eval $$(call ds-srcdir,ds_texi,$$(srcdir)/doc))
$$(eval $$(call ds-builddir,ds_texi,$$(builddir)/texinfo.d))

vpath	%.texi		$$(ds_texi_SRCDIR)
vpath	%.texiinc	$$(ds_texi_SRCDIR)

ds_texi_SOURCES		= $$(call ds-glob,ds_texi,*.texi)

DS_TEXI_FLAGS		= -I $$(ds_texi_SRCDIR)		\
			  -I $$(ds_texi_BUILDDIR)	\
			  -I $$(infrastructuredir)	\
			  $$(ds_texi_MORE_FLAGS)
DS_TEXI2INFO_SPLIT_FLAGS	?= --no-split
DS_TEXI2HTML_SPLIT_FLAGS	?= --no-split
DS_TEXI2INFO_FLAGS	= $$(DS_TEXI_FLAGS) $$(DS_TEXI2INFO_SPLIT_FLAGS)
DS_TEXI2HTML_FLAGS	= $$(DS_TEXI_FLAGS) $$(DS_TEXI2HTML_SPLIT_FLAGS) --html
DS_TEXI2DVI_FLAGS	= $$(DS_TEXI_FLAGS) --dvi --tidy \
				--build-dir=$$(ds_texi_BUILDDIR)
DS_TEXI2PDF_FLAGS	= $$(DS_TEXI_FLAGS) --dvipdf --tidy \
				--build-dir=$$(ds_texi_BUILDDIR)

ds_texi_PREREQ		= $$(ds_texi_BUILDDIR)/version.texiinc \
				  $$(wildcard $$(ds_texi_SRCDIR)/*.texiinc) \
				  $$(ds_texi_AUX_PREREQ)
ds_texi_CLEANFILES	= $$(ds_texi_BUILDDIR)/version.texiinc

.PHONY: ds-texinfo-builddir

ds-texinfo-builddir:
	test -d $$(ds_texi_BUILDDIR) || $$(MKDIR) $$(ds_texi_BUILDDIR)

$$(ds_texi_BUILDDIR)/version.texiinc: Makefile
# Placing here the command for the  build dir prevents the targets to be
# rebuild every time the "doc" rule is invoked.  This is because writing
# a  file in  the build  directory  changes the  directory access  time.
# Neither  a phony rule  nor an  ordinary rule  would solve  the problem
# (trust me, I tried them).
	@$(MAKE) ds-texinfo-builddir
	echo -e "@macro version{}\n$$(PACKAGE_VERSION)\n@end macro\n" >$$(@)

$$(ds_texi_BUILDDIR)/%.info: $$(ds_texi_SRCDIR)/%.texi $$(ds_texi_PREREQ)
	$$(MAKEINFO) $$(DS_TEXI2INFO_FLAGS) -o $$(@) $$(<)

$$(ds_texi_BUILDDIR)/%.info.gz: $$(ds_texi_BUILDDIR)/%.info
	$$(GZIP) --force --best $$(<)

$$(ds_texi_BUILDDIR)/%.html: $$(ds_texi_SRCDIR)/%.texi $$(ds_texi_PREREQ)
	$$(MAKEINFO) $$(DS_TEXI2HTML_FLAGS) -o $$(@) $$(<)

$$(ds_texi_BUILDDIR)/%.dvi: $$(ds_texi_SRCDIR)/%.texi $$(ds_texi_PREREQ)
	$$(TEXI2DVI) $$(DS_TEXI2DVI_FLAGS) -o $$(@) $$(<)

$$(ds_texi_BUILDDIR)/%.pdf: $$(ds_texi_SRCDIR)/%.texi $$(ds_texi_PREREQ)
	$$(TEXI2PDF) $$(DS_TEXI2PDF_FLAGS) -o $$(@) $$(<)

$$(ds_texi_BUILDDIR)/%.ps: $$(ds_texi_BUILDDIR)/%.dvi
	cd $$(ds_texi_BUILDDIR) && $$(DVIPS) $$(notdir $$(<)) -o

$$(ds_texi_BUILDDIR)/%.ps.gz: $$(ds_texi_BUILDDIR)/%.ps
	$$(GZIP) --force --best $$(<)

## ---------------------------------------------------------------------

ifeq ($$(ds_config_ENABLE_DOC_INFO),yes)

ds_texi_INFO_TARGETS	= $$(call ds-replace-dir,$$(ds_texi_BUILDDIR),\
				$$(ds_texi_SOURCES:.texi=.info.gz))
ds_texi_INFO_INSTLST	= $$(ds_texi_INFO_TARGETS)
ds_texi_INFO_INSTDIR	= \
	$$(if $$(filter yes,$$(ds_config_VERSIONED_LAYOUT)),$$(pkginfodir),$$(infodir))

ds_texi_INFO_MOSTLYCLEANFILES	= $$(ds_texi_INFO_TARGETS)
ds_texi_INFO_CLEANFILES		= $$(ds_texi_INFO_MOSTLYCLEANFILES) \
				  $$(ds_texi_CLEANFILES)

$$(eval $$(call ds-module,ds_texi_INFO,doc,DATA))

info: ds_texi_INFO-all

endif # ds_config_ENABLE_DOC_INFO = yes

## ---------------------------------------------------------------------

ifeq ($$(ds_config_ENABLE_DOC_HTML),yes)

ds_texi_HTML_TARGETS	= $$(call ds-replace-dir,$$(ds_texi_BUILDDIR),\
				$$(ds_texi_SOURCES:.texi=.html))
ds_texi_HTML_INSTLST	= $$(ds_texi_HTML_TARGETS)
ds_texi_HTML_INSTDIR	= \
	$$(if $$(filter yes,$$(ds_config_VERSIONED_LAYOUT)),$$(pkghtmldir),$$(htmldir))

ds_texi_HTML_MOSTLYCLEANFILES	= $$(ds_texi_HTML_TARGETS)
ds_texi_HTML_CLEANFILES		= $$(ds_texi_HTML_MOSTLYCLEANFILES) \
				  $$(ds_texi_CLEANFILES)

$$(eval $$(call ds-module,ds_texi_HTML,doc,DATA))

html: ds_texi_HTML-all

endif # ds_config_ENABLE_DOC_HTML = yes

## ---------------------------------------------------------------------

ifeq ($$(ds_config_ENABLE_DOC_DVI),yes)

ds_texi_DVI_TARGETS	= $$(call ds-replace-dir,$$(ds_texi_BUILDDIR),\
				$$(ds_texi_SOURCES:.texi=.dvi))
ds_texi_DVI_INSTLST	= $$(ds_texi_DVI_TARGETS)
ds_texi_DVI_INSTDIR	= \
	$$(if $$(filter yes,$$(ds_config_VERSIONED_LAYOUT)),$$(pkgdvidir),$$(dvidir))

ds_texi_DVI_MOSTLYCLEANFILES	= $$(ds_texi_DVI_TARGETS)
ds_texi_DVI_CLEANFILES		= $$(ds_texi_DVI_MOSTLYCLEANFILES) \
				  $$(ds_texi_BUILDDIR)/*.t2d \
				  $$(ds_texi_CLEANFILES)

$$(eval $$(call ds-module,ds_texi_DVI,doc,DATA))

dvi: ds_texi_DVI-all

endif # ds_config_ENABLE_DOC_DVI = yes

## ---------------------------------------------------------------------

ifeq ($$(ds_config_ENABLE_DOC_PDF),yes)

ds_texi_PDF_TARGETS	= $$(call ds-replace-dir,$$(ds_texi_BUILDDIR),\
				$$(ds_texi_SOURCES:.texi=.pdf))
ds_texi_PDF_INSTLST	= $$(ds_texi_PDF_TARGETS)
ds_texi_PDF_INSTDIR	= \
	$$(if $$(filter yes,$$(ds_config_VERSIONED_LAYOUT)),$$(pkgpdfdir),$$(pdfdir))

ds_texi_PDF_MOSTLYCLEANFILES	= $$(ds_texi_PDF_TARGETS)
ds_texi_PDF_CLEANFILES		= $$(ds_texi_PDF_MOSTLYCLEANFILES) \
				  $$(ds_texi_BUILDDIR)/*.t2d \
				  $$(ds_texi_CLEANFILES)

$$(eval $$(call ds-module,ds_texi_PDF,doc,DATA))

pdf: ds_texi_PDF-all

endif # ds_config_ENABLE_DOC_PDF = yes

## ---------------------------------------------------------------------

ifeq ($$(ds_config_ENABLE_DOC_PS),yes)

ds_texi_PS_TARGETS	= $$(call ds-replace-dir,$$(ds_texi_BUILDDIR),\
				$$(ds_texi_SOURCES:.texi=.ps.gz))
ds_texi_PS_INSTLST	= $$(ds_texi_PS_TARGETS)
ds_texi_PS_INSTDIR	= \
	$$(if $$(filter yes,$$(ds_config_VERSIONED_LAYOUT)),$$(pkgpsdir),$$(psdir))

ds_texi_PS_MOSTLYCLEANFILES	= $$(ds_texi_PS_TARGETS)
ds_texi_PS_CLEANFILES		= $$(ds_texi_PS_MOSTLYCLEANFILES) \
				  $$(ds_texi_BUILDDIR)/*.t2d \
				  $$(ds_texi_CLEANFILES)

$$(eval $$(call ds-module,ds_texi_PS,doc,DATA))

ps: ds_texi_PS-all

endif # ds_config_ENABLE_DOC_PDF = yes

## ---------------------------------------------------------------------

endif # ds_config_ENABLE_DOC = yes
endef

#page
define ds-meta-scripts
$$(eval $$(call ds-srcdir,ds_meta_scripts,$$(ds_meta_srcdir)))
$$(eval $$(call ds-builddir,ds_meta_scripts,$$(ds_meta_builddir)))

ds_meta_scripts_NAMES	= preinstall postinstall preremoval postremoval
ds_meta_scripts_SOURCES = $$(call ds-glob,ds_meta_scripts,$$(addsuffix .in,$$(ds_meta_scripts_NAMES)))
ds_meta_scripts_INSTLST	= $$(call ds-replace-dir,$$(ds_meta_scripts_BUILDDIR),$$(ds_meta_scripts_SOURCES:.in=))
ds_meta_scripts_INSTDIR	= $$(pkglibexecdir)

ifneq ($$(strip $$(ds_meta_scripts_SOURCES)),)
$$(eval $$(call ds-module-install-rules,ds_meta_scripts,bin,BIN))
endif
endef

define ds-autoconf
$$(eval $$(call ds-srcdir,ds_autoconf,$$(ds_meta_srcdir)/autoconf))

ds_autoconf_NAMES	= $$(addsuffix .m4,$$(if $(1),$(1),$$(PACKAGE_NAME)))
ds_autoconf_SOURCES	= $$(call ds-glob,ds_autoconf,$$(ds_autoconf_NAMES))
ds_autoconf_INSTLST	= $$(ds_autoconf_SOURCES)
ds_autoconf_INSTDIR	= $$(datadir)/aclocal/$$(PKG_DIR)

ifneq ($$(strip $$(ds_autoconf_INSTLST)),)
$$(eval $$(call ds-module-install-rules,ds_autoconf,dev,DATA))
endif
endef

define ds-pkg-config
$$(eval $$(call ds-srcdir,ds_pkgconfig,$$(ds_meta_srcdir)))
$$(eval $$(call ds-builddir,ds_pkgconfig,$$(ds_meta_builddir)))

ds_pkgconfig_NAMES	= $$(addsuffix .pc,$$(if $(1),$(1),$$(PACKAGE_NAME)))
ds_pkgconfig_SOURCES	= $$(call ds-glob,ds_pkgconfig,$$(addsuffix .in,$$(ds_pkgconfig_NAMES)))
ds_pkgconfig_INSTLST	= $$(call ds-replace-dir,$$(ds_pkgconfig_BUILDDIR),$$(ds_pkgconfig_SOURCES:.in=))
ds_pkgconfig_INSTDIR	= $$(libdir)/pkgconfig

ifneq ($$(strip $$(ds_pkgconfig_SOURCES)),)
$$(eval $$(call ds-module-install-rules,ds_pkgconfig,bin,DATA))
endif
endef

define ds-config-inspection-script
$$(eval $$(call ds-srcdir,ds_config_script,$$(ds_meta_srcdir)))
$$(eval $$(call ds-builddir,ds_config_script,$$(ds_meta_builddir)))

ds_config_script_NAMES   = $$(if $(1),$(1),$$(PACKAGE_NAME)-config)
ds_config_script_SOURCES = $$(call ds-glob,ds_config_script,$$(addsuffix .in,$$(ds_config_script_NAMES)))
ds_config_script_INSTLST = $$(call ds-replace-dir,$$(ds_config_script_BUILDDIR),$$(ds_config_script_SOURCES:.in=))
ds_config_script_INSTDIR = $$(bindir)

ifneq ($$(strip $$(ds_config_script_SOURCES)),)
$$(eval $$(call ds-module-install-rules,ds_config_script,bin,BIN))
endif
endef

#page
define ds-uninstall-scripts
$$(eval $$(call ds-builddir,ds_uninstall,$$(builddir)/uninstall.d))

ifeq ($$(ds_include_BIN_RULES),yes)
$$(eval $$(call ds-private-uninstall-scripts,bin))
endif

ifeq ($$(ds_include_DOC_RULES),yes)
$$(eval $$(call ds-private-uninstall-scripts,doc,doc-))
endif

ifeq ($$(ds_include_DEV_RULES),yes)
$$(eval $$(call ds-private-uninstall-scripts,dev,dev-))
endif
endef

define ds-private-uninstall-scripts
# 1 - the section identifier
# 2 - the package name section

ds_uninstall_$(1)_PACKAGE	= $$(PACKAGE_NAME)-$(2)$$(PACKAGE_VERSION)
ds_uninstall_$(1)_NAME		= uninstall-$$(ds_uninstall_$(1)_PACKAGE).sh
ds_uninstall_$(1)_PATHNAME	= $$(ds_uninstall_BUILDDIR)/$$(ds_uninstall_$(1)_NAME)
ds_uninstall_$(1)_TARGETS	= $$(ds_uninstall_$(1)_PATHNAME)

$$(eval $$(call ds-default-install-variables,ds_uninstall_$(1),$$(pkglibexecdir)))
$$(eval $$(call ds-default-clean-variables,ds_uninstall_$(1)))
$$(eval $$(call ds-module,ds_uninstall_$(1),$(1),BIN))

$$(ds_uninstall_$(1)_PATHNAME):
	$$(call ds-echo,'## ---------------------------------------------------------------------')
	$$(call ds-echo,'## Building $(1) uninstall script...')
# This is not required because the first 'echo' outputs with '>'.
#	-@test -f $$(@) && $(RM) $$(@)
	@echo '#!/bin/sh'							>$$(@)
	@echo '#'								>>$$(@)
	@echo '# Executing this script will remove the package: $$(ds_uninstall_$(1)_PACKAGE).'	>>$$(@)
	@echo '#'								>>$$(@)
	@echo '# *** WARNING ***'						>>$$(@)
	@echo '#'								>>$$(@)
	@echo '# Do not run this script if you use a package management system like'	>>$$(@)
	@echo '# the one of Slackware Linux.  Rely on that for package removal.'	>>$$(@)
	@echo									>>$$(@)
	@$(MAKE) --silent $(1)-print-uninstall-script				>>$$(@)
# Special handling of uninstall scripts.
	@$(MAKE) --silent ds_uninstall_$(1)-print-uninstall-script		>>$$(@)
	@printf '\n### end of file\n' >>$$(@)
	$$(call ds-echo,'## done.')

endef

#page
# Synopsis:
#
#	$(eval $(call ds-tcl-programs))
#	$(eval $(call ds-tcl-tests))
#
# Description:
#
#  Add rules for  testing Tcl scripts and packages,  using the 'tcltest'
#  package.  From  the command line  of 'make' the  variable 'TESTFLAGS'
#  can be used to configure the 'tcltest' package.

define ds-tcl-tests
ds_tcl_TESTDIR			?= $$(srcdir)/tests
ds_tcl_TESTMAIN			?= $$(ds_tcl_TESTDIR)/all.tcl
ds_tcl_test_TARGETS		?=
ds_tcl_test_MOSTLYCLEANFILES	?=
ds_tcl_test_CLEANFILES		?=

ds_tcl_test_ENV		= 			\
	TMPDIR=$$(TMPDIR)			\
	srcdir=$$(abspath $$(srcdir))		\
	builddir=$$(abspath $$(builddir))

.PHONY: tcltest tcltests

tcltest tcltests: $$(ds_tcl_test_TARGETS)
	test -f $$(ds_tcl_TESTMAIN) && \
	$$(ds_tcl_test_ENV) $$(TCLSH) $$(ds_tcl_TESTMAIN) $$(TESTFLAGS)

tcltest-clean:
	-$$(RM) $$(ds_tcl_test_CLEANFILES)
tcltest-mostlyclean:
	-$$(RM) $$(ds_tcl_test_MOSTLYCLEANFILES)

test:			tcltest
test-clean:		tcltest-clean
test-mostlyclean:	tcltest-mostlyclean
endef

#page
## --------------------------------------------------------------------
## C language support.
## --------------------------------------------------------------------

ifeq ($(ds_include_C_LANGUAGE),yes)

CC			= @CC@
CPP			= @CPP@
AR			= @AR@ rc
RANLIB			= @RANLIB@
ifeq ($(ds_config_ENABLE_STRIP),yes)
STRIP			= @STRIP@
else
STRIP			= :
endif
GDB			= @GDB@

CPPFLAGS		?= @CPPFLAGS@
CFLAGS			?= @CFLAGS@
LIBS			?= @LIBS@
LDFLAGS			?= @LDFLAGS@

DEFS			= @DEFS@
LDFLAGS_RPATH		= -Wl,-rpath,$(libdir)
LDFLAGS_DL		= @LDFLAGS_DL@

ifeq ($(ds_config_ENABLE_GCC_WARNING),yes)
GCC_WARNINGS		= -Wall -W -Wextra -pedantic			\
			   -Wmissing-prototypes				\
			   -Wpointer-arith -Wcast-qual -Wcast-align	\
			   -Wwrite-strings -Wnested-externs		\
			   -Wstrict-prototypes -Wshadow -fno-common
endif # ds_config_ENABLE_GCC_WARNING = yes

ifeq (@USING_GCC@,yes)
GCC_PIPE		= -pipe
GCC_SHARED		= -shared -fPIC
endif # USING_GCC = yes

CC_COMPILE_OUTPUT	?= $(if @NO_MINUS_C_MINUS_O@,-o,-c -o)
CC_LINK_OUTPUT		?= -o

endif # ds_include_C_LANGUAGE = yes

## --------------------------------------------------------------------

define ds-cc-compile
$(1)_CC_COMPILE_ENV		?=
$(1)_CC_COMPILE_CC		?= $$(CC) $$(GCC_PIPE)
$(1)_CC_COMPILE_INCLUDES	?=
$(1)_CC_COMPILE_CPPFLAGS	?= $$(DEFS) $$(CPPFLAGS)
$(1)_CC_COMPILE_CFLAGS		?= $$(GCC_WARNINGS) $$(CFLAGS)
$(1)_CC_COMPILE_MORE		?=
$(1)_CC_COMPILE			?= $$($(1)_CC_COMPILE_ENV)	\
				$$($(1)_CC_COMPILE_CC)		\
				$$($(1)_CC_COMPILE_INCLUDES)	\
				$$($(1)_CC_COMPILE_CPPFLAGS)	\
				$$($(1)_CC_COMPILE_CFLAGS)	\
				$$($(1)_CC_COMPILE_MORE)	\
				$$(CC_COMPILE_OUTPUT)
endef

define ds-cc-link-program
$(1)_CC_PROGRAM_ENV		?=
$(1)_CC_PROGRAM_CC		?= $$(CC) $$(GCC_PIPE)
$(1)_CC_PROGRAM_LDFLAGS		?= $$(LDFLAGS)
$(1)_CC_PROGRAM_LIBS		?= $$(LIBS)
$(1)_CC_PROGRAM_PRE		?=
$(1)_CC_PROGRAM_POST		?=
$(1)_CC_PROGRAM			?= $$($(1)_CC_PROGRAM_ENV)	\
				$$($(1)_CC_PROGRAM_CC)		\
				$$($(1)_CC_PROGRAM_LDFLAGS)	\
				$$($(1)_CC_PROGRAM_PRE)		\
				$$($(1)_CC_PROGRAM_LIBS)	\
				$$(CC_LINK_OUTPUT) $$(@) $$(^)	\
				$$($(1)_CC_PROGRAM_POST)
endef

define ds-cc-link-shared-library
$(1)_CC_SHLIB_ENV		?=
$(1)_CC_SHLIB_CC		?= $$(CC) $$(GCC_PIPE) $$(GCC_SHARED)
$(1)_CC_SHLIB_LDFLAGS		?= $$(LDFLAGS)
$(1)_CC_SHLIB_LIBS		?= $$(LIBS)
$(1)_CC_SHLIB_PRE		?=
$(1)_CC_SHLIB_POST		?=
$(1)_CC_SHLIB			?= $$($(1)_CC_SHLIB_ENV)	\
				$$($(1)_CC_SHLIB_CC)		\
				$$($(1)_CC_SHLIB_LDFLAGS)	\
				$$($(1)_CC_SHLIB_PRE)		\
				$$($(1)_CC_SHLIB_LIBS)		\
				$$(CC_LINK_OUTPUT) $$(@) $$(^)	\
				$$($(1)_CC_SHLIB_POST)
endef

## --------------------------------------------------------------------

define ds-c-sources
$(1)_RULESET		?= bin
$(1)_SRCDIR		?= $$(srcdir)/src
$(1)_BUILDDIR		?= $$(builddir)/objects.d
$(1)_PATTERNS		?= *.c
$(1)_PREREQUISITES	?=

$$(eval $$(call ds-srcdir,$(1)))
$$(eval $$(call ds-builddir,$(1)))

vpath	%.h		$$($(1)_SRCDIR)
vpath	%.@OBJEXT@	$$($(1)_BUILDDIR)

$(1)_CC_COMPILE_INCLUDES+= -I$$(builddir) -I$$($(1)_SRCDIR)
$$(eval $$(call ds-cc-compile,$(1)))

$(1)_SOURCES	= $$(call ds-glob,$(1),$$($(1)_PATTERNS))
$(1)_TARGETS	= $$(call ds-replace-dir,$$($(1)_BUILDDIR),$$($(1)_SOURCES:.c=.@OBJEXT@))

$$(eval $$(call ds-default-clean-variables,$(1)))
$$(eval $$(call ds-module-no-install,$(1),$$($(1)_RULESET)))

$$($(1)_TARGETS) : $$($(1)_BUILDDIR)/%.@OBJEXT@ : $$($(1)_SRCDIR)/%.c $$($(1)_PREREQUISITES)
	$$($(1)_CC_COMPILE) $$(@) $$(<)
endef

## --------------------------------------------------------------------

define ds-c-shared-library
ifeq ($$(ds_config_ENABLE_SHARED),yes)

$(1)_shlib_RULESET	?= bin
$(1)_shlib_BUILDDIR	?= $$(builddir)/libraries.d
$(1)_shlib_OBJECTS	?= $$($(1)_TARGETS)

$$(eval $$(call ds-builddir,$(1)_shlib))

$(1)_shlib_NAME		= $$($(1)_SHARED_LIBRARY_NAME)
$(1)_shlib_PATHNAME	= $$($(1)_shlib_BUILDDIR)/$$($(1)_shlib_NAME)
$(1)_shlib_LINK_NAME	= $$($(1)_SHARED_LIBRARY_LINK_NAME)
$(1)_shlib_LINK_PATHNAME= $$($(1)_shlib_BUILDDIR)/$$($(1)_shlib_LINK_NAME)
$(1)_shlib_TARGETS	= $$($(1)_shlib_PATHNAME) $$($(1)_shlib_LINK_PATHNAME)
$(1)_shlib_INSTLST	= $$($(1)_shlib_PATHNAME)
$(1)_shlib_INSTDIR	?= $(libdir)

$$(eval $$(call ds-cc-link-shared-library,$(1)_shlib))
$$(eval $$(call ds-default-clean-variables,$(1)_shlib))
$$(eval $$(call ds-module,$(1)_shlib,$$($(1)_shlib_RULESET),LIB))

$$($(1)_shlib_PATHNAME) : $$($(1)_shlib_OBJECTS)
	$$(call ds-echo,'## ---------------------------------------------------------------------')
	$$(call ds-echo,'## Building shared library $$($(1)_shlib_NAME)')
	$$($(1)_shlib_CC_SHLIB)
	$$(STRIP) $$(@)
ifeq ($$(ds_config_ENABLE_SHLIB_SYMLINK),yes)
	cd $$($(1)_shlib_BUILDDIR);\
	test -L $$($(1)_shlib_LINK_NAME) || \
	$$(SYMLINK) $$($(1)_shlib_NAME) $$($(1)_shlib_LINK_NAME)
endif
	$$(call ds-echo,'## done.')

ifeq ($$(ds_config_ENABLE_SHLIB_SYMLINK),yes)
$(1)_shlib-install-post:
	$$(call ds-install-directory,$(1)_shlib)
	cd $$(DESTDIR)$$($(1)_shlib_INSTDIR) ; \
	$$(SYMLINK) $$($(1)_shlib_NAME) $$($(1)_shlib_LINK_NAME)

$(1)_shlib-uninstall-post:
	$$(RM_FILE) $$(DESTDIR)$$(libdir)/$$($(1)_shlib_LINK_NAME)

$(1)_shlib-print-install-files-layout-post:
	@echo $$($(1)_shlib_INSTDIR)/$$($(1)_shlib_LINK_NAME)

$(1)_shlib-print-uninstall-files-script-post:
	@echo $$(RM_FILE) $$($(1)_shlib_INSTDIR)/$$($(1)_shlib_LINK_NAME)
endif # ds_config_ENABLE_SHLIB_SYMLINK = yes
endif # ds_config_ENABLE_SHARED = yes
endef

## --------------------------------------------------------------------

define ds-c-static-library
ifeq ($$(ds_config_ENABLE_STATIC),yes)

$(1)_stlib_RULESET	?= dev
$(1)_stlib_BUILDDIR	?= $$(builddir)/libraries.d
$(1)_stlib_OBJECTS	?= $$($(1)_TARGETS)

$$(eval $$(call ds-builddir,$(1)_stlib))

$(1)_stlib_NAME		= $$($(1)_STATIC_LIBRARY_NAME)
$(1)_stlib_PATHNAME	= $$($(1)_stlib_BUILDDIR)/$$($(1)_stlib_NAME)
$(1)_stlib_TARGETS	= $$($(1)_stlib_PATHNAME)
$(1)_stlib_INSTLST	= $$($(1)_stlib_TARGETS)
$(1)_stlib_INSTDIR	?= $(libdir)

$$(eval $$(call ds-default-clean-variables,$(1)_stlib))
$$(eval $$(call ds-module,$(1)_stlib,$$($(1)_stlib_RULESET),LIB))

$$($(1)_stlib_PATHNAME) : $$($(1)_stlib_OBJECTS)
	$$(call ds-echo,'## ---------------------------------------------------------------------')
	$$(call ds-echo,'## Building static library $$($(1)_stlib_NAME)')
	$$(AR) $$(@) $$(^)
	-($$(RANLIB) $$(@) || true) >/dev/null 2>&1
	$$(call ds-echo,'## done.')
endif # ds_config_ENABLE_STATIC = yes
endef

## --------------------------------------------------------------------

define ds-c-single-program
# $(1) - the identifier of the module
# $(2) - the name of the program
$$(eval $$(call ds-c-single-program-no-install,$(1),$(2)))
$$(eval $$(call ds-default-install-variables,$(1),$(pkglibexecdir)))
$$(eval $$(call ds-module-install-rules,$(1),$$($(1)_sinprog_RULESET),BIN))
endef

define ds-c-single-program-no-install
# $(1) - the identifier of the module
# $(2) - the name of the program

$(1)_sinprog_RULESET	?= bin
$(1)_sinprog_BUILDDIR	?= $$(builddir)/programs.d
$(1)_sinprog_OBJECTS	?= $$($(1)_TARGETS)

$$(eval $$(call ds-builddir,$(1)_sinprog))

$(1)_sinprog_PREFIX	?=
$(1)_sinprog_NAME	= $$($(1)_sinprog_PREFIX)$(2)
$(1)_sinprog_PATHNAME	= $$($(1)_sinprog_BUILDDIR)/$$($(1)_sinprog_NAME)
$(1)_sinprog_TARGETS	= $$($(1)_sinprog_PATHNAME)

$$(eval $$(call ds-cc-link-program,$(1)_sinprog))
$$(eval $$(call ds-default-clean-variables,$(1)_sinprog))
$$(eval $$(call ds-module-no-install,$(1)_sinprog,$$($(1)_sinprog_RULESET)))

$$($(1)_sinprog_PATHNAME) : $$($(1)_sinprog_OBJECTS)
	$$($(1)_sinprog_CC_PROGRAM)
	$$(STRIP) $$(@)
endef

## --------------------------------------------------------------------

define ds-c-programs
# $(1) - the identifier of the module
$$(eval $$(call ds-c-programs-no-install,$(1)))
$$(eval $$(call ds-default-install-variables,$(1),$(pkglibexecdir)))
$$(eval $$(call ds-module-install-rules,$(1),$$($(1)_programs_RULESET),BIN))
endef

define ds-c-programs-no-install
# $(1) - the identifier of the module

$(1)_programs_RULESET	?= bin
$(1)_programs_SRCDIR	?= $$($(1)_BUILDDIR)
$(1)_programs_BUILDDIR	?= $$(builddir)/programs.d
$(1)_programs_OBJECTS	?= $$($(1)_TARGETS)

$$(eval $$(call ds-builddir,$(1)_programs))

$(1)_programs_PREFIX	?=
$(1)_programs_NAMES	= $$(addprefix $$($(1)_programs_PREFIX),\
				$$(notdir $$($(1)_programs_OBJECTS:.@OBJEXT@=)))
$(1)_programs_PATHNAMES	= $$(addprefix $$($(1)_programs_BUILDDIR)/,$$($(1)_programs_NAMES))
$(1)_programs_TARGETS	= $$($(1)_programs_PATHNAMES)

$$(eval $$(call ds-cc-link-program,$(1)_programs))
$$(eval $$(call ds-default-clean-variables,$(1)_programs))
$$(eval $$(call ds-module-no-install,$(1)_programs,$$($(1)_programs_RULESET)))

$$($(1)_programs_PATHNAMES) \
   : $$($(1)_programs_BUILDDIR)/$$($(1)_programs_PREFIX)% \
   : $$($(1)_programs_SRCDIR)/%.@OBJEXT@
	$$($(1)_programs_CC_PROGRAM)
	$$(STRIP) $$(@)
endef

## --------------------------------------------------------------------

define ds-c-example-programs
$(1)_examples_RULESET		= examples
$(1)_examples_SRCDIR		?= $$(srcdir)/examples
$(1)_examples_BUILDDIR		?= $$(builddir)/examples.d
$(1)_examples_programs_RULESET	= examples
$(1)_examples_programs_BUILDDIR	?= $$($(1)_examples_BUILDDIR)
$$(eval $$(call ds-c-sources,$(1)_examples))
$$(eval $$(call ds-c-programs-no-install,$(1)_examples))
endef

define ds-c-test-programs
$(1)_tests_RULESET		= tests
$(1)_tests_SRCDIR		?= $$(srcdir)/tests
$(1)_tests_BUILDDIR		?= $$(builddir)/tests.d
$(1)_tests_programs_RULESET	= tests
$(1)_tests_programs_BUILDDIR	?= $$($(1)_tests_BUILDDIR)
$$(eval $$(call ds-c-sources,$(1)_tests))
$$(eval $$(call ds-c-programs-no-install,$(1)_tests))
endef

## --------------------------------------------------------------------

define ds-h-files-installer
$(1)_c_headers_RULESET	?= dev
$(1)_c_headers_SRCDIR	?= $(2)
$(1)_c_headers_PATTERNS	?= $(3)
$$(eval $$(call ds-srcdir,$(1),$$($(1)_c_headers_SRCDIR)))
$(1)_c_headers_INSTLST	= \
	$$(call ds-glob,$(1),$$(if $$($(1)_c_headers_PATTERNS),$$($(1)_c_headers_PATTERNS),*.h))
$(1)_c_headers_INSTDIR	?= $$(pkgincludedir)
$$(eval $$(call ds-module-install-rules,$(1)_c_headers,$$($(1)_c_headers_RULESET)))
endef

define ds-c-library
include meta.d/makefiles/$(1)-clib.make
$$(eval $$(call ds-c-sources,$(1)))
$$(eval $$(call ds-c-shared-library,$(1)))
$$(eval $$(call ds-c-static-library,$(1)))
endef

define ds-c-library-extended
$$(eval $$(call ds-c-library,$(1)))
$$(eval $$(call ds-h-files-installer,$(1)))
endef

#page
## --------------------------------------------------------------------
## C++ language support.
## --------------------------------------------------------------------

ifeq ($(ds_include_CXX_LANGUAGE),yes)

CXX			?= @CXX@
CXXFLAGS		?= @CXXFLAGS@

ifeq ($(ds_config_ENABLE_GCC_WARNING),yes)
GXX_WARNINGS		= -Wall -W -Wextra -pedantic			\
			  -Wpointer-arith -Wcast-qual -Wcast-align	\
			  -Wwrite-strings -Wshadow -fno-common
endif # ds_config_ENABLE_GCC_WARNING = yes

#CXX_COMPILE_OUTPUT	?= $(if @CXX_NO_MINUS_C_MINUS_O@,-o,-c -o)
CXX_COMPILE_OUTPUT	?= $(CC_COMPILE_OUTPUT)
CXX_LINK_OUTPUT		?= -o

endif # ds_include_CXX_LANGUAGE = yes

## --------------------------------------------------------------------

define ds-cxx-compile
$(1)_CXX_COMPILE_ENV		?=
$(1)_CXX_COMPILE_CXX		?= $$(CXX) $$(GCC_PIPE)
$(1)_CXX_COMPILE_INCLUDES	?=
$(1)_CXX_COMPILE_CPPFLAGS	?= $$(DEFS) $$(CPPFLAGS)
$(1)_CXX_COMPILE_CXXFLAGS	?= $$(GXX_WARNINGS) $$(CXXFLAGS)
$(1)_CXX_COMPILE_MORE		?=
$(1)_CXX_COMPILE		?= $$($(1)_CXX_COMPILE_ENV)	\
				$$($(1)_CXX_COMPILE_CXX)	\
				$$($(1)_CXX_COMPILE_INCLUDES)	\
				$$($(1)_CXX_COMPILE_CPPFLAGS)	\
				$$($(1)_CXX_COMPILE_CXXFLAGS)	\
				$$($(1)_CXX_COMPILE_MORE)	\
				$$(CXX_COMPILE_OUTPUT)
endef

define ds-cxx-link-program
$(1)_CXX_PROGRAM_ENV		?=
$(1)_CXX_PROGRAM_CXX		?= $$(CXX) $$(GCC_PIPE)
$(1)_CXX_PROGRAM_LDFLAGS	?= $$(LDFLAGS)
$(1)_CXX_PROGRAM_LIBS		?= $$(LIBS)
$(1)_CXX_PROGRAM_PRE		?=
$(1)_CXX_PROGRAM_POST		?=
$(1)_CXX_PROGRAM		?= $$($(1)_CXX_PROGRAM_ENV)	\
				$$($(1)_CXX_PROGRAM_CXX)	\
				$$($(1)_CXX_PROGRAM_LDFLAGS)	\
				$$($(1)_CXX_PROGRAM_PRE)	\
				$$($(1)_CXX_PROGRAM_LIBS)	\
				$$(CXX_LINK_OUTPUT) $$(@) $$(^)	\
				$$($(1)_CXX_PROGRAM_POST)
endef

define ds-cxx-link-shared-library
$(1)_CXX_SHLIB_ENV		?=
$(1)_CXX_SHLIB_CXX		?= $$(CXX) $$(GCC_PIPE) $$(GCC_SHARED)
$(1)_CXX_SHLIB_LDFLAGS		?= $$(LDFLAGS)
$(1)_CXX_SHLIB_LIBS		?= $$(LIBS)
$(1)_CXX_SHLIB_PRE		?=
$(1)_CXX_SHLIB_POST		?=
$(1)_CXX_SHLIB			?= $$($(1)_CXX_SHLIB_ENV)	\
				$$($(1)_CXX_SHLIB_CXX)		\
				$$($(1)_CXX_SHLIB_LDFLAGS)	\
				$$($(1)_CXX_SHLIB_PRE)		\
				$$($(1)_CXX_SHLIB_LIBS)		\
				$$(CXX_LINK_OUTPUT) $$(@) $$(^)	\
				$$($(1)_CXX_SHLIB_POST)
endef

## --------------------------------------------------------------------

define ds-cxx-sources
$(1)_RULESET		?= bin
$(1)_SRCDIR		?= $$(srcdir)/src
$(1)_BUILDDIR		?= $$(builddir)/objects.d
$(1)_PATTERNS		?= *.cpp
$(1)_PREREQUISITES	?=

$$(eval $$(call ds-srcdir,$(1)))
$$(eval $$(call ds-builddir,$(1)))

vpath	%.hpp		$$($(1)_SRCDIR)
vpath	%.@OBJEXT@	$$($(1)_BUILDDIR)

$(1)_CXX_COMPILE_INCLUDES+= -I$$(builddir) -I$$($(1)_SRCDIR)
$$(eval $$(call ds-cxx-compile,$(1)))

$(1)_SOURCES	= $$(call ds-glob,$(1),$$($(1)_PATTERNS))
$(1)_TARGETS	= $$(call ds-replace-dir,$$($(1)_BUILDDIR),$$($(1)_SOURCES:.cpp=.@OBJEXT@))

$$(eval $$(call ds-default-clean-variables,$(1)))
$$(eval $$(call ds-module-no-install,$(1),$$($(1)_RULESET)))

$$($(1)_TARGETS) : $$($(1)_BUILDDIR)/%.@OBJEXT@ : $$($(1)_SRCDIR)/%.cpp $$($(1)_PREREQUISITES)
	$$($(1)_CXX_COMPILE) $$(@) $$(<)
endef

## --------------------------------------------------------------------

define ds-cxx-shared-library
ifeq ($$(ds_config_ENABLE_SHARED),yes)

$(1)_shlib_RULESET	?= bin
$(1)_shlib_BUILDDIR	?= $$(builddir)/libraries.d
$(1)_shlib_OBJECTS	?= $$($(1)_TARGETS)

$$(eval $$(call ds-builddir,$(1)_shlib))

$(1)_shlib_NAME		= $$($(1)_SHARED_LIBRARY_NAME)
$(1)_shlib_PATHNAME	= $$($(1)_shlib_BUILDDIR)/$$($(1)_shlib_NAME)
$(1)_shlib_LINK_NAME	= $$($(1)_SHARED_LIBRARY_LINK_NAME)
$(1)_shlib_LINK_PATHNAME= $$($(1)_shlib_BUILDDIR)/$$($(1)_shlib_LINK_NAME)
$(1)_shlib_TARGETS	= $$($(1)_shlib_PATHNAME) $$($(1)_shlib_LINK_PATHNAME)
$(1)_shlib_INSTLST	= $$($(1)_shlib_PATHNAME)
$(1)_shlib_INSTDIR	?= $(libdir)

$$(eval $$(call ds-cxx-link-shared-library,$(1)_shlib))
$$(eval $$(call ds-default-clean-variables,$(1)_shlib))
$$(eval $$(call ds-module,$(1)_shlib,$$($(1)_shlib_RULESET),LIB))

$$($(1)_shlib_PATHNAME) : $$($(1)_shlib_OBJECTS)
	$$(call ds-echo,'## ---------------------------------------------------------------------')
	$$(call ds-echo,'## Building shared library $$($(1)_shlib_NAME)')
	$$($(1)_shlib_CXX_SHLIB)
	$$(STRIP) $$(@)
ifeq ($$(ds_config_ENABLE_SHLIB_SYMLINK),yes)
	cd $$($(1)_shlib_BUILDDIR);\
	test -L $$($(1)_shlib_LINK_NAME) || \
	$$(SYMLINK) $$($(1)_shlib_NAME) $$($(1)_shlib_LINK_NAME)
endif
	$$(call ds-echo,'## done.')

ifeq ($$(ds_config_ENABLE_SHLIB_SYMLINK),yes)
$(1)_shlib-install-post:
	$$(call ds-install-directory,$(1)_shlib)
	cd $$(DESTDIR)$$($(1)_shlib_INSTDIR) ; \
	$$(SYMLINK) $$($(1)_shlib_NAME) $$($(1)_shlib_LINK_NAME)

$(1)_shlib-uninstall-post:
	$$(RM_FILE) $$(DESTDIR)$$(libdir)/$$($(1)_shlib_LINK_NAME)

$(1)_shlib-print-install-files-layout-post:
	@echo $$($(1)_shlib_INSTDIR)/$$($(1)_shlib_LINK_NAME)

$(1)_shlib-print-uninstall-files-script-post:
	@echo $$(RM_FILE) $$($(1)_shlib_INSTDIR)/$$($(1)_shlib_LINK_NAME)
endif # ds_config_ENABLE_SHLIB_SYMLINK = yes
endif # ds_config_ENABLE_SHARED = yes
endef

## --------------------------------------------------------------------

define ds-cxx-single-program
# $(1) - the identifier of the module
# $(2) - the name of the program
$$(eval $$(call ds-cxx-single-program-no-install,$(1),$(2)))
$$(eval $$(call ds-default-install-variables,$(1),$(pkglibexecdir)))
$$(eval $$(call ds-module-install-rules,$(1),$$($(1)_sinprog_RULESET),BIN))
endef

define ds-cxx-single-program-no-install
# $(1) - the identifier of the module
# $(2) - the name of the program

$(1)_sinprog_RULESET	?= bin
$(1)_sinprog_BUILDDIR	?= $$(builddir)/programs.d
$(1)_sinprog_OBJECTS	?= $$($(1)_TARGETS)

$$(eval $$(call ds-builddir,$(1)_sinprog))

$(1)_sinprog_PREFIX	?=
$(1)_sinprog_NAME	= $$($(1)_sinprog_PREFIX)$(2)
$(1)_sinprog_PATHNAME	= $$($(1)_sinprog_BUILDDIR)/$$($(1)_sinprog_NAME)
$(1)_sinprog_TARGETS	= $$($(1)_sinprog_PATHNAME)

$$(eval $$(call ds-cxx-link-program,$(1)_sinprog))
$$(eval $$(call ds-default-clean-variables,$(1)_sinprog))
$$(eval $$(call ds-module-no-install,$(1)_sinprog,$$($(1)_sinprog_RULESET)))

$$($(1)_sinprog_PATHNAME) : $$($(1)_sinprog_OBJECTS)
	$$($(1)_sinprog_CXX_PROGRAM)
	$$(STRIP) $$(@)
endef

## --------------------------------------------------------------------

define ds-cxx-programs
# $(1) - the identifier of the module
$$(eval $$(call ds-cxx-programs-no-install,$(1)))
$$(eval $$(call ds-default-install-variables,$(1),$(pkglibexecdir)))
$$(eval $$(call ds-module-install-rules,$(1),$$($(1)_programs_RULESET),BIN))
endef

define ds-cxx-programs-no-install
# $(1) - the identifier of the module

$(1)_programs_RULESET	?= bin
$(1)_programs_SRCDIR	?= $$($(1)_BUILDDIR)
$(1)_programs_BUILDDIR	?= $$(builddir)/programs.d
$(1)_programs_OBJECTS	?= $$($(1)_TARGETS)

$$(eval $$(call ds-builddir,$(1)_programs))

$(1)_programs_PREFIX	?=
$(1)_programs_NAMES	= $$(addprefix $$($(1)_programs_PREFIX),\
				$$(notdir $$($(1)_programs_OBJECTS:.@OBJEXT@=)))
$(1)_programs_PATHNAMES	= $$(addprefix $$($(1)_programs_BUILDDIR)/,$$($(1)_programs_NAMES))
$(1)_programs_TARGETS	= $$($(1)_programs_PATHNAMES)

$$(eval $$(call ds-cxx-link-program,$(1)_programs))
$$(eval $$(call ds-default-clean-variables,$(1)_programs))
$$(eval $$(call ds-module-no-install,$(1)_programs,$$($(1)_programs_RULESET)))

$$($(1)_programs_PATHNAMES) \
   : $$($(1)_programs_BUILDDIR)/$$($(1)_programs_PREFIX)% \
   : $$($(1)_programs_SRCDIR)/%.@OBJEXT@
	$$($(1)_programs_CXX_PROGRAM)
	$$(STRIP) $$(@)
endef

## --------------------------------------------------------------------

define ds-cxx-example-programs
$(1)_examples_RULESET		= examples
$(1)_examples_SRCDIR		?= $$(srcdir)/examples
$(1)_examples_BUILDDIR		?= $$(builddir)/examples.d
$(1)_examples_programs_RULESET	= examples
$(1)_examples_programs_BUILDDIR	?= $$($(1)_examples_BUILDDIR)
$$(eval $$(call ds-cxx-sources,$(1)))
$$(eval $$(call ds-cxx-programs-no-install,$(1)))
endef

define ds-cxx-test-programs
$(1)_tests_RULESET		= tests
$(1)_tests_SRCDIR		?= $$(srcdir)/tests
$(1)_tests_BUILDDIR		?= $$(builddir)/tests.d
$(1)_tests_programs_RULESET	= tests
$(1)_tests_programs_BUILDDIR	?= $$($(1)_tests_BUILDDIR)
$$(eval $$(call ds-cxx-sources,$(1)_tests))
$$(eval $$(call ds-cxx-programs-no-install,$(1)_tests))
endef

## --------------------------------------------------------------------

define ds-hpp-files-installer
$(1)_cxx_headers_RULESET	?= dev
$(1)_cxx_headers_SRCDIR		?= $(2)
$(1)_cxx_headers_PATTERNS	?= $(3)
$$(eval $$(call ds-srcdir,$(1),$$($(1)_cxx_headers_SRCDIR)))
$(1)_cxx_headers_INSTLST	= \
   $$(call ds-glob,$(1),$$(if $$($(1)_cxx_headers_PATTERNS),$$($(1)_cxx_headers_PATTERNS),*.hpp))
$(1)_cxx_headers_INSTDIR	?= $$(pkgincludedir)
$$(eval $$(call ds-module-install-rules,$(1)_cxx_headers,$$($(1)_cxx_headers_RULESET)))
endef

define ds-cxx-library
include meta.d/makefiles/$(1)-clib.make
$$(eval $$(call ds-cxx-sources,$(1)))
$$(eval $$(call ds-cxx-shared-library,$(1)))
$$(eval $$(call ds-c-static-library,$(1)))
endef

define ds-cxx-library-extended
$$(eval $$(call ds-cxx-library,$(1)))
$$(eval $$(call ds-hpp-files-installer,$(1)))
endef

#page
## --------------------------------------------------------------------
## Generic packaging stuff.
## --------------------------------------------------------------------

ds_archive_NAME		?= $(PACKAGE_NAME)
ds_archive_VERSION	?= $(PACKAGE_VERSION)

ifneq ($(strip $(BUILD_VERSION)),)
ds_archive_BUILD_VERSION= $(BUILD_VERSION)
else
ds_archive_BUILD_VERSION= 1mm
endif

ifneq ($(strip $(ARCHIVE_ARCH)),)
ds_archive_ARCH		= $(ARCHIVE_ARCH)
else
ds_archive_ARCH		= \
	$(firstword $(subst -, ,$(shell $(infrastructuredir)/config.guess)))
endif

ds_archive_NAMETAIL	= $(ds_archive_VERSION)-$(ds_archive_ARCH)-$(ds_archive_BUILD_VERSION)
ds_archive_bin_PREFIX	= $(ds_archive_NAME)-$(ds_archive_NAMETAIL)
ds_archive_doc_PREFIX	= $(ds_archive_NAME)-doc-$(ds_archive_NAMETAIL)
ds_archive_dev_PREFIX	= $(ds_archive_NAME)-dev-$(ds_archive_NAMETAIL)
ds_archive_full_PREFIX	= $(ds_archive_NAME)-full-$(ds_archive_NAMETAIL)

ifeq ($(ds_config_USE_SUDO),yes)
ds_archive_SUDO		= $(SUDO)
endif

#page
define ds-source-distribution
ds_dist_TMPDIR		?= $$(TMPDIR)/$$(PKG_ID)
ds_dist_ARCHIVE		?= $$(PKG_ID)-src.tar.$$(ds_COMPRESSOR_EXT)
ds_dist_DESTDIR		= $$(builddir)/dist.d

ds_dist_REPOSITORY	?= /usr/local/src
ds_dist_PACKAGE_SECTION	?= local
ds_dist_PACKAGE_DEST	= $$(ds_dist_REPOSITORY)/$$(ds_dist_PACKAGE_SECTION)

.PHONY: dist dist-store

dist:
	-test -d $$(ds_dist_DESTDIR) || $$(MKDIR) $$(ds_dist_DESTDIR)
	$$(RM_SILENT) $$(ds_dist_TMPDIR)
	$$(RM_SILENT) $$(TMPDIR)/$$(ds_dist_ARCHIVE)
	$$(MKDIR) $$(ds_dist_TMPDIR)
	$$(TAR) \
		--directory=$$(srcdir) --create --file=- --dereference		\
		--exclude=RCS                   --exclude=CVS                   \
		--exclude=.git			--exclude=.git\*		\
		--exclude=archives              --exclude=\*.ps			\
		--exclude=\*.dvi                --exclude=tmp			\
		--exclude=\*.gz                 --exclude=\*.tar                \
		--exclude=\*.so                 --exclude=\*.o			\
		--exclude=\*.a                  --exclude=\*.rpm                \
		--exclude=\*.deb                --exclude=.emacs\*		\
		--exclude=\*~                   --exclude=TAGS                  \
		--exclude=config.log            --exclude=config.status         \
		--exclude=config.cache          --exclude=Makefile              \
		--exclude=autom4te.cache	--exclude="{arch}"              \
		--exclude=.arch-ids		--exclude=\+\+\*                \
		--exclude=\=\*                                                  \
		. | $$(TAR) --directory=$$(ds_dist_TMPDIR) --extract --file=-
	$$(TAR) --directory=$$(TMPDIR) --verbose				\
		--create $$(ds_COMPRESSOR_TAR)					\
		--file=$$(ds_dist_DESTDIR)/$$(ds_dist_ARCHIVE) $$(PKG_ID)
	$$(RM_SILENT) $$(ds_dist_TMPDIR)

dist-store:
	$$(MV) $$(ds_dist_DESTDIR)/$$(ds_dist_ARCHIVE) $$(ds_dist_PACKAGE_DEST)

endef

#page
define ds-binary-distribution
ds_bindist_TMPDIR	= $$(TMPDIR)/$$(PKG_ID)
ds_bindist_DESTDIR	= $$(builddir)/bindist.d

ds_bindist_bin_ARCHIVE	= $$(ds_archive_bin_PREFIX).tar.$$(ds_COMPRESSOR_EXT)
ds_bindist_doc_ARCHIVE	= $$(ds_archive_doc_PREFIX).tar.$$(ds_COMPRESSOR_EXT)
ds_bindist_dev_ARCHIVE	= $$(ds_archive_dev_PREFIX).tar.$$(ds_COMPRESSOR_EXT)

.PHONY: bindist         bindist-bin         bindist-doc         bindist-dev
.PHONY: bindist-install bindist-bin-install bindist-doc-install bindist-dev-install

bindist:		$$(addprefix bindist-,         $$(ds_RULESETS))
bindist-install:	$$(addprefix bindist-install-, $$(ds_RULESETS))

bindist-bin:
	$$(call ds-bindist-make-package,bin-install,$$(ds_bindist_bin_ARCHIVE))

bindist-doc:
	$$(call ds-bindist-make-package,doc-install,$$(ds_bindist_doc_ARCHIVE))

bindist-dev:
	$$(call ds-bindist-make-package,dev-install,$$(ds_bindist_dev_ARCHIVE))

bindist-install-bin:
	$$(call ds-bindist-install,$$(ds_bindist_bin_ARCHIVE))

bindist-install-doc:
	$$(call ds-bindist-install,$$(ds_bindist_doc_ARCHIVE))

bindist-install-dev:
	$$(call ds-bindist-install,$$(ds_bindist_dev_ARCHIVE))

ds_bindist_ARCHIVE_FULL	= $$(ds_archive_FULL_PREFIX).tar.$$(ds_COMPRESSOR_EXT)

.PHONY: bindist-full bindist-install-full

bindist-full:
	$$(call ds-bindist-make-package,\
		$$(addsuffix -install,$$(ds_RULESETS)),\
		$$(ds_bindist_full_ARCHIVE))

bindist-install-full:
	$$(call ds-bindist-install,$$(ds_bindist_full_ARCHIVE))

endef

define ds-bindist-make-package
test -d $(ds_bindist_DESTDIR) || $(MKDIR) $(ds_bindist_DESTDIR)
$(RM_SILENT) $(ds_bindist_TMPDIR)
$(MAKE) $(1) DESTDIR=$(ds_bindist_TMPDIR)
$(TAR) --directory=$(ds_bindist_TMPDIR) \
	--create $(ds_COMPRESSOR_TAR) --verbose \
	--file=$(ds_bindist_DESTDIR)/$(strip $(2)) .
$(RM_SILENT) $(ds_bindist_TMPDIR)
endef

define ds-bindist-install
$(TAR) --directory=/						\
	--extract $(ds_COMPRESSOR_TAR) --verbose		\
	--no-overwrite-dir --no-same-owner --same-permissions	\
	--file=$(ds_bindist_DESTDIR)/$(1)
endef

#page
## ---------------------------------------------------------------------
## Slackware packaging.
## ---------------------------------------------------------------------

define ds-slackware-distribution
# Define everything  needed to build binary Slackware  packages, one for
# each Makefile section.

# The type of package to create.  Must be one among "tgz" and "txz".
ds_slackware_TYPE		?= tgz

# The directory in which new package files will be stored.
ds_slackware_REPOSITORY		= $$(abspath $$(builddir)/slackware.d)

# The top directory under which  files will be temporarily installed for
# package building.
ds_slackware_TOP_BUILDDIR	= $$(TMPDIR)/$$(PKG_ID)

# The  top directory in  the temporary  installation in  which "makepkg"
# will be executed.
ds_slackware_STD_PACKAGE_TOPDIR	= $$(ds_slackware_TOP_BUILDDIR)
ds_slackware_LOC_PACKAGE_TOPDIR	= $$(ds_slackware_TOP_BUILDDIR)$$(prefix)

# The root directory for standard and "local" packages.
ds_slackware_STD_ROOT		= /
ds_slackware_LOC_ROOT		= $$(prefix)/

# The pathnames of the Slackware package registry.
ds_slackware_REGISTRY_DIR	= var/log/packages
ds_slackware_STD_REGISTRY	= $$(ds_slackware_STD_ROOT)$$(ds_slackware_REGISTRY_DIR)
ds_slackware_LOC_REGISTRY	= $$(ds_slackware_LOC_ROOT)$$(ds_slackware_REGISTRY_DIR)

# "makepkg" related variables
ds_slackware_STD_MAKEPKG_PROGRAM	?= @ds_slackware_STD_MAKEPKG_PROGRAM@
ds_slackware_LOC_MAKEPKG_PROGRAM	?= @ds_slackware_LOC_MAKEPKG_PROGRAM@
ifeq (yes,$$(ds_config_SLACKWARE_CHOWN))
ds_slackware_MAKEPKG_FLAGS	= --chown y
else
ds_slackware_MAKEPKG_FLAGS	= --chown n
endif
ifeq (yes,$$(ds_config_SLACKWARE_LINKADD))
ds_slackware_MAKEPKG_FLAGS	+= --prepend --linkadd y
else
ds_slackware_MAKEPKG_FLAGS	+= --linkadd n
endif
ds_slackware_STD_MAKEPKG	= \
	$$(ds_slackware_STD_MAKEPKG_PROGRAM) $$(ds_slackware_MAKEPKG_FLAGS)
ds_slackware_LOC_MAKEPKG	= ROOT=$$(ds_slackware_LOC_ROOT) \
	$$(ds_slackware_LOC_MAKEPKG_PROGRAM) $$(ds_slackware_MAKEPKG_FLAGS)

# "installpkg" related variables
ds_slackware_STD_INSTALLPKG_PROGRAM	?= @ds_slackware_STD_INSTALLPKG_PROGRAM@
ds_slackware_LOC_INSTALLPKG_PROGRAM	?= @ds_slackware_LOC_INSTALLPKG_PROGRAM@
ds_slackware_INSTALLPKG_FLAGS	?=
ds_slackware_STD_INSTALLPKG	= \
	$$(ds_slackware_STD_INSTALLPKG_PROGRAM) $$(ds_slackware_INSTALLPKG_FLAGS)
ds_slackware_LOC_INSTALLPKG	= ROOT=$$(ds_slackware_LOC_ROOT) \
	$$(ds_slackware_LOC_INSTALLPKG_PROGRAM) --root $$(ds_slackware_LOC_ROOT) \
		$$(ds_slackware_INSTALLPKG_FLAGS)

# "removepkg" related variables
ds_slackware_STD_REMOVEPKG_PROGRAM	?= @ds_slackware_STD_REMOVEPKG_PROGRAM@
ds_slackware_LOC_REMOVEPKG_PROGRAM	?= @ds_slackware_LOC_REMOVEPKG_PROGRAM@
ds_slackware_REMOVEPKG_FLAGS	?=
ds_slackware_STD_REMOVEPKG	= \
	$$(ds_slackware_STD_REMOVEPKG_PROGRAM) $$(ds_slackware_REMOVEPKG_FLAGS)
ds_slackware_LOC_REMOVEPKG	= ROOT=$$(ds_slackware_LOC_ROOT) \
	$$(ds_slackware_LOC_REMOVEPKG_PROGRAM) $$(ds_slackware_REMOVEPKG_FLAGS)

# "upgradepkg" related variables
ds_slackware_STD_UPGRADEPKG_PROGRAM	?= @ds_slackware_STD_UPGRADEPKG_PROGRAM@
ds_slackware_LOC_UPGRADEPKG_PROGRAM	?= @ds_slackware_LOC_UPGRADEPKG_PROGRAM@
ds_slackware_UPGRADEPKG_FLAGS	?= --verbose --reinstall
ds_slackware_STD_UPGRADEPKG	= \
	$$(ds_slackware_STD_UPGRADEPKG_PROGRAM) $$(ds_slackware_UPGRADEPKG_FLAGS)
ds_slackware_LOC_UPGRADEPKG	= ROOT=$$(ds_slackware_LOC_ROOT) \
	$$(ds_slackware_LOC_UPGRADEPKG_PROGRAM) $$(ds_slackware_UPGRADEPKG_FLAGS)

ds_slackware_STD_RECURSIVE_MAKE_ENV	= \
	TMPDIR=$$(TMPDIR)						\
	DESTDIR=$$(ds_slackware_TOP_BUILDDIR)				\
	ds_slackware_PACKAGE_TOPDIR=$$(ds_slackware_STD_PACKAGE_TOPDIR)	\
	ds_slackware_REGISTRY=$$(ds_slackware_STD_REGISTRY)

ds_slackware_LOC_RECURSIVE_MAKE_ENV	= \
	TMPDIR=$$(TMPDIR)						\
	DESTDIR=$$(ds_slackware_TOP_BUILDDIR)				\
	ds_slackware_PACKAGE_TOPDIR=$$(ds_slackware_LOC_PACKAGE_TOPDIR)	\
	ds_slackware_REGISTRY=$$(ds_slackware_LOC_REGISTRY)

.PHONY: slackware			slackware-install		\
	slackware-remove		slackware-upgrade		\
	local-slackware			local-slackware-install		\
	local-slackware-remove		local-slackware-upgrade		\
	slackware-repository		slackware-top-builddir		\
	slackware-clean-repository	slackware-clean-top-builddir	\
	slackware-clean

slackware:		$(addprefix slackware-make-,	  $(ds_RULESETS))
slackware-install:	$(addprefix slackware-install-,	  $(ds_RULESETS))
slackware-remove:	$(addprefix slackware-remove-,	  $(ds_RULESETS))
slackware-upgrade:	$(addprefix slackware-upgrade-,	  $(ds_RULESETS))

local-slackware:	$(addprefix local-slackware-make-,	  $(ds_RULESETS))
local-slackware-install:$(addprefix local-slackware-install-,	  $(ds_RULESETS))
local-slackware-remove:	$(addprefix local-slackware-remove-,	  $(ds_RULESETS))
local-slackware-upgrade:$(addprefix local-slackware-upgrade-,	  $(ds_RULESETS))

slackware-repository:
	-test -d $$(ds_slackware_REPOSITORY)   || $$(MKDIR) $$(ds_slackware_REPOSITORY)

slackware-top-builddir:
	-test -d $$(ds_slackware_TOP_BUILDDIR) || $$(MKDIR) $$(ds_slackware_TOP_BUILDDIR)

slackware-clean-repository:
	-$$(ds_archive_SUDO) $$(RM) $$(ds_slackware_REPOSITORY)/*

slackware-clean-top-builddir:
	-$$(ds_archive_SUDO) $$(RM) $$(ds_slackware_TOP_BUILDDIR)

slackware-clean: slackware-clean-top-builddir slackware-clean-builddir

$$(eval $$(call ds-slackware-section-package,bin))
$$(eval $$(call ds-slackware-section-package,doc))
$$(eval $$(call ds-slackware-section-package,dev))

endef

## --------------------------------------------------------------------

define ds-slackware-section-package
#Define everything needed to build a section's Slackware binary package.
#
# 1 - the section: bin, doc, dev
#

ds_slackware_$(1)_PACKAGE_SPEC		= $$(ds_archive_$(1)_PREFIX)
ds_slackware_$(1)_PACKAGE_NAME		= $$(ds_slackware_$(1)_PACKAGE_SPEC).$$(ds_slackware_TYPE)
ds_slackware_$(1)_PACKAGE_TMPNAME	= $$(TMPDIR)/$$(ds_slackware_$(1)_PACKAGE_NAME)
ds_slackware_$(1)_PACKAGE_PATHNAME	= $$(ds_slackware_REPOSITORY)/$$(ds_slackware_$(1)_PACKAGE_NAME)
ifeq (bin,$$(strip $(1)))
ds_slackware_$(1)_PACKAGE_PATTERN	= $$(PACKAGE_NAME)-[0-9]*
else
ds_slackware_$(1)_PACKAGE_PATTERN	= $$(PACKAGE_NAME)-$(1)-[0-9]*
endif
ds_slackware_$(1)_STD_INSTALLED_PACKAGE	= $$(notdir $$(firstword $$(wildcard \
	$$(ds_slackware_STD_REGISTRY)/$$(ds_slackware_$(1)_PACKAGE_PATTERN))))
ds_slackware_$(1)_LOC_INSTALLED_PACKAGE	= $$(notdir $$(firstword $$(wildcard \
	$$(ds_slackware_LOC_REGISTRY)/$$(ds_slackware_$(1)_PACKAGE_PATTERN))))

.PHONY: slackware-make-$(1)		slackware-install-$(1)		\
	slackware-remove-$(1)		slackware-upgrade-$(1)		\
	local-slackware-make-$(1)	local-slackware-install-$(1)	\
	local-slackware-remove-$(1)	local-slackware-upgrade-$(1)	\
	slackware-aux-$(1)

# We create the package in  a temporary location under "sudo", then copy
# it in the  repository, so we end with a package  file having owner and
# group equal to the id of the user.

slackware-make-$(1): slackware-repository
	$$(ds_archive_SUDO) $$(MAKE) private-slackware-make-$(1) $$(ds_slackware_STD_RECURSIVE_MAKE_ENV)
	test -f $$(ds_slackware_$(1)_PACKAGE_TMPNAME) && {				      \
		$$(RM) $$(ds_slackware_$(1)_PACKAGE_PATHNAME) ;				      \
		$$(CP) $$(ds_slackware_$(1)_PACKAGE_TMPNAME) $$(ds_slackware_REPOSITORY); }

local-slackware-make-$(1): slackware-repository
	$$(ds_archive_SUDO) $$(MAKE) private-local-slackware-make-$(1) $$(ds_slackware_LOC_RECURSIVE_MAKE_ENV)
	test -f $$(ds_slackware_$(1)_PACKAGE_TMPNAME) && {				      \
		$$(RM) $$(ds_slackware_$(1)_PACKAGE_PATHNAME) ;				      \
		$$(CP) $$(ds_slackware_$(1)_PACKAGE_TMPNAME) $$(ds_slackware_REPOSITORY); }

private-slackware-make-$(1):
	$$(call ds-private-slackware-make-package,$(1),ds_slackware_STD_MAKEPKG,ds_slackware_STD_RECURSIVE_MAKE_ENV,ds_slackware_STD_PACKAGE_TOPDIR)

private-local-slackware-make-$(1):
	$$(call ds-private-slackware-make-package,$(1),ds_slackware_LOC_MAKEPKG,ds_slackware_LOC_RECURSIVE_MAKE_ENV,ds_slackware_LOC_PACKAGE_TOPDIR)

slackware-install-$(1):
	$$(ds_archive_SUDO) $$(ds_slackware_STD_INSTALLPKG) $$(ds_slackware_$(1)_PACKAGE_PATHNAME)

local-slackware-install-$(1):
	$$(ds_archive_SUDO) $$(ds_slackware_LOC_INSTALLPKG) $$(ds_slackware_$(1)_PACKAGE_PATHNAME)

slackware-remove-$(1):
	$$(ds_archive_SUDO) $$(ds_slackware_STD_REMOVEPKG) $$(ds_slackware_$(1)_PACKAGE_SPEC)

local-slackware-remove-$(1):
	$$(ds_archive_SUDO) $$(ds_slackware_LOC_REMOVEPKG) $$(ds_slackware_$(1)_PACKAGE_SPEC)

slackware-upgrade-$(1):
ifeq (,$$(ds_slackware_$(1)_STD_INSTALLED_PACKAGE))
	$$(ds_archive_SUDO) $$(ds_slackware_STD_INSTALLPKG) $$(ds_slackware_$(1)_PACKAGE_PATHNAME)
else
	$$(ds_archive_SUDO) $$(ds_slackware_STD_UPGRADEPKG) \
		$$(ds_slackware_$(1)_STD_INSTALLED_PACKAGE)%$$(ds_slackware_$(1)_PACKAGE_PATHNAME)
endif

local-slackware-upgrade-$(1):
ifeq (,$$(ds_slackware_$(1)_LOC_INSTALLED_PACKAGE))
	$$(ds_archive_SUDO) $$(ds_slackware_LOC_INSTALLPKG) $$(ds_slackware_$(1)_PACKAGE_PATHNAME)
else
	$$(ds_archive_SUDO) $$(ds_slackware_LOC_UPGRADEPKG) \
		$$(ds_slackware_$(1)_LOC_INSTALLED_PACKAGE)%$$(ds_slackware_$(1)_PACKAGE_PATHNAME)
endif

slackware-aux-$(1):

endef

# Build the Slackware  binary package for a section.   Install the files
# in a temporary location, then
#
# This  function should  be  called  under "sudo"  in  a recursive  MAKE
# execution.
#
# Arguments:
#
# 1 - the section: bin, doc, dev
# 2 - the name of the variable holding the MAKEPKG to use
# 3 - the name of the ENV variable to use for recursive MAKE invocation
# 4 - the name of the variable holding the package top directory
#
define ds-private-slackware-make-package
$(RM) $(ds_slackware_$(1)_PACKAGE_TMPNAME)
$(RM) $(ds_slackware_TOP_BUILDDIR)
$(MAKE) $(1)-install $($(3))
$(INSTALL_DIR) $(ds_slackware_PACKAGE_TOPDIR)/install
(test -f $(ds_meta_builddir)/slackware/$(1)/slack-desc &&		\
	$(INSTALL_DATA)						\
		$(ds_meta_builddir)/slackware/$(1)/slack-desc		\
		$($(4))/install) || true
(test -f $(ds_meta_builddir)/slackware/$(1)/doinst.sh &&		\
	$(INSTALL_DATA)						\
		$(ds_meta_builddir)/slackware/$(1)/doinst.sh		\
		$($(4))/install) || true
(test -f $(ds_meta_builddir)/slackware/$(1)/setup.$(PACKAGE_NAME) &&		\
	$(INSTALL_DATA)							\
		$(ds_meta_builddir)/slackware/$(1)/setup.$(PACKAGE_NAME)	\
		$($(4))/var/log/setup) || true
(test -f $(ds_meta_builddir)/slackware/$(1)/setup.onlyonce.$(PACKAGE_NAME) &&		\
	$(INSTALL_DATA)								\
		$(ds_meta_builddir)/slackware/$(1)/setup.onlyonce.$(PACKAGE_NAME)	\
		$($(4))/var/log/setup) || true
$(MAKE) slackware-aux-$(1) $($(3))
cd $($(4)) && $($(2)) $(ds_slackware_$(1)_PACKAGE_TMPNAME)
$(RM) $(ds_slackware_TOP_BUILDDIR)
endef

#page
ifeq ($(ds_include_GENERIC_DOCUMENTATION),yes)
$(eval $(call ds-generic-documentation))
endif

ifeq ($(ds_include_TEXINFO_DOCUMENTATION),yes)
$(eval $(call ds-texinfo-documentation))
endif

ifeq ($(ds_include_META_SCRIPTS),yes)
$(eval $(call ds-meta-scripts))
endif

ifeq ($(ds_include_PKGCONFIG),yes)
$(eval $(call ds-pkg-config))
endif

ifeq ($(ds_include_AUTOCONF),yes)
$(eval $(call ds-autoconf))
endif

ifeq ($(ds_include_CONFIG_INSPECTION_SCRIPT),yes)
$(eval $(call ds-config-inspection-script))
endif

ifeq ($(ds_include_SOURCE_DISTRIBUTION),yes)
$(eval $(call ds-source-distribution))
endif

ifeq ($(ds_include_BINARY_DISTRIBUTION),yes)
$(eval $(call ds-binary-distribution))
endif

ifeq ($(ds_include_SLACKWARE_DISTRIBUTION),yes)
$(eval $(call ds-slackware-distribution))
endif

ifeq ($(ds_include_UNINSTALL_SCRIPTS),yes)
$(eval $(call ds-uninstall-scripts))
endif

### end of file
# Local Variables:
# mode: makefile-gmake
# End:
