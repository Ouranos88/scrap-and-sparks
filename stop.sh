#!/bin/sh
# Scrap & Sparks: stop the game (macOS, Linux). Your progress and your n8n stay saved.
cd "$(dirname "$0")" || exit 1
docker compose stop
printf '\n  The game is stopped. Run start.sh to play again.\n\n'
