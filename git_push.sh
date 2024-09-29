#!/bin/bash

show_help() {
    echo "Usage: git_push.sh [commit_message] [target_branch]"
    echo "Pushes changes to the specified branch or the current branch if not specified."
    echo "If no commit message is provided, you'll be prompted to enter one."
    echo "If no target branch is provided, it pushes to the current branch."
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    show_help
    exit 0
fi

# Check for unmerged files
if git diff --name-only --diff-filter=U | grep -q .; then
    echo "Error: You have unmerged files. Please resolve them first."
    git status
    exit 1
fi

# Update local repo
git pull --rebase

# Add all changes
git add .

# Commit changes
if [ $# -eq 0 ]; then
    echo "Enter commit message:"
    read commit_message
else
    commit_message="$1"
fi

git commit -m "$commit_message"

# Determine target branch
if [ -n "$2" ]; then
    target_branch="$2"
else
    target_branch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$target_branch" == "HEAD" ]; then
        echo "Error: You are in 'detached HEAD' state. Please create or switch to a branch before pushing."
        exit 1
    fi
fi

# Push changes
git push origin $target_branch

echo "Changes pushed successfully to branch: $target_branch"

