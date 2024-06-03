#!/usr/bin/env bash
set -e; set -o pipefail;

nix build '.#docker' --show-trace
image=$((docker load < result) | sed -n '$s/^Loaded image: //p')
docker image tag "$image" rust-template:latest
