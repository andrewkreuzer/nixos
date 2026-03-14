import subprocess
import json
import sys


def get_status():
    try:
        result = subprocess.run(
            ["playerctl", "--player=spotify", "status"],
            capture_output=True,
            text=True,
            timeout=2
        )
        return result.stdout.strip()
    except Exception:
        return ""


def get_metadata():
    try:
        result = subprocess.run(
            ["playerctl", "--player=spotify", "metadata",
             "--format", "{{artist}}\t{{title}}\t{{album}}"],
            capture_output=True,
            text=True,
            timeout=2
        )
        if result.returncode != 0 or not result.stdout.strip():
            return None, None, None
        parts = result.stdout.strip().split("\t")
        artist = parts[0] if len(parts) > 0 else ""
        title = parts[1] if len(parts) > 1 else ""
        album = parts[2] if len(parts) > 2 else ""
        return artist, title, album
    except Exception:
        return None, None, None


def output_json(text, tooltip, css_class):
    data = {"text": text, "tooltip": tooltip, "class": css_class}
    print(json.dumps(data), flush=True)


def main():
    proc = subprocess.Popen(
        ["playerctl", "--player=spotify", "--follow", "metadata",
         "--format", "{{artist}}\t{{title}}\t{{album}}"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )

    # Initial output
    artist, title, album = get_metadata()
    status = get_status()
    if status == "Playing" and artist and title:
        text = f"󰝚  {artist} - {title}"
        tooltip = f"{title}\nby {artist}\nfrom {album}" if album else f"{title}\nby {artist}"
        output_json(text, tooltip, "playing")
    elif status == "Paused":
        output_json("󰝚 ", "Spotify paused", "paused")
    else:
        output_json("", "", "stopped")

    # Follow changes
    try:
        for line in proc.stdout:
            line = line.strip()
            if not line:
                output_json("", "Spotify not playing", "stopped")
                continue
            parts = line.split("\t")
            artist = parts[0] if len(parts) > 0 else ""
            title = parts[1] if len(parts) > 1 else ""
            album = parts[2] if len(parts) > 2 else ""
            status = get_status()
            if status == "Playing" and artist and title:
                text = f"󰝚  {artist} - {title}"
                tooltip = f"{title}\nby {artist}\nfrom {album}" if album else f"{title}\nby {artist}"
                output_json(text, tooltip, "playing")
            elif status == "Paused":
                output_json("󰝚 ", "Spotify paused", "paused")
            else:
                output_json("", "", "stopped")
    except KeyboardInterrupt:
        proc.terminate()
        sys.exit(0)


if __name__ == "__main__":
    main()
