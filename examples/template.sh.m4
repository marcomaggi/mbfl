# template.sh.m4 --

MBFL_SCRIPT_NAME([[template.sh]])
MBFL_SCRIPT_VERSION([[1.0]])
MBFL_SCRIPT_PACKAGE([[Marco\'s BASH Functions Library]])
MBFL_SCRIPT_DESCRIPTION([[A test script]])
MBFL_SCRIPT_ABSTRACT([[#
#	This script shows how an MBFL script should be organised
#	to use the "mbfl.m4" autocomposition macro file.
#]])
MBFL_COPYRIGHT_YEARS([[2004]])
MBFL_AUTHORS([[Marco Maggi and Marco Maggi]])
MBFL_LICENSE([[GPL]])
MBFL_ACTION(ALPHA, a, alpha, [[selects action alpha]])
MBFL_OPTION(BETA,, b, beta, 1, [[selects option beta]])
MBFL_OPTION(VALUE, 0, v, value, 1, [[selects a value]])
MBFL_OPTION(FILE, 0, f, file, 1, [[selects a file]])
MBFL_OPTION(ENABLE, 0, e, enable, 0, [[enables a feature]])
MBFL_OPTION(DISABLE, 0, d, disable, 0, [[disables a feature]])
MBFL_SCRIPT

#page

function script_begin () {
    if test -n "${script_option_BETA}";	then
	echo "option beta: ${script_option_BETA}"
    fi
    return 0
}
function script_end () {
    return 0
}
function script_action_ALPHA () {
    echo "action alpha"
}

MBFL_END

### end of file
# Local Variables:
# mode: sh
# page-delimiter: "^#PAGE$"
# End:
