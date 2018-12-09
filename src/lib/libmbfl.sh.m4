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
# Copyright (c) 2003-2005, 2009, 2013, 2018 Marco Maggi <marco.maggi-ipsu@poste.it>
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

m4_include(base.sh)
m4_include(string.sh)
m4_include(atexit.sh)
m4_include(locations.sh)
m4_include(encode.sh)
m4_include(fd.sh)
m4_include(file.sh)
m4_include(actions.sh)
m4_include(getopts.sh)
m4_include(message.sh)
m4_include(program.sh)
m4_include(signal.sh)
m4_include(variable.sh)
m4_include(times-and-dates.sh)
m4_include(dialog.sh)
m4_include(system.sh)
m4_include(arrays.sh)
m4_include(interfaces.sh)
m4_include(main.sh)

### end of file
# Local Variables:
# mode: sh
# End:
