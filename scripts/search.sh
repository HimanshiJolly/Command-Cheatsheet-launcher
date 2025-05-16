#!/bin/bash
API_KEY="AIzaSyCMV-2YINJqg6b_u-e0h-gqD24zYolL-i8"
GEMINI_URL="https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHEATSHEET_DIR="$SCRIPT_DIR/../cheatsheets"
LOG_FILE="$CHEATSHEET_DIR/search_log.txt"
FAVOURITES_FILE="$CHEATSHEET_DIR/favourites.txt"  

mkdir -p "$CHEATSHEET_DIR"

search_command() {
while true; do
    cmd=$(dialog --inputbox "Enter the Linux command you want to search:" 10 50 3>&1 1>&2 2>&3 3>&-)

   if [ $? -ne 0 ]; then
    clear; echo "Cancelled."; return 1
fi
if [[ -z "$cmd" || "$cmd" =~ ^[[:space:]]*$ || ! "$cmd" =~ ^[a-zA-Z0-9\-]+$ ]]; then
            dialog --msgbox "Invalid input. Please enter a valid Linux command (no spaces or special characters like @ ? / ! #)." 10 60
        else
            break
        fi
    done
    echo "$(date): $cmd" >> "$LOG_FILE"
response_file=$(mktemp)
(
    payload=$(jq -n --arg txt "Explain the '$cmd' command in Linux. List all the commands with flags like (* $cmd -flag -> explanation) and explain them.Don't add any markdowns provide in the assigned format only with one *." \
      '{contents: [{parts: [{text: $txt}]}], generationConfig: {temperature: 0.2}}')

    curl -s -X POST "$GEMINI_URL" -H "Content-Type: application/json" -d "$payload" > "$response_file"
) &
api_pid=$!
{
  for i in $(seq 1 30); do
    echo $((i * 3 + 10))   
    sleep 1
    if ! kill -0 $api_pid 2>/dev/null; then break; fi  
  done
} | dialog --gauge "Fetching explanation from Gemini (~30s)..." 10 60 0

wait $api_pid
response=$(<"$response_file")
rm "$response_file"

    explanation=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text')

    echo "$explanation" > /tmp/cmd_details.txt
    dialog --textbox /tmp/cmd_details.txt 25 80

    commands=$(grep -i "^*" /tmp/cmd_details.txt | grep -i "$cmd" | sed -E 's/^\*\s*//; s/\s*->.*$//')

    if [ -z "$commands" ]; then
        dialog --msgbox "No commands found in the explanation." 10 50
        return
    fi
    menu_items=()
    i=1
    while IFS= read -r line; do
        menu_items+=("$i" "$line")
        ((i++))
    done <<< "$commands"
    while true; do
        action=$(dialog --menu "What would you like to do next?" 15 60 3 \
            1 "Copy a command to clipboard" \
            2 "Add command to favourites" \
            3 "Return to main menu" \
            3>&1 1>&2 2>&3)

        case $action in
            1)  choice=$(dialog --menu "Select a command to copy:" 20 80 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
                if [ $? -eq 0 ]; then
                    selected=$(echo "$commands" | sed -n "${choice}p")
                    echo -n "$selected" | xclip -selection clipboard
                    dialog --msgbox "Copied to clipboard:\n$selected" 8 60
                fi
                ;;
            2)  choice=$(dialog --menu "Select a command to add to favourites:" 20 80 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)
                if [ $? -eq 0 ]; then
                    selected=$(echo "$commands" | sed -n "${choice}p")
                    echo "$selected" >> "$FAVOURITES_FILE"
                    dialog --msgbox "Added to favourites:\n$selected" 8 60
                fi
                ;;
            3) clear; break ;;
            *)
                clear; echo "Invalid choice."; break ;;
        esac
    done
}
