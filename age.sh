#!/bin/bash
# age.sh - Calculate age from a birth date (YYYY-MM-DD)

if [ -z "$1" ]; then
    echo "Usage: $0 YYYY-MM-DD"
    exit 1
fi

BIRTH="$1"

# Validate the date format and that it's a real date
if ! date -d "$BIRTH" "+%Y-%m-%d" >/dev/null 2>&1; then
    echo "Error: '$BIRTH' is not a valid date. Use YYYY-MM-DD."
    exit 1
fi

# Normalize (handles things like 2000-1-5)
BIRTH=$(date -d "$BIRTH" "+%Y-%m-%d")
TODAY=$(date "+%Y-%m-%d")

# Can't be born in the future
if [[ "$BIRTH" > "$TODAY" ]]; then
    echo "Error: birth date is in the future."
    exit 1
fi

# Convert both to seconds since epoch
birth_s=$(date -d "$BIRTH" +%s)
today_s=$(date -d "$TODAY" +%s)

# Total days alive
total_days=$(( (today_s - birth_s) / 86400 ))

# Break into years, months, days
by=$(date -d "$BIRTH" +%Y); bm=$(date -d "$BIRTH" +%m); bd=$(date -d "$BIRTH" +%d)
ty=$(date -d "$TODAY" +%Y); tm=$(date -d "$TODAY" +%m); td=$(date -d "$TODAY" +%d)

years=$(( ty - by ))
months=$(( tm - bm ))
days=$(( td - bd ))

if [ $days -lt 0 ]; then
    months=$(( months - 1 ))
    # days in the previous month of today
    prev_month=$(date -d "$TODAY -1 month" "+%Y-%m")
    days_in_prev=$(date -d "$prev_month-01 +1 month -1 day" "+%d")
    days=$(( days + days_in_prev ))
fi

if [ $months -lt 0 ]; then
    years=$(( years - 1 ))
    months=$(( months + 12 ))
fi

echo "Birth date : $BIRTH"
echo "Today      : $TODAY"
echo "Age        : $years years, $months months, $days days"
echo "Total days : $total_days"
