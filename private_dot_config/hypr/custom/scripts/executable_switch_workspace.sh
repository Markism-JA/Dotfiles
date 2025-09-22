#!/bin/bash

direction=""

while [[ "$#" -gt 0 ]]; do
    case "$1" in
    -n | --next) direction="next" ;;
    -p | --prev) direction="prev" ;;
    *)
        echo "Usage: $0 [-n|--next] | [-p|--prev]"
        exit 1
        ;;
    esac
    shift
done

[[ -z "$direction" ]] && echo "No direction provided. Use -n or -p." && exit 1

current=$(hyprctl activeworkspace -j | jq '.id')
workspaces=$(hyprctl workspaces -j)

if [[ "$direction" == "next" ]]; then
    target=$(echo "$workspaces" | jq "[.[] | select(.id > $current)] | sort_by(.id) | .[0].id // empty")
else
    target=$(echo "$workspaces" | jq "[.[] | select(.id < $current)] | sort_by(.id) | reverse | .[0].id // empty")
fi

if [[ -n "$target" ]]; then
    hyprctl dispatch workspace "$target"
fi
