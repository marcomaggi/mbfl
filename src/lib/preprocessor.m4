m4_divert(-1)m4_dnl
m4_dnl preprocessor.m4 --
m4_dnl
m4_dnl Part of: Marco's BASH Functions Library
m4_dnl Contents: macros for the preprocessor
m4_dnl Date: Sat Apr 19, 2003
m4_dnl
m4_dnl Abstract
m4_dnl
m4_dnl	Library of macros to preprocess BASH scripts using MBFL.
m4_dnl
m4_dnl Copyright (c) 2003-2005, 2009, 2013, 2018 Marco Maggi
m4_dnl <marco.maggi-ipsu@poste.it>
m4_dnl
m4_dnl This  is free  software; you  can redistribute  it and/or  modify it
m4_dnl under  the  terms  of  the  GNU Lesser  General  Public  License  as
m4_dnl published by the Free Software Foundation; either version 3.0 of the
m4_dnl License, or (at your option) any later version.
m4_dnl
m4_dnl This library is distributed in the  hope that it will be useful, but
m4_dnl WITHOUT  ANY   WARRANTY;  without  even  the   implied  warranty  of
m4_dnl MERCHANTABILITY or  FITNESS FOR A  PARTICULAR PURPOSE.  See  the GNU
m4_dnl Lesser General Public License for more details.
m4_dnl
m4_dnl You should  have received a  copy of  the GNU Lesser  General Public
m4_dnl License along with this library; if  not, write to the Free Software
m4_dnl Foundation, Inc., 59 Temple Place,  Suite 330, Boston, MA 02111-1307
m4_dnl USA.
m4_dnl


m4_dnl initial setup

m4_changequote(`[[[', `]]]')


m4_dnl function parameters handling

m4_define([[[mbfl_mandatory_parameter]]],[[[local $1=${$2:?"missing $3 parameter to '${FUNCNAME}'"}]]])
m4_define([[[mbfl_mandatory_integer_parameter]]],[[[local -i $1=${$2:?"missing $3 parameter to '${FUNCNAME}'"}]]])

m4_define([[[mbfl_optional_parameter]]],[[[local $1="${$2:-$3}"]]])
m4_define([[[mbfl_optional_integer_parameter]]],[[[local -i $1="${$2:-$3}"]]])

m4_define([[[mbfl_mandatory_nameref_parameter]]],[[[m4_dnl
local mbfl_a_variable_$1=${$2:?"missing $3 parameter to '${FUNCNAME}'"}
local -n $1=$[[[]]]mbfl_a_variable_$1
]]])


m4_dnl script's command line arguments handling

m4_define([[[mbfl_command_line_argument]]],[[[local $1="${ARGV[$2]]]}"]]])


m4_dnl library loading and embedding

m4_define([[[mbfl_library_loader]]],[[[
declare mbfl_INTERACTIVE=no
declare mbfl_LOADED=no
declare mbfl_HARDCODED=$1
declare mbfl_INSTALLED=$(type -p mbfl-config &>/dev/null && mbfl-config) &>/dev/null

declare item
for item in "$MBFL_LIBRARY" "$mbfl_HARDCODED" "$mbfl_INSTALLED"
do
    if test -n "$item" -a -f "$item" -a -r "$item"
    then
        if source "$item" &>/dev/null
	then break
	else
            printf '%s error: loading MBFL file "%s"\n' "$script_PROGNAME" "$item" >&2
            exit 100
	fi
    fi
done
unset -v item
if test "$mbfl_LOADED" != yes
then
    printf '%s error: incorrect evaluation of MBFL\n' "$script_PROGNAME" >&2
    exit 100
fi
]]])

m4_define([[[mbfl_embed_library]]],[[[m4_include(__MBFL_LIBRARY__)]]])


m4_dnl handling of variables with NAMEREF attribute

dnl Synopsis:
dnl
dnl   mbfl_local_nameref(NAME, DATA_VARNAME_EXPR)
dnl
dnl It expands into:
dnl
dnl   local mbfl_a_variable_NAME=DATA_VARNAME_EXPR
dnl   local -n NAME=$mbfl_a_variable_NAME
dnl
dnl Declare a proxy variable NAME aliasing the data variable whose value
dnl is the result of evaluating DATA_VARNAME_EXPR.
dnl
m4_define([[[mbfl_local_nameref]]],[[[m4_dnl
  local mbfl_a_variable_$1=$2
  local -n $1=$[[[]]]mbfl_a_variable_$1
]]])

m4_dnl Synopsis:
m4_dnl
m4_dnl   mbfl_local_varref(VARNAME, INIT_VALUE, LOCAL_OPTIONS)
m4_dnl
m4_dnl It expands into:
m4_dnl
m4_dnl   local mbfl_a_variable_VARNAME
m4_dnl   mbfl_variable_alloc mbfl_a_variable_VARNAME
m4_dnl   local LOCAL_OPTIONS $mbfl_a_variable_VARNAME
m4_dnl   local -n VARNAME=$mbfl_a_variable_VARNAME
m4_dnl
m4_dnl and when INIT_VALUE is not empty, it finishes with:
m4_dnl
m4_dnl   VARNAME=INIT_VALUE
m4_dnl
m4_dnl Define a  local "proxy variable"  VARNAME referencing a  local "data
m4_dnl variable"  with unique  name.  The  data variable  has the  optional
m4_dnl attributes    LOCAL_OPTIONS.      A    further     local    variable
m4_dnl mbfl_a_variable_VARNAME holds the name of the data variable.
m4_dnl
m4_define([[[mbfl_local_varref]]],[[[m4_dnl
  local mbfl_a_variable_$1
  mbfl_variable_alloc mbfl_a_variable_$1
  local $3 $[[[mbfl_a_variable_$1]]]
  local -n $1=$[[[]]]mbfl_a_variable_$1
  m4_ifelse($2,,,$1=$2)m4_dnl
]]])

m4_dnl Synopsis:
m4_dnl
m4_dnl   mbfl_global_varref(VARNAME, INIT_VALUE, DECLARE_OPTIONS)
m4_dnl
m4_dnl Expands into:
m4_dnl
m4_dnl   local mbfl_a_variable_VARNAME
m4_dnl   mbfl_variable_alloc mbfl_a_variable_VARNAME
m4_dnl   declare -g DECLARE_OPTIONS $mbfl_a_variable_VARNAME
m4_dnl   local -n VARNAME=$mbfl_a_variable_VARNAME
m4_dnl
m4_dnl and when INIT_VALUE is not empty, it finishes with:
m4_dnl
m4_dnl   VARNAME=INIT_VALUE
m4_dnl
m4_dnl Define a global "proxy variable"  VARNAME referencing a global "data
m4_dnl variable"  with unique  name.  The  data variable  has the  optional
m4_dnl attributes    DECLARE_OPTIONS.     A   further    global    variable
m4_dnl mbfl_a_variable_VARNAME holds the name of the data variable.
m4_dnl
m4_define([[[mbfl_global_varref]]],[[[m4_dnl
  local mbfl_a_variable_$1
  mbfl_variable_alloc mbfl_a_variable_$1
  declare -g $3 $[[[mbfl_a_variable_$1]]]
  local   -n $1=$[[[]]]mbfl_a_variable_$1
  m4_ifelse($2,,,$1=$2)m4_dnl
]]])

m4_define([[[mbfl_local_index_array_varref]]],[[[mbfl_local_varref($1,$2,-a $3)]]])
m4_define([[[mbfl_local_assoc_array_varref]]],[[[mbfl_local_varref($1,$2,-A $3)]]])
m4_define([[[mbfl_global_index_array_varref]]],[[[mbfl_global_varref($1,$2,-a $3)]]])
m4_define([[[mbfl_global_assoc_array_varref]]],[[[mbfl_global_varref($1,$2,-A $3)]]])

m4_define([[[mbfl_namevar]]],[[[mbfl_a_variable_$1]]])
m4_define([[[mbfl_datavar]]],[[[$[[[]]]mbfl_namevar($1)]]])

m4_define([[[mbfl_unset_varref]]],[[[m4_dnl
  unset -v $mbfl_a_variable_$1
  unset -v mbfl_a_variable_$1
  unset -v -n $1
  unset -v $1
]]])


m4_dnl array slots

m4_define([[[mbfl_slot_ref]]],[[[${$1[$2]}]]])
m4_define([[[mbfl_slot_set]]],$1[$2]=$3)


m4_dnl string macros

m4_define([[[mbfl_string_len]]],[[[${[[[#]]]$1}]]])
m4_define([[[mbfl_string_idx]]],[[[${$1:$2:1}]]])


m4_dnl done

m4_dnl end of file
m4_divert(0)m4_dnl
