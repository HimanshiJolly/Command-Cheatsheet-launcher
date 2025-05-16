#!/bin/bash

# Function to clear favorites
clear_favorites() {
    > data/favorites.txt
    dialog --msgbox "✅ Favorites cleared successfully!" 6 40
}

# Function to clear recent searches
clear_recent_searches() {
    > data/recent.txt
    dialog --msgbox "✅ Recent searches cleared!" 6 40
}

# Function to reset all preferences
reset_preferences() {
    > data/favorites.txt
    > data/recent.txt
    dialog --msgbox "♻️ All preferences have been reset!" 6 45
}

# Main settings menu function
settings() {
    while true; do
        CHOICE=$(dialog --clear --stdout --title "⚙️ Settings" \
            --menu "Manage your preferences:" 15 50 4 \
            1 "Clear Favorites" \
            2 "Clear Recent Searches" \
            3 "Reset All Preferences" \
            4 "Back to Main Menu")

        case $CHOICE in
            1) clear_favorites ;;
            2) clear_recent_searches ;;
            3) reset_preferences ;;
            4) break ;;
            *) break ;;
        esac
    done
}

