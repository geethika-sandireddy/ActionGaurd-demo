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

## How the attack is reproduced

1. `fake-action/` plays the role of a trusted third-party action (like
   `tj-actions/changed-files`). The tag **`v1`** starts out pointing at a
   safe commit.
2. `vulnerable-demo.yml` calls it as `fake-action@v1` — a **mutable tag**,
   exactly how most workflows reference third-party actions.
3. `scripts/simulate-attack.sh` force-moves `v1` to point at a different,
   compromised commit (`fake-action/action.yml` now logs a fake secret and
   makes an outbound call) — **without touching `vulnerable-demo.yml` at
   all**.
4. Re-running the exact same workflow now executes the compromised code.
5. `fixed-demo.yml` calls `fake-action@<commit-SHA>` instead of `@v1`. Moving
   the tag has no effect on it — it always resolves to the exact, verified
   commit.

Full click-by-click script: [`docs/ATTACK-WALKTHROUGH.md`](docs/ATTACK-WALKTHROUGH.md).

## Running it yourself

| Step | Command / Action |
|---|---|
| Run the vulnerable demo | Actions tab → **🔴 Vulnerable Demo** → Run workflow |
| Run the fixed demo | Actions tab → **✅ Fixed Demo** → Run workflow |
| Trigger the simulated attack | `./scripts/simulate-attack.sh` |
| Reset back to the safe state | `./scripts/restore-safe-tag.sh` |

## Safety notes

- `DEMO_FAKE_SECRET` is a hardcoded placeholder string, never a real credential.
- The "unexpected network call" in the compromised build hits `httpbin.org`,
  a public request-echoing test service — nothing sensitive is actually sent
  anywhere, and no real system is targeted.
- Everything here lives in one repository that you control. No real
  third-party action, user, or secret is ever touched.

## Relationship to the rest of CI/CD Redzone

This repo is the **attack replay** piece only. The companion pieces (not in
this repo) are:
- **ActionGuard** — a scanner that flags workflows using mutable tags or
  known-compromised actions.
- **ActionGuard Dashboard** — a React + Spring Boot + PostgreSQL UI that
  visualizes scan results and can trigger/replay this attack remotely.

## Status

✅ Attack replay (this repo) complete: safe build, compromised build, tag-move
attack, SHA-pinned fix, and a scripted walkthrough are all in place.
