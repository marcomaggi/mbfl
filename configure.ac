dnl @configure_input@
dnl

AC_INIT([mbfl],[1.3b5],[marcomaggi@gna.org])
DS_BEGIN([./src/modules/base.sh.m4])
DS_INCLUDE_SECTION([DEV_RULES])
DS_EXCLUDE_SECTION([META_SCRIPTS])
DS_ENABLE_OPTION([SENDMAIL_STUFF],[sendmail],[no],
   [whether to install sendmail example script and emacs interface],
   [enable installation of sendmail example script and emacs interface])
DS_CONFIG_FILE_INSPECTION_SCRIPT
DS_CONFIG_FILE_PKGCONFIG
DS_CONFIG_FILE_SLACKWARE_BIN_DESC
DS_CONFIG_FILE_SLACKWARE_DOC_DESC
DS_CONFIG_FILE_SLACKWARE_DEV_DESC
DS_END

dnl end of file
