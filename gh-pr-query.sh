#!/bin/bash

# GitHub PR query for merged pull requests between Jan 1, 2025 and Aug 11, 2025
# Multiple repositories support

# Define repositories to query with their hosts
# Format: "host:owner/repo" or just "owner/repo" for default GitHub
REPOS=(
  "git.corp.adobe.com:AdobeDocs/commerce.en"
  "github.com:AdobeDocs/commerce-extensibility"
  "github.com:AdobeDocs/commerce-services"
  "github.com:AdobeDocs/commerce-webapi"
  "github.com:commerce-docs/microsite-commerce-storefront"
  # Add more repositories as needed
)

echo "Fetching merged pull requests for multiple repositories..."
echo "Date range: January 1, 2025 to August 11, 2025"
echo "================================================"

# Create output filename with timestamp
OUTPUT_FILE="merged_prs_$(date +%Y%m%d_%H%M%S).csv"

# Create CSV header
echo "Repository,PR Number,Title,Author,Merged At,Merge Commit,URL" > "$OUTPUT_FILE"

# Loop through each repository
for repo in "${REPOS[@]}"; do
  echo "Processing repository: $repo"
  
  # Extract host and repo from the format "host:owner/repo"
  if [[ "$repo" == *":"* ]]; then
    HOST=$(echo "$repo" | cut -d: -f1)
    REPO_NAME=$(echo "$repo" | cut -d: -f2-)
    
    # Set the host for this command
    export GH_HOST="$HOST"
    
    # Check if we can access this repository
    if gh repo view "$REPO_NAME" --json name >/dev/null 2>&1; then
      gh pr list \
        --repo "$REPO_NAME" \
        --state merged \
        --search "merged:2025-01-01..2025-08-11" \
        --limit 100 \
        --json number,title,author,mergedAt,mergeCommit,url | \
        jq -r --arg repo "$repo" '.[] | [$repo, .number, .title, .author.login, .mergedAt, .mergeCommit.oid, .url] | @csv' >> "$OUTPUT_FILE"
    else
      echo "ERROR: Cannot access repository $repo. Please check authentication for $HOST"
      echo "Try running: gh auth login --host $HOST"
    fi
    
    # Reset to default host
    unset GH_HOST
  else
    # Default to github.com if no host specified
    gh pr list \
      --repo "$repo" \
      --state merged \
      --search "merged:2025-01-01..2025-08-11" \
      --limit 100 \
      --json number,title,author,mergedAt,mergeCommit,url | \
      jq -r --arg repo "$repo" '.[] | [$repo, .number, .title, .author.login, .mergedAt, .mergeCommit.oid, .url] | @csv' >> "$OUTPUT_FILE"
  fi
done

echo ""
echo "Query completed. Results saved to: $OUTPUT_FILE"
echo "Total records: $(($(wc -l < "$OUTPUT_FILE") - 1))"  # Subtract 1 for header
