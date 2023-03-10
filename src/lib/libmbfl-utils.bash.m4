#! libmbfl-utils.bash --
#!
#! Part of: Marco's BASH Functions Library
#! Contents: utilities library file
#! Date: Nov 16, 2020
#!
#! Abstract
#!
#!	This is the utilities library file of MBFL.  It can be sourced in shell scripts at the
#!	beginning of evaluation.
#!
#! Copyright (c) 2020, 2023 Marco Maggi
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

if mbfl_string_neq_yes("$mbfl_INTERACTIVE")
then declare -r mbfl_LOADED_MBFLUTILS='yes'
fi

m4_include(utils-file.bash)

#!# end of file
# Local Variables:
# mode: sh
# End:
