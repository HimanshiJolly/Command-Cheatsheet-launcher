#!/bin/bash

# Source necessary scripts
source scripts/loader.sh
source scripts/search.sh
source scripts/favorites.sh
source scripts/recent.sh
source scripts/settings.sh
source scripts/help.sh
source scripts/display.sh

# Welcome and ask for user's name
echo "Welcome to Command-Cheatsheet Launcher!"
read -p "Please enter your name: " USER_NAME

# Function to get time-based greeting
get_greeting() {
    HOUR=$(date +%H)
    if [ $HOUR -ge 5 ] && [ $HOUR -lt 12 ]; then
        echo "Good morning"
    elif [ $HOUR -ge 12 ] && [ $HOUR -lt 17 ]; then
        echo "Good afternoon"
    else
        echo "Good evening"
    fi
}

GREETING=$(get_greeting)
echo "$GREETING, $USER_NAME!"
echo "Please choose to continue:"
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
