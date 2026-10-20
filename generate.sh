#!/usr/bin/env bash
# Generates metadata-only evidence for the marryflow repositories.
# Output contains NO source code, NO file contents and NO author e-mail addresses.

set -euo pipefail

WEB="${WEB:-/Users/zhousirui/weblearning/marryflow}"
BACKEND="${BACKEND:-/Users/zhousirui/weblearning/marryflow-backend}"
MOBILE="${MOBILE:-/Users/zhousirui/weblearning/marryflow-mobile}"
MONO="${MONO:-/Users/zhousirui/weblearning/marryflow-monorepo}"

ROOT="$(cd "$(dirname "$0")" && pwd)"
DATA="$ROOT/data"
PRIV="$ROOT/_private"
mkdir -p "$DATA" "$PRIV"

CUTOFF="2026-03-17"

for r in "$WEB" "$BACKEND" "$MOBILE" "$MONO"; do
  [ -d "$r/.git" ] || { echo "ERROR: not a git repository: $r" >&2; exit 1; }
done

# ---------------------------------------------------------------- web repo
# Full transcript: hash | author date | author name | subject   (no e-mail)
git -C "$WEB" log --reverse --date=iso-strict \
  --pretty=format:'%H|%ad|%an|%s' > "$DATA/commits-marryflow-web.txt"
printf '\n' >> "$DATA/commits-marryflow-web.txt"

# Per-commit file paths and line counts only — never file contents
git -C "$WEB" log --reverse --date=short --numstat \
  --pretty=format:'--- %H | %ad | %s' > "$DATA/changes-marryflow-web.txt"
printf '\n' >> "$DATA/changes-marryflow-web.txt"

# Commit volume by month
git -C "$WEB" log --date=format:'%Y-%m' --pretty=format:'%ad' \
  | sort | uniq -c | awk '{printf "%s  %3d\n", $2, $1}' \
  > "$DATA/commits-per-month.txt"

# Tags (usually empty)
git -C "$WEB" for-each-ref --sort=creatordate \
  --format='%(refname:short) | %(creatordate:iso-strict)' refs/tags \
  > "$DATA/tags.txt"

# ------------------------------------------------------- all four repos
: > "$DATA/all-repositories.txt"
for spec in "marryflow|$WEB" \
            "marryflow-backend|$BACKEND" \
            "marryflow-mobile|$MOBILE" \
            "marryflow-monorepo|$MONO"; do
  name="${spec%%|*}"; path="${spec#*|}"
  first="$(git -C "$path" log --reverse --pretty=format:'%H|%ad|%s' --date=iso-strict | sed -n '1p')"
  last="$(git -C "$path" log -1 --pretty=format:'%H|%ad|%s' --date=iso-strict)"
  count="$(git -C "$path" rev-list --count HEAD)"
  {
    echo "$name"
    echo "  commits : $count"
    echo "  first   : $first"
    echo "  last    : $last"
    echo
  } >> "$DATA/all-repositories.txt"
done

# ---------------------------------------------------------- summary
WEB_FIRST="$(git -C "$WEB" log --reverse --pretty=format:'%ad' --date=short | sed -n '1p')"
WEB_LAST="$(git -C "$WEB" log -1 --pretty=format:'%ad' --date=short)"
WEB_COUNT="$(git -C "$WEB" rev-list --count HEAD)"

{
  echo "marryflow (web) commit range : $WEB_FIRST .. $WEB_LAST"
  echo "marryflow (web) commit count : $WEB_COUNT"
  echo "generated at                 : $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "generated on host            : $(uname -s)"
  echo "git version                  : $(git --version)"
  echo
  echo "Repositories created after 2026-03-17 establish continuity of"
  echo "development only. They are not offered as evidence of prior use."
} > "$DATA/summary.txt"

# ---------------------------------------------------------- integrity
# Full snapshot stays PRIVATE. Only its checksum is published.
git -C "$WEB" bundle create "$PRIV/marryflow-web.bundle" --all >/dev/null 2>&1
shasum -a 256 "$PRIV/marryflow-web.bundle" \
  | awk -v f="marryflow-web.bundle" '{print $1"  "f"  (git bundle --all, not published)"}' \
  > "$DATA/bundle-sha256.txt"

# Checksums of every published data file
( cd "$DATA" && shasum -a 256 *.txt > ../verify.txt )

# ---------------------------------------------------------- guard rails
if [ ! -s "$DATA/commits-marryflow-web.txt" ]; then
  echo "ERROR: commits file is empty" >&2; exit 1
fi

if [[ "$WEB_FIRST" > "$CUTOFF" ]]; then
  echo "WARNING: first commit ($WEB_FIRST) is NOT before $CUTOFF." >&2
  echo "         The prior-use claim in the letter does not hold." >&2
fi

stray="$(find "$ROOT" -name '*.bundle' -not -path "$PRIV/*" | sed -n '1p')"
if [ -n "$stray" ]; then
  echo "ERROR: a .bundle file would be published: $stray" >&2
  echo "       Move it to _private/ and re-run." >&2
  exit 1
fi

echo "OK"
echo "  web commits : $WEB_COUNT ($WEB_FIRST .. $WEB_LAST)"
echo "  output      : $DATA"
echo "  private     : $PRIV (never commit this directory)"
