#!/bin/bash

# Function to view recent searches in a dialog
Recent() {
    local log_file="cheatsheets/search_log.txt"
    if [[ ! -f "$log_file" ]]; then
        echo "Search log file not found: $log_file"
        return 1
    fi

    if [[ ! -s "$log_file" ]]; then
        echo "No recent searches found."
        return 0
    fi

    local last_commands
    last_commands=$(tail -n 5 "$log_file")

    # Check if dialog is installed for dialog display
    if command -v dialog >/dev/null 2>&1; then
        echo "$last_commands" | dialog --title "Recent Searches" --msgbox "$(cat)" 20 60
    else
        echo "Dialog not found. Displaying recent searches in terminal:"
        echo "$last_commands"
    fi
}

# Alias function name to match launcher.sh case statement
recent_searches() {
    Recent
}
