#!/bin/bash

# Source necessary scripts
source scripts/loader.sh
source scripts/search.sh
source scripts/favourites.sh
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
    OPTION=$(main_menu)  # Now passing name to menu

    if [ $? -ne 0 ]; then
    dialog --yesno "Do you want to exit, $USER_NAME?" 7 50
    [ $? -eq 0 ] && clear && exit 0
    continue
    fi


    case $OPTION in
        1) search_command ;;
        2) view_favorites ;;
        3) recent_searches ;;
        4) settings ;;
        5) help ;;
        6) 
            dialog --msgbox "Goodbye, $USER_NAME! 👋 Have a great day!" 6 40
            sleep 1
            clear
            exit 0 
            ;;
    esac
done

