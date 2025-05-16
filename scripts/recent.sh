#!/bin/bash

# Function to view recent searches in a dialog
Recent() {
    local log_file="cheatsheets/search_log.txt"
    if [[ ! -f "$log_file" ]]; then
        echo "Search log file not found: $log_file"
        return 1
    fi

    while true; do
        if command -v dialog >/dev/null 2>&1; then
            CHOICE=$(dialog --clear --title "Recent Searches" --menu "Choose an option:" 10 50 3 \
                1 "View last 10 searches" \
                2 "Clear search log" \
                3 "Exit" \
                3>&1 1>&2 2>&3)
            exit_status=$?
            if [ $exit_status -ne 0 ]; then
                clear
                return 0
            fi
        else
            echo "Dialog not found. Defaulting to view last 10 searches."
            CHOICE=1
        fi

        case $CHOICE in
            1)
                if [[ ! -s "$log_file" ]]; then
                    if command -v dialog >/dev/null 2>&1; then
                        dialog --msgbox "No recent searches found." 6 40
                    else
                        echo "No recent searches found."
                    fi
                else
                    local last_commands
                    last_commands=$(tail -n 10 "$log_file" | sed -E 's/^.*: //')
                    if command -v dialog >/dev/null 2>&1; then
                        echo "$last_commands" | dialog --title "Last 10 Searches" --msgbox "$(cat)" 20 60
                    else
                        echo "Last 10 searches:"
                        echo "$last_commands"
                    fi
                fi
                ;;
            2)
                if command -v dialog >/dev/null 2>&1; then
                    dialog --yesno "Are you sure you want to clear the search log?" 7 50
                    if [ $? -eq 0 ]; then
                        > "$log_file"
                        dialog --msgbox "Search log cleared." 6 40
                    fi
                else
                    read -p "Are you sure you want to clear the search log? (y/N): " confirm
                    if [[ "$confirm" =~ ^[Yy]$ ]]; then
                        > "$log_file"
                        echo "Search log cleared."
                    fi
                fi
                ;;
            3)
                clear
                return 0
                ;;
            *)
                ;;
        esac
    done
}

# Alias function name to match launcher.sh case statement
recent_searches() {
    Recent
}
