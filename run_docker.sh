#!/usr/bin/env bash
set -e; set -o pipefail;

nix build '' --show-trace
