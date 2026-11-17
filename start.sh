#!/bin/sh
# Scrap & Sparks: start everything and open the game (macOS, Linux).
# Run it with:  sh start.sh   (or ./start.sh)
# The first time it also creates the .env file and downloads n8n and the game (about 4 GB).
set -u
cd "$(dirname "$0")" || exit 1

say() { printf '  %s\n' "$*"; }
fail() { printf '\n'; exit 1; }
open_url() {
  if command -v open >/dev/null 2>&1; then open "$1"
  elif command -v xdg-open >/dev/null 2>&1; then xdg-open "$1" >/dev/null 2>&1 &
  else say "Open $1 in your browser."
  fi
}

printf '\n  Scrap & Sparks\n  ---------------\n\n'
os=$(uname)

# ---- 1. Is Docker installed? ----
if ! command -v docker >/dev/null 2>&1; then
  if [ "$os" = Darwin ]; then
    say "Docker Desktop is not installed yet. The install page opens now."
    say "Install it, open it once, then run start.sh again."
    open_url "https://docs.docker.com/desktop/setup/install/mac-install/"
  else
    say "Docker is not installed yet. Install Docker Engine and its Compose plugin:"
    say "https://docs.docker.com/engine/install/  then run start.sh again."
  fi
  fail
fi

# ---- 2. Is Docker running? (macOS: start Docker Desktop and wait up to 3 minutes) ----
if ! docker info >/dev/null 2>&1; then
  if [ "$os" = Darwin ]; then
    say "Starting Docker Desktop (this can take a minute)..."
    open -a Docker >/dev/null 2>&1 || true
    tries=0
    until docker info >/dev/null 2>&1; do
      tries=$((tries + 1))
      if [ "$tries" -ge 60 ]; then
        say "Docker Desktop did not start. Open it yourself, wait until it is running, then run start.sh again."
        fail
      fi
      sleep 3
    done
  else
    say "Docker is not running, or your user may not use it."
    say "Start it (for example: sudo systemctl start docker). If it says 'permission denied',"
    say "see https://docs.docker.com/engine/install/linux-postinstall/  Then run start.sh again."
    fail
  fi
fi

# ---- 3. First time only: create .env (a random secret and your timezone) ----
if [ ! -f .env ]; then
  token=$(od -An -tx1 -N32 /dev/urandom | tr -d ' \n')
  if [ -z "$token" ]; then say "Could not create a random secret for the .env file."; fail; fi
  tz=""
  if [ -L /etc/localtime ]; then tz=$(readlink /etc/localtime | sed 's|.*/zoneinfo/||'); fi
  case "$tz" in */*) ;; *) tz="Europe/Brussels" ;; esac
  umask 077
  {
    echo "# Created by start.sh. Keep this file private."
    echo "N8N_RUNNERS_AUTH_TOKEN=$token"
    echo "GENERIC_TIMEZONE=$tz"
  } > .env
  say "Created .env (timezone $tz)."
fi

port=$(grep -E '^COMPANION_PORT=' .env | tail -n 1 | cut -d= -f2)
# A port set in the shell wins, as it does for Docker Compose.
port=${COMPANION_PORT:-${port:-8765}}

# ---- 4. Start n8n, its task runner and the companion ----
say "Starting the game. The first time, Docker downloads about 4 GB: please wait..."
if ! docker compose up -d; then
  printf '\n'
  say "Docker could not start the game. Read the message above."
  say "A common cause: another program already uses port 5678, 8765 or 5688."
  fail
fi

# ---- 5. Wait until the game answers (up to 2 minutes), then open it ----
up() {
  if command -v curl >/dev/null 2>&1; then curl -sf -o /dev/null "http://localhost:$port/"
  else wget -q -O /dev/null "http://localhost:$port/"
  fi
}
tries=0
until up; do
  tries=$((tries + 1))
  if [ "$tries" -ge 60 ]; then
    say "The game is taking long to start. Try opening http://localhost:$port in your browser."
    exit 0
  fi
  sleep 2
done
open_url "http://localhost:$port/"
printf '\n'
say "The game runs at http://localhost:$port"
say "To stop it later: sh stop.sh. Your progress and your n8n stay saved."
printf '\n'
