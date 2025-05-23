#!/bin/bash

main_menu() {
    dialog --clear \
           --backtitle "🔥 Linux Command Cheatsheet Launcher 🔥" \
           --title "Main Menu 🚀" \
           --stdout --menu "Please select to continue:" 20 60 10 \
           1 "🔍 Search command" \
           2 "⭐ View favourites" \
           3 "🕒 Recent searches" \
           4 "⚙️  Settings" \
           5 "❓ Help/About" \
           6 "🚪 Exit"
}

