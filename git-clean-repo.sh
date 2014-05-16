#!/bin/bash

#Credit goes to:
#http://stevelorek.com/how-to-shrink-a-git-repository.html
#Author: Steve Lorek
#Desciption: Ruby and Rails Developer from Southampton, UK—Senior Developer at LoveThis.

#Cleaning the file will take a while, depending on
#how busy your repository has been. You just need
# one command to begin the process:

git filter-branch --tag-name-filter cat --index-filter 'git rm -r --cached --ignore-unmatch filename' --prune-empty -f -- --all 

#This command is adapted from other sources—the
#principle addition is --tag-name-filter cat which ensures tags are rewritten as well.

#After this command has finished executing,
#your repository should now be cleaned, with all branches and tags in tact.

#Reclaim space

#While we may have rewritten the history of the repository,
#those files still exist in there, stealing disk space and generally making a nuisance of themselves. Let's nuke the bastards:

rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now
git gc --aggressive --prune=now

#Now we have a fresh, clean repository. In my case,
#it went from 180MB to 7MB.

#Push the cleaned repository

#Now we need to push the changes back to the remote
#repository, so that nobody else will suffer the pain of a 180MB download.

git push origin --force --all

#The --all argument pushes all your branches as well.
#That's why we needed to clone them at the start of the process.

#Then push the newly-rewritten tags:

git push origin --force --tags

