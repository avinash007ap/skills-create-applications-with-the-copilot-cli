#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $(basename "$0") -t "Title" -b body.md [-r reviewer1,reviewer2] [-c 2,3] [-B base]

Options:
  -t  PR title (required)
  -b  Path to file containing PR body (required)
  -r  Comma-separated reviewers to request (optional)
  -c  Comma-separated issue numbers to close (optional)
  -B  Base branch (default: main)

Example:
  gh-pr-create.sh -t "Add feature" -b ./pr-body.md -r alice,bob -c 2,3
EOF
  exit 1
}

TITLE=""
BODYFILE=""
REVIEWERS=""
CLOSES=""
BASE="main"

while getopts ":t:b:r:c:B:" opt; do
  case ${opt} in
    t ) TITLE="$OPTARG" ;;
    b ) BODYFILE="$OPTARG" ;;
    r ) REVIEWERS="$OPTARG" ;;
    c ) CLOSES="$OPTARG" ;;
    B ) BASE="$OPTARG" ;;
    * ) usage ;;
  esac
done

if [ -z "$TITLE" ] || [ -z "$BODYFILE" ]; then
  usage
fi

if [ ! -f "$BODYFILE" ]; then
  echo "Body file $BODYFILE not found" >&2
  exit 1
fi

# Append closes lines if provided
if [ -n "$CLOSES" ]; then
  IFS=',' read -r -a arr <<< "$CLOSES"
  for n in "${arr[@]}"; do
    echo "\nCloses #$n" >> "$BODYFILE"
  done
fi

# Create PR and capture number and url
PR_JSON=$(gh pr create --base "$BASE" --title "$TITLE" --body-file "$BODYFILE" --json number,url 2>/dev/null)
PR_NUMBER=$(echo "$PR_JSON" | jq -r '.number')
PR_URL=$(echo "$PR_JSON" | jq -r '.url')

if [ -z "$PR_NUMBER" ] || [ "$PR_NUMBER" = "null" ]; then
  echo "Failed to create PR" >&2
  echo "$PR_JSON"
  exit 1
fi

echo "PR created: $PR_URL (#$PR_NUMBER)"

# Add reviewers if provided and they exist
if [ -n "$REVIEWERS" ]; then
  IFS=',' read -r -a rarr <<< "$REVIEWERS"
  valid_reviewers=()
  for r in "${rarr[@]}"; do
    if gh api -X GET "/users/$r" >/dev/null 2>&1; then
      valid_reviewers+=("$r")
    else
      echo "Warning: reviewer '$r' not found; skipping"
    fi
  done
  if [ ${#valid_reviewers[@]} -gt 0 ]; then
    joined=$(IFS=','; echo "${valid_reviewers[*]}")
    gh pr edit "$PR_NUMBER" --add-reviewer "$joined"
    echo "Requested review from: $joined"
  fi
fi

# Output PR URL for calling scripts
echo "$PR_URL"
