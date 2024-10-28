#!# preprocessor.test --
#!#
#!# Part of: Marco's BASH Functions Library
#!# Contents: tests for some of the preprocessor features
#!# Date: Oct  4, 2024
#!#
#!# Abstract
#!#
#!#	To select the tests in this file:
#!#
#!#		$ make all test file=preprocessor.test
#!#
#!# Copyright (c) 2024 Marco Maggi
#!# <mrc.mgg@gmail.com>
#!#
#!# The author hereby  grants permission to use,  copy, modify, distribute, and  license this software
#!# and its documentation  for any purpose, provided  that existing copyright notices  are retained in
#!# all copies and that this notice is  included verbatim in any distributions.  No written agreement,
#!# license,  or royalty  fee is  required for  any  of the  authorized uses.   Modifications to  this
#!# software may  be copyrighted by their  authors and need  not follow the licensing  terms described
#!# here, provided that the new terms are clearly indicated  on the first page of each file where they
#!# apply.
#!#
#!# IN NO EVENT SHALL THE AUTHOR OR DISTRIBUTORS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
#!# INCIDENTAL, OR CONSEQUENTIAL DAMAGES  ARISING OUT OF THE USE OF  THIS SOFTWARE, ITS DOCUMENTATION,
#!# OR ANY  DERIVATIVES THEREOF,  EVEN IF  THE AUTHOR  HAVE BEEN  ADVISED OF  THE POSSIBILITY  OF SUCH
#!# DAMAGE.
#!#
#!# THE AUTHOR AND  DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,
#!# THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
#!# THIS  SOFTWARE IS  PROVIDED  ON AN  \"AS  IS\" BASIS,  AND  THE AUTHOR  AND  DISTRIBUTORS HAVE  NO
#!# OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#!#


#### setup

mbfl_embed_library(__LIBMBFL_LINKER__)
mbfl_linker_source_library_by_stem(core)
mbfl_linker_source_library_by_stem(tests)

MBFL_DEFINE_SPECIAL_MACROS
MBFL_DEFINE_UNDERSCORE_MACRO


#### variable reference macros

function preprocessor-macro-qq-1.1		() {	dotest-equal '"${CIAO}"'	'QQ(CIAO)'	;}
function preprocessor-macro-qq-1.2		() {	dotest-equal '"${CIAO[123]}"'	'QQ(CIAO,123)'	;}

function preprocessor-macro-ww-1.1		() {	dotest-equal '"${CIAO:?}"'      'WW(CIAO)'	;}
function preprocessor-macro-ww-1.2		() {	dotest-equal '"${CIAO[123]:?}"' 'WW(CIAO,123)'	;}

function preprocessor-macro-rr-1.1		() {	dotest-equal '${CIAO:?}'	'RR(CIAO)'	;}
function preprocessor-macro-rr-1.2		() {	dotest-equal '${CIAO[123]:?}'	'RR(CIAO,123)'	;}

function preprocessor-macro-ss-1.1		() {	dotest-equal 'CIAO[123]'	'SS(CIAO,123)'	;}

function preprocessor-macro-underscore-1.1	() {	dotest-equal '${mbfl_a_variable_CIAO:?}'  '_(CIAO)'	;}

function preprocessor-macro-pp-1.1 () {
    dotest-equal "\${7:?\"missing parameter 7 CIAO CIAO in call to \${FUNCNAME}\"}"	'PP(7,CIAO CIAO)'
}


#### leaving locations

function sub-preprocessor-location-leave-when-failure-1.1 () {
    mbfl_location_enter
    {
	RESULT+=1
	mbfl_location_leave_when_failure( { RESULT+=2; true; } )
	RESULT+=3
    }
    mbfl_location_leave
}
function preprocessor-location-leave-when-failure-1.1 () {
    declare RESULT=0
    sub-preprocessor-location-leave-when-failure-1.1
    dotest-equal 0123 WW(RESULT)
}

### ------------------------------------------------------------------------

function sub-preprocessor-location-leave-when-failure-1.2 () {
    mbfl_location_enter
    {
	RESULT+=1
	mbfl_location_leave_when_failure(RESULT+=2; true)
	RESULT+=3
    }
    mbfl_location_leave
}
function preprocessor-location-leave-when-failure-1.2 () {
    declare RESULT=0
    sub-preprocessor-location-leave-when-failure-1.2
    dotest-equal 0123 WW(RESULT)
}

### ------------------------------------------------------------------------

function sub-preprocessor-location-leave-when-failure-2.1 () {
    mbfl_location_enter
    {
	RESULT+=1
	mbfl_location_leave_when_failure( { RESULT+=2 ; false; } )
	RESULT+=3
    }
    mbfl_location_leave
}
function preprocessor-location-leave-when-failure-2.1 () {
    declare RESULT=0
    sub-preprocessor-location-leave-when-failure-2.1
    dotest-equal 012 WW(RESULT)
}


#### checking number of arguments

function sub-preprocessor-check-number-of-arguments-two () {
    mbfl_check_mandatory_parameters_number(3,5)
    return_success
}
function preprocessor-check-number-of-arguments-1.1.1 () {
    # Correct number of arguments.
    sub-preprocessor-check-number-of-arguments-two 1 2 3
}
function preprocessor-check-number-of-arguments-1.1.2 () {
    # Correct number of arguments.
    sub-preprocessor-check-number-of-arguments-two 1 2 3 4
}
function preprocessor-check-number-of-arguments-1.1.3 () {
    # Correct number of arguments.
    sub-preprocessor-check-number-of-arguments-two 1 2 3 4 5
}
function preprocessor-check-number-of-arguments-1.2.1 () {
    mbfl_location_enter
    {
	# Not enough parameters.  The  function call is evaluated in a subshell:  we let the default
	# exception-handler handle the exception and terminate the subshell with exit status false.
	! (sub-preprocessor-check-number-of-arguments-two 1 2)
    }
    mbfl_location_leave
}
function preprocessor-check-number-of-arguments-1.2.2 () {
    mbfl_location_enter
    {
	# Too many  parameters.  The function call  is evaluated in  a subshell: we let  the default
	# exception-handler handle the exception and terminate the subshell with exit status false.
	! (sub-preprocessor-check-number-of-arguments-two 1 2 3 4 5 6)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sub-preprocessor-check-number-of-arguments-one () {
    mbfl_check_mandatory_parameters_number(3)
    return_success
}
function preprocessor-check-number-of-arguments-2.1.1 () {
    # Correct number of arguments.
    sub-preprocessor-check-number-of-arguments-one 1 2 3
}
function preprocessor-check-number-of-arguments-2.2.1 () {
    mbfl_location_enter
    {
	# Not enough parameters.  The  function call is evaluated in a subshell:  we let the default
	# exception-handler handle the exception and terminate the subshell with exit status false.
	! (sub-preprocessor-check-number-of-arguments-one 1 2)
    }
    mbfl_location_leave
}


#### let's go

dotest preprocessor-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
