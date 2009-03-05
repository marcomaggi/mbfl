m4_divert(-1)m4_dnl
# macros.m4 --
# 
# Part of: Marco's BASH Functions Library
# Contents: macros for the preprocessor
# Date: Sat Apr 19, 2003
# 
# Abstract
# 
#	Library of macros to preprocess BASH scripts using MBFL.
# 
# Copyright (c) 2003, 2004, 2005 Marco Maggi
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

m4_changequote(`[[', `]]')

m4_define([[mandatory_parameter]],[[local $1=${$2:?"missing $3 parameter to '${FUNCNAME}'"}]])
m4_define([[optional_parameter]],[[local $1="${$2:-$3}"]])

m4_define([[command_line_argument]],[[local $1="${ARGV[$2]}"]])

### end of file
# Local Variables:
# mode: m4
# End:
m4_divert(0)m4_dnl
