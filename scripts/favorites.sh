#!/bin/bash

# Function to view and manage favorite commands
View() {
    FAV_FILE="$(dirname "$0")/../cheatsheets/favourites.txt"
    if [ ! -f "$FAV_FILE" ] || [ ! -s "$FAV_FILE" ]; then
        dialog --msgbox "No favorite commands found." 10 40
        return
    fi

    while true; do
        dialog --title "Favorite Commands" --textbox "$FAV_FILE" 20 60

        action=$(dialog --menu "What would you like to do?" 15 50 3 \
            1 "Remove a command" \
            2 "Clear all favorites" \
            3 "Return to main menu" \
            3>&1 1>&2 2>&3)

        case $action in
            1)
                # Remove a command
                mapfile -t commands < "$FAV_FILE"
                if [ ${#commands[@]} -eq 0 ]; then
                    dialog --msgbox "No commands to remove." 10 40
                    continue
                fi

                menu_items=()
                for i in "${!commands[@]}"; do
                    idx=$((i+1))
                    menu_items+=("$idx" "${commands[i]}")
                done

                choice=$(dialog --menu "Select a command to remove:" 20 70 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
                if [ $? -eq 0 ]; then
                    unset 'commands[choice-1]'
                    # Write back remaining commands
                    printf "%s\n" "${commands[@]}" > "$FAV_FILE"
                    dialog --msgbox "Command removed from favorites." 10 40
                fi
                ;;
            2)
                # Clear all favorites
                dialog --yesno "Are you sure you want to clear all favorites?" 7 50
                if [ $? -eq 0 ]; then
                    > "$FAV_FILE"
                    dialog --msgbox "All favorites cleared." 10 40
                fi
                ;;
            3)
                break
                ;;
            *)
                dialog --msgbox "Invalid choice." 10 40
                ;;
        esac
    done
}

# Alias function name to match launcher.sh case statement
view_favorites() {
    View
}
