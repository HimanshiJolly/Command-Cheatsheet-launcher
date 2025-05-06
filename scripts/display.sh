#!/bin/bash

# Function to show the main menu
main_menu() {
    dialog --clear --stdout --menu "Command Cheatsheet Launcher" 20 50 8 \
        1 "Search command" \
        2 "View favorites" \
        3 "Recent searches" \
        4 "Settings" \
        5 "Help/About" \
        6 "Exit"
}
