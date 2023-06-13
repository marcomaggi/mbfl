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

m4_undivert(config-values.bash)
m4_undivert(base.bash)
m4_undivert(main.bash)
m4_undivert(string.bash)
m4_undivert(integers.bash)
m4_undivert(variable.bash)
m4_undivert(atexit.bash)
m4_undivert(arrays.bash)
m4_undivert(functions.bash)
m4_undivert(message.bash)
m4_undivert(object.bash)
m4_undivert(hooks.bash)
m4_undivert(locations.bash)
m4_undivert(encode.bash)
m4_undivert(fd.bash)
m4_undivert(file.bash)
m4_undivert(actions.bash)
m4_undivert(getopts.bash)
m4_undivert(program.bash)
m4_undivert(process.bash)
m4_undivert(exceptional-conditions.bash)
m4_undivert(exception-handlers.bash)
m4_undivert(signal.bash)
m4_undivert(times-and-dates.bash)
m4_undivert(dialog.bash)
m4_undivert(math.bash)
m4_undivert(system.bash)
m4_undivert(semver.bash)

function mbfl_library_initialise_libmbfl () {
    mbfl_initialise_module_exceptional_conditions
    mbfl_initialise_module_exception_handlers
    mbfl_initialise_module_semver
}

mbfl_library_initialise_libmbfl

#!# end of file
# Local Variables:
# mode: sh
# End:
