# getopts.sh --
# 
# Part of: Marco's BASH function libraries
# Contents: tests for the getopts library
# Date: Tue Apr 22, 2003
# 
# Abstract
# 
#	This file must be executes through "all.tcl": from the build
#	directory:
#
#		$ make all test TESTFLAGS="-match getopts-*"
# 
#	will select these tests.
# 
# Copyright (c) 2003 Marco Maggi
# 
# This is free  software you can redistribute it  and/or modify it under
# the terms of  the GNU General Public License as  published by the Free
# Software Foundation; either  version 2, or (at your  option) any later
# version.
# 
# This  file is  distributed in  the hope  that it  will be  useful, but
# WITHOUT   ANY  WARRANTY;  without   even  the   implied  warranty   of
# MERCHANTABILITY  or FITNESS  FOR A  PARTICULAR PURPOSE.   See  the GNU
# General Public License for more details.
# 
# You  should have received  a copy  of the  GNU General  Public License
# along with this file; see the file COPYING.  If not, write to the Free
# Software Foundation,  Inc., 59  Temple Place -  Suite 330,  Boston, MA
# 02111-1307, USA.
# 

source ../=build/getopts.sh

#     variable	precmd ". %s"
#     set precmd [format $precmd $libname]

#page

shopt -s expand_aliases

function mbfl_test () {
    local NAME="${1}"
    local DESCRIPTION="${2}"
    local EXITCODE="${3}"
    local BODY="${4}"

    alias ${NAME}="echo ${DESCRIPTION};${BODY};"
}

mbfl_test getopts_1_1 "is long option" 0 "mbfl_getopts_islong --option"
mbfl_test getopts_1_2 "is long option" 1 "mbfl_getopts_islong -option"
mbfl_test getopts_1_3 "is long option" 1 "mbfl_getopts_islong --"
mbfl_test getopts_1_4 "is long option" 1 "mbfl_getopts_islong --optio\\\)"
mbfl_test getopts_1_5 "is long option" 0 "mbfl_getopts_islong --option1"
mbfl_test getopts_1_6 "is long option" 0 "mbfl_getopts_islong --option-one"
mbfl_test getopts_1_7 "is long option" 0 \
    'mbfl_getopts_islong --option a; echo "$a"; fi' \
    option

if test -z "${PATTERN}"; then
    PATTERN=\*
fi

for item in `declare -F` ; do
    item=${item:12}
    echo $item
    if MBFL__OUTPUT=`$item` ; then
	echo "SUCCESS"
    else
	echo "FAILED"
    fi
done

exit

#PAGE

mbfl_test getopts-2.1 "is long option with arg" {
    -body	{
	bash "if mbfl_getopts_islong_with --option=one ; then echo yes; fi"
    }
    -result yes
}

mbfl_test getopts-2.2 "is long option with arg" {
    -body	{
	bash "if mbfl_getopts_islong_with --option ; then echo yes; fi"
    }
    -result {}
}

mbfl_test getopts-2.3 "is long option with arg" {
    -body	{
	bash "if mbfl_getopts_islong_with -option=one ; then echo yes; fi"
    }
    -result {}
}

mbfl_test getopts-2.4 "is long option with arg" {
    -body	{
	bash "if mbfl_getopts_islong_with --option=two a b; then echo \"\$a=\$b\"; fi"
    }
    -result {option=two}
}

mbfl_test getopts-2.5 "is long option with arg" {
    -body	{
	bash "if mbfl_getopts_islong_with --a=1 a b; then echo \"\$a=\$b\"; fi"
    }
    -result {a=1}
}

mbfl_test getopts-2.6 "is long option with arg and blanks" {
    -body	{
	bash "if mbfl_getopts_islong_with \"--a=1 2\" a b; then echo \"\$a=\$b\"; fi"
    }
    -result {a=1 2}
}

mbfl_test getopts-2.7 "is long option with arg and blanks" {
    -body	{
	bash "if mbfl_getopts_islong_with \"--a=1\\\\\" a b; then echo \"\$a=\$b\"; fi"
    }
    -result a=1\\
}

mbfl_test getopts-2.8 "is long option with orphan =" {
    -body	{
	bash "if mbfl_getopts_islong_with --afasd=; then echo yes; else echo no; fi"
    }
    -result no
}

#PAGE

mbfl_test getopts-3.1 "is brief option" {
    -body	{
	bash "if mbfl_getopts_isbrief -a; then echo yes; else echo no; fi"
    }
    -result yes
}

mbfl_test getopts-3.2 "is brief option" {
    -body	{
	bash "if mbfl_getopts_isbrief -aa; then echo yes; else echo no; fi"
    }
    -result no
}

mbfl_test getopts-3.3 "is brief option" {
    -body	{
	bash "if mbfl_getopts_isbrief -1; then echo yes; else echo no; fi"
    }
    -result yes
}

mbfl_test getopts-3.4 "is brief option" {
    -body	{
	bash "if mbfl_getopts_isbrief -_; then echo yes; else echo no; fi"
    }
    -result no
}

mbfl_test getopts-3.5 "is brief option" {
    -body	{
	bash "if mbfl_getopts_isbrief -\[; then echo yes; else echo no; fi"
    }
    -result no
}

mbfl_test getopts-3.6 "is long option" {
    -body	{
	bash "if mbfl_getopts_isbrief -o a ; then echo \"\$a\"; fi"
    }
    -result o
}

#PAGE

mbfl_test getopts-4.1 "is brief option with arg" {
    -body	{
	bash "if mbfl_getopts_isbrief_with -a123; then echo yes; else echo no; fi"
    }
    -result yes
}

mbfl_test getopts-4.2 "is brief option with arg" {
    -body	{
	bash "if mbfl_getopts_isbrief_with -a; then echo yes; else echo no; fi"
    }
    -result no
}

mbfl_test getopts-4.3 "is brief option with arg" {
    -body	{
	bash "if mbfl_getopts_isbrief_with -_123; then echo yes; else echo no; fi"
    }
    -result yes
}

mbfl_test getopts-4.4 "is brief option with arg" {
    -body	{
	bash "if mbfl_getopts_isbrief_with -A123 a b; then echo \"\$a=\$b\"; fi"
    }
    -result {A=123}
}
#PAGE
## ---------------------------------------------------------
## End of "::test" namespace.
## ---------------------------------------------------------

::tcltest::cleanupTests
}
namespace delete ::test


### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#page"
# End:
