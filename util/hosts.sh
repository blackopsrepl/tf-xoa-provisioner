#!/bin/bash

# Check if argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 ../inventories/hosts.ini"
  exit 1
fi

# Ansible inventory file path from command-line argument
inventory_file="$1"

# Loop through Ansible inventory and manage SSH fingerprints
while read -r host; do
  # Remove comments and empty lines
  [[ "$host" == \#* ]] && continue
  [[ -z "$host" ]] && continue

  # Extract just the hostname part before any ansible settings
  host=$(echo "$host" | cut -d ' ' -f 1)

  # Remove existing SSH fingerprint if exists
  ssh-keygen -R "$host" > /dev/null 2>&1

  # Add new SSH fingerprint
  ssh-keyscan -H "$host" >> ~/.ssh/known_hosts

done < "$inventory_file"

