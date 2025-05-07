#!/bin/bash

# === CONFIG ===
API_KEY="AIzaSyD5wv630b-CLBCZsMNIbvPwjsjM_x5J_CI"  # Replace with your Gemini API Key
GEMINI_URL="https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY"

Search_Command() {
    cmd=$(dialog --inputbox "Enter the Linux command you want to search:" 10 50 3>&1 1>&2 2>&3 3>&-)

# Cancel check
if [ $? -ne 0 ]; then
  clear; echo "Cancelled."; exit 1
fi

# === QUERY GEMINI ===
payload=$(jq -n --arg txt "Explain the '$cmd' command in Linux with all flags and examples in bullet points." \
    '{contents: [{parts: [{text: $txt}]}]}')

response=$(curl -s -X POST "$GEMINI_URL" -H "Content-Type: application/json" -d "$payload")

# === PARSE RESPONSE ===
explanation=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text')

# === SHOW DETAILS ===
echo "$explanation" > /tmp/cmd_details.txt
dialog --textbox /tmp/cmd_details.txt 25 80

# === GENERATE CHOICES ===
commands=$(grep -oP '`[^`]+`' /tmp/cmd_details.txt | tr -d '`')
menu_items=()
i=1
while IFS= read -r line; do
  menu_items+=("$i" "$line")
  ((i++))
done <<< "$commands"

# === SHOW MENU ===
choice=$(dialog --menu "Select a command to copy:" 20 80 10 "${menu_items[@]}" 3>&1 1>&2 2>&3)

# === COPY TO CLIPBOARD ===
if [ $? -eq 0 ]; then
  selected=$(echo "$commands" | sed -n "${choice}p")
  echo -n "$selected" | xclip -selection clipboard
  clear
  echo "Copied to clipboard: $selected"
else
  clear
  echo "No selection made."
fi

} 
