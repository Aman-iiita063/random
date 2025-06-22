#!/bin/bash

START_DATE="2024-07-01"
END_DATE="2024-12-30"
TOUCH_FILE="contributions.txt"

git init
touch $TOUCH_FILE
git add $TOUCH_FILE

current_date="$START_DATE"

while [[ "$current_date" < "$END_DATE" ]]; do
  # Pick 2–5 random days in the week
  day_count=$((RANDOM % 4 + 2)) # 2 to 5
  days=($(shuf -i 0-6 -n $day_count))

  for day in "${days[@]}"; do
    commit_date=$(date -d "$current_date +$day days" +"%Y-%m-%d")
    commits=$((RANDOM % 4 + 1)) # 1–4 commits

    for ((i = 1; i <= commits; i++)); do
      echo "$commit_date - $i" >>$TOUCH_FILE
      git add $TOUCH_FILE
      GIT_AUTHOR_DATE="$commit_date 12:0$i:00" \
      GIT_COMMITTER_DATE="$commit_date 12:0$i:00" \
      git commit --quiet --allow-empty -m "Commit $i on $commit_date"
    done
  done

  # Go to next week
  current_date=$(date -d "$current_date +7 days" +"%Y-%m-%d")
done

# Push to GitHub
git branch -M main
# remote already exists, so don't add again
git pull origin main --rebase
git push origin main
