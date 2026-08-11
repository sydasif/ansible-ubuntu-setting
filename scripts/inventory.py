#!/usr/bin/env python3

# This script generates an Ansible inventory in JSON format.
#
# Local (default): auto-detects the local machine, placed in its distro group
# (e.g. Ubuntu) with a local connection.
#
# Remote (ANSIBLE_TARGETS set): returns the comma-separated hostnames in the
# `all` group with an SSH connection. Per-host vars (ansible_user, user_home,
# storage_root) come from host_vars/<hostname>.yml.
import json
import os
import platform
import sys

import distro


def build_inventory():
    targets = os.environ.get("ANSIBLE_TARGETS", "").strip()

    if targets:
        hosts = [host for host in (h.strip() for h in targets.split(",")) if host]
        return {
            "_meta": {"hostvars": {host: {"ansible_connection": "ssh"} for host in hosts}},
            "all": {"hosts": hosts},
        }

    hostname = platform.uname().node
    distribution = distro.id().capitalize()
    return {
        "_meta": {"hostvars": {hostname: {"ansible_connection": "local"}}},
        distribution: {"hosts": [hostname]},
    }


if __name__ == "__main__":
    try:
        flag = sys.argv[1]
    except IndexError:
        sys.exit(1)

    inventory = build_inventory()

    if flag == "--list":
        print(json.dumps(inventory))
    elif flag == "--host":
        # Ansible queries per-host vars; none are defined here.
        print(json.dumps({}))
    else:
        sys.exit(1)
