# dialog.sh.m4 --
# 
# Part of: Marco's BASH Functions Library
# Contents: dialog functions
# Date: Sun Dec 21, 2003
# 
# Abstract
# 
#       This file is a collection of functions used to interact to the
#       user at the console.
# 
# Copyright (c) 2003, 2004 Marco Maggi
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

function mbfl_dialog_yes_or_no () {
    local STRING="${1:?}"
    local PROMPT="${script_PROGNAME}: ${STRING}? (yes/no) "
    local ANS=


    read -e -p "${PROMPT}" ANS
    while test "$ANS" != 'yes' -a "$ANS" != 'no'; do
        echo 'Please answer yes or no.'
        read -e -p "${PROMPT}" ANS
    done
    
    test "$ANS" = yes && return 0
    return 1
}

### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#PAGE$"
# indent-tabs-mode: nil
# End:
