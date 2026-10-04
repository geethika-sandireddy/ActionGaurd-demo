#!/usr/bin/env bash
# Replays the tj-actions/changed-files-style supply-chain attack on this repo.
#
# What it does: force-moves the mutable tag `v1` from the safe commit to the
# compromised commit (tagged `malicious-fake-action`). It does NOT touch any
# consumer workflow YAML — that's the whole point of the attack.
#
# Usage: ./scripts/simulate-attack.sh
set -euo pipefail

MALICIOUS_SHA=$(git rev-parse malicious-fake-action)

echo "Before: v1 -> $(git rev-parse v1)"
echo "Moving tag v1 -> $MALICIOUS_SHA (compromised build) ..."

git tag -f v1 "$MALICIOUS_SHA"
git push -f origin v1

echo "Done. v1 now points at the compromised commit."
echo "Go to Actions -> '🔴 Vulnerable Demo (pinned to mutable tag)' -> Run workflow."
echo "It will execute the compromised fake-action, with no YAML changes."
