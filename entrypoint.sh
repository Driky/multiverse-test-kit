#!/bin/sh

if [ -s /env-mount/env.sh ]; then
  echo "Sourcing env.sh"
  . /env-mount/env.sh
else
  echo "env.sh missing or empty"
fi

# Create output directories in writable /tmp location
mkdir -p /tmp/outputs /tmp/logs
chmod 755 /tmp/outputs /tmp/logs

# Strip platform anti-collision suffixes (_[7 hex chars] before extension)
# Renames a single file in-place; prints the new path on stdout.
strip_suffix_file() {
  filepath="$1"
  filename=$(basename "$filepath")
  ext="${filename##*.}"
  stem="${filename%.*}"
  new_stem=$(printf '%s' "$stem" | sed 's/_[0-9a-fA-F]\{7\}$//')
  if [ "$new_stem" != "$stem" ]; then
    new_path="$(dirname "$filepath")/${new_stem}.${ext}"
    mv "$filepath" "$new_path"
    echo "  Renamed: $filename -> ${new_stem}.${ext}" >&2
    printf '%s' "$new_path"
  else
    printf '%s' "$filepath"
  fi
}

strip_suffix_dir() {
  dir="$1"
  find "$dir" -maxdepth 1 -type f | while IFS= read -r filepath; do
    strip_suffix_file "$filepath" > /dev/null
  done
}

if [ -d "$KIT_INPUTS_FILE" ]; then
  echo "Input directory: $KIT_INPUTS_FILE"
  strip_suffix_dir "$KIT_INPUTS_FILE"
  find "$KIT_INPUTS_FILE" | sort | sed "s|[^/]*/|  |g"
elif [ -f "$KIT_INPUTS_FILE" ]; then
  KIT_INPUTS_FILE=$(strip_suffix_file "$KIT_INPUTS_FILE")
  export KIT_INPUTS_FILE
  echo "Input file: $KIT_INPUTS_FILE"
else
  echo "No input file supplied, continuing without it"
fi

exec "$@"
