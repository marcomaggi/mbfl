m4_divert(-1)m4_dnl
# macros.m4 --
# 
# Part of: Marco's BASH Functions Library
# Contents: macros for the preprocessor
# Date: Sat Apr 19, 2003
# 
# Abstract
# 
# 
# 
# Copyright (c) 2003 Marco Maggi
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

m4_changequote([[, ]])

m4_define([[mandatory_parameter]],
	[[local $1="${$2:?missing $3 parameter to ${FUNCNAME}}"]])
m4_define([[optional_parameter]], [[local $1="${$2:-$3}"]])

### end of file
# Local Variables:
# mode: m4
# page-delimiter: "^#PAGE$"
# End:
m4_divert(0)m4_dnl
