#!/usr/bin/env bash
# Clone (and optionally install) the dsh-qq-suite family.
#
#   ./install.sh                 clone every repo into ./repos
#   ./install.sh --tools         also npm i -g the six CLI tools
#   ./install.sh --dir ~/tools   choose target dir
#
# Touches nothing else: no config files, no PATH edits, no services.

set -euo pipefail

OWNER="whatxin7"
DIR="$(cd "$(dirname "$0")" && pwd)/repos"
TOOLS=0

while [ $# -gt 0 ]; do
  case "$1" in
    --tools) TOOLS=1; shift ;;
    --dir) DIR="$2"; shift 2 ;;
    -h|--help) sed -n '2,8p' "$0"; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

command -v git >/dev/null || { echo "git not found"; exit 1; }
command -v node >/dev/null || { echo "node >= 20 required (https://nodejs.org)"; exit 1; }
echo "node $(node --version) / $(git --version)"

mkdir -p "$DIR"
echo "target: $DIR"

REPOS="dsh-token-meter dsh-qq-access dsh-qq-voice dsh-qq-stickers dsh-mcp-safe-tools dsh-session-link dsh-persona-kit dsh-qq-suite"
NEEDS_INSTALL="dsh-mcp-safe-tools dsh-persona-kit"

for name in $REPOS; do
  dest="$DIR/$name"
  echo "-- $name"
  if [ -d "$dest/.git" ]; then
    echo "   exists, pulling"
    git -C "$dest" pull --ff-only || true
  else
    git clone "https://github.com/$OWNER/$name.git" "$dest"
  fi
  case " $NEEDS_INSTALL " in
    *" $name "*) (cd "$dest" && npm install --no-audit --no-fund >/dev/null && echo "   npm install done") ;;
  esac
  echo
done

if [ "$TOOLS" -eq 1 ]; then
  echo "== installing global commands"
  for name in dsh-token-meter dsh-qq-access dsh-qq-voice dsh-qq-stickers dsh-session-link dsh-persona-kit; do
    echo "   npm i -g github:$OWNER/$name"
    npm i -g "github:$OWNER/$name" --no-audit --no-fund >/dev/null || echo "   install failed: $name"
  done
  echo
  echo "verify: token-meter --help / qq-access --help / voice --help / sticker --help / session-link --help / persona --help"
fi

echo "done. docs: https://github.com/$OWNER/dsh-qq-suite/blob/main/INSTALL.md"
