
function fill_array () {
    local PATHNAME="$1"
    local item=
    local input; declare -a input
    local counter=0

echo "pathname: $PATHNAME"
echo
    echo -e "${PATHNAME//\//\\n}" | while read -r item ; do
        input[$counter]="$item"
echo "counter: $counter; element: ${input[$counter]}"
        let ++counter
    done
echo
echo "final counter: $counter"
echo "final elements: ${input[*]}"
}

fill_array abc/def/ghi

