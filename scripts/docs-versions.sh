#!/usr/bin/env sh
set -e

printf '['
latest='"latest"'
for ver in $(git ls-remote --heads "${1:-.}" | grep -P -o '(?<=refs/heads/)[0-9][0-9.]+' | sort -V -r); do
  printf '{"version": "%s", "title": "%s", "aliases": [%s]}, ' "$ver" "$ver" "$latest"
  latest=''
done
printf '{"version": "master", "title": "nightly", "aliases": []}'
printf ']'
test -z "$latest"  # Check that we wrote at least one version
