#!/bin/bash

# Customize the time range
START_DATE="2024-07-01"
END_DATE="2025-05-30"

# Number of days to randomly pick commits per week
DAYS_PER_WEEK=2-5

# File to touch and commit
TOUCH_FILE="contributions.txt"

# Initialize git repo if not already
git init
touch $TOUCH_FILE
git add $TOUCH_FILE

# Loop over each week
current_date=$START_DATE
while [[ "$current_date" < "$END_DATE" ]]; do
    # Get Monday of current week
    week_start=$(date -I -d "$current_date - $(date -d $current_date +%u) + 1 days")

    # Pick random days in the week (0=Sunday, 6=Saturday)
    picked_days=($(shuf -i 0-6 -n $DAYS_PER_WEEK))

    for day in "${picked_days[@]}"; do
        commit_date=$(date -I -d "$week_start + $day days")

        # Pick random number of commits (1–4)
        commits=$(( ( RANDOM % 4 ) + 1 ))

        for ((i=1; i<=commits; i++)); do
            echo "$commit_date - $i" >> $TOUCH_FILE
            git add $TOUCH_FILE
            GIT_AUTHOR_DATE="$commit_date 12:0$i:00" \
            GIT_COMMITTER_DATE="$commit_date 12:0$i:00" \
            git commit --quiet --allow-empty -m "Commit $i on $commit_date"
        done
    done

    # Go to next week
    current_date=$(date -I -d "$current_date + 7 days")
done

# Final push
git branch -M main
git remote add origin https://github.com/Aman-iiita063/random.git
git push -u origin main
