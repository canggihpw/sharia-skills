#!/usr/bin/env bash
# Structural and cross-reference checks for the skill pack.
# Exits 1 on any failure. Run from the repo root or via `npm run check`.

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail=0

err() { printf 'FAIL  %s\n' "$*"; fail=1; }

mapfile_compat() { :; } # no-op marker; bash 3.2 has no mapfile

skill_files=()
skill_names=()
while IFS= read -r f; do
  skill_files+=("$f")
  skill_names+=("$(basename "$(dirname "$f")")")
done < <(find "$ROOT/skills" -name SKILL.md | sort)

contains() {
  local needle="$1"; shift
  local x
  for x in "$@"; do [ "$x" = "$needle" ] && return 0; done
  return 1
}

for f in "${skill_files[@]}"; do
  dir="$(dirname "$f")"
  name="$(basename "$dir")"

  # 1. Frontmatter
  if [ "$(head -1 "$f")" != "---" ]; then
    err "$name: missing frontmatter"
    continue
  fi

  fm_name="$(sed -n 's/^name: *//p' "$f" | head -1)"
  fm_desc="$(sed -n 's/^description: *//p' "$f" | head -1)"
  fm_ver="$(sed -n 's/^version: *//p' "$f" | head -1)"
  fm_author="$(sed -n 's/^author: *//p' "$f" | head -1)"

  [ "$fm_name" = "$name" ] || err "$name: frontmatter name is '$fm_name'"
  case "$fm_desc" in
    '"Use when'*) ;;
    *) err "$name: description must start with \"Use when\"" ;;
  esac
  [ -n "$fm_ver" ] || err "$name: missing version"
  [ -n "$fm_author" ] || err "$name: missing author"

  # 2. Required sections
  for h in "## Purpose" "## When to Use" "## Prerequisites" "## Execution Workflow" "## Output" "## Constraints"; do
    grep -q "^$h" "$f" || err "$name: missing section '$h'"
  done

  # 3. Every analysis skill refreshes context before analysing
  case "$name" in
    sharia-market-context|sharia-ask) ;;
    *) grep -q '^### Step 0' "$f" || err "$name: missing Step 0 (context refresh)" ;;
  esac

  # 4. Reference links resolve inside the skill
  refs="$(grep -oE 'references/[A-Za-z0-9_./-]+\.(md|yaml)' "$f" | sort -u)"
  for ref in $refs; do
    [ -f "$dir/$ref" ] || err "$name: broken reference '$ref'"
  done

  # 5. Skill-to-skill mentions resolve
  tokens="$(grep -oE 'sharia-[a-z-]+' "$f" | sort -u)"
  for t in $tokens; do
    case "$t" in
      sharia-compliant|sharia-branded|sharia-skills) continue ;;
    esac
    contains "$t" "${skill_names[@]}" || err "$name: unknown skill reference '$t'"
  done

  # 6. Agent metadata
  [ -f "$dir/agents/openai.yaml" ] || err "$name: missing agents/openai.yaml"
  if [ -f "$dir/agents/openai.yaml" ]; then
    grep -q 'display_name:' "$dir/agents/openai.yaml" || err "$name: openai.yaml missing display_name"
    grep -q 'short_description:' "$dir/agents/openai.yaml" || err "$name: openai.yaml missing short_description"
  fi

  # 7. No stale relative paths from the pre-registry layout
  grep -q '\.\./\.\./\.\./references' "$f" && err "$name: stale ../../.. reference path"
done

# 8. The router should reach every non-router skill
ask="$ROOT/skills/orchestration/sharia-ask/SKILL.md"
if [ -f "$ask" ]; then
  for n in "${skill_names[@]}"; do
    case "$n" in
      sharia-ask) continue ;;
    esac
    grep -q "$n" "$ask" || err "sharia-ask: does not route to '$n'"
  done
fi

if [ "$fail" -eq 0 ]; then
  echo "All ${#skill_files[@]} skills pass structural and cross-reference checks."
  exit 0
fi

echo ""
echo "Skill checks failed."
exit 1
