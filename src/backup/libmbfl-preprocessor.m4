m4_divert(-1)
# libmbfl-preprocessor.m4 --
#
# Part of: Marco's BASH Functions Library
# Contents: macros for the preprocessor
# Date: Sat Apr 19, 2003
#
# Abstract
#
#	Library of macros to preprocess BASH scripts using MBFL.
#
# Copyright (c) 2003-2005, 2009, 2013, 2018, 2020, 2023, 2024 Marco Maggi
# <mrc.mgg@gmail.com>
#
# This is free software; you can redistribute it and/or  modify it under the terms of the GNU Lesser
# General Public  License as published by  the Free Software  Foundation; either version 3.0  of the
# License, or (at your option) any later version.
#
# This library is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
# even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the  GNU Lesser General Public License along with this library;
# if not,  write to  the Free  Software Foundation,  Inc., 59  Temple Place,  Suite 330,  Boston, MA
# 02111-1307 USA.
#


#### initial setup

m4_changequote(`[[[', `]]]')


#### helper macros

m4_define([[[MBFL_SHARP]]],[[[#]]])

# Synopsis:
#
#    MBFL_P_ERRPRINT([[[this is an error message]]])
#
# Print to stderr an error message using the built-in facilities of GNU m4.
#
m4_define([[[MBFL_P_ERRPRINT]]],[[[m4_errprint(m4___program__:m4___file__:m4___line__:[[[ $1
]]])]]])

# Synopsis:
#
#    MBFL_P_WRONG_NUM_ARGS(MACRO_NAME, GIVEN_NUM_ARGS, EXPECTED_NUM_ARGS)
#
# Check the number of arguments given to a macro use: if it is wrong. print to stderr
# an error message using the built-in facilities of GNU m4.
#
m4_define([[[MBFL_P_WRONG_NUM_ARGS]]],[[[m4_dnl
m4_ifelse([[[$2]]],[[[$3]]],[[[MBFL_P_ERRPRINT([[[wrong number of parameter in use of $1: expected $3 got $2]]])]]])m4_dnl
]]])

# Synopsis:
#
#    MBFL_P_REMOVE_COMMA_FROM_ARGLIST(1, 2, 3, 4)
#    --> 1 2 3 4
#
# remove the commas from its arguments list.  To use this with "m4_shift()":
#
#    MBFL_P_REMOVE_COMMA_FROM_ARGLIST(m4_shift($@))
#
m4_define([[[MBFL_P_REMOVE_COMMA_FROM_ARGLIST]]],[[[m4_dnl
m4_ifelse([[[$1]]],,,[[[$1]]] [[[MBFL_P_REMOVE_COMMA_FROM_ARGLIST(m4_shift($@))]]])m4_dnl
]]])

m4_define([[[mbfl_p_qq]]],[[[m4_dnl
m4_ifelse($#,1,"${$1}",$#,2,"${$1[$2]}",[[[MBFL_P_ERRPRINT([[[wrong number of parameters in use of QQ: expected 1 or 2 got $#]]])]]])m4_dnl
]]])
m4_define([[[mbfl_p_ww]]],[[[m4_dnl
m4_ifelse($#,1,"${$1:?}",$#,2,"${$1[$2]:?}",[[[MBFL_P_ERRPRINT([[[wrong number of parameters in use of QQ: expected 1 or 2 got $#]]])]]])m4_dnl
]]])
m4_define([[[mbfl_p_rr]]],[[[m4_dnl
m4_ifelse($#,1,${$1:?},$#,2,${$1[$2]:?},[[[MBFL_P_ERRPRINT([[[wrong number of parameters in use of QQ: expected 1 or 2 got $#]]])]]])m4_dnl
]]])
m4_define([[[mbfl_p_ss]]],[[[m4_dnl
m4_ifelse($#,2,$1[$2],[[[MBFL_P_ERRPRINT([[[wrong number of parameters in use of QQ: expected 2 got $#]]])]]])m4_dnl
]]])

m4_define([[[PP]]],[[[m4_ifelse($#,2,${$1:?"missing parameter $1 $2 in call to '$FUNCNAME'"},
  [[[m4_errprint(m4___program__:m4___file__:m4___line__: wrong number of arguments in pp use ($#): $@
)]]])]]])

m4_define([[[MBFL_DEFINE_QQ_MACRO]]],[[[m4_dnl
m4_define([[[QQ]]],[[[mbfl_p_qq($]]]@[[[)]]])m4_dnl
m4_define([[[WW]]],[[[mbfl_p_ww($]]]@[[[)]]])m4_dnl
m4_define([[[RR]]],[[[mbfl_p_rr($]]]@[[[)]]])m4_dnl
m4_define([[[SS]]],[[[mbfl_p_ss($]]]@[[[)]]])m4_dnl
m4_define([[[PP]]],[[[mbfl_p_pp($]]]@[[[)]]])m4_dnl
]]])


#### function parameters handling

m4_define([[[mbfl_mandatory_parameter]]],[[[declare $4 $1=${$2:?"missing parameter $2 m4_ifelse($3,,$1,$3) in call to to '$FUNCNAME'"}]]])
m4_define([[[mbfl_mandatory_integer_parameter]]],[[[mbfl_mandatory_parameter($1,$2,$3,-i)]]])

m4_define([[[mbfl_optional_parameter]]],[[[declare $4 $1="${$2:-$3}"]]])
m4_define([[[mbfl_optional_integer_parameter]]],[[[mbfl_optional_parameter($1,$2,$3,-i)]]])

m4_define([[[mbfl_mandatory_nameref_parameter]]],[[[m4_dnl
declare mbfl_a_variable_$1=${$2:?"missing $3 parameter to '$FUNCNAME'"}; m4_dnl
declare -n $1=$[[[]]]mbfl_a_variable_$1 m4_dnl
]]])


#### script's command line arguments handling

# Synopsis:
#
#    mbfl_command_line_argument(VARNAME, ARGINDEX)
#
# Store in the  variable VARNAME the value  at key ARGINDEX in the  index array ARGV.
# The first argument has index 0.
#
m4_define([[[mbfl_command_line_argument]]],[[[declare $3 $1="${ARGV[$2]}"]]])

m4_define([[[mbfl_extract_command_line_argument]]],[[[m4_dnl
mbfl_command_line_argument($1,$2,$3); m4_dnl
mbfl_variable_unset(ARGV[$2]) m4_dnl
]]])


#### library loading and embedding

m4_define([[[mbfl_library_loader]]],[[[source m4_ifelse($1,,__MBFL_LIBMBFL_INSTALLATION_PATHNAME__,$1) || exit 100]]])
m4_define([[[mbfl_load_library]]],  [[[source m4_ifelse($1,,__MBFL_LIBMBFL_INSTALLATION_PATHNAME__,$1) || exit 100]]])

m4_define([[[mbfl_embed_library]]],[[[m4_undivert(m4_ifelse($1,,__MBFL_LIBMBFL_INSTALLATION_PATHNAME__,$1))]]])

m4_define([[[mbfl_linker_source_library_by_stem]]],[[[
if mbfl_linker_find_library_by_stem '$1'
then
    mbfl_slot_set(MBFL_LINKER_LOADED_LIBRARIES,$1,true)
    mbfl_load_library(mbfl_slot_qref(MBFL_LINKER_FOUND_LIBRARIES,$1))
fi
]]])


#### string macros

m4_define([[[mbfl_string_len]]],[[[m4_changecom([[[mbfl_beg]]],[[[mbfl_end]]])m4_dnl
${MBFL_SHARP()$1}m4_dnl
m4_changecom([[[MBFL_SHARP()]]])]]])

m4_define([[[mbfl_string_idx]]],[[[${$1:$2:1}]]])
m4_define([[[mbfl_string_qidx]]],[[["${$1:$2:1}"]]])

m4_define([[[mbfl_string_empty]]],[[[m4_changecom([[[mbfl_beg]]],[[[mbfl_end]]])m4_dnl
{ test ${MBFL_SHARP()$1} -eq 0; }m4_dnl
m4_changecom([[[MBFL_SHARP()]]])
]]])

m4_define([[[mbfl_string_not_empty]]],[[[m4_changecom([[[mbfl_beg]]],[[[mbfl_end]]])m4_dnl
{ test ${MBFL_SHARP()$1} -ne 0; }m4_dnl
m4_changecom([[[MBFL_SHARP()]]])]]])

m4_define([[[mbfl_string_last_char]]],[[[m4_changecom([[[mbfl_beg]]],[[[mbfl_end]]])m4_dnl
${$1:$((${MBFL_SHARP()$1} - 1)):1}m4_dnl
m4_changecom([[[MBFL_SHARP()]]])]]])

# We protect  the expansion  of these  macros by wrapping  the expression  into curly
# braces.
#
m4_define([[[mbfl_string_eq]]], [[[{ test $1  '=' $2; }]]])
m4_define([[[mbfl_string_neq]]],[[[{ test $1 '!=' $2; }]]])
m4_define([[[mbfl_string_lt]]], [[[{ test $1  '<' $2; }]]])
m4_define([[[mbfl_string_gt]]], [[[{ test $1  '>' $2; }]]])

# These implementations are wrong because they evaluate the arguments twice!!!
#
# m4_define([[[mbfl_string_le]]], [[[{ test $1  '<' $2 -o $1 '=' $2; }]]])
# m4_define([[[mbfl_string_ge]]], [[[{ test $1  '>' $2 -o $1 '=' $2; }]]])

m4_define([[[mbfl_string_le]]], [[[{ mbfl_string_less_or_equal    $1 $2; }]]])
m4_define([[[mbfl_string_ge]]], [[[{ mbfl_string_greater_or_equal $1 $2; }]]])

m4_define([[[mbfl_string_eq_yes]]],   [[[{ test $1  '=' 'yes'; }]]])
m4_define([[[mbfl_string_eq_no]]],    [[[{ test $1  '=' 'no'; }]]])
m4_define([[[mbfl_string_eq_true]]],  [[[{ test $1  '=' 'true'; }]]])
m4_define([[[mbfl_string_eq_false]]], [[[{ test $1  '=' 'false'; }]]])

m4_define([[[mbfl_string_neq_yes]]],   [[[{ test $1  '!=' 'yes'; }]]])
m4_define([[[mbfl_string_neq_no]]],    [[[{ test $1  '!=' 'no'; }]]])
m4_define([[[mbfl_string_neq_true]]],  [[[{ test $1  '!=' 'true'; }]]])
m4_define([[[mbfl_string_neq_false]]], [[[{ test $1  '!=' 'false'; }]]])

m4_define([[[mbfl_integer_eq]]], [[[{ test $1 -eq $2; }]]])
m4_define([[[mbfl_integer_neq]]],[[[{ test $1 -ne $2; }]]])
m4_define([[[mbfl_integer_lt]]], [[[{ test $1 -lt $2; }]]])
m4_define([[[mbfl_integer_gt]]], [[[{ test $1 -gt $2; }]]])
m4_define([[[mbfl_integer_le]]], [[[{ test $1 -le $2; }]]])
m4_define([[[mbfl_integer_ge]]], [[[{ test $1 -ge $2; }]]])


#### variables, arrays and slots handling

m4_define([[[mbfl_variable_unset]]],[[[unset -v $1]]])
m4_define([[[mbfl_unset_variable]]],[[[unset -v $1]]])

m4_define([[[mbfl_declare_index_array]]],  [[[declare -a $1[[[]]]m4_ifelse($2,,,=$2)]]])
m4_define([[[mbfl_declare_assoc_array]]], [[[declare -A $1[[[]]]m4_ifelse($2,,,=$2)]]])

m4_define([[[mbfl_slot_spec]]],   [[[$1[$2]]]])
m4_define([[[mbfl_slot_ref]]],    [[[${mbfl_slot_spec([[[$1]]],[[[$2]]])}]]])
m4_define([[[mbfl_slot_set]]],    [[[mbfl_slot_spec([[[$1]]],[[[$2]]])=[[[$3]]]]]])
m4_define([[[mbfl_slot_append]]], [[[mbfl_slot_spec([[[$1]]],[[[$2]]])+=[[[$3]]]]]])
m4_define([[[mbfl_slot_qref]]],   [[["mbfl_slot_ref([[[$1]]],[[[$2]]])"]]])

m4_define([[[mbfl_slots_number]]],[[[m4_changecom([[[mbfl_beg]]],[[[mbfl_end]]])m4_dnl
${MBFL_SHARP()$1[@]}m4_dnl
m4_changecom([[[MBFL_SHARP()]]])]]])

m4_define([[[mbfl_slot_value_len]]],[[[m4_changecom([[[mbfl_beg]]],[[[mbfl_end]]])m4_dnl
${MBFL_SHARP()$1[$2]}m4_dnl
m4_changecom([[[MBFL_SHARP()]]])]]])

m4_define([[[mbfl_slots_values]]],  [[[${$1[@]}]]])
m4_define([[[mbfl_slots_qvalues]]],[[["${$1[@]}"]]])

m4_define([[[mbfl_slots_keys]]],  [[[${!$1[@]}]]])
m4_define([[[mbfl_slots_qkeys]]],[[["${!$1[@]}"]]])


#### nameref variables handling

m4_define([[[mbfl_declare_nameref]]],[[[m4_dnl
  declare    mbfl_a_variable_$1=$2; m4_dnl
  declare -n $1=$[[[]]]mbfl_a_variable_$1 m4_dnl
]]])

m4_define([[[mbfl_declare_varref]]],[[[m4_dnl
  declare mbfl_a_variable_$1; m4_dnl
  mbfl_variable_alloc mbfl_a_variable_$1 $1; m4_dnl
  declare $3 $[[[mbfl_a_variable_$1]]]; m4_dnl
  declare -n $1=$[[[]]]mbfl_a_variable_$1; m4_dnl
  m4_ifelse([[[$2]]],,[[[$1=]]],[[[$1=$2]]])m4_dnl
]]])

m4_define([[[mbfl_declare_global_varref]]], [[[mbfl_declare_varref($1,$2,-g $3)]]])
m4_define([[[mbfl_declare_integer_varref]]],[[[mbfl_declare_varref($1,m4_ifelse([[[$2]]],,0, [[[$2]]]),-i $3)]]])

m4_define([[[mbfl_declare_index_array_varref]]],[[[mbfl_declare_varref($1,m4_ifelse([[[$2]]],,[[[()]]],[[[$2]]]),-a $3)]]])
m4_define([[[mbfl_declare_assoc_array_varref]]],[[[mbfl_declare_varref($1,m4_ifelse([[[$2]]],,[[[()]]],[[[$2]]]),-A $3)]]])

m4_define([[[mbfl_namevar]]],[[[mbfl_a_variable_$1]]])
m4_define([[[mbfl_datavar]]],[[[$[[[]]]mbfl_namevar([[[$1]]])]]])

m4_define([[[mbfl_undeclare_varref]]],[[[m4_dnl
  unset -v $mbfl_a_variable_$1; m4_dnl
  unset -v  mbfl_a_variable_$1; m4_dnl
  unset -v -n $1; m4_dnl
  unset -v    $1 m4_dnl
]]])
m4_define([[[mbfl_unset_varref]]],[[[mbfl_undeclare_varref($1)]]])

m4_define([[[mbfl_p_underscore_macro]]],[[[mbfl_datavar($1)]]])
m4_define([[[mbfl_p_default_object_underscore_macro_for_methods]]],[[[m4_ifelse($#,1, [[[mbfl_datavar([[[$1]]])]]], [[[mbfl_default_object_call_method mbfl_datavar($1) $2]]]) ]]])
m4_define([[[mbfl_p_default_object_underscore_macro_for_slots]]],[[[m4_ifelse($#,1,[[[mbfl_datavar([[[$1]]])]]],$#,2,[[[mbfl_slot_qref([[[$1]]],[[[$2]]])]]],$#,3,[[[mbfl_slot_set([[[$1]]],[[[$2]]],[[[$3]]])]]],[[[MBFL_P_ERRPRINT([[[wrong number of parameters in use of _: expected 1 or 2 got $#]]])]]])]]])

m4_define([[[MBFL_DEFINE_UNDERSCORE_MACRO]]],m4_dnl
[[[m4_define([[[_]]],[[[mbfl_p_underscore_macro($]]]@[[[)]]])]]])

m4_define([[[MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS]]],m4_dnl
[[[m4_define([[[_]]],[[[mbfl_p_default_object_underscore_macro_for_slots($]]]@[[[)]]])]]])

m4_define([[[MBFL_DEFINE_UNDERSCORE_MACRO_FOR_METHODS]]],m4_dnl
[[[m4_define([[[_]]],[[[mbfl_p_default_object_underscore_macro_for_methods($]]]@[[[)]]])]]])


#### defining program execution functions

m4_define([[[MBFL_DEFINE_PROGRAM_EXECUTOR_FUNCNAME_PREFIX]]],[[[$1[[[]]]program_]]])
m4_define([[[MBFL_DEFINE_PROGRAM_REPLACER_FUNCNAME_PREFIX]]],[[[$1[[[]]]program_replace_]]])

dnl Synopsis:
dnl
dnl   MBFL_DEFINE_PROGRAM_EXECUTOR(STEM, EXECUTABLE_PATHNAME, OPTIONAL_DEFAULT_FLAGS, OPTIONAL_FUNCTION_PREFIX)
dnl
dnl If we change this macro expansion: remember to update the documentation.
dnl
m4_define([[[MBFL_DEFINE_PROGRAM_EXECUTOR]]],[[[
function MBFL_DEFINE_PROGRAM_EXECUTOR_FUNCNAME_PREFIX([[[$4]]])[[[]]]$1 () {
    mbfl_declare_varref(PROGRAM)
    mbfl_program_found_var mbfl_datavar(PROGRAM) $2 || exit $?
    mbfl_program_exec "$PROGRAM" $3 "$[[[]]]@"
}
]]])

dnl Synopsis:
dnl
dnl   MBFL_DEFINE_PROGRAM_REPLACER(STEM, EXECUTABLE_PATHNAME, OPTIONAL_DEFAULT_FLAGS, OPTIONAL_FUNCTION_PREFIX)
dnl
dnl If we change this macro expansion: remember to update the documentation.
dnl
m4_define([[[MBFL_DEFINE_PROGRAM_REPLACER]]],[[[
function MBFL_DEFINE_PROGRAM_REPLACER_FUNCNAME_PREFIX([[[$4]]])[[[]]]$1 () {
    mbfl_declare_varref(PROGRAM)
    mbfl_program_found_var mbfl_datavar(PROGRAM) $2 || exit $?
    mbfl_program_replace "$PROGRAM" $3 "$[[[]]]@"
}
]]])


#### objects
#
# Usage example:
#
#    mbfl_default_class_declare(GREEK)
#    mbfl_default_object_declare(SELF)
#
#    mbfl_default_class_define  _(GREEK) _(mbfl_default_object) 'greek' alpha beta gamma
#    mbfl_default_object_define _(SELF)  _(GREEK) 1 2 3
#    mbfl_default_object_unset(SELF)
#

# Synopsis:
#
#   mbfl_default_object_declare(CLASS_NAME)
#   mbfl_default_object_declare_global(CLASS_NAME)
#   mbfl_default_object_unset(CLASS_NAME)
#
# Declare or  unset the variables  required to represent  an instance of  class whose
# superclass is "mbfl_default_object".
#
m4_define([[[mbfl_default_object_declare]]],        [[[mbfl_declare_index_array_varref([[[$1]]])]]])
m4_define([[[mbfl_default_object_declare_global]]], [[[mbfl_declare_index_array_varref([[[$1]]],,[[[-g]]])]]])
m4_define([[[mbfl_default_object_unset]]],          [[[mbfl_unset_varref([[[$1]]])]]])

# Synopsis:
#
#   mbfl_default_class_declare(CLASS_NAME)
#   mbfl_default_class_declare_global(CLASS_NAME)
#   mbfl_default_class_unset(CLASS_NAME)
#
# Declare or unset the variables required to represent an instance of metaclass whose
# superclass is "mbfl_default_class".
#
m4_define([[[mbfl_default_class_declare]]],        [[[mbfl_default_object_declare([[[$1]]])]]])
m4_define([[[mbfl_default_class_declare_global]]], [[[mbfl_default_object_declare_global([[[$1]]])]]])
m4_define([[[mbfl_default_class_unset]]],          [[[mbfl_default_object_unset([[[$1]]])]]])


#### exceptional-condition objects and exception-handlers

m4_define([[[mbfl_exception_raise_then_return_failure]]],[[[{ mbfl_exception_raise [[[$1]]] ; return_because_failure ; }]]])
m4_define([[[mbfl_location_leave_then_return_success]]], [[[{ mbfl_location_leave ; return_because_success ; }]]])
m4_define([[[mbfl_location_leave_then_return_failure]]], [[[{ mbfl_location_leave ; return_because_failure ; }]]])

m4_define([[[mbfl_check_mandatory_parameters_number]]],[[[m4_changecom([[[mbfl_beg]]],[[[mbfl_end]]])m4_dnl
m4_ifelse($#,[[[2]]],m4_dnl
[[[{ if (( $[[[]]]MBFL_SHARP > $2 || $1 > $[[[]]]MBFL_SHARP )) ; then mbfl_default_object_declare(CND) ; mbfl_wrong_parameters_number_condition_make _(CND) $FUNCNAME $[[[]]]MBFL_SHARP $1 $2 ; mbfl_exception_raise_then_return_failure(_(CND)) ; fi ; } ]]],m4_dnl
$#,[[[1]]],m4_dnl
[[[{ if (( $1 > $[[[]]]MBFL_SHARP )) ; then mbfl_default_object_declare(CND) ; mbfl_wrong_parameters_number_condition_make _(CND) $FUNCNAME $[[[]]]MBFL_SHARP $1 9999 ; mbfl_exception_raise_then_return_failure(_(CND)) ; fi ; } ]]],m4_dnl
[[[MBFL_P_ERRPRINT([[[wrong number of parameters]]]) m4_m4exit([[[1]]])]]])m4_dnl
m4_changecom([[[MBFL_SHARP()]]])]]])


#### miscellaneous macros

m4_define([[[mbfl_hook_declare]]],       [[[mbfl_declare_index_array_varref([[[$1]]])]]])
m4_define([[[mbfl_hook_global_declare]]],[[[mbfl_declare_index_array_varref([[[$1]]],,[[[-g]]])]]])


#### done

### end of file
m4_divert(0)m4_dnl
