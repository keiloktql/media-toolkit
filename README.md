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
- Move all `.lrf` / `.LRF` files into the corresponding `proxy` folder.
- Rename each moved file to `.mp4` (e.g., `video1.lrf` → `proxy/video1.mp4`).
- Skip files when the destination already exists, instead of overwriting them.

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

3. **Preview what will happen:**

```sh
./lrf_to_proxy.sh --dry-run /path/to/your/project_folder
```

4. **Run the script with your project folder as an argument:**

```sh
./lrf_to_proxy.sh /path/to/your/project_folder
```

Confirm when prompted.

After running, each day’s folder will have a `proxy` subfolder containing the converted `.mp4` files.

For non-interactive agent runs, use `--yes` after checking a dry run:

```sh
./lrf_to_proxy.sh --yes /path/to/your/project_folder
```

## Agent Skill Usage

This repo includes a reusable Agent Skill at:

```text
skills/media-toolkit/
  SKILL.md
  scripts/lrf_to_proxy.sh
```

The skill teaches an AI coding agent when and how to use the media toolkit, including the safe `--dry-run` first workflow.

### Codex

For Codex, install the skill into your user skills directory:

```sh
mkdir -p ~/.codex/skills
cp -R skills/media-toolkit ~/.codex/skills/
```

Then start a new Codex session and ask for something like:

```text
Use the media-toolkit skill to prepare proxies for /path/to/project_folder
```

Keep `skills/media-toolkit/` in this repo as the source copy. The reliable Codex install target is `~/.codex/skills/media-toolkit/`.

### Claude Code

Claude Code also supports Agent Skills. Use the same skill folder; you do not need to rewrite it.

For a personal Claude Code skill available across projects:

```sh
mkdir -p ~/.claude/skills
cp -R skills/media-toolkit ~/.claude/skills/
```

For a project-local Claude Code skill checked into a specific project:

```sh
mkdir -p .claude/skills
cp -R skills/media-toolkit .claude/skills/
```

Claude Code discovers skills from:

- `~/.claude/skills/<skill-name>/SKILL.md` for personal skills.
- `.claude/skills/<skill-name>/SKILL.md` for project skills.

Claude Code watches existing skill directories and usually picks up edits during the current session. If you create a new top-level `.claude/skills` directory after Claude Code has already started, restart Claude Code so it can watch that directory.

### Do I Need `.agents`, `.claude`, and `skills/`?

Not usually.

- `skills/media-toolkit/` is the portable source folder in this repo.
- `~/.codex/skills/media-toolkit/` is the user-wide Codex install location.
- `~/.claude/skills/media-toolkit/` is the user-wide Claude Code install location.
- `.claude/skills/media-toolkit/` is the project-local Claude Code location.
- `.agents/` is only needed if you are building agent marketplace/plugin packaging around the skill. This toolkit does not need that yet.

Do not assume a plain root-level `skills/` folder is auto-loaded by every agent. It is useful as source code in this repo, but each agent has its own discovery location. For Claude Code, use `.claude/skills/` or `~/.claude/skills/`. For Codex, use `~/.codex/skills/`.
