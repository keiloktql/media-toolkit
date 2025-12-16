# media-toolkit

A toolkit for Le Le's (that's me) media production flow.

## Disclaimer

> This toolkit is provided as-is. I am not responsible for any damages, data loss, or other issues that may arise from using these scripts. Use at your own risk. This workflow is tailored for my personal use: **DJI Osmo Pocket 3 → Mac → DaVinci Resolve**. It may not work for everyone or for other editing setups.

## Script: `lrf_to_proxy.sh` Use Case

TLDR: A simple script for managing and converting video files from the DJI Osmo Pocket 3 on macOS.

When recording with the DJI Osmo Pocket 3, each day’s footage is organized into separate folders (e.g., `day1`, `day2`). Each folder contains video files in `.mp4` format and corresponding `.lrf` files (high-quality or log/raw footage). The file names are arbitrary and not standardized.

To streamline editing, it’s often necessary to create "proxy" files—lower-resolution or more easily handled versions of the originals. This toolkit provides a convenient way to organize and convert `.lrf` files into `.mp4` proxies, moving them into a dedicated `proxy` subfolder within each day’s folder.

## Workflow

1. Copy your DJI Osmo Pocket 3 project folder to your Mac.
2. The folder structure should look like:
   ```
   project_folder/
     folder_1/
       video_1.mp4
       video_1.lrf
     folder_2/
       video_2.mp4
       video_2.lrf
     ...
   ```
3. Run the provided script to automate proxy creation and organization.

## What it does

This script will:

- Create a `proxy` folder inside each day’s subfolder.
- Move all `.lrf` files into the corresponding `proxy` folder.
- Rename each `.lrf` file to `.mp4` (e.g., `video1.lrf` → `proxy/video1.mp4`).

### How to Use

1. **Clone the repository:**

```sh
git clone https://github.com/keiloktql/media-toolkit.git
cd media-toolkit
```

2. **Make the script executable:**

```sh
chmod +x lrf_to_proxy.sh
```

3. **Run the script with your project folder as an argument:**

```sh
./lrf_to_proxy.sh /path/to/your/project_folder
```

Confirm when prompted.

After running, each day’s folder will have a `proxy` subfolder containing the converted `.mp4` files.
