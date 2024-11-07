#! /bin/bash

set -eu -o pipefail

CRYSTAL=${CRYSTAL:-crystal}
if [ -z "${STDLIB_SRC-}" ]; then
  CRYSTAL_PATH="$($CRYSTAL env CRYSTAL_PATH)"
  STDLIB_SRC="${CRYSTAL_PATH#*:}" # stdlib source directory is the last entry in CRYSTAL_PATH
fi

echo "Validating flags for stdlib source ${STDLIB_SRC} ($(cat "${STDLIB_SRC}/VERSION"))"

filter_missing() {
  missing=0

  while read -r word; do
      grep -q "\`$word\`" docs/syntax_and_semantics/compile_time_flags.md || {
        [ ${missing} -eq 0 ] && echo "# Missing ${1} flags:"
        echo "$word"
        missing=1
      }
    done
  return ${missing}
}

status=0
find "${STDLIB_SRC}" -name '*.cr' -type f -not -path "${STDLIB_SRC}/compiler/**" -print0 \
  | xargs -0 "${CRYSTAL}" tool flags \
  | filter_missing "stdlib" || status=1

{
  ${CRYSTAL} tool flags "${STDLIB_SRC}/compiler"
  grep --no-file -o -R -P '(?<=has_flag\?[( ]")[^"]+' "${STDLIB_SRC}/compiler"
} | sort -u | filter_missing "compiler" || status=1

exit ${status}
