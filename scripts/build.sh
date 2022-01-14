#! /usr/bin/env bash

# This script is intended to be called from the root directory of the
# repository. i.e.
#   $ scripts/build.sh

set -e

source repo-profile.sh
make
