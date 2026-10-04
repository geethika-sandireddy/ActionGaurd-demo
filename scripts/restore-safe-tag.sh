#!/usr/bin/env bash
# Moves tag v1 back to the original safe commit, so the attack demo can be
# replayed from a clean state.
#
# Usage: ./scripts/restore-safe-tag.sh
set -euo pipefail

SAFE_SHA="9a9bab0741f13aae03e511d33dacaff05ac6e165"

echo "Before: v1 -> $(git rev-parse v1)"
echo "Restoring tag v1 -> $SAFE_SHA (safe build) ..."

git tag -f v1 "$SAFE_SHA"
git push -f origin v1

echo "Done. v1 points at the safe build again. Demo is ready to replay."
