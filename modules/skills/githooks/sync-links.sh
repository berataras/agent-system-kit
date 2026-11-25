#!/bin/bash
# Sync per-skill symlinks from the shared skills repo into each agent's skills folder.
# One-way: only touches symlinks that point into this repo. Never deletes real files or folders.
REPO="$(cd "$(dirname "$0")/.." && pwd)"
LIST="$REPO/.githooks/agent-dirs"
[ -f "$LIST" ] || { echo "skills: $LIST not found; create it from .githooks/agent-dirs.example (one agent skills folder per line), then run this script again"; exit 0; }

while IFS= read -r line || [ -n "$line" ]; do
  line="${line%%#*}"                         # strip comments
  line="$(echo "$line" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')"
  [ -n "$line" ] || continue
  dir="${line/#\~/$HOME}"                    # expand a leading ~
  [ -d "$dir" ] || continue

  # Remove dangling links that point into the repo
  for link in "$dir"/* "$dir"/.[!.]*; do
    [ -L "$link" ] || continue
    target=$(readlink "$link")
    case "$target" in
      "$REPO"/*) [ -e "$link" ] || { rm "$link"; echo "skills: removed $link"; } ;;
    esac
  done

  # Add a link for every skill folder (a folder that contains a SKILL.md)
  for skill in "$REPO"/*/; do
    name=$(basename "$skill")
    [ -f "$REPO/$name/SKILL.md" ] || continue
    if [ -L "$dir/$name" ]; then
      continue
    elif [ -e "$dir/$name" ]; then
      echo "skills: WARNING $dir/$name exists and is not a link; left untouched"
    else
      ln -s "$REPO/$name" "$dir/$name" && echo "skills: linked $dir/$name"
    fi
  done
done < "$LIST"
exit 0
