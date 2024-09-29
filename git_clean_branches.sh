#!/bin/bash

git branch --merged | egrep -v "(^\*|main|dev)" | xargs git branch -d
echo "Merged branches cleaned up."
