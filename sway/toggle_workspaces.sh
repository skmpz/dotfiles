#!/usr/bin/env bash

# Get current output and workspace
current_output=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused==true).name')
current_workspace=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

# Get all workspaces on the current output, sorted by number (or name)
workspaces=($(swaymsg -t get_workspaces | jq -r --arg output "$current_output" \
  '[.[] | select(.output==$output)] | sort_by(.name) | .[].name'))

# Find index of current workspace
for i in "${!workspaces[@]}"; do
  if [[ "${workspaces[$i]}" == "$current_workspace" ]]; then
    current_index=$i
    break
  fi
done

# Compute next workspace index (wrap around)
next_index=$(( (current_index + 1) % ${#workspaces[@]} ))

# Switch to it
swaymsg workspace "${workspaces[$next_index]}"
