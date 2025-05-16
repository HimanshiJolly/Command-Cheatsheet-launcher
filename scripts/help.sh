#!/bin/bash

# help function called from launcher.sh
help() {
    dialog --title "📘 Help & Usage" --msgbox \
"🔹 Command-Cheatsheet Launcher  
🔹 Version: 1.0.0  

🧩 What You Can Do:
1️⃣ Search useful Linux commands.
2️⃣ Save frequently used commands to Favorites.
3️⃣ View your recent searches anytime.
4️⃣ Customize settings and clear preferences.
5️⃣ Open this Help section for guidance.

📌 Designed to boost your productivity in the terminal." \
    20 60

    dialog --title "📦 About This Tool" --msgbox \
"🛠️ Command-Cheatsheet Launcher is a lightweight terminal-based tool for Linux users.

👩‍💻 Created with ❤️ for the open-source community." 14 60
}

