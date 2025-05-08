#!/bin/bash

# Function to view recent searches
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

    echo "All recent searches:"
    cat "$log_file"
}

# Alias function name to match launcher.sh case statement
recent_searches() {
    Recent
}
