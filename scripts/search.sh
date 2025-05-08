#!/bin/bash

# === CONFIG ===
API_KEY="AIzaSyCMV-2YINJqg6b_u-e0h-gqD24zYolL-i8"
GEMINI_URL="https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHEATSHEET_DIR="$SCRIPT_DIR/../cheatsheets"
LOG_FILE="$CHEATSHEET_DIR/search_log.txt"
FAVOURITES_FILE="$CHEATSHEET_DIR/favourites.txt"  # Favourites file

mkdir -p "$CHEATSHEET_DIR"

search_command() {
    cmd=$(dialog --inputbox "Enter the Linux command you want to search:" 10 50 3>&1 1>&2 2>&3 3>&-)

    if [ $? -ne 0 ]; then
        clear; echo "Cancelled."; exit 1
    fi

    # Log the actual Linux command entered (do not log invalid actions or menu options)
    echo "$(date): $cmd" >> "$LOG_FILE"

    # === QUERY GEMINI ===
    payload=$(jq -n --arg txt "Explain the '$cmd' command in Linux with all flags and examples in bullet points." \
        '{contents: [{parts: [{text: $txt}]}]}')

    response=$(curl -s -X POST "$GEMINI_URL" -H "Content-Type: application/json" -d "$payload")
    explanation=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text')

    echo "$explanation" > /tmp/cmd_details.txt
    dialog --textbox /tmp/cmd_details.txt 25 80

    # === Extract commands for menu ===
    commands=$(grep -oP '`[^`]+`' /tmp/cmd_details.txt | tr -d '`')
    if [ -z "$commands" ]; then
        dialog --msgbox "No commands found in the explanation." 10 50
        return
    fi

    # Convert to menu format
    menu_items=()
    i=1
    while IFS= read -r line; do
        menu_items+=("$i" "$line")
        ((i++))
    done <<< "$commands"

    # === Post explanation menu ===
    while true; do
        action=$(dialog --menu "What would you like to do next?" 15 60 3 \
            1 "Copy a command to clipboard" \
            2 "Add command to favourites" \
            3 "Return to main menu" \
            3>&1 1>&2 2>&3)

        case $action in
            1)  # Copy
                # Ensure the menu displays available commands
                choice=$(dialog --menu "Select a command to copy:" 20 80 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
                if [ $? -eq 0 ]; then
                    selected=$(echo "$commands" | sed -n "${choice}p")
                    echo -n "$selected" | xclip -selection clipboard
                    dialog --msgbox "Copied to clipboard:\n$selected" 8 60
                fi
                ;;
            2)  # Add to favourites
                # Ensure the menu displays available commands
                choice=$(dialog --menu "Select a command to add to favourites:" 20 80 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
                if [ $? -eq 0 ]; then
                    selected=$(echo "$commands" | sed -n "${choice}p")
                    # Store in favourites.txt
                    echo "$selected" >> "$FAVOURITES_FILE"
                    dialog --msgbox "Added to favourites:\n$selected" 8 60
                fi
                ;;
            3)  # Return to main menu
                clear; break ;;
            *)
                clear; echo "Invalid choice."; break ;;
        esac
    done
}
