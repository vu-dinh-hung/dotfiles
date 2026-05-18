#!/bin/sh
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

cur="$(pwd)"
fonts_source="$(dirname $0)/../fonts/ttf/"
fonts_target="/usr/local/share/fonts/"

cd "$fonts_source"
cp * "$fonts_target"
cd "$cur"

echo "Installed fonts to $fonts_target"
