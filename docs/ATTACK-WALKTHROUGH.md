# Live Demo Walkthrough

A script you can follow in front of an audience, start to finish. Everything
happens from the GitHub Actions tab and a terminal with push access to this
repo — no laptop required if someone else runs the terminal steps.

## 0. Setup check

- `v1` tag should currently point at the **safe** commit
  (`9a9bab0741f13aae03e511d33dacaff05ac6e165`). Run
  `./scripts/restore-safe-tag.sh` if you're not sure.

## 1. Show the normal pipeline

1. Go to **Actions → 🔴 Vulnerable Demo (pinned to mutable tag) → Run workflow**.
2. Open the run, expand the `fake-action` step.
3. Logs show: `✅ fake-action@v1 (SAFE build) running` — nothing suspicious.

## 2. Simulate the attack

1. From a terminal with push access:
   ```
   ./scripts/simulate-attack.sh
   ```
   This force-moves the `v1` tag to the compromised commit. **No workflow
   YAML changes.**
2. Go to **Actions → 🔴 Vulnerable Demo → Run workflow** again — same button,
   same YAML as step 1.
3. Open the run, expand the `fake-action` step. Logs now show:
   - `🔴 SIMULATED ATTACK: fake-action is now running compromised code`
   - `🔴 [SECRET EXPOSED] demo-secret = FAKE-DEMO-SECRET-1234-NOT-REAL`
   - `🔴 Attempting an outbound call to an unexpected destination...`
   - a line showing the call reaching `httpbin.org` instead of nowhere

   **Talking point:** the workflow file is byte-for-byte identical to the
   one that ran safely in step 1. Only the code behind the `@v1` tag changed.

## 3. Show the fix

1. Go to **Actions → ✅ Fixed Demo (pinned to commit SHA) → Run workflow**.
2. Open the run, expand the `fake-action` step. Logs show the **safe** build
   output, even though `v1` is still pointing at the compromised commit.
3. **Talking point:** `fixed-demo.yml` references
   `fake-action@9a9bab074...` — an exact commit, not a tag. Moving `v1` has
   no effect on it.

## 4. Side-by-side comparison

| | `vulnerable-demo.yml` | `fixed-demo.yml` |
|---|---|---|
| Action reference | `fake-action@v1` (tag, mutable) | `fake-action@9a9bab07...` (SHA, immutable) |
| After tag-move attack | Runs compromised code | Unaffected, runs safe code |
| Secret exposure | Yes (simulated) | No |
| Unexpected network call | Yes (simulated, to httpbin.org) | No |

## 5. Reset for the next run

```
./scripts/restore-safe-tag.sh
```
