#!/usr/bin/env bash
set -euo pipefail

repository_root=$(git rev-parse --show-toplevel)
git config core.hooksPath "$repository_root/.githooks"
printf 'Git hooks activated for %s\n' "$repository_root"
