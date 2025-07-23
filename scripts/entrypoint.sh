#!/bin/bash
set -e

REPO="${GITHUB_REPOSITORY}"
REF_NAME="${GITHUB_REF_NAME}"

echo "📦 Fetching PR title from branch: $REF_NAME"

PR_JSON=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/${REPO}/pulls")

PR_TITLE=$(echo "$PR_JSON" | jq -r ".[] | select(.head.ref == \"$REF_NAME\") | .title" | head -n 1)

echo "✅ PR Title: $PR_TITLE"

# Use provided pattern to extract issue key
ISSUE_KEY=$(echo "$PR_TITLE" | grep -oE "$ISSUE_KEY_PATTERN")

if [[ -z "$ISSUE_KEY" ]]; then
  echo "❗ No issue key found matching pattern '$ISSUE_KEY_PATTERN'."
  exit 0
fi

echo "🔑 Found issue key: $ISSUE_KEY"

# Get current Jira issue status
STATUS=$(curl -s -u "$JIRA_USER_EMAIL:$JIRA_API_TOKEN" \
  -H "Accept: application/json" \
  "$JIRA_BASE_URL/rest/api/3/issue/$ISSUE_KEY" | jq -r '.fields.status.name')

echo "ℹ️ Current status of $ISSUE_KEY: $STATUS"

# Perform the transition
echo "🔄 Transitioning $ISSUE_KEY using transition ID: $TRANSITION_ID"

curl -s -u "$JIRA_USER_EMAIL:$JIRA_API_TOKEN" \
  -X POST \
  -H "Content-Type: application/json" \
  --data "{\"transition\":{\"id\":\"$TRANSITION_ID\"}}" \
  "$JIRA_BASE_URL/rest/api/3/issue/$ISSUE_KEY/transitions"

echo "✅ Transition complete for $ISSUE_KEY"
