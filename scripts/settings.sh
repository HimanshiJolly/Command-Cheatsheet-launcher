#!/bin/bash

# Function to clear favorites
clear_favourites() {
FAV_FILE="cheatsheets/favourites.txt"
    if [ ! -f "$FAV_FILE" ] || [ ! -s "$FAV_FILE" ]; then
        dialog --msgbox "No favorite commands found." 10 40
        return
    fi
    dialog --yesno "Are you sure you want to clear all favorites?" 7 50
                if [ $? -eq 0 ]; then
                    > "$FAV_FILE"
                    dialog --msgbox "All favorites cleared." 10 40
                fi
}

# Function to clear recent searches
clear_recent_searches() {
local log_file="cheatsheets/search_log.txt"
    if [[ ! -f "$log_file" ]]; then
        echo "Search log file not found: $log_file"
        return 1
    fi
   
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
}

# Function to reset all preferences
delete_command_favourites() {
    FAV_FILE="cheatsheets/favourites.txt"

    if [ ! -f "$FAV_FILE" ] || [ ! -s "$FAV_FILE" ]; then
        dialog --msgbox "No favorite commands found." 10 40
        return
    fi

    mapfile -t commands < "$FAV_FILE"
    if [ ${#commands[@]} -eq 0 ]; then
        dialog --msgbox "No commands to remove." 10 40
        return
    fi

    menu_items=()
    for i in "${!commands[@]}"; do
        idx=$((i + 1))
        menu_items+=("$idx" "${commands[i]}")
    done

    choice=$(dialog --menu "Select a command to remove:" 20 70 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
    if [ $? -eq 0 ]; then
        unset 'commands[choice-1]'

        # Write back remaining non-empty commands
        for cmd in "${commands[@]}"; do
            [[ -n "$cmd" ]] && echo "$cmd"
        done > "$FAV_FILE"

        dialog --msgbox "Command removed from favorites." 10 40
    fi
}


# Main settings menu function
settings() {
    while true; do
        CHOICE=$(dialog --clear --stdout --title "⚙️ Settings" \
            --menu "Manage your preferences:" 15 50 4 \
            1 "Clear Search History" \
            2 "Delete a command from favourites" \
            3 "Clear all favourites" \
            4 "Return to main menu")

        case $CHOICE in
            1) clear_recent_searches ;;
            2) delete_command_favourites ;;
            3) clear_favourites ;;
            4) break ;;
            *) break ;;
        esac
    done
}

