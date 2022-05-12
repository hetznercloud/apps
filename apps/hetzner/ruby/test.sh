#!/bin/bash
set -uexo pipefail

[[ "$(ruby -e \"puts RUBY_VERSION.split('.')[0]\")" == "3" ]] || exit 1
