#!/usr/bin/env bash
set -e
RUN_ID=$(date +%s%N)
exec /usr/bin/sipp -cid_str "$RUN_ID"-%u-%p@%s "$@"
