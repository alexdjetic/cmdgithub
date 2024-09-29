#!/bin/bash

echo "Commit count by author:"
git shortlog -sn --all

echo -e "\nTotal commits:"
git rev-list --all --count

echo -e "\nCommits by day of week:"
git log --all --format='%aD' | awk '{print $1}' | sort | uniq -c | sort -rn
