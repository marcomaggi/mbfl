# all.tcl --
# 
# Part of: Marco's BASH Functions Library
# Contents: main test file
# Date: Sat Apr 19, 2003
# 
# Abstract
# 
# 
# 
# Copyright (c) 2003 Marco Maggi
# 
# This library is free software;  you can redistribute it and/or modify
# it  under the  terms  of the  GNU  Lesser General  Public License  as
# published by the Free Software  Foundation; either version 2.1 of the
# License, or (at your option) any later version.
# 
# This library is  distributed in the hope that it  will be useful, but
# WITHOUT  ANY   WARRANTY;  without   even  the  implied   warranty  of
# MERCHANTABILITY  or FITNESS FOR  A PARTICULAR  PURPOSE.  See  the GNU
# Lesser General Public License for more details.
# 
# You  should have received  a copy  of the  GNU Lesser  General Public
# License along with  this library; if not, write  to the Free Software
# Foundation, Inc.,  59 Temple Place, Suite 330,  Boston, MA 02111-1307
# USA
# 

package require Tcl 8.4
package require tcltest 2.2

::tcltest::configure -verbose "pass error" -testdir \
	[file dirname [file normalize [info script]]]
eval ::tcltest::configure $argv

::tcltest::runAllTests

### end of file
