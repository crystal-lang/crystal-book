#!/usr/bin/env sh
#
# This helper updates all references to the previous Crystal release.
#
# Usage:
#
#    scripts/release-update.sh
#
# Requirements:
#     Have the updated crystal version installed as `crystal`
#
# See Crystal release checklist: https://github.com/crystal-lang/distribution-scripts/blob/master/processes/crystal-release.md#post-release
set -eu

# Populate sample version of Crystal
crystal --version | tee crystal-version.txt
