#!/bin/bash

show_help() {
    echo "Usage: revert_commit.sh [commit_hash] [branch_name]"
    echo "Reverts a commit on the current branch or a specified branch."
    echo "If no commit hash is provided, it reverts the last commit."
    echo "If no branch name is provided, it operates on the current branch."
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    show_help
    exit 0
fi

# Determine the commit to revert
if [ -z "$1" ]; then
    commit_to_revert="HEAD"
else
    commit_to_revert="$1"
fi

# Determine the branch
if [ -z "$2" ]; then
    branch=$(git rev-parse --abbrev-ref HEAD)
else
    branch="$2"
fi

# Store the current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Switch to the target branch if necessary
if [ "$branch" != "$current_branch" ]; then
    git checkout "$branch"
fi

# Update the branch
git pull origin "$branch"

# Revert the commit
git revert "$commit_to_revert" --no-edit

# Push the changes
git push origin "$branch"

echo "Commit $commit_to_revert has been reverted on branch $branch and pushed to remote."

# Switch back to the original branch if necessary
if [ "$branch" != "$current_branch" ]; then
    git checkout "$current_branch"
    echo "Switched back to branch $current_branch."
fi
