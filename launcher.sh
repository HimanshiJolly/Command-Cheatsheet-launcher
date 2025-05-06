#!/bin/bash

# Source necessary scripts
source scripts/loader.sh
source scripts/search.sh
source scripts/favorites.sh
source scripts/recent.sh
source scripts/settings.sh
source scripts/help.sh
source scripts/display.sh

# Main loop for the program
while true; do
    OPTION=$(main_menu)  # Show the main menu
    case $OPTION in
        1) Search Command ;;          # Option 1: Search command
        2) View Favorites ;;          # Option 2: View favorite commands
        3) Recent Searches ;;         # Option 3: View recent searches
        4) Settings ;;           # Option 4: Settings
        5) Help ;;               # Option 5: Help/About
        6) exit 0 ;;                  # Option 6: Exit
        *) echo "Invalid option!" ;;  # Invalid selection
    esac
done
