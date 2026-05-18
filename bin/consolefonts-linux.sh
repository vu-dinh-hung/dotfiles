#!/bin/sh
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

cur="$(pwd)"
consolefonts_source="$(dirname $0)/../fonts/console/"
consolefonts_target="/usr/share/consolefonts/"

cd "$consolefonts_source"
cp * "$consolefonts_target"
cd "$cur"

echo "Installed console fonts to $consolefonts_target"
