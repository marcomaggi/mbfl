# loader.sh

INSTALLED_MBFL="$(mbfl-config)" &>/dev/null
for item in "${MBFL_LIBRARY}" ./infrastructure/libmbfl.sh "${INSTALLED_MBFL}"
  do
  if test -n "${item}" -a -f "${item}" -a -r "${item}" ; then
      if ! source "${item}" &>/dev/null ; then
          printf '%s error: evaluating MBFL "%s"\n' \
              "${script_PROGNAME}" "${item}" >&2
          exit 2
      fi
  fi
done
if test "${mbfl_LOADED}" != 'yes' ; then
    printf '%s error: loading MBFL\n' "${script_PROGNAME}" >&2
    exit 2
fi

### end of file
