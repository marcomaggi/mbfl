# mbflpp.sh --
# 
# Part of: Marco's BASH Functions Library
# Contents: script preprocessor
# Date: Tue Mar 29, 2005
# 
# Abstract
# 
#	Preprocessor for BASH scripts using MBFL.
# 
# Copyright (c) 2005 Marco Maggi
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

#page
## ------------------------------------------------------------
## MBFL's related options and variables.
## ------------------------------------------------------------

script_PROGNAME=mbflpp.sh
script_VERSION='@PACKAGE_XVERSION@'
script_COPYRIGHT_YEARS=2005
script_AUTHOR='Marco Maggi'
script_LICENSE=GPL
script_USAGE="usage: ${script_PROGNAME} [options] <INFILE >OUTFILE"
script_DESCRIPTION='Script preprocessor for MBFL.'

source "${MBFL_LIBRARY:=`mbfl-config`}"

# keyword default-value brief-option long-option has-argument description
mbfl_declare_option ALPHA no a alpha noarg "selects action alpha"
mbfl_declare_option BETA "" b beta  witharg "selects option beta"
mbfl_declare_option VALUE 0 "" value witharg "selects a value"
mbfl_declare_option FILE 0 f file witharg "selects a file"
mbfl_declare_option ENABLE no e enable noarg "enables a feature"
mbfl_declare_option DISABLE no d disable noarg "disables a feature"

mbfl_declare_program m4

#page
## ------------------------------------------------------------
## Global variables.
## ------------------------------------------------------------

hidden_option_DATADIR='@datadir@/@PACKAGE_NAME@_@PACKAGE_XVERSION@'

#page
## ------------------------------------------------------------
## Main functions.
## ------------------------------------------------------------

function main () {
    local M4_FLAGS='--prefix-builtins'
    local libfile=${hidden_option_DATADIR}/preprocessor.m4

    M4_FLAGS="${M4_FLAGS} --include=${libfile}"
set -x
    program_m4 ${M4_FLAGS}
}

#page
## ------------------------------------------------------------
## Program interfaces.
## ------------------------------------------------------------

function program_m4 () {
    local M4=`mbfl_program_found m4`
    mbfl_program_exec ${M4} "$@"
}

#page
## ------------------------------------------------------------
## Let's go.
## ------------------------------------------------------------

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
