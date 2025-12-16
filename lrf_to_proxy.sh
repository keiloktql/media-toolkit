#!/bin/bash

# Exit if no argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/project_folder"
  exit 1
fi

PROJECT_DIR="$1"

# Validate directory
if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: '$PROJECT_DIR' is not a valid directory"
  exit 1
fi

echo "⚠️  This will:"
echo "• Create a 'proxy' folder inside each subfolder"
echo "• Move all .lrf files into the proxy folder"
echo "• Rename .lrf → .mp4"
echo
echo "Target project folder:"
echo "$PROJECT_DIR"
echo

read -p "Continue? (y/N): " CONFIRM

case "$CONFIRM" in
  y|Y) echo "Starting...";;
  *) echo "Aborted ❌"; exit 0;;
esac

# Loop through all immediate subfolders
for DAY_DIR in "$PROJECT_DIR"/*/; do
  [ -d "$DAY_DIR" ] || continue

  PROXY_DIR="${DAY_DIR}proxy"
  mkdir -p "$PROXY_DIR"

  shopt -s nullglob
  for LRF in "$DAY_DIR"*.lrf "$DAY_DIR"*.LRF; do
    [ -e "$LRF" ] || continue

    # Remove .lrf or .LRF extension for basename
    BASENAME=$(basename "$LRF")
    BASENAME_NOEXT="${BASENAME%.*}"
    mv "$LRF" "$PROXY_DIR/${BASENAME_NOEXT}.mp4"
  done
  shopt -u nullglob
done

echo "Done ✅ Proxies created and LRF files moved + renamed."
