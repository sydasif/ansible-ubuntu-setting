#!/usr/bin/env python3

# This script generates an Ansible inventory in JSON format.
import json
import platform
import sys

import distro

hostname = platform.uname().node
distribution = distro.id().capitalize()

inventory = {
    "_meta": {"hostvars": {hostname: {"ansible_connection": "local"}}},
    distribution: {"hosts": [hostname]},
}

if __name__ == "__main__":
    try:
        flag = sys.argv[1]
    except IndexError:
        sys.exit(1)

    if flag == "--list":
        print(json.dumps(inventory))
    else:
        print(json.dumps({}))
