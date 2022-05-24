#!/bin/bash
set -uexo pipefail

# The bash in GitHub action is running non-interactive and therefore does not
# source the .profile that extend the path for the go binary.
# https://github.community/t/self-hosted-not-using-bashrc/18358

source $HOME/.profile

go version || exit 1
