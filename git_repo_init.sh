#!/bin/bash
# Author: DJetic Alexandre
# Date: 23/08/2024
# Modified: Current Date

set -euo pipefail

GITHUB_USERNAME="alexdjetic"  # Replace with your GitHub username

function show_help() {
        echo "Usage: $0 <github_repo_name> [branch_name]"
        echo "Initializes a new Git repository and sets up remote with SSH."
        echo "  <github_repo_name>: The name of the repository on GitHub (required)"
        echo "  [branch_name]: The name of the main branch (optional, default: main)"
}

function detect_project_type() {
        if [[ -f "package.json" ]]; then
                echo "Node"
        elif [[ -f "requirements.txt" || -f "setup.py" || -d "venv" ]]; then
                echo "Python"
        elif [[ -f "pom.xml" || -f "build.gradle" ]]; then
                echo "Java"
        elif [[ -f "Gemfile" ]]; then
                echo "Ruby"
        elif [[ -f "composer.json" ]]; then
                echo "PHP"
        else
                echo "Generic"
        fi
}

function add_gitignore() {
        local project_type=$1
        local gitignore_url="https://raw.githubusercontent.com/github/gitignore/master/${project_type}.gitignore"

        if curl --output /dev/null --silent --head --fail "$gitignore_url"; then
                curl -o .gitignore "$gitignore_url"
                echo "Added .gitignore for $project_type"
        else
                echo "No specific .gitignore found for $project_type. Using generic gitignore."
                echo ".DS_Store
Thumbs.db
*.log
*.tmp
*.swp
.vscode/
.idea/" > .gitignore
        fi
}

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
        show_help
        exit 1
fi

REPO="$1"
BRANCH="${2:-main}"  # Use the second argument if provided, otherwise default to "main"

# Initialize Git repository
git init

# Set the default branch name
git config --local init.defaultBranch "$BRANCH"

# Rename the current branch to the specified branch name
git branch -M "$BRANCH"

# Detect project type and add appropriate .gitignore
PROJECT_TYPE=$(detect_project_type)
add_gitignore "$PROJECT_TYPE"

# Add the remote origin using SSH
git remote add origin "git@github.com:${GITHUB_USERNAME}/${REPO}.git"

# Attempt to pull from the remote repository
if ! git pull origin "$BRANCH" --allow-unrelated-histories; then
        echo "Remote repository is empty or doesn't exist. Creating initial commit."
        # Create a README file if it doesn't exist
        [ -f README.md ] || echo "# ${REPO}" > README.md
        git add README.md .gitignore
        git commit -m "Initial commit with README and .gitignore"
fi

# Set the upstream branch to track the remote branch
git branch --set-upstream-to=origin/"$BRANCH" "$BRANCH"

# Push to the remote repository
git push -u origin "$BRANCH"

echo "Git repository initialized and set up with remote origin via SSH."
echo "Project type detected: $PROJECT_TYPE"
echo ".gitignore file added based on project type."
echo "Branch: $BRANCH"

