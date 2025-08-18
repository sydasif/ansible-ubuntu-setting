#!/bin/bash
set -e
set -o pipefail

PROFILE_NAME="$1" # Expect profile name as the first argument

# First, try to find the profile by name
PROFILES_LIST=$(dconf list /org/gnome/terminal/legacy/profiles:/)
for PROFILE_PATH in $PROFILES_LIST; do
  VISIBLE_NAME=$(dconf read "/org/gnome/terminal/legacy/profiles:/${PROFILE_PATH}visible-name" | tr -d "'")
  if [ "$VISIBLE_NAME" = "$PROFILE_NAME" ]; then
    echo "found:${PROFILE_PATH%/}"
    exit 0
  fi
done

# If we're here, the profile was not found. Let's create it.
NEW_UUID=$(uuidgen)

CURRENT_PROFILES_STR=$(dconf read /org/gnome/terminal/legacy/profiles:/list)

if [[ "$CURRENT_PROFILES_STR" == "@as []" || "$CURRENT_PROFILES_STR" == "[]" ]]; then
  NEW_PROFILES_LIST="['$NEW_UUID']"
else
  NEW_PROFILES_LIST="${CURRENT_PROFILES_STR%]*}, '$NEW_UUID']"
fi

dconf write /org/gnome/terminal/legacy/profiles:/list "$NEW_PROFILES_LIST"

# Set the visible name for the new profile so we can find it next time
dconf write "/org/gnome/terminal/legacy/profiles:/:$NEW_UUID/visible-name" "'$PROFILE_NAME'"

echo "created:$NEW_UUID"
