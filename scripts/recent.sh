#!/bin/bash
Recent() {
    local log_file="cheatsheets/search_log.txt"

    if [[ ! -f "$log_file" || ! -s "$log_file" ]]; then
        if command -v dialog >/dev/null 2>&1; then
            dialog --msgbox "No recent searches found." 6 40
        else
            echo "No recent searches found."
        fi
        return 0
    fi

    local last_commands
    last_commands=$(tail -n 10 "$log_file")

    if command -v dialog >/dev/null 2>&1; then
        dialog --title "Last 10 Searches" --msgbox "$last_commands" 20 60
    else
        echo "Last 10 searches:"
        echo "$last_commands"
    fi
}

recent_searches() {
    Recent
}

