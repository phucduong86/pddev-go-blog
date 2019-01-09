#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Remove current public folder
rm -rf public

# Add git submodule
git submodule add -b master git@github.com:phucduong86/phucduong86.github.io.git public

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public
# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..

# Clean up public folder
rm -rf public

# Commit changes to current repo.
msg="Committing changes to current repo `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git add .
git commit -m "$msg"
git push origin master