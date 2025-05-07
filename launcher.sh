#!/bin/bash

# Source necessary scripts
source scripts/loader.sh
source scripts/search.sh
source scripts/favorites.sh
source scripts/recent.sh
source scripts/settings.sh
source scripts/help.sh
source scripts/display.sh

# Ask for user's name using dialog
USER_NAME=$(dialog --clear --stdout --inputbox "👋 Welcome to Command-Cheatsheet Launcher!\n\nPlease enter your name:" 10 50)

# If user presses Esc or enters nothing
if [ -z "$USER_NAME" ]; then
    USER_NAME="User"
fi

# Function to get time-based greeting
get_greeting() {
    HOUR=$(date +%H)
    if [ "$HOUR" -ge 5 ] && [ "$HOUR" -lt 12 ]; then
        echo "Good morning"
    elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 17 ]; then
        echo "Good afternoon"
    else
        echo "Good evening"
    fi
}

# Show greeting using dialog
GREETING=$(get_greeting)
dialog --title "Greetings 🙏" --msgbox "$GREETING, $USER_NAME! 👩‍💻\n\nLet's get started!" 8 50

# Main loop
while true; do
    OPTION=$(main_menu "$USER_NAME")  # Now passing name to menu

    case $OPTION in
        1) Search Command ;;
        2) View Favorites ;;
        3) Recent Searches ;;
        4) Settings ;;
        5) Help ;;
        6) 
            dialog --msgbox "Goodbye, $USER_NAME! 👋 Have a great day!" 6 40
            clear
            exit 0 
            ;;
    esac
done

