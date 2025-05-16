#!/bin/bash
View() {
    FAV_FILE="cheatsheets/favourites.txt"

    if [ ! -f "$FAV_FILE" ] || [ ! -s "$FAV_FILE" ]; then
        dialog --msgbox "No favorite commands found." 10 40
        return
    fi

    dialog --title "Favorite Commands" --textbox "$FAV_FILE" 20 60
}
view_favorites() {
    View
}

