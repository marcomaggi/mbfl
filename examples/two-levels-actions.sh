# two-level-actions.sh --

script_PROGNAME=two-levels-actions.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2013'
script_AUTHOR='Marco Maggi'
script_LICENSE=BSD
script_USAGE="usage: ${script_PROGNAME} [action] [subaction] [options]"
script_DESCRIPTION='Example script showing action arguments.'
script_EXAMPLES=

source "${MBFL_LIBRARY:=$(mbfl-config)}"

mbfl_declare_action_set ONE
mbfl_declare_action ONE RED  NONE red  'Do main action one red.'
mbfl_declare_action ONE BLUE NONE blue 'Do main action one blue.'

mbfl_declare_action_set TWO
mbfl_declare_action TWO GREEN NONE green 'Do main action one green.'
mbfl_declare_action TWO CYAN  NONE cyan  'Do main action one cyan.'

mbfl_declare_action_set MAIN
mbfl_declare_action MAIN ONE  ONE  one  'Do main action one.'
mbfl_declare_action MAIN TWO  TWO  two  'Do main action two.'
mbfl_declare_action MAIN HELP NONE help 'Do main action help.'

function script_before_parsing_options_ONE () {
    script_USAGE="usage: ${script_PROGNAME} one [action] [options]"
    script_DESCRIPTION='Example action tree: one.'
}
function script_before_parsing_options_TWO () {
    script_USAGE="usage: ${script_PROGNAME} two [action] [options]"
    script_DESCRIPTION='Example action tree: two.'
}

function script_before_parsing_options_RED () {
    script_USAGE="usage: ${script_PROGNAME} one red [options]"
    script_DESCRIPTION='Example action tree: one red.'
    mbfl_declare_option ALPHA no a alpha noarg 'Enable option alpha.'
    mbfl_declare_option BETA  '' b beta  witharg 'Set option beta.'
}
function script_before_parsing_options_BLUE () {
    script_USAGE="usage: ${script_PROGNAME} one blue [options]"
    script_DESCRIPTION='Example action tree: one blue.'
    mbfl_declare_option DELTA no d delta noarg 'Enable option delta.'
    mbfl_declare_option GAMMA '' g gamma witharg 'Set option gamma.'
}
function script_before_parsing_options_GREEN () {
    script_USAGE="usage: ${script_PROGNAME} two green [options]"
    script_DESCRIPTION='Example action tree: two green.'
    mbfl_declare_option ALPHA no a alpha noarg 'Enable option alpha.'
    mbfl_declare_option BETA  '' b beta  witharg 'Set option beta.'
}
function script_before_parsing_options_CYAN () {
    script_USAGE="usage: ${script_PROGNAME} two cyan [options]"
    script_DESCRIPTION='Example action tree: two cyan.'
    mbfl_declare_option DELTA no d delta noarg 'Enable option delta.'
    mbfl_declare_option GAMMA '' g gamma witharg 'Set option gamma.'
}

function main () {
    mbfl_main_print_usage_screen_brief
}
function script_action_ONE () {
    mbfl_main_print_usage_screen_brief
}
function script_action_TWO () {
    mbfl_main_print_usage_screen_brief
}
function script_action_HELP () {
    mbfl_actions_fake_action_set MAIN
    mbfl_main_print_usage_screen_brief
}

function script_action_RED () {
    printf 'performing action red: alpha=%s, beta=%s\n' \
        "$script_option_ALPHA" "$script_option_BETA"
}
function script_action_BLUE () {
    printf 'performing action blue: delta=%s, gamma=%s\n' \
        "$script_option_DELTA" "$script_option_GAMMA"
}
function script_action_GREEN () {
    printf 'performing action green: alpha=%s, beta=%s\n' \
        "$script_option_ALPHA" "$script_option_BETA"
}
function script_action_CYAN () {
    printf 'performing action cyan: delta=%s, gamma=%s\n' \
        "$script_option_DELTA" "$script_option_GAMMA"
}

mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
