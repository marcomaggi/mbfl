# one-level-actions.sh --

script_PROGNAME=one-level-actions.sh
script_VERSION=1.0
script_COPYRIGHT_YEARS='2013'
script_AUTHOR='Marco Maggi'
script_LICENSE=BSD
script_USAGE="usage: ${script_PROGNAME} [action] [options]"
script_DESCRIPTION='Example script showing action arguments.'
script_EXAMPLES=

source "${MBFL_LIBRARY:=$(mbfl-config)}"

mbfl_declare_action_set MAIN
mbfl_declare_action MAIN ONE  NONE one  'Do main action one.'
mbfl_declare_action MAIN TWO  NONE two  'Do main action two.'
mbfl_declare_action MAIN HELP NONE help 'Do main action help.'

function script_before_parsing_options_ONE () {
    script_USAGE="usage: ${script_PROGNAME} one [options]"
    script_DESCRIPTION='Example action tree: one.'
    mbfl_declare_option ALPHA no a alpha noarg 'Enable option alpha.'
    mbfl_declare_option BETA  '' b beta  witharg 'Set option beta.'
}
function script_before_parsing_options_TWO () {
    script_USAGE="usage: ${script_PROGNAME} two [options]"
    script_DESCRIPTION='Example action tree: two.'
    mbfl_declare_option DELTA no d delta noarg 'Enable option delta.'
    mbfl_declare_option GAMMA '' g gamma witharg 'Set option gamma.'
}
function main () {
    mbfl_main_print_usage_screen_brief
}
function script_action_HELP () {
    mbfl_actions_fake_action_set MAIN
    mbfl_main_print_usage_screen_brief
}
function script_action_ONE () {
    printf 'performing action one: alpha=%s, beta=%s\n' \
        "$script_option_ALPHA" "$script_option_beta"
}
function script_action_TWO () {
    printf 'performing action two: delta=%s, gamma=%s\n' \
        "$script_option_DELTA" "$script_option_GAMMA"
}
mbfl_main

### end of file
# Local Variables:
# mode: sh
# End:
