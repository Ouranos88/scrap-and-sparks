#!/bin/sh
# Scrap & Sparks (Mac): double-click this file to start the game. It runs start.sh in this folder.
# macOS blocks it the first time (it is not signed): see the install guide, "Open Anyway".
cd "$(dirname "$0")" || exit 1
sh ./start.sh
