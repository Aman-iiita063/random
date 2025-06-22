#!/bin/bash

# Time range
START_DATE="2024-07-01"
END_DATE="2025-05-30"
TOUCH_FILE="contributions.txt"

# Init
git init
touch $TOUCH_FILE
git add $TOUCH_FILE

# Loop through each week
current_date="$START_DATE"
while [[ "$current_date" < "$END_DATE" ]]; do
  for i in {1..3}; do  # 3 random days per week
    offset=$(( RANDOM % 7 ))
    commit_date=$(date -d "$current_date +$offset days" +%Y-%m-%d)

    commit_count=$(( (RANDOM % 4) + 1 ))  # 1–4 commits
    for ((j=1; j<=commit_count; j++)); do
      echo "$commit_date - $j" >> $TOUCH_FILE
      git add $TOUCH_FILE
      GIT_AUTHOR_DATE="$commit_date 12:0$j:00" \
      GIT_COMMITTER_DATE="$commit_date 12:0$j:00" \
      git commit --quiet --allow-empty -m "Commit $j on $commit_date"
    done
  done

  current_date=$(date -d "$current_date +7 days" +%Y-%m-%d)
done

# Push to GitHub
git branch -M main

# Add remote only if not exists
if ! git remote | grep -q origin; then
  git remote add origin https://github.com/Aman-iiita063/random.git
fi

# Force push to overwrite
git push -f origin main
