# program.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the program.sh functions
# Date: Wed Feb  4, 2004
#
# Abstract
#
#
# Copyright (c) 2004, 2005, 2012, 2013, 2014, 2018, 2020 Marco Maggi
# <mrc.mgg@gmail.com>
#
# The author hereby  grants permission to use,  copy, modify, distribute, and  license this software
# and its documentation  for any purpose, provided  that existing copyright notices  are retained in
# all copies and that this notice is  included verbatim in any distributions.  No written agreement,
# license,  or royalty  fee is  required for  any  of the  authorized uses.   Modifications to  this
# software may  be copyrighted by their  authors and need  not follow the licensing  terms described
# here, provided that the new terms are clearly indicated  on the first page of each file where they
# apply.
#
# IN NO EVENT SHALL THE AUTHOR OR DISTRIBUTORS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES  ARISING OUT OF THE USE OF  THIS SOFTWARE, ITS DOCUMENTATION,
# OR ANY  DERIVATIVES THEREOF,  EVEN IF  THE AUTHOR  HAVE BEEN  ADVISED OF  THE POSSIBILITY  OF SUCH
# DAMAGE.
#
# THE AUTHOR AND  DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
# THIS  SOFTWARE IS  PROVIDED  ON AN  \"AS  IS\" BASIS,  AND  THE AUTHOR  AND  DISTRIBUTORS HAVE  NO
# OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#

#PAGE
#### setup

source setup.sh

#page
#### splitting path

function program-split-path-1.1 () {
    if mbfl_program_split_path
    then
	for ((i=0; i < ${#mbfl_split_PATH[@]}; ++i))
	do echo "${mbfl_split_PATH[$i]}"
	done
    fi
}

#PAGE
#### run simple programs

function program-1.1.1 () {
    mbfl_program_exec echo 123 | dotest-output 123
}
function program-1.1.2 () {
    mbfl_set_option_test
    mbfl_program_exec echo 123 2>&1 | dotest-output "command echo '123' <&0 >&1 2>&2"
}
function program-1.1.3 () {
    mbfl_program_exec true
}
function program-1.1.4 () {
    ! mbfl_program_exec false
}

### ------------------------------------------------------------------------

function program-1.2.1 () {
    mbfl_program_exec2 0 1 2 echo 123 | dotest-output 123
}
function program-1.2.2 () {
    mbfl_set_option_test
    mbfl_program_exec2 0 1 2 echo 123 2>&1 | dotest-output "command echo '123' <&0 >&1 2>&2"
}
function program-1.2.3 () {
    mbfl_program_exec2 0 1 2 true
}
function program-1.2.4 () {
    ! mbfl_program_exec2 0 1 2 false
}

#page
#### tests for mbfl_declare_program and related stuff

function program-3.1 () {
    {
	mbfl_set_option_verbose
	mbfl_message_set_channel 1
	mbfl_message_set_progname "test"
	mbfl_declare_program /bin/ls
	mbfl_program_validate_declared
	mbfl_unset_option_verbose
    } | dotest-output 'test: found "/bin/ls": "/bin/ls"'
}
function program-3.2 () {
    mbfl_declare_program unexistent
    ! mbfl_program_validate_declared &>/dev/null
}
function program-3.3 () {
    mbfl_declare_program /bin/ls
    mbfl_program_found /bin/ls | dotest-output /bin/ls
}
function program-3.4 () {
    mbfl_declare_program unexistent
    mbfl_program_found unexistent | dotest-output
}
function program-3.5 () {
    local ret=0

    mbfl_set_option_verbose
    mbfl_message_set_channel 1
    mbfl_message_set_progname "test"
    mbfl_declare_program unexistent
    mbfl_program_validate_declared | dotest-output 'test: *** not found "unexistent", path: ""'
}

#page
#### tests for sudo invocation

function program-4.1 () {
    local USERNAME

    if USERNAME=$("$mbfl_program_WHOAMI")
    then
	local CODE
	mbfl_program_enable_sudo
	mbfl_set_option_test
	{
	    mbfl_program_FORCE_USE_SUDO=true
	    mbfl_program_declare_sudo_user "$USERNAME"
	    echo 123 | mbfl_program_exec cat 2>&1 | \
		dotest-output "command $mbfl_program_SUDO -u $USERNAME cat <&0 >&1 2>&2"
	    CODE=$?
	}
	mbfl_unset_option_test
	return $CODE
    else true
    fi
}
function program-4.2 () {
    local USERNAME

    if USERNAME=$("$mbfl_program_WHOAMI")
    then
	local CODE
	mbfl_program_enable_sudo
	mbfl_set_option_test
	{
	    mbfl_program_FORCE_USE_SUDO=true
	    mbfl_program_declare_sudo_user "$USERNAME"
	    mbfl_program_declare_sudo_options -H VAL=val
	    echo 123 | mbfl_program_exec cat 2>&1 | \
		dotest-output "command $mbfl_program_SUDO -H VAL=val -u $USERNAME cat <&0 >&1 2>&2"
	    CODE=$?
	}
	mbfl_unset_option_test
	return $CODE
    else true
    fi
}

#page
#### tests for background execution

# Background execution with "mbfl_program_execbg()".
#
function program-5.1.1 () {
    local -r DIR=$(dotest-echo-tmpdir)

    dotest-mkfile test-input.txt
    dotest-mkfile test-output.txt
    {
	echo inp >"$DIR"/test-input.txt

	if mbfl_fd_open_input 10 "$DIR"/test-input.txt
	then
	    if mbfl_fd_open_output 11 "$DIR"/test-output.txt
	    then
		mbfl_set_option_show_program
		mbfl_program_execbg 10 11 "$BASH" -c 'echo -n out >&1; read -n 0 ; echo -n "$REPLY" >&1'
		if wait $mbfl_program_BGPID
		then
		    if false
		    then
			echo  input="$(<"$DIR"/test-input.txt)"  >&2
			echo output="$(<"$DIR"/test-output.txt)" >&2
		    fi
		    dotest-equal     'inp'    "$(<"$DIR"/test-input.txt)"  && \
			dotest-equal 'outinp' "$(<"$DIR"/test-output.txt)"
		else dotest-printf 'error in the background process'
		fi
	    else dotest-printf 'error opening output file'
	    fi
	else dotest-printf 'error opening input file'
	fi

	mbfl_fd_close 10
	mbfl_fd_close 11
    }
    dotest-clean-files
}

# Background execution with "mbfl_program_execbg()" with stderr-to-stdout redirection.
#
function program-5.1.2 () {
    local -r DIR=$(dotest-echo-tmpdir)

    dotest-mkfile test-input.txt
    dotest-mkfile test-output.txt
    {
	echo inp >"$DIR"/test-input.txt

	if mbfl_fd_open_input 10 "$DIR"/test-input.txt
	then
	    if mbfl_fd_open_output 11 "$DIR"/test-output.txt
	    then
		mbfl_program_redirect_stderr_to_stdout
		mbfl_set_option_show_program
		mbfl_program_execbg 10 11 "$BASH" -c 'echo -n out >&1; echo -n err >&2 ; read -n 0 ; echo -n "$REPLY" >&1'
		if wait $mbfl_program_BGPID
		then
		    if false
		    then
			echo  input="$(<"$DIR"/test-input.txt)"  >&2
			echo output="$(<"$DIR"/test-output.txt)" >&2
		    fi
		    dotest-equal     'inp'       "$(<"$DIR"/test-input.txt)"  && \
			dotest-equal 'outerrinp' "$(<"$DIR"/test-output.txt)"
		else dotest-printf 'error in the background process'
		fi
	    else dotest-printf 'error opening output file'
	    fi
	else dotest-printf 'error opening input file'
	fi

	mbfl_fd_close 10
	mbfl_fd_close 11
    }
    dotest-clean-files
}

#page
#### tests for background execution with more channels redirection

# Background execution with "mbfl_program_execbg2()".
#
function program-5.2 () {
    local -r DIR=$(dotest-echo-tmpdir)

    dotest-mkfile test-input.txt
    dotest-mkfile test-output.txt
    dotest-mkfile test-error.txt
    {
	echo inp >"$DIR"/test-input.txt

	if mbfl_fd_open_input 10 "$DIR"/test-input.txt
	then
	    if mbfl_fd_open_output 11 "$DIR"/test-output.txt
	    then
		if mbfl_fd_open_output 12 "$DIR"/test-error.txt
		then
		    mbfl_set_option_show_program
		    mbfl_program_execbg2 10 11 12 "$BASH" -c 'echo -n out >&1; echo -n err >&2; read -n 0 ; echo -n "$REPLY" >&1'
		    if wait $mbfl_program_BGPID
		    then
			if false
			then
			    echo  input="$(<"$DIR"/test-input.txt)"  >&2
			    echo output="$(<"$DIR"/test-output.txt)" >&2
			    echo  error="$(<"$DIR"/test-error.txt)"  >&2
			fi
			dotest-equal     'inp'    "$(<"$DIR"/test-input.txt)"  && \
			    dotest-equal 'outinp' "$(<"$DIR"/test-output.txt)" && \
			    dotest-equal 'err'    "$(<"$DIR"/test-error.txt)"
		    else dotest-printf 'error in the background process'
		    fi
		else dotest-printf 'error opening error file'
		fi
	    else dotest-printf 'error opening output file'
	    fi
	else dotest-printf 'error opening input file'
	fi

	mbfl_fd_close 10
	mbfl_fd_close 11
	mbfl_fd_close 12
    }
    dotest-clean-files
}

#page
#### finding programs

function program-find-1.1 () {
    (PATH=/bin
     local RESULT=$(mbfl_program_find ls)
     dotest-equal /bin/ls "$RESULT")
}

function program-find-2.1 () {
    (PATH=/bin
     mbfl_local_varref(RESULT)
     mbfl_program_find_var mbfl_datavar(RESULT) ls
     dotest-equal /bin/ls "$RESULT")
}

#page
#### executing by replacing

function program-replace-1.1 () {
    (mbfl_program_replace "$mbfl_PROGRAM_BASH" '-c' 'exit 123';)
    dotest-equal $? 123
}

function program-replace-1.2 () {
    local RESULT

    RESULT=$(mbfl_program_replace "$mbfl_PROGRAM_BASH" '-c' 'echo password';)
    dotest-equal "$RESULT" 'password'
}

function program-replace-2.1 () {
    local RESULT

    RESULT=$(mbfl_program_set_exec_flags '-a secret'
	     mbfl_program_replace "$mbfl_PROGRAM_BASH" '-c' 'echo $0';)
    dotest-equal "$RESULT" secret
}
function program-replace-2.2 () {
    local RESULT

    RESULT=$(mbfl_program_set_exec_flags '-a secret'
	     mbfl_program_reset_exec_flags
	     mbfl_program_replace "$mbfl_PROGRAM_BASH" '-c' 'echo $0';)
    dotest-equal "$RESULT" "$mbfl_PROGRAM_BASH"
}

#PAGE
#### let's go

dotest program-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
