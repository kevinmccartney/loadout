#!/usr/bin/env bash

set -o errexit

# Change directory to the project root directory.
cd "$(dirname "$0")"
cd ../

pwd

ls -la

# Because I'm using namespace packages,
# I have used --package acme rather than using
# the path 'src/acme', which would correctly
# collect my files but erroneously add
# 'src/acme' to the Mypy search path.
# We only want 'src' in the path so that Mypy
# knows our modules by their fully qualified names.
mypy loadout tests