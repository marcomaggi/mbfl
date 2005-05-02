# file.sh --
# 
# Part of: Marco's BASH Functions Library
# Contents: file functions
# Date: Fri Apr 18, 2003
# 
# Abstract
# 
#       This is a collection of file functions for the GNU BASH shell.
# 
# Copyright (c) 2003, 2004, 2005 Marco Maggi
# 
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  2.1 of the License,  or (at
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
# USA
# 

#page
## ------------------------------------------------------------
## Changing directory functions.
## ------------------------------------------------------------

function mbfl_cd () {
    mbfl_change_directory "$@"
    mbfl_message_verbose "entering directory: '${PWD}'\n"
}
function mbfl_change_directory () {
    cd "$@" &>/dev/null
}

#page
## ------------------------------------------------------------
## File name functions.
## ------------------------------------------------------------

function mbfl_file_extension () {
    mandatory_parameter(PATHNAME, 1, pathname)
    local i=
    
    for ((i="${#PATHNAME}"; $i >= 0; --i)); do
        test "${PATHNAME:$i:1}" = '/' && return
        if mbfl_string_is_equal_unquoted_char "${PATHNAME}" $i '.' ; then
            let ++i
            printf '%s\n' "${PATHNAME:$i}"
            return
        fi
    done
}
function mbfl_file_dirname () {
    optional_parameter(PATHNAME, 1, '')
    local i=

    # Do not change "${PATHNAME:$i:1}" with "$ch"!! We need to extract the
    # char at each loop iteration.

    for ((i="${#PATHNAME}"; $i >= 0; --i)); do
        if test "${PATHNAME:$i:1}" = "/" ; then
            while test \( $i -gt 0 \) -a \( "${PATHNAME:$i:1}" = "/" \) ; do
                let --i
            done
            if test $i = 0 ; then
                printf '%s\n' "${PATHNAME:$i:1}"
            else
                let ++i
                printf '%s\n' "${PATHNAME:0:$i}"
            fi
            return 0
        fi
    done

    printf '.\n'
    return 0
}
function mbfl_file_subpathname () {
    mandatory_parameter(PATHNAME, 1, pathname)
    mandatory_parameter(BASEDIR, 2, base directory)

    if test "${BASEDIR:$((${#BASEDIR}-1))}" = '/'; then
        BASEDIR="${BASEDIR:0:$((${#BASEDIR}-1))}"
    fi
    if test "${PATHNAME}" = "${BASEDIR}" ; then
        printf './\n'
        return 0
    elif test "${PATHNAME:0:${#BASEDIR}}" = "${BASEDIR}"; then
        printf  './%s\n' "${PATHNAME:$((${#BASEDIR}+1))}"
        return 0
    else
        return 1
    fi
}
function mbfl_p_file_remove_dots_from_pathname () {
    mandatory_parameter(PATHNAME, 1, pathname)
    local item i
    local SPLITPATH SPLITCOUNT; declare -a SPLITPATH
    local output output_counter=0; declare -a output
    local input_counter=0 

    mbfl_file_split "${PATHNAME}"

    for ((input_counter=0; $input_counter < $SPLITCOUNT; ++input_counter)) ; do
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
    for ((i=1; $i < $output_counter; ++i)) ; do
        PATHNAME="${PATHNAME}/${output[$i]}"
    done

    printf '%s\n' "${PATHNAME}"
}
function mbfl_file_rootname () {
    mandatory_parameter(PATHNAME, 1, pathname)
    local i="${#PATHNAME}"

    test $i = 1 && { printf '%s\n' "${PATHNAME}"; return 0; }

    for ((i="${#PATHNAME}"; $i >= 0; --i)) ; do
        ch="${PATHNAME:$i:1}"
        if test "$ch" = "." ; then
            if test $i -gt 0 ; then
                printf '%s\n' "${PATHNAME:0:$i}"
                break
            else
                printf '%s\n' "${PATHNAME}"
            fi
        elif test "$ch" = "/" ; then
            printf '%s\n' "${PATHNAME}"
            break
        fi
    done
    return 0
}
function mbfl_file_split () {
    mandatory_parameter(PATHNAME, 1, pathname)
    local i=0 last_found=0

    mbfl_string_skip "${PATHNAME}" i /
    last_found=$i

    for ((SPLITCOUNT=0; $i < "${#PATHNAME}"; ++i)) ; do
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
    mandatory_parameter(PATHNAME, 1, pathname)
    local i=

    for ((i="${#PATHNAME}"; $i >= 0; --i)) ; do
        if test "${PATHNAME:$i:1}" = "/" ; then
            let ++i
            printf '%s\n' "${PATHNAME:$i}"
            return 0
        fi
    done

    printf '%s\n' "${PATHNAME}"
    return 0
}

#page
## ------------------------------------------------------------
## Pathname normalisation.
## ------------------------------------------------------------

function mbfl_file_normalise () {
    local pathname="${1:?}"
    local prefix="${2}"
    local dirname=
    local tailname=
    local ORGDIR="${PWD}"

    if mbfl_file_is_absolute "${pathname}" ; then
        mbfl_p_file_normalise1 "${pathname}"
    elif mbfl_file_is_directory "${prefix}" ; then
        pathname="${prefix}/${pathname}"
        mbfl_p_file_normalise1 "${pathname}"
    elif test -n "${prefix}" ; then
        prefix=$(mbfl_p_file_remove_dots_from_pathname "${prefix}")
        pathname=$(mbfl_p_file_remove_dots_from_pathname "${pathname}")
        pathname=$(mbfl_file_strip_trailing_slash "${pathname}")
        printf '%s/%s\n' "${prefix}" "${pathname}"
    else
        mbfl_p_file_normalise1 "${pathname}"
    fi

    cd "${ORGDIR}" >/dev/null
    return 0
}
function mbfl_p_file_normalise1 () {
    if mbfl_file_is_directory "${pathname}"; then
        mbfl_p_file_normalise2 "${pathname}"
    else
        local tailname=$(mbfl_file_tail "${pathname}")
        local dirname=$(mbfl_file_dirname "${pathname}")

        if mbfl_file_is_directory "${dirname}"; then
            mbfl_p_file_normalise2 "${dirname}" "${tailname}"
        else
            pathname=$(mbfl_file_strip_trailing_slash "${pathname}")
            printf '%s\n' "${pathname}"
        fi
    fi
}
function mbfl_p_file_normalise2 () {
    cd "$1" >/dev/null
    if test -n "$2" ; then echo "${PWD}/$2"; else echo "${PWD}"; fi
    cd - >/dev/null
}
function mbfl_file_strip_trailing_slash () {
    mandatory_parameter(pathname, 1, pathname)
    local len=${#pathname}

    if test "${pathname:$len}" = '/' ; then
        pathname=${pathname:1:$(($len-1))}
    fi
    printf '%s\n' "${pathname}"
}

#PAGE
## ------------------------------------------------------------
## Temporary directory functions.
## ------------------------------------------------------------

function mbfl_file_find_tmpdir () {
    local TMPDIR="${1}"


    if mbfl_file_directory_is_writable "${TMPDIR}" ; then
        printf "${TMPDIR}\n"
        return 0
    fi

    if test -n "${USER}" ; then
        TMPDIR="/tmp/${USER}"
        if mbfl_file_directory_is_writable "${TMPDIR}" ; then
            printf "${TMPDIR}\n"
            return 0
        fi
    fi

    TMPDIR=/tmp
    if mbfl_file_directory_is_writable "${TMPDIR}" ; then
        printf "${TMPDIR}\n"
        return 0
    fi

    mbfl_message_error "cannot find usable value for 'TMPDIR'"
    return 1
}
#page
## ------------------------------------------------------------
## File removal functions.
## ------------------------------------------------------------

function mbfl_file_enable_remove () {
    mbfl_declare_program rm
    mbfl_declare_program rmdir
}
function mbfl_file_remove () {
    mandatory_parameter(PATHNAME, 1, pathname)
    local FLAGS="--force --recursive"

    if ! mbfl_option_test ; then
        if ! mbfl_file_exists "${PATHNAME}" ; then
            mbfl_message_error "pathname does not exist '${PATHNAME}'"
            return 1
        fi
    fi
    mbfl_exec_rm "${PATHNAME}" ${FLAGS}
}
function mbfl_file_remove_file () {
    mandatory_parameter(PATHNAME, 1, pathname)
    local FLAGS="--force"

    if ! mbfl_option_test ; then
        if ! mbfl_file_is_file "${PATHNAME}" ; then
            mbfl_message_error "pathname is not a file '${PATHNAME}'"
            return 1
        fi
    fi
    mbfl_exec_rm "${PATHNAME}" ${FLAGS}    
}
function mbfl_exec_rm () {
    mandatory_parameter(PATHNAME, 1, pathname)
    shift
    local RM=$(mbfl_program_found rm) FLAGS

    mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
    mbfl_program_exec "${RM}" ${FLAGS} "$@" -- "${PATHNAME}"
}
#page
## ------------------------------------------------------------
## File copy functions.
## ------------------------------------------------------------

function mbfl_file_enable_copy () {
    mbfl_declare_program cp
}
function mbfl_file_copy () {
    mandatory_parameter(SOURCE, 1, source pathname)
    mandatory_parameter(TARGET, 2, target pathname)
    shift 2

    if ! mbfl_option_test ; then
        if ! mbfl_file_is_readable "${SOURCE}" ; then
            mbfl_message_error "copying file '${SOURCE}'"
            return 1
        fi
    fi
    mbfl_exec_cp "${SOURCE}" "${TARGET}" "$@"
}
function mbfl_file_copy_recursively () {
    mandatory_parameter(SOURCE, 1, source pathname)
    mandatory_parameter(TARGET, 2, target pathname)
    shift 2

    if ! mbfl_option_test ; then
        if ! mbfl_file_is_readable "${SOURCE}" print_error ; then
            mbfl_message_error "copying '${SOURCE}'"
            return 1
        fi
    fi
    mbfl_exec_cp "${SOURCE}" "${TARGET}" --recursive "$@"
}
function mbfl_exec_cp () {
    mandatory_parameter(SOURCE, 1, source pathname)
    mandatory_parameter(TARGET, 2, target pathname)
    shift 2
    local CP=$(mbfl_program_found cp) FLAGS

    mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
    mbfl_program_exec ${CP} ${FLAGS} "$@" -- "${SOURCE}" "${TARGET}"
}

#page
## ------------------------------------------------------------
## Directory remove functions.
## ------------------------------------------------------------

function mbfl_file_remove_directory () {
    mandatory_parameter(PATHNAME, 1, pathname)
    optional_parameter(REMOVE_SILENTLY, 2, no)
    local FLAGS=

    if ! mbfl_file_is_directory "${PATHNAME}" ; then
        mbfl_message_error "pathname is not a directory '${PATHNAME}'"
        return 1
    fi
    if test "${REMOVE_SILENTLY}" = 'yes' ; then
        FLAGS="${FLAGS} --ignore-fail-on-non-empty"
    fi
    mbfl_exec_rmdir "${PATHNAME}" ${FLAGS}
}
function mbfl_file_remove_directory_silently () {
    mbfl_file_remove_directory "$1" yes
}
function mbfl_exec_rmdir () {
    mandatory_parameter(PATHNAME, 1, pathname)
    shift
    local RMDIR=$(mbfl_program_found rmdir) FLAGS

    mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
    mbfl_program_exec "${RMDIR}" $FLAGS "$@" "${PATHNAME}"
}

#page
## ------------------------------------------------------------
## Directory creation functions.
## ------------------------------------------------------------

function mbfl_file_enable_make_directory () {
    mbfl_declare_program mkdir
}
function mbfl_file_make_directory () {
    mandatory_parameter(PATHNAME, 1, pathname)
    optional_parameter(PERMISSIONS, 2, 0775)
    local MKDIR=$(mbfl_program_found mkdir)
    local FLAGS="--parents"

    FLAGS="${FLAGS} --mode=${PERMISSIONS}"
    mbfl_file_is_directory "${PATHNAME}" && return 0
    mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
    mbfl_program_exec "${MKDIR}" $FLAGS "${PATHNAME}"
}
function mbfl_file_make_if_not_directory () {
    mandatory_parameter(PATHNAME, 1, pathname)
    optional_parameter(PERMISSIONS, 2, 0775)

    mbfl_file_is_directory   "${PATHNAME}" || \
    mbfl_file_make_directory "${PATHNAME}" "${PERMISSIONS}"
    mbfl_program_reset_sudo_user
}

#page
## ------------------------------------------------------------
## Symbolic link functions.
## ------------------------------------------------------------

function mbfl_file_enable_symlink () {
    mbfl_declare_program ln
}
function mbfl_file_symlink () {
    mandatory_parameter(ORIGINAL_NAME, 1, original name)
    mandatory_parameter(SYMLINK_NAME, 2, symbolic link name)
    local LN=$(mbfl_program_found ln)
    local FLAGS="--symbolic"

    mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
    mbfl_program_exec "${LN}" ${FLAGS} "${ORIGINAL_NAME}" "${SYMLINK_NAME}"
}

#page
## ------------------------------------------------------------
## File listing functions.
## ------------------------------------------------------------

function mbfl_file_enable_listing () {
    mbfl_declare_program ls readlink
}
function mbfl_file_get_owner () {
    mandatory_parameter(PATHNAME, 1, pathname)
    local LS_FLAGS="-l" OWNER

    set -- $(mbfl_file_p_invoke_ls) || return 1
    OWNER=$3
    if test -z "${OWNER}" ; then
        mbfl_message_error "null owner while inspecting '${PATHNAME}'"
        return 1
    fi
    printf '%s\n' "${OWNER}"
}
function mbfl_file_get_group () {
    mandatory_parameter(PATHNAME, 1, pathname)
    local LS_FLAGS="-l" GROUP

    set -- $(mbfl_file_p_invoke_ls) || return 1
    GROUP=$4
    if test -z "${GROUP}" ; then
        mbfl_message_error "null group while inspecting '${PATHNAME}'"
        return 1
    fi
    printf '%s\n' "${GROUP}"
}
function mbfl_file_get_size () {
    mandatory_parameter(PATHNAME, 1, pathname)
    local LS_FLAGS="--block-size=1 --size"
    set -- $(mbfl_file_p_invoke_ls) || return 1
    printf '%s\n' "${1}"
}
function mbfl_file_p_invoke_ls () {
    local LS=$(mbfl_program_found ls)
    if mbfl_file_is_directory "${PATHNAME}" ; then LS_FLAGS="${LS_FLAGS} -d"; fi
    mbfl_program_exec ${LS} ${LS_FLAGS} "${PATHNAME}"
}
function mbfl_file_normalise_link () {
    local READLINK=$(mbfl_program_found readlink)
    mbfl_program_exec ${READLINK} -fn $1
}

#page
## ------------------------------------------------------------
## File permissions inspection functions.
## ------------------------------------------------------------

function mbfl_p_file_print_error_return_result () {
    local RESULT=$?

    if test ${RESULT} != 0 -a "${PRINT_ERROR}" = 'print_error' ; then
        mbfl_message_error "${ERROR_MESSAGE}"
    fi
    return $RESULT
}

# ------------------------------------------------------------

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

# ------------------------------------------------------------

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

# ------------------------------------------------------------

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
    mandatory_parameter(DIRECTORY, 1, directory pathname)
    mandatory_parameter(DESCRIPTION, 2, directory description)
    local code

    mbfl_message_verbose "validating ${DESCRIPTION} directory '${DIRECTORY}'\n"
    mbfl_file_is_directory              "${DIRECTORY}" print_error && \
    mbfl_file_directory_is_writable     "${DIRECTORY}" print_error
    code=$?
    test $code != 0 && mbfl_message_error \
        "unwritable ${DESCRIPTION} directory '${DIRECTORY}'"
    return $code
}

# ------------------------------------------------------------

function mbfl_file_is_symlink () {
    local PATHNAME=${1}
    local PRINT_ERROR=${2:-no}    
    local ERROR_MESSAGE="not a symbolic link pathname '${PATHNAME}'"
    test -n "${PATHNAME}" -a -L "${PATHNAME}"
    mbfl_p_file_print_error_return_result
}

#page
## ------------------------------------------------------------
## File pathname type functions.
## ------------------------------------------------------------

function mbfl_file_is_absolute () {
    mandatory_parameter(PATHNAME, 1, pathname)
    test "${PATHNAME:0:1}" = /
}
function mbfl_file_is_absolute_dirname () {
    mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_file_is_directory "${PATHNAME}" && mbfl_file_is_absolute "${PATHNAME}"
}
function mbfl_file_is_absolute_filename () {
    mandatory_parameter(PATHNAME, 1, pathname)
    mbfl_file_is_file "${PATHNAME}" && mbfl_file_is_absolute "${PATHNAME}"
}

#page
## ------------------------------------------------------------
## "tar" interface.
## ------------------------------------------------------------

function mbfl_file_enable_tar () {
    mbfl_declare_program tar
}
function mbfl_tar_create_to_stdout () {
    mandatory_parameter(DIRECTORY, 1, directory name)
    shift
    mbfl_tar_exec --directory="${DIRECTORY}" --create --file=- "$@" .
}
function mbfl_tar_extract_from_stdin () {
    mandatory_parameter(DIRECTORY, 1, directory name)
    shift
    mbfl_tar_exec --directory="${DIRECTORY}" --extract --file=- "$@"
}
function mbfl_tar_extract_from_file () {
    mandatory_parameter(DIRECTORY, 1, directory name)
    mandatory_parameter(ARCHIVE_FILENAME, 2, archive pathname)
    shift 2
    mbfl_tar_exec --directory="${DIRECTORY}" --extract --file="${ARCHIVE_FILENAME}" "$@"
}
function mbfl_tar_create_to_file () {
    mandatory_parameter(DIRECTORY, 1, directory name)
    mandatory_parameter(ARCHIVE_FILENAME, 2, archive pathname)
    shift 2
    mbfl_tar_exec --directory="${DIRECTORY}" --create --file="${ARCHIVE_FILENAME}" "$@" .
}
function mbfl_tar_archive_directory_to_file () {
    mandatory_parameter(DIRECTORY, 1, directory name)
    mandatory_parameter(ARCHIVE_FILENAME, 2, archive pathname)
    shift 2
    local PARENT=$(mbfl_file_dirname "${DIRECTORY}")
    local DIRNAME=$(mbfl_file_tail "${DIRECTORY}")
    mbfl_tar_exec --directory="${PARENT}" --create \
        --file="${ARCHIVE_FILENAME}" "$@" "${DIRNAME}"
}
function mbfl_tar_list () {
    mandatory_parameter(ARCHIVE_FILENAME, 1, archive pathname)
    shift
    mbfl_tar_exec --list --file="${ARCHIVE_FILENAME}" "$@"
}
function mbfl_tar_exec () {
    local TAR=$(mbfl_program_found tar)
    local FLAGS
    mbfl_option_verbose_program && FLAGS="${FLAGS} --verbose"
    mbfl_program_exec "${TAR}" ${FLAGS} "$@"
}
#page
## ------------------------------------------------------------
## File permissions functions.
## ------------------------------------------------------------

function mbfl_file_enable_permissions () {
    mbfl_declare_program ls
    mbfl_declare_program cut
    mbfl_declare_program chmod
}
function mbfl_file_get_permissions () {
    mandatory_parameter(PATHNAME, 1, pathname)
    local LS=$(mbfl_program_found ls)
    local CUT=$(mbfl_program_found cut)
    local SYMBOLIC OWNER GROUP OTHER

    SYMBOLIC=$(mbfl_program_exec ${LS} -l "${PATHNAME}" | \
        mbfl_program_exec ${CUT} -d' ' -f1)
    OWNER=${SYMBOLIC:1:3}
    GROUP=${SYMBOLIC:4:3}
    OTHER=${SYMBOLIC:7:3}

    printf '0%d%d%d\n' \
        $(mbfl_system_symbolic_to_octal_permissions ${OWNER}) \
        $(mbfl_system_symbolic_to_octal_permissions ${GROUP}) \
        $(mbfl_system_symbolic_to_octal_permissions ${OTHER})
}
function mbfl_file_set_permissions () {
    mandatory_parameter(PERMISSIONS, 1, permissions)
    mandatory_parameter(PATHNAME, 2, pathname)
    local CHMOD=$(mbfl_program_found chmod)
    
    mbfl_program_exec ${CHMOD} "${PERMISSIONS}" "${PATHNAME}"
}

#page
## ------------------------------------------------------------
## Reading and writing files with privileges.
## ------------------------------------------------------------

function mbfl_file_append () {
    mandatory_parameter(STRING, 1, string)
    mandatory_parameter(FILENAME, 2, file name)
    mbfl_program_bash_command "printf '%s' '${STRING}' >>'${FILENAME}'"
}
function mbfl_file_write () {
    mandatory_parameter(STRING, 1, string)
    mandatory_parameter(FILENAME, 2, file name)
    mbfl_program_bash_command "printf '%s' '${STRING}' >'${FILENAME}'" 
}
function mbfl_file_read () {
    mandatory_parameter(FILENAME, 1, file name)
    mbfl_program_bash_command "printf '%s' \"\$(<${FILENAME})\""
}

### end of file
# Local Variables:
# mode: sh
# End:
