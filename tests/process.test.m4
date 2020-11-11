# process.test --
#
# Part of: Marco's BASH Functions Library
# Contents: tests for the process functions
# Date: Nov  3, 2020
#
# Abstract
#
#
# Copyright (c) 2020 Marco Maggi
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
#### disowning a process

function process-disown-1.1 () {
    local THE_PID DISOWN_RV KILL_RV WAIT_RV

    #mbfl_set_option_test
    #mbfl_set_option_debug
    mbfl_set_option_show_program

    # We need  to use "mbfl_program_execbg()" directly  if we want to  access "$mbfl_program_BGPID";
    # using "mbfl_program_bash_command()"  and putting it  in the background  with "&" will  not set
    # "mbfl_program_BGPID" correctly.
    mbfl_program_execbg 0 1 "$mbfl_PROGRAM_BASH" '--norc' '--noprofile' '-i' '-c' 'echo "subshell pid: $$" >&2; suspend; exit 0 &>/dev/null;'
    THE_PID=$mbfl_program_BGPID

    mbfl_process_sleep 1
    mbfl_process_jobs

    mbfl_process_disown $THE_PID
    DISOWN_RV=$?

    mbfl_process_kill -SIGCONT $THE_PID
    KILL_RV=$?

    mbfl_process_wait $THE_PID
    WAIT_RV=$?

    dotest-equal 0 $DISOWN_RV 'disown return status' &&
	dotest-equal 0 $KILL_RV 'kill return status' &&
	dotest-equal 0 $WAIT_RV 'wait return status'
}

#page
#### let's go

dotest process-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
