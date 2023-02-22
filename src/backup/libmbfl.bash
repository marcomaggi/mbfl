#! libmbfl.bash --
#!
#! Part of: Marco's BASH Functions Library
#! Contents: library file
#! Date: Fri Nov 28, 2003
#!
#! Abstract
#!
#!	This is the  library file of MBFL. It must  be sourced in shell scripts at  the beginning of
#!	evaluation.
#!
#! Copyright (c) 2003-2005, 2009, 2013, 2018, 2020, 2023 Marco Maggi
#! <mrc.mgg@gmail.com>
#!
#! This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
#! General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
#! License, or (at your option) any later version.
#!
#! This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
#! even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
#! Lesser General Public License for more details.
#!
#! You should have received a copy of the  GNU Lesser General Public License along with this library;
#! if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
#! 02111-1307 USA.
#!
declare -r mbfl_LOADED_MBFL='yes'
shopt -s expand_aliases
declare -r mbfl_PACKAGE='mbfl'
declare -r mbfl_PACKAGE_NAME='Marcos Bash Functions Library'
declare -r mbfl_PACKAGE_VERSION='3.0.0-devel.7'
declare -r mbfl_CORE_VERSION='3.0.0'
declare -r mbfl_SEMANTIC_VERSION='v3.0.0-devel.7+noarch'
declare -r mbfl_PROGRAM_BASH='/bin/bash'
declare -r mbfl_PROGRAM_CHMOD='/bin/chmod'
declare -r mbfl_PROGRAM_CHGRP='/bin/chgrp'
declare -r mbfl_PROGRAM_CHOWN='/bin/chown'
declare -r mbfl_PROGRAM_CP='/bin/cp'
declare -r mbfl_PROGRAM_DATE='/bin/date'
declare -r mbfl_PROGRAM_ID='/bin/id'
declare -r mbfl_PROGRAM_INSTALL='/bin/install'
declare -r mbfl_PROGRAM_LN='/bin/ln'
declare -r mbfl_PROGRAM_LS='/bin/ls'
declare -r mbfl_PROGRAM_M4='/usr/bin/m4'
declare -r mbfl_PROGRAM_MKDIR='/bin/mkdir'
declare -r mbfl_PROGRAM_MV='/bin/mv'
declare -r mbfl_PROGRAM_READLINK='/bin/readlink'
declare -r mbfl_PROGRAM_REALPATH='/bin/realpath'
declare -r mbfl_PROGRAM_RM='/bin/rm'
declare -r mbfl_PROGRAM_RMDIR='/bin/rmdir'
declare -r mbfl_PROGRAM_SLEEP='/bin/sleep'
declare -r mbfl_PROGRAM_STAT='/bin/stat'
declare -r mbfl_PROGRAM_SUDO='/usr/bin/sudo'
declare -r mbfl_PROGRAM_WHOAMI='/bin/whoami'
function mbfl_p_define_some_configuration_values () {
local prefix="/"
local exec_prefix="${prefix}"
local bindir="${exec_prefix}/bin"
local datarootdir="${prefix}/share"
local datadir="${datarootdir}"
declare -g mbfl_INSTDIR_PREFIX=$prefix
declare -g mbfl_INSTDIR_EXEC_PREFIX=$exec_prefix
declare -g mbfl_INSTDIR_BINDIR=$bindir
declare -g mbfl_INSTDIR_DATAROOTDIR=$datarootdir
declare -g mbfl_INSTDIR_DATADIR=$datadir
}
mbfl_p_define_some_configuration_values
declare -r mbfl_LOADED='yes'
: ${script_PROGNAME:='<unknown>'}
: ${script_VERSION:='<unknown>'}
: ${script_COPYRIGHT_YEARS:='<unknown>'}
: ${script_AUTHOR:='<unknown>'}
: ${script_LICENSE:='<unknown>'}
: ${script_USAGE:='<unknown>'}
: ${script_DESCRIPTION:='<unknown>'}
: ${script_EXAMPLES:=}
function mbfl_set_maybe () {
if mbfl_string_is_not_empty "$1"
then eval $1=\'"$2"\'
fi
}
function mbfl_read_maybe_null () {
local  VARNAME=${1:?"missing variable name parameter to '$FUNCNAME'"}
if mbfl_option_null
then IFS= read -rs -d $'\x00' $VARNAME
else IFS= read -rs $VARNAME
fi
}
function mbfl_set_option_debug ()   { function mbfl_option_debug () { true;  }; }
function mbfl_unset_option_debug () { function mbfl_option_debug () { false; }; }
mbfl_unset_option_debug
declare mbfl_saved_option_DEBUG
declare mbfl_saved_option_DEBUG
function mbfl_option_debug_save () {
local LAST_EXIT_STATUS=$?
if mbfl_option_debug
then mbfl_saved_option_DEBUG=true
fi
mbfl_unset_option_debug
return $LAST_EXIT_STATUS
}
function mbfl_option_debug_restore () {
local LAST_EXIT_STATUS=$?
if mbfl_string_equal "$mbfl_saved_option_DEBUG" 'true'
then mbfl_set_option_debug
fi
return $LAST_EXIT_STATUS
}
function mbfl_set_option_encoded_args ()   { function mbfl_option_encoded_args () { true;  }; }
function mbfl_unset_option_encoded_args () { function mbfl_option_encoded_args () { false; }; }
mbfl_unset_option_encoded_args
declare mbfl_saved_option_ENCODED_ARGS
declare mbfl_saved_option_ENCODED_ARGS
function mbfl_option_encoded_args_save () {
local LAST_EXIT_STATUS=$?
if mbfl_option_encoded_args
then mbfl_saved_option_ENCODED_ARGS=true
fi
mbfl_unset_option_encoded_args
return $LAST_EXIT_STATUS
}
function mbfl_option_encoded_args_restore () {
local LAST_EXIT_STATUS=$?
if mbfl_string_equal "$mbfl_saved_option_ENCODED_ARGS" 'true'
then mbfl_set_option_encoded_args
fi
return $LAST_EXIT_STATUS
}
function mbfl_set_option_force ()   { function mbfl_option_force () { true;  }; }
function mbfl_unset_option_force () { function mbfl_option_force () { false; }; }
mbfl_unset_option_force
declare mbfl_saved_option_FORCE
declare mbfl_saved_option_FORCE
function mbfl_option_force_save () {
local LAST_EXIT_STATUS=$?
if mbfl_option_force
then mbfl_saved_option_FORCE=true
fi
mbfl_unset_option_force
return $LAST_EXIT_STATUS
}
function mbfl_option_force_restore () {
local LAST_EXIT_STATUS=$?
if mbfl_string_equal "$mbfl_saved_option_FORCE" 'true'
then mbfl_set_option_force
fi
return $LAST_EXIT_STATUS
}
function mbfl_set_option_interactive ()   { function mbfl_option_interactive () { true;  }; }
function mbfl_unset_option_interactive () { function mbfl_option_interactive () { false; }; }
mbfl_unset_option_interactive
declare mbfl_saved_option_INTERACTIVE
declare mbfl_saved_option_INTERACTIVE
function mbfl_option_interactive_save () {
local LAST_EXIT_STATUS=$?
if mbfl_option_interactive
then mbfl_saved_option_INTERACTIVE=true
fi
mbfl_unset_option_interactive
return $LAST_EXIT_STATUS
}
function mbfl_option_interactive_restore () {
local LAST_EXIT_STATUS=$?
if mbfl_string_equal "$mbfl_saved_option_INTERACTIVE" 'true'
then mbfl_set_option_interactive
fi
return $LAST_EXIT_STATUS
}
function mbfl_set_option_null ()   { function mbfl_option_null () { true;  }; }
function mbfl_unset_option_null () { function mbfl_option_null () { false; }; }
mbfl_unset_option_null
declare mbfl_saved_option_NULL
declare mbfl_saved_option_NULL
function mbfl_option_null_save () {
local LAST_EXIT_STATUS=$?
if mbfl_option_null
then mbfl_saved_option_NULL=true
fi
mbfl_unset_option_null
return $LAST_EXIT_STATUS
}
function mbfl_option_null_restore () {
local LAST_EXIT_STATUS=$?
if mbfl_string_equal "$mbfl_saved_option_NULL" 'true'
then mbfl_set_option_null
fi
return $LAST_EXIT_STATUS
}
function mbfl_set_option_show_program ()   { function mbfl_option_show_program () { true;  }; }
function mbfl_unset_option_show_program () { function mbfl_option_show_program () { false; }; }
mbfl_unset_option_show_program
declare mbfl_saved_option_SHOW_PROGRAM
declare mbfl_saved_option_SHOW_PROGRAM
function mbfl_option_show_program_save () {
local LAST_EXIT_STATUS=$?
if mbfl_option_show_program
then mbfl_saved_option_SHOW_PROGRAM=true
fi
mbfl_unset_option_show_program
return $LAST_EXIT_STATUS
}
function mbfl_option_show_program_restore () {
local LAST_EXIT_STATUS=$?
if mbfl_string_equal "$mbfl_saved_option_SHOW_PROGRAM" 'true'
then mbfl_set_option_show_program
fi
return $LAST_EXIT_STATUS
}
function mbfl_set_option_test ()   { function mbfl_option_test () { true;  }; }
function mbfl_unset_option_test () { function mbfl_option_test () { false; }; }
mbfl_unset_option_test
declare mbfl_saved_option_TEST
declare mbfl_saved_option_TEST
function mbfl_option_test_save () {
local LAST_EXIT_STATUS=$?
if mbfl_option_test
then mbfl_saved_option_TEST=true
fi
mbfl_unset_option_test
return $LAST_EXIT_STATUS
}
function mbfl_option_test_restore () {
local LAST_EXIT_STATUS=$?
if mbfl_string_equal "$mbfl_saved_option_TEST" 'true'
then mbfl_set_option_test
fi
return $LAST_EXIT_STATUS
}
function mbfl_set_option_verbose ()   { function mbfl_option_verbose () { true;  }; }
function mbfl_unset_option_verbose () { function mbfl_option_verbose () { false; }; }
mbfl_unset_option_verbose
declare mbfl_saved_option_VERBOSE
declare mbfl_saved_option_VERBOSE
function mbfl_option_verbose_save () {
local LAST_EXIT_STATUS=$?
if mbfl_option_verbose
then mbfl_saved_option_VERBOSE=true
fi
mbfl_unset_option_verbose
return $LAST_EXIT_STATUS
}
function mbfl_option_verbose_restore () {
local LAST_EXIT_STATUS=$?
if mbfl_string_equal "$mbfl_saved_option_VERBOSE" 'true'
then mbfl_set_option_verbose
fi
return $LAST_EXIT_STATUS
}
function mbfl_set_option_verbose_program ()   { function mbfl_option_verbose_program () { true;  }; }
function mbfl_unset_option_verbose_program () { function mbfl_option_verbose_program () { false; }; }
mbfl_unset_option_verbose_program
declare mbfl_saved_option_VERBOSE_PROGRAM
declare mbfl_saved_option_VERBOSE_PROGRAM
function mbfl_option_verbose_program_save () {
local LAST_EXIT_STATUS=$?
if mbfl_option_verbose_program
then mbfl_saved_option_VERBOSE_PROGRAM=true
fi
mbfl_unset_option_verbose_program
return $LAST_EXIT_STATUS
}
function mbfl_option_verbose_program_restore () {
local LAST_EXIT_STATUS=$?
if mbfl_string_equal "$mbfl_saved_option_VERBOSE_PROGRAM" 'true'
then mbfl_set_option_verbose_program
fi
return $LAST_EXIT_STATUS
}
if { test "$mbfl_INTERACTIVE"  '!=' 'yes'; }
then
declare -a mbfl_EXIT_CODES
declare -a mbfl_EXIT_NAMES
declare -A mbfl_EXIT_CODES_BY_NAME
mbfl_EXIT_CODES[0]=0
mbfl_EXIT_NAMES[0]=success
mbfl_EXIT_CODES_BY_NAME[success]=0
function exit_because_success   () { mbfl_exit 0; }
alias return_because_success='return 0'
mbfl_EXIT_CODES[1]=1
mbfl_EXIT_NAMES[1]=failure
mbfl_EXIT_CODES_BY_NAME[failure]=1
function exit_because_failure   () { mbfl_exit 1; }
alias return_because_failure='return 1'
mbfl_EXIT_CODES[2]=100
mbfl_EXIT_NAMES[2]=error_loading_library
mbfl_EXIT_CODES_BY_NAME[error_loading_library]=100
function exit_because_error_loading_library   () { mbfl_exit 100; }
alias return_because_error_loading_library='return 100'
mbfl_EXIT_CODES[3]=99
mbfl_EXIT_NAMES[3]=program_not_found
mbfl_EXIT_CODES_BY_NAME[program_not_found]=99
function exit_because_program_not_found   () { mbfl_exit 99; }
alias return_because_program_not_found='return 99'
mbfl_EXIT_CODES[4]=98
mbfl_EXIT_NAMES[4]=wrong_num_args
mbfl_EXIT_CODES_BY_NAME[wrong_num_args]=98
function exit_because_wrong_num_args   () { mbfl_exit 98; }
alias return_because_wrong_num_args='return 98'
mbfl_EXIT_CODES[5]=97
mbfl_EXIT_NAMES[5]=invalid_action_set
mbfl_EXIT_CODES_BY_NAME[invalid_action_set]=97
function exit_because_invalid_action_set   () { mbfl_exit 97; }
alias return_because_invalid_action_set='return 97'
mbfl_EXIT_CODES[6]=96
mbfl_EXIT_NAMES[6]=invalid_action_declaration
mbfl_EXIT_CODES_BY_NAME[invalid_action_declaration]=96
function exit_because_invalid_action_declaration   () { mbfl_exit 96; }
alias return_because_invalid_action_declaration='return 96'
mbfl_EXIT_CODES[7]=95
mbfl_EXIT_NAMES[7]=invalid_action_argument
mbfl_EXIT_CODES_BY_NAME[invalid_action_argument]=95
function exit_because_invalid_action_argument   () { mbfl_exit 95; }
alias return_because_invalid_action_argument='return 95'
mbfl_EXIT_CODES[8]=94
mbfl_EXIT_NAMES[8]=missing_action_function
mbfl_EXIT_CODES_BY_NAME[missing_action_function]=94
function exit_because_missing_action_function   () { mbfl_exit 94; }
alias return_because_missing_action_function='return 94'
mbfl_EXIT_CODES[9]=93
mbfl_EXIT_NAMES[9]=invalid_option_declaration
mbfl_EXIT_CODES_BY_NAME[invalid_option_declaration]=93
function exit_because_invalid_option_declaration   () { mbfl_exit 93; }
alias return_because_invalid_option_declaration='return 93'
mbfl_EXIT_CODES[10]=92
mbfl_EXIT_NAMES[10]=invalid_option_argument
mbfl_EXIT_CODES_BY_NAME[invalid_option_argument]=92
function exit_because_invalid_option_argument   () { mbfl_exit 92; }
alias return_because_invalid_option_argument='return 92'
mbfl_EXIT_CODES[11]=91
mbfl_EXIT_NAMES[11]=invalid_function_name
mbfl_EXIT_CODES_BY_NAME[invalid_function_name]=91
function exit_because_invalid_function_name   () { mbfl_exit 91; }
alias return_because_invalid_function_name='return 91'
mbfl_EXIT_CODES[12]=90
mbfl_EXIT_NAMES[12]=invalid_sudo_username
mbfl_EXIT_CODES_BY_NAME[invalid_sudo_username]=90
function exit_because_invalid_sudo_username   () { mbfl_exit 90; }
alias return_because_invalid_sudo_username='return 90'
mbfl_EXIT_CODES[13]=89
mbfl_EXIT_NAMES[13]=no_location
mbfl_EXIT_CODES_BY_NAME[no_location]=89
function exit_because_no_location   () { mbfl_exit 89; }
alias return_because_no_location='return 89'
mbfl_EXIT_CODES[14]=88
mbfl_EXIT_NAMES[14]=invalid_mbfl_version
mbfl_EXIT_CODES_BY_NAME[invalid_mbfl_version]=88
function exit_because_invalid_mbfl_version   () { mbfl_exit 88; }
alias return_because_invalid_mbfl_version='return 88'
fi
alias exit_success='exit_because_success'
alias exit_failure='exit_because_failure'
alias return_success='return_because_success'
alias return_failure='return_because_failure'
function mbfl_declare_exit_code () {
local  CODE=${1:?"missing exit code parameter to '$FUNCNAME'"}
local  DESCRIPTION=${2:?"missing exit code name parameter to '$FUNCNAME'"}
if ! mbfl_string_is_digit "$CODE"
then
mbfl_message_error_printf 'invalid exit code (not a digit string): "%s"' "$CODE"
return_because_failure
fi
if ! mbfl_string_is_identifier "$DESCRIPTION"
then
mbfl_message_error_printf 'invalid exit code name (not an identifier): "%s"' "$DESCRIPTION"
return_because_failure
fi
local -i i=${#mbfl_EXIT_CODES[@]}
mbfl_EXIT_NAMES[$i]=$DESCRIPTION
mbfl_EXIT_CODES[$i]=$CODE
mbfl_EXIT_CODES_BY_NAME["$DESCRIPTION"]=$i
{
local COMMMAND
printf -v COMMAND 'function exit_because_%s () { mbfl_exit %d; }' "$DESCRIPTION" $CODE
eval "$COMMAND"
}
{
local COMMAND
printf -v COMMAND 'alias return_because_%s="return %d"' "$DESCRIPTION" $CODE
eval "$COMMAND"
}
}
function mbfl_list_exit_codes () {
local -i i
for ((i=0; i < ${#mbfl_EXIT_CODES[@]}; ++i))
do printf '%d %s\n' ${mbfl_EXIT_CODES[$i]} ${mbfl_EXIT_NAMES[$i]}
done
}
function mbfl_print_exit_code () {
local  NAME=${1:?"missing exit code name parameter to '$FUNCNAME'"}
local -i i
for ((i=0; i < ${#mbfl_EXIT_CODES[@]}; ++i))
do
if mbfl_string_equal "${mbfl_EXIT_NAMES[$i]}" "$NAME"
then printf '%d\n' ${mbfl_EXIT_CODES[$i]}
fi
done
}
function mbfl_print_exit_code_names () {
local  CODE=${1:?"missing exit code parameter to '$FUNCNAME'"}
local -i i
for ((i=0; i < ${#mbfl_EXIT_CODES[@]}; ++i))
do
if mbfl_string_equal "${mbfl_EXIT_CODES[$i]}" "$CODE"
then printf '%s\n' ${mbfl_EXIT_NAMES[$i]}
fi
done
}
if { test "$mbfl_INTERACTIVE"  '!=' 'yes'; }
then declare -i mbfl_PENDING_EXIT_CODE=0
fi
function mbfl_script_is_exiting () { return_failure; }
function mbfl_exit () {
local  CODE="${1:-0}"
mbfl_main_pending_EXIT_CODE=$CODE
mbfl_PENDING_EXIT_CODE=$CODE
function mbfl_script_is_exiting () { return_success; }
exit $CODE
}
function mbfl_shell_is_function () {
local  FUNC=${1:?"missing function name parameter to '$FUNCNAME'"}
local -r WORD=$(type -t "$FUNC")
test 'function' '=' "$WORD"
}
if { test "$mbfl_INTERACTIVE"  '!=' 'yes'; }
then
declare mbfl_option_TMPDIR=${TMPDIR:-/tmp/${USER}}
declare -r mbfl_ORG_PWD=$PWD
declare -i ARGC=0 ARGC1=0 ARG1ST=0
declare -a ARGV ARGV1
for ((ARGC1=0; $# > 0; ++ARGC1))
do
ARGV1[$ARGC1]=$1
shift
done
declare mbfl_main_SCRIPT_FUNCTION=main
declare mbfl_main_PRIVATE_SCRIPT_FUNCTION=
declare mbfl_main_SCRIPT_BEFORE_PARSING_OPTIONS=script_before_parsing_options
declare mbfl_main_SCRIPT_AFTER_PARSING_OPTIONS=script_after_parsing_options
fi
function mbfl_main_set_main () {
local  FUNC=${1:?"missing main function name parameter to '$FUNCNAME'"}
mbfl_main_SCRIPT_FUNCTION=${FUNC}
}
function mbfl_main_set_private_main () {
local  FUNC=${1:?"missing main function name parameter to '$FUNCNAME'"}
mbfl_main_PRIVATE_SCRIPT_FUNCTION=${FUNC}
}
function mbfl_main_set_before_parsing_options () {
local  FUNC=${1:?"missing main function name parameter to '$FUNCNAME'"}
mbfl_main_SCRIPT_BEFORE_PARSING_OPTIONS=${FUNC}
}
function mbfl_main_set_after_parsing_options () {
local  FUNC=${1:?"missing main function name parameter to '$FUNCNAME'"}
mbfl_main_SCRIPT_AFTER_PARSING_OPTIONS=${FUNC}
}
if { test "$mbfl_INTERACTIVE"  '!=' 'yes'; }
then declare -i mbfl_main_pending_EXIT_CODE=0
fi
function mbfl_main_is_exiting () {
mbfl_script_is_exiting
}
function mbfl_main_declare_exit_code () {
mbfl_declare_exit_code "$@"
}
function mbfl_main_create_exit_functions () {
:
}
function mbfl_main_list_exit_codes () {
mbfl_list_exit_codes
}
function mbfl_main_print_exit_code () {
mbfl_main_print_exit_code "$@"
}
function mbfl_main_print_exit_code_names () {
mbfl_main_print_exit_code_names "$@"
}
if { test "$mbfl_INTERACTIVE"  '!=' 'yes'; }
then
declare -r mbfl_message_LICENSE_GPL="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
This file  is free software you  can redistribute it  and/or modify it
under the terms of the GNU  General Public License as published by the
Free Software  Foundation; either version  2, or (at your  option) any
later version.\n
This  file is  distributed in  the hope  that it  will be  useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
General Public License for more details.\n
You  should have received  a copy  of the  GNU General  Public License
along with this file; see the file COPYING.  If not, write to the Free
Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
02111-1307, USA.
"
declare -r mbfl_message_LICENSE_GPL3="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
This file  is free software you  can redistribute it  and/or modify it
under the terms of the GNU  General Public License as published by the
Free Software  Foundation; either version  3, or (at your  option) any
later version.\n
This  file is  distributed in  the hope  that it  will be  useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
General Public License for more details.\n
You  should have received  a copy  of the  GNU General  Public License
along with this file; see the file COPYING.  If not, write to the Free
Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
02111-1307, USA.
"
declare -r mbfl_message_LICENSE_LGPL="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
This is free software; you  can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the
Free Software  Foundation; either version  2.1 of the License,  or (at
your option) any later version.\n
This library  is distributed in the  hope that it will  be useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
Lesser General Public License for more details.\n
You  should have  received a  copy of  the GNU  Lesser  General Public
License along  with this library; if  not, write to  the Free Software
Foundation, Inc.,  59 Temple Place,  Suite 330, Boston,  MA 02111-1307
USA.
"
declare -r mbfl_message_LICENSE_LGPL3="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
This is free software; you  can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the
Free Software  Foundation; either version  3.0 of the License,  or (at
your option) any later version.\n
This library  is distributed in the  hope that it will  be useful, but
WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
Lesser General Public License for more details.\n
You  should have  received a  copy of  the GNU  Lesser  General Public
License along  with this library; if  not, write to  the Free Software
Foundation, Inc.,  59 Temple Place,  Suite 330, Boston,  MA 02111-1307
USA.
"
declare -r mbfl_message_LICENSE_BSD="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
The author  hereby grant permission to use,  copy, modify, distribute,
and  license this  software  and its  documentation  for any  purpose,
provided that  existing copyright notices  are retained in  all copies
and that  this notice  is included verbatim  in any  distributions. No
written agreement, license, or royalty  fee is required for any of the
authorized uses.  Modifications to this software may be copyrighted by
their authors and need not  follow the licensing terms described here,
provided that the new terms are clearly indicated on the first page of
each file where they apply.\n
IN NO  EVENT SHALL THE AUTHOR  OR DISTRIBUTORS BE LIABLE  TO ANY PARTY
FOR  DIRECT, INDIRECT, SPECIAL,  INCIDENTAL, OR  CONSEQUENTIAL DAMAGES
ARISING OUT  OF THE  USE OF THIS  SOFTWARE, ITS DOCUMENTATION,  OR ANY
DERIVATIVES  THEREOF, EVEN  IF THE  AUTHOR  HAVE BEEN  ADVISED OF  THE
POSSIBILITY OF SUCH DAMAGE.\n
THE  AUTHOR  AND DISTRIBUTORS  SPECIFICALLY  DISCLAIM ANY  WARRANTIES,
INCLUDING,   BUT   NOT  LIMITED   TO,   THE   IMPLIED  WARRANTIES   OF
MERCHANTABILITY,    FITNESS   FOR    A    PARTICULAR   PURPOSE,    AND
NON-INFRINGEMENT.  THIS  SOFTWARE IS PROVIDED  ON AN \"AS  IS\" BASIS,
AND  THE  AUTHOR  AND  DISTRIBUTORS  HAVE  NO  OBLIGATION  TO  PROVIDE
MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
"
declare -r mbfl_message_LICENSE_LIBERAL="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
The author  hereby grants permission  to use, copy,  modify, distribute,
and  license  this  software  and its  documentation  for  any  purpose,
provided that existing copyright notices  are retained in all copies and
that this notice is included  verbatim in any distributions.  No written
agreement, license, or royalty fee is required for any of the authorized
uses.   Modifications  to this  software  may  be copyrighted  by  their
authors and need not follow the licensing terms described here, provided
that the new terms are clearly indicated  on the first page of each file
where they apply.\n
IN NO EVENT SHALL THE AUTHOR OR  DISTRIBUTORS BE LIABLE TO ANY PARTY FOR
DIRECT, INDIRECT, SPECIAL, INCIDENTAL,  OR CONSEQUENTIAL DAMAGES ARISING
OUT OF THE  USE OF THIS SOFTWARE, ITS DOCUMENTATION,  OR ANY DERIVATIVES
THEREOF, EVEN IF THE AUTHOR HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH
DAMAGE.\n
THE  AUTHOR  AND  DISTRIBUTORS  SPECIFICALLY  DISCLAIM  ANY  WARRANTIES,
INCLUDING,   BUT   NOT   LIMITED   TO,   THE   IMPLIED   WARRANTIES   OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
THIS  SOFTWARE IS  PROVIDED ON  AN  \"AS IS\"  BASIS, AND  THE AUTHOR  AND
DISTRIBUTORS  HAVE  NO  OBLIGATION   TO  PROVIDE  MAINTENANCE,  SUPPORT,
UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
"
fi
if { test "$mbfl_INTERACTIVE"  '!=' 'yes'; }
then
declare -r mbfl_message_VERSION="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
This is free software; see the  source or use the '--license' option for
copying conditions.  There is NO warranty; not  even for MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.
"
fi
function mbfl_main_print_version_number () {
echo -e "$mbfl_message_VERSION"
exit_success
}
function mbfl_main_print_version_number_only () {
echo -e "$script_VERSION"
exit_success
}
function mbfl_main_print_license () {
case $script_LICENSE in
GPL|GPL2)
echo -e "$mbfl_message_LICENSE_GPL"
;;
GPL3)
echo -e "$mbfl_message_LICENSE_GPL3"
;;
LGPL|LGPL2)
echo -e "$mbfl_message_LICENSE_LGPL"
;;
LGPL3)
echo -e "$mbfl_message_LICENSE_LGPL3"
;;
BSD)
echo -e "$mbfl_message_LICENSE_BSD"
;;
liberal)
echo -e "$mbfl_message_LICENSE_LIBERAL"
;;
*)
mbfl_message_error_printf 'unknown license: "%s"' "$script_LICENSE"
exit_failure
;;
esac
exit_success
}
function mbfl_main_print_usage_screen_long () {
if mbfl_string_is_not_empty "$script_USAGE"
then printf '%s\n' "$script_USAGE"
else printf 'usafe: %s [arguments]\n' "$script_PROGNAME"
fi
if mbfl_string_is_not_empty "$script_DESCRIPTION"
then
printf "${script_DESCRIPTION}\n\n"
fi
mbfl_actions_print_usage_screen
mbfl_getopts_print_usage_screen long
if mbfl_string_is_not_empty "$script_EXAMPLES"
then
printf "${script_EXAMPLES}\n"
fi
exit_success
}
function mbfl_main_print_usage_screen_brief () {
if mbfl_string_is_not_empty "$script_USAGE"
then printf '%s\n' "$script_USAGE"
else printf 'usafe: %s [arguments]\n' "$script_PROGNAME"
fi
if mbfl_string_is_not_empty "$script_DESCRIPTION"
then
printf "${script_DESCRIPTION}\n\n"
fi
mbfl_actions_print_usage_screen
mbfl_getopts_print_usage_screen brief
if mbfl_string_is_not_empty "$script_EXAMPLES"
then
printf "${script_EXAMPLES}\n"
fi
exit_success
}
function mbfl_main () {
local exit_code=0 action_func item code
mbfl_message_set_progname "$script_PROGNAME"
mbfl_main_create_exit_functions
mbfl_main_check_mbfl_semantic_version
if mbfl_actions_set_exists MAIN
then
if ! mbfl_actions_dispatch MAIN
then exit_failure
fi
fi
if ! mbfl_invoke_script_function $mbfl_main_SCRIPT_BEFORE_PARSING_OPTIONS
then exit_because_invalid_function_name
fi
if ! mbfl_getopts_parse
then exit_because_invalid_option_argument
fi
if ! mbfl_invoke_script_function $mbfl_main_SCRIPT_AFTER_PARSING_OPTIONS
then exit_because_invalid_function_name
fi
if mbfl_string_is_not_empty "$mbfl_main_PRIVATE_SCRIPT_FUNCTION"
then mbfl_invoke_existent_script_function $mbfl_main_PRIVATE_SCRIPT_FUNCTION
else mbfl_invoke_existent_script_function $mbfl_main_SCRIPT_FUNCTION
fi
mbfl_exit $?
}
function mbfl_main_check_mbfl_semantic_version () {
if mbfl_shell_is_function 'script_check_mbfl_semantic_version'
then
if ! script_check_mbfl_semantic_version "$mbfl_SEMANTIC_VERSION"
then
mbfl_message_error_printf 'hard-coded MBFL library version "%s" does not satisfy the requirements of the script' \
"$mbfl_SEMANTIC_VERSION"
exit_because_invalid_mbfl_version
fi
elif mbfl_string_is_not_empty "$script_REQUIRED_MBFL_VERSION"
then
if ! mbfl_main_check_mbfl_semantic_version_variable
then exit_because_invalid_mbfl_version
fi
fi
}
function mbfl_main_check_mbfl_semantic_version_variable () {
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_message_debug_printf 'library version "%s", version required by the script "%s"' \
"$mbfl_SEMANTIC_VERSION" "$script_REQUIRED_MBFL_VERSION"
if {
mbfl_location_enter
{
mbfl_location_handler 'mbfl_semver_reset_config'
mbfl_semver_config[PARSE_LEADING_V]='optional'
mbfl_semver_compare_var $mbfl_a_variable_RV "$mbfl_SEMANTIC_VERSION" "$script_REQUIRED_MBFL_VERSION"
}
mbfl_location_leave
}
then
if (( RV >= 0 ))
then return 0
else
mbfl_message_error_printf \
'hard-coded MBFL library version "%s" is lesser than the minimum version required by the script "%s"' \
"$mbfl_SEMANTIC_VERSION" "$script_REQUIRED_MBFL_VERSION"
exit_because_invalid_mbfl_version
fi
else
mbfl_message_error_printf 'invalid required semantic version for MBFL: "%s"' "$script_REQUIRED_MBFL_VERSION"
exit_because_invalid_mbfl_version
fi
}
function mbfl_invoke_script_function () {
local  FUNC=${1:?"missing function name parameter to '$FUNCNAME'"}
if mbfl_shell_is_function "$FUNC"
then $FUNC
else return 0
fi
}
function mbfl_invoke_existent_script_function () {
local  FUNC=${1:?"missing function name parameter to '$FUNCNAME'"}
if mbfl_shell_is_function "$FUNC"
then $FUNC
else
mbfl_message_error_printf 'internal error: request to call non-existent function \"%s\"' "$FUNC"
exit_because_invalid_function_name
fi
}
if { test "$mbfl_INTERACTIVE"  '!=' 'yes'; }
then
declare -r MBFL_ASCII_RANGE_ASCII_SYMBOLS='.,:;{[()]}_=<>~+-*/%&$!?"^|#@'"'"'`'
declare -r MBFL_ASCII_RANGE_DIGITS='0123456789'
declare -r MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET='abcdefghijklmnopqrstuvwxyz'
declare -r MBFL_ASCII_RANGE_LOWER_CASE_VOWELS='aeiouy'
declare -r MBFL_ASCII_RANGE_LOWER_CASE_CONSONANTS='bcdfghjklmnpqrstvwxz'
declare -r MBFL_ASCII_RANGE_LOWER_CASE_ALNUM='abcdefghijklmnopqrstuvwxyz0123456789'
declare -r MBFL_ASCII_RANGE_LOWER_CASE_BASE16='abcdef0123456789'
declare -r MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
declare -r MBFL_ASCII_RANGE_UPPER_CASE_VOWELS='AEIOUY'
declare -r MBFL_ASCII_RANGE_UPPER_CASE_CONSONANTS='BCDFGHJKLMNPQRSTVWXZ'
declare -r MBFL_ASCII_RANGE_UPPER_CASE_ALNUM='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
declare -r MBFL_ASCII_RANGE_UPPER_CASE_BASE16='ABCDEF0123456789'
declare -r MBFL_ASCII_RANGE_MIXED_CASE_ALPHABET="${MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET}${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}"
declare -r MBFL_ASCII_RANGE_MIXED_CASE_VOWELS="${MBFL_ASCII_RANGE_LOWER_CASE_VOWELS}${MBFL_ASCII_RANGE_UPPER_CASE_VOWELS}"
declare -r MBFL_ASCII_RANGE_MIXED_CASE_CONSONANTS="${MBFL_ASCII_RANGE_LOWER_CASE_CONSONANTS}${MBFL_ASCII_RANGE_UPPER_CASE_CONSONANTS}"
declare -r MBFL_ASCII_RANGE_MIXED_CASE_ALNUM="${MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET}${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}${MBFL_ASCII_RANGE_DIGITS}"
declare -r MBFL_ASCII_RANGE_MIXED_CASE_BASE16='abcdefABCDEF0123456789'
declare -r MBFL_ASCII_RANGE_BASE32="${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}234567"
declare -r MBFL_ASCII_RANGE_BASE64="${MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET}${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}${MBFL_ASCII_RANGE_DIGITS}+/"
declare -r MBFL_ASCII_RANGE_ASCII_NOBLANK="${MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET}${MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET}${MBFL_ASCII_RANGE_DIGITS}${MBFL_ASCII_RANGE_ASCII_SYMBOLS}"
fi
function mbfl_string_is_quoted_char () {
local  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
local -i POS=${2:?"missing position parameter to '$FUNCNAME'"}
local -i COUNT
let --POS
for ((COUNT=0; POS >= 0; --POS))
do
if test "${STRING:${POS}:1}" = \\
then let ++COUNT
else break
fi
done
let ${COUNT}%2
}
function mbfl_string_is_equal_unquoted_char () {
local  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
local -i POS=${2:?"missing position parameter to '$FUNCNAME'"}
local  CHAR=${3:?"missing known char parameter to '$FUNCNAME'"}
if test "${STRING:${POS}:1}" != "$CHAR"
then mbfl_string_is_quoted_char "$STRING" "$POS"
fi
}
function mbfl_string_quote_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_STRING="${2:-}"
local -i mbfl_I
local mbfl_ch
mbfl_RESULT_VARREF=
for ((mbfl_I=0; mbfl_I < ${#mbfl_STRING}; ++mbfl_I))
do
mbfl_ch=${mbfl_STRING:$mbfl_I:1}
if test "$mbfl_ch" = \\
then mbfl_ch=\\\\
fi
mbfl_RESULT_VARREF+=$mbfl_ch
done
}
function mbfl_string_quote () {
local  STRING="${1:-}"
local RESULT_VARNAME
if mbfl_string_quote_var RESULT_VARNAME "$STRING"
then printf '%s\n' "$RESULT_VARNAME"
else return 1
fi
}
function mbfl_string_length () {
local  STRING="${1:-}"
echo ${#STRING}
}
function mbfl_string_length_equal_to () {
local -i LENGTH=${1:?"missing length of string parameter to '$FUNCNAME'"}
local  STRING="${2:-}"
test ${#STRING} -eq $LENGTH
}
function mbfl_string_is_empty () {
local  STRING="${1:-}"
test -z "$STRING"
}
function mbfl_string_is_not_empty () {
local  STRING="${1:-}"
test -n "$STRING"
}
function mbfl_string_first_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_STRING=${2:?"missing string parameter to '$FUNCNAME'"}
local  mbfl_CHAR=${3:?"missing char parameter to '$FUNCNAME'"}
local  mbfl_BEGIN="${4:-0}"
local -i mbfl_I
for ((mbfl_I=mbfl_BEGIN; mbfl_I < ${#mbfl_STRING}; ++mbfl_I))
do
if test "${mbfl_STRING:$mbfl_I:1}" = "$mbfl_CHAR"
then
mbfl_RESULT_VARREF=$mbfl_I
return 0
fi
done
return 1
}
function mbfl_string_first () {
local  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
local  CHAR=${2:?"missing char parameter to '$FUNCNAME'"}
local  BEGIN="${3:-}"
local mbfl_a_variable_RESULT_VARNAME
mbfl_variable_alloc mbfl_a_variable_RESULT_VARNAME
local  $mbfl_a_variable_RESULT_VARNAME
local -n RESULT_VARNAME=$mbfl_a_variable_RESULT_VARNAME
if mbfl_string_first_var $mbfl_a_variable_RESULT_VARNAME "$STRING" "$CHAR" "$BEGIN"
then printf '%s\n' "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_string_last_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_STRING=${2:?"missing string parameter to '$FUNCNAME'"}
local  mbfl_CHAR=${3:?"missing char parameter to '$FUNCNAME'"}
local  mbfl_BEGIN="${4:-}"
local -i mbfl_I
for ((mbfl_I=${mbfl_BEGIN:-((${#mbfl_STRING}-1))}; mbfl_I >= 0; --mbfl_I))
do
if test "${mbfl_STRING:$mbfl_I:1}" = "$mbfl_CHAR"
then
mbfl_RESULT_VARREF=$mbfl_I
return 0
fi
done
return 1
}
function mbfl_string_last () {
local  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
local  CHAR=${2:?"missing char parameter to '$FUNCNAME'"}
local  BEGIN="${3:-}"
local mbfl_a_variable_RESULT_VARNAME
mbfl_variable_alloc mbfl_a_variable_RESULT_VARNAME
local  $mbfl_a_variable_RESULT_VARNAME
local -n RESULT_VARNAME=$mbfl_a_variable_RESULT_VARNAME
if mbfl_string_last_var $mbfl_a_variable_RESULT_VARNAME "$STRING" "$CHAR" "$BEGIN"
then printf '%s\n' "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_string_index_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_STRING=${2:?"missing string parameter to '$FUNCNAME'"}
local  mbfl_INDEX=${3:?"missing index parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=${mbfl_STRING:${mbfl_INDEX}:1}
}
function mbfl_string_index () {
local  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
local  INDEX=${2:?"missing index parameter to '$FUNCNAME'"}
printf "${STRING:$INDEX:1}\n"
}
function mbfl_string_range_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_STRING=${2:?"missing string parameter to '$FUNCNAME'"}
local  mbfl_BEGIN=${3:?"missing begin parameter to '$FUNCNAME'"}
local  mbfl_END="${4:-}"
if test -z "$mbfl_END" -o "$mbfl_END" = 'end' -o "$mbfl_END" = 'END'
then mbfl_RESULT_VARREF=${mbfl_STRING:$mbfl_BEGIN}
else mbfl_RESULT_VARREF=${mbfl_STRING:$mbfl_BEGIN:$mbfl_END}
fi
}
function mbfl_string_range () {
local  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
local  BEGIN=${2:?"missing begin parameter to '$FUNCNAME'"}
local  END="${3:-}"
local mbfl_a_variable_RESULT_VARNAME
mbfl_variable_alloc mbfl_a_variable_RESULT_VARNAME
local  $mbfl_a_variable_RESULT_VARNAME
local -n RESULT_VARNAME=$mbfl_a_variable_RESULT_VARNAME
if mbfl_string_range_var $mbfl_a_variable_RESULT_VARNAME "$STRING" "$BEGIN" "$END"
then printf '%s\n' "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_string_is_true () {
local  STRING=${1:?"missing the string argument parameter to '$FUNCNAME'"}
test 'true' = "$STRING"
}
function mbfl_string_is_false () {
local  STRING=${1:?"missing the string argument parameter to '$FUNCNAME'"}
test 'false' = "$STRING"
}
function mbfl_string_chars () {
local  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
local -i i j
local ch
for ((i=0, j=0; i < ${#STRING}; ++i, ++j))
do
ch=${STRING:$i:1}
if test "$ch" != $'\\'
then SPLITFIELD[$j]=$ch
else
let ++i
if test $i != ${#STRING}
then SPLITFIELD[$j]=${ch}${STRING:$i:1}
else SPLITFIELD[$j]=$ch
fi
fi
done
SPLITCOUNT=$j
return 0
}
function mbfl_string_split () {
local  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
local  SEPARATOR=${2:?"missing separator parameter to '$FUNCNAME'"}
local -i i j k=0 first=0
SPLITFIELD=()
SPLITCOUNT=0
for ((i=0; i < ${#STRING}; ++i))
do
if (( (i + ${#SEPARATOR}) > ${#STRING}))
then break
elif mbfl_string_equal_substring "$STRING" $i "$SEPARATOR"
then
SPLITFIELD[$k]=${STRING:$first:$((i - first))}
let ++k
let i+=${#SEPARATOR}-1
let first=i+1
fi
done
SPLITFIELD[$k]=${STRING:$first}
let ++k
SPLITCOUNT=$k
return 0
}
function mbfl_string_split_blanks () {
local  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
local ACCUM CH
local -i i
SPLITFIELD=()
SPLITCOUNT=0
for ((i=0; i < ${#STRING}; ++i))
do
CH=${STRING:$i:1}
if test ' ' = "$CH" -o $'\t' = "$CH"
then
SPLITFIELD[${#SPLITFIELD[@]}]=$ACCUM
ACCUM=
for ((i=$i; i < ${#STRING}; ++i))
do
CH=${STRING:$((i+1)):1}
if test ' ' != "$CH" -a $'\t' != "$CH"
then break
fi
done
else ACCUM+=$CH
fi
done
if mbfl_string_is_not_empty "$ACCUM"
then SPLITFIELD[${#SPLITFIELD[@]}]=$ACCUM
fi
SPLITCOUNT=${#SPLITFIELD[@]}
return 0
}
function mbfl_string_equal () {
local  STR1="${1:-}"
local  STR2="${2:-}"
test "$STR1" '=' "$STR2"
}
function mbfl_string_not_equal () {
local  STR1="${1:-}"
local  STR2="${2:-}"
test "$STR1" '!=' "$STR2"
}
function mbfl_string_is_yes () {
local  STR="${1:-}"
test "$STR" = 'yes'
}
function mbfl_string_is_no () {
local  STR="${1:-}"
test "$STR" = 'no'
}
function mbfl_string_less () {
local  STR1="${1:-}"
local  STR2="${2:-}"
test "$STR1" '<' "$STR2"
}
function mbfl_string_greater () {
local  STR1="${1:-}"
local  STR2="${2:-}"
test "$STR1" '>' "$STR2"
}
function mbfl_string_less_or_equal () {
local  STR1="${1:-}"
local  STR2="${2:-}"
test "$STR1" '<' "$STR2" -o "$STR1" '=' "$STR2"
}
function mbfl_string_greater_or_equal () {
local  STR1="${1:-}"
local  STR2="${2:-}"
test "$STR1" '>' "$STR2" -o "$STR1" '=' "$STR2"
}
function mbfl_string_equal_substring () {
local  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
local  POSITION=${2:?"missing position parameter to '$FUNCNAME'"}
local  PATTERN=${3:?"missing pattern parameter to '$FUNCNAME'"}
local i
if (( (POSITION + ${#PATTERN}) > ${#STRING} ))
then return 1
fi
for ((i=0; i < "${#PATTERN}"; ++i))
do
if test "${PATTERN:$i:1}" != "${STRING:$(($POSITION+$i)):1}"
then return 1
fi
done
return 0
}
function mbfl_string_is_alpha_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
! test \( "$CHAR" \< A -o Z \< "$CHAR" \) -a \( "$CHAR" \< a -o z \< "$CHAR" \)
}
function mbfl_string_is_digit_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
! test "$CHAR" \< 0 -o 9 \< "$CHAR"
}
function mbfl_string_is_alnum_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
mbfl_string_is_alpha_char "$CHAR" || mbfl_string_is_digit_char "$CHAR"
}
function mbfl_string_is_name_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
mbfl_string_is_alnum_char "$CHAR" || test "$CHAR" = _
}
function mbfl_string_is_identifier_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
mbfl_string_is_alnum_char "$CHAR" || test "$CHAR" = '_' -o "$CHAR" = '-'
}
function mbfl_string_is_extended_identifier_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
mbfl_string_is_alnum_char "$CHAR" || test "$CHAR" = '_' -o "$CHAR" = '-' -o "$CHAR" = '.'
}
function mbfl_string_is_noblank_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
test \( "$CHAR" != " " \) -a \
\( "$CHAR" != $'\n' \) -a \( "$CHAR" != $'\r' \) -a \
\( "$CHAR" != $'\t' \) -a \( "$CHAR" != $'\f' \)
}
function mbfl_string_is_ascii_symbol_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_ASCII_SYMBOLS" "$CHAR"
}
function mbfl_string_is_lower_case_vowel_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_LOWER_CASE_VOWELS" "$CHAR"
}
function mbfl_string_is_lower_case_consonant_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_LOWER_CASE_CONSONANTS" "$CHAR"
}
function mbfl_string_is_lower_case_alphabet_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_LOWER_CASE_ALPHABET" "$CHAR"
}
function mbfl_string_is_lower_case_alnum_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_LOWER_CASE_ALNUM" "$CHAR"
}
function mbfl_string_is_lower_case_base16_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_LOWER_CASE_BASE16" "$CHAR"
}
function mbfl_string_is_upper_case_vowel_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_UPPER_CASE_VOWELS" "$CHAR"
}
function mbfl_string_is_upper_case_consonant_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_UPPER_CASE_CONSONANTS" "$CHAR"
}
function mbfl_string_is_upper_case_alphabet_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_UPPER_CASE_ALPHABET" "$CHAR"
}
function mbfl_string_is_upper_case_alnum_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_UPPER_CASE_ALNUM" "$CHAR"
}
function mbfl_string_is_upper_case_base16_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_UPPER_CASE_BASE16" "$CHAR"
}
function mbfl_string_is_mixed_case_vowel_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_MIXED_CASE_VOWELS" "$CHAR"
}
function mbfl_string_is_mixed_case_consonant_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_MIXED_CASE_CONSONANTS" "$CHAR"
}
function mbfl_string_is_mixed_case_alphabet_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_MIXED_CASE_ALPHABET" "$CHAR"
}
function mbfl_string_is_mixed_case_alnum_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_MIXED_CASE_ALNUM" "$CHAR"
}
function mbfl_string_is_mixed_case_base16_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_MIXED_CASE_BASE16" "$CHAR"
}
function mbfl_string_is_base32_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_BASE32" "$CHAR"
}
function mbfl_string_is_base64_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_BASE64" "$CHAR"
}
function mbfl_string_is_ascii_noblank_char () {
local  CHAR=${1:?"missing char parameter to '$FUNCNAME'"}
local mbfl_a_variable_RV
mbfl_variable_alloc mbfl_a_variable_RV
local  $mbfl_a_variable_RV
local -n RV=$mbfl_a_variable_RV
mbfl_string_first_var $mbfl_a_variable_RV "$MBFL_ASCII_RANGE_ASCII_NOBLANK" "$CHAR"
}
function mbfl_p_string_is () {
local  CHAR_PRED_FUNC=${1:?"missing char predicate func parameter to '$FUNCNAME'"}
local STRING=$2
local -i i
if ((0 < ${#STRING}))
then
for ((i=0; i < ${#STRING}; ++i))
do
if ! $CHAR_PRED_FUNC "${STRING:$i:1}"
then return 1
fi
done
return 0
else return 1
fi
}
function mbfl_string_is_alpha			() { mbfl_p_string_is mbfl_string_is_alpha_char   "$@"; }
function mbfl_string_is_digit			() { mbfl_p_string_is mbfl_string_is_digit_char   "$@"; }
function mbfl_string_is_alnum			() { mbfl_p_string_is mbfl_string_is_alnum_char   "$@"; }
function mbfl_string_is_noblank			() { mbfl_p_string_is mbfl_string_is_noblank_char "$@"; }
function mbfl_string_is_ascii_symbol		() { mbfl_p_string_is mbfl_string_is_ascii_symbol_char "$@"; }
function mbfl_string_is_lower_case_vowel	() { mbfl_p_string_is mbfl_string_is_lower_case_vowel_char "$@"; }
function mbfl_string_is_lower_case_consonant	() { mbfl_p_string_is mbfl_string_is_lower_case_consonant_char "$@"; }
function mbfl_string_is_lower_case_alphabet	() { mbfl_p_string_is mbfl_string_is_lower_case_alphabet_char "$@"; }
function mbfl_string_is_lower_case_alnum	() { mbfl_p_string_is mbfl_string_is_lower_case_alnum_char "$@"; }
function mbfl_string_is_lower_case_base16	() { mbfl_p_string_is mbfl_string_is_lower_case_base16_char "$@"; }
function mbfl_string_is_upper_case_vowel	() { mbfl_p_string_is mbfl_string_is_upper_case_vowel_char "$@"; }
function mbfl_string_is_upper_case_consonant	() { mbfl_p_string_is mbfl_string_is_upper_case_consonant_char "$@"; }
function mbfl_string_is_upper_case_alphabet	() { mbfl_p_string_is mbfl_string_is_upper_case_alphabet_char "$@"; }
function mbfl_string_is_upper_case_alnum	() { mbfl_p_string_is mbfl_string_is_upper_case_alnum_char "$@"; }
function mbfl_string_is_upper_case_base16	() { mbfl_p_string_is mbfl_string_is_upper_case_base16_char "$@"; }
function mbfl_string_is_mixed_case_vowel	() { mbfl_p_string_is mbfl_string_is_mixed_case_vowel_char "$@"; }
function mbfl_string_is_mixed_case_consonant	() { mbfl_p_string_is mbfl_string_is_mixed_case_consonant_char "$@"; }
function mbfl_string_is_mixed_case_alphabet	() { mbfl_p_string_is mbfl_string_is_mixed_case_alphabet_char "$@"; }
function mbfl_string_is_mixed_case_alnum	() { mbfl_p_string_is mbfl_string_is_mixed_case_alnum_char "$@"; }
function mbfl_string_is_mixed_case_base16	() { mbfl_p_string_is mbfl_string_is_mixed_case_base16_char "$@"; }
function mbfl_string_is_base32			() { mbfl_p_string_is mbfl_string_is_base32_char "$@"; }
function mbfl_string_is_base64			() { mbfl_p_string_is mbfl_string_is_base64_char "$@"; }
function mbfl_string_is_ascii_noblank		() { mbfl_p_string_is mbfl_string_is_ascii_noblank_char "$@"; }
function mbfl_string_is_name () {
local STRING=$1
mbfl_string_is_not_empty "$STRING" && \
mbfl_p_string_is mbfl_string_is_name_char "$STRING" && \
{ ! mbfl_string_is_digit "${STRING:0:1}"; }
}
function mbfl_string_is_identifier () {
local  STRING="${1:-}"
mbfl_string_is_not_empty "$STRING"					\
&&   mbfl_p_string_is mbfl_string_is_identifier_char "$STRING"	\
&& ! mbfl_string_is_digit "${STRING:0:1}"		\
&& mbfl_string_not_equal "${STRING:0:1}" '-'
}
function mbfl_string_is_extended_identifier () {
local STRING=$1
mbfl_string_is_not_empty "$STRING" \
&&   mbfl_p_string_is mbfl_string_is_extended_identifier_char "$STRING"		\
&& ! mbfl_string_is_digit "${STRING:0:1}"				\
&& mbfl_string_not_equal "${STRING:0:1}" '-'
}
function mbfl_string_is_username () {
local  STRING="${1:-}"
local -r REX='^(([a-zA-Z0-9_\.\-]+)|(\+[0-9]+))$'
if mbfl_string_equal $'\n' "${STRING:$((${#STRING} - 1)):1}"
then return_failure
elif [[ "$STRING" =~ $REX ]]
then return_success
else return_failure
fi
}
function mbfl_string_is_groupname () {
local  STRING="${1:-}"
mbfl_string_is_username "$STRING"
}
function mbfl_string_is_network_port () {
local  STRING="${1:-}"
if mbfl_string_is_not_empty "$STRING" && mbfl_string_is_digit "$STRING" && ((0 <= STRING && STRING <= 1024))
then return 0
else return 1
fi
}
function mbfl_string_is_network_hostname () {
local  STRING="${1:-}"
local -r REX="^([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])(\.([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]{0,61}[a-zA-Z0-9]))*$"
if ((${#STRING} <= 255)) && [[ $STRING =~ $REX ]]
then return 0
fi
return 1
}
function mbfl_string_is_network_ip_address () {
local  STRING="${1:-}"
local -r REX="^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
if ((${#STRING} <= 255)) && [[ $STRING =~ $REX ]]
then return 0
fi
return 1
}
function mbfl_string_is_email_address () {
local  ADDRESS="${1:-}"
local -r REX='^[a-zA-Z0-9_.\-]+(@[a-zA-Z0-9_.\-]+)?$'
if [[ $ADDRESS =~ $REX ]]
then return 0
else return 1
fi
}
function mbfl_string_toupper () {
echo "${1^^}"
}
function mbfl_string_tolower () {
echo "${1,,}"
}
function mbfl_string_toupper_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
mbfl_RESULT_VARREF="${2^^}"
}
function mbfl_string_tolower_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
mbfl_RESULT_VARREF="${2,,}"
}
function mbfl_string_replace () {
local  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
local  PATTERN=${2:?"missing pattern parameter to '$FUNCNAME'"}
local  SUBST="${3:-}"
printf '%s\n' "${STRING//$PATTERN/$SUBST}"
}
function mbfl_string_replace_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_STRING=${2:?"missing string parameter to '$FUNCNAME'"}
local  mbfl_PATTERN=${3:?"missing pattern parameter to '$FUNCNAME'"}
local  mbfl_SUBST="${4:-}"
mbfl_RESULT_VARREF=${mbfl_STRING//${mbfl_PATTERN}/${mbfl_SUBST}}
}
function mbfl_string_skip () {
local  mbfl_STRING=${1:?"missing string parameter to '$FUNCNAME'"}
local mbfl_a_variable_mbfl_POSNAME=${2:?"missing position parameter to '$FUNCNAME'"}
local -n mbfl_POSNAME=$mbfl_a_variable_mbfl_POSNAME
local  mbfl_CHAR=${3:?"missing char parameter to '$FUNCNAME'"}
while test "${mbfl_STRING:$mbfl_POSNAME:1}" = "$mbfl_CHAR"
do let ++mbfl_POSNAME
done
}
function mbfl_sprintf () {
local  VARNAME=${1:?"missing variable name parameter to '$FUNCNAME'"}
local  FORMAT=${2:?"missing format parameter to '$FUNCNAME'"}
local OUTPUT=
shift 2
printf -v OUTPUT "$FORMAT" "$@"
eval "$VARNAME"=\'"$OUTPUT"\'
}
function mbfl_string_strip_carriage_return_var () {
local mbfl_a_variable_RESULT_NAMEREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n RESULT_NAMEREF=$mbfl_a_variable_RESULT_NAMEREF
local  LINE="${2:-}"
if mbfl_string_is_not_empty "$LINE"
then
local mbfl_a_variable_CH
mbfl_variable_alloc mbfl_a_variable_CH
local  $mbfl_a_variable_CH
local -n CH=$mbfl_a_variable_CH
mbfl_string_index_var $mbfl_a_variable_CH "$LINE" $((${#LINE} - 1))
if mbfl_string_equal "$CH" $'\r'
then RESULT_NAMEREF=${LINE:0:((${#LINE} - 1))}
else RESULT_NAMEREF=$LINE
fi
fi
}
declare -a mbfl_atexit_HANDLERS
declare -i mbfl_atexit_NEXT=0
function mbfl_atexit_enable () {
trap mbfl_atexit_run EXIT
}
function mbfl_atexit_disable () {
trap '' EXIT
}
function mbfl_atexit_register () {
local  mbfl_HANDLER=${1:?"missing handler script parameter to '$FUNCNAME'"}
local  mbfl_IDVAR="${2:-}"
if mbfl_string_is_not_empty "$mbfl_IDVAR"
then local -n mbfl_ID_VARREF=$mbfl_IDVAR
else local mbfl_ID_VARREF
fi
mbfl_atexit_HANDLERS[$mbfl_atexit_NEXT]=$mbfl_HANDLER
mbfl_ID_VARREF=$mbfl_atexit_NEXT
let ++mbfl_atexit_NEXT
}
function mbfl_atexit_forget () {
local -i ID=${1:?"missing handler id parameter to '$FUNCNAME'"}
mbfl_atexit_HANDLERS[$ID]=
}
function mbfl_atexit_run () {
local HANDLER
local -i i
for ((i=${#mbfl_atexit_HANDLERS[@]}-1; i >= 0; --i))
do
HANDLER=${mbfl_atexit_HANDLERS[$i]}
if mbfl_string_is_not_empty "$HANDLER"
then
mbfl_atexit_HANDLERS[$i]=
"$HANDLER"
fi
done
}
function mbfl_atexit_clear () {
mbfl_atexit_HANDLERS=()
mbfl_atexit_NEXT=0
}
declare -A mbfl_location_HANDLERS
declare -i mbfl_location_COUNTER=0
declare mbfl_location_ATEXIT_ID
function mbfl_location_enter () {
let ++mbfl_location_COUNTER
mbfl_location_HANDLERS[${mbfl_location_COUNTER}:count]=0
}
function mbfl_location_leave () {
local RETURN_STATUS=$?
if ((0 < mbfl_location_COUNTER))
then
local -i i HANDLERS_COUNT=${mbfl_location_HANDLERS[${mbfl_location_COUNTER}:count]}
local HANDLER HANDLER_KEY
for ((i=HANDLERS_COUNT; 0 < i; --i))
do
HANDLER_KEY=${mbfl_location_COUNTER}:${i}
HANDLER=${mbfl_location_HANDLERS[${HANDLER_KEY}]}
if mbfl_string_is_not_empty $HANDLER
then eval $HANDLER
fi
unset -v mbfl_location_HANDLERS[${HANDLER_KEY}]
done
unset -v mbfl_location_HANDLERS[${mbfl_location_COUNTER}:count]
let --mbfl_location_COUNTER
fi
return $RETURN_STATUS
}
function mbfl_location_run_all () {
while ((0 < mbfl_location_COUNTER))
do mbfl_location_leave
done
}
function mbfl_location_enable_cleanup_atexit () {
mbfl_atexit_register mbfl_location_run_all mbfl_location_ATEXIT_ID
}
function mbfl_location_disable_cleanup_atexit () {
mbfl_atexit_forget $mbfl_location_ATEXIT_ID
}
function mbfl_location_handler () {
if ((0 < mbfl_location_COUNTER))
then
local  HANDLER=${1:?"missing location handler parameter to '$FUNCNAME'"}
local COUNT_KEY=${mbfl_location_COUNTER}:count
let ++mbfl_location_HANDLERS[${COUNT_KEY}]
local HANDLER_KEY=${mbfl_location_COUNTER}:${mbfl_location_HANDLERS[${COUNT_KEY}]}
mbfl_location_HANDLERS[${HANDLER_KEY}]=${HANDLER}
else
mbfl_message_error 'attempt to register a location handler outside any location'
exit_because_no_location
fi
}
function mbfl_location_handler_suspend_testing () {
mbfl_option_test_save
mbfl_location_handler mbfl_option_test_restore
}
function mbfl_location_handler_change_directory () {
local  NEWPWD=${1:?"missing new process working directory parameter to '$FUNCNAME'"}
if ! mbfl_directory_is_executable "$NEWPWD"
then
pushd -n "$NEWPWD" &>/dev/null
if mbfl_cd "$NEWPWD"
then
mbfl_location_handler 'popd'
return_success
else return_failure
fi
else return_failure
fi
}
function mbfl_encode_hex_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable reference parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_INPUT=${2:?"missing input string parameter to '$FUNCNAME'"}
local -i mbfl_I
local mbfl_OCTET mbfl_ENCODED_OCTET
for ((mbfl_I=0; mbfl_I < ${#mbfl_INPUT}; ++mbfl_I))
do
printf -v mbfl_OCTET         '%d' "'${mbfl_INPUT:${mbfl_I}:1}"
printf -v mbfl_ENCODED_OCTET '%02X' "$mbfl_OCTET"
mbfl_RESULT_VARREF+=$mbfl_ENCODED_OCTET
done
return 0
}
function mbfl_encode_hex () {
local  INPUT=${1:?"missing input string parameter to '$FUNCNAME'"}
local RESULT_VARNAME
mbfl_encode_hex_var RESULT_VARNAME "$INPUT"
echo "$RESULT_VARNAME"
}
function mbfl_encode_oct_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable reference parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_INPUT=${2:?"missing input string parameter to '$FUNCNAME'"}
local -i mbfl_I
local mbfl_OCTET mbfl_ENCODED_OCTET
for ((mbfl_I=0; mbfl_I < ${#mbfl_INPUT}; ++mbfl_I))
do
printf -v mbfl_OCTET         '%d' "'${mbfl_INPUT:${mbfl_I}:1}"
printf -v mbfl_ENCODED_OCTET '%03o' "$mbfl_OCTET"
mbfl_RESULT_VARREF+=$mbfl_ENCODED_OCTET
done
return 0
}
function mbfl_encode_oct () {
local  INPUT=${1:?"missing input string parameter to '$FUNCNAME'"}
local RESULT_VARNAME
mbfl_encode_oct_var RESULT_VARNAME "$INPUT"
echo "$RESULT_VARNAME"
}
function mbfl_decode_hex_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable reference parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_INPUT=${2:?"missing input string parameter to '$FUNCNAME'"}
local -i mbfl_I
local mbfl_DECODED_OCTET
for ((mbfl_I=0; mbfl_I < ${#mbfl_INPUT}; mbfl_I+=2))
do
printf -v mbfl_DECODED_OCTET "\\x${mbfl_INPUT:${mbfl_I}:2}"
mbfl_RESULT_VARREF+=$mbfl_DECODED_OCTET
done
return 0
}
function mbfl_decode_hex () {
local  INPUT=${1:?"missing input string parameter to '$FUNCNAME'"}
local RESULT_VARNAME
mbfl_decode_hex_var RESULT_VARNAME "$INPUT"
echo "$RESULT_VARNAME"
}
function mbfl_decode_oct_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable reference parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_INPUT=${2:?"missing input string parameter to '$FUNCNAME'"}
local -i mbfl_I
local mbfl_DECODED_OCTET
for ((mbfl_I=0; mbfl_I < ${#mbfl_INPUT}; mbfl_I+=3))
do
printf -v mbfl_DECODED_OCTET "\\${mbfl_INPUT:${mbfl_I}:3}"
mbfl_RESULT_VARREF+=$mbfl_DECODED_OCTET
done
return 0
}
function mbfl_decode_oct () {
local  INPUT=${1:?"missing input string parameter to '$FUNCNAME'"}
local RESULT_VARNAME
mbfl_decode_oct_var RESULT_VARNAME "$INPUT"
echo "$RESULT_VARNAME"
}
function mbfl_fd_p_check_fd () {
local  FD=${1:?"missing file descriptor parameter to '$FUNCNAME'"}
local  POS=${2:?"missing positional argument index parameter to '$FUNCNAME'"}
if mbfl_string_is_digit "$1"
then return 1
else
mbfl_message_error_printf 'file descriptor positional argument %d is not a digit: "%s"' $POS "$FD"
return 0
fi
}
function mbfl_fd_p_execute_operation () {
local  COMMAND=${1:?"missing statement to execute parameter to '$FUNCNAME'"}
if { mbfl_option_test || mbfl_option_show_program; }
then echo "$COMMAND" >&2
fi
eval "$COMMAND"
}
function mbfl_fd_open_input () {
local  FD=${1:?"missing file descriptor parameter to '$FUNCNAME'"}
local  FILE=${2:?"missing file pathname parameter to '$FUNCNAME'"}
if mbfl_fd_p_check_fd "$FD" 1
then return 1
fi
{
local COMMAND TEMPLATE='exec %s<"%s"'
printf -v COMMAND "$TEMPLATE" "$FD" "$FILE"
mbfl_fd_p_execute_operation "$COMMAND"
}
}
function mbfl_fd_open_output () {
local  FD=${1:?"missing file descriptor parameter to '$FUNCNAME'"}
local  FILE=${2:?"missing file pathname parameter to '$FUNCNAME'"}
if mbfl_fd_p_check_fd "$FD" 1
then return 1
fi
{
local COMMAND TEMPLATE='exec %s>"%s"'
printf -v COMMAND "$TEMPLATE" "$FD" "$FILE"
mbfl_fd_p_execute_operation "$COMMAND"
}
}
function mbfl_fd_open_input_output () {
local  FD=${1:?"missing file descriptor parameter to '$FUNCNAME'"}
local  FILE=${2:?"missing file pathname parameter to '$FUNCNAME'"}
if mbfl_fd_p_check_fd "$FD" 1
then return 1
fi
{
local COMMAND TEMPLATE='exec %s<>"%s"'
printf -v COMMAND "$TEMPLATE" "$FD" "$FILE"
mbfl_fd_p_execute_operation "$COMMAND"
}
}
function mbfl_fd_close () {
local  FD=${1:?"missing file descriptor parameter to '$FUNCNAME'"}
if mbfl_fd_p_check_fd "$FD" 1
then return 1
fi
{
local COMMAND TEMPLATE='exec %s<&-'
printf -v COMMAND "$TEMPLATE" "$FD"
mbfl_fd_p_execute_operation "$COMMAND"
}
}
function mbfl_fd_dup_input () {
local  SRCFD=${1:?"missing source file descriptor parameter to '$FUNCNAME'"}
local  DSTFD=${2:?"missing dest file descriptor parameter to '$FUNCNAME'"}
if mbfl_fd_p_check_fd "$SRCFD" 1
then return 1
fi
if mbfl_fd_p_check_fd "$DSTFD" 2
then return 1
fi
{
local COMMAND TEMPLATE='exec %s<&%s'
printf -v COMMAND "$TEMPLATE" "$DSTFD" "$SRCFD"
mbfl_fd_p_execute_operation "$COMMAND"
}
}
function mbfl_fd_dup_output () {
local  SRCFD=${1:?"missing source file descriptor parameter to '$FUNCNAME'"}
local  DSTFD=${2:?"missing dest file descriptor parameter to '$FUNCNAME'"}
if mbfl_fd_p_check_fd "$SRCFD" 1
then return 1
fi
if mbfl_fd_p_check_fd "$DSTFD" 2
then return 1
fi
{
local COMMAND TEMPLATE='exec %s>&%s'
printf -v COMMAND "$TEMPLATE" "$DSTFD" "$SRCFD"
mbfl_fd_p_execute_operation "$COMMAND"
}
}
function mbfl_fd_move () {
local  SRCFD=${1:?"missing source file descriptor parameter to '$FUNCNAME'"}
local  DSTFD=${2:?"missing dest file descriptor parameter to '$FUNCNAME'"}
if mbfl_fd_p_check_fd "$SRCFD" 1
then return 1
fi
if mbfl_fd_p_check_fd "$DSTFD" 2
then return 1
fi
{
local COMMAND TEMPLATE='exec %s<&%s-'
printf -v COMMAND "$TEMPLATE" "$DSTFD" "$SRCFD"
mbfl_fd_p_execute_operation "$COMMAND"
}
}
function mbfl_file_p_validate_executable_hard_coded_pathname () {
local  PROGRAM_PATHNAME=${1:?"missing executable program pathname parameter to '$FUNCNAME'"}
! mbfl_string_equal '/bin/false' "$PROGRAM_PATHNAME" && mbfl_file_is_executable "$PROGRAM_PATHNAME"
}
function mbfl_p_file_backwards_looking_at_double_dot () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local -i INDEX=${2:?"missing pathname index parameter to '$FUNCNAME'"}
if ((0 < INDEX))
then
local -r ch=${PATHNAME:$((INDEX - 1)):1}
if   ((1 == INDEX)) && test "$ch" = '.'
then return_success
elif ((1 < INDEX))  && test \( "$ch" = '.' \) -a \( "${PATHNAME:$((INDEX - 2)):1}" = '/' \)
then return_success
else return_because_failure
fi
else return_because_failure
fi
}
function mbfl_p_file_looking_at_component_beginning () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local -i INDEX=${2:?"missing pathname index parameter to '$FUNCNAME'"}
test 0 -eq $INDEX -o "${PATHNAME:$((INDEX - 1)):1}" = '/'
}
function mbfl_cd () {
local  DIRECTORY=${1:?"missing directory parameter to '$FUNCNAME'"}
shift 1
mbfl_file_normalise_var DIRECTORY "$DIRECTORY"
mbfl_message_verbose "entering directory: '${DIRECTORY}'\n"
mbfl_change_directory "$DIRECTORY" "$@"
}
function mbfl_change_directory () {
local  DIRECTORY=${1:?"missing directory parameter to '$FUNCNAME'"}
shift 1
cd "$@" "$DIRECTORY" &>/dev/null
}
function mbfl_file_extension_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
local -i mbfl_I
local mbfl_result
for ((mbfl_I=${#mbfl_PATHNAME}; mbfl_I > 0; --mbfl_I))
do
if test "${mbfl_PATHNAME:$mbfl_I:1}" = '/'
then break
else
if mbfl_string_is_equal_unquoted_char "$mbfl_PATHNAME" $mbfl_I .
then
if test "${mbfl_PATHNAME:$((mbfl_I - 1)):1}" = '/'
then
break
else
mbfl_result=${mbfl_PATHNAME:$((mbfl_I + 1))}
break
fi
fi
fi
done
mbfl_RESULT_VARREF=$mbfl_result
return_success
}
function mbfl_file_extension () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local RESULT_VARNAME
if mbfl_file_extension_var RESULT_VARNAME "$PATHNAME"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_dirname_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PATHNAME="${2:-}"
local -i mbfl_I
local mbfl_result=.
for ((mbfl_I=${#mbfl_PATHNAME}; mbfl_I >= 0; --mbfl_I))
do
if test "${mbfl_PATHNAME:${mbfl_I}:1}" = '/'
then
while test \( ${mbfl_I} -gt 0 \) -a \( "${mbfl_PATHNAME:${mbfl_I}:1}" = '/' \)
do let --mbfl_I
done
mbfl_result=${mbfl_PATHNAME:0:$((mbfl_I + 1))}
break
fi
done
mbfl_RESULT_VARREF=$mbfl_result
return_success
}
function mbfl_file_dirname () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local RESULT_VARNAME
if mbfl_file_dirname_var RESULT_VARNAME "$PATHNAME"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_rootname_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
local -i mbfl_I=${#mbfl_PATHNAME}
local mbfl_ch mbfl_result
if test \( "$mbfl_PATHNAME" = '/' \) -o \( "$mbfl_PATHNAME" = '.' \) -o \( "$mbfl_PATHNAME" = '..' \)
then mbfl_result=$mbfl_PATHNAME
else
while ((0 < mbfl_I)) && test "${mbfl_PATHNAME:$((mbfl_I - 1)):1}" = '/'
do let --mbfl_I
done
mbfl_PATHNAME=${mbfl_PATHNAME:0:$mbfl_I}
if ((1 == mbfl_I))
then mbfl_result=$mbfl_PATHNAME
else
for ((mbfl_I=${#mbfl_PATHNAME}; $mbfl_I >= 0; --mbfl_I))
do
mbfl_ch=${mbfl_PATHNAME:$mbfl_I:1}
if test "$mbfl_ch" = '.'
then
if mbfl_p_file_backwards_looking_at_double_dot "$mbfl_PATHNAME" $mbfl_I || \
mbfl_p_file_looking_at_component_beginning "$mbfl_PATHNAME" $mbfl_I
then
mbfl_result=$mbfl_PATHNAME
break
elif ((0 < mbfl_I))
then
mbfl_result=${mbfl_PATHNAME:0:$mbfl_I}
break
else
mbfl_result=$mbfl_PATHNAME
break
fi
elif test "$mbfl_ch" = '/'
then
mbfl_result=$mbfl_PATHNAME
break
fi
done
fi
fi
mbfl_RESULT_VARREF=$mbfl_result
return_success
}
function mbfl_file_rootname () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local RESULT_VARNAME
if mbfl_file_rootname_var RESULT_VARNAME "$PATHNAME"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_tail_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
local -i mbfl_I
local result=$mbfl_PATHNAME
for ((mbfl_I=${#mbfl_PATHNAME}; $mbfl_I >= 0; --mbfl_I))
do
if test "${mbfl_PATHNAME:$mbfl_I:1}" = '/'
then
result=${mbfl_PATHNAME:$((mbfl_I + 1))}
break
fi
done
mbfl_RESULT_VARREF=$result
return_success
}
function mbfl_file_tail () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local RESULT_VARNAME
if mbfl_file_tail_var RESULT_VARNAME "$PATHNAME"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_split () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local i=0 last_found=0 len=${#PATHNAME}
mbfl_string_skip "$PATHNAME" i '/'
last_found=$i
for ((SPLITCOUNT=0; $i < $len; ++i))
do
if test "${PATHNAME:$i:1}" = '/'
then
SPLITPATH[$SPLITCOUNT]=${PATHNAME:$last_found:$(($i-$last_found))}
let ++SPLITCOUNT
let ++i
mbfl_string_skip "$PATHNAME" i '/'
last_found=$i
fi
done
SPLITPATH[$SPLITCOUNT]=${PATHNAME:$last_found}
let ++SPLITCOUNT
return_success
}
function mbfl_file_strip_trailing_slash_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
local -i mbfl_I=${#mbfl_PATHNAME}
local mbfl_result
while ((0 < mbfl_I)) && test "${mbfl_PATHNAME:$((mbfl_I - 1)):1}" = '/'
do let --mbfl_I
done
if ((0 == mbfl_I))
then mbfl_result='.'
else mbfl_result=${mbfl_PATHNAME:0:$mbfl_I}
fi
mbfl_RESULT_VARREF=$mbfl_result
}
function mbfl_file_strip_trailing_slash () {
local  mbfl_PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local RESULT_VARNAME
if mbfl_file_strip_trailing_slash_var RESULT_VARNAME "$mbfl_PATHNAME"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_strip_leading_slash_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
local mbfl_result
if test "${mbfl_PATHNAME:0:1}" = '/'
then
local -i mbfl_I=1 mbfl_len=${#mbfl_PATHNAME}
while ((mbfl_I < mbfl_len)) && test "${mbfl_PATHNAME:$mbfl_I:1}" = '/'
do let ++mbfl_I
done
if ((mbfl_len == mbfl_I))
then mbfl_result='.'
else mbfl_result=${mbfl_PATHNAME:$mbfl_I}
fi
else mbfl_result=$mbfl_PATHNAME
fi
mbfl_RESULT_VARREF=$mbfl_result
}
function mbfl_file_strip_leading_slash () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local RESULT_VARNAME
if mbfl_file_strip_leading_slash_var RESULT_VARNAME "$PATHNAME"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_normalise_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
local  mbfl_PREFIX="${3:-}"
local mbfl_result mbfl_ORGPWD=$PWD
if mbfl_file_is_absolute "$mbfl_PATHNAME"
then
mbfl_p_file_normalise1_var mbfl_result "$mbfl_PATHNAME"
mbfl_RESULT_VARREF=$mbfl_result
elif mbfl_file_is_directory "$mbfl_PREFIX"
then
mbfl_PATHNAME=${mbfl_PREFIX}/${mbfl_PATHNAME}
mbfl_p_file_normalise1_var mbfl_result "$mbfl_PATHNAME"
mbfl_RESULT_VARREF=$mbfl_result
elif mbfl_string_is_not_empty "$mbfl_PREFIX"
then
local mbfl_PATHNAME1 mbfl_PATHNAME2
mbfl_p_file_remove_dots_from_pathname_var mbfl_PREFIX   "$mbfl_PREFIX"
mbfl_p_file_remove_dots_from_pathname_var mbfl_PATHNAME1 "$mbfl_PATHNAME"
mbfl_file_strip_trailing_slash_var        mbfl_PATHNAME2 "$mbfl_PATHNAME1"
printf -v mbfl_RESULT_VARREF '%s/%s' "$mbfl_PREFIX" "$mbfl_PATHNAME2"
else
mbfl_p_file_normalise1_var mbfl_result "$mbfl_PATHNAME"
mbfl_RESULT_VARREF=$mbfl_result
fi
cd "$mbfl_ORGPWD" >/dev/null
return_success
}
function mbfl_file_normalise () {
local  mbfl_PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local  mbfl_PREFIX="${2:-}"
local RESULT_VARNAME
if mbfl_file_normalise_var RESULT_VARNAME "$mbfl_PATHNAME" "$mbfl_PREFIX"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_p_file_remove_dots_from_pathname_var () {
local mbfl_a_variable_RESULT_VARREF1=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n RESULT_VARREF1=$mbfl_a_variable_RESULT_VARREF1
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
local   -a SPLITPATH
local -i SPLITCOUNT
local   -a mbfl_output
local -i mbfl_output_counter mbfl_input_counter
mbfl_file_split "$mbfl_PATHNAME"
for ((mbfl_input_counter=0, mbfl_output_counter=0; mbfl_input_counter < SPLITCOUNT; ++mbfl_input_counter))
do
case ${SPLITPATH[$mbfl_input_counter]} in
'.')
;;
'..')
let --mbfl_output_counter
;;
*)
mbfl_output[$mbfl_output_counter]=${SPLITPATH[$mbfl_input_counter]}
let ++mbfl_output_counter
;;
esac
done
{
local -i i
mbfl_PATHNAME=${mbfl_output[0]}
for ((i=1; $i < $mbfl_output_counter; ++i))
do mbfl_PATHNAME+=/${mbfl_output[$i]}
done
}
RESULT_VARREF1=$mbfl_PATHNAME
}
function mbfl_p_file_normalise1_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF1=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF1=$mbfl_a_variable_mbfl_RESULT_VARREF1
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
if mbfl_file_is_directory "$mbfl_PATHNAME"
then mbfl_p_file_normalise2_var mbfl_RESULT_VARREF1 "$mbfl_PATHNAME"
else
local mbfl_TAILNAME mbfl_DIRNAME
mbfl_file_tail_var    mbfl_TAILNAME "$mbfl_PATHNAME"
mbfl_file_dirname_var mbfl_DIRNAME  "$mbfl_PATHNAME"
if mbfl_file_is_directory "$mbfl_DIRNAME"
then mbfl_p_file_normalise2_var mbfl_RESULT_VARREF1 "$mbfl_DIRNAME" "$mbfl_TAILNAME"
else mbfl_file_strip_trailing_slash_var mbfl_RESULT_VARREF1 "$mbfl_PATHNAME"
fi
fi
}
function mbfl_p_file_normalise2_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF2=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF2=$mbfl_a_variable_mbfl_RESULT_VARREF2
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
local  mbfl_TAILNAME="${3:-}"
cd "$mbfl_PATHNAME" >/dev/null
if mbfl_string_is_not_empty "$mbfl_TAILNAME"
then printf -v mbfl_RESULT_VARREF2 '%s/%s' "$PWD" "$mbfl_TAILNAME"
else mbfl_RESULT_VARREF2=$PWD
fi
cd - >/dev/null
}
function mbfl_file_enable_realpath () {
: mbfl_declare_program realpath
}
function mbfl_exec_realpath () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_REALPATH"
then mbfl_program_exec "$mbfl_PROGRAM_REALPATH" "$@"
else
mbfl_message_error_printf 'program "realpath" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_REALPATH"
return_because_program_not_found
fi
}
function mbfl_file_realpath () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
shift
mbfl_exec_realpath "$@" -- "$PATHNAME"
}
function mbfl_file_realpath_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
shift 2
if ! mbfl_RESULT_VARREF=$(mbfl_file_realpath "$mbfl_PATHNAME" "$@")
then return $?
fi
}
function mbfl_file_subpathname_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
local  mbfl_BASEDIR=${3:?"missing base directory parameter to '$FUNCNAME'"}
if test "${mbfl_BASEDIR:$((${#mbfl_BASEDIR}-1))}" = '/'
then mbfl_BASEDIR=${mbfl_BASEDIR:0:$((${#mbfl_BASEDIR}-1))}
fi
if test "$mbfl_PATHNAME" = "$mbfl_BASEDIR"
then
mbfl_RESULT_VARREF='./'
return_success
elif test "${mbfl_PATHNAME:0:${#mbfl_BASEDIR}}" = "$mbfl_BASEDIR"
then
printf -v mbfl_RESULT_VARREF './%s' "${mbfl_PATHNAME:$((${#mbfl_BASEDIR}+1))}"
return_success
else return_because_failure
fi
}
function mbfl_file_subpathname () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local  BASEDIR=${2:?"missing base directory parameter to '$FUNCNAME'"}
local RESULT_VARNAME
if mbfl_file_subpathname_var RESULT_VARNAME "$PATHNAME" "$BASEDIR"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_is_absolute () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
test "${PATHNAME:0:1}" = '/'
}
function mbfl_file_is_absolute_dirname () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_file_is_directory "$PATHNAME" && mbfl_file_is_absolute "$PATHNAME"
}
function mbfl_file_is_absolute_filename () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_file_is_file "$PATHNAME" && mbfl_file_is_absolute "$PATHNAME"
}
function mbfl_file_is_relative () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
test "${PATHNAME:0:1}" != '/'
}
function mbfl_file_is_relative_dirname () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_file_is_directory "$PATHNAME" && mbfl_file_is_relative "$PATHNAME"
}
function mbfl_file_is_relative_filename () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_file_is_file "$PATHNAME" && mbfl_file_is_relative "$PATHNAME"
}
function mbfl_file_find_tmpdir_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_TMPDIR="${2:-"$mbfl_option_mbfl_TMPDIR"}"
if mbfl_file_directory_is_writable "$mbfl_TMPDIR"
then
mbfl_RESULT_VARREF=$mbfl_TMPDIR
return_success
elif mbfl_string_is_not_empty "$USER"
then
mbfl_TMPDIR=/tmp/${USER}
if mbfl_file_directory_is_writable "$mbfl_TMPDIR"
then
mbfl_RESULT_VARREF=$mbfl_TMPDIR
return_success
else return_because_failure
fi
else
mbfl_TMPDIR=/tmp
if mbfl_file_directory_is_writable "$mbfl_TMPDIR"
then
mbfl_RESULT_VARREF=$mbfl_TMPDIR
return_success
else
mbfl_message_error 'cannot find usable value for "mbfl_TMPDIR"'
return_because_failure
fi
fi
}
function mbfl_file_find_tmpdir () {
local  TMPDIR="${1:-"$mbfl_option_TMPDIR"}"
local RESULT_VARNAME
if mbfl_file_find_tmpdir_var RESULT_VARNAME "$TMPDIR"
then echo "$RESULT_VARNAME"
else return $?
fi
}
function mbfl_file_enable_remove () {
: mbfl_declare_program rm
: mbfl_declare_program rmdir
}
function mbfl_exec_rm () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_RM"
then
local FLAGS
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
mbfl_program_exec "$mbfl_PROGRAM_RM" $FLAGS "$@"
else
mbfl_message_error_printf 'program "rm" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_RM"
return_because_program_not_found
fi
}
function mbfl_file_remove () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local FLAGS='--force --recursive'
if ! mbfl_option_test
then
if ! mbfl_file_exists "$PATHNAME"
then
mbfl_message_error_printf 'pathname does not exist: "%s"' "$PATHNAME"
return_because_failure
fi
fi
mbfl_exec_rm $FLAGS -- "$PATHNAME"
}
function mbfl_file_remove_file () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local FLAGS='--force'
if ! mbfl_option_test
then
if ! mbfl_file_is_file "$PATHNAME"
then
mbfl_message_error_printf 'pathname is not a file: "%s"' "$PATHNAME"
return_because_failure
fi
fi
mbfl_exec_rm $FLAGS -- "$PATHNAME"
}
function mbfl_file_remove_symlink () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local FLAGS='--force'
if ! mbfl_option_test
then
if ! mbfl_file_is_symlink "$PATHNAME"
then
mbfl_message_error_printf 'pathname is not a symbolic link: "%s"' "$PATHNAME"
return_because_failure
fi
fi
mbfl_exec_rm $FLAGS -- "$PATHNAME"
}
function mbfl_file_remove_file_or_symlink () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local FLAGS='--force'
if ! mbfl_option_test
then
if      ! mbfl_file_is_file    "$PATHNAME" ||
! mbfl_file_is_symlink "$PATHNAME"
then
mbfl_message_error_printf 'pathname is neither a file nor a symbolic link: "%s"' "$PATHNAME"
return_because_failure
fi
fi
mbfl_exec_rm $FLAGS -- "$PATHNAME"
}
function mbfl_exec_rmdir () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_RMDIR"
then
local FLAGS
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
mbfl_program_exec "$mbfl_PROGRAM_RMDIR" $FLAGS "$@"
else
mbfl_message_error_printf 'program "rmdir" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_RMDIR"
return_because_program_not_found
fi
}
function mbfl_file_remove_directory () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local  REMOVE_SILENTLY="${2:-no}"
if mbfl_file_is_directory "$PATHNAME"
then
local FLAGS
if mbfl_string_equal "$REMOVE_SILENTLY" 'yes'
then FLAGS+=' --ignore-fail-on-non-empty'
fi
mbfl_exec_rmdir $FLAGS -- "$PATHNAME"
else
mbfl_message_error "pathname is not a directory '${PATHNAME}'"
return_because_failure
fi
}
function mbfl_file_remove_directory_silently () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_file_remove_directory "$PATHNAME" yes
}
function mbfl_file_enable_copy () {
: mbfl_declare_program cp
}
function mbfl_exec_cp () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_CP"
then
local FLAGS
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
mbfl_program_exec "$mbfl_PROGRAM_CP" $FLAGS "$@"
else
mbfl_message_error_printf 'program "cp" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_CP"
return_because_program_not_found
fi
}
function mbfl_exec_cp_to_dir () {
local  SOURCE=${1:?"missing source pathname parameter to '$FUNCNAME'"}
local  TARGET_DIRECTORY=${2:?"missing target directory pathname parameter to '$FUNCNAME'"}
shift 2
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_CP"
then
local FLAGS
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
mbfl_program_exec "$mbfl_PROGRAM_CP" $FLAGS "$@" --target-directory="${TARGET_DIRECTORY}/" -- "$SOURCE"
else
mbfl_message_error_printf 'program "cp" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_CP"
return_because_program_not_found
fi
}
function mbfl_file_copy () {
local  SOURCE=${1:?"missing source pathname parameter to '$FUNCNAME'"}
local  TARGET=${2:?"missing target pathname parameter to '$FUNCNAME'"}
shift 2
if ! mbfl_option_test
then
if ! mbfl_file_is_readable "$SOURCE"
then
mbfl_message_error_printf 'copying file "%s"' "$SOURCE"
return_because_failure
fi
fi
if mbfl_file_exists "$TARGET"
then
if mbfl_file_is_directory "$TARGET"
then mbfl_message_error_printf 'target of copy exists and it is a directory "%s"' "$TARGET"
else mbfl_message_error_printf 'target file of copy already exists "%s"' "$TARGET"
fi
return_because_failure
else mbfl_exec_cp "$@" -- "$SOURCE" "$TARGET"
fi
}
function mbfl_file_copy_to_directory () {
local  SOURCE=${1:?"missing source pathname parameter to '$FUNCNAME'"}
local  TARGET_DIRECTORY=${2:?"missing target directory pathname parameter to '$FUNCNAME'"}
shift 2
if ! mbfl_option_test
then
if      ! mbfl_file_is_readable  "$SOURCE"           print_error || \
! mbfl_file_exists       "$TARGET_DIRECTORY" print_error || \
! mbfl_file_is_directory "$TARGET_DIRECTORY" print_error
then
mbfl_message_error_printf 'copying file "%s"' "$SOURCE"
return_because_failure
fi
fi
mbfl_exec_cp "$@" --target-directory="${TARGET_DIRECTORY}/" -- "$SOURCE"
}
function mbfl_file_enable_move () {
: mbfl_declare_program mv
}
function mbfl_exec_mv () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_MV"
then
local FLAGS
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
mbfl_program_exec "$mbfl_PROGRAM_MV" $FLAGS "$@"
else
mbfl_message_error_printf 'program "mv" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_MV"
return_because_program_not_found
fi
}
function mbfl_file_move () {
local  SOURCE=${1:?"missing source pathname parameter to '$FUNCNAME'"}
local  TARGET=${2:?"missing target pathname parameter to '$FUNCNAME'"}
shift 2
if ! mbfl_option_test
then
if ! mbfl_file_pathname_is_readable "$SOURCE" print_error
then
mbfl_message_error_printf 'moving "%s"' "$SOURCE"
return_because_failure
fi
fi
mbfl_exec_mv "$@" -- "$SOURCE" "$TARGET"
}
function mbfl_file_move_to_directory () {
local  SOURCE=${1:?"missing source pathname parameter to '$FUNCNAME'"}
local  TARGET_DIRECTORY=${2:?"missing target directory pathname parameter to '$FUNCNAME'"}
shift 2
if ! mbfl_option_test
then
if      ! mbfl_file_pathname_is_readable "$SOURCE"           print_error || \
! mbfl_file_exists               "$TARGET_DIRECTORY" print_error || \
! mbfl_file_is_directory         "$TARGET_DIRECTORY" print_error
then
mbfl_message_error_printf 'moving file "%s"' "$SOURCE"
return_because_failure
fi
fi
mbfl_exec_mv "$@" --target-directory="${TARGET_DIRECTORY}/" -- "$SOURCE"
}
function mbfl_file_enable_make_directory () {
: mbfl_declare_program mkdir
}
function mbfl_exec_mkdir () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_MKDIR"
then
local FLAGS
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
mbfl_program_exec "$mbfl_PROGRAM_MKDIR" $FLAGS "$@"
else
mbfl_message_error_printf 'program "mkdir" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_MKDIR"
return_because_program_not_found
fi
}
function mbfl_file_make_directory () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local  PERMISSIONS="${2:-}"
if mbfl_string_is_empty "$PERMISSIONS"
then
shift
PERMISSIONS=0775
else shift 2
fi
local FLAGS="--parents --mode=${PERMISSIONS}"
mbfl_exec_mkdir $FLAGS "$@" -- "$PATHNAME"
}
function mbfl_file_make_if_not_directory () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
local  PERMISSIONS="${2:-}"
if mbfl_string_is_empty "$PERMISSIONS"
then
shift
PERMISSIONS=0775
else shift 2
fi
if mbfl_file_is_directory "$PATHNAME"
then mbfl_program_reset_sudo_user
else mbfl_file_make_directory "$PATHNAME" "$PERMISSIONS" "$@"
fi
}
function mbfl_file_enable_symlink () {
: mbfl_declare_program ln
}
function mbfl_exec_ln () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_LN"
then
local FLAGS
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
mbfl_program_exec "$mbfl_PROGRAM_LN" $FLAGS "$@"
else
mbfl_message_error_printf 'program "ln" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_LN"
return_because_program_not_found
fi
}
function mbfl_file_link () {
local  ORIGINAL_NAME=${1:?"missing original name parameter to '$FUNCNAME'"}
local  LINK_NAME=${2:?"missing link name parameter to '$FUNCNAME'"}
shift 2
mbfl_exec_ln "$@" -- "$ORIGINAL_NAME" "$LINK_NAME"
}
function mbfl_file_symlink () {
local  ORIGINAL_NAME=${1:?"missing original name parameter to '$FUNCNAME'"}
local  SYMLINK_NAME=${2:?"missing symbolic link name parameter to '$FUNCNAME'"}
shift 2
mbfl_exec_ln --symbolic "$@" -- "$ORIGINAL_NAME" "$SYMLINK_NAME"
}
function mbfl_file_enable_listing () {
: mbfl_declare_program ls
: mbfl_declare_program readlink
}
function mbfl_exec_ls () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_LS"
then mbfl_program_exec "$mbfl_PROGRAM_LS" "$@"
else
mbfl_message_error_printf 'program not "ls" executable, tested pathname is: "%s"' "$mbfl_PROGRAM_LS"
return_because_program_not_found
fi
}
function mbfl_file_listing () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
shift
mbfl_exec_ls "$@" -- "$PATHNAME"
}
function mbfl_file_long_listing () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
shift
mbfl_file_listing "$PATHNAME" '-l' "$@"
}
function mbfl_exec_readlink () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_READLINK"
then
local FLAGS
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
mbfl_program_exec "$mbfl_PROGRAM_READLINK" $FLAGS "$@"
else
mbfl_message_error_printf 'program not "readlink" executable, tested pathname is: "%s"' "$mbfl_PROGRAM_READLINK"
return_because_program_not_found
fi
}
function mbfl_file_read_link () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
shift
mbfl_exec_readlink "$@" -- "$PATHNAME"
}
function mbfl_file_readlink () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
shift
mbfl_exec_readlink "$@" -- "$PATHNAME"
}
function mbfl_file_normalise_link () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_exec_readlink --canonicalize --no-newline -- "$PATHNAME"
}
function mbfl_file_pathname_p_is () {
local  PRINT_ERROR=${1:?"missing print error argument parameter to '$FUNCNAME'"}
local  TEST_FLAG=${2:?"missing test flag parameter to '$FUNCNAME'"}
local  DESCRIPTION=${3:?"missing test condition description parameter to '$FUNCNAME'"}
local  PATHNAME="${4:-}"
if mbfl_string_is_not_empty "$PATHNAME"
then
if test $TEST_FLAG "$PATHNAME"
then return_success
else
if mbfl_string_equal 'print_error' "$PRINT_ERROR"
then mbfl_message_error_printf 'the pathname is not %s: "%s"' "$DESCRIPTION" "$PATHNAME"
fi
return_failure
fi
else
if mbfl_string_equal 'print_error' "$PRINT_ERROR"
then mbfl_message_error_printf 'invalid empty pathname argument'
fi
return_failure
fi
}
function mbfl_file_exists () {
local  PATHNAME="${1:-}"
test -n "$PATHNAME" -a -e "$PATHNAME"
}
function mbfl_file_pathname_is_readable () {
local  PATHNAME="${1:-}"
local  PRINT_ERROR="${2:-no}"
mbfl_file_pathname_p_is "$PRINT_ERROR" '-r' 'readable' "$PATHNAME"
}
function mbfl_file_pathname_is_writable () {
local  PATHNAME="${1:-}"
local  PRINT_ERROR="${2:-no}"
mbfl_file_pathname_p_is "$PRINT_ERROR" '-w' 'writable' "$PATHNAME"
}
function mbfl_file_pathname_is_executable () {
local  PATHNAME="${1:-}"
local  PRINT_ERROR="${2:-no}"
mbfl_file_pathname_p_is "$PRINT_ERROR" '-x' 'executable' "$PATHNAME"
}
function mbfl_file_is_file () {
local  PATHNAME="${1:-}"
local  PRINT_ERROR="${2:-no}"
mbfl_file_pathname_p_is "$PRINT_ERROR" '-f' 'a file' "$PATHNAME"
}
function mbfl_file_is_readable () {
local  PATHNAME="${1:-}"
local  PRINT_ERROR="${2:-no}"
mbfl_file_is_file "$PATHNAME" "$PRINT_ERROR" && \
mbfl_file_pathname_is_readable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_is_writable () {
local  PATHNAME="${1:-}"
local  PRINT_ERROR="${2:-no}"
mbfl_file_is_file "$PATHNAME" "$PRINT_ERROR" && \
mbfl_file_pathname_is_writable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_is_executable () {
local  PATHNAME="${1:-}"
local  PRINT_ERROR="${2:-no}"
mbfl_file_is_file "$PATHNAME" "$PRINT_ERROR" && \
mbfl_file_pathname_is_executable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_file_is_directory () {
local  PATHNAME="${1:-}"
local  PRINT_ERROR="${2:-no}"
mbfl_file_pathname_p_is "$PRINT_ERROR" '-d' 'a directory' "$PATHNAME"
}
function mbfl_directory_is_readable () { mbfl_file_directory_is_readable "$@"; }
function mbfl_file_directory_is_readable () {
local  PATHNAME="${1:-}"
local  PRINT_ERROR="${2:-no}"
mbfl_file_is_directory "$PATHNAME" "$PRINT_ERROR" && \
mbfl_file_pathname_is_readable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_directory_is_writable () { mbfl_file_directory_is_writable "$@"; }
function mbfl_file_directory_is_writable () {
local  PATHNAME="${1:-}"
local  PRINT_ERROR="${2:-no}"
mbfl_file_is_directory "$PATHNAME" "$PRINT_ERROR" && \
mbfl_file_pathname_is_writable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_directory_is_executable () { mbfl_file_directory_is_executable "$@"; }
function mbfl_file_directory_is_executable () {
local  PATHNAME="${1:-}"
local  PRINT_ERROR="${2:-no}"
mbfl_file_is_directory "$PATHNAME" "$PRINT_ERROR" && \
mbfl_file_pathname_is_executable "$PATHNAME" "$PRINT_ERROR"
}
function mbfl_directory_validate_writability () { mbfl_file_directory_validate_writability "$@"; }
function mbfl_file_directory_validate_writability () {
local  DIRECTORY=${1:?"missing directory pathname parameter to '$FUNCNAME'"}
local  DESCRIPTION=${2:?"missing directory description parameter to '$FUNCNAME'"}
mbfl_message_verbose "validating ${DESCRIPTION} directory '${DIRECTORY}'\n"
mbfl_file_is_directory "$DIRECTORY" print_error && mbfl_file_directory_is_writable "$DIRECTORY" print_error
local -i CODE=$?
if ((0 != CODE))
then mbfl_message_error_printf 'unwritable %s directory: "%s"' "$DESCRIPTION" "$DIRECTORY"
fi
return $CODE
}
function mbfl_file_is_symlink () {
local  PATHNAME="${1:-}"
local  PRINT_ERROR="${2:-no}"
mbfl_file_pathname_p_is "$PRINT_ERROR" '-L' 'readable' "$PATHNAME"
}
function mbfl_file_enable_permissions () {
mbfl_file_enable_stat
: mbfl_declare_program chmod
}
function mbfl_exec_chmod () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_CHMOD"
then
local FLAGS
if mbfl_option_verbose_program
then FLAGS+=' --changes'
fi
mbfl_program_exec "$mbfl_PROGRAM_CHMOD" $FLAGS "$@"
else
mbfl_message_error_printf 'program not "chmod" executable, tested pathname is: "%s"' "$mbfl_PROGRAM_CHMOD"
return_because_program_not_found
fi
}
function mbfl_file_chmod () {
local  PERMISSIONS=${1:?"missing permissions parameter to '$FUNCNAME'"}
local  PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
shift 2
mbfl_exec_chmod "$PERMISSIONS" "$@" -- "$PATHNAME"
}
function mbfl_file_get_permissions () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_file_stat "$PATHNAME" --printf='0%a\n'
}
function mbfl_file_set_permissions () {
local  PERMISSIONS=${1:?"missing permissions parameter to '$FUNCNAME'"}
local  PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_file_chmod "$PERMISSIONS" "$PATHNAME"
}
function mbfl_file_get_permissions_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" --format='0%a')
}
declare -a mbfl_SYMBOLIC_PERMISSIONS
mbfl_SYMBOLIC_PERMISSIONS[0]='---'
mbfl_SYMBOLIC_PERMISSIONS[1]='--x'
mbfl_SYMBOLIC_PERMISSIONS[2]='-w-'
mbfl_SYMBOLIC_PERMISSIONS[3]='-wx'
mbfl_SYMBOLIC_PERMISSIONS[4]='r--'
mbfl_SYMBOLIC_PERMISSIONS[5]='r-x'
mbfl_SYMBOLIC_PERMISSIONS[6]='rw-'
mbfl_SYMBOLIC_PERMISSIONS[7]='rwx'
function mbfl_file_symbolic_to_octal_permissions () {
local  MODE=${1:?"missing symbolic permissions parameter to '$FUNCNAME'"}
local -i i
for ((i=0; i < ${#mbfl_SYMBOLIC_PERMISSIONS[@]}; ++i))
do
if mbfl_string_equal ${mbfl_SYMBOLIC_PERMISSIONS[$i]} "$MODE"
then
printf "%s\n" $i
return_success
fi
done
return_failure
}
function mbfl_file_octal_to_symbolic_permissions () {
local  MODE=${1:?"missing symbolic permissions parameter to '$FUNCNAME'"}
printf '%s\n' ${mbfl_SYMBOLIC_PERMISSIONS[$MODE]}
}
function mbfl_system_symbolic_to_octal_permissions () {
mbfl_file_symbolic_to_octal_permissions "$@"
}
function mbfl_system_octal_to_symbolic_permissions () {
mbfl_file_octal_to_symbolic_permissions "$@"
}
function mbfl_file_enable_owner_and_group () {
mbfl_file_enable_stat
: mbfl_declare_program chown
: mbfl_declare_program chgrp
}
function mbfl_exec_chown () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_CHOWN"
then
local FLAGS
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
mbfl_program_exec "$mbfl_PROGRAM_CHOWN" $FLAGS "$@"
else
mbfl_message_error_printf 'program not "chown" executable, tested pathname is: "%s"' "$mbfl_PROGRAM_CHOWN"
return_because_program_not_found
fi
}
function mbfl_exec_chgrp () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_CHGRP"
then
local FLAGS
if mbfl_option_verbose_program
then FLAGS+=' --verbose'
fi
mbfl_program_exec "$mbfl_PROGRAM_CHGRP" $FLAGS "$@"
else
mbfl_message_error_printf 'program not "chgrp" executable, tested pathname is: "%s"' "$mbfl_PROGRAM_CHGRP"
return_because_program_not_found
fi
}
function mbfl_file_set_owner () {
local  OWNER=${1:?"missing owner parameter to '$FUNCNAME'"}
local  PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
shift 2
mbfl_exec_chown "$@" "$OWNER" -- "$PATHNAME"
}
function mbfl_file_set_group () {
local  GROUP=${1:?"missing group parameter to '$FUNCNAME'"}
local  PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
shift 2
mbfl_exec_chgrp "$@" "$GROUP" -- "$PATHNAME"
}
function mbfl_file_append () {
local  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
local  FILENAME=${2:?"missing file name parameter to '$FUNCNAME'"}
mbfl_program_bash_command "printf '%s' '${STRING}' >>'${FILENAME}'"
}
function mbfl_file_write () {
local  STRING=${1:?"missing string parameter to '$FUNCNAME'"}
local  FILENAME=${2:?"missing file name parameter to '$FUNCNAME'"}
mbfl_program_bash_command "printf '%s' '${STRING}' >'${FILENAME}'"
}
function mbfl_file_read () {
local  FILENAME=${1:?"missing file name parameter to '$FUNCNAME'"}
mbfl_program_bash_command "printf '%s' \"\$(<${FILENAME})\""
}
function mbfl_file_enable_stat () {
: mbfl_declare_program stat
}
function mbfl_exec_stat () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_STAT"
then mbfl_program_exec "$mbfl_PROGRAM_STAT" "$@"
else
mbfl_message_error_printf 'program not "stat" executable, tested pathname is: "%s"' "$mbfl_PROGRAM_STAT"
return_because_program_not_found
fi
}
function mbfl_file_stat () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
shift
mbfl_exec_stat "$@" -- "$PATHNAME"
}
function mbfl_file_stat_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
shift 2
mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" "$@")
}
function mbfl_file_get_owner () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_file_stat "$PATHNAME" --format='%U'
}
function mbfl_file_get_group () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_file_stat "$PATHNAME" --format='%G'
}
function mbfl_file_get_size () {
local  PATHNAME=${1:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_file_stat "$PATHNAME" --format='%s'
}
function mbfl_file_get_owner_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" --printf='%U')
}
function mbfl_file_get_group_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" --printf='%G')
}
function mbfl_file_get_size_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PATHNAME=${2:?"missing pathname parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=$(mbfl_file_stat "$mbfl_PATHNAME" --printf='%s')
}
if { test "$mbfl_INTERACTIVE"  '!=' 'yes'; }
then
declare -A mbfl_action_sets_EXISTS
declare -A mbfl_action_sets_SUBSETS
declare -A mbfl_action_sets_KEYWORDS
declare -A mbfl_action_sets_DESCRIPTIONS
declare -A mbfl_action_sets_IDENTIFIERS
declare mbfl_action_sets_SELECTED_SET=NONE
fi
function mbfl_declare_action_set () {
local  ACTION_SET=${1:?"missing action set parameter to '$FUNCNAME'"}
if mbfl_string_is_name "$ACTION_SET"
then
if mbfl_string_is_empty "${mbfl_action_sets_EXISTS[${ACTION_SET}]}"
then mbfl_action_sets_EXISTS[${ACTION_SET}]=true
else
mbfl_message_error_printf 'action set declared twice: "%s"' "$ACTION_SET"
exit_because_invalid_action_declaration
fi
else
mbfl_message_error_printf 'invalid action set identifier: "%s"' "$ACTION_SET"
exit_because_invalid_action_declaration
fi
}
function mbfl_declare_action () {
local -r ACTION_SET=${1:?"missing action set parameter to '$FUNCNAME'"}
local -r ACTION_KEYWORD=${2:?"missing keyword parameter to '$FUNCNAME'"}
local -r ACTION_SUBSET=${3:?"missing subset parameter to '$FUNCNAME'"}
local -r ACTION_IDENTIFIER=${4:?"missing identifier parameter to '$FUNCNAME'"}
local -r ACTION_DESCRIPTION=${5:?"missing description parameter to '$FUNCNAME'"}
local -r KEY=${ACTION_SET}-${ACTION_IDENTIFIER}
if ! mbfl_string_is_identifier "$ACTION_IDENTIFIER"
then
mbfl_message_error_printf 'internal error: invalid action identifier: "%s"' "$ACTION_IDENTIFIER"
exit_because_invalid_action_declaration
fi
if mbfl_string_is_name "$ACTION_KEYWORD"
then mbfl_action_sets_KEYWORDS[${KEY}]=${ACTION_KEYWORD}
else
mbfl_message_error_printf \
'internal error: invalid keyword for action "%s": "%s"' \
"$ACTION_IDENTIFIER" "$ACTION_KEYWORD"
exit_because_invalid_action_declaration
fi
if mbfl_actions_set_exists_or_none "$ACTION_SUBSET"
then mbfl_action_sets_SUBSETS[${KEY}]=${ACTION_SUBSET}
else
mbfl_message_error_printf \
'internal error: invalid or non-existent action subset identifier for action "%s": "%s"' \
"$ACTION_IDENTIFIER" "$ACTION_SUBSET"
exit_because_invalid_action_declaration
fi
mbfl_action_sets_DESCRIPTIONS[${KEY}]="$ACTION_DESCRIPTION"
mbfl_action_sets_IDENTIFIERS[${ACTION_SET}]+=" $ACTION_IDENTIFIER"
return_success
}
function mbfl_actions_set_exists () {
local  ACTION_SET=${1:?"missing action set parameter to '$FUNCNAME'"}
mbfl_string_is_name "$ACTION_SET" && ${mbfl_action_sets_EXISTS[${ACTION_SET}]:-false}
}
function mbfl_actions_set_exists_or_none () {
local  ACTION_SET=${1:?"missing action set parameter to '$FUNCNAME'"}
mbfl_actions_set_exists "$ACTION_SET" || { test NONE  '=' "$ACTION_SET"; }
}
function mbfl_actions_dispatch () {
local  ACTION_SET=${1:?"missing action set parameter to '$FUNCNAME'"}
if ! mbfl_actions_set_exists "$ACTION_SET"
then
mbfl_message_error_printf 'invalid action identifier: "%s"' "$ACTION_SET"
return_failure
fi
if (( ARG1ST == ARGC1 ))
then return_success
fi
local -r IDENTIFIER=${ARGV1[$ARG1ST]}
local -r KEY=${ACTION_SET}-${IDENTIFIER}
local -r ACTION_SUBSET=${mbfl_action_sets_SUBSETS[${KEY}]}
local -r ACTION_KEYWORD=${mbfl_action_sets_KEYWORDS[${KEY}]}
if mbfl_string_is_empty "$ACTION_KEYWORD"
then
return_success
else
let ++ARG1ST
mbfl_main_set_before_parsing_options script_before_parsing_options_${ACTION_KEYWORD}
mbfl_main_set_after_parsing_options  script_after_parsing_options_${ACTION_KEYWORD}
mbfl_main_set_main script_action_${ACTION_KEYWORD}
mbfl_action_sets_SELECTED_SET=$ACTION_SUBSET
if mbfl_string_not_equal 'NONE' "$ACTION_SUBSET"
then
mbfl_actions_dispatch "$ACTION_SUBSET"
else
return_success
fi
fi
}
function mbfl_actions_fake_action_set () {
local  ACTION_SET=${1:?"missing action set parameter to '$FUNCNAME'"}
if mbfl_actions_set_exists "$ACTION_SET"
then
mbfl_action_sets_SELECTED_SET=$ACTION_SET
return_success
else return_failure
fi
}
function mbfl_actions_print_usage_screen () {
local ACTION_SET=$mbfl_action_sets_SELECTED_SET
if { mbfl_string_is_not_empty "$ACTION_SET" && mbfl_string_not_equal 'NONE' "$ACTION_SET"; }
then
printf 'Action commands:\n\n'
local ACTION_IDENTIFIER KEY
for ACTION_IDENTIFIER in ${mbfl_action_sets_IDENTIFIERS[${ACTION_SET}]}
do
KEY=${ACTION_SET}-${ACTION_IDENTIFIER}
printf '\t%s [options] [arguments]\n\t\t%s\n\n' \
"$ACTION_IDENTIFIER" "${mbfl_action_sets_DESCRIPTIONS[${KEY}]}"
done
fi
return_success
}
function mbfl_actions_completion_print_script () {
local  NAMESPACE=${1:?"missing namespace for the names of completion functions parameter to '$FUNCNAME'"}
local  PROGNAME=${2:?"missing name of the command for which the completion script is built parameter to '$FUNCNAME'"}
local  SCRIPTTYPE="${3:-main}"
local FUNCNAME_ENTRY_POINT
local FUNCNAME_COMPGEN
local FUNCNAME_DISPATCH
printf -v FUNCNAME_ENTRY_POINT '%s-completion-%s'          "$NAMESPACE" "$PROGNAME"
printf -v FUNCNAME_DISPATCH    '%s-dispatch-completion-%s' "$NAMESPACE" "$PROGNAME"
printf -v FUNCNAME_COMPGEN     '%s-compgen-%s'             "$NAMESPACE" "$PROGNAME"
case "$SCRIPTTYPE" in
'main')
mbfl_actions_completion_fake_cat <<END
complete -F $FUNCNAME_ENTRY_POINT -o default "$PROGNAME"
function $FUNCNAME_ENTRY_POINT () {
local -r word_to_be_completed=\${COMP_WORDS[\${COMP_CWORD}]}
$FUNCNAME_DISPATCH 0
}
function $FUNCNAME_COMPGEN () {
local -r candidate_completions=\${1:?"\${FUNCNAME}: missing candidate completions argument"}
COMPREPLY=(\`compgen -W "\$candidate_completions" -- "\$word_to_be_completed"\`)
}
END
;;
'subscript')
mbfl_actions_completion_fake_cat <<END
function $FUNCNAME_COMPGEN () {
local -r candidate_completions=\${1:?"\${FUNCNAME}: missing candidate completions argument"}
COMPREPLY=(\`compgen -W "\$candidate_completions" -- "\$word_to_be_completed"\`)
}
END
;;
*)
mbfl_message_error_printf 'invalid script type to function %s: %s' "$FUNCNAME" "$SCRIPTTYPE"
return_failure
;;
esac
local   -A ITERATOR
ITERATOR[ACTION_SET]='MAIN'
ITERATOR[COMMANDS_LIST]="$PROGNAME"
ITERATOR[FUNCTIONS_SUFFIX]="$PROGNAME"
mbfl_p_actions_completion_visit_node
exit_success
}
function mbfl_p_actions_completion_visit_node () {
local ACTION_IDENTIFIER KEY
local   -A TMP
mbfl_actions_completion_print_dispatcher
KEY=${ITERATOR[ACTION_SET]}
for ACTION_IDENTIFIER in ${mbfl_action_sets_IDENTIFIERS[$KEY]}
do
TMP[ACTION_SET]=${ITERATOR[ACTION_SET]}
TMP[COMMANDS_LIST]=${ITERATOR[COMMANDS_LIST]}
TMP[FUNCTIONS_SUFFIX]=${ITERATOR[FUNCTIONS_SUFFIX]}
printf -v KEY '%s-%s' ${ITERATOR[ACTION_SET]} $ACTION_IDENTIFIER
ITERATOR[ACTION_SET]=${mbfl_action_sets_SUBSETS[$KEY]}
printf -v ITERATOR[COMMANDS_LIST]    '%s %s' "${ITERATOR[COMMANDS_LIST]}"    $ACTION_IDENTIFIER
printf -v ITERATOR[FUNCTIONS_SUFFIX] '%s-%s' "${ITERATOR[FUNCTIONS_SUFFIX]}" $ACTION_IDENTIFIER
if mbfl_string_equal 'NONE' "${ITERATOR[ACTION_SET]}"
then mbfl_p_actions_completion_print_leaf
else mbfl_p_actions_completion_visit_node
fi
ITERATOR[ACTION_SET]=${TMP[ACTION_SET]}
ITERATOR[COMMANDS_LIST]=${TMP[COMMANDS_LIST]}
ITERATOR[FUNCTIONS_SUFFIX]=${TMP[FUNCTIONS_SUFFIX]}
done
}
function mbfl_p_actions_completion_print_leaf () {
local FUNCNAME_DISPATCH
printf -v FUNCNAME_DISPATCH '%s-dispatch-completion-%s' "$NAMESPACE" "${ITERATOR[FUNCTIONS_SUFFIX]}"
mbfl_actions_completion_fake_cat <<EOF
function $FUNCNAME_DISPATCH () {
local -ir index_of_command=\${1:?"\${FUNCNAME}: missing argument: index of command"}
local -ir index_of_next_arg=\$((1 + index_of_command))
:
}
EOF
}
function mbfl_actions_completion_print_dispatcher () {
local FUNCNAME_DISPATCH
local ACTION_SET=${ITERATOR[ACTION_SET]}
local ACTION_IDENTIFIER
printf -v FUNCNAME_DISPATCH '%s-dispatch-completion-%s' "$NAMESPACE" "${ITERATOR[FUNCTIONS_SUFFIX]}"
mbfl_actions_completion_fake_cat <<EOF
function $FUNCNAME_DISPATCH () {
local -ir index_of_command=\${1:?"\${FUNCNAME}: missing argument: index of command"}
local -ir index_of_subcommand=\$((1 + index_of_command))
if (( index_of_subcommand == COMP_CWORD))
then
$FUNCNAME_COMPGEN '${mbfl_action_sets_IDENTIFIERS[$ACTION_SET]}'
elif (( index_of_subcommand < COMP_CWORD))
then
case "\${COMP_WORDS[\$index_of_subcommand]}" in
EOF
for ACTION_IDENTIFIER in ${mbfl_action_sets_IDENTIFIERS[${ACTION_SET}]}
do
mbfl_actions_completion_fake_cat <<EOF
'$ACTION_IDENTIFIER')
$NAMESPACE-dispatch-completion-${ITERATOR[FUNCTIONS_SUFFIX]}-${ACTION_IDENTIFIER} \$index_of_subcommand
;;
EOF
done
mbfl_actions_completion_fake_cat <<EOF
esac
else
printf 'error: command-line completion function invoked incorrectly: %s\\\\n' "\$FUNCNAME" >&2
return 1
fi
}
EOF
}
function mbfl_actions_completion_fake_cat () {
while read
do echo "$REPLY"
done
}
if { test "$mbfl_INTERACTIVE"  '!=' 'yes'; }
then
declare -i mbfl_getopts_INDEX=0
declare -a mbfl_getopts_KEYWORDS
declare -a mbfl_getopts_DEFAULTS
declare -a mbfl_getopts_BRIEFS
declare -a mbfl_getopts_LONGS
declare -a mbfl_getopts_HASARG
declare -a mbfl_getopts_DESCRIPTION
fi
function mbfl_getopts_reset () {
unset mbfl_getopts_KEYWORDS
unset mbfl_getopts_DEFAULTS
unset mbfl_getopts_BRIEFS
unset mbfl_getopts_LONGS
unset mbfl_getopts_HASARG
unset mbfl_getopts_DESCRIPTION
mbfl_getopts_INDEX=0
declare -a mbfl_getopts_KEYWORDS
declare -a mbfl_getopts_DEFAULTS
declare -a mbfl_getopts_BRIEFS
declare -a mbfl_getopts_LONGS
declare -a mbfl_getopts_HASARG
declare -a mbfl_getopts_DESCRIPTION
}
if { test "$mbfl_INTERACTIVE"  '!=' 'yes'; }
then mbfl_message_DEFAULT_OPTIONS="
\t--tmpdir=DIR
\t\tselect a directory for temporary files
\t-i --interactive
\t\task before doing dangerous operations
\t-f --force
\t\tdo not ask before dangerous operations
\t--encoded-args
\t\tdecode arguments following this option
\t\tfrom the hex format (example: 414243 -> ABC)
\t-v --verbose
\t\tverbose execution
\t--silent
\t\tsilent execution
\t--verbose-program
\t\tverbose execution for external program (if supported)
\t--show-program
\t--show-programs
\t\tprint the command line of executed external programs
\t--null
\t\tuse the null character as terminator
\t--debug
\t\tprint debug messages
\t--test
\t\ttests execution
\t--validate-programs
\t\tchecks the existence of all the required external programs
\t--list-exit-codes
\t\tprints a list of exit codes and names
\t--print-exit-code=NAME
\t\tprints the exit code associated to a name
\t--print-exit-code-names=CODE
\t\tprints the names associated to an exit code
\t--version
\t\tprint version informations and exit
\t--version-only
\t\tprint version number and exit
\t--license
\t\tprint license informations and exit
\t--print-options
\t\tprint a list of long option switches
\t-h --help --usage
\t\tprint usage informations and exit
\t-H --brief-help --brief-usage
\t\tprint usage informations and the list of script specific
\t\toptions, then exit
"
fi
function mbfl_declare_option () {
local  keyword=${1:?"missing option declaration keyword parameter to '$FUNCNAME'"}
local default=$2
local brief=$3
local long=$4
local  hasarg=${5:?"missing option declaration hasarg selection parameter to '$FUNCNAME'"}
local  description=${6:?"missing option declaration decription parameter to '$FUNCNAME'"}
local tolower_keyword toupper_keyword
local -ri index=$((1 + mbfl_getopts_INDEX))
mbfl_p_declare_option_test_length "$keyword" 'keyword' $index
mbfl_string_toupper_var toupper_keyword $keyword
mbfl_string_tolower_var tolower_keyword $keyword
mbfl_getopts_KEYWORDS[$mbfl_getopts_INDEX]=$toupper_keyword
mbfl_getopts_BRIEFS[$mbfl_getopts_INDEX]=$brief
mbfl_getopts_LONGS[$mbfl_getopts_INDEX]=$long
mbfl_p_declare_option_test_length "$hasarg" 'hasarg' $index
if { mbfl_string_not_equal "$hasarg" 'witharg' && mbfl_string_not_equal "$hasarg" 'noarg'; }
then
mbfl_message_error_printf 'wrong value "%s" to hasarg field in option declaration number %d' "$hasarg" $index
exit_because_invalid_option_declaration
fi
mbfl_getopts_HASARG[$mbfl_getopts_INDEX]=$hasarg
if { mbfl_string_equal "$hasarg" 'noarg' && \
mbfl_string_not_equal "$default" 'yes' && \
mbfl_string_not_equal "$default" 'no'; }
then
mbfl_message_error_printf 'wrong value "%s" as default for option with no argument number %d' "$default" $index
exit_because_invalid_option_declaration
fi
mbfl_getopts_DEFAULTS[$mbfl_getopts_INDEX]=$default
mbfl_p_declare_option_test_length "$description" 'description' $index
mbfl_getopts_DESCRIPTION[$mbfl_getopts_INDEX]=$description
mbfl_getopts_INDEX=$index
eval script_option_${toupper_keyword}=\'"$default"\'
if mbfl_string_equal ${keyword:0:7} 'ACTION_'
then
if mbfl_string_equal "$hasarg" 'noarg'
then
if mbfl_string_equal "$default" 'yes'
then mbfl_main_set_main script_${tolower_keyword}
fi
else
mbfl_message_error_printf 'action option must be with no argument "%s"' $keyword
return_failure
fi
fi
return_success
}
function mbfl_p_declare_option_test_length () {
local value=$1
local  value_name=${2:?"missing value name parameter to '$FUNCNAME'"}
local -i option_number=${3:?"missing ciao number parameter to '$FUNCNAME'"}
if mbfl_string_is_empty "$value"
then
mbfl_message_error_printf 'null "%s" in declared option number %d' "$value_name" $option_number
exit_because_invalid_option_declaration
fi
}
function mbfl_getopts_parse () {
local p_OPT= p_OPTARG= argument=
local -i i
for ((i=ARG1ST; i < ARGC1; ++i))
do
argument=${ARGV1[$i]}
if mbfl_string_equal "$argument" '--'
then
local -i j
for ((j=1+i; j < ARGC1; ++j))
do
ARGV[$ARGC]=${ARGV1[$j]}
let ++ARGC
done
break
elif mbfl_string_equal '--' "${argument:0:2}"
then
if mbfl_getopts_islong  "$argument" p_OPT
then
if ! mbfl_getopts_p_process_predefined_option_no_arg "$p_OPT"
then return_failure
fi
elif mbfl_getopts_islong_with "$argument" p_OPT p_OPTARG
then
if ! mbfl_getopts_p_process_predefined_option_with_arg "$p_OPT" "$p_OPTARG"
then return_failure
fi
else
mbfl_message_error_printf 'invalid command line argument: "%s"' "$argument"
return_failure
fi
elif mbfl_string_equal '-' "${argument:0:1}"
then
if mbfl_getopts_isbrief "$argument" p_OPT
then
if ! mbfl_getopts_p_process_predefined_option_no_arg "$p_OPT"
then return_failure
fi
elif mbfl_getopts_isbrief_with "$argument" p_OPT p_OPTARG
then
if ! mbfl_getopts_p_process_predefined_option_with_arg "$p_OPT" "$p_OPTARG"
then return_failure
fi
else
mbfl_message_error_printf 'invalid command line argument: "%s"' "$argument"
return_failure
fi
else
ARGV[$ARGC]=${argument}
let ++ARGC
fi
done
if mbfl_option_encoded_args
then
for ((i=0; i < ARGC; ++i))
do ARGV[$i]=$(mbfl_decode_hex "${ARGV[$i]}")
done
fi
return_success
}
function mbfl_getopts_p_process_script_option () {
local  OPT=${1:?"missing option name parameter to '$FUNCNAME'"}
local  OPTARG="${2:-}"
local i=0 value brief long hasarg keyword tolower_keyword update_procedure state_variable
for ((i=0; i < mbfl_getopts_INDEX; ++i))
do
keyword=${mbfl_getopts_KEYWORDS[$i]}
brief=${mbfl_getopts_BRIEFS[$i]}
long=${mbfl_getopts_LONGS[$i]}
hasarg=${mbfl_getopts_HASARG[$i]}
if test \( -n "$OPT" \) -a \
\( \( -n "$brief" -a "$brief" = "$OPT" \) -o \( -n "$long" -a "$long" = "$OPT" \) \)
then
if mbfl_string_equal "$hasarg" "witharg"
then
if mbfl_string_is_empty "$OPTARG"
then
mbfl_message_error "expected non-empty argument for option: \"$OPT\""
return_failure
fi
if mbfl_option_encoded_args
then value=$(mbfl_decode_hex "$OPTARG")
else value=$OPTARG
fi
else value=yes
fi
mbfl_string_tolower_var tolower_keyword ${keyword}
if mbfl_string_equal ${keyword:0:7} ACTION_
then mbfl_main_set_main script_${tolower_keyword}
fi
update_procedure=script_option_update_${tolower_keyword}
state_variable=script_option_${keyword}
eval ${state_variable}=\'"$value"\'
mbfl_invoke_script_function ${update_procedure}
return_success
fi
done
mbfl_message_error_printf 'unknown option "%s"' "$OPT"
return_failure
}
function mbfl_getopts_p_process_predefined_option_no_arg () {
local  OPT=${1:?"missing option name parameter to '$FUNCNAME'"}
local i=0
case $OPT in
encoded-args)
mbfl_set_option_encoded_args
;;
v|verbose)
mbfl_set_option_verbose
;;
silent)
mbfl_unset_option_verbose
;;
verbose-program)
mbfl_set_option_verbose_program
;;
show-program|show-programs)
mbfl_set_option_show_program
;;
debug)
mbfl_set_option_debug
mbfl_set_option_verbose
mbfl_set_option_show_program
;;
test)
mbfl_set_option_test
;;
null)
mbfl_set_option_null
;;
f|force)
mbfl_unset_option_interactive
;;
i|interactive)
mbfl_set_option_interactive
;;
validate-programs)
mbfl_main_set_private_main mbfl_program_main_validate_programs
;;
list-exit-codes)
mbfl_main_set_private_main mbfl_main_list_exit_codes
;;
version)
mbfl_main_set_private_main mbfl_main_print_version_number
;;
version-only)
mbfl_main_set_private_main mbfl_main_print_version_number_only
;;
license)
mbfl_main_set_private_main mbfl_main_print_license
;;
h|help|usage)
mbfl_main_set_private_main mbfl_main_print_usage_screen_long
;;
H|brief-help|brief-usage)
mbfl_main_set_private_main mbfl_main_print_usage_screen_brief
;;
print-options)
mbfl_main_set_private_main mbfl_getopts_print_long_switches
;;
*)
mbfl_getopts_p_process_script_option "$OPT"
return $?
;;
esac
return_success
}
function mbfl_getopts_p_process_predefined_option_with_arg () {
local  OPT=${1:?"missing option name parameter to '$FUNCNAME'"}
local  OPTARG=${2:?"missing option argument parameter to '$FUNCNAME'"}
if mbfl_string_is_empty "$OPTARG"
then
mbfl_message_error_printf 'empty value given to option "%s" requiring argument' "$OPT"
exit_because_invalid_option_argument
fi
if mbfl_option_encoded_args
then OPTARG=$(mbfl_decode_hex "$OPTARG")
fi
case $OPT in
tmpdir)
mbfl_option_TMPDIR=${OPTARG}
;;
print-exit-code)
mbfl_print_exit_code "$OPTARG"
exit_success
;;
print-exit-code-names|print-exit-code-name)
mbfl_print_exit_code_names "$OPTARG"
exit_success
;;
*)
mbfl_getopts_p_process_script_option "$OPT" "$OPTARG"
return $?
;;
esac
return_success
}
function mbfl_getopts_print_usage_screen () {
local  BRIEF_OR_LONG=${1:?"missing brief or long selection parameter to '$FUNCNAME'"}
local i=0 item brief long description long_hasarg long_hasarg default
printf 'Options:\n'
if ((0 == mbfl_getopts_INDEX))
then printf '\tNo script-specific options.\n'
else
for ((i=0; i < mbfl_getopts_INDEX; ++i))
do
if test "${mbfl_getopts_HASARG[$i]}" = 'witharg'
then
brief_hasarg='VALUE'
long_hasarg='=VALUE'
else
brief_hasarg=
long_hasarg=
fi
printf '\t'
brief=${mbfl_getopts_BRIEFS[$i]}
if test -n "$brief"
then printf -- '-%s%s ' "$brief" "$brief_hasarg"
fi
long=${mbfl_getopts_LONGS[$i]}
if test -n "$long"
then printf -- '--%s%s' "$long" "$long_hasarg"
fi
printf '\n'
description=${mbfl_getopts_DESCRIPTION[$i]}
if mbfl_string_is_empty "$description"
then description='undocumented option'
fi
printf '\t\t%b\n' "$description"
if test "${mbfl_getopts_HASARG[$i]}" = 'witharg'
then
item=${mbfl_getopts_DEFAULTS[$i]}
if mbfl_string_is_not_empty "$item"
then printf -v default "'%s'" "$item"
else default='empty'
fi
printf '\t\t(default: %s)\n' "$default"
else
if test ${mbfl_getopts_KEYWORDS[$i]:0:7} = ACTION_
then
if test "${mbfl_getopts_DEFAULTS[$i]}" = 'yes'
then printf '\t\t(default action)\n'
fi
fi
fi
done
fi
printf '\n'
if test $BRIEF_OR_LONG = long
then
printf 'Common options:\n'
printf "$mbfl_message_DEFAULT_OPTIONS"
printf '\n'
fi
}
function mbfl_getopts_islong () {
local  ARGUMENT=${1:?"missing argument parameter to '$FUNCNAME'"}
local  OPTION_VARIABLE_NAME="${2:-}"
local -r REX='^--([a-zA-Z0-9_\-]+)$'
if [[ $ARGUMENT =~ $REX ]]
then
mbfl_set_maybe "$OPTION_VARIABLE_NAME" "${BASH_REMATCH[1]}"
return_success
else return_failure
fi
}
function mbfl_getopts_islong_with () {
local  ARGUMENT=${1:?"missing argument parameter to '$FUNCNAME'"}
local  OPTION_VARIABLE_NAME="${2:-}"
local  VALUE_VARIABLE_NAME="${3:-}"
local -r REX='^--([a-zA-Z0-9_\-]+)=(.+)$'
if [[ $ARGUMENT =~ $REX ]]
then
mbfl_set_maybe "$OPTION_VARIABLE_NAME" "${BASH_REMATCH[1]}"
mbfl_set_maybe "$VALUE_VARIABLE_NAME"  "${BASH_REMATCH[2]}"
return_success
else return_failure
fi
}
function mbfl_getopts_isbrief () {
local  ARGUMENT=${1:?"missing argument parameter to '$FUNCNAME'"}
local  OPTION_VARIABLE_NAME="${2:-}"
local -r REX='^-([a-zA-Z0-9])$'
if [[ $ARGUMENT =~ $REX ]]
then
mbfl_set_maybe "$OPTION_VARIABLE_NAME" "${BASH_REMATCH[1]}"
return_success
else return_failure
fi
}
function mbfl_getopts_isbrief_with () {
local  ARGUMENT=${1:?"missing argument parameter to '$FUNCNAME'"}
local  OPTION_VARIABLE_NAME="${2:-}"
local  VALUE_VARIABLE_NAME="${3:-}"
local -r REX='^-([a-zA-Z0-9])(.+)$'
if [[ $ARGUMENT =~ $REX ]]
then
mbfl_set_maybe "$OPTION_VARIABLE_NAME" "${BASH_REMATCH[1]}"
mbfl_set_maybe "$VALUE_VARIABLE_NAME"  $(mbfl_string_quote "${BASH_REMATCH[2]}")
return_success
else return_failure
fi
}
function mbfl_wrong_num_args () {
local -i required=${1:?"missing required number of args parameter to '$FUNCNAME'"}
local -i argc=${2:?"missing given number of args parameter to '$FUNCNAME'"}
if ((required == argc))
then return_success
else
mbfl_message_error "number of arguments required: $required"
return_failure
fi
}
function mbfl_wrong_num_args_range () {
local -i min_required=${1:?"missing minimum required number of args parameter to '$FUNCNAME'"}
local -i max_required=${2:?"missing maximum required number of args parameter to '$FUNCNAME'"}
local -i argc=${3:?"missing given number of args parameter to '$FUNCNAME'"}
if test $min_required -gt $argc -o $max_required -lt $argc
then
mbfl_message_error "number of required arguments between $min_required and $max_required but given $argc"
return_failure
else return_success
fi
}
function mbfl_argv_from_stdin () {
local item=
if ((0 == ARGC))
then return_success
else
while mbfl_read_maybe_null item
do
ARGV[$ARGC]=$item
let ++ARGC
done
fi
}
function mbfl_argv_all_files () {
local i item
for ((i=0; i < ARGC; ++i))
do
mbfl_file_normalise_var item "${ARGV[$i]}"
if mbfl_file_is_file "$item"
then ARGV[$i]=$item
else
mbfl_message_error_printf 'unexistent file "%s"' "$item"
return_failure
fi
done
return_success
}
function mbfl_getopts_p_test_option () {
test "${!1}" = yes
}
function mbfl_getopts_print_long_switches () {
local i=0
for ((i=0; $i < ${#mbfl_getopts_LONGS[@]}; ++i))
do
if test -n "${mbfl_getopts_LONGS[$i]}"
then printf -- '--%s' "${mbfl_getopts_LONGS[$i]}"
else continue
fi
if (( (i+1) < ${#mbfl_getopts_LONGS[@]}))
then echo -n ' '
fi
done
echo
return_success
}
function mbfl_getopts_gather_mbfl_options_var () {
local mbfl_a_variable_FLAGS=${1:?"missing variable name parameter to '$FUNCNAME'"}
local -n FLAGS=$mbfl_a_variable_FLAGS
if mbfl_option_verbose
then FLAGS+=' --verbose'
fi
if mbfl_option_verbose_program
then FLAGS+=' --verbose-program'
fi
if mbfl_option_debug
then FLAGS+=' --debug'
fi
if mbfl_option_show_program
then FLAGS+=' --show-program'
fi
if mbfl_option_test
then FLAGS+=' --test'
fi
if mbfl_option_interactive
then FLAGS+=' --interactive'
fi
if mbfl_option_null
then FLAGS+=' --null'
fi
if mbfl_option_encoded_args
then FLAGS+=' --encoded-args'
fi
}
function mbfl_getopts_gather_mbfl_options_array () {
local mbfl_a_variable_FLAGS_ARRY=${1:?"missing indexed array variable name parameter to '$FUNCNAME'"}
local -n FLAGS_ARRY=$mbfl_a_variable_FLAGS_ARRY
local -i IDX=${#FLAGS_ARRY[@]}
if mbfl_option_verbose
then FLAGS_ARRY[$IDX]='--verbose'; let ++IDX
fi
if mbfl_option_verbose_program
then FLAGS_ARRY[$IDX]='--verbose-program'; let ++IDX
fi
if mbfl_option_debug
then FLAGS_ARRY[$IDX]='--debug'; let ++IDX
fi
if mbfl_option_show_program
then FLAGS_ARRY[$IDX]='--show-program'; let ++IDX
fi
if mbfl_option_test
then FLAGS_ARRY[$IDX]='--test'; let ++IDX
fi
if mbfl_option_interactive
then FLAGS_ARRY[$IDX]='--interactive'; let ++IDX
fi
if mbfl_option_null
then FLAGS_ARRY[$IDX]='--null'; let ++IDX
fi
if mbfl_option_encoded_args
then FLAGS_ARRY[$IDX]='--encoded-args'; let ++IDX
fi
}
declare mbfl_message_PROGNAME=$script_PROGNAME
declare mbfl_message_CHANNEL=2
function mbfl_message_set_progname () {
mbfl_message_PROGNAME=${1:?$FUNCNAME error: missing program name argument}
}
function mbfl_message_set_channel () {
local CHANNEL=${1:?$FUNCNAME error: missing channel argument}
if mbfl_string_is_digit "$CHANNEL"
then mbfl_message_CHANNEL=$CHANNEL
else
mbfl_message_error_printf 'invalid message channel, expected digits: "%s"' "$CHANNEL"
return 1
fi
}
function mbfl_message_p_print () {
printf "${2:?$1 error: missing template argument}" >&$mbfl_message_CHANNEL
}
function mbfl_message_p_print_prefix () {
mbfl_message_p_print $1 "$mbfl_message_PROGNAME: $2"
}
function mbfl_message_string () {
local  STRING="${1:-string}"
mbfl_message_p_print $FUNCNAME "$1"
return 0
}
function mbfl_message_verbose () {
if mbfl_option_verbose
then mbfl_message_p_print_prefix $FUNCNAME "$1"
fi
return 0
}
function mbfl_message_verbose_end () {
if mbfl_option_verbose
then mbfl_message_p_print $FUNCNAME "$1\n"
fi
return 0
}
function mbfl_message_error () {
mbfl_message_p_print_prefix $FUNCNAME "error: $1\n"
return 0
}
function mbfl_message_warning () {
mbfl_message_p_print_prefix $FUNCNAME "warning: $1\n"
return 0
}
function mbfl_message_debug () {
mbfl_option_debug && mbfl_message_p_print_prefix $FUNCNAME "debug: $1\n"
return 0
}
function mbfl_message_verbose_printf () {
if mbfl_option_verbose
then
{
printf '%s: ' "$mbfl_message_PROGNAME"
printf "$@"
} >&$mbfl_message_CHANNEL
fi
return 0
}
function mbfl_message_error_printf () {
{
printf '%s: error: ' "$mbfl_message_PROGNAME"
printf "$@"
echo
} >&$mbfl_message_CHANNEL
return 0
}
function mbfl_message_warning_printf () {
{
printf '%s: warning: ' "$mbfl_message_PROGNAME"
printf "$@"
echo
} >&$mbfl_message_CHANNEL
return 0
}
function mbfl_message_debug_printf () {
if mbfl_option_debug
then
{
printf '%s: debug: ' "$mbfl_message_PROGNAME"
printf "$@"
echo
} >&$mbfl_message_CHANNEL
fi
return 0
}
declare -a mbfl_split_PATH
function mbfl_program_split_path () {
if ((0 == ${#mbfl_split_PATH[@]}))
then
local   -a SPLITFIELD
local -i SPLITCOUNT i
mbfl_string_split "$PATH" :
for ((i=0; i < SPLITCOUNT; ++i))
do mbfl_split_PATH[$i]=${SPLITFIELD[$i]}
done
return_success
else return_failure
fi
}
function mbfl_program_find_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PROGRAM=${2:?"missing program parameter to '$FUNCNAME'"}
if mbfl_file_is_absolute "$mbfl_PROGRAM"
then
if mbfl_file_is_file "$mbfl_PROGRAM"
then
mbfl_RESULT_VARREF="$mbfl_PROGRAM"
return_success
else return_because_program_not_found
fi
elif {
local mbfl_a_variable_DUMMY
mbfl_variable_alloc mbfl_a_variable_DUMMY
local  $mbfl_a_variable_DUMMY
local -n DUMMY=$mbfl_a_variable_DUMMY
mbfl_string_first_var $mbfl_a_variable_DUMMY "$mbfl_PROGRAM" '/'
}
then
if mbfl_file_is_file "$mbfl_PROGRAM"
then
mbfl_RESULT_VARREF="$mbfl_PROGRAM"
return_success
else return_because_program_not_found
fi
else
mbfl_program_split_path
local mbfl_PATHNAME
local -i mbfl_I mbfl_NUMBER_OF_COMPONENTS=${#mbfl_split_PATH[@]}
for ((mbfl_I=0; mbfl_I < mbfl_NUMBER_OF_COMPONENTS; ++mbfl_I))
do
printf -v mbfl_PATHNAME '%s/%s' "${mbfl_split_PATH[$mbfl_I]}" "$mbfl_PROGRAM"
if mbfl_file_is_file "$mbfl_PATHNAME"
then
mbfl_RESULT_VARREF="$mbfl_PATHNAME"
break
fi
done
if mbfl_string_is_not_empty "$mbfl_RESULT_VARREF"
then return_success
else return_because_program_not_found
fi
fi
}
function mbfl_program_find () {
local  PROGRAM=${1:?"missing program parameter to '$FUNCNAME'"}
local mbfl_a_variable_RESULT_VARNAME
mbfl_variable_alloc mbfl_a_variable_RESULT_VARNAME
local  $mbfl_a_variable_RESULT_VARNAME
local -n RESULT_VARNAME=$mbfl_a_variable_RESULT_VARNAME
if mbfl_program_find_var $mbfl_a_variable_RESULT_VARNAME "$PROGRAM"
then echo "$RESULT_VARNAME"
else return $?
fi
}
if { test "$mbfl_INTERACTIVE"  '!=' 'yes'; }
then declare -A mbfl_program_PATHNAMES
fi
function mbfl_declare_program () {
local  PROGRAM=${1:?"missing program parameter to '$FUNCNAME'"}
local PROGRAM_PATHNAME
mbfl_program_find_var PROGRAM_PATHNAME "$PROGRAM"
if mbfl_string_is_not_empty "$PROGRAM_PATHNAME"
then mbfl_file_normalise_var PROGRAM_PATHNAME "$PROGRAM_PATHNAME"
fi
mbfl_program_PATHNAMES["$PROGRAM"]=$PROGRAM_PATHNAME
return_success
}
function mbfl_program_validate_declared () {
local -i RV=0
local PROGRAM PROGRAM_PATHNAME
for PROGRAM in "${!mbfl_program_PATHNAMES[@]}"
do
PROGRAM_PATHNAME=${mbfl_program_PATHNAMES["$PROGRAM"]}
if mbfl_file_is_file "$PROGRAM_PATHNAME"
then mbfl_message_verbose_printf 'found "%s": "%s"\n' "$PROGRAM" "$PROGRAM_PATHNAME"
else
mbfl_message_verbose_printf '*** not found "%s", path: "%s"\n' "$PROGRAM" "$PROGRAM_PATHNAME"
RV=1
fi
done
return $RV
}
function mbfl_program_found_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PROGRAM=${2:?"missing program name parameter to '$FUNCNAME'"}
local -r mbfl_PROGRAM_PATHNAME=${mbfl_program_PATHNAMES["$mbfl_PROGRAM"]}
if mbfl_file_is_file "$mbfl_PROGRAM_PATHNAME"
then
mbfl_RESULT_VARREF=$mbfl_PROGRAM_PATHNAME
return_success
else
mbfl_message_error_printf 'unable to find pathname for program file: "%s"' "$mbfl_PROGRAM"
return_because_program_not_found
fi
}
function mbfl_program_found () {
local  PROGRAM=${1:?"missing program name parameter to '$FUNCNAME'"}
local RESULT_VARNAME EXIT_STATUS
mbfl_program_found_var RESULT_VARNAME "$PROGRAM"
EXIT_STATUS=$?
if ((0 == EXIT_STATUS))
then
echo "$RESULT_VARNAME"
return_success
else return $EXIT_STATUS
fi
}
function mbfl_program_main_validate_programs () {
mbfl_program_validate_declared || exit_because_program_not_found
}
declare mbfl_program_EXEC_FLAGS
function mbfl_program_set_exec_flags () {
mbfl_program_EXEC_FLAGS="$*"
}
function mbfl_program_reset_exec_flags () {
mbfl_program_EXEC_FLAGS=
}
declare mbfl_program_STDERR_TO_STDOUT=false
function mbfl_program_redirect_stderr_to_stdout () {
mbfl_program_STDERR_TO_STDOUT=true
}
function mbfl_program_set_stderr_to_stdout () {
mbfl_program_STDERR_TO_STDOUT=true
}
function mbfl_program_reset_stderr_to_stdout () {
mbfl_program_STDERR_TO_STDOUT=false
}
declare mbfl_program_SUDO_USER=':nosudo:'
declare mbfl_program_SUDO_OPTIONS
declare mbfl_program_EFFECTIVE_USER
declare mbfl_program_FORCE_USE_SUDO=false
function mbfl_program_enable_sudo () {
if ! mbfl_file_is_executable "$mbfl_PROGRAM_SUDO"
then mbfl_message_warning_printf 'executable sudo not found: "%s"\n' "$mbfl_PROGRAM_SUDO"
fi
if ! mbfl_file_is_executable "$mbfl_PROGRAM_WHOAMI"
then mbfl_message_warning_printf 'executable whoami not found: "%s"\n' "$mbfl_PROGRAM_WHOAMI"
fi
}
function mbfl_program_declare_sudo_user () {
local  PERSONA=${1:?"missing sudo user name parameter to '$FUNCNAME'"}
local EFFECTIVE_USER_NAME
if ! mbfl_string_is_username "$PERSONA"
then
mbfl_message_error_printf 'attempt to select invalid "sudo" user: "%s"' "$PERSONA"
exit_because_invalid_sudo_username
fi
if ! mbfl_file_is_executable "$mbfl_PROGRAM_SUDO"
then
mbfl_message_error_printf 'executable sudo not found: "%s"' "$mbfl_PROGRAM_SUDO"
exit_because_program_not_found
fi
if ! mbfl_file_is_executable "$mbfl_PROGRAM_WHOAMI"
then
mbfl_message_error_printf 'executable whoami not found: "%s"' "$mbfl_PROGRAM_WHOAMI"
exit_because_program_not_found
fi
if mbfl_string_is_empty "$mbfl_program_EFFECTIVE_USER"
then
if mbfl_program_EFFECTIVE_USER=$("$mbfl_PROGRAM_WHOAMI")
then EFFECTIVE_USER_NAME=$mbfl_program_EFFECTIVE_USER
else
mbfl_message_error 'unable to determine current effective user name'
exit_because_failure
fi
else EFFECTIVE_USER_NAME=$mbfl_program_EFFECTIVE_USER
fi
if mbfl_string_not_equal "$PERSONA" "$EFFECTIVE_USER_NAME" || mbfl_string_is_true "$mbfl_program_FORCE_USE_SUDO"
then
mbfl_program_SUDO_USER=$PERSONA
mbfl_program_FORCE_USE_SUDO=false
mbfl_message_debug_printf '%s: the next program execution will use "sudo" with user: "%s"' "$FUNCNAME" "$mbfl_program_SUDO_USER"
return_success
else
mbfl_message_debug_printf '%s: skipped "sudo" request for user: "%s"' "$FUNCNAME" "$PERSONA"
mbfl_program_reset_sudo_user
mbfl_program_FORCE_USE_SUDO=false
return_because_failure
fi
}
function mbfl_program_reset_sudo_user () {
mbfl_message_debug_printf '%s: reset sudo user request' "$FUNCNAME"
mbfl_program_SUDO_USER=':nosudo:'
}
function mbfl_program_sudo_user () {
printf '%s\n' "$mbfl_program_SUDO_USER"
}
function mbfl_program_requested_sudo () {
test "$mbfl_program_SUDO_USER" != ':nosudo:'
}
function mbfl_program_declare_sudo_options () {
mbfl_program_SUDO_OPTIONS="$*"
}
function mbfl_program_set_sudo_options () {
mbfl_program_SUDO_OPTIONS="$*"
}
function mbfl_program_reset_sudo_options () {
mbfl_program_SUDO_OPTIONS=
}
declare mbfl_program_BGPID
function mbfl_program_exec () {
local -ir INCHAN=0 OUCHAN=1 ERCHAN=2
local -r REPLACE=false BACKGROUND=false
mbfl_p_program_exec $INCHAN $OUCHAN $ERCHAN $REPLACE $BACKGROUND "$@"
}
function mbfl_program_exec2 () {
local  INCHAN=${1:?"missing numeric input channel parameter to '$FUNCNAME'"}
local  OUCHAN=${2:?"missing numeric output channel parameter to '$FUNCNAME'"}
local  ERCHAN=${3:?"missing numeric error channel parameter to '$FUNCNAME'"}
shift 3
local -r REPLACE=false BACKGROUND=false
mbfl_program_reset_stderr_to_stdout
mbfl_p_program_exec $INCHAN $OUCHAN $ERCHAN $REPLACE $BACKGROUND "$@"
}
function mbfl_program_execbg () {
local  INCHAN=${1:?"missing numeric input channel parameter to '$FUNCNAME'"}
local  OUCHAN=${2:?"missing numeric output channel parameter to '$FUNCNAME'"}
local -ir ERCHAN=2
shift 2
local -r REPLACE=false BACKGROUND=true
mbfl_p_program_exec $INCHAN $OUCHAN $ERCHAN $REPLACE $BACKGROUND "$@"
}
function mbfl_program_execbg2 () {
local  INCHAN=${1:?"missing numeric input channel parameter to '$FUNCNAME'"}
local  OUCHAN=${2:?"missing numeric output channel parameter to '$FUNCNAME'"}
local  ERCHAN=${3:?"missing numeric error channel parameter to '$FUNCNAME'"}
shift 3
local -r REPLACE=false BACKGROUND=true
mbfl_program_reset_stderr_to_stdout
mbfl_p_program_exec $INCHAN $OUCHAN $ERCHAN $REPLACE $BACKGROUND "$@"
}
function mbfl_program_replace () {
local -ir INCHAN=0 OUCHAN=1 ERCHAN=2
local -r REPLACE=true BACKGROUND=false
mbfl_p_program_exec $INCHAN $OUCHAN $ERCHAN $REPLACE $BACKGROUND "$@"
}
function mbfl_program_replace2 () {
local  INCHAN=${1:?"missing numeric input channel parameter to '$FUNCNAME'"}
local  OUCHAN=${2:?"missing numeric output channel parameter to '$FUNCNAME'"}
local  ERCHAN=${3:?"missing numeric error channel parameter to '$FUNCNAME'"}
shift 3
local -r REPLACE=true BACKGROUND=false
mbfl_program_reset_stderr_to_stdout
mbfl_p_program_exec $INCHAN $OUCHAN $ERCHAN $REPLACE $BACKGROUND "$@"
}
function mbfl_p_program_exec () {
local  INCHAN=${1:?"missing input channel parameter to '$FUNCNAME'"}
local  OUCHAN=${2:?"missing output channel parameter to '$FUNCNAME'"}
local  ERCHAN=${3:?"missing error channel parameter to '$FUNCNAME'"}
local  REPLACE=${4:?"missing replace argument parameter to '$FUNCNAME'"}
local  BACKGROUND=${5:?"missing background argument parameter to '$FUNCNAME'"}
shift 5
local USE_SUDO=false
if mbfl_program_requested_sudo
then USE_SUDO=true
fi
local -r SUDO="$mbfl_PROGRAM_SUDO"
local -r PERSONA=$mbfl_program_SUDO_USER
local -r SUDO_OPTIONS=$mbfl_program_SUDO_OPTIONS
mbfl_program_reset_sudo_user
mbfl_program_reset_sudo_options
local -r STDERR_TO_STDOUT=$mbfl_program_STDERR_TO_STDOUT
mbfl_program_reset_stderr_to_stdout
if { mbfl_option_test || mbfl_option_show_program; }
then mbfl_p_program_log_1 "$@"
fi
if ! mbfl_option_test
then
if $REPLACE
then
local EXEC=exec
local EXEC_FLAGS=$mbfl_program_EXEC_FLAGS
mbfl_program_reset_exec_flags
else
local EXEC=
local EXEC_FLAGS=
mbfl_program_reset_exec_flags
fi
if $STDERR_TO_STDOUT
then
if mbfl_string_is_digit "$OUCHAN"
then
if mbfl_string_is_digit "$INCHAN"
then
if $BACKGROUND
then
local -i EXIT_CODE
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN" &
else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN" &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
return $EXIT_CODE
else
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN"
else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN"
fi
fi
else
if $BACKGROUND
then
local -i EXIT_CODE
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN" &
else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN" &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
return $EXIT_CODE
else
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN"
else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$OUCHAN"
fi
fi
fi
else
if mbfl_string_is_digit "$INCHAN"
then
if $BACKGROUND
then
local -i EXIT_CODE
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN" &
else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN" &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
return $EXIT_CODE
else
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN"
else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN"
fi
fi
else
if $BACKGROUND
then
local -i EXIT_CODE
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN" &
else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN" &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
return $EXIT_CODE
else
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN"
else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >"$OUCHAN" 2>&"$OUCHAN"
fi
fi
fi
fi
else
if mbfl_string_is_digit "$OUCHAN"
then
if mbfl_string_is_digit "$INCHAN"
then
if $BACKGROUND
then
local -i EXIT_CODE
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN" &
else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN" &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
return $EXIT_CODE
else
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN"
else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN"
fi
fi
else
if $BACKGROUND
then
local -i EXIT_CODE
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN" &
else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN" &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
return $EXIT_CODE
else
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN"
else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >&"$OUCHAN" 2>&"$ERCHAN"
fi
fi
fi
else
if mbfl_string_is_digit "$INCHAN"
then
if $BACKGROUND
then
local -i EXIT_CODE
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN" &
else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN" &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
return $EXIT_CODE
else
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN"
else $EXEC $EXEC_FLAGS                                     "$@" <&"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN"
fi
fi
else
if $BACKGROUND
then
local -i EXIT_CODE
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN" &
else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN" &
fi
EXIT_CODE=$?
mbfl_program_BGPID=$!
mbfl_message_debug_printf 'executed background process with PID: %s' "$mbfl_program_BGPID"
return $EXIT_CODE
else
if $USE_SUDO
then $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$@" <"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN"
else $EXEC $EXEC_FLAGS                                     "$@" <"$INCHAN" >"$OUCHAN" 2>&"$ERCHAN"
fi
fi
fi
fi
fi
fi
}
function mbfl_p_program_log_1 () {
{
mbfl_p_program_log_2 "$@"
if $BACKGROUND
then echo ' &'
else echo
fi
} >&2
}
function mbfl_p_program_log_2 () {
mbfl_p_program_log_3 "$@"
if $STDERR_TO_STDOUT
then echo -n " 2>&$OUCHAN"
else echo -n " 2>&$ERCHAN"
fi
}
function mbfl_p_program_log_3 () {
mbfl_p_program_log_4 "$@"
if mbfl_string_is_digit "$OUCHAN"
then echo -n " >&$OUCHAN"
else echo -n " >'$OUCHAN'"
fi
}
function mbfl_p_program_log_4 () {
mbfl_p_program_log_5 "$@"
if mbfl_string_is_digit "$INCHAN"
then echo -n " <&$INCHAN"
else echo -n " <'$INCHAN'"
fi
}
function mbfl_p_program_log_5 () {
local EXEC EXEC_FLAGS PROG=$1
shift 1
if $REPLACE
then
EXEC=exec
EXEC_FLAGS=$mbfl_program_EXEC_FLAGS
else EXEC=command
fi
if $USE_SUDO
then echo -n $EXEC $EXEC_FLAGS "$SUDO" $SUDO_OPTIONS -u "$PERSONA" "$PROG"
else echo -n $EXEC $EXEC_FLAGS "$PROG"
fi
{
local mbfl_a_variable_QUOTED_ARG
mbfl_variable_alloc mbfl_a_variable_QUOTED_ARG
local  $mbfl_a_variable_QUOTED_ARG
local -n QUOTED_ARG=$mbfl_a_variable_QUOTED_ARG
local arg
for arg in "$@"
do
mbfl_string_quote_var $mbfl_a_variable_QUOTED_ARG "$arg"
printf " '%s'" "$QUOTED_ARG"
done
}
}
function mbfl_program_bash () {
mbfl_program_exec "$mbfl_PROGRAM_BASH" "$@"
}
function mbfl_program_bash_command () {
local  COMMAND=${1:?"missing command parameter to '$FUNCNAME'"}
shift
mbfl_program_bash "$@" -c "$COMMAND"
}
function mbfl_process_disown () {
if mbfl_option_test || mbfl_option_show_program
then
{
printf 'builtin disown '
echo -n "$@"
printf '\n'
} >&2
fi
if ! mbfl_option_test
then builtin disown "$@"
fi
}
function mbfl_process_wait () {
if mbfl_option_test || mbfl_option_show_program
then
{
printf 'builtin wait '
echo -n "$@"
printf '\n'
} >&2
fi
if ! mbfl_option_test
then builtin wait "$@"
fi
}
function mbfl_process_kill () {
if mbfl_option_test || mbfl_option_show_program
then
{
printf 'builtin kill '
echo -n "$@"
printf '\n'
} >&2
fi
if ! mbfl_option_test
then builtin kill "$@"
fi
}
function mbfl_process_suspend () {
if mbfl_option_test || mbfl_option_show_program
then
{
printf 'builtin suspend '
echo -n "$@"
printf '\n'
} >&2
fi
if ! mbfl_option_test
then builtin suspend "$@"
fi
}
function mbfl_process_bg () {
if mbfl_option_test || mbfl_option_show_program
then
{
printf 'builtin bg '
echo -n "$@"
printf '\n'
} >&2
fi
if ! mbfl_option_test
then builtin bg "$@"
fi
}
function mbfl_process_fg () {
if mbfl_option_test || mbfl_option_show_program
then
{
printf 'builtin fg '
echo -n "$@"
printf '\n'
} >&2
fi
if ! mbfl_option_test
then builtin fg "$@"
fi
}
function mbfl_process_jobs () {
if mbfl_option_test || mbfl_option_show_program
then
{
printf 'builtin jobs '
echo -n "$@"
printf '\n'
} >&2
fi
if ! mbfl_option_test
then builtin jobs "$@"
fi
}
function mbfl_process_sleep () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_SLEEP"
then mbfl_program_exec "$mbfl_PROGRAM_SLEEP" "$@"
else return_failure
fi
}
if { test "$mbfl_INTERACTIVE"  '!=' 'yes'; }
then
declare -a mbfl_signal_HANDLERS
declare -i mbfl_signal_MAX_SIGNUM
function mbfl_p_signal_init_module () {
local -i i=0
{ while kill -l $i ; do let ++i; done; } &>/dev/null
mbfl_signal_MAX_SIGNUM=$i
}
mbfl_p_signal_init_module
fi
function mbfl_signal_map_signame_to_signum () {
local  SIGSPEC=${1:?"missing signal name parameter to '$FUNCNAME'"}
local i name
for ((i=0; $i < $mbfl_signal_MAX_SIGNUM; ++i))
do
test "SIG$(kill -l $i)" = "$SIGSPEC" && {
echo $i
return 0
}
done
return 1
}
function mbfl_signal_attach () {
local  SIGSPEC=${1:?"missing signal name parameter to '$FUNCNAME'"}
local  HANDLER=${2:?"missing function name parameter to '$FUNCNAME'"}
local signum
signum=$(mbfl_signal_map_signame_to_signum "$SIGSPEC") || return 1
if test -z ${mbfl_signal_HANDLERS[$signum]}
then mbfl_signal_HANDLERS[$signum]=$HANDLER
else mbfl_signal_HANDLERS[$signum]=${mbfl_signal_HANDLERS[$signum]}:$HANDLER
fi
mbfl_message_debug "attached '$HANDLER' to signal $SIGSPEC"
trap -- "mbfl_signal_invoke_handlers $signum" $signum
}
function mbfl_signal_invoke_handlers () {
local  SIGNUM=${1:?"missing signal number parameter to '$FUNCNAME'"}
local handler ORGIFS=$IFS
mbfl_message_debug "received signal 'SIG$(kill -l $SIGNUM)'"
IFS=:
for handler in ${mbfl_signal_HANDLERS[$SIGNUM]}
do
IFS=$ORGIFS
mbfl_message_debug "registered handler: $handler"
test -n "$handler" && eval $handler
done
IFS=$ORGIFS
return 0
}
function mbfl_variable_find_in_array () {
local  ELEMENT=${1:?"missing element parameter parameter to '$FUNCNAME'"}
local -i i ARRAY_DIM=${#mbfl_FIELDS[@]}
for ((i=0; i < ARRAY_DIM; ++i))
do
if mbfl_string_equal "${mbfl_FIELDS[$i]}" "$ELEMENT"
then
printf '%d\n' $i
return 0
fi
done
return 1
}
function mbfl_variable_element_is_in_array () {
local pos
pos=$(mbfl_variable_find_in_array "$@")
}
function mbfl_variable_colon_variable_to_array () {
local  COLON_VARIABLE=${1:?"missing colon variable parameter to '$FUNCNAME'"}
local ORGIFS=$IFS
IFS=: mbfl_FIELDS=(${!COLON_VARIABLE})
IFS=$ORGIFS
return 0
}
function mbfl_variable_array_to_colon_variable () {
local  COLON_VARIABLE=${1:?"missing colon variable parameter to '$FUNCNAME'"}
local -i i dimension=${#mbfl_FIELDS[@]}
if test $dimension = 0
then eval $COLON_VARIABLE=
else
eval ${COLON_VARIABLE}=\'"${mbfl_FIELDS[0]}"\'
for ((i=1; $i < $dimension; ++i))
do eval $COLON_VARIABLE=\'"${!COLON_VARIABLE}:${mbfl_FIELDS[$i]}"\'
done
fi
return 0
}
function mbfl_variable_colon_variable_drop_duplicate () {
local  COLON_VARIABLE=${1:?"missing colon variable parameter to '$FUNCNAME'"}
local item
local   -a mbfl_FIELDS
local   -a FIELDS
local -i dimension count i
mbfl_variable_colon_variable_to_array "$COLON_VARIABLE"
dimension=${#mbfl_FIELDS[@]}
FIELDS=("${mbfl_FIELDS[@]}")
mbfl_FIELDS=()
for ((i=0, count=0; i < dimension; ++i))
do
item=${FIELDS[$i]}
if mbfl_variable_element_is_in_array "$item"
then continue
fi
mbfl_FIELDS[$count]=$item
let ++count
done
mbfl_variable_array_to_colon_variable $COLON_VARIABLE
return 0
}
function mbfl_variable_alloc () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_NAME
while true
do
mbfl_NAME=mbfl_u_variable_${RANDOM}
local -n mbfl_REF=$mbfl_NAME
if ((0 == ${#mbfl_REF} && 0 == ${#mbfl_REF[@]}))
then break
fi
done
mbfl_RESULT_VARREF=$mbfl_NAME
return 0
}
function mbfl_times_and_dates_enable () {
:
}
function mbfl_exec_date () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_DATE"
then mbfl_program_exec "$mbfl_PROGRAM_DATE" "$@"
else
mbfl_message_error_printf 'program "date" not executable, tested pathname is: "%s"' "$mbfl_PROGRAM_DATE"
return_because_program_not_found
fi
}
function mbfl_exec_date_format () {
local  FORMAT=${1:?"missing date format parameter to '$FUNCNAME'"}
shift
mbfl_exec_date "$FORMAT" "$@"
}
function mbfl_date_current_year () {
mbfl_exec_date_format '+%Y'
}
function mbfl_date_current_month () {
mbfl_exec_date_format '+%m'
}
function mbfl_date_current_day () {
mbfl_exec_date_format '+%d'
}
function mbfl_date_current_hour () {
mbfl_exec_date_format '+%H'
}
function mbfl_date_current_minute () {
mbfl_exec_date_format '+%M'
}
function mbfl_date_current_second () {
mbfl_exec_date_format '+%S'
}
function mbfl_date_current_date () {
mbfl_exec_date_format '+%F'
}
function mbfl_date_current_time () {
mbfl_exec_date_format '+%T'
}
function mbfl_date_email_timestamp () {
mbfl_exec_date --rfc-2822
}
function mbfl_date_iso_timestamp () {
mbfl_exec_date --iso-8601=ns
}
function mbfl_dialog_enable_programs () {
mbfl_declare_program stty
}
function mbfl_dialog_yes_or_no () {
local  STRING=${1:?"missing prompt string parameter to '$FUNCNAME'"}
local  PROGNAME="${2:-${script_PROGNAME}}"
local PROMPT ANS
printf -v PROMPT '%s: %s? (yes/no) ' "$PROGNAME" "$STRING"
while { IFS= read -r -e -p "$PROMPT" ANS && \
mbfl_string_not_equal "$ANS" 'yes' && \
mbfl_string_not_equal "$ANS" 'no'; }
do printf '%s: please answer yes or no.\n' "$PROGNAME"
done
mbfl_string_equal "$ANS" 'yes'
}
function mbfl_dialog_ask_password_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_PROMPT=${2:?"missing prompt parameter to '$FUNCNAME'"}
local mbfl_PASSWORD
local mbfl_a_variable_mbfl_STTY
mbfl_variable_alloc mbfl_a_variable_mbfl_STTY
local  $mbfl_a_variable_mbfl_STTY
local -n mbfl_STTY=$mbfl_a_variable_mbfl_STTY
mbfl_program_found_var $mbfl_a_variable_mbfl_STTY stty || exit_because_program_not_found
printf '%s: ' "mbfl_PROMPT" >&2
"$mbfl_STTY" cbreak -echo </dev/tty >/dev/tty 2>&1
IFS= read -rs mbfl_PASSWORD
"$mbfl_STTY" -cbreak echo </dev/tty >/dev/tty 2>&1
echo >&2
mbfl_RESULT_VARREF=$mbfl_PASSWORD
}
function mbfl_dialog_ask_password () {
local  PROMPT=${1:?"missing prompt parameter to '$FUNCNAME'"}
local RESULT_VARNAME
if mbfl_dialog_ask_password_var RESULT_VARNAME "$PROMPT"
then echo "$RV"
else return $?
fi
}
function mbfl_system_enable_programs () {
:
}
declare -A mbfl_system_PASSWD_ENTRIES
declare -i mbfl_system_PASSWD_COUNT=0
function mbfl_system_passwd_reset () {
mbfl_system_PASSWD_ENTRIES=()
mbfl_system_PASSWD_COUNT=0
}
function mbfl_system_passwd_read () {
if ((0 == mbfl_system_PASSWD_COUNT))
then
local -r REX='([a-zA-Z0-9_\-]+):([a-zA-Z0-9_\-]+):([0-9]+):([0-9]+):(.*):([a-zA-Z0-9_/\-]+):([a-zA-Z0-9_/\-]+)'
local LINE
if {
while IFS= read LINE
do
if [[ $LINE =~ $REX ]]
then
mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:name"]=${BASH_REMATCH[1]}
mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:passwd"]=${BASH_REMATCH[2]}
mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:uid"]=${BASH_REMATCH[3]}
mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:gid"]=${BASH_REMATCH[4]}
mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:gecos"]=${BASH_REMATC[5]}
mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:dir"]=${BASH_REMATCH[6]}
mbfl_system_PASSWD_ENTRIES["${mbfl_system_PASSWD_COUNT}:shell"]=${BASH_REMATCH[7]}
let ++mbfl_system_PASSWD_COUNT
else
:
fi
done </etc/passwd
}
then
if ((0 < mbfl_system_PASSWD_COUNT))
then return 0
else return 1
fi
else return 1
fi
else return 0
fi
}
function mbfl_system_passwd_print_entries () {
local -i i
for ((i=0; i < mbfl_system_PASSWD_COUNT; ++i))
do
printf "name='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:name]}"
printf "passwd='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:passwd]}"
printf "uid=%d "	"${mbfl_system_PASSWD_ENTRIES[${i}:uid]}"
printf "gid=%d "	"${mbfl_system_PASSWD_ENTRIES[${i}:gid]}"
printf "gecos='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:gecos]}"
printf "dir='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:dir]}"
printf "shell='%s'\n"	"${mbfl_system_PASSWD_ENTRIES[${i}:shell]}"
done
}
function mbfl_system_passwd_print_entries_as_xml () {
local -i i
for ((i=0; i < mbfl_system_PASSWD_COUNT; ++i))
do
printf '<entry '
printf "name='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:name]}"
printf "passwd='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:passwd]}"
printf "uid='%d' "	"${mbfl_system_PASSWD_ENTRIES[${i}:uid]}"
printf "gid='%d' "	"${mbfl_system_PASSWD_ENTRIES[${i}:gid]}"
printf "gecos='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:gecos]}"
printf "dir='%s' "	"${mbfl_system_PASSWD_ENTRIES[${i}:dir]}"
printf "shell='%s'"	"${mbfl_system_PASSWD_ENTRIES[${i}:shell]}"
printf '/>\n'
done
}
function mbfl_system_passwd_print_entries_as_json () {
local -i i
for ((i=0; i < mbfl_system_PASSWD_COUNT; ++i))
do
printf '"entry": { '
printf '"name": "%s", '		"${mbfl_system_PASSWD_ENTRIES[${i}:name]}"
printf '"passwd": "%s", '	"${mbfl_system_PASSWD_ENTRIES[${i}:passwd]}"
printf '"uid": %d, '		"${mbfl_system_PASSWD_ENTRIES[${i}:uid]}"
printf '"gid": %d, '		"${mbfl_system_PASSWD_ENTRIES[${i}:gid]}"
printf '"gecos": "%s", '	"${mbfl_system_PASSWD_ENTRIES[${i}:gecos]}"
printf '"dir": "%s", '		"${mbfl_system_PASSWD_ENTRIES[${i}:dir]}"
printf '"shell": "%s"'		"${mbfl_system_PASSWD_ENTRIES[${i}:shell]}"
printf ' }\n'
done
}
function mbfl_system_passwd_get_name_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_INDEX=${2:?"missing passwd entry index parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:name]}
}
function mbfl_system_passwd_get_name () {
local -i INDEX=${1:?"missing passwd entry index parameter to '$FUNCNAME'"}
echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:name]}"
}
function mbfl_system_passwd_get_passwd_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_INDEX=${2:?"missing passwd entry index parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:passwd]}
}
function mbfl_system_passwd_get_passwd () {
local -i INDEX=${1:?"missing passwd entry index parameter to '$FUNCNAME'"}
echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:passwd]}"
}
function mbfl_system_passwd_get_uid_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_INDEX=${2:?"missing passwd entry index parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:uid]}
}
function mbfl_system_passwd_get_uid () {
local -i INDEX=${1:?"missing passwd entry index parameter to '$FUNCNAME'"}
echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:uid]}"
}
function mbfl_system_passwd_get_gid_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_INDEX=${2:?"missing passwd entry index parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:gid]}
}
function mbfl_system_passwd_get_gid () {
local -i INDEX=${1:?"missing passwd entry index parameter to '$FUNCNAME'"}
echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:gid]}"
}
function mbfl_system_passwd_get_gecos_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_INDEX=${2:?"missing passwd entry index parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:gecos]}
}
function mbfl_system_passwd_get_gecos () {
local -i INDEX=${1:?"missing passwd entry index parameter to '$FUNCNAME'"}
echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:gecos]}"
}
function mbfl_system_passwd_get_dir_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_INDEX=${2:?"missing passwd entry index parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:dir]}
}
function mbfl_system_passwd_get_dir () {
local -i INDEX=${1:?"missing passwd entry index parameter to '$FUNCNAME'"}
echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:dir]}"
}
function mbfl_system_passwd_get_shell_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_INDEX=${2:?"missing passwd entry index parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=${mbfl_system_PASSWD_ENTRIES[${mbfl_INDEX}:shell]}
}
function mbfl_system_passwd_get_shell () {
local -i INDEX=${1:?"missing passwd entry index parameter to '$FUNCNAME'"}
echo "${mbfl_system_PASSWD_ENTRIES[${INDEX}:shell]}"
}
function mbfl_system_passwd_find_entry_by_name_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_THE_NAME=${2:?"missing user name parameter to '$FUNCNAME'"}
local -i mbfl_I
for ((mbfl_I=0; mbfl_I < mbfl_system_PASSWD_COUNT; ++mbfl_I))
do
if mbfl_string_equal "$mbfl_THE_NAME" "${mbfl_system_PASSWD_ENTRIES[${mbfl_I}:name]}"
then
mbfl_RESULT_VARREF=$mbfl_I
return 0
fi
done
return 1
}
function mbfl_system_passwd_find_entry_by_name () {
local  THE_NAME=${1:?"missing user name parameter to '$FUNCNAME'"}
local RESULT_VARNAME
if mbfl_system_passwd_find_entry_by_name_var RESULT_VARNAME "$THE_NAME"
then echo "$RESULT_VARNAME"
else return 1
fi
}
function mbfl_system_passwd_find_entry_by_uid_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_THE_UID=${2:?"missing user id parameter to '$FUNCNAME'"}
local -i mbfl_I
for ((mbfl_I=0; mbfl_I < mbfl_system_PASSWD_COUNT; ++mbfl_I))
do
if mbfl_string_equal "$mbfl_THE_UID" "${mbfl_system_PASSWD_ENTRIES[${mbfl_I}:uid]}"
then
mbfl_RESULT_VARREF=$mbfl_I
return 0
fi
done
return 1
}
function mbfl_system_passwd_find_entry_by_uid () {
local  THE_UID=${1:?"missing user id parameter to '$FUNCNAME'"}
local RESULT_VARNAME
if mbfl_system_passwd_find_entry_by_uid_var RESULT_VARNAME "$THE_UID"
then echo "$RESULT_VARNAME"
else return 1
fi
}
function mbfl_system_passwd_uid_to_name_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_THE_UID=${2:?"missing user id parameter to '$FUNCNAME'"}
local -i mbfl_USER_INDEX
if mbfl_system_passwd_find_entry_by_uid_var mbfl_USER_INDEX $mbfl_THE_UID
then mbfl_system_passwd_get_name_var $mbfl_a_variable_mbfl_RESULT_VARREF $mbfl_USER_INDEX
else return 1
fi
}
function mbfl_system_passwd_uid_to_name () {
local -i THE_UID=${1:?"missing user id parameter to '$FUNCNAME'"}
local -i USER_INDEX
if mbfl_system_passwd_find_entry_by_uid_var USER_INDEX $THE_UID
then mbfl_system_passwd_get_name $USER_INDEX
else return 1
fi
}
function mbfl_system_passwd_name_to_uid_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_THE_NAME=${2:?"missing user name parameter to '$FUNCNAME'"}
local -i mbfl_USER_INDEX
if mbfl_system_passwd_find_entry_by_name_var mbfl_USER_INDEX "$mbfl_THE_NAME"
then mbfl_system_passwd_get_uid_var $mbfl_a_variable_mbfl_RESULT_VARREF $mbfl_USER_INDEX
else return 1
fi
}
function mbfl_system_passwd_name_to_uid () {
local  mbfl_THE_NAME=${1:?"missing user name parameter to '$FUNCNAME'"}
local -i mbfl_USER_INDEX
if mbfl_system_passwd_find_entry_by_name_var mbfl_USER_INDEX "$mbfl_THE_NAME"
then mbfl_system_passwd_get_uid $mbfl_USER_INDEX
else return 1
fi
}
function mbfl_system_numerical_user_id_to_name () {
local -i mbfl_THE_UID=${1:?"missing user id parameter to '$FUNCNAME'"}
if mbfl_system_passwd_read
then mbfl_system_passwd_uid_to_name "$mbfl_THE_UID"
fi
}
function mbfl_system_user_name_to_numerical_id () {
local  mbfl_THE_NAME=${1:?"missing user name parameter to '$FUNCNAME'"}
if mbfl_system_passwd_read
then mbfl_system_passwd_name_to_uid "$mbfl_THE_NAME"
fi
}
declare -A mbfl_system_GROUP_ENTRIES
declare -i mbfl_system_GROUP_COUNT=0
function mbfl_system_group_reset () {
mbfl_system_GROUP_ENTRIES=()
mbfl_system_GROUP_COUNT=0
}
function mbfl_system_group_read () {
if ((0 == mbfl_system_GROUP_COUNT))
then
local -r REX='([a-zA-Z0-9_\-]+):([a-zA-Z0-9_\-]+):([0-9]+):([a-zA-Z0-9_/,\-]*)'
local LINE
if {
while IFS= read LINE
do
if [[ $LINE =~ $REX ]]
then
mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:name"]=${BASH_REMATCH[1]}
mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:passwd"]=${BASH_REMATCH[2]}
mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:gid"]=${BASH_REMATCH[3]}
mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:users"]=${BASH_REMATCH[4]}
if mbfl_string_is_not_empty "${mbfl_system_GROUP_ENTRIES[${mbfl_system_GROUP_COUNT}:users]}"
then
{
local SPLITFIELD
local -i SPLITCOUNT i
mbfl_string_split "${mbfl_system_GROUP_ENTRIES[${mbfl_system_GROUP_COUNT}:users]}" ','
mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:users:count"]=$SPLITCOUNT
for ((i=0; i < SPLITCOUNT; ++i))
do mbfl_system_GROUP_ENTRIES["${mbfl_system_GROUP_COUNT}:users:${i}"]=${SPLITFIELD[$i]}
done
}
fi
let ++mbfl_system_GROUP_COUNT
fi
done </etc/group
}
then
if ((0 < mbfl_system_GROUP_COUNT))
then return 0
else return 1
fi
else return 1
fi
else return 0
fi
}
function mbfl_system_group_print_entries () {
local -i i
for ((i=0; i < mbfl_system_GROUP_COUNT; ++i))
do
printf "name='%s' "	"${mbfl_system_GROUP_ENTRIES[${i}:name]}"
printf "passwd='%s' "	"${mbfl_system_GROUP_ENTRIES[${i}:passwd]}"
printf "gid=%d "	"${mbfl_system_GROUP_ENTRIES[${i}:gid]}"
printf "users='%s'\n"	"${mbfl_system_GROUP_ENTRIES[${i}:users]}"
done
}
function mbfl_system_group_print_entries_as_xml () {
local -i i
for ((i=0; i < mbfl_system_GROUP_COUNT; ++i))
do
printf '<entry '
printf "name='%s' "	"${mbfl_system_GROUP_ENTRIES[${i}:name]}"
printf "passwd='%s' "	"${mbfl_system_GROUP_ENTRIES[${i}:passwd]}"
printf "gid='%d' "	"${mbfl_system_GROUP_ENTRIES[${i}:gid]}"
printf "users='%s'"	"${mbfl_system_GROUP_ENTRIES[${i}:users]}"
printf '/>\n'
done
}
function mbfl_system_group_print_entries_as_json () {
local -i i
for ((i=0; i < mbfl_system_GROUP_COUNT; ++i))
do
printf '"entry": { '
printf '"name": "%s", '		"${mbfl_system_GROUP_ENTRIES[${i}:name]}"
printf '"passwd": "%s", '	"${mbfl_system_GROUP_ENTRIES[${i}:passwd]}"
printf '"gid": %d, '		"${mbfl_system_GROUP_ENTRIES[${i}:gid]}"
printf '"users": "%s"'		"${mbfl_system_GROUP_ENTRIES[${i}:users]}"
printf ' }\n'
done
}
function mbfl_system_group_get_name_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_GROUP_INDEX=${2:?"missing group entry index parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:name]}
}
function mbfl_system_group_get_name () {
local -i GROUP_INDEX=${1:?"missing group entry index parameter to '$FUNCNAME'"}
echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:name]}"
}
function mbfl_system_group_get_passwd_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_GROUP_INDEX=${2:?"missing group entry index parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:passwd]}
}
function mbfl_system_group_get_passwd () {
local -i GROUP_INDEX=${1:?"missing group entry index parameter to '$FUNCNAME'"}
echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:passwd]}"
}
function mbfl_system_group_get_gid_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_GROUP_INDEX=${2:?"missing group entry index parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:gid]}
}
function mbfl_system_group_get_gid () {
local -i GROUP_INDEX=${1:?"missing group entry index parameter to '$FUNCNAME'"}
echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:gid]}"
}
function mbfl_system_group_get_users_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_GROUP_INDEX=${2:?"missing group entry index parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:users]}
}
function mbfl_system_group_get_users () {
local -i GROUP_INDEX=${1:?"missing group entry index parameter to '$FUNCNAME'"}
echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:users]}"
}
function mbfl_system_group_get_users_count_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_GROUP_INDEX=${2:?"missing group entry index parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:users:count]}
}
function mbfl_system_group_get_users_count () {
local -i GROUP_INDEX=${1:?"missing group entry index parameter to '$FUNCNAME'"}
echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:users:count]}"
}
function mbfl_system_group_get_user_name_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_GROUP_INDEX=${2:?"missing group entry index parameter to '$FUNCNAME'"}
local -i mbfl_USER_INDEX=${3:?"missing user index parameter to '$FUNCNAME'"}
mbfl_RESULT_VARREF=${mbfl_system_GROUP_ENTRIES[${mbfl_GROUP_INDEX}:users:${mbfl_USER_INDEX}]}
}
function mbfl_system_group_get_user_name () {
local -i GROUP_INDEX=${1:?"missing group entry index parameter to '$FUNCNAME'"}
local -i USER_INDEX=${2:?"missing user index parameter to '$FUNCNAME'"}
echo "${mbfl_system_GROUP_ENTRIES[${GROUP_INDEX}:users:${USER_INDEX}]}"
}
function mbfl_system_group_find_entry_by_name_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_THE_NAME=${2:?"missing group name parameter to '$FUNCNAME'"}
local -i mbfl_I
for ((mbfl_I=0; mbfl_I < mbfl_system_GROUP_COUNT; ++mbfl_I))
do
if mbfl_string_equal "$mbfl_THE_NAME" "${mbfl_system_GROUP_ENTRIES[${mbfl_I}:name]}"
then
mbfl_RESULT_VARREF=$mbfl_I
return 0
fi
done
return 1
}
function mbfl_system_group_find_entry_by_name () {
local  THE_NAME=${1:?"missing group name parameter to '$FUNCNAME'"}
local RESULT_VARNAME
if mbfl_system_group_find_entry_by_name_var RESULT_VARNAME "$THE_NAME"
then echo "$RESULT_VARNAME"
else return 1
fi
}
function mbfl_system_group_find_entry_by_gid_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_THE_GID=${2:?"missing group id parameter to '$FUNCNAME'"}
local -i mbfl_I
for ((mbfl_I=0; mbfl_I < mbfl_system_GROUP_COUNT; ++mbfl_I))
do
if mbfl_string_equal "$mbfl_THE_GID" "${mbfl_system_GROUP_ENTRIES[${mbfl_I}:gid]}"
then
mbfl_RESULT_VARREF=$mbfl_I
return 0
fi
done
return 1
}
function mbfl_system_group_find_entry_by_gid () {
local  THE_GID=${1:?"missing group id parameter to '$FUNCNAME'"}
local RESULT_VARNAME
if mbfl_system_group_find_entry_by_gid_var RESULT_VARNAME "$THE_GID"
then echo "$RESULT_VARNAME"
else return 1
fi
}
function mbfl_system_group_gid_to_name_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local -i mbfl_THE_GID=${2:?"missing group id parameter to '$FUNCNAME'"}
local -i mbfl_GROUP_INDEX
if mbfl_system_group_find_entry_by_gid_var mbfl_GROUP_INDEX $mbfl_THE_GID
then mbfl_system_group_get_name_var $mbfl_a_variable_mbfl_RESULT_VARREF $mbfl_GROUP_INDEX
else return 1
fi
}
function mbfl_system_group_gid_to_name () {
local -i THE_GID=${1:?"missing group id parameter to '$FUNCNAME'"}
local -i GROUP_INDEX
if mbfl_system_group_find_entry_by_gid_var GROUP_INDEX $THE_GID
then mbfl_system_group_get_name $GROUP_INDEX
else return 1
fi
}
function mbfl_system_group_name_to_gid_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local  mbfl_THE_NAME=${2:?"missing group name parameter to '$FUNCNAME'"}
local -i GROUP_INDEX
if mbfl_system_group_find_entry_by_name_var GROUP_INDEX "$mbfl_THE_NAME"
then mbfl_system_group_get_gid_var $mbfl_a_variable_mbfl_RESULT_VARREF $GROUP_INDEX
else return 1
fi
}
function mbfl_system_group_name_to_gid () {
local  THE_NAME=${1:?"missing group name parameter to '$FUNCNAME'"}
local -i GROUP_INDEX
if mbfl_system_group_find_entry_by_name_var GROUP_INDEX "$THE_NAME"
then mbfl_system_group_get_gid $GROUP_INDEX
else return 1
fi
}
function mbfl_system_numerical_group_id_to_name () {
local -i THE_GID=${1:?"missing group id parameter to '$FUNCNAME'"}
if mbfl_system_group_read
then mbfl_system_group_gid_to_name "$THE_GID"
fi
}
function mbfl_system_group_name_to_numerical_id () {
local  THE_NAME=${1:?"missing group name parameter to '$FUNCNAME'"}
if mbfl_system_group_read
then mbfl_system_group_name_to_gid "$THE_NAME"
fi
}
function mbfl_system_whoami () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_WHOAMI"
then mbfl_program_exec "$mbfl_PROGRAM_WHOAMI"
else return_failure
fi
}
function mbfl_system_whoami_var () {
local mbfl_a_variable_USERNAME=${1:?"missing username result variable parameter to '$FUNCNAME'"}
local -n USERNAME=$mbfl_a_variable_USERNAME
if ! USERNAME=$(mbfl_system_whoami)
then return_failure
fi
}
function mbfl_system_id () {
if mbfl_file_p_validate_executable_hard_coded_pathname "$mbfl_PROGRAM_ID"
then mbfl_program_exec "$mbfl_PROGRAM_ID" "$@"
else return_failure
fi
}
function mbfl_system_id_var () {
local mbfl_a_variable_RESULT=${1:?"missing username result variable parameter to '$FUNCNAME'"}
local -n RESULT=$mbfl_a_variable_RESULT
shift
if ! RESULT=$(mbfl_system_id "$@")
then return_failure
fi
}
function mbfl_system_effective_user_id    () { mbfl_system_id '--user'           "$@"; }
function mbfl_system_effective_user_name  () { mbfl_system_id '--user' '--name'  "$@"; }
function mbfl_system_effective_group_id   () { mbfl_system_id '--group'          "$@"; }
function mbfl_system_effective_group_name () { mbfl_system_id '--group' '--name' "$@"; }
function mbfl_system_effective_user_id_var () {
local mbfl_a_variable_RESULT=${1:?"missing username result variable parameter to '$FUNCNAME'"}
local -n RESULT=$mbfl_a_variable_RESULT
shift
mbfl_system_id_var $mbfl_a_variable_RESULT '--user' "$@"
}
function mbfl_system_effective_user_name_var () {
local mbfl_a_variable_RESULT=${1:?"missing username result variable parameter to '$FUNCNAME'"}
local -n RESULT=$mbfl_a_variable_RESULT
shift
mbfl_system_id_var $mbfl_a_variable_RESULT '--user' '--name' "$@"
}
function mbfl_system_effective_group_id_var () {
local mbfl_a_variable_RESULT=${1:?"missing groupname result variable parameter to '$FUNCNAME'"}
local -n RESULT=$mbfl_a_variable_RESULT
shift
mbfl_system_id_var $mbfl_a_variable_RESULT '--group' "$@"
}
function mbfl_system_effective_group_name_var () {
local mbfl_a_variable_RESULT=${1:?"missing groupname result variable parameter to '$FUNCNAME'"}
local -n RESULT=$mbfl_a_variable_RESULT
shift
mbfl_system_id_var $mbfl_a_variable_RESULT '--group' '--name' "$@"
}
function mbfl_system_real_user_id    () { mbfl_system_id '--real' '--user'           "$@"; }
function mbfl_system_real_user_name  () { mbfl_system_id '--real' '--user'  '--name' "$@"; }
function mbfl_system_real_group_id   () { mbfl_system_id '--real' '--group'          "$@"; }
function mbfl_system_real_group_name () { mbfl_system_id '--real' '--group' '--name' "$@"; }
function mbfl_system_real_user_id_var () {
local mbfl_a_variable_RESULT=${1:?"missing username result variable parameter to '$FUNCNAME'"}
local -n RESULT=$mbfl_a_variable_RESULT
shift
mbfl_system_id_var $mbfl_a_variable_RESULT '--real' '--user' "$@"
}
function mbfl_system_real_user_name_var () {
local mbfl_a_variable_RESULT=${1:?"missing username result variable parameter to '$FUNCNAME'"}
local -n RESULT=$mbfl_a_variable_RESULT
shift
mbfl_system_id_var $mbfl_a_variable_RESULT '--real' '--user' '--name' "$@"
}
function mbfl_system_real_group_id_var () {
local mbfl_a_variable_RESULT=${1:?"missing groupname result variable parameter to '$FUNCNAME'"}
local -n RESULT=$mbfl_a_variable_RESULT
shift
mbfl_system_id_var $mbfl_a_variable_RESULT '--real' '--group' "$@"
}
function mbfl_system_real_group_name_var () {
local mbfl_a_variable_RESULT=${1:?"missing groupname result variable parameter to '$FUNCNAME'"}
local -n RESULT=$mbfl_a_variable_RESULT
shift
mbfl_system_id_var $mbfl_a_variable_RESULT '--real' '--group' '--name' "$@"
}
function mbfl_array_is_empty () {
local mbfl_a_variable_mbfl_ARRAY_VARREF=${1:?"missing array variable name parameter to '$FUNCNAME'"}
local -n mbfl_ARRAY_VARREF=$mbfl_a_variable_mbfl_ARRAY_VARREF
if ((0 == ${#mbfl_ARRAY_VARREF[@]}))
then return 0
else return 1
fi
}
function mbfl_array_is_not_empty () {
local mbfl_a_variable_mbfl_ARRAY_VARREF=${1:?"missing array variable name parameter to '$FUNCNAME'"}
local -n mbfl_ARRAY_VARREF=$mbfl_a_variable_mbfl_ARRAY_VARREF
if ((0 != ${#mbfl_ARRAY_VARREF[@]}))
then return 0
else return 1
fi
}
function mbfl_array_length_var () {
local mbfl_a_variable_mbfl_RESULT_VARREF=${1:?"missing result variable name parameter to '$FUNCNAME'"}
local -n mbfl_RESULT_VARREF=$mbfl_a_variable_mbfl_RESULT_VARREF
local mbfl_a_variable_mbfl_ARRAY_VARREF=${2:?"missing array variable name parameter to '$FUNCNAME'"}
local -n mbfl_ARRAY_VARREF=$mbfl_a_variable_mbfl_ARRAY_VARREF
mbfl_RESULT_VARREF=${#mbfl_ARRAY_VARREF[@]}
}
function mbfl_array_length () {
local mbfl_a_variable_mbfl_ARRAY_VARREF=${1:?"missing array variable name parameter to '$FUNCNAME'"}
local -n mbfl_ARRAY_VARREF=$mbfl_a_variable_mbfl_ARRAY_VARREF
echo ${#mbfl_ARRAY_VARREF[@]}
}
function mbfl_array_copy () {
local mbfl_a_variable_DST=${1:?"missing destination array variable parameter to '$FUNCNAME'"}
local -n DST=$mbfl_a_variable_DST
local mbfl_a_variable_SRC=${2:?"missing source array variable parameter to '$FUNCNAME'"}
local -n SRC=$mbfl_a_variable_SRC
local KEY
for KEY in "${!SRC[@]}"
do DST["$KEY"]=${SRC["$KEY"]}
done
}
declare -A mbfl_semver_CONFIG
function mbfl_semver_reset_config () {
mbfl_semver_CONFIG[PARSE_LEADING_V]='optional'
mbfl_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]='false'
}
mbfl_semver_reset_config
function mbfl_semver_parse () {
local mbfl_a_variable_mbfl_RV=${1:?"missing result array variable parameter to '$FUNCNAME'"}
local -n mbfl_RV=$mbfl_a_variable_mbfl_RV
local  mbfl_INPUT_STRING=${2:?"missing string parameter to '$FUNCNAME'"}
local mbfl_a_variable_mbfl_THE_START_INDEX=${3:?"missing index of first character to parse parameter to '$FUNCNAME'"}
local -n mbfl_THE_START_INDEX=$mbfl_a_variable_mbfl_THE_START_INDEX
local mbfl_a_variable_mbfl_START_INDEX
mbfl_variable_alloc mbfl_a_variable_mbfl_START_INDEX
local -i $mbfl_a_variable_mbfl_START_INDEX
local -n mbfl_START_INDEX=$mbfl_a_variable_mbfl_START_INDEX
mbfl_START_INDEX=$mbfl_THE_START_INDEX
mbfl_p_semver_init_result_array
local mbfl_MAJOR_NUMBER
local mbfl_MINOR_NUMBER
local mbfl_PATCH_LEVEL
local mbfl_PRERELEASE_VERSION
local mbfl_BUILD_METADATA
local mbfl_PARSING_ERROR_MESSAGE
case ${mbfl_semver_CONFIG[PARSE_LEADING_V]}
in
'mandatory')
if test "${mbfl_INPUT_STRING:$mbfl_START_INDEX:1}" = 'v'
then let ++mbfl_START_INDEX
else
mbfl_RV[PARSING_ERROR_MESSAGE]='missing leading "v" character'
return 1
fi
;;
'missing')
if test "${mbfl_INPUT_STRING:$mbfl_START_INDEX:1}" = 'v'
then
mbfl_RV[PARSING_ERROR_MESSAGE]='unexpected leading "v" character'
return 1
fi
;;
*)
if test "${mbfl_INPUT_STRING:$mbfl_START_INDEX:1}" = 'v'
then let ++mbfl_START_INDEX
fi
;;
esac
if ! mbfl_p_semver_parse_version_numbers
then
mbfl_RV[PARSING_ERROR_MESSAGE]=$mbfl_PARSING_ERROR_MESSAGE
return 1
fi
if test "${mbfl_INPUT_STRING:$mbfl_START_INDEX:1}" = '-'
then
if ! mbfl_p_semver_parse_prerelease_version
then
mbfl_RV[PARSING_ERROR_MESSAGE]=$mbfl_PARSING_ERROR_MESSAGE
return 1
fi
fi
if test "${mbfl_INPUT_STRING:$mbfl_START_INDEX:1}" = '+'
then
if ! mbfl_p_semver_parse_build_metadata
then
mbfl_RV[PARSING_ERROR_MESSAGE]=$mbfl_PARSING_ERROR_MESSAGE
return 1
fi
fi
mbfl_RV[MAJOR_NUMBER]=$mbfl_MAJOR_NUMBER
mbfl_RV[MINOR_NUMBER]=$mbfl_MINOR_NUMBER
mbfl_RV[PATCH_LEVEL]=$mbfl_PATCH_LEVEL
mbfl_RV[PRERELEASE_VERSION]=$mbfl_PRERELEASE_VERSION
mbfl_RV[BUILD_METADATA]=$mbfl_BUILD_METADATA
mbfl_RV[START_INDEX]=$mbfl_THE_START_INDEX
mbfl_RV[END_INDEX]=$mbfl_START_INDEX
let mbfl_THE_START_INDEX=mbfl_START_INDEX
return 0
}
function mbfl_p_semver_init_result_array () {
mbfl_RV[MAJOR_NUMBER]=
mbfl_RV[MINOR_NUMBER]=
mbfl_RV[PATCH_LEVEL]=
mbfl_RV[PRERELEASE_VERSION]=
mbfl_RV[BUILD_METADATA]=
mbfl_RV[END_INDEX]=
mbfl_RV[PARSING_ERROR_MESSAGE]=
}
function mbfl_p_semver_parse_version_numbers () {
local -r REX='^(0|([1-9][0-9]*))\.(0|([1-9][0-9]*))\.(0|([1-9][0-9]*))($|[\-\+]|[^0-9A-Za-z])'
if [[ "${mbfl_INPUT_STRING:$mbfl_START_INDEX}" =~ $REX ]]
then
mbfl_MAJOR_NUMBER=${BASH_REMATCH[1]}
mbfl_MINOR_NUMBER=${BASH_REMATCH[3]}
mbfl_PATCH_LEVEL=${BASH_REMATCH[5]}
let mbfl_START_INDEX+=2+${#mbfl_MAJOR_NUMBER}+${#mbfl_MINOR_NUMBER}+${#mbfl_PATCH_LEVEL}
return 0
else
mbfl_PARSING_ERROR_MESSAGE='invalid version numbers specification'
return 1
fi
}
function mbfl_p_semver_parse_prerelease_version () {
local -r IDREX='(0|[1-9][0-9]*|[0-9A-Za-z\-][0-9A-Za-z\-]+)'
local REX='^\-('
REX+=$IDREX
REX+='(\.'
REX+=$IDREX
REX+=')*'
REX+=')($|\+|[^0-9A-Za-z\.\-])'
if [[ "${mbfl_INPUT_STRING:$mbfl_START_INDEX}" =~ $REX ]]
then
mbfl_PRERELEASE_VERSION=${BASH_REMATCH[1]}
let mbfl_START_INDEX+=1+${#BASH_REMATCH[1]}
return 0
else
mbfl_PARSING_ERROR_MESSAGE='invalid prerelease version'
return 1
fi
}
function mbfl_p_semver_parse_build_metadata () {
local IDRANGE='0-9A-Za-z'
if ${mbfl_semver_CONFIG[ACCEPT_UNDERSCORE_IN_BUILD_METADATA]}
then IDRANGE+='_'
fi
IDRANGE+='\-'
local IDREX='(['
IDREX+=$IDRANGE
IDREX+=']+)'
local REX='^\+('
REX+=$IDREX
REX+='(\.'
REX+=$IDREX
REX+=')*'
REX+=')'
if [[ "${mbfl_INPUT_STRING:$mbfl_START_INDEX}" =~ $REX ]]
then
mbfl_BUILD_METADATA=${BASH_REMATCH[1]}
let mbfl_START_INDEX+=1+${#BASH_REMATCH[1]}
return 0
else
mbfl_PARSING_ERROR_MESSAGE='invalid build metadata'
return 1
fi
}
function mbfl_semver_split_prerelease_version () {
local mbfl_a_variable_mbfl_RV=${1:?"missing result array variable parameter to '$FUNCNAME'"}
local -n mbfl_RV=$mbfl_a_variable_mbfl_RV
local  mbfl_INPUT_SPEC=${2:?"missing input prerelease version specification parameter to '$FUNCNAME'"}
local -r IDREX='(0|[1-9][0-9]*|[0-9A-Za-z\-][0-9A-Za-z\-]+)'
local -r DOTIDREX='\.(0|[1-9][0-9]*|[0-9A-Za-z\-][0-9A-Za-z\-]+)'
local -i i=0 j=0
if [[ "$mbfl_INPUT_SPEC" =~ $IDREX ]]
then
mbfl_RV[0]=${BASH_REMATCH[1]}
j=${#BASH_REMATCH[1]}
else return 1
fi
for ((i=1; 0 < (${#mbfl_INPUT_SPEC} - j); ++i))
do
if [[ "${mbfl_INPUT_SPEC:$j}" =~ $DOTIDREX ]]
then
mbfl_RV[$i]=${BASH_REMATCH[1]}
j+=1+${#BASH_REMATCH[1]}
else return 1
fi
done
return 0
}
function mbfl_semver_compare_var () {
local mbfl_a_variable_RV=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n RV=$mbfl_a_variable_RV
local  ONE=${2:?"missing first semantic version specification parameter to '$FUNCNAME'"}
local  TWO=${3:?"missing second semantic version specification parameter to '$FUNCNAME'"}
local mbfl_a_variable_ONE_INDEX
mbfl_variable_alloc mbfl_a_variable_ONE_INDEX
local -i $mbfl_a_variable_ONE_INDEX
local -n ONE_INDEX=$mbfl_a_variable_ONE_INDEX
ONE_INDEX=0
local mbfl_a_variable_TWO_INDEX
mbfl_variable_alloc mbfl_a_variable_TWO_INDEX
local -i $mbfl_a_variable_TWO_INDEX
local -n TWO_INDEX=$mbfl_a_variable_TWO_INDEX
TWO_INDEX=0
local mbfl_a_variable_ONE_COMPONENTS
mbfl_variable_alloc mbfl_a_variable_ONE_COMPONENTS
local -A $mbfl_a_variable_ONE_COMPONENTS
local -n ONE_COMPONENTS=$mbfl_a_variable_ONE_COMPONENTS
local mbfl_a_variable_TWO_COMPONENTS
mbfl_variable_alloc mbfl_a_variable_TWO_COMPONENTS
local -A $mbfl_a_variable_TWO_COMPONENTS
local -n TWO_COMPONENTS=$mbfl_a_variable_TWO_COMPONENTS
if ! mbfl_semver_parse $mbfl_a_variable_ONE_COMPONENTS "$ONE" $mbfl_a_variable_ONE_INDEX
then return 1
fi
if ! mbfl_semver_parse $mbfl_a_variable_TWO_COMPONENTS "$TWO" $mbfl_a_variable_TWO_INDEX
then return 1
fi
mbfl_semver_compare_components_var $mbfl_a_variable_RV $mbfl_a_variable_ONE_COMPONENTS $mbfl_a_variable_TWO_COMPONENTS
}
function mbfl_semver_compare_components_var () {
local mbfl_a_variable_RV=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n RV=$mbfl_a_variable_RV
local mbfl_a_variable_ONE_COMPONENTS=${2:?"missing first semantic version specification components parameter to '$FUNCNAME'"}
local -n ONE_COMPONENTS=$mbfl_a_variable_ONE_COMPONENTS
local mbfl_a_variable_TWO_COMPONENTS=${3:?"missing second semantic version specification components parameter to '$FUNCNAME'"}
local -n TWO_COMPONENTS=$mbfl_a_variable_TWO_COMPONENTS
if   test "${ONE_COMPONENTS[MAJOR_NUMBER]}" -lt "${TWO_COMPONENTS[MAJOR_NUMBER]}"
then RV=-1
elif test "${ONE_COMPONENTS[MAJOR_NUMBER]}" -gt "${TWO_COMPONENTS[MAJOR_NUMBER]}"
then RV=+1
else
if   test "${ONE_COMPONENTS[MINOR_NUMBER]}" -lt "${TWO_COMPONENTS[MINOR_NUMBER]}"
then RV=-1
elif test "${ONE_COMPONENTS[MINOR_NUMBER]}" -gt "${TWO_COMPONENTS[MINOR_NUMBER]}"
then RV=+1
else
if   test "${ONE_COMPONENTS[PATCH_LEVEL]}" -lt "${TWO_COMPONENTS[PATCH_LEVEL]}"
then RV=-1
elif test "${ONE_COMPONENTS[PATCH_LEVEL]}" -gt "${TWO_COMPONENTS[PATCH_LEVEL]}"
then RV=+1
else
if   (( 0 == ${#ONE_COMPONENTS[PRERELEASE_VERSION]} && 0 == ${#TWO_COMPONENTS[PRERELEASE_VERSION]} ))
then RV=0
elif (( 0 == ${#ONE_COMPONENTS[PRERELEASE_VERSION]} && 0 < ${#TWO_COMPONENTS[PRERELEASE_VERSION]} ))
then RV=-1
elif (( 0 == ${#TWO_COMPONENTS[PRERELEASE_VERSION]} && 0 < ${#ONE_COMPONENTS[PRERELEASE_VERSION]} ))
then RV=+1
else
mbfl_semver_compare_prerelease_version		\
$mbfl_a_variable_RV				\
"${ONE_COMPONENTS[PRERELEASE_VERSION]}"		\
"${TWO_COMPONENTS[PRERELEASE_VERSION]}"
return $?
fi
fi
fi
fi
return 0
}
function mbfl_semver_compare_prerelease_version () {
local mbfl_a_variable_RV=${1:?"missing result variable parameter to '$FUNCNAME'"}
local -n RV=$mbfl_a_variable_RV
local  ONE_PRERELEASE_VERSION="${2:-first prerelease version specification}"
local  TWO_PRERELEASE_VERSION="${3:-second prerelease version specification}"
local mbfl_a_variable_ONE_IDENTIFIERS
mbfl_variable_alloc mbfl_a_variable_ONE_IDENTIFIERS
local -a $mbfl_a_variable_ONE_IDENTIFIERS
local -n ONE_IDENTIFIERS=$mbfl_a_variable_ONE_IDENTIFIERS
local mbfl_a_variable_TWO_IDENTIFIERS
mbfl_variable_alloc mbfl_a_variable_TWO_IDENTIFIERS
local -a $mbfl_a_variable_TWO_IDENTIFIERS
local -n TWO_IDENTIFIERS=$mbfl_a_variable_TWO_IDENTIFIERS
if ! mbfl_semver_split_prerelease_version $mbfl_a_variable_ONE_IDENTIFIERS "$ONE_PRERELEASE_VERSION"
then return 1
fi
if ! mbfl_semver_split_prerelease_version $mbfl_a_variable_TWO_IDENTIFIERS "$TWO_PRERELEASE_VERSION"
then return 1
fi
local -i i ONE_IS_NUMERIC TWO_IS_NUMERIC MIN
RV=0
if (( ${#ONE_IDENTIFIERS[@]} < ${#TWO_IDENTIFIERS[@]} ))
then MIN=${#ONE_IDENTIFIERS[@]}
else MIN=${#TWO_IDENTIFIERS[@]}
fi
for ((i=0; i < MIN; ++i))
do
mbfl_string_is_digit "${ONE_IDENTIFIERS[$i]}"
ONE_IS_NUMERIC=$?
mbfl_string_is_digit "${TWO_IDENTIFIERS[$i]}"
TWO_IS_NUMERIC=$?
if (( 0 == ONE_IS_NUMERIC && 0 == TWO_IS_NUMERIC ))
then
if   test "${ONE_IDENTIFIERS[$i]}" -lt "${TWO_IDENTIFIERS[$i]}"
then RV=-1 ; break
elif test "${ONE_IDENTIFIERS[$i]}" -gt "${TWO_IDENTIFIERS[$i]}"
then RV=+1 ; break
fi
elif (( 0 == ONE_IS_NUMERIC ))
then RV=+1 ; break ;# ONE is numeric, TWO is not: ONE is lesser according to the standard.
elif (( 0 == TWO_IS_NUMERIC ))
then RV=-1 ; break ;# TWO is numeric, ONE is not: TWO is lesser according to the standard.
else
if   test "${ONE_IDENTIFIERS[$i]}" '<' "${TWO_IDENTIFIERS[$i]}"
then RV=-1 ; break
elif test "${ONE_IDENTIFIERS[$i]}" '>' "${TWO_IDENTIFIERS[$i]}"
then RV=+1 ; break
fi
fi
done
if (( 0 == RV ))
then
if   (( ${#ONE_IDENTIFIERS[@]} < ${#TWO_IDENTIFIERS[@]} ))
then RV=-1
elif (( ${#ONE_IDENTIFIERS[@]} > ${#TWO_IDENTIFIERS[@]} ))
then RV=+1
fi
fi
return 0
}
#!# end of file
