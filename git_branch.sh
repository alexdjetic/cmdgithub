#!/bin/bash

show_help() {
    echo "Usage: git_branch.sh [branch_name]"
    echo "Without arguments: Lists all branches and shows the current branch."
    echo "With branch_name: Creates a new branch or switches to it if it exists,"
    echo "                  and sets up remote tracking."
}

# Update local repo
git pull

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    show_help
    exit 0
fi

if [ $# -eq 0 ]; then
    # List all branches
    echo "Current branches:"
    git branch -a

    # Show current branch
    echo "Current branch:"
    git rev-parse --abbrev-ref HEAD
else
    branch_name="$1"
    # Check if branch exists
    if git show-ref --verify --quiet refs/heads/$branch_name; then
        # Branch exists, switch to it
        git checkout $branch_name
    else
        # Branch doesn't exist, create and switch to it
        git checkout -b $branch_name
    fi
    
    # Set up remote tracking
    git push -u origin $branch_name

    echo "Now on branch: $(git rev-parse --abbrev-ref HEAD)"
    echo "Remote tracking has been set up. You can now use 'git push' without arguments."
fi
