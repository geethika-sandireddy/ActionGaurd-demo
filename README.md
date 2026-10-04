# ActionGuard Demo — Live Replay of a GitHub Actions Supply-Chain Attack

Part of **CI/CD Redzone**, a safe, interactive recreation of the real-world
**tj-actions/changed-files** GitHub Actions supply-chain breach (CVE-2025-30066).

This repo is the **attack replay** piece: a sandboxed consumer workflow that
calls a sandboxed "third-party" action living in this same repo, so we can
show — with real commits, real tags, and real GitHub Actions runs — exactly
how a mutable-tag attack works, and how pinning to a commit SHA stops it.

**Nothing here touches a real repository, a real secret, or a real attacker.**
Every "secret" is a hardcoded demo string, every "malicious" action is a few
lines of `echo`/`curl` that only prove the point.

## The idea in one sentence

> A GitHub Action referenced by a **tag** (`@v1`) can be silently swapped for
> different code by moving that tag — the consumer's workflow YAML never
> changes. Referencing it by **commit SHA** makes that impossible.

## What's in this repo

| Path | Purpose |
|---|---|
| `fake-action/` | Our stand-in for a trusted third-party action (like `tj-actions/changed-files`) |
| `.github/workflows/vulnerable-demo.yml` | Consumer workflow pinned to the **mutable tag** `@v1` |
| `.github/workflows/fixed-demo.yml` | Same consumer workflow pinned to an **immutable commit SHA** |
| `scripts/simulate-attack.sh` | Force-moves tag `v1` from the safe commit to the compromised commit |
| `scripts/restore-safe-tag.sh` | Moves `v1` back to the safe commit, so the demo can be replayed |
| `docs/ATTACK-WALKTHROUGH.md` | Step-by-step script for running the live demo |

## Status

🚧 Under construction — see commit history for progress. Full walkthrough
lands in `docs/ATTACK-WALKTHROUGH.md` once all pieces are in place.
