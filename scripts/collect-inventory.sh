#!/usr/bin/env bash
set -euo pipefail

echo "## CPU"
lscpu

echo
echo "## Memory"
free -h

echo
echo "## Storage"
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL,SERIAL

echo
echo "## Network"
for iface in /sys/class/net/*; do
  name=$(basename "$iface")
  printf '%s ' "$name"
  [ -f "$iface/address" ] && printf 'mac=%s ' "$(cat "$iface/address")"
  [ -f "$iface/operstate" ] && printf 'state=%s ' "$(cat "$iface/operstate")"
  [ -f "$iface/speed" ] && printf 'speed=%sMb ' "$(cat "$iface/speed" 2>/dev/null || true)"
  printf '\n'
done

