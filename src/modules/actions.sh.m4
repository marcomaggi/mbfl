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
    mbfl_action_sets_EXISTS[${ACTION_SET}]=yes
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
    # select this section.
    #
    mbfl_mandatory_parameter(ACTION_IDENTIFIER,4,identifier)

    # A string describing this action, to be used for the help screen.
    #
    mbfl_mandatory_parameter(ACTION_DESCRIPTION,5,description)

    if mbfl_actions_is_action_argument "$ACTION_IDENTIFIER"
    then mbfl_action_sets_EXISTS[${ACTION_SET}]=yes
    else
        mbfl_message_error "internal error: invalid action identifier: $ACTION_IDENTIFIER"
        exit_because_invalid_action_declaration
    fi

    if test -n "$ACTION_KEYWORD"
    then mbfl_action_sets_KEYWORDS[${ACTION_SET}-${ACTION_IDENTIFIER}]=${ACTION_KEYWORD}
    else
        mbfl_message_error "internal error: null keyword for action: $ACTION_IDENTIFIER"
        exit_because_invalid_action_declaration
    fi

    if test -n "$ACTION_SUBSET"
    then mbfl_action_sets_SUBSETS[${ACTION_SET}-${ACTION_IDENTIFIER}]=$ACTION_SUBSET
    else
        mbfl_message_error "internal error: null subset identifier for action: $ACTION_IDENTIFIER"
        exit_because_invalid_action_declaration
    fi

    mbfl_action_sets_DESCRIPTIONS[${ACTION_SET}-${ACTION_IDENTIFIER}]=$ACTION_DESCRIPTION
    return 0
}
#page
function mbfl_actions_is_action_argument () {
    mbfl_mandatory_parameter(ARGUMENT, 1, command line argument)
    local len="${#ARGUMENT}" i ch

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
        \( "$1" != '-' \)
}
#page
function mbfl_actions_dispatch () {
    mbfl_mandatory_parameter(ACTION_SET,1,action set)
    if test 1 -le $(($ARGC1 - $ARG1ST))
    then
        if test "${mbfl_action_sets_EXISTS[${ACTION_SET}]}" = yes
        then
            local IDENTIFIER=${ARGV1[$ARG1ST]}
        let ++ARG1ST
            ACTION_SUBSET=${mbfl_action_sets_SUBSETS[${ACTION_SET}-${IDENTIFIER}]}
            if test -n "${ACTION_SUBSET}" -a "${ACTION_SUBSET}" != NONE
            then
                # The  selected  action  has  a subset  of  actions,  so
                # dispatch them.
                mbfl_actions_dispatch "${ACTION_SUBSET}"
            else
                # The selected action is a leaf in the tree.
                local KEYWORD=${mbfl_action_sets_KEYWORDS[${ACTION_SET}-${IDENTIFIER}]}
                local BEFORE=script_before_parsing_option_$KEYWORD;
                local AFTER=script_after_parsing_option_$KEYWORD;
                local MAIN=script_action_$KEYWORD;
                if test "$(type -t $BEFORE)" = function
                then alias script_before_parsing_option=$BEFORE
                fi
                if test "$(type -t $AFTER)" = function
                then alias script_after_parsing_option=$AFTER
                fi
                if test "$(type -t $MAIN)" = function
                then mbfl_main_set_main $MAIN
                else
                    mbfl_message_error "main function for action '$KEY' not defined: $MAIN"
                    exit_because_missing_action_function
                fi
            fi
        else
            mbfl_message_error "invalid action identifier: $IDENTIFIER"
            exit_because_invalid_action_argument
        fi
    else
        mbfl_message_error 'invalid number of arguments while parsing action identifier'
        exit_because_wrong_num_args
    fi
}

### end of file
# Local Variables:
# mode: sh
# End:
