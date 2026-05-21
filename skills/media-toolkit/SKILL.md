---
name: media-toolkit
description: Prepare Le Le's media production folders for editing, especially DJI Osmo Pocket 3 footage, .lrf/.LRF sidecar files, proxy folders, and DaVinci Resolve proxy organization. Use when Codex needs to inspect, dry-run, or run media organization scripts for project folders containing day/session subfolders with .mp4 and .lrf files.
---

# Media Toolkit

Use this skill for Le Le's DJI Osmo Pocket 3 to Mac to DaVinci Resolve workflow.

## LRF to Proxy

Use `scripts/lrf_to_proxy.sh` when the user wants to organize `.lrf` or `.LRF` files into `proxy/` folders.

Expected input shape:

```text
project_folder/
  day1/
    video_1.mp4
    video_1.lrf
  day2/
    video_2.mp4
    video_2.LRF
```

Expected result:

```text
project_folder/
  day1/
    video_1.mp4
    proxy/
      video_1.mp4
  day2/
    video_2.mp4
    proxy/
      video_2.mp4
```

The script only scans immediate subfolders of the project folder. It creates a `proxy/` directory inside each subfolder that contains `.lrf` or `.LRF` files, moves those files into it, and renames the moved files to `.mp4`.

## Workflow

1. Confirm the target project folder exists.
2. Run a dry run first:

```sh
scripts/lrf_to_proxy.sh --dry-run /path/to/project_folder
```

3. Review the dry-run output for unexpected folders, collisions, or skipped files.
4. If the dry run looks correct and the user has approved the change, run:

```sh
scripts/lrf_to_proxy.sh --yes /path/to/project_folder
```

## Safety Notes

- Treat `--yes` as destructive because it moves files.
- Do not run the script on a broad directory such as the user's home folder.
- If destination files already exist in `proxy/`, the script skips those files instead of overwriting them.
- If the user only asks what would happen, use `--dry-run` and summarize the output.
