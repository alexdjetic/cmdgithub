#!/bin/bash

show_help() {
    echo "Usage: delete_branch.sh <branch_to_delete> [current_branch]"
    echo "Deletes the specified branch locally and remotely."
    echo "If current_branch is not specified, it switches to 'main' branch."
    echo "Note: You cannot delete the branch you're currently on."
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ $# -eq 0 ]; then
    show_help
    exit 0
fi

branch_to_delete="$1"
current_branch=${2:-"main"}

# Check if trying to delete the current branch
if [ "$branch_to_delete" == "$(git rev-parse --abbrev-ref HEAD)" ]; then
    echo "Switching to '$current_branch' branch before deletion..."
    git checkout "$current_branch"
fi

# Ensure we're on the current_branch
git checkout "$current_branch"

# Update the current branch
git pull origin "$current_branch"

# Delete the local branch
if git branch -D "$branch_to_delete"; then
    echo "Local branch '$branch_to_delete' deleted."
else
    echo "Failed to delete local branch '$branch_to_delete'. It may not exist locally."
fi

# Delete the remote branch
if git push origin --delete "$branch_to_delete"; then
    echo "Remote branch '$branch_to_delete' deleted."
else
    echo "Failed to delete remote branch '$branch_to_delete'. It may not exist remotely or you may not have permission."
fi

echo "Branch deletion process completed. You are now on the '$current_branch' branch."
