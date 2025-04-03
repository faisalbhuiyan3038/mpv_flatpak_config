# Custom MPV configuration

- open mpv-file-browser with fn+rightCTRL on laptop.
- adjust sharpness, gamma, contrast and brightness to improve visuals.

Use mpv from svp's folder for svp support, just place these in %appdata%\mpv

for mvtools, install svp, use mpv from there, place mvtools dl file from https://github.com/dubhater/vapoursynth-mvtools/releases in vapoursynth64/plugins.
Follow this thread if any problems occur: https://www.reddit.com/r/mpv/comments/oke3aa/guide_how_to_get_motion_interpolation_soap_opera/

for autosubsync: https://github.com/joaquintorres/autosubsync-mpv


# UOSC Paste Button Updater

This repository contains scripts to automatically add a paste button to the UOSC interface for MPV.

## What does the paste button do?

The paste button adds a clipboard icon to your UOSC controls bar. When clicked, it will:
- Take any URL or file path from your clipboard
- Directly open and play it in MPV

This is especially useful for:
- Quickly playing YouTube or other online video links
- Opening local files without using the file menu
- Sharing videos between applications without downloading

## When to use these scripts

Run the appropriate script whenever:
- You update UOSC to a newer version
- You reset your UOSC configuration
- You want to ensure the paste button is present in your controls

The scripts are safe to run multiple times - they will check if the button already exists and won't add duplicates.

## How to use the scripts

### On Linux or macOS:

```bash
# Navigate to your mpv config directory
cd ~/.var/app/io.mpv.Mpv/config/mpv  # Flatpak installation
# OR
cd ~/.config/mpv  # Standard installation

# Run the script
./update-uosc-paste.sh
```

### On Windows:

```
# Navigate to your mpv config directory
cd %APPDATA%\mpv

# Run the script
update-uosc-paste.bat
```

## Manual Installation

If the scripts don't work for any reason, you can manually add the paste button to your UOSC configuration:

1. Open your `script-opts/uosc.conf` file
2. Find the line starting with `controls=`
3. Add `command:content_paste:script-binding uosc/paste-to-open?Paste and play from clipboard,` before `gap,prev,items`
4. Save the file and restart MPV

## Requirements

- MPV with UOSC installed
- Basic terminal/command prompt knowledge 