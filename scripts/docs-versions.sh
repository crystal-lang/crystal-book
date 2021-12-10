#!/bin/bash
set -eu

branches=( $(git ls-remote --heads "${1:-.}" | grep -P -o '(?<=refs/heads/)[0-9][0-9.]+' | sort -V -r) )
latest_branch="${branches[0]}"

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

cat <<EOF > .aws-config
{
  "IndexDocument": {
    "Suffix": "index.html"
  },
  "RoutingRules": [
    {
      "Condition": {
        "KeyPrefixEquals": "reference/latest/"
      },
      "Redirect": {
        "HttpRedirectCode": "302",
        "ReplaceKeyPrefixWith": "reference/${latest_branch}/",
        "Protocol": "https",
        "HostName": "crystal-lang.org"
      }
    },
    {
      "Condition": {
        "KeyPrefixEquals": "reference/",
        "HttpErrorCodeReturnedEquals": "404"
      },
      "Redirect": {
        "HttpRedirectCode": "301",
        "ReplaceKeyPrefixWith": "reference/latest/",
        "Protocol": "https",
        "HostName": "crystal-lang.org"
      }
    }
  ]
}
EOF
