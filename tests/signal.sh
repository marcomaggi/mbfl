# signal.sh --
# 
# Part of: Marco's BASH Functions Library
# Contents: test script for libsignal
# Date: Mon Jul  7, 2003
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
# $Id: signal.sh,v 1.4 2003/11/28 10:28:42 marco Exp $
#

for lib in signal.sh message.sh
do
    for dir in $PWD $PWD/..
    do
	LIB="$dir/$lib"
	if test -f "$LIB"
	then source $LIB
	fi
    done
done


function handler () {
    local SIGSPEC="${1:?}"
    local id="${2:?}"

    echo "signal.sh: received ${SIGSPEC}, id=${id}, flag=${flag}"
    flag=$flag+1
    return 0
}

k=$(mbfl_signal_attach SIGUSR1	"handler SIGUSR1 1")
k=$(mbfl_signal_attach SIGUSR1	"handler SIGUSR1 2")
k=$(mbfl_signal_attach SIGUSR2	"handler SIGUSR2 1")
k=$(mbfl_signal_attach SIGUSR2	"handler SIGUSR2 2")
k=$(mbfl_signal_attach SIGTERM	"handler SIGTERM 1")
k=$(mbfl_signal_attach SIGTERM	"handler SIGTERM 2")
k=$(mbfl_signal_attach EXIT	"handler EXIT 1")
k=$(mbfl_signal_attach EXIT	"handler EXIT 2")

k1=$(mbfl_signal_attach SIGTERM	"handler SIGTERM 3")
k2=$(mbfl_signal_attach SIGTERM	"handler SIGTERM 4")

mbfl_signal_detach $k1
mbfl_signal_detach $k2

mbfl_signal_inspect

declare -i i=0 flag=0

while test a = a
do
    i=$i+1
    if test $flag = 5
    then break
    fi
done

echo quitting
exit 0

### end of file
# Local Variables:
# page-delimiter: "^#PAGE$"
# End:
