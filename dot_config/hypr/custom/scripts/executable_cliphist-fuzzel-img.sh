#!/usr/bin/env bash

thumbnail_size=128
thumbnail_dir="${XDG_CACHE_HOME:-$HOME/.cache}/cliphist/thumbnails"

cliphist_list=$(cliphist list)
if [ -z "$cliphist_list" ]; then
    fuzzel -d --placeholder "cliphist: please store something first" --lines 0
    rm -rf "$thumbnail_dir"
    exit
fi

[ -d "$thumbnail_dir" ] || mkdir -p "$thumbnail_dir"

read -r -d '' thumbnail <<EOF
/^[0-9]+\s<meta http-equiv=/ { next }
match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
  cliphist_item_id=grp[1]
  ext=grp[3]
  thumbnail_file=cliphist_item_id"."ext
  system("[ -f ${thumbnail_dir}/"thumbnail_file" ] || echo " cliphist_item_id "\\\\\t | cliphist decode | magick - -thumbnail ${thumbnail_size}^ -gravity center -extent ${thumbnail_size} ${thumbnail_dir}/"thumbnail_file)
  print \$0"\0icon\x1f${thumbnail_dir}/"thumbnail_file
  next
}
1
EOF

clear_button_text=" Clear History"

item=$((echo "$clear_button_text"; echo "$cliphist_list") | gawk "$thumbnail" | fuzzel -d --placeholder "Search clipboard..." --counter)
exit_code=$?

if [ "$item" == "$clear_button_text" ]; then
    confirmation=$(echo -e "No\nYes" | fuzzel -d --placeholder "Delete and reset all history?" --lines 2)
    if [ "$confirmation" == "Yes" ]; then
        # This performs a full reset: stops the daemon, wipes the db, and clears thumbnails.
        pkill cliphist &> /dev/null
        cliphist wipe
        rm -rf "$thumbnail_dir"
    fi
    exit
fi

if [ "$exit_code" -eq 19 ]; then
    confirmation=$(echo -e "No\nYes" | fuzzel -d --placeholder "Delete and reset all history?" --lines 2)
    if [ "$confirmation" == "Yes" ]; then
        pkill cliphist &> /dev/null
        cliphist wipe
        rm -rf "$thumbnail_dir"
    fi

elif [ "$exit_code" -eq 10 ]; then
    if [ -n "$item" ]; then
        item_id=$(echo "$item" | cut -f1)
        echo "$item_id" | cliphist delete
        find "$thumbnail_dir" -name "${item_id}.*" -delete
    fi
else
    [ -z "$item" ] || echo "$item" | cliphist decode | wl-copy
fi

find "$thumbnail_dir" -type f | while IFS= read -r thumbnail_file; do
    cliphist_item_id=$(basename "${thumbnail_file%.*}")
    if ! grep -q -E "^${cliphist_item_id}\s" <<<"$cliphist_list"; then
        rm "$thumbnail_file"
    fi
done
