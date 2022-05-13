#!/bin/bash
set -uexo pipefail

go version || exit 1
