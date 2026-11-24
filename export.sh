#!/usr/bin/env bash
# One command from a clean clone to a file you can upload to itch.io:
#   ./export.sh
# It imports the project, exports the "Web" preset (a release build) to build/web/,
# and zips that folder with index.html at the top level, named with the version
# from Project Settings.
#
# It needs a Godot binary. If `godot` is not on your PATH, point GODOT at it:
#   macOS:    GODOT=/Applications/Godot.app/Contents/MacOS/Godot ./export.sh
#   Windows:  GODOT="/c/path/to/Godot.exe" ./export.sh   (from Git Bash)
set -euo pipefail
cd "$(dirname "$0")"

GODOT="${GODOT:-godot}"
VERSION="$(grep -m1 '^config/version=' project.godot | cut -d'"' -f2)"
ZIP="build/rival-brains-${VERSION}-web.zip"

rm -rf build/web "$ZIP"
mkdir -p build/web

echo "Importing..."
"$GODOT" --headless --import >/dev/null 2>&1 || true
echo "Exporting the Web preset (release) at version ${VERSION}..."
"$GODOT" --headless --export-release "Web" build/web/index.html

(cd build/web && zip -q -r "../$(basename "$ZIP")" .)
echo "Done: $ZIP"
echo "Upload that file to itch.io and tick: This file will be played in the browser."
