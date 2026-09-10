#!/usr/bin/env bash
set -euo pipefail

status=0
skill_count=0

while IFS= read -r skill; do
  skill_count=$((skill_count + 1))
  relative=${skill#skills/}
  name=${relative%/SKILL.md}
  if [[ ! $name =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    printf 'Invalid skill directory name: %s\n' "$name" >&2
    status=1
  fi
  if [[ $(sed -n '1p' "$skill") != '---' ]] || ! sed -n '2,/^---$/p' "$skill" | grep -q '^name: '; then
    printf 'Missing frontmatter name: %s\n' "$skill" >&2
    status=1
  fi
  if ! sed -n '2,/^---$/p' "$skill" | grep -q '^description: '; then
    printf 'Missing frontmatter description: %s\n' "$skill" >&2
    status=1
  fi
  declared_name=$(sed -n '2,/^---$/p' "$skill" | sed -n 's/^name: *//p' | head -n 1)
  if [[ $declared_name != "$name" ]]; then
    printf 'Skill name must match its directory: %s\n' "$skill" >&2
    status=1
  fi
done < <(find skills -mindepth 2 -type f -name SKILL.md | sort)

if [[ $skill_count -eq 0 ]]; then
  printf 'No skills found under skills/\n' >&2
  status=1
fi

exit "$status"
