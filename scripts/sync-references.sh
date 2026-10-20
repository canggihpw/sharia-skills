#!/usr/bin/env bash
# Copy the canonical reference files into every skill directory.
# The `skills` CLI installs skill directories individually, so shared files
# must live inside each skill to travel with it. `shared/references/` is the
# single source of truth; edit there, then run this script.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/shared/references"

if [ ! -d "$SRC" ]; then
  echo "missing source directory: $SRC" >&2
  exit 1
fi

count=0
for skill_md in "$ROOT"/skills/*/*/SKILL.md; do
  skill_dir="$(dirname "$skill_md")"
  mkdir -p "$skill_dir/references"
  cp "$SRC"/*.md "$SRC"/*.yaml "$skill_dir/references/"
  count=$((count + 1))
done

echo "Synced $(find "$SRC" -type f | wc -l | tr -d ' ') reference files into $count skills."
