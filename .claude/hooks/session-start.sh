#!/bin/bash
# Installs the GeoInt skill into Claude Code at the start of each cloud session.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

repo="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"

# Same layout as the README's install steps.
mkdir -p "$HOME/.agents/skills" "$HOME/.claude/skills"
ln -sfn "$repo" "$HOME/.agents/skills/geoint"
ln -sfn "$HOME/.agents/skills/geoint" "$HOME/.claude/skills/geoint"

# exiftool is optional (meta.py reads more with it); don't fail the session if apt is unreachable.
if ! command -v exiftool >/dev/null 2>&1 && command -v apt-get >/dev/null 2>&1; then
  { apt-get install -y -qq libimage-exiftool-perl \
    || { apt-get update -qq && apt-get install -y -qq libimage-exiftool-perl; }; } >/dev/null 2>&1 \
    || echo "geoint: could not install exiftool; continuing without it" >&2
fi
