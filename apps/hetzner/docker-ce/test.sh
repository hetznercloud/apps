#!/bin/bash
set -uexo pipefail

[[ "$(docker run -i busybox /bin/ash -c 'echo -n hello world')" == "hello world" ]] || exit 1
