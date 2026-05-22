#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") branch_name "Commit message" body.md [reviewers] [issues] [--auto-merge]

Arguments:
  branch_name    name of feature branch to create (e.g., feature/add-modulo)
  commit_msg     commit message for changes
  body.md        path to PR body file
  reviewers      comma-separated reviewers (optional)
  issues         comma-separated issue numbers to close (optional)
  --auto-merge   enable auto-merge after checks (optional)

Example:
  run-feature-pipeline.sh feature/add-mod -m "feat: add mod" ./pr-body.md alice,bob 2,3 --auto-merge
EOF
  exit 1
}

if [ "$#" -lt 3 ]; then
  usage
fi

BRANCH="$1"
shift
COMMIT_MSG="$1"
shift
BODYFILE="$1"
shift
REVIEWERS="${1-}"
ISSUES="${2-}"
AUTO_MERGE=false

for arg in "$@"; do
  if [ "$arg" = "--auto-merge" ]; then
    AUTO_MERGE=true
  fi
done

# create branch
git checkout -b "$BRANCH"

# run tests if available
if [ -f package.json ] && jq -e '.scripts.test' package.json >/dev/null 2>&1; then
  echo "Running npm test..."
  npm test
else
  echo "No test script found; skipping tests"
fi

# commit and push
git add .
if git diff --cached --quiet; then
  echo "No staged changes to commit"
else
  git commit -m "$COMMIT_MSG"
  git push --set-upstream origin "$BRANCH"
fi

# create PR using helper
if [ -n "$ISSUES" ]; then
  scripts/gh-pr-create.sh -t "$COMMIT_MSG" -b "$BODYFILE" -r "$REVIEWERS" -c "$ISSUES"
else
  scripts/gh-pr-create.sh -t "$COMMIT_MSG" -b "$BODYFILE" -r "$REVIEWERS"
fi

# Optionally enable auto-merge
if [ "$AUTO_MERGE" = true ]; then
  PR_JSON=$(gh pr list --head "$BRANCH" --state open --json number,url --jq '.[0]')
  PR_NUMBER=$(echo "$PR_JSON" | jq -r '.number')
  if [ -n "$PR_NUMBER" ] && [ "$PR_NUMBER" != "null" ]; then
    gh pr merge "$PR_NUMBER" --auto
    echo "Enabled auto-merge for PR #$PR_NUMBER"
  fi
fi
