# fake-action

Our stand-in for a trusted third-party GitHub Action. In the real
tj-actions/changed-files incident, consumers referenced the action by a
mutable tag (e.g. `@v44`); the attacker moved that tag to point at a
malicious commit. Nobody's workflow YAML changed — the code behind the tag
did.

This directory plays that role here. Commit history shows two versions:
the original **safe build** (this commit), and a later **compromised build**
used to replay the attack. The tag `v1` starts out pointing at the safe
build; `scripts/simulate-attack.sh` is what moves it.
