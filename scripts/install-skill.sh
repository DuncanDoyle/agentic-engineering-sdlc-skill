#!/usr/bin/env bash
# install-skill.sh — sync the agentic-engineering-sdlc skill from this repo into the
# shared skills dir used by both Claude Code and Codex. Copies runtime files only
# (SKILL.md, templates/), not repository metadata or development-only files.
#
#   scripts/install-skill.sh            # installs to ~/.agents/skills/agentic-engineering-sdlc
#   AGENTS_SKILLS_DIR=/path scripts/install-skill.sh
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
dest="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}/agentic-engineering-sdlc"

mkdir -p "$dest"
# --delete keeps the installation in sync when runtime files are removed.
rsync -a --delete \
  "$ROOT/SKILL.md" \
  "$ROOT/templates" \
  "$dest/"

echo "Installed agentic-engineering-sdlc skill to $dest"
