#!/usr/bin/env bash

set -u

usage() {
  cat <<'USAGE'
Usage: lrf_to_proxy.sh [--dry-run] [--yes] /path/to/project_folder

Move DJI Osmo Pocket 3 .lrf/.LRF files from each immediate subfolder into
that subfolder's proxy/ directory, renaming them to .mp4.

Options:
  -n, --dry-run   Show what would happen without creating folders or moving files.
  -y, --yes       Run without an interactive confirmation prompt.
  -h, --help      Show this help.
USAGE
}

DRY_RUN=0
YES=0
PROJECT_DIR=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    -n|--dry-run)
      DRY_RUN=1
      shift
      ;;
    -y|--yes)
      YES=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Error: unknown option '$1'" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [ -n "$PROJECT_DIR" ]; then
        echo "Error: only one project folder can be provided" >&2
        usage >&2
        exit 1
      fi
      PROJECT_DIR="$1"
      shift
      ;;
  esac
done

if [ "$#" -gt 0 ]; then
  if [ -n "$PROJECT_DIR" ]; then
    echo "Error: only one project folder can be provided" >&2
    usage >&2
    exit 1
  fi
  PROJECT_DIR="$1"
fi

if [ -z "$PROJECT_DIR" ]; then
  usage >&2
  exit 1
fi

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: '$PROJECT_DIR' is not a valid directory" >&2
  exit 1
fi

echo "This will:"
echo "- Create a 'proxy' folder inside each immediate subfolder"
echo "- Move all .lrf/.LRF files into the matching proxy folder"
echo "- Rename each moved file to .mp4"
echo
echo "Target project folder:"
echo "$PROJECT_DIR"
echo

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry run mode: no folders will be created and no files will be moved."
elif [ "$YES" -ne 1 ]; then
  if [ ! -t 0 ]; then
    echo "Error: non-interactive run requires --yes" >&2
    exit 1
  fi

  read -r -p "Continue? (y/N): " CONFIRM
  case "$CONFIRM" in
    y|Y) echo "Starting...";;
    *) echo "Aborted"; exit 0;;
  esac
else
  echo "Starting..."
fi

MOVED=0
SKIPPED=0

shopt -s nullglob

for DAY_DIR in "$PROJECT_DIR"/*/; do
  [ -d "$DAY_DIR" ] || continue

  DAY_NAME=$(basename "$DAY_DIR")
  if [ "$DAY_NAME" = "proxy" ]; then
    continue
  fi

  LRF_FILES=( "$DAY_DIR"*.lrf "$DAY_DIR"*.LRF )
  if [ "${#LRF_FILES[@]}" -eq 0 ]; then
    continue
  fi

  PROXY_DIR="${DAY_DIR}proxy"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "Would ensure directory: $PROXY_DIR"
  else
    mkdir -p "$PROXY_DIR"
  fi

  for LRF in "${LRF_FILES[@]}"; do
    BASENAME=$(basename "$LRF")
    BASENAME_NOEXT="${BASENAME%.*}"
    DESTINATION="$PROXY_DIR/${BASENAME_NOEXT}.mp4"

    if [ -e "$DESTINATION" ]; then
      echo "Skipping existing destination: $DESTINATION" >&2
      SKIPPED=$((SKIPPED + 1))
      continue
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
      echo "Would move: $LRF -> $DESTINATION"
    else
      mv "$LRF" "$DESTINATION"
      echo "Moved: $LRF -> $DESTINATION"
    fi
    MOVED=$((MOVED + 1))
  done
done

shopt -u nullglob

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry run complete: $MOVED file(s) would be moved, $SKIPPED file(s) skipped."
else
  echo "Done: $MOVED file(s) moved, $SKIPPED file(s) skipped."
fi
