# setup.tcl --
# 
# Part of: Marco's BASH Functions Library
# Contents: sets up the test environment
# Date: Fri Nov 28, 2003
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
# $Id: setup.tcl,v 1.1.1.3 2003/12/17 12:43:50 marco Exp $
#


package require Tcl 8.4
package require tcltest 2.2

::tcltest::configure -verbose "pass error" -testdir \
	[file dirname [file normalize [info script]]]
eval ::tcltest::configure $argv

namespace eval ::test {

    variable	libpath $env(builddir)
    variable	bash [auto_execok bash]

    if { ! [file isdirectory $env(TMPDIR)] } {
	error "unexistent directory for temporary files (TMPDIR: $env(TMPDIR))"
    }
    if { ! [file writable $env(TMPDIR)] } {
	error "unwritable directory for temporary files (TMPDIR: $env(TMPDIR))"
    }
    variable	tmpdir [file join $env(TMPDIR) tcltest.[pid]]
    ::tcltest::configure -tmpdir $tmpdir

    
    proc bash { command } {
	variable	bash
	variable	precmd

	set command [format "%s; %s" $precmd $command]

	if { [catch {
	    set result [exec $bash -c $command 2>@stderr]
	} res] } {
	    puts stderr $res
	    return
	}
	return $result
    }
}

### end of file
# Local Variables:
# mode: tcl
# page-delimiter: "^#PAGE"
# End:
