#!/bin/bash

show_help() {
    echo "Usage: merge_to_main.sh [commit_message]"
    echo "Merges the current branch into main."
    echo "If no commit message is provided, a default one will be used."
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    show_help
    exit 0
fi

# Get current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Check if we're already on main
if [ "$current_branch" == "main" ]; then
    echo "You are already on the main branch. Nothing to merge."
    exit 0
fi

# Update local repo
git pull origin $current_branch

# Switch to main branch
git checkout main

# Update main branch
git pull origin main

# Merge the current branch into main
if [ $# -eq 0 ]; then
    commit_message="Merge branch '$current_branch' into main"
else
    commit_message="$1"
fi

git merge $current_branch -m "$commit_message"

# Push changes to remote
git push origin main

echo "Branch '$current_branch' has been merged into main and pushed to remote."

# Switch back to the original branch
git checkout $current_branch

echo "Switched back to branch '$current_branch'."
