#!/usr/bin/env bash
# Propagate shared/references into every skill directory.
#
# The `skills` CLI installs skill directories individually, so shared files must
# live inside each skill to travel with it. `shared/references/` is the single
# source of truth: edit there, then run this script.
#
#   bash scripts/sync-references.sh          # write the copies
#   bash scripts/sync-references.sh --check  # report drift, write nothing
#
# --check exits 1 if any copy is missing, stale, or orphaned.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/shared/references"
MODE="sync"

case "${1:-}" in
  --check|check) MODE="check" ;;
  "") ;;
  *) echo "usage: $0 [--check]" >&2; exit 2 ;;
esac

if [ ! -d "$SRC" ]; then
  echo "missing source directory: $SRC" >&2
  exit 1
fi

# Comment syntax differs by file type, so the banner is generated per file.
banner() {
  local rel="$1" file="$2"
  case "$file" in
    *.md)
      printf '<!-- GENERATED FILE — do not edit. Source: shared/references/%s. Run `npm run sync`. -->\n\n' "$rel"
      ;;
    *.yaml|*.yml)
      printf '# GENERATED FILE — do not edit. Source: shared/references/%s. Run `npm run sync`.\n\n' "$rel"
      ;;
    *)
      # Unknown type: copy verbatim rather than inject an invalid comment.
      ;;
  esac
}

render() {
  local src="$1" rel="$2"
  banner "$rel" "$src"
  cat "$src"
}

drift=0

report() {
  local kind="$1" path="$2"
  printf '%-8s %s\n' "$kind" "${path#$ROOT/}"
  drift=1
}

for skill_md in "$ROOT"/skills/*/*/SKILL.md; do
  skill_dir="$(dirname "$skill_md")"
  dest_root="$skill_dir/references"

  if [ "$MODE" = "sync" ]; then
    rm -rf "$dest_root"
    mkdir -p "$dest_root"
  fi

  # Missing or stale copies.
  while IFS= read -r -d '' src; do
    rel="${src#"$SRC"/}"
    dest="$dest_root/$rel"

    if [ "$MODE" = "sync" ]; then
      mkdir -p "$(dirname "$dest")"
      render "$src" "$rel" > "$dest"
      continue
    fi

    if [ ! -f "$dest" ]; then
      report "missing" "$dest"
    elif ! diff -q <(render "$src" "$rel") "$dest" >/dev/null 2>&1; then
      report "drift" "$dest"
    fi
  done < <(find "$SRC" -type f -print0)

  # Orphaned copies (file exists in a skill but not in shared/).
  if [ "$MODE" = "check" ] && [ -d "$dest_root" ]; then
    while IFS= read -r -d '' dest; do
      rel="${dest#"$dest_root"/}"
      [ -f "$SRC/$rel" ] || report "orphan" "$dest"
    done < <(find "$dest_root" -type f -print0)
  fi
done

if [ "$MODE" = "check" ]; then
  if [ "$drift" -eq 0 ]; then
    echo "References in sync."
    exit 0
  fi
  echo "" >&2
  echo "Reference drift detected. Run \`npm run sync\` and commit the result." >&2
  exit 1
fi

echo "Synced $(find "$SRC" -type f | wc -l | tr -d ' ') reference files into $(find "$ROOT/skills" -name SKILL.md | wc -l | tr -d ' ') skills."
