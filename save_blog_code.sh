#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mSaving code on GitHub...\033[0m\n"

# Add changes to git.
git add .

# Commit changes.
msg="saving blog code $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master
