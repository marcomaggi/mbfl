# libmbfl.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: library file
# Date: Fri Nov 28, 2003
#
# Abstract
#
#	This is the library file of MBFL. It must be sourced in shell
#	scripts at the beginning of evaluation.
#
# Copyright (c) 2003-2005, 2009, 2013 Marco Maggi <marcomaggi@gna.org>
#
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  3.0 of the License,  or (at
# your option) any later version.
#
# This library  is distributed in the  hope that it will  be useful, but
# WITHOUT   ANY  WARRANTY;   without  even   the  implied   warranty  of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# Lesser General Public License for more details.
#
# You  should have  received a  copy of  the GNU  Lesser  General Public
# License along  with this library; if  not, write to  the Free Software
# Foundation, Inc.,  59 Temple Place,  Suite 330, Boston,  MA 02111-1307
# USA.
#

mbfl_LOADED_MBFL='yes'

shopt -s expand_aliases

mbfl_LOADED='yes'
: ${script_PROGNAME:='<unknown>'}
: ${script_VERSION:='<unknown>'}
: ${script_COPYRIGHT_YEARS:='<unknown>'}
: ${script_AUTHOR:='<unknown>'}
: ${script_LICENSE:='<unknown>'}
: ${script_USAGE:='<unknown>'}
: ${script_DESCRIPTION:='<unknown>'}
: ${script_EXAMPLES:=}
function mbfl_set_maybe () {
test -n "$1" && eval $1=\'"$2"\'
}
function mbfl_read_maybe_null () {
local VARNAME=${1:?"missing variable name parameter to '${FUNCNAME}'"}
if mbfl_option_null
then IFS= read -rs -d $'\x00' $VARNAME
else IFS= read -rs $VARNAME
fi
}
function mbfl_set_option_test ()   { function mbfl_option_test () { true;  }; }
function mbfl_unset_option_test () { function mbfl_option_test () { false; }; }
mbfl_unset_option_test
function mbfl_set_option_verbose_program ()   { function mbfl_option_verbose_program () { true;  }; }
function mbfl_unset_option_verbose_program () { function mbfl_option_verbose_program () { false; }; }
mbfl_unset_option_verbose_program
function mbfl_set_option_show_program ()   { function mbfl_option_show_program () { true;  }; }
function mbfl_unset_option_show_program () { function mbfl_option_show_program () { false; }; }
mbfl_unset_option_show_program
function mbfl_set_option_verbose ()   { function mbfl_option_verbose () { true;  }; }
function mbfl_unset_option_verbose () { function mbfl_option_verbose () { false; }; }
mbfl_unset_option_verbose
function mbfl_set_option_debug ()   { function mbfl_option_debug () { true;  }; }
function mbfl_unset_option_debug () { function mbfl_option_debug () { false; }; }
mbfl_unset_option_debug
function mbfl_set_option_null ()   { function mbfl_option_null () { true;  }; }
function mbfl_unset_option_null () { function mbfl_option_null () { false; }; }
mbfl_unset_option_null
function mbfl_set_option_interactive ()   { function mbfl_option_interactive () { true;  }; }
function mbfl_unset_option_interactive () { function mbfl_option_interactive () { false; }; }
mbfl_unset_option_interactive
function mbfl_set_option_encoded_args ()   { function mbfl_option_encoded_args () { true;  }; }
function mbfl_unset_option_encoded_args () { function mbfl_option_encoded_args () { false; }; }
mbfl_unset_option_encoded_args
function mbfl_option_test_save () {
mbfl_option_test && mbfl_save_option_TEST=yes
mbfl_unset_option_test
}
function mbfl_option_test_restore () {
test "$mbfl_save_option_TEST" = "yes" && mbfl_set_option_test
}

function mbfl_string_chars () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local i j ch
for ((i=0, j=0; $i < ${#STRING}; ++i, ++j))
do
ch=${STRING:$i:1}
if test "$ch" != $'\\'
then SPLITFIELD[$j]=$ch
else
let ++i
if test $i != "${#STRING}"
then SPLITFIELD[$j]=${ch}${STRING:$i:1}
else
SPLITFIELD[$j]=$ch
fi
fi
done
SPLITCOUNT=$j
return 0
}
function mbfl_string_equal_substring () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local POSITION=${2:?"missing position parameter to '${FUNCNAME}'"}
local PATTERN=${3:?"missing pattern parameter to '${FUNCNAME}'"}
local i
test $(($POSITION+${#PATTERN})) -gt ${#STRING} && return 1
for ((i=0; $i < "${#PATTERN}"; ++i))
do test "${PATTERN:$i:1}" != "${STRING:$(($POSITION+$i)):1}" && \
return 1
done
return 0
}
function mbfl_string_split () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local SEPARATOR=${2:?"missing separator parameter to '${FUNCNAME}'"}
local i j k=0 first=0
for ((i=0; $i < "${#STRING}"; ++i))
do
test $(($i+${#SEPARATOR})) -gt ${#STRING} && break
mbfl_string_equal_substring "${STRING}" $i "${SEPARATOR}" && {
SPLITFIELD[$k]="${STRING:$first:$(($i-$first))}"
let ++k
i=$(($i+${#SEPARATOR}-1))
# place the "first" marker to the beginning of the
# next substring; "i" will be incremented by "for",
# that is why we do "+1" here
first=$(($i+1))
}
done
SPLITFIELD[$k]="${STRING:$first}"
let ++k
SPLITCOUNT=$k
return 0
}
function mbfl_string_first () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local CHAR=${2:?"missing char parameter to '${FUNCNAME}'"}
local BEGIN="${3:-0}"
local i
for ((i=$BEGIN; $i < ${#STRING}; ++i))
do test "${STRING:$i:1}" = "$CHAR" && {
printf "$i\n"
return 0
}
done
return 0
}
function mbfl_string_last () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local CHAR=${2:?"missing char parameter to '${FUNCNAME}'"}
local i="${3:-${#STRING}}"
for ((; $i >= 0; --i))
do test "${STRING:$i:1}" = "$CHAR" && {
printf "$i\n"
return 0
}
done
return 0
}
function mbfl_string_index () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local INDEX=${2:?"missing index parameter to '${FUNCNAME}'"}
printf "${STRING:$INDEX:1}\n"
}
function mbfl_string_is_alpha_char () {
local CHAR=${1:?"missing char parameter to '${FUNCNAME}'"}
! test \( "${CHAR}" \< A -o Z \< "${CHAR}" \) -a \( "${CHAR}" \< a -o z \< "${CHAR}" \)
}
function mbfl_string_is_digit_char () {
local CHAR=${1:?"missing char parameter to '${FUNCNAME}'"}
! test "${CHAR}" \< 0 -o 9 \< "${CHAR}"
}
function mbfl_string_is_alnum_char () {
local CHAR=${1:?"missing char parameter to '${FUNCNAME}'"}
mbfl_string_is_alpha_char "${CHAR}" || mbfl_string_is_digit_char "${CHAR}"
}
function mbfl_string_is_name_char () {
local CHAR=${1:?"missing char parameter to '${FUNCNAME}'"}
mbfl_string_is_alnum_char "${CHAR}" || test "${CHAR}" = _
}
function mbfl_string_is_identifier_char () {
local CHAR=${1:?"missing char parameter to '${FUNCNAME}'"}
mbfl_string_is_alnum_char "${CHAR}" || test "${CHAR}" = '_' -o "${CHAR}" = '-'
}
function mbfl_string_is_noblank_char () {
local CHAR=${1:?"missing char parameter to '${FUNCNAME}'"}
test \( "${CHAR}" != " " \) -a \
\( "${CHAR}" != $'\n' \) -a \( "${CHAR}" != $'\r' \) -a \
\( "${CHAR}" != $'\t' \) -a \( "${CHAR}" != $'\f' \)
}
for class in alpha digit alnum noblank ; do
alias "mbfl_string_is_${class}"="mbfl_p_string_is $class"
done
function mbfl_p_string_is () {
local CLASS=${1:?"missing class parameter to '${FUNCNAME}'"}
local STRING=${2:?"missing string parameter to '${FUNCNAME}'"}
local i
test "${#STRING}" = 0 && return 1
for ((i=0; $i < ${#STRING}; ++i))
do "mbfl_string_is_${CLASS}_char" "${STRING:$i:1}" || return 1
done
return 0
}
function mbfl_string_is_name () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
mbfl_p_string_is name "${STRING}" && ! mbfl_string_is_digit "${STRING:0:1}"
}
function mbfl_string_is_identifier () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
mbfl_p_string_is identifier "${STRING}"		\
&& ! mbfl_string_is_digit "${STRING:0:1}"	\
&& ! test "${STRING:0:1}" = '-'
}
function mbfl_string_is_username () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
mbfl_string_is_identifier "${STRING}"
}
function mbfl_string_range () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local BEGIN=${2:?"missing begin parameter to '${FUNCNAME}'"}
local END="${3:-}"
if test -z "$END" -o "$END" = "end" -o "$END" = "END"
then printf "${STRING:$BEGIN}\n"
else printf "${STRING:$BEGIN:$END}\n"
fi
}
function mbfl_string_replace () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local PATTERN=${2:?"missing pattern parameter to '${FUNCNAME}'"}
local SUBST="${3:-}"
printf "${STRING//$PATTERN/$SUBST}\n"
}
function mbfl_string_skip () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local POSNAME=${2:?"missing position parameter to '${FUNCNAME}'"}
local CHAR=${3:?"missing char parameter to '${FUNCNAME}'"}
local position=${!POSNAME}
while test "${STRING:$position:1}" = "$CHAR" ; do let ++position ; done
eval $POSNAME=$position
}
function mbfl_string_toupper () {
mbfl_p_string_uplo toupper "${1}"
}
function mbfl_string_tolower () {
mbfl_p_string_uplo tolower "${1}"
}
function mbfl_p_string_uplo () {
local MODE=${1:?"missing mode parameter to '${FUNCNAME}'"}
local STRING="${2:-}"
local ch lower upper flag=0
test "${#STRING}" = 0 && return 0
for ch in \
a A b B c C d D e E f F g G h H i I j J k K l L m M \
n N o O p P q Q r R s S t T u U v V w W x X y Y z Z
do
if test $flag = 0
then
lower=$ch
flag=1
else
upper=$ch
if test "${MODE}" = toupper
then STRING="${STRING//$lower/$upper}"
else STRING="${STRING//$upper/$lower}"
fi
flag=0
fi
done
printf "${STRING}\n"
return 0
}
function mbfl_sprintf () {
local VARNAME="${1:?missing variable name parameter in ${FUNCNAME}}"
local FORMAT="${2:?missing format parameter in ${FUNCNAME}}"
local OUTPUT=
shift 2
OUTPUT=$(printf "${FORMAT}" "$@")
eval "${VARNAME}"=\'"${OUTPUT}"\'
}
function mbfl_string_is_equal_unquoted_char () {
local STRING="${1:?missing string parameter to ${FUNCNAME}}"
local pos="${2:?missing position parameter to ${FUNCNAME}}"
local char="${3:?missing known char parameter to ${FUNCNAME}}"
test "${STRING:$pos:1}" = "$char" || mbfl_string_is_quoted_char "$STRING" $pos
}
function mbfl_string_is_quoted_char () {
local STRING="${1:?missing string parameter to ${FUNCNAME}}"
local i="${2:?missing position parameter to ${FUNCNAME}}"
local count
let --i
for ((count=0; $i >= 0; --i))
do
if test "${STRING:$i:1}" = \\
then let ++count
else break
fi
done
let ${count}%2
}
function mbfl_string_quote () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local i ch
for ((i=0; $i < "${#STRING}"; ++i))
do
ch="${STRING:$i:1}"
test "$ch" = \\ && ch=\\\\
printf '%s' "$ch"
done
printf '\n'
return 0
}

function mbfl_decode_hex () {
local INPUT=${1:?"missing input string parameter to '${FUNCNAME}'"}
for ((i=0; $i < ${#INPUT}; i=$(($i + 2)))) ; do
echo -en "\\x${INPUT:$i:2}"
done
echo;# to end the line and let "read" acquire the stuff from a pipeline
}
function mbfl_decode_oct () {
local INPUT=${1:?"missing input string parameter to '${FUNCNAME}'"}
for ((i=0; $i < ${#INPUT}; i=$(($i + 3)))) ; do
echo -en "\\0${INPUT:$i:3}"
done
echo;# to end the line and let "read" acquire the stuff from a pipeline
}

function mbfl_cd () {
local DIRECTORY=${1:?"missing directory parameter to '${FUNCNAME}'"}
shift 1
DIRECTORY=$(mbfl_file_normalise "${DIRECTORY}")
mbfl_message_verbose "entering directory: '${DIRECTORY}'\n"
mbfl_change_directory "${DIRECTORY}" "$@"
}
function mbfl_change_directory () {
local DIRECTORY=${1:?"missing directory parameter to '${FUNCNAME}'"}
shift 1
cd "$@" "${DIRECTORY}" &>/dev/null
}
function mbfl_file_extension () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local i=
for ((i="${#PATHNAME}"; $i >= 0; --i))
do
test "${PATHNAME:$i:1}" = '/' && return
mbfl_string_is_equal_unquoted_char "${PATHNAME}" $i '.' && {
let ++i
printf '%s\n' "${PATHNAME:$i}"
return
}
done
}
function mbfl_file_dirname () {
local PATHNAME="${1:-''}"
local i=
for ((i="${#PATHNAME}"; $i >= 0; --i))
do
test "${PATHNAME:$i:1}" = "/" && {
while test \( $i -gt 0 \) -a \( "${PATHNAME:$i:1}" = "/" \)
do let --i
done
if test $i = 0
then printf '%s\n' "${PATHNAME:$i:1}"
else
let ++i
printf '%s\n' "${PATHNAME:0:$i}"
fi
return 0
}
done
printf '.\n'
return 0
}
function mbfl_file_subpathname () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local BASEDIR=${2:?"missing base directory parameter to '${FUNCNAME}'"}
test "${BASEDIR:$((${#BASEDIR}-1))}" = '/' && \
BASEDIR="${BASEDIR:0:$((${#BASEDIR}-1))}"
if test "${PATHNAME}" = "${BASEDIR}"
then
printf './\n'
return 0
elif test "${PATHNAME:0:${#BASEDIR}}" = "${BASEDIR}"
then
printf  './%s\n' "${PATHNAME:$((${#BASEDIR}+1))}"
return 0
else return 1
fi
}
function mbfl_p_file_remove_dots_from_pathname () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local item i
local SPLITPATH SPLITCOUNT; declare -a SPLITPATH
local output output_counter=0; declare -a output
local input_counter=0
mbfl_file_split "${PATHNAME}"
for ((input_counter=0; $input_counter < $SPLITCOUNT; ++input_counter))
do
case "${SPLITPATH[$input_counter]}" in
.)
;;
..)
let --output_counter
;;
*)
output[$output_counter]="${SPLITPATH[$input_counter]}"
let ++output_counter
;;
esac
done
PATHNAME="${output[0]}"
for ((i=1; $i < $output_counter; ++i))
do PATHNAME="${PATHNAME}/${output[$i]}"
done
printf '%s\n' "${PATHNAME}"
}
function mbfl_file_rootname () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local i="${#PATHNAME}"
test $i = 1 && {
printf '%s\n' "${PATHNAME}"
return 0
}
for ((i="${#PATHNAME}"; $i >= 0; --i))
do
ch="${PATHNAME:$i:1}"
if test "$ch" = "."
then
if test $i -gt 0
then
printf '%s\n' "${PATHNAME:0:$i}"
break
else printf '%s\n' "${PATHNAME}"
fi
elif test "$ch" = "/"
then
printf '%s\n' "${PATHNAME}"
break
fi
done
return 0
}
function mbfl_file_split () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local i=0 last_found=0
mbfl_string_skip "${PATHNAME}" i /
last_found=$i
for ((SPLITCOUNT=0; $i < "${#PATHNAME}"; ++i))
do
test "${PATHNAME:$i:1}" = / && {
SPLITPATH[$SPLITCOUNT]="${PATHNAME:$last_found:$(($i-$last_found))}"
let ++SPLITCOUNT; let ++i
mbfl_string_skip "${PATHNAME}" i /
last_found=$i
}
done
SPLITPATH[$SPLITCOUNT]="${PATHNAME:$last_found}"
let ++SPLITCOUNT
return 0
}
function mbfl_file_tail () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local i=
for ((i="${#PATHNAME}"; $i >= 0; --i))
do
test "${PATHNAME:$i:1}" = "/" && {
let ++i
printf '%s\n' "${PATHNAME:$i}"
return 0
}
done
printf '%s\n' "${PATHNAME}"
return 0
}
function mbfl_file_normalise () {
local pathname="${1:?}"
local prefix="${2}"
local dirname=
local tailname=
local ORGDIR="${PWD}"
if mbfl_file_is_absolute "${pathname}"
then mbfl_p_file_normalise1 "${pathname}"
elif mbfl_file_is_directory "${prefix}"
then
pathname="${prefix}/${pathname}"
mbfl_p_file_normalise1 "${pathname}"
elif test -n "${prefix}"
then
prefix=$(mbfl_p_file_remove_dots_from_pathname "${prefix}")
pathname=$(mbfl_p_file_remove_dots_from_pathname "${pathname}")
pathname=$(mbfl_file_strip_trailing_slash "${pathname}")
printf '%s/%s\n' "${prefix}" "${pathname}"
else mbfl_p_file_normalise1 "${pathname}"
fi
cd "${ORGDIR}" >/dev/null
return 0
}
function mbfl_p_file_normalise1 () {
if mbfl_file_is_directory "${pathname}"
then mbfl_p_file_normalise2 "${pathname}"
else
local tailname=$(mbfl_file_tail "${pathname}")
local dirname=$(mbfl_file_dirname "${pathname}")
if mbfl_file_is_directory "${dirname}"
then mbfl_p_file_normalise2 "${dirname}" "${tailname}"
else
pathname=$(mbfl_file_strip_trailing_slash "${pathname}")
printf '%s\n' "${pathname}"
fi
fi
}
function mbfl_p_file_normalise2 () {
cd "$1" >/dev/null
if test -n "$2"
then echo "${PWD}/$2"
else echo "${PWD}"
fi
cd - >/dev/null
}
function mbfl_file_strip_trailing_slash () {
local pathname=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local len=${#pathname}
test "${pathname:$len}" = '/' && \
pathname=${pathname:1:$(($len-1))}
printf '%s\n' "${pathname}"
}
function mbfl_file_find_tmpdir () {
local TMPDIR="${1:-${mbfl_option_TMPDIR}}"
mbfl_file_directory_is_writable "${TMPDIR}" && {
printf "${TMPDIR}\n"
return 0
}
test -n "${USER}" && {
TMPDIR="/tmp/${USER}"
mbfl_file_directory_is_writable "${TMPDIR}" && {
printf "${TMPDIR}\n"
return 0
}
}
TMPDIR=/tmp
mbfl_file_directory_is_writable "${TMPDIR}" && {
printf "${TMPDIR}\n"
return 0
}
mbfl_message_error "cannot find usable value for 'TMPDIR'"
return 1
}
function mbfl_file_enable_remove () {
mbfl_declare_program rm
mbfl_declare_program rmdir
}
function mbfl_file_remove () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local FLAGS="--force --recursive"
mbfl_option_test || {
mbfl_file_exists "${PATHNAME}" || {
mbfl_message_error "pathname does not exist '${PATHNAME}'"
return 1
}
}
mbfl_exec_rm "${PATHNAME}" ${FLAGS}
}
function mbfl_file_remove_file () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local FLAGS="--force"
mbfl_option_test || {
mbfl_file_is_file "${PATHNAME}" || {
mbfl_message_error "pathname is not a file '${PATHNAME}'"
return 1
}
}
mbfl_exec_rm "${PATHNAME}" ${FLAGS}
}
function mbfl_file_remove_symlink () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local FLAGS="--force"
mbfl_option_test || {
mbfl_file_is_symlink "${PATHNAME}" || {
mbfl_message_error "pathname is not a symboli link '${PATHNAME}'"
return 1
}
}
mbfl_exec_rm "${PATHNAME}" ${FLAGS}
}
function mbfl_file_remove_file_or_symlink () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local FLAGS="--force"
mbfl_option_test || {
mbfl_file_is_file "${PATHNAME}" && ! mbfl_file_is_symlink "${PATHNAME}" || {
mbfl_message_error "pathname is not a file neither a symbolic link '${PATHNAME}'"
return 1
}
}
mbfl_exec_rm "${PATHNAME}" ${FLAGS}
}
function mbfl_exec_rm () {
local RM FLAGS
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
shift
RM=$(mbfl_program_found rm) || exit $?
mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
mbfl_program_exec "${RM}" ${FLAGS} "$@" -- "${PATHNAME}"
}
function mbfl_file_enable_copy () {
mbfl_declare_program cp
}
function mbfl_file_copy () {
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
mbfl_option_test || {
mbfl_file_is_readable "${SOURCE}" || {
mbfl_message_error "copying file '${SOURCE}'"
return 1
}
}
mbfl_file_exists "${TARGET}" && {
if mbfl_file_is_directory "${TARGET}"
then mbfl_message_error "target of copy exists and it is a directory '${TARGET}'"
else mbfl_message_error "target file of copy already exists '${TARGET}'"
fi
return 1
}
mbfl_exec_cp "${SOURCE}" "${TARGET}" "$@"
}
function mbfl_file_copy_to_directory () {
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
mbfl_option_test || {
{ mbfl_file_is_readable    "${SOURCE}" print_error && \
mbfl_file_exists       "${TARGET}" print_error && \
mbfl_file_is_directory "${TARGET}" print_error
} || {
mbfl_message_error "copying file '${SOURCE}'"
return 1
}
}
mbfl_exec_cp_to_dir "${SOURCE}" "${TARGET}" "$@"
}
function mbfl_exec_cp () {
local CP FLAGS
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
CP=$(mbfl_program_found cp) || exit $?
mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
mbfl_program_exec ${CP} ${FLAGS} "$@" -- "${SOURCE}" "${TARGET}"
}
function mbfl_exec_cp_to_dir () {
local CP FLAGS
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
CP=$(mbfl_program_found cp) || exit $?
mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
mbfl_program_exec ${CP} ${FLAGS} "$@" --target-directory="${TARGET}/" -- "${SOURCE}"
}
function mbfl_file_enable_move () {
mbfl_declare_program mv
}
function mbfl_file_move () {
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
mbfl_option_test || {
mbfl_file_pathname_is_readable "${SOURCE}" print_error || {
mbfl_message_error "moving '${SOURCE}'"
return 1
}
}
mbfl_exec_mv "${SOURCE}" "${TARGET}" "$@"
}
function mbfl_file_move_to_directory () {
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
mbfl_option_test || {
{ mbfl_file_pathname_is_readable "${SOURCE}" print_error && \
mbfl_file_exists             "${TARGET}" print_error && \
mbfl_file_is_directory       "${TARGET}" print_error
} || {
mbfl_message_error "moving file '${SOURCE}'"
return 1
}
}
mbfl_exec_mv_to_dir "${SOURCE}" "${TARGET}" "$@"
}
function mbfl_exec_mv () {
local MV FLAGS
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
MV=$(mbfl_program_found mv) || exit $?
mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
mbfl_program_exec ${MV} ${FLAGS} "$@" -- "${SOURCE}" "${TARGET}"
}
function mbfl_exec_mv_to_dir () {
local MV FLAGS
local SOURCE=${1:?"missing source pathname parameter to '${FUNCNAME}'"}
local TARGET=${2:?"missing target pathname parameter to '${FUNCNAME}'"}
shift 2
MV=$(mbfl_program_found mv) || exit $?
mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
mbfl_program_exec ${MV} ${FLAGS} "$@" --target-directory="${TARGET}/" -- "${SOURCE}"
}
function mbfl_file_remove_directory () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local REMOVE_SILENTLY="${2:-no}"
local FLAGS=
mbfl_file_is_directory "${PATHNAME}" || {
mbfl_message_error "pathname is not a directory '${PATHNAME}'"
return 1
}
test "${REMOVE_SILENTLY}" = 'yes' && \
FLAGS="${FLAGS} --ignore-fail-on-non-empty"
mbfl_exec_rmdir "${PATHNAME}" ${FLAGS}
}
function mbfl_file_remove_directory_silently () {
mbfl_file_remove_directory "$1" yes
}
function mbfl_exec_rmdir () {
local RMDIR FLAGS
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
shift
RMDIR=$(mbfl_program_found rmdir) || exit $?
mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
mbfl_program_exec "${RMDIR}" $FLAGS "$@" "${PATHNAME}"
}
function mbfl_file_enable_make_directory () {
mbfl_declare_program mkdir
}
function mbfl_file_make_directory () {
local MKDIR FLAGS
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local PERMISSIONS="${2:-0775}"
MKDIR=$(mbfl_program_found mkdir) || exit $?
FLAGS="--parents --mode=${PERMISSIONS}"
mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
mbfl_program_exec "${MKDIR}" $FLAGS "${PATHNAME}"
}
function mbfl_file_make_if_not_directory () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local PERMISSIONS="${2:-0775}"
mbfl_file_is_directory   "${PATHNAME}" || \
mbfl_file_make_directory "${PATHNAME}" "${PERMISSIONS}"
mbfl_program_reset_sudo_user
}
function mbfl_file_enable_symlink () {
mbfl_declare_program ln
}
function mbfl_file_symlink () {
local LN FLAGS="--symbolic"
local ORIGINAL_NAME=${1:?"missing original name parameter to '${FUNCNAME}'"}
local SYMLINK_NAME=${2:?"missing symbolic link name parameter to '${FUNCNAME}'"}
LN=$(mbfl_program_found ln) || exit $?
mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
mbfl_program_exec "${LN}" ${FLAGS} "${ORIGINAL_NAME}" "${SYMLINK_NAME}"
}
function mbfl_file_enable_listing () {
mbfl_declare_program ls
mbfl_declare_program readlink
}
function mbfl_file_listing () {
local LS
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
shift 1
LS=$(mbfl_program_found ls) || exit $?
mbfl_program_exec ${LS} "$@" "${PATHNAME}"
}
function mbfl_file_long_listing () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local LS_FLAGS='-l'
mbfl_file_listing "${PATHNAME}" "${LS_FLAGS}"
}
function mbfl_file_get_owner () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local LS_FLAGS="-l" OWNER
set -- $(mbfl_file_p_invoke_ls) || return 1
OWNER=$3
test -z "${OWNER}" && {
mbfl_message_error "null owner while inspecting '${PATHNAME}'"
return 1
}
printf '%s\n' "${OWNER}"
}
function mbfl_file_get_group () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local LS_FLAGS="-l" GROUP
set -- $(mbfl_file_p_invoke_ls) || return 1
GROUP=$4
test -z "${GROUP}" && {
mbfl_message_error "null group while inspecting '${PATHNAME}'"
return 1
}
printf '%s\n' "${GROUP}"
}
function mbfl_file_get_size () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
local output LS_FLAGS="-l"
output=$(mbfl_file_p_invoke_ls) || return 1
set -- $output
printf '%s\n' "${5}"
}
function mbfl_file_p_invoke_ls () {
local LS
LS=$(mbfl_program_found ls) || exit $?
mbfl_file_is_directory "${PATHNAME}" && LS_FLAGS="${LS_FLAGS} -d"
mbfl_program_exec ${LS} ${LS_FLAGS} "${PATHNAME}"
}
function mbfl_file_normalise_link () {
local READLINK
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
READLINK=$(mbfl_program_found readlink) || exit $?
mbfl_program_exec "${READLINK}" -fn "${PATHNAME}"
}
function mbfl_file_read_link () {
local READLINK
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
READLINK=$(mbfl_program_found readlink) || exit $?
mbfl_program_exec "${READLINK}" "${PATHNAME}"
}
function mbfl_p_file_print_error_return_result () {
local RESULT=$?
test ${RESULT} != 0 -a "${PRINT_ERROR}" = 'print_error' && \
mbfl_message_error "${ERROR_MESSAGE}"
return $RESULT
}
function mbfl_file_exists () {
test -e "${1}"
}
function mbfl_file_pathname_is_readable () {
local PATHNAME=${1}
local PRINT_ERROR=${2:-no}
local ERROR_MESSAGE="not readable pathname '${PATHNAME}'"
test -n "${PATHNAME}" -a -r "${PATHNAME}"
mbfl_p_file_print_error_return_result
}
function mbfl_file_pathname_is_writable () {
local PATHNAME=${1}
local PRINT_ERROR=${2:-no}
local ERROR_MESSAGE="not writable pathname '${PATHNAME}'"
test -n "${PATHNAME}" -a -w "${PATHNAME}"
mbfl_p_file_print_error_return_result
}
function mbfl_file_pathname_is_executable () {
local PATHNAME=${1}
local PRINT_ERROR=${2:-no}
local ERROR_MESSAGE="not executable pathname '${PATHNAME}'"
test -n "${PATHNAME}" -a -x "${PATHNAME}"
mbfl_p_file_print_error_return_result
}
function mbfl_file_is_file () {
local PATHNAME=${1}
local PRINT_ERROR=${2:-no}
local ERROR_MESSAGE="unexistent file '${PATHNAME}'"
test -n "${PATHNAME}" -a -f "${PATHNAME}"
mbfl_p_file_print_error_return_result
}
function mbfl_file_is_readable () {
local PATHNAME=${1}
local PRINT_ERROR=${2:-no}
mbfl_file_is_file "${PATHNAME}" "${PRINT_ERROR}" && \
mbfl_file_pathname_is_readable "${PATHNAME}" "${PRINT_ERROR}"
}
function mbfl_file_is_writable () {
local PATHNAME=${1}
local PRINT_ERROR=${2:-no}
mbfl_file_is_file "${PATHNAME}" "${PRINT_ERROR}" && \
mbfl_file_pathname_is_writable "${PATHNAME}" "${PRINT_ERROR}"
}
function mbfl_file_is_executable () {
local PATHNAME=${1}
local PRINT_ERROR=${2:-no}
mbfl_file_is_file "${PATHNAME}" "${PRINT_ERROR}" && \
mbfl_file_pathname_is_executable "${PATHNAME}" "${PRINT_ERROR}"
}
function mbfl_file_is_directory () {
local PATHNAME=${1}
local PRINT_ERROR=${2:-no}
local ERROR_MESSAGE="unexistent directory '${PATHNAME}'"
test -n "${PATHNAME}" -a -d "${PATHNAME}"
mbfl_p_file_print_error_return_result
}
function mbfl_file_directory_is_readable () {
local PATHNAME=${1}
local PRINT_ERROR=${2:-no}
mbfl_file_is_directory "${PATHNAME}" "${PRINT_ERROR}" && \
mbfl_file_pathname_is_readable "${PATHNAME}" "${PRINT_ERROR}"
}
function mbfl_file_directory_is_writable () {
local PATHNAME=${1}
local PRINT_ERROR=${2:-no}
mbfl_file_is_directory "${PATHNAME}" "${PRINT_ERROR}" && \
mbfl_file_pathname_is_writable "${PATHNAME}" "${PRINT_ERROR}"
}
function mbfl_file_directory_is_executable () {
local PATHNAME=${1}
local PRINT_ERROR=${2:-no}
mbfl_file_is_directory "${PATHNAME}" "${PRINT_ERROR}" && \
mbfl_file_pathname_is_executable "${PATHNAME}" "${PRINT_ERROR}"
}
function mbfl_file_directory_validate_writability () {
local code
local DIRECTORY=${1:?"missing directory pathname parameter to '${FUNCNAME}'"}
local DESCRIPTION=${2:?"missing directory description parameter to '${FUNCNAME}'"}
mbfl_message_verbose "validating ${DESCRIPTION} directory '${DIRECTORY}'\n"
mbfl_file_is_directory              "${DIRECTORY}" print_error && \
mbfl_file_directory_is_writable     "${DIRECTORY}" print_error
code=$?
test $code != 0 && mbfl_message_error \
"unwritable ${DESCRIPTION} directory '${DIRECTORY}'"
return $code
}
function mbfl_file_is_symlink () {
local PATHNAME=${1}
local PRINT_ERROR=${2:-no}
local ERROR_MESSAGE="not a symbolic link pathname '${PATHNAME}'"
test -n "${PATHNAME}" -a -L "${PATHNAME}"
mbfl_p_file_print_error_return_result
}
function mbfl_file_is_absolute () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
test "${PATHNAME:0:1}" = /
}
function mbfl_file_is_absolute_dirname () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_file_is_directory "${PATHNAME}" && mbfl_file_is_absolute "${PATHNAME}"
}
function mbfl_file_is_absolute_filename () {
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
mbfl_file_is_file "${PATHNAME}" && mbfl_file_is_absolute "${PATHNAME}"
}
function mbfl_file_enable_tar () {
mbfl_declare_program tar
}
function mbfl_tar_create_to_stdout () {
local DIRECTORY=${1:?"missing directory name parameter to '${FUNCNAME}'"}
shift
mbfl_tar_exec --directory="${DIRECTORY}" --create --file=- "$@" .
}
function mbfl_tar_extract_from_stdin () {
local DIRECTORY=${1:?"missing directory name parameter to '${FUNCNAME}'"}
shift
mbfl_tar_exec --directory="${DIRECTORY}" --extract --file=- "$@"
}
function mbfl_tar_extract_from_file () {
local DIRECTORY=${1:?"missing directory name parameter to '${FUNCNAME}'"}
local ARCHIVE_FILENAME=${2:?"missing archive pathname parameter to '${FUNCNAME}'"}
shift 2
mbfl_tar_exec --directory="${DIRECTORY}" --extract --file="${ARCHIVE_FILENAME}" "$@"
}
function mbfl_tar_create_to_file () {
local DIRECTORY=${1:?"missing directory name parameter to '${FUNCNAME}'"}
local ARCHIVE_FILENAME=${2:?"missing archive pathname parameter to '${FUNCNAME}'"}
shift 2
mbfl_tar_exec --directory="${DIRECTORY}" --create --file="${ARCHIVE_FILENAME}" "$@" .
}
function mbfl_tar_archive_directory_to_file () {
local PARENT DIRNAME
local DIRECTORY=${1:?"missing directory name parameter to '${FUNCNAME}'"}
local ARCHIVE_FILENAME=${2:?"missing archive pathname parameter to '${FUNCNAME}'"}
shift 2
PARENT=$(mbfl_file_dirname "${DIRECTORY}")
DIRNAME=$(mbfl_file_tail "${DIRECTORY}")
mbfl_tar_exec --directory="${PARENT}" --create \
--file="${ARCHIVE_FILENAME}" "$@" "${DIRNAME}"
}
function mbfl_tar_list () {
local ARCHIVE_FILENAME=${1:?"missing archive pathname parameter to '${FUNCNAME}'"}
shift
mbfl_tar_exec --list --file="${ARCHIVE_FILENAME}" "$@"
}
function mbfl_tar_exec () {
local TAR FLAGS
TAR=$(mbfl_program_found tar) || exit $?
mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
mbfl_program_exec "${TAR}" ${FLAGS} "$@"
}
function mbfl_file_enable_permissions () {
mbfl_declare_program ls
mbfl_declare_program cut
mbfl_declare_program chmod
}
function mbfl_file_get_permissions () {
local LS CUT SYMBOLIC OWNER GROUP OTHER
local PATHNAME=${1:?"missing pathname parameter to '${FUNCNAME}'"}
LS=$(mbfl_program_found ls)   || exit $?
CUT=$(mbfl_program_found cut) || exit $?
SYMBOLIC=$(mbfl_program_exec ${LS} -ld "${PATHNAME}" | \
mbfl_program_exec ${CUT} -d' ' -f1) || return $?
mbfl_message_debug "symbolic permissions '${SYMBOLIC}'"
OWNER=${SYMBOLIC:1:3}
GROUP=${SYMBOLIC:4:3}
OTHER=${SYMBOLIC:7:3}
OWNER=$(mbfl_system_symbolic_to_octal_permissions "${OWNER}")
GROUP=$(mbfl_system_symbolic_to_octal_permissions "${GROUP}")
OTHER=$(mbfl_system_symbolic_to_octal_permissions "${OTHER}")
printf '0%d%d%d\n' "${OWNER}" "${GROUP}" "${OTHER}"
}
function mbfl_file_set_permissions () {
local CHMOD
local PERMISSIONS=${1:?"missing permissions parameter to '${FUNCNAME}'"}
local PATHNAME=${2:?"missing pathname parameter to '${FUNCNAME}'"}
CHMOD=$(mbfl_program_found chmod) || exit $?
mbfl_program_exec ${CHMOD} "${PERMISSIONS}" "${PATHNAME}"
}
function mbfl_file_append () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local FILENAME=${2:?"missing file name parameter to '${FUNCNAME}'"}
mbfl_program_bash_command "printf '%s' '${STRING}' >>'${FILENAME}'"
}
function mbfl_file_write () {
local STRING=${1:?"missing string parameter to '${FUNCNAME}'"}
local FILENAME=${2:?"missing file name parameter to '${FUNCNAME}'"}
mbfl_program_bash_command "printf '%s' '${STRING}' >'${FILENAME}'"
}
function mbfl_file_read () {
local FILENAME=${1:?"missing file name parameter to '${FUNCNAME}'"}
mbfl_program_bash_command "printf '%s' \"\$(<${FILENAME})\""
}
mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_gzip
mbfl_p_file_compress_KEEP_ORIGINAL='no'
mbfl_p_file_compress_TO_STDOUT='no'
function mbfl_file_enable_compress () {
mbfl_declare_program gzip
mbfl_declare_program bzip2
mbfl_file_compress_select_gzip
mbfl_file_compress_nokeep
}
function mbfl_file_compress_keep ()     { mbfl_p_file_compress_KEEP_ORIGINAL='yes'; }
function mbfl_file_compress_nokeep ()   { mbfl_p_file_compress_KEEP_ORIGINAL='no'; }
function mbfl_file_compress_stdout ()   { mbfl_p_file_compress_TO_STDOUT='yes'; }
function mbfl_file_compress_nostdout () { mbfl_p_file_compress_TO_STDOUT='no'; }
function mbfl_file_compress_select_gzip () {
mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_gzip
}
function mbfl_file_compress_select_bzip () {
mbfl_p_file_compress_FUNCTION=mbfl_p_file_compress_bzip
}
function mbfl_file_compress () {
local FILE=${1:?"missing target file parameter to '${FUNCNAME}'"}
shift
mbfl_p_file_compress compress "${FILE}" "$@"
}
function mbfl_file_decompress () {
local FILE=${1:?"missing target file parameter to '${FUNCNAME}'"}
shift
mbfl_p_file_compress decompress "${FILE}" "$@"
}
function mbfl_p_file_compress () {
local MODE=${1:?"missing compression/decompression mode parameter to '${FUNCNAME}'"}
local FILE=${2:?"missing target file parameter to '${FUNCNAME}'"}
shift 2
mbfl_file_is_file "${FILE}" || {
mbfl_message_error "compression target is not a file '${FILE}'"
return 1
}
${mbfl_p_file_compress_FUNCTION} ${MODE} "${FILE}" "$@"
}
function mbfl_p_file_compress_gzip () {
local COMPRESSOR FLAGS DEST
local COMPRESS=${1:?"missing compress/decompress mode parameter to '${FUNCNAME}'"}
local SOURCE=${2:?"missing target file parameter to '${FUNCNAME}'"}
shift 2
COMPRESSOR=$(mbfl_program_found gzip) || exit $?
case "${COMPRESS}" in
compress)
DEST=${SOURCE}.gz
;;
decompress)
DEST=$(mbfl_file_rootname "${SOURCE}")
FLAGS="${FLAGS} --decompress"
;;
*)
mbfl_message_error "internal error: wrong mode '${COMPRESS}' in '${FUNCNAME}'"
exit_failure
;;
esac
mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
if test "${mbfl_p_file_compress_TO_STDOUT}" = yes
then
FLAGS="${FLAGS} --stdout"
mbfl_program_exec "${COMPRESSOR}" ${FLAGS} "$@" "${SOURCE}"
else
if test "${mbfl_p_file_compress_KEEP_ORIGINAL}" = yes
then
FLAGS="${FLAGS} --stdout"
mbfl_program_exec "${COMPRESSOR}" ${FLAGS} "$@" "${SOURCE}" >"${DEST}"
else mbfl_program_exec "${COMPRESSOR}" ${FLAGS} "$@" "${SOURCE}"
fi
fi
}
function mbfl_p_file_compress_bzip () {
local COMPRESSOR FLAGS DEST
local COMPRESS=${1:?"missing compress/decompress mode parameter to '${FUNCNAME}'"}
local SOURCE=${2:?"missing target file parameter to '${FUNCNAME}'"}
shift 2
COMPRESSOR=$(mbfl_program_found bzip2) || exit $?
case "${COMPRESS}" in
compress)
DEST=${SOURCE}.bz2
FLAGS="${FLAGS} --compress"
;;
decompress)
DEST=$(mbfl_file_rootname "${SOURCE}")
FLAGS="${FLAGS} --decompress"
;;
*)
mbfl_message_error "internal error: wrong mode '${COMPRESS}' in '${FUNCNAME}'"
exit_failure
;;
esac
mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
if test "${mbfl_p_file_compress_TO_STDOUT}" = yes
then
FLAGS="${FLAGS} --keep --stdout"
mbfl_program_exec "${COMPRESSOR}" ${FLAGS} "$@" "${SOURCE}"
else
test "${mbfl_p_file_compress_KEEP_ORIGINAL}" = yes && \
FLAGS="${FLAGS} --keep"
mbfl_program_exec "${COMPRESSOR}" ${FLAGS} "$@" "${SOURCE}"
fi
}

test "$mbfl_INTERACTIVE" = yes || {
declare -A mbfl_action_sets_EXISTS
declare -A mbfl_action_sets_SUBSETS
declare -A mbfl_action_sets_KEYWORDS
declare -A mbfl_action_sets_DESCRIPTIONS
declare -A mbfl_action_sets_IDENTIFIERS
declare mbfl_action_sets_SELECTED_SET=MAIN
}
function mbfl_declare_action_set () {
local ACTION_SET=${1:?"missing action set parameter to '${FUNCNAME}'"}
if mbfl_string_is_name "$ACTION_SET"
then
if test -z "${mbfl_action_sets_EXISTS[${ACTION_SET}]}"
then mbfl_action_sets_EXISTS[${ACTION_SET}]=yes
else
mbfl_message_error "action set declared twice: \"$ACTION_SET\""
# exit_because_invalid_action_declaration
exit 96
fi
else
mbfl_message_error "invalid action set identifier: \"$ACTION_SET\""
exit 96
fi
}
function mbfl_declare_action () {
local ACTION_SET=${1:?"missing action set parameter to '${FUNCNAME}'"}
local ACTION_KEYWORD=${2:?"missing keyword parameter to '${FUNCNAME}'"}
local ACTION_SUBSET=${3:?"missing subset parameter to '${FUNCNAME}'"}
local ACTION_IDENTIFIER=${4:?"missing identifier parameter to '${FUNCNAME}'"}
local ACTION_DESCRIPTION=${5:?"missing description parameter to '${FUNCNAME}'"}
local KEY="${ACTION_SET}-${ACTION_IDENTIFIER}"
if ! mbfl_string_is_identifier "$ACTION_IDENTIFIER"
then
mbfl_message_error "internal error: invalid action identifier: $ACTION_IDENTIFIER"
exit_because_invalid_action_declaration
fi
if mbfl_string_is_name "$ACTION_KEYWORD"
then mbfl_action_sets_KEYWORDS[${KEY}]=${ACTION_KEYWORD}
else
mbfl_message_error "internal error: invalid keyword for action \"$ACTION_IDENTIFIER\": \"$ACTION_KEYWORD\""
exit_because_invalid_action_declaration
fi
if mbfl_actions_set_exists_or_none "$ACTION_SUBSET"
then mbfl_action_sets_SUBSETS[${KEY}]=$ACTION_SUBSET
else
mbfl_message_error \
"internal error: invalid or non-existent action subset identifier for action \"$ACTION_IDENTIFIER\": \"$ACTION_SUBSET\""
exit_because_invalid_action_declaration
fi
mbfl_action_sets_DESCRIPTIONS[${KEY}]=$ACTION_DESCRIPTION
mbfl_action_sets_IDENTIFIERS[${ACTION_SET}]="${mbfl_action_sets_IDENTIFIERS[${ACTION_SET}]} ${ACTION_IDENTIFIER}"
return 0
}
function mbfl_actions_set_exists () {
local ACTION_SET=${1:?"missing action set parameter to '${FUNCNAME}'"}
mbfl_string_is_name "$ACTION_SET" \
&& test "${mbfl_action_sets_EXISTS[${ACTION_SET}]}" \
-a "${mbfl_action_sets_EXISTS[${ACTION_SET}]}" = yes
}
function mbfl_actions_set_exists_or_none () {
local ACTION_SET=${1:?"missing action set parameter to '${FUNCNAME}'"}
mbfl_string_is_name "$ACTION_SET" && \
test "$ACTION_SET" = NONE \
-o \( "${mbfl_action_sets_EXISTS[${ACTION_SET}]}" -a "${mbfl_action_sets_EXISTS[${ACTION_SET}]}" = yes \)
}
function mbfl_actions_dispatch () {
local ACTION_SET=${1:?"missing action set parameter to '${FUNCNAME}'"}
if ! mbfl_actions_set_exists "${ACTION_SET}"
then
mbfl_message_error "invalid action identifier: \"${ACTION_SET}\""
return 1
fi
if test $ARG1ST = $ARGC1
then return 0
fi
local IDENTIFIER=${ARGV1[$ARG1ST]}
local KEY="${ACTION_SET}-${IDENTIFIER}"
local ACTION_SUBSET=${mbfl_action_sets_SUBSETS[${KEY}]}
local ACTION_KEYWORD=${mbfl_action_sets_KEYWORDS[${KEY}]}
if test -z "${ACTION_KEYWORD}"
then
return 0
else
let ++ARG1ST
mbfl_main_set_before_parsing_options "script_before_parsing_options_$ACTION_KEYWORD"
mbfl_main_set_after_parsing_options  "script_after_parsing_options_$ACTION_KEYWORD"
mbfl_main_set_main "script_action_$ACTION_KEYWORD"
mbfl_action_sets_SELECTED_SET=$ACTION_SUBSET
if test "${ACTION_SUBSET}" != NONE
then
mbfl_actions_dispatch "${ACTION_SUBSET}"
else
return 0
fi
fi
}
function mbfl_actions_fake_action_set () {
local ACTION_SET=${1:?"missing action set parameter to '${FUNCNAME}'"}
if mbfl_actions_set_exists "$ACTION_SET"
then
mbfl_action_sets_SELECTED_SET=$ACTION_SET
return 0
else return 1
fi
}
function mbfl_actions_print_usage_screen () {
local ACTION_SET=$mbfl_action_sets_SELECTED_SET
if test -n "$ACTION_SET" -a "$ACTION_SET" != NONE
then
printf 'Action commands:\n\n'
local ACTION_IDENTIFIER KEY
for ACTION_IDENTIFIER in ${mbfl_action_sets_IDENTIFIERS[${ACTION_SET}]}
do
KEY="${ACTION_SET}-${ACTION_IDENTIFIER}"
printf '\t%s [options] [arguments]\n\t\t%s\n\n' \
"${ACTION_IDENTIFIER}" "${mbfl_action_sets_DESCRIPTIONS[${KEY}]}"
done
fi
return 0
}

test "$mbfl_INTERACTIVE" = yes || {
declare -i mbfl_getopts_INDEX=0
declare -a mbfl_getopts_KEYWORDS
declare -a mbfl_getopts_DEFAULTS
declare -a mbfl_getopts_BRIEFS
declare -a mbfl_getopts_LONGS
declare -a mbfl_getopts_HASARG
declare -a mbfl_getopts_DESCRIPTION
}
test "$mbfl_INTERACTIVE" = yes || {
mbfl_message_DEFAULT_OPTIONS="
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
}
function mbfl_declare_option () {
local keyword="$1"
local default="$2"
local brief="$3"
local long="$4"
local hasarg="$5"
local description="$6"
local index=$(($mbfl_getopts_INDEX + 1))
mbfl_p_declare_option_test_length $keyword keyword $index
mbfl_getopts_KEYWORDS[$mbfl_getopts_INDEX]=$(mbfl_string_toupper "$keyword")
mbfl_getopts_BRIEFS[$mbfl_getopts_INDEX]=$brief
mbfl_getopts_LONGS[$mbfl_getopts_INDEX]=$long
mbfl_p_declare_option_test_length $hasarg hasarg $index
test "$hasarg" != witharg -a "$hasarg" != noarg && {
mbfl_message_error \
"wrong value '$hasarg' to hasarg field in option declaration number $index"
exit_because_invalid_option_declaration
}
mbfl_getopts_HASARG[$mbfl_getopts_INDEX]=$hasarg
test "$hasarg" = noarg -a "$default" != yes -a "$default" != no && {
mbfl_message_error \
"wrong value '$default' as default for option with no argument number $index"
exit_because_invalid_option_declaration
}
mbfl_getopts_DEFAULTS[$mbfl_getopts_INDEX]=$default
mbfl_p_declare_option_test_length $description description $index
mbfl_getopts_DESCRIPTION[$mbfl_getopts_INDEX]=$description
mbfl_getopts_INDEX=$index
eval script_option_$(mbfl_string_toupper $keyword)=\'"$default"\'
if test ${keyword:0:7} = ACTION_
then
if test "${hasarg}" = noarg
then
if test "${default}" = yes
then mbfl_main_set_main script_$(mbfl_string_tolower $keyword)
fi
else
mbfl_message_error "action option must be with no argument '$keyword'"
return 1
fi
fi
return 0
}
function mbfl_p_declare_option_test_length () {
local value=$1
local value_name=$2
local option_number=$3
if test -z "$value"
then
mbfl_message_error "null $value_name in declared option number $option_number"
exit_because_invalid_option_declaration
fi
}
function mbfl_getopts_parse () {
local p_OPT= p_OPTARG= argument= i
local found_end_of_options_delimiter=0 retval
for ((i=${ARG1ST}; $i < ${ARGC1}; ++i))
do
argument="${ARGV1[$i]}"
if test "$found_end_of_options_delimiter" = 1
then
ARGV[$ARGC]="${argument}"
let ++ARGC
elif test "${argument}" = '--'
then found_end_of_options_delimiter=1
elif \
mbfl_getopts_isbrief "${argument}" p_OPT || \
mbfl_getopts_islong  "${argument}" p_OPT
then
mbfl_getopts_p_process_predefined_option_no_arg "${p_OPT}"
retval=$?
if test $retval != 0
then return $retval
fi
elif \
mbfl_getopts_isbrief_with "${argument}" p_OPT p_OPTARG || \
mbfl_getopts_islong_with  "${argument}" p_OPT p_OPTARG
then
mbfl_getopts_p_process_predefined_option_with_arg "${p_OPT}" "${p_OPTARG}"
retval=$?
if test $retval != 0
then return $retval
fi
else
test $i = 0 && found_possible_action_argument=1
ARGV[$ARGC]="${argument}"
let ++ARGC
fi
done
mbfl_option_encoded_args && {
for ((i=0; $i < $ARGC; ++i))
do ARGV[$i]=$(mbfl_decode_hex "${ARGV[$i]}")
done
}
return 0
}
function mbfl_getopts_p_process_script_option () {
local OPT=${1:?"missing option name parameter to '${FUNCNAME}'"}
local OPTARG="${2:-}"
local i=0 value brief long hasarg keyword tolower_keyword update_procedure state_variable
for ((i=0; $i < $mbfl_getopts_INDEX; ++i))
do
keyword="${mbfl_getopts_KEYWORDS[$i]}"
brief="${mbfl_getopts_BRIEFS[$i]}"
long="${mbfl_getopts_LONGS[$i]}"
hasarg="${mbfl_getopts_HASARG[$i]}"
test \( -n "$OPT" \) -a \
\( \( -n "$brief" -a "$brief" = "$OPT" \) -o \
\( -n "$long"  -a "$long"  = "$OPT" \) \) && {
if test "$hasarg" = "witharg"
then
if test -z "$OPTARG"
then
mbfl_message_error "expected non-empty argument for option: \"$OPT\""
return 1
fi
if mbfl_option_encoded_args
then value=$(mbfl_decode_hex "${OPTARG}")
else value="$OPTARG"
fi
else value="yes"
fi
tolower_keyword=$(mbfl_string_tolower ${keyword})
test ${keyword:0:7} = ACTION_ && \
mbfl_main_set_main script_${tolower_keyword}
update_procedure=script_option_update_${tolower_keyword}
state_variable=script_option_${keyword}
eval ${state_variable}=\'"${value}"\'
mbfl_invoke_script_function ${update_procedure}
return 0
}
done
mbfl_message_error "unknown option \"${OPT}\""
return 1
}
function mbfl_getopts_p_process_predefined_option_no_arg () {
local OPT=${1:?"missing option name parameter to '${FUNCNAME}'"}
local i=0
case "${OPT}" in
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
show-program)
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
mbfl_getopts_p_process_script_option "${OPT}"
return $?
;;
esac
return 0
}
function mbfl_getopts_p_process_predefined_option_with_arg () {
local OPT=${1:?"missing option name parameter to '${FUNCNAME}'"}
local OPTARG=${2:?"missing option argument parameter to '${FUNCNAME}'"}
if test -z "$OPTARG"
then
mbfl_message_error "empty value given to option \"${OPT}\" requiring argument"
exit_because_invalid_option_argument
fi
mbfl_option_encoded_args && OPTARG=$(mbfl_decode_hex "${OPTARG}")
case "${OPT}" in
tmpdir)
mbfl_option_TMPDIR="${OPTARG}"
;;
print-exit-code)
mbfl_main_print_exit_code "${OPTARG}"
exit 0
;;
print-exit-code-names|print-exit-code-name)
mbfl_main_print_exit_code_names "${OPTARG}"
exit 0
;;
*)
mbfl_getopts_p_process_script_option "${OPT}" "${OPTARG}"
return $?
;;
esac
return 0
}
function mbfl_getopts_print_usage_screen () {
local BRIEF_OR_LONG=${1:?"missing brief or long selection parameter to '${FUNCNAME}'"}
local i=0 item brief long description long_hasarg long_hasarg default
printf 'Options:\n'
if test $mbfl_getopts_INDEX = 0
then printf '\tNo script-specific options.\n'
else
for ((i=0; $i < $mbfl_getopts_INDEX; ++i))
do
if test "${mbfl_getopts_HASARG[$i]}" = 'witharg'
then
brief_hasarg="VALUE"
long_hasarg="=VALUE"
else
brief_hasarg=
long_hasarg=
fi
printf '\t'
brief="${mbfl_getopts_BRIEFS[$i]}"
test -n "$brief" && printf -- '-%s%s ' "${brief}" "${brief_hasarg}"
long="${mbfl_getopts_LONGS[$i]}"
test -n "$long" && printf -- '--%s%s' "${long}" "${long_hasarg}"
printf '\n'
description="${mbfl_getopts_DESCRIPTION[$i]}"
test -z "${description}" && description='undocumented option'
printf '\t\t%s\n' "${description}"
if test "${mbfl_getopts_HASARG[$i]}" = 'witharg'
then
item="${mbfl_getopts_DEFAULTS[$i]}"
if test -n "${item}"
then default=$(printf "'%s'" "${item}")
else default='empty'
fi
printf '\t\t(default: %s)\n' "${default}"
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
if test ${BRIEF_OR_LONG} = long
then
printf 'Common options:\n'
printf "${mbfl_message_DEFAULT_OPTIONS}"
printf '\n'
fi
}
function mbfl_getopts_islong () {
local ARGUMENT=${1:?"missing argument parameter to '${FUNCNAME}'"}
local OPTION_VARIABLE_NAME="${2:-}"
local len="${#ARGUMENT}" i ch
test $len -lt 3 -o "${ARGUMENT:0:2}" != "--"  && return 1
for ((i=2; $i < $len; ++i)); do
ch="${ARGUMENT:$i:1}"
mbfl_p_getopts_not_char_in_long_option_name "$ch" && return 1
done
mbfl_set_maybe "${OPTION_VARIABLE_NAME}" "${ARGUMENT:2}"
return 0
}
function mbfl_getopts_islong_with () {
local ARGUMENT=${1:?"missing argument parameter to '${FUNCNAME}'"}
local OPTION_VARIABLE_NAME="${2:-}"
local VALUE_VARIABLE_NAME="${3:-}"
local len="${#ARGUMENT}" equal_position
test $len -lt 5 && return 1
equal_position=$(mbfl_string_first "${ARGUMENT}" =)
test -z "$equal_position" -o $(($equal_position + 1)) = $len && return 1
mbfl_getopts_islong "${ARGUMENT:0:$equal_position}" || return 1
mbfl_set_maybe "${OPTION_VARIABLE_NAME}" "${ARGUMENT:2:$(($equal_position - 2))}"
mbfl_set_maybe "${VALUE_VARIABLE_NAME}"  "${ARGUMENT:$(($equal_position + 1))}"
return 0
}
function mbfl_p_getopts_not_char_in_long_option_name () {
test \
\( "$1" \< A -o Z \< "$1" \) -a \
\( "$1" \< a -o z \< "$1" \) -a \
\( "$1" \< 0 -o 9 \< "$1" \) -a \
"$1" != _ -a "$1" != -
}
function mbfl_getopts_isbrief () {
local COMMAND_LINE_ARGUMENT=${1:?"missing command line argument parameter to '${FUNCNAME}'"}
local OPTION_VARIABLE_NAME="${2:-}"
local ch
test "${#COMMAND_LINE_ARGUMENT}" = 2 -a \
"${COMMAND_LINE_ARGUMENT:0:1}" = "-" || return 1
mbfl_p_getopts_not_char_in_brief_option_name \
"${COMMAND_LINE_ARGUMENT:1:1}" && return 1
mbfl_set_maybe "${OPTION_VARIABLE_NAME}" "${COMMAND_LINE_ARGUMENT:1}"
return 0
}
function mbfl_getopts_isbrief_with () {
local COMMAND_LINE_ARGUMENT=${1:?"missing command line argument parameter to '${FUNCNAME}'"}
local OPTION_VARIABLE_NAME="${2:-}"
local VALUE_VARIABLE_NAME="${3:-}"
test "${#COMMAND_LINE_ARGUMENT}" -gt 2 -a \
"${COMMAND_LINE_ARGUMENT:0:1}" = "-" || return 1
mbfl_p_getopts_not_char_in_brief_option_name \
"${COMMAND_LINE_ARGUMENT:1:1}" && return 1
mbfl_set_maybe "${OPTION_VARIABLE_NAME}" "${COMMAND_LINE_ARGUMENT:1:1}"
local QUOTED_VALUE=$(mbfl_string_quote "${COMMAND_LINE_ARGUMENT:2}")
mbfl_set_maybe "${VALUE_VARIABLE_NAME}" "${QUOTED_VALUE}"
return 0
}
function mbfl_p_getopts_not_char_in_brief_option_name () {
test \
\( "$1" \< A -o Z \< "$1" \) -a \
\( "$1" \< a -o z \< "$1" \) -a \
\( "$1" \< 0 -o 9 \< "$1" \)
}
function mbfl_wrong_num_args () {
local required=${1:?"missing required number of args parameter to '${FUNCNAME}'"}
local argc=${2:?"missing given number of args parameter to '${FUNCNAME}'"}
test $required != $argc && {
mbfl_message_error "number of arguments required: $required"
return 1
}
return 0
}
function mbfl_wrong_num_args_range () {
local min_required=${1:?"missing minimum required number of args parameter to '${FUNCNAME}'"}
local max_required=${2:?"missing maximum required number of args parameter to '${FUNCNAME}'"}
local argc=${3:?"missing given number of args parameter to '${FUNCNAME}'"}
test $min_required -gt $argc -o $max_required -lt $argc && {
mbfl_message_error \
"number of required arguments between $min_required and $max_required but given $argc"
return 1
}
return 0
}
function mbfl_argv_from_stdin () {
local item=
test $ARGC -ne 0 && {
while mbfl_read_maybe_null item
do
ARGV[${ARGC}]=${item}
let ++ARGC
done
}
return 0
}
function mbfl_argv_all_files () {
local i item
for ((i=0; $i < $ARGC; ++i))
do
item=$(mbfl_file_normalise "${ARGV[$i]}")
test -f "${item}" || {
mbfl_message_error "unexistent file '${item}'"
return 1
}
ARGV[$i]=${item}
done
return 0
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
test $(($i+1)) -lt ${#mbfl_getopts_LONGS[@]} && echo -n ' '
done
echo
return 0
}

mbfl_message_PROGNAME=$script_PROGNAME
mbfl_message_CHANNEL=2
function mbfl_message_set_progname () {
mbfl_message_PROGNAME=${1:?$FUNCNAME error: missing program name argument}
}
function mbfl_message_set_channel () {
mbfl_message_CHANNEL=${1:?$FUNCNAME error: missing channel argument}
}
function mbfl_message_p_print () {
printf "${2:?$1 error: missing argument}" >&$mbfl_message_CHANNEL
}
function mbfl_message_p_print_prefix () {
mbfl_message_p_print $1 "$mbfl_message_PROGNAME: $2"
}
function mbfl_message_string () {
mbfl_message_p_print $FUNCNAME "$1"
return 0
}
function mbfl_message_verbose () {
mbfl_option_verbose && mbfl_message_p_print_prefix $FUNCNAME "$1"
return 0
}
function mbfl_message_verbose_end () {
mbfl_option_verbose && mbfl_message_p_print $FUNCNAME "$1\n"
return 0
}
function mbfl_message_verbose_printf () {
mbfl_option_verbose && {
printf '%s: ' "$mbfl_message_PROGNAME" >&$mbfl_message_CHANNEL
printf "$@" >&$mbfl_message_CHANNEL
}
return 0
}
function mbfl_message_debug () {
mbfl_option_debug && mbfl_message_p_print_prefix $FUNCNAME "debug: $1\n"
return 0
}
function mbfl_message_debug_printf () {
mbfl_option_debug && {
{
printf '%s: debug: ' "$mbfl_message_PROGNAME"
printf "$@"
echo
} >&$mbfl_message_CHANNEL
}
return 0
}
function mbfl_message_warning () {
mbfl_message_p_print_prefix $FUNCNAME "warning: $1\n"
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
function mbfl_message_error () {
mbfl_message_p_print_prefix $FUNCNAME "error: $1\n"
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

function mbfl_program_find () {
local PROGRAM=${1:?"missing program parameter to '${FUNCNAME}'"}
local item
for item in $(type -ap "$PROGRAM")
do
if mbfl_file_is_executable "$item"
then
printf "%s\n" "$item"
return 0
fi
done
return 0
}
declare mbfl_program_SUDO_USER=nosudo
declare mbfl_program_STDERR_TO_STDOUT=no
declare mbfl_program_BASH=$BASH
declare mbfl_program_BGPID
function mbfl_program_enable_sudo () {
mbfl_declare_program sudo
mbfl_declare_program whoami
}
function mbfl_program_declare_sudo_user () {
local PERSONA=${1:?"missing sudo user name parameter to '${FUNCNAME}'"}
if mbfl_string_is_username "${PERSONA}"
then mbfl_program_SUDO_USER=${PERSONA}
else
mbfl_message_error_printf 'attempt to select invalid "sudo" user: "%s"' "${PERSONA}"
exit_because_invalid_username
fi
}
function mbfl_program_reset_sudo_user () {
mbfl_program_SUDO_USER=nosudo
}
function mbfl_program_sudo_user () {
printf '%s\n' "$mbfl_program_SUDO_USER"
}
function mbfl_program_requested_sudo () {
test "$mbfl_program_SUDO_USER" != nosudo
}
function mbfl_program_redirect_stderr_to_stdout () {
mbfl_program_STDERR_TO_STDOUT=yes
}
function mbfl_program_exec () {
local PERSONA=$mbfl_program_SUDO_USER USE_SUDO=no SUDO WHOAMI
local STDERR_TO_STDOUT=no
mbfl_program_SUDO_USER=nosudo
test "$PERSONA" = nosudo || {
SUDO=$(mbfl_program_found sudo)     || exit $?
WHOAMI=$(mbfl_program_found whoami) || exit $?
USE_SUDO=yes
}
STDERR_TO_STDOUT=${mbfl_program_STDERR_TO_STDOUT}
mbfl_program_STDERR_TO_STDOUT=no
{ mbfl_option_test || mbfl_option_show_program; } && {
if test "$USE_SUDO" = yes -a "$PERSONA" != "$USER"
then echo "$SUDO" -u "$PERSONA" "$@" >&2
else echo "$@" >&2
fi
}
mbfl_option_test || {
if test "$USE_SUDO" = yes
then
test "$PERSONA" = $("$WHOAMI") || {
if test "$STDERR_TO_STDOUT" = yes
then "$SUDO" -u "$PERSONA" "$@" 2>&1
else "$SUDO" -u "$PERSONA" "$@"
fi
}
else
if test "$STDERR_TO_STDOUT" = yes
then "$@" 2>&1
else "$@"
fi
fi
}
}
function mbfl_program_execbg () {
local INCHAN=${1:?"missing input channel parameter to '${FUNCNAME}'"}
local OUCHAN=${2:?"missing output channel parameter to '${FUNCNAME}'"}
shift 2
local PERSONA=$mbfl_program_SUDO_USER USE_SUDO=no SUDO WHOAMI
local STDERR_TO_STDOUT=no
mbfl_program_SUDO_USER=nosudo
test "$PERSONA" = nosudo || {
SUDO=$(mbfl_program_found sudo)     || exit $?
WHOAMI=$(mbfl_program_found whoami) || exit $?
USE_SUDO=yes
}
STDERR_TO_STDOUT=${mbfl_program_STDERR_TO_STDOUT}
mbfl_program_STDERR_TO_STDOUT='no'
{ mbfl_option_test || mbfl_option_show_program; } && {
if test "$USE_SUDO" = yes -a "$PERSONA" != "$USER"
then echo "$SUDO" -u "$PERSONA" "$@" >&2
else echo "$@" >&2
fi
}
mbfl_option_test || {
if test "$USE_SUDO" = yes
then
test "$PERSONA" = $("$WHOAMI") || {
if test "$STDERR_TO_STDOUT" = yes
then "$SUDO" -u "$PERSONA" "$@" <$INCHAN 2>&1 >$OUCHAN &
else "$SUDO" -u "$PERSONA" "$@" <$INCHAN >$OUCHAN &
fi
mbfl_program_BGPID=$!
}
else
if test "$STDERR_TO_STDOUT" = yes
then "$@" <$INCHAN 2>&1 >$OUCHAN &
else "$@" <$INCHAN >$OUCHAN &
fi
mbfl_program_BGPID=$!
fi
}
}
function mbfl_program_bash_command () {
local COMMAND=${1:?"missing command parameter to '${FUNCNAME}'"}
mbfl_program_exec "$mbfl_program_BASH" -c "$COMMAND"
}
function mbfl_program_bash () {
mbfl_program_exec "$mbfl_program_BASH" "$@"
}
test "$mbfl_INTERACTIVE" = yes || \
declare -a mbfl_program_NAMES mbfl_program_PATHS
function mbfl_declare_program () {
local PROGRAM=${1:?"missing program parameter to '${FUNCNAME}'"}
local pathname
local next_free_index=${#mbfl_program_NAMES[@]}
mbfl_program_NAMES[${next_free_index}]="$PROGRAM"
PROGRAM=$(mbfl_program_find "$PROGRAM")
test -n "$PROGRAM" && \
PROGRAM=$(mbfl_file_normalise "$PROGRAM")
mbfl_program_PATHS[${next_free_index}]="$PROGRAM"
return 0
}
function mbfl_program_validate_declared () {
local -i i retval=0 number_of_programs=${#mbfl_program_NAMES[@]}
local name path
for ((i=0; $i < $number_of_programs; ++i))
do
name="${mbfl_program_NAMES[$i]}"
path="${mbfl_program_PATHS[$i]}"
if test -n "$path" -a -x "$path"
then mbfl_message_verbose "found '$name': '$path'\n"
else
mbfl_message_verbose "*** not found '$name', path: '$path'\n"
retval=1
fi
done
return $retval
}
function mbfl_program_found () {
local PROGRAM=${1:?"missing program name parameter to '${FUNCNAME}'"}
local number_of_programs=${#mbfl_program_NAMES[@]} i=
if test "$PROGRAM" != :
then
for ((i=0; $i < ${number_of_programs}; ++i))
do
if test "${mbfl_program_NAMES[$i]}" = "$PROGRAM"
then
echo "${mbfl_program_PATHS[$i]}"
return 0
fi
done
fi
mbfl_message_error "executable not found '$PROGRAM'"
exit_because_program_not_found
}
function mbfl_program_main_validate_programs () {
mbfl_program_validate_declared || exit_because_program_not_found
}

test "$mbfl_INTERACTIVE" = yes || {
declare -a mbfl_signal_HANDLERS
i=0
{ while kill -l $i ; do let ++i; done; } &>/dev/null
declare -i mbfl_signal_MAX_SIGNUM=$i
}
function mbfl_signal_map_signame_to_signum () {
local SIGSPEC=${1:?"missing signal name parameter to '${FUNCNAME}'"}
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
local SIGSPEC=${1:?"missing signal name parameter to '${FUNCNAME}'"}
local HANDLER=${2:?"missing function name parameter to '${FUNCNAME}'"}
local signum
signum=$(mbfl_signal_map_signame_to_signum "$SIGSPEC") || return 1
if test -z ${mbfl_signal_HANDLERS[$signum]}
then mbfl_signal_HANDLERS[$signum]=$HANDLER
else mbfl_signal_HANDLERS[$signum]="${mbfl_signal_HANDLERS[$signum]}:$HANDLER"
fi
mbfl_message_debug "attached '$HANDLER' to signal $SIGSPEC"
trap -- "mbfl_signal_invoke_handlers $signum" $signum
}
function mbfl_signal_invoke_handlers () {
local SIGNUM=${1:?"missing signal number parameter to '${FUNCNAME}'"}
local handler ORGIFS="$IFS"
mbfl_message_debug "received signal 'SIG$(kill -l $SIGNUM)'"
IFS=:
for handler in ${mbfl_signal_HANDLERS[$SIGNUM]}
do
IFS="$ORGIFS"
mbfl_message_debug "registered handler: $handler"
test -n "$handler" && eval $handler
done
IFS="$ORGIFS"
return 0
}

function mbfl_variable_find_in_array () {
local ELEMENT=${1:?"missing element parameter parameter to '${FUNCNAME}'"}
declare -i i ARRAY_DIM=${#mbfl_FIELDS[*]}
for ((i=0; $i < $ARRAY_DIM; ++i))
do test "${mbfl_FIELDS[$i]}" = "$ELEMENT" && { printf "$i\n"; return 0; }
done
return 1
}
function mbfl_variable_element_is_in_array () {
local pos
pos=$(mbfl_variable_find_in_array "$@")
}
function mbfl_variable_colon_variable_to_array () {
local COLON_VARIABLE=${1:?"missing colon variable parameter to '${FUNCNAME}'"}
local ORGIFS="$IFS"
IFS=: mbfl_FIELDS=(${!COLON_VARIABLE})
IFS="$ORGIFS"
return 0
}
function mbfl_variable_array_to_colon_variable () {
local COLON_VARIABLE=${1:?"missing colon variable parameter to '${FUNCNAME}'"}
declare -i i dimension=${#mbfl_FIELDS[*]}
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
local COLON_VARIABLE=${1:?"missing colon variable parameter to '${FUNCNAME}'"}
local item
declare -a mbfl_FIELDS FIELDS
declare -i dimension count i
mbfl_variable_colon_variable_to_array "$COLON_VARIABLE"
dimension=${#mbfl_FIELDS[*]}
FIELDS=("${mbfl_FIELDS[@]}")
mbfl_FIELDS=()
for ((i=0, count=0; $i < $dimension; ++i))
do
item="${FIELDS[$i]}"
mbfl_variable_element_is_in_array "$item" && continue
mbfl_FIELDS[$count]=$item
let ++count
done
mbfl_variable_array_to_colon_variable $COLON_VARIABLE
return 0
}

function mbfl_dialog_enable_programs () {
mbfl_declare_program stty
}
function mbfl_dialog_yes_or_no () {
local STRING=${1:?"missing prompt string parameter to '${FUNCNAME}'"}
local PROGNAME="${2:-${script_PROGNAME}}"
local PROMPT="${PROGNAME}: ${STRING}? (yes/no) "
local ANS=
while IFS= read -r -e -p "$PROMPT" ANS && \
test "$ANS" != 'yes' -a "$ANS" != 'no'
do echo "${PROGNAME}: please answer yes or no."
done
test "$ANS" = yes
}
function mbfl_dialog_ask_password () {
local PROMPT=${1:?"missing prompt parameter to '${FUNCNAME}'"}
local PASSWORD= STTY=
STTY=$(mbfl_program_found stty) || exit $?
echo -n "${prompt}: " >&2
"$STTY" cbreak -echo </dev/tty >/dev/tty 2>&1
IFS= read -rs PASSWORD
"$STTY" -cbreak echo </dev/tty >/dev/tty 2>&1
echo >&2
printf %s "${PASSWORD}"
}

function mbfl_system_enable_programs () {
mbfl_declare_program grep
mbfl_declare_program cut
}
function mbfl_system_numerical_user_id_to_name () {
local GREP CUT RESULT
local ID=${1:?"missing numerical user id parameter to '${FUNCNAME}'"}
GREP=$(mbfl_program_found grep) || exit $?
CUT=$(mbfl_program_found cut)   || exit $?
mbfl_program_exec ${GREP} "^[^:]\+:[^:]\+:${ID}:" /etc/passwd | \
mbfl_program_exec ${CUT} -d: -f1
}
function mbfl_system_user_name_to_numerical_id () {
local GREP CUT
local NAME=${1:?"missing user name parameter to '${FUNCNAME}'"}
GREP=$(mbfl_program_found grep) || exit $?
CUT=$(mbfl_program_found cut)   || exit $?
mbfl_program_exec ${GREP} "^${NAME}" /etc/passwd | \
mbfl_program_exec ${CUT} -d: -f3
}
declare -a mbfl_symbolic_permissions
mbfl_symbolic_permissions[0]='---'
mbfl_symbolic_permissions[1]='--x'
mbfl_symbolic_permissions[2]='-w-'
mbfl_symbolic_permissions[3]='-wx'
mbfl_symbolic_permissions[4]='r--'
mbfl_symbolic_permissions[5]='r-x'
mbfl_symbolic_permissions[6]='rw-'
mbfl_symbolic_permissions[7]='rwx'
function mbfl_system_symbolic_to_octal_permissions () {
local MODE=${1:?"missing symbolic permissions parameter to '${FUNCNAME}'"}
for ((i=0; $i < 8; ++i))
do test "${mbfl_symbolic_permissions[$i]}" = "${MODE}" && {
printf "${i}\n"
return 0
}
done
return 1
}
function mbfl_system_octal_to_symbolic_permissions () {
local MODE=${1:?"missing symbolic permissions parameter to '${FUNCNAME}'"}
printf "${mbfl_symbolic_permissions[${MODE}]}\n"
}

mbfl_p_at_queue_letter='a'
function mbfl_at_enable () {
mbfl_declare_program at
mbfl_declare_program atq
mbfl_declare_program atrm
mbfl_declare_program sort
}
function mbfl_at_validate_queue_letter () {
local QUEUE=${1:?"missing queue letter parameter to '${FUNCNAME}'"}
test ${#QUEUE} -eq 1 && mbfl_string_is_alpha_char "${QUEUE}"
}
function mbfl_at_validate_selected_queue () {
mbfl_at_check_queue_letter "${QUEUE}" || {
mbfl_message_error "bad 'at' queue identifier '${QUEUE}'"
return 1
}
}
function mbfl_at_select_queue () {
local QUEUE=${1:?"missing queue letter parameter to '${FUNCNAME}'"}
mbfl_at_validate_queue_letter "${QUEUE}" || {
mbfl_message_error "bad 'at' queue identifier '${QUEUE}'"
return 1
}
mbfl_p_at_queue_letter=${QUEUE}
}
function mbfl_at_schedule () {
local AT QUEUE=${mbfl_p_at_queue_letter}
local SCRIPT=${1:?"missing script parameter to '${FUNCNAME}'"}
local TIME=${2:?"missing time parameter to '${FUNCNAME}'"}
AT=$(mbfl_program_found at) || exit $?
printf %s "${SCRIPT}" | {
mbfl_program_redirect_stderr_to_stdout
mbfl_program_exec "$AT" -q $QUEUE $TIME || {
mbfl_message_error \
"scheduling command execution '$SCRIPT' at time '$TIME'"
return 1
}
} | {
{ read; read; } || {
mbfl_message_error "reading output of 'at'"
mbfl_message_error "while scheduling command execution '$SCRIPT' at time '$TIME'"
return 1
}
set -- $REPLY
printf %d "$2"
}
}
function mbfl_at_queue_print_identifiers () {
local QUEUE=${mbfl_p_at_queue_letter}
mbfl_p_at_program_atq "$QUEUE" | while IFS= read -r LINE
do
set -- $LINE
printf '%d ' "$1"
done
}
function mbfl_at_queue_print_queues () {
local ATQ SORT line
ATQ=$(mbfl_program_found atq)   || exit $?
SORT=$(mbfl_program_found sort) || exit $?
{ mbfl_program_exec "${ATQ}" | while IFS= read -r line
do
set -- $line
printf '%c\n' "$4"
done } | mbfl_program_exec "$SORT" -u
}
function mbfl_at_queue_print_jobs () {
local QUEUE=${mbfl_p_at_queue_letter}
mbfl_p_at_program_atq "$QUEUE"
}
function mbfl_at_print_queue () {
local QUEUE=$mbfl_p_at_queue_letter
printf '%c' "$QUEUE"
}
function mbfl_at_drop () {
local ATRM
local ID=${1:?"missing script identifier parameter to '${FUNCNAME}'"}
ATRM=$(mbfl_program_found atrm) || exit $?
mbfl_program_exec "$ATRM" "$ID"
}
function mbfl_at_queue_clean () {
local item QUEUE=${mbfl_p_at_queue_letter}
for item in $(mbfl_at_queue_print_identifiers "$QUEUE")
do mbfl_at_drop "$item"
done
}
function mbfl_p_at_program_atq () {
local ATQ
local QUEUE=${1:?"missing job queue parameter to '${FUNCNAME}'"}
ATQ=$(mbfl_program_found atq) || exit $?
mbfl_program_exec "$ATQ" -q "$QUEUE"
}

test "$mbfl_INTERACTIVE" = yes || {
mbfl_option_TMPDIR="${TMPDIR:-/tmp/${USER}}"
mbfl_ORG_PWD=$PWD
declare -i ARGC=0 ARGC1=0 ARG1ST=0
declare -a ARGV ARGV1
for ((ARGC1=0; $# > 0; ++ARGC1))
do
ARGV1[$ARGC1]=$1
shift
done
mbfl_main_SCRIPT_FUNCTION=main
mbfl_main_PRIVATE_SCRIPT_FUNCTION=
mbfl_main_SCRIPT_BEFORE_PARSING_OPTIONS=script_before_parsing_options
mbfl_main_SCRIPT_AFTER_PARSING_OPTIONS=script_after_parsing_options
}
function mbfl_main_set_main () {
local FUNC=${1:?"missing main function name parameter to '${FUNCNAME}'"}
mbfl_main_SCRIPT_FUNCTION=${FUNC}
}
function mbfl_main_set_private_main () {
local FUNC=${1:?"missing main function name parameter to '${FUNCNAME}'"}
mbfl_main_PRIVATE_SCRIPT_FUNCTION=${FUNC}
}
function mbfl_main_set_before_parsing_options () {
local FUNC=${1:?"missing main function name parameter to '${FUNCNAME}'"}
mbfl_main_SCRIPT_BEFORE_PARSING_OPTIONS=${FUNC}
}
function mbfl_main_set_after_parsing_options () {
local FUNC=${1:?"missing main function name parameter to '${FUNCNAME}'"}
mbfl_main_SCRIPT_AFTER_PARSING_OPTIONS=${FUNC}
}
test "$mbfl_INTERACTIVE" = yes || {
declare -a mbfl_main_EXIT_CODES mbfl_main_EXIT_NAMES
mbfl_main_EXIT_CODES[0]=0
mbfl_main_EXIT_NAMES[0]=success
mbfl_main_EXIT_CODES[1]=1
mbfl_main_EXIT_NAMES[1]=failure
mbfl_main_EXIT_CODES[2]=99
mbfl_main_EXIT_NAMES[2]=program_not_found
mbfl_main_EXIT_CODES[3]=98
mbfl_main_EXIT_NAMES[3]=wrong_num_args
mbfl_main_EXIT_CODES[4]=97
mbfl_main_EXIT_NAMES[4]=invalid_action_set
mbfl_main_EXIT_CODES[5]=96
mbfl_main_EXIT_NAMES[5]=invalid_action_declaration
mbfl_main_EXIT_CODES[6]=95
mbfl_main_EXIT_NAMES[6]=invalid_action_argument
mbfl_main_EXIT_CODES[7]=94
mbfl_main_EXIT_NAMES[7]=missing_action_function
mbfl_main_EXIT_CODES[8]=93
mbfl_main_EXIT_NAMES[8]=invalid_option_declaration
mbfl_main_EXIT_CODES[9]=92
mbfl_main_EXIT_NAMES[9]=invalid_option_argument
mbfl_main_EXIT_CODES[10]=91
mbfl_main_EXIT_NAMES[10]=invalid_function_name
mbfl_main_EXIT_CODES[11]=90
mbfl_main_EXIT_NAMES[11]=invalid_username
}
function exit_success () {
exit_because_success
}
function exit_failure () {
exit_because_failure
}
function mbfl_main_declare_exit_code () {
local CODE=${1:?"missing exit code parameter to '${FUNCNAME}'"}
local DESCRIPTION=${2:?"missing exit code name parameter to '${FUNCNAME}'"}
local i=${#mbfl_main_EXIT_CODES[@]}
mbfl_main_EXIT_NAMES[$i]=$DESCRIPTION
mbfl_main_EXIT_CODES[$i]=$CODE
}
function mbfl_main_create_exit_functions () {
local i name
for ((i=0; $i < ${#mbfl_main_EXIT_CODES[@]}; ++i))
do
name=exit_because_${mbfl_main_EXIT_NAMES[${i}]}
eval function "$name" "()" "{ exit ${mbfl_main_EXIT_CODES[${i}]}; }"
done
}
function mbfl_main_list_exit_codes () {
local i
for ((i=0; $i < ${#mbfl_main_EXIT_CODES[@]}; ++i))
do printf '%d %s\n' ${mbfl_main_EXIT_CODES[${i}]} ${mbfl_main_EXIT_NAMES[${i}]}
done
}
function mbfl_main_print_exit_code () {
local NAME=${1:?"missing exit code name parameter to '${FUNCNAME}'"}
local i
for ((i=0; $i < ${#mbfl_main_EXIT_CODES[@]}; ++i))
do test "${mbfl_main_EXIT_NAMES[${i}]}" = "$NAME" && \
printf '%d\n' ${mbfl_main_EXIT_CODES[${i}]}
done
}
function mbfl_main_print_exit_code_names () {
local CODE=${1:?"missing exit code parameter to '${FUNCNAME}'"}
local i
for ((i=0; $i < ${#mbfl_main_EXIT_CODES[@]}; ++i))
do test "${mbfl_main_EXIT_CODES[${i}]}" = "$CODE" && \
printf '%s\n' ${mbfl_main_EXIT_NAMES[${i}]}
done
}
test "$mbfl_INTERACTIVE" = yes || {
mbfl_message_LICENSE_GPL="${script_PROGNAME} version ${script_VERSION}
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
mbfl_message_LICENSE_GPL3="${script_PROGNAME} version ${script_VERSION}
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
mbfl_message_LICENSE_LGPL="${script_PROGNAME} version ${script_VERSION}
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
mbfl_message_LICENSE_LGPL3="${script_PROGNAME} version ${script_VERSION}
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
mbfl_message_LICENSE_BSD="${script_PROGNAME} version ${script_VERSION}
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
}
test "$mbfl_INTERACTIVE" = yes || {
mbfl_message_VERSION="${script_PROGNAME} version ${script_VERSION}
Written by ${script_AUTHOR}.\n
Copyright (C) ${script_COPYRIGHT_YEARS} by ${script_AUTHOR}.\n
This is free software; see the  source or use the '--license' option for
copying conditions.  There is NO warranty; not  even for MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.
"
}
function mbfl_main_print_version_number () {
echo -e "${mbfl_message_VERSION}"
exit_success
}
function mbfl_main_print_version_number_only () {
echo -e "${script_VERSION}"
exit_success
}
function mbfl_main_print_license () {
case "${script_LICENSE}" in
GPL|GPL2)
echo -e "${mbfl_message_LICENSE_GPL}"
;;
GPL3)
echo -e "${mbfl_message_LICENSE_GPL3}"
;;
LGPL|LGPL2)
echo -e "${mbfl_message_LICENSE_LGPL}"
;;
LGPL3)
echo -e "${mbfl_message_LICENSE_LGPL3}"
;;
BSD)
echo -e "${mbfl_message_LICENSE_BSD}"
;;
*)
mbfl_message_error "unknown license: \"${script_LICENSE}\""
exit_failure
;;
esac
exit_success
}
function mbfl_main_print_usage_screen_long () {
if test -n "${script_USAGE}"
then printf '%s\n' "${script_USAGE}"
else printf 'usafe: %s [arguments]\n' "${script_PROGNAME}"
fi
test -n "${script_DESCRIPTION}" && printf "${script_DESCRIPTION}\n\n"
mbfl_actions_print_usage_screen
mbfl_getopts_print_usage_screen long
test -n "${script_EXAMPLES}" && printf "${script_EXAMPLES}\n"
exit_success
}
function mbfl_main_print_usage_screen_brief () {
if test -n "${script_USAGE}"
then printf '%s\n' "${script_USAGE}"
else printf 'usafe: %s [arguments]\n' "${script_PROGNAME}"
fi
test -n "${script_DESCRIPTION}" && printf "${script_DESCRIPTION}\n\n"
mbfl_actions_print_usage_screen
mbfl_getopts_print_usage_screen brief
test -n "${script_EXAMPLES}" && printf "${script_EXAMPLES}\n"
exit_success
}
function mbfl_main () {
local exit_code=0 action_func item code
mbfl_message_set_progname "$script_PROGNAME"
mbfl_main_create_exit_functions
if mbfl_actions_set_exists MAIN
then
if ! mbfl_actions_dispatch MAIN
then exit_failure
fi
fi
mbfl_invoke_script_function $mbfl_main_SCRIPT_BEFORE_PARSING_OPTIONS || exit_failure
mbfl_getopts_parse || exit_because_invalid_option_argument
mbfl_invoke_script_function $mbfl_main_SCRIPT_AFTER_PARSING_OPTIONS || exit_failure
if test -n "$mbfl_main_PRIVATE_SCRIPT_FUNCTION"
then mbfl_invoke_existent_script_function $mbfl_main_PRIVATE_SCRIPT_FUNCTION
else mbfl_invoke_existent_script_function $mbfl_main_SCRIPT_FUNCTION
fi
exit_success
}
function mbfl_invoke_script_function () {
local FUNC=${1:?"missing function name parameter to '${FUNCNAME}'"}
if test "$(type -t $FUNC)" = function
then $FUNC
else return 0
fi
}
function mbfl_invoke_existent_script_function () {
local FUNC=${1:?"missing function name parameter to '${FUNCNAME}'"}
if test "$(type -t $FUNC)" = function
then $FUNC
else
mbfl_message_error "internal error: request to call non-existent function \"$FUNC\""
exit_because_invalid_function_name
fi
}


### end of file
# Local Variables:
# mode: sh
# End:
