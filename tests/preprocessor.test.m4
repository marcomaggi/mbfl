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

MBFL_DEFINE_QQ_MACRO
MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### variable reference macros

function preprocessor-macro-qq-1.1		() {	dotest-equal '"${CIAO}"'      'QQ(CIAO)'	;}
function preprocessor-macro-qq-1.2		() {	dotest-equal '"${CIAO[123]}"' 'QQ(CIAO,123)'	;}

function preprocessor-macro-ww-1.1		() {	dotest-equal '"${CIAO:?}"'      'WW(CIAO)'	;}
function preprocessor-macro-ww-1.2		() {	dotest-equal '"${CIAO[123]:?}"' 'WW(CIAO,123)'	;}

function preprocessor-macro-underscore-1.1	() {	dotest-equal '$mbfl_a_variable_CIAO'  '_(CIAO)'		;}
function preprocessor-macro-underscore-1.2	() {	dotest-equal '"${CIAO[123]}"'	      '_(CIAO,123)'	;}


#### let's go

dotest preprocessor-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
