#
# Part of: Marco's Bash Functions Library
# Contents: command line actions processing
# Date: Mon May 27, 2013
#
# Abstract
#
#
#
# Copyright (C) 2013 Marco Maggi <marcomaggi@gna.org>
#
# This  program  is free  software:  you  can redistribute  it
# and/or modify it  under the terms of the  GNU General Public
# License as published by the Free Software Foundation, either
# version  3 of  the License,  or (at  your option)  any later
# version.
#
# This  program is  distributed in  the hope  that it  will be
# useful, but  WITHOUT ANY WARRANTY; without  even the implied
# warranty  of  MERCHANTABILITY or  FITNESS  FOR A  PARTICULAR
# PURPOSE.   See  the  GNU  General Public  License  for  more
# details.
#
# You should  have received a  copy of the GNU  General Public
# License   along   with    this   program.    If   not,   see
# <http://www.gnu.org/licenses/>.
#

#page
test "$mbfl_INTERACTIVE" = yes || {
    declare -A mbfl_action_sets_EXISTS
    declare -A mbfl_action_sets_SUBSETS
    declare -A mbfl_action_sets_KEYWORDS
    declare -A mbfl_action_sets_DESCRIPTIONS
}

function mbfl_declare_action_set () {
    mbfl_mandatory_parameter(ACTION_SET,1,action set)
    if mbfl_actions_valid_string_as_action_set_identifier "$ACTION_SET"
    then mbfl_action_sets_EXISTS[${ACTION_SET}]=yes
    else
        mbfl_message_error "invalid action set identifier. \"$ACTION_SET\""
        exit_because_invalid_action_declaration
    fi
}

#page
function mbfl_declare_action () {
    # The name of the action set this action belongs to.
    #
    mbfl_mandatory_parameter(ACTION_SET,1,action set)

    # A unique string (in this script) identifying this action.
    #
    mbfl_mandatory_parameter(ACTION_KEYWORD,2,keyword)

    # If $ACTION_SUBSET  is "NONE" it means  that this action is  a leaf
    # and it will set the main function to run.
    #
    mbfl_mandatory_parameter(ACTION_SUBSET,3,subset)

    # A string  representing the  argument on the  command line  used to
    # select this action.
    #
    mbfl_mandatory_parameter(ACTION_IDENTIFIER,4,identifier)

    # A string  describing this action, to  be used to compose  the help
    # screen.
    #
    mbfl_mandatory_parameter(ACTION_DESCRIPTION,5,description)

    local KEY="${ACTION_SET}-${ACTION_IDENTIFIER}"

    if ! mbfl_actions_valid_string_as_action_argument "$ACTION_IDENTIFIER"
    then
        mbfl_message_error "internal error: invalid action identifier: $ACTION_IDENTIFIER"
        exit_because_invalid_action_declaration
    fi

    if mbfl_actions_valid_string_as_keyword_identifier "$ACTION_KEYWORD"
    then mbfl_action_sets_KEYWORDS[${KEY}]=${ACTION_KEYWORD}
    else
        mbfl_message_error "internal error: invalid keyword for action \"$ACTION_IDENTIFIER\": \"$ACTION_KEYWORD\""
        exit_because_invalid_action_declaration
    fi

    if mbfl_actions_set_exists_or_none "$ACTION_SUBSET"
    then mbfl_action_sets_SUBSETS[${KEY}]=$ACTION_SUBSET
    else
        mbfl_message_error \
            "internal error: invalid or non-existent action subset identifier for action \"$ACTION_IDENTIFIER\": \"$ACTION_SUBSET\""
        exit_because_invalid_action_declaration
    fi

    mbfl_action_sets_DESCRIPTIONS[${KEY}]=$ACTION_DESCRIPTION
    return 0
}
#page
function mbfl_actions_valid_string_as_action_set_identifier () {
    mbfl_p_actions_valid_string_as_identifier "$1"
}
function mbfl_actions_valid_string_as_keyword_identifier () {
    mbfl_p_actions_valid_string_as_identifier "$1"
}
function mbfl_actions_valid_string_as_action_argument () {
    mbfl_p_actions_valid_string_as_identifier "$1"
}
function mbfl_p_actions_valid_string_as_identifier () {
    # Return  0 if  ARGUMENT is  a  valid string  to be  used as  action
    # selector argument; else return 1.
    #
    mbfl_mandatory_parameter(ARGUMENT, 1, string)
    local len="${#ARGUMENT}" i ch
    test $len = 0 && return 1
    ch="${ARGUMENT:0:1}"
    mbfl_p_actions_not_first_char_in_action_argument_name "$ch" && return 1
    for ((i=1; $i < $len; ++i))
    do
        ch="${ARGUMENT:$i:1}"
        mbfl_p_actions_not_char_in_action_argument_name "$ch" && return 1
    done
    return 0
}
function mbfl_p_actions_not_first_char_in_action_argument_name () {
    test \
        \( "$1" \< A -o Z \< "$1" \) -a \
        \( "$1" \< a -o z \< "$1" \)
}
function mbfl_p_actions_not_char_in_action_argument_name () {
    test \
        \( "$1" \< A -o Z \< "$1" \) -a \
        \( "$1" \< a -o z \< "$1" \) -a \
        \( "$1" \< 0 -o 9 \< "$1" \) -a \
        \( "$1" != '-' \)            -a \
        \( "$1" != '_' \)
}
#page
function mbfl_actions_set_exists () {
    # Return 0  if ACTION_SET  is the identifier  of an  existent action
    # set; else return 1.
    #
    mbfl_mandatory_parameter(ACTION_SET,1,action set)
    mbfl_actions_valid_string_as_action_set_identifier "$ACTION_SET" \
        && test "${mbfl_action_sets_EXISTS[${ACTION_SET}]}" \
        -a "${mbfl_action_sets_EXISTS[${ACTION_SET}]}" = yes
}
function mbfl_actions_set_exists_or_none () {
    # Return 0 if ACTION_SET is the identifier of an existent action set
    # or it is the string "NONE"; else return 1.
    #
    mbfl_mandatory_parameter(ACTION_SET,1,action set)
    mbfl_actions_valid_string_as_action_set_identifier "$ACTION_SET" \
        && test \
        "$ACTION_SET" = NONE \
        -o \( "${mbfl_action_sets_EXISTS[${ACTION_SET}]}" \
              -a "${mbfl_action_sets_EXISTS[${ACTION_SET}]}" = yes \)
}
#page
function mbfl_actions_dispatch () {
    # Parse the  next command line  argument and select  accordingly the
    # functions for the main module.
    #
    # Upon entering this function: the  global variable ARGV1 must be an
    # array  containing  all  the  command line  arguments;  the  global
    # variable  ARGC1 must  be  an integer  representing  the number  of
    # values in  ARGV1; the  global variable ARG1ST  must be  an integer
    # representing  the  index in  ARGV1  of  the  next argument  to  be
    # processed.
    #
    mbfl_mandatory_parameter(ACTION_SET,1,action set)

    # It  is an  error if  this function  is called  with an  action set
    # identifier specifying a non-existent action set.
    if ! mbfl_actions_set_exists "${ACTION_SET}"
    then
        mbfl_message_error "invalid action identifier: \"${ACTION_SET}\""
        return 1
    fi

    # If  there are  no  more  command lin  arguments:  just accept  the
    # previously selected values for the functions.
    if test $ARG1ST = $ARGC1
    then return 0
    fi

    local IDENTIFIER=${ARGV1[$ARG1ST]}
    local KEY="${ACTION_SET}-${IDENTIFIER}"
    local ACTION_SUBSET=${mbfl_action_sets_SUBSETS[${KEY}]}
    local ACTION_KEYWORD=${mbfl_action_sets_KEYWORDS[${KEY}]}
    #mbfl_message_debug "processing argument '$IDENTIFIER' for action selection"
    if test -z "${ACTION_KEYWORD}"
    then
        # The next  argument from  the command line  is *not*  an action
        # identifier:  just leave  it alone.   We accept  the previously
        # selected functions and return success.
        #mbfl_message_debug "argument '$IDENTIFIER' is not an action identifier"
        return 0
    else
        # The  next  argument  from  the command  line  *is*  an  action
        # identifier: consume it and select its functions.
        let ++ARG1ST
        mbfl_main_set_before_parsing_options "script_before_parsing_options_$ACTION_KEYWORD"
        mbfl_main_set_after_parsing_options  "script_after_parsing_options_$ACTION_KEYWORD"
        mbfl_main_set_main "script_action_$ACTION_KEYWORD"
        if test "${ACTION_SUBSET}" != NONE
        then
            # The selected action has a  subset of actions: dispatch the
            # subset.
            #mbfl_message_debug "argument '$IDENTIFIER' is an action identifier with action subset"
            mbfl_actions_dispatch "${ACTION_SUBSET}"
        else
            # The selected  action has *no*  subset of actions: it  is a
            # leaf  in  the actions  tree.   Stop  recursing and  return
            # success.
            #mbfl_message_debug "argument '$IDENTIFIER' is an action identifier without action subset"
            return 0
        fi
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
