#!/system/bin/sh

if [ $# -lt 1 ]; then
    echo "Usage ./proc_of_group.sh <group id>"
    exit 1
fi

echo "PID    CMDLINE"
for p in /proc/*
do
    if [ ! -e "$p/status" ]; then
        continue
    fi

    groups_line=$(grep "Groups:" "$p/status")
    if [ -z "$groups_line" ]; then
        continue
    fi

    match_line=$(echo "$groups_line" | grep "$1")
    if [ -z "$match_line" ]; then
        continue
    fi

    echo "${p##*/} $(cat "$p/cmdline")"
    echo "    $match_line"
done
