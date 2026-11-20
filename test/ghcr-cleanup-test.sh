#!/bin/bash
# ghcr-cleanup-test.sh - Verify which GHCR versions the cleanup script would
# keep and delete, using fixture data (no network, no registry access).
#
# Usage: ./test/ghcr-cleanup-test.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

command -v jq >/dev/null 2>&1 || { echo "jq is required to run this test" >&2; exit 1; }

# shellcheck source=SCRIPTDIR/../.github/scripts/ghcr-cleanup.sh
source "$DOTFILES_DIR/.github/scripts/ghcr-cleanup.sh"
# The sourced script turns on errexit; checks below must keep going on failure.
set +e

NOW=1800000000            # 2027-01-15T08:00:00Z
RETENTION_DAYS=7
OLD="2027-01-01T00:00:00Z"
RECENT="2027-01-14T00:00:00Z"

# id | digest | updated_at | tags (comma-separated, empty = untagged)
FIXTURE_ROWS=(
    "1|sha256:release|$OLD|ci-100,2027.01.0,2027.01,latest"
    "2|sha256:release-amd64|$OLD|"
    "3|sha256:release-arm64|$OLD|"
    "4|sha256:stale-pr|$OLD|ci-200"
    "5|sha256:stale-pr-amd64|$OLD|"
    "6|sha256:stale-dev|$OLD|dev-ci-300"
    "7|sha256:recent-pr|$RECENT|ci-400"
    "8|sha256:recent-pr-amd64|$OLD|"
    "9|sha256:recent-orphan|$RECENT|"
    "10|sha256:lookalike|$OLD|ci-500-debug"
)

# What each kept tagged image's index references (normally read from the
# registry with `docker buildx imagetools inspect`).
REFERENCED='["sha256:release-amd64","sha256:release-arm64","sha256:recent-pr-amd64"]'

fixture_versions_json() {
    local row id digest updated tags
    for row in "${FIXTURE_ROWS[@]}"; do
        IFS='|' read -r id digest updated tags <<< "$row"
        jq -n --argjson id "$id" --arg name "$digest" --arg updated "$updated" --arg tags "$tags" \
            '{id: $id, name: $name, updated_at: $updated,
              metadata: {container: {tags: ($tags | split(",") | map(select(length > 0)))}}}'
    done | jq -s .
}

PASSED=0
FAILED=0

check() {
    local desc="$1" expected="$2" actual="$3"
    if [[ "$actual" == "$expected" ]]; then
        echo "[PASS] $desc"
        ((PASSED++))
    else
        echo "[FAIL] $desc"
        echo "       expected: $expected"
        echo "       actual:   $actual"
        ((FAILED++))
    fi
}

VERSIONS="$(fixture_versions_json)"

deleted_ids="$(plan_deletions "$NOW" "$RETENTION_DAYS" "$REFERENCED" <<< "$VERSIONS" | cut -f1 | sort -n | tr '\n' ' ')"
kept_digests="$(kept_tagged_digests "$NOW" "$RETENTION_DAYS" <<< "$VERSIONS" | sort | tr '\n' ' ')"

is_deleted() { [[ " $deleted_ids " == *" $1 "* ]] && echo deleted || echo kept; }

# Table: version id | expected outcome | why
CASES=(
    "1|kept|release sharing a digest with its ci- tag"
    "2|kept|platform manifest referenced by the release"
    "3|kept|platform manifest referenced by the release"
    "4|deleted|stale CI-only image"
    "5|deleted|untagged manifest of a deleted CI image"
    "6|deleted|stale dev-ci- image"
    "7|kept|CI image inside the retention window"
    "8|kept|old manifest still referenced by a recent CI image"
    "9|kept|untagged orphan inside the retention window"
    "10|kept|tag that only looks like a CI tag"
)

for case_row in "${CASES[@]}"; do
    IFS='|' read -r id expected why <<< "$case_row"
    check "version $id: $why -> $expected" "$expected" "$(is_deleted "$id")"
done

check "kept tagged digests are the ones whose indexes get inspected" \
    "sha256:lookalike sha256:recent-pr sha256:release " "$kept_digests"

echo ""
echo "Passed: $PASSED  Failed: $FAILED"
(( FAILED == 0 ))
