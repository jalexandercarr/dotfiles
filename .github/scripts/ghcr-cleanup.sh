#!/bin/bash
# ghcr-cleanup.sh - Prune stale CI image versions from GHCR.
#
# Usage: ghcr-cleanup.sh <package>...
#   e.g. ghcr-cleanup.sh dotfiles dotfiles/ubuntu-dotfiles dotfiles/amazon-dotfiles
#
# Environment:
#   OWNER           GHCR namespace (user or org) that owns the packages (required)
#   RETENTION_DAYS  Only versions older than this are deleted (default: 7)
#   DRY_RUN         "true" prints the plan without deleting anything (default: true)
#   GH_TOKEN        Token for `gh api`; needs read:packages and delete:packages
#
# Requires gh, jq, and `docker buildx` logged in to ghcr.io.
#
# What gets deleted (only when older than RETENTION_DAYS):
#   - Versions whose tags are ALL CI tags (ci-<run_id> / dev-ci-<run_id>).
#     Release and :latest images are promoted from a ci-<run_id> image with
#     `imagetools create`, so they share its digest — a version that also
#     carries any non-CI tag is a release and is always kept.
#   - Untagged versions (per-platform and attestation manifests of
#     multi-arch images) that no kept tagged version references. The
#     references are read from each kept image's index, so deleting an
#     untagged version never breaks a live multi-arch image.

set -euo pipefail

readonly CI_TAG_PATTERN='^(dev-)?ci-[0-9]+$'
readonly SECONDS_PER_DAY=86400

# Tagged versions to keep: anything with a tag that isn't a stale CI-only
# version. Reads the versions JSON array on stdin, prints one digest per line.
kept_tagged_digests() {
    local now="$1" retention_days="$2"
    jq -r --argjson now "$now" --argjson days "$retention_days" --arg ci "$CI_TAG_PATTERN" '
        def tags: .metadata.container.tags // [];
        def stale: (.updated_at | fromdateiso8601) < ($now - $days * '"$SECONDS_PER_DAY"');
        def ci_only: (tags | length > 0) and all(tags[]; test($ci));
        .[] | select((tags | length > 0) and ((ci_only and stale) | not)) | .name
    '
}

# Versions to delete. Reads the versions JSON array on stdin; $3 is a JSON
# array of digests referenced by kept images. Prints "id<TAB>digest<TAB>tags".
plan_deletions() {
    local now="$1" retention_days="$2" referenced_json="$3"
    jq -r --argjson now "$now" --argjson days "$retention_days" --arg ci "$CI_TAG_PATTERN" \
        --argjson referenced "$referenced_json" '
        def tags: .metadata.container.tags // [];
        def stale: (.updated_at | fromdateiso8601) < ($now - $days * '"$SECONDS_PER_DAY"');
        def ci_only: (tags | length > 0) and all(tags[]; test($ci));
        def untagged_orphan: (tags | length == 0) and (.name | IN($referenced[]) | not);
        .[] | select(stale and (ci_only or untagged_orphan))
            | "\(.id)\t\(.name)\t\(tags | join(","))"
    '
}

# REST base path for the owner's packages: /users/<owner> or /orgs/<owner>.
owner_api_base() {
    local owner="$1" owner_type
    owner_type="$(gh api "users/${owner}" --jq .type)"
    if [[ "$owner_type" == "Organization" ]]; then
        echo "orgs/${owner}"
    else
        echo "users/${owner}"
    fi
}

# Digests (platform + attestation manifests) listed in an image index.
index_child_digests() {
    local image_ref="$1"
    docker buildx imagetools inspect --raw "$image_ref" | jq -r '.manifests[]?.digest'
}

cleanup_package() {
    local owner="$1" api_base="$2" package="$3" now="$4"
    local encoded_package="${package//\//%2F}"
    local versions_url="${api_base}/packages/container/${encoded_package}/versions"
    local image="ghcr.io/${owner,,}/${package}"

    echo "==> ${package}"

    local versions
    versions="$(gh api --paginate "$versions_url" --jq '.[]' | jq -s .)"

    local referenced=()
    local digest
    while IFS= read -r digest; do
        [[ -n "$digest" ]] || continue
        # Fail the whole package rather than guess: an unreadable index means
        # we can't tell which untagged manifests it still needs.
        local children
        if ! children="$(index_child_digests "${image}@${digest}")"; then
            echo "Could not inspect ${image}@${digest}; skipping ${package}" >&2
            return 1
        fi
        while IFS= read -r child; do
            [[ -n "$child" ]] && referenced+=("$child")
        done <<< "$children"
    done < <(kept_tagged_digests "$now" "$RETENTION_DAYS" <<< "$versions")

    local referenced_json
    referenced_json="$(printf '%s\n' "${referenced[@]+"${referenced[@]}"}" | jq -R . | jq -sc 'map(select(length > 0))')"

    local id name tags deleted=0
    while IFS=$'\t' read -r id name tags; do
        [[ -n "$id" ]] || continue
        if [[ "$DRY_RUN" == "true" ]]; then
            echo "  would delete ${id} ${name} [${tags:-untagged}]"
        else
            gh api -X DELETE "${versions_url}/${id}" --silent
            echo "  deleted ${id} ${name} [${tags:-untagged}]"
        fi
        deleted=$((deleted + 1))
    done < <(plan_deletions "$now" "$RETENTION_DAYS" "$referenced_json" <<< "$versions")

    echo "  ${deleted} version(s) $([[ "$DRY_RUN" == "true" ]] && echo "to delete" || echo "deleted")"
}

main() {
    if (( $# == 0 )); then
        echo "usage: $0 <package>..." >&2
        exit 64
    fi
    : "${OWNER:?OWNER must be set}"
    RETENTION_DAYS="${RETENTION_DAYS:-7}"
    DRY_RUN="${DRY_RUN:-true}"

    local api_base now failed=0
    api_base="$(owner_api_base "$OWNER")"
    now="$(date +%s)"

    echo "Retention: ${RETENTION_DAYS} days, dry run: ${DRY_RUN}"
    local package
    for package in "$@"; do
        cleanup_package "$OWNER" "$api_base" "$package" "$now" || failed=1
    done
    exit "$failed"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
