#!/usr/bin/env bash

# Get the ID of the active workspace
active_workspace=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .activeWorkspace.id')

# Get JSON data for all clients in the active workspace
clients_json=$(hyprctl clients -j | jq --arg ws "$active_workspace" '[.[] | select(.workspace.id == ($ws | tonumber))]')

# Count total and floating windows from the JSON data
total_count=$(echo "$clients_json" | jq 'length')
floating_count=$(echo "$clients_json" | jq '[.[] | select(.floating)] | length')

# Exit early if there are no windows
if [[ "$total_count" -eq 0 ]]; then
    echo "No windows in workspace $active_workspace"
    exit 0
fi

# Determine toggle mode: if half or more are floating, we tile, otherwise we float
if [ "$floating_count" -ge $((total_count / 2)) ]; then
    mode="tile"
else
    mode="float"
fi

# Build a batch of dispatch commands
dispatch_cmds=""

if [ "$mode" == "float" ]; then
    # Get addresses of tiled windows and create dispatch commands to make them float
    tiled_clients=$(echo "$clients_json" | jq -r '.[] | select(.floating | not) | .address')
    while IFS= read -r addr; do
        if [[ -n "$addr" ]]; then
            dispatch_cmds+="dispatch togglefloating address:$addr;"
        fi
    done <<< "$tiled_clients"
else # mode == "tile"
    # Get addresses of floating windows and create dispatch commands to make them tile
    floating_clients=$(echo "$clients_json" | jq -r '.[] | select(.floating) | .address')
    while IFS= read -r addr; do
        if [[ -n "$addr" ]]; then
            dispatch_cmds+="dispatch togglefloating address:$addr;"
        fi
    done <<< "$floating_clients"
fi

# Execute all dispatches at once if there are any
if [[ -n "$dispatch_cmds" ]]; then
    hyprctl --batch "$dispatch_cmds"
fi