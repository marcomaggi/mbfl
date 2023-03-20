#! libmbfl.bash --
#!
#! Part of: Marco's BASH Functions Library
#! Contents: library file
#! Date: Fri Nov 28, 2003
#!
#! Abstract
#!
#!	This is the  library file of MBFL. It must  be sourced in shell scripts at  the beginning of
#!	evaluation.
#!
#! Copyright (c) 2003-2005, 2009, 2013, 2018, 2020, 2023 Marco Maggi
#! <mrc.mgg@gmail.com>
#!
#! This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
#! General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
#! License, or (at your option) any later version.
#!
#! This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
#! even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
#! Lesser General Public License for more details.
#!
#! You should have received a copy of the  GNU Lesser General Public License along with this library;
#! if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
#! 02111-1307 USA.
#!

declare -r mbfl_LOADED_MBFL='yes'
shopt -s expand_aliases

m4_include(config-values.bash)
m4_include(base.bash)
m4_include(shell.bash)
m4_include(main.bash)
m4_include(string.bash)
m4_include(atexit.bash)
m4_include(locations.bash)
m4_include(variable.bash)
m4_include(arrays.bash)
m4_include(struct.bash)
m4_include(encode.bash)
m4_include(fd.bash)
m4_include(file.bash)
m4_include(actions.bash)
m4_include(getopts.bash)
m4_include(message.bash)
m4_include(program.bash)
m4_include(process.bash)
m4_include(signal.bash)
m4_include(times-and-dates.bash)
m4_include(dialog.bash)
m4_include(math.bash)
m4_include(system.bash)
m4_include(semver.bash)

#!# end of file
# Local Variables:
# mode: sh
# End:
