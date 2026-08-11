#!/usr/bin/env python3

"""Verify group_vars live config and example template expose the same keys.

Every var added to group_vars/<Distro>.yml must be mirrored in
group_vars/example.yml (and vice versa) or a live run can fail with undefined
variable errors. Exits nonzero when the two files drift.
"""

from pathlib import Path

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
GROUP_VARS = REPO_ROOT / "group_vars"


def load_keys(path):
    if not path.exists():
        return None
    with path.open() as fh:
        return set(yaml.safe_load(fh) or {})


def main():
    # Find every *.yml except the example, i.e. the live config file(s).
    live_files = [p for p in sorted(GROUP_VARS.glob("*.yml")) if p.name != "example.yml"]
    example = GROUP_VARS / "example.yml"

    if not live_files or not example.exists():
        print("error: expected group_vars/<Distro>.yml and group_vars/example.yml")
        return 1

    example_keys = load_keys(example)
    ok = True
    for live_file in live_files:
        live_keys = load_keys(live_file)
        missing = sorted(example_keys - live_keys)
        extra = sorted(live_keys - example_keys)
        if missing or extra:
            ok = False
            print(f"drift in {live_file.name}:")
            if missing:
                print(f"  missing in live file: {missing}")
            if extra:
                print(f"  present only in live file: {extra}")
    if ok:
        print("ok: group_vars and example.yml are in sync")
        return 0
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
