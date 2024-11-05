#!/bin/bash
set -uexo pipefail

curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

sleep 15

[[ "$(curl http://localhost:8000)" ]] || exit 1
