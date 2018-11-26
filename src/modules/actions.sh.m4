#
# Part of: Marco's Bash Functions Library
# Contents: command line actions processing
# Date: Mon May 27, 2013
#
# Abstract
#
#
#
# Copyright (C) 2013, 2018 Marco Maggi <marco.maggi-ipsu@poste.it>
#
# This is free software; you  can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the
# Free Software  Foundation; either version  3.0 of the License,  or (at
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
# USA.
#

#page
#### global variables

if test "$mbfl_INTERACTIVE" != 'yes'
then
    # Associative array: the keys are the  names of the action sets, the
    # values are "true".   If a string represents the name  of an action
    # set: it is a key in this  array.  If a string does *not* represent
    # the name of an action set: it is not a key in this array.
    #
    declare -A mbfl_action_sets_EXISTS

    # Associative array: the keys are strings like:
    #
    #   ${ACTION_SET}-${ACTION_IDENTIFIER}
    #
    # the  values are  the names  o the  actions sets  being subsets  of
    # $ACTION_SET.
    #
    # Every  action   set  might   be  associated  to   multiple  action
    # identifiers.
    #
    # * If the  pair $ACTION_SET, $ACTION_IDENTIFIER is  a non-leaf node
    #   in the actions tree: it has  an action subset, whose name is the
    #   value in this array.
    #
    # * If the  pair $ACTION_SET, $ACTION_IDENTIFIER  is a leaf  node in
    #   the actions tree: it has no action subset, and the value in this
    #   this array is the special name "NONE".
    #
    declare -A mbfl_action_sets_SUBSETS

    # Associative array: the keys are strings like:
    #
    #   ${ACTION_SET}-${ACTION_IDENTIFIER}
    #
    # the  values  are  strings  used  to  compose  the  function  names
    # associated with the script action.
    #
    # Every  action   set  might   be  associated  to   multiple  action
    # identifiers.  The  strings from  this array's  values are  used to
    # compose  the  main function  name,  the  "before parsing  options"
    # function  name,  the  "after  parsing options"  function  name  as
    # follows:
    #
    #   script_before_parsing_options_$KEYWORD
    #   script_after_parsing_options_$KEYWORD
    #   script_action_$KEYWORD
    #
    declare -A mbfl_action_sets_KEYWORDS

    # Associative array: the keys are strings like:
    #
    #   ${ACTION_SET}-${ACTION_IDENTIFIER}
    #
    # the  values   are  strings  representing  a   description  of  the
    # associated  script  action.   Such   descriptions  are  used  when
    # composing the help screen.
    #
    declare -A mbfl_action_sets_DESCRIPTIONS

    # Associative array: the keys are  the ${ACTION_SET}, the values are
    # strings representing the action command line arguments.
    #
    declare -A mbfl_action_sets_IDENTIFIERS

    # If "mbfl_actions_dispatch()"  selects an  action set: its  name is
    # stored  here.   This variable  is  used  when composing  the  help
    # screen.
    #
    declare mbfl_action_sets_SELECTED_SET=MAIN
fi

#page
# Declare a new action set.
#
function mbfl_declare_action_set () {
    mbfl_mandatory_parameter(ACTION_SET,1,action set)
    if mbfl_string_is_name "$ACTION_SET"
    then
        if mbfl_string_is_empty "${mbfl_action_sets_EXISTS[${ACTION_SET}]}"
        then mbfl_action_sets_EXISTS[${ACTION_SET}]=true
        else
            mbfl_message_error_printf 'action set declared twice: "%s"' "$ACTION_SET"
	    exit_because_invalid_action_declaration
        fi
    else
        mbfl_message_error_printf 'invalid action set identifier: "%s"' "$ACTION_SET"
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

    local KEY=${ACTION_SET}-${ACTION_IDENTIFIER}

    if ! mbfl_string_is_identifier "$ACTION_IDENTIFIER"
    then
        mbfl_message_error_printf 'internal error: invalid action identifier: "%s"' "$ACTION_IDENTIFIER"
        exit_because_invalid_action_declaration
    fi

    if mbfl_string_is_name "$ACTION_KEYWORD"
    then mbfl_action_sets_KEYWORDS[${KEY}]=${ACTION_KEYWORD}
    else
        mbfl_message_error_printf \
	    'internal error: invalid keyword for action "%s": "%s"' \
	    "$ACTION_IDENTIFIER" "$ACTION_KEYWORD"
        exit_because_invalid_action_declaration
    fi

    if mbfl_actions_set_exists_or_none "$ACTION_SUBSET"
    then mbfl_action_sets_SUBSETS[${KEY}]=$ACTION_SUBSET
    else
        mbfl_message_error_printf \
	    'internal error: invalid or non-existent action subset identifier for action "%s": "%s"' \
	    "$ACTION_IDENTIFIER" "$ACTION_SUBSET"
        exit_because_invalid_action_declaration
    fi

    mbfl_action_sets_DESCRIPTIONS[${KEY}]=$ACTION_DESCRIPTION
    mbfl_action_sets_IDENTIFIERS[${ACTION_SET}]+=" ${ACTION_IDENTIFIER}"
    return 0
}

#page
# Return 0  if ACTION_SET is the  identifier of an existent  action set;
# else return 1.
#
function mbfl_actions_set_exists () {
    mbfl_mandatory_parameter(ACTION_SET,1,action set)
    mbfl_string_is_name "$ACTION_SET" && ${mbfl_action_sets_EXISTS[${ACTION_SET}]:-false}
}

# Return 0 if ACTION_SET is the  identifier of an existent action set or
# it is the string "NONE"; else return 1.
#
function mbfl_actions_set_exists_or_none () {
    mbfl_mandatory_parameter(ACTION_SET,1,action set)

    mbfl_actions_set_exists "$ACTION_SET" || mbfl_string_equal 'NONE' "$ACTION_SET"
}

#page
# Parse  the  next command  line  argument  and select  accordingly  the
# functions for the main module.
#
# Upon  entering this  function: the  global variable  ARGV1 must  be an
# array containing all  the command line arguments;  the global variable
# ARGC1 must be  an integer representing the number of  values in ARGV1;
# the global variable  ARG1ST must be an integer  representing the index
# in ARGV1 of the next argument to be processed.
#
function mbfl_actions_dispatch () {
    mbfl_mandatory_parameter(ACTION_SET,1,action set)

    # It  is an  error if  this function  is called  with an  action set
    # identifier specifying a non-existent action set.
    if ! mbfl_actions_set_exists "$ACTION_SET"
    then
        mbfl_message_error_printf 'invalid action identifier: "%s"' "$ACTION_SET"
        return 1
    fi

    # If  there are  no  more  command lin  arguments:  just accept  the
    # previously selected values for the functions.
    if (( ARG1ST == ARGC1 ))
    then return 0
    fi

    local IDENTIFIER=${ARGV1[$ARG1ST]}
    local KEY=${ACTION_SET}-${IDENTIFIER}
    local ACTION_SUBSET=${mbfl_action_sets_SUBSETS[${KEY}]}
    local ACTION_KEYWORD=${mbfl_action_sets_KEYWORDS[${KEY}]}
    #mbfl_message_debug_printf 'processing argument "%s" for action selection' "$IDENTIFIER"
    if mbfl_string_is_empty "$ACTION_KEYWORD"
    then
        # The next  argument from  the command line  is *not*  an action
        # identifier:  just leave  it alone.   We accept  the previously
        # selected functions and return success.
        #mbfl_message_debug_printf 'argument "%s" is not an action identifier' "$IDENTIFIER"
        return 0
    else
        # The  next  argument  from  the command  line  *is*  an  action
        # identifier: consume it and select its functions.
        let ++ARG1ST
        mbfl_main_set_before_parsing_options script_before_parsing_options_${ACTION_KEYWORD}
        mbfl_main_set_after_parsing_options  script_after_parsing_options_${ACTION_KEYWORD}
        mbfl_main_set_main script_action_${ACTION_KEYWORD}
        mbfl_action_sets_SELECTED_SET=$ACTION_SUBSET
        if mbfl_string_not_equal 'NONE' "$ACTION_SUBSET"
        then
            # The selected action has a  subset of actions: dispatch the
            # subset.
            #mbfl_message_debug_printf 'argument "%s" is an action identifier with action subset' "$IDENTIFIER"
            mbfl_actions_dispatch "$ACTION_SUBSET"
        else
            # The selected  action has *no*  subset of actions: it  is a
            # leaf  in  the actions  tree.   Stop  recursing and  return
            # success.
            #mbfl_message_debug_printf 'argument "%s" is an action identifier without action subset' "$IDENTIFIER"
            return 0
        fi
    fi
}
#page
# Mutate MBFL state to mimic the selection of an action set.
#
function mbfl_actions_fake_action_set () {
    mbfl_mandatory_parameter(ACTION_SET,1,action set)
    if mbfl_actions_set_exists "$ACTION_SET"
    then
	mbfl_action_sets_SELECTED_SET=$ACTION_SET
	return 0
    else return 1
    fi
}
# If an action set  has been selected and its name  is not "NONE": print
# the help screen documenting the available actions.
#
function mbfl_actions_print_usage_screen () {
    local ACTION_SET=$mbfl_action_sets_SELECTED_SET

    if { mbfl_string_is_not_empty "$ACTION_SET" && mbfl_string_not_equal 'NONE' "$ACTION_SET"; }
    then
	printf 'Action commands:\n\n'
	local ACTION_IDENTIFIER KEY
	for ACTION_IDENTIFIER in ${mbfl_action_sets_IDENTIFIERS[${ACTION_SET}]}
	do
	    KEY=${ACTION_SET}-${ACTION_IDENTIFIER}
	    printf '\t%s [options] [arguments]\n\t\t%s\n\n' \
		   "$ACTION_IDENTIFIER" "${mbfl_action_sets_DESCRIPTIONS[${KEY}]}"
	done
    fi
    return 0
}

### end of file
# Local Variables:
# mode: sh
# End:
