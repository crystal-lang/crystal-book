#!/bin/bash
set -eu

branches=( $(git ls-remote --heads "${1:-.}" | grep -P -o '(?<=refs/heads/)[0-9][0-9.]+' | sort -V -r) )
latest_version="${branches[0]}"

{
  printf '[\n'
  latest='"latest"'
  for ver in "${branches[@]}"; do
    printf '{"version": "%s", "title": "%s", "aliases": [%s]},\n' "$ver" "$ver" "$latest"
    latest=''
  done
  printf '{"version": "master", "title": "nightly", "aliases": []}\n'
  printf ']\n'
  test -z "$latest"  # Check that we wrote at least one version
} > versions.json

sed 's/\${LATEST_VERSION}/'"${latest_version}"'/g' "$(dirname "$0")/aws-config.json" > aws-config.json
